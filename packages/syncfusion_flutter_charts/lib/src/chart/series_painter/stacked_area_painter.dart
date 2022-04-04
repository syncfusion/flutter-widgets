import 'dart:math' as math_lib;

import 'package:flutter/material.dart';

import '../../../charts.dart';
import '../../common/rendering_details.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../axis/axis.dart';
import '../chart_segment/chart_segment.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';

/// Creates series renderer for stacked area series.
class StackedAreaSeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedAreaSeriesRenderer class.
  StackedAreaSeriesRenderer();

  /// Stacked area segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? _points]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final StackedAreaSegment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segment.currentSegmentIndex = 0;
      segmentProperties.seriesIndex = seriesIndex;
      if (_points != null) {
        segment.points = _points;
      }
      segment.animationFactor = animateFactor;
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              true &&
          seriesRendererDetails.xAxisDetails!.zoomFactor == 1 &&
          seriesRendererDetails.yAxisDetails!.zoomFactor == 1 &&
          // ignore: unnecessary_null_comparison
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= segmentProperties.seriesIndex &&
          SeriesHelper.getSeriesRendererDetails(
                      _oldSeriesRenderers[segmentProperties.seriesIndex])
                  .seriesName ==
              SeriesHelper.getSeriesRendererDetails(
                      segmentProperties.seriesRenderer)
                  .seriesName) {
        segmentProperties.oldSeriesRenderer =
            _oldSeriesRenderers[segmentProperties.seriesIndex];
        segmentProperties.oldSegmentIndex = 0;
      }
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render stacked area series segments.
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    if (seriesRendererDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          seriesRendererDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              seriesRendererDetails.segments[0], seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedAreaSegment createSegment() => StackedAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = seriesRendererDetails.seriesColor;
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
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Creates series renderer for Stacked area 100 series
class StackedArea100SeriesRenderer extends StackedSeriesRenderer {
  /// Calling the default constructor of StackedArea100SeriesRenderer class.
  StackedArea100SeriesRenderer();

  /// Stacked Area segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(
      int seriesIndex, SfCartesianChart chart, double animateFactor,
      [List<Offset>? _points]) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    // Clearing the old chart segments objects with a dispose call.
    disposeOldSegments(chart, seriesRendererDetails);
    final StackedArea100Segment segment = createSegment();
    final SegmentProperties segmentProperties =
        SegmentProperties(seriesRendererDetails.stateProperties, segment);
    SegmentHelper.setSegmentProperties(segment, segmentProperties);
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        seriesRendererDetails.stateProperties.oldSeriesRenderers;
    seriesRendererDetails.isRectSeries = false;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segmentProperties.seriesRenderer = this;
      segmentProperties.series =
          seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
      segment.currentSegmentIndex = 0;
      segmentProperties.seriesIndex = seriesIndex;
      if (_points != null) {
        segment.points = _points;
      }
      segment.animationFactor = animateFactor;
      if (seriesRendererDetails
                  .stateProperties.renderingDetails.widgetNeedUpdate ==
              false &&
          seriesRendererDetails.xAxisDetails!.zoomFactor == 1 &&
          seriesRendererDetails.yAxisDetails!.zoomFactor == 1 &&
          // ignore: unnecessary_null_comparison
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= segmentProperties.seriesIndex &&
          SeriesHelper.getSeriesRendererDetails(
                      _oldSeriesRenderers[segmentProperties.seriesIndex])
                  .seriesName ==
              SeriesHelper.getSeriesRendererDetails(
                      segmentProperties.seriesRenderer)
                  .seriesName) {
        segmentProperties.oldSeriesRenderer =
            _oldSeriesRenderers[segmentProperties.seriesIndex];
        segmentProperties.oldSeries = SeriesHelper.getSeriesRendererDetails(
                segmentProperties.oldSeriesRenderer!)
            .series as XyDataSeries<dynamic, dynamic>;
        segmentProperties.oldSegmentIndex = 0;
      }
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      seriesRendererDetails.segments.add(segment);
    }
    return segment;
  }

  /// To render stacked area 100 series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    if (seriesRendererDetails.isSelectionEnable == true) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          seriesRendererDetails.selectionBehaviorRenderer;
      SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
          .selectionRenderer
          ?.checkWithSelectionState(
              seriesRendererDetails.segments[0], seriesRendererDetails.chart);
    }
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  StackedArea100Segment createSegment() => StackedArea100Segment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(this);
    final SegmentProperties segmentProperties =
        SegmentHelper.getSegmentProperties(segment);
    segmentProperties.color = seriesRendererDetails.seriesColor;
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
    canvas.drawPath(seriesRendererDetails.markerShapes[index]!, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}

/// Represents the StackedArea Chart painter
class StackedAreaChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedAreaChartPainter class.
  StackedAreaChartPainter(
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

  /// Specifies the Stacked area series renderer
  final StackedAreaSeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked area series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    stackedAreaPainter(
        canvas,
        seriesRenderer,
        seriesRendererDetails,
        stateProperties,
        seriesRendererDetails.seriesAnimation,
        seriesRendererDetails.seriesElementAnimation!,
        painterKey);
  }

  @override
  bool shouldRepaint(StackedAreaChartPainter oldDelegate) => isRepaint;
}

/// Represents the StackedArea100 Chart painter
class StackedArea100ChartPainter extends CustomPainter {
  /// Calling the default constructor of StackedArea100ChartPainter class.
  StackedArea100ChartPainter(
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

  /// Specifies the StackedArea100 series renderer
  final StackedArea100SeriesRenderer seriesRenderer;

  /// Specifies the painter key value
  final PainterKey painterKey;

  /// Painter method for stacked area 100 series
  @override
  void paint(Canvas canvas, Size size) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // Disposing the old chart segments.
    disposeOldSegments(chart, seriesRendererDetails);
    stackedAreaPainter(
        canvas,
        seriesRenderer,
        seriesRendererDetails,
        stateProperties,
        seriesRendererDetails.seriesAnimation,
        seriesRendererDetails.seriesElementAnimation!,
        painterKey);
  }

  @override
  bool shouldRepaint(StackedArea100ChartPainter oldDelegate) => isRepaint;
}

/// Painter method for stacked area series
void stackedAreaPainter(
    Canvas canvas,
    dynamic seriesRenderer,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    Animation<double>? seriesAnimation,
    Animation<double> chartElementAnimation,
    PainterKey painterKey) {
  Rect clipRect, axisClipRect;
  final int seriesIndex = painterKey.index;
  final SfCartesianChart chart = stateProperties.chart;
  final RenderingDetails _renderingDetails = stateProperties.renderingDetails;

  seriesRendererDetails.storeSeriesProperties(stateProperties, seriesIndex);
  double animationFactor;
  final num? crossesAt = getCrossesAtValue(seriesRenderer, stateProperties);
  final List<CartesianChartPoint<dynamic>> dataPoints =
      seriesRendererDetails.dataPoints;

  // Clip rect will be added for series.
  if (seriesRendererDetails.visible! == true) {
    final dynamic series = seriesRendererDetails.series;
    canvas.save();
    axisClipRect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.clipRect(axisClipRect);
    animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
    stateProperties.shader = null;
    if (series.onCreateShader != null) {
      stateProperties.shader = series.onCreateShader!(
          ShaderDetails(stateProperties.chartAxis.axisClipRect, 'series'));
    }
    if (seriesRendererDetails.reAnimate == true ||
        ((!(_renderingDetails.widgetNeedUpdate ||
                    _renderingDetails.isLegendToggled) ||
                !stateProperties.oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0 == true)) {
      performLinearAnimation(stateProperties,
          seriesRendererDetails.xAxisDetails!.axis, canvas, animationFactor);
    }

    final Path _path = Path(), _strokePath = Path();
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    ChartLocation point1, point2;
    final ChartAxisRendererDetails xAxisDetails =
            seriesRendererDetails.xAxisDetails!,
        yAxisDetails = seriesRendererDetails.yAxisDetails!;
    CartesianChartPoint<dynamic>? point;
    final dynamic _series = seriesRendererDetails.series;
    final List<Offset> _points = <Offset>[];
    if (dataPoints.isNotEmpty) {
      int startPoint = 0;
      final StackedValues stackedValues =
          seriesRendererDetails.stackingValues[0];
      List<CartesianSeriesRenderer> seriesRendererCollection;
      CartesianSeriesRenderer previousSeriesRenderer;
      SeriesRendererDetails previousSeriesRendererDetails;
      seriesRendererCollection = findSeriesCollection(stateProperties);
      point1 = calculatePoint(
          dataPoints[0].xValue,
          math_lib.max(yAxisDetails.visibleRange!.minimum,
              crossesAt ?? stackedValues.startValues[0]),
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          _series,
          rect);
      _path.moveTo(point1.x, point1.y);
      _strokePath.moveTo(point1.x, point1.y);
      if (seriesRendererDetails.visibleDataPoints == null ||
          seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
        seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRendererDetails.setSeriesProperties(seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRendererDetails.calculateRegionData(stateProperties,
            seriesRendererDetails, seriesIndex, point, pointIndex);
        if (point.isVisible) {
          point1 = calculatePoint(
              dataPoints[pointIndex].xValue,
              stackedValues.endValues[pointIndex],
              xAxisDetails,
              yAxisDetails,
              stateProperties.requireInvertedAxis,
              _series,
              rect);
          _points.add(Offset(point1.x, point1.y));
          _path.lineTo(point1.x, point1.y);
          _strokePath.lineTo(point1.x, point1.y);
        } else {
          if (_series.emptyPointSettings.mode != EmptyPointMode.drop) {
            for (int j = pointIndex - 1; j >= startPoint; j--) {
              point2 = calculatePoint(
                  dataPoints[j].xValue,
                  crossesAt ?? stackedValues.startValues[j],
                  xAxisDetails,
                  yAxisDetails,
                  stateProperties.requireInvertedAxis,
                  _series,
                  rect);
              _path.lineTo(point2.x, point2.y);
              if (_series.borderDrawMode == BorderDrawMode.excludeBottom) {
                _strokePath.lineTo(point1.x, point2.y);
              } else if (_series.borderDrawMode == BorderDrawMode.all) {
                _strokePath.lineTo(point2.x, point2.y);
              }
            }
            if (dataPoints.length > pointIndex + 1 &&
                // ignore: unnecessary_null_comparison
                dataPoints[pointIndex + 1] != null &&
                dataPoints[pointIndex + 1].isVisible) {
              point1 = calculatePoint(
                  dataPoints[pointIndex + 1].xValue,
                  crossesAt ?? stackedValues.startValues[pointIndex + 1],
                  xAxisDetails,
                  yAxisDetails,
                  stateProperties.requireInvertedAxis,
                  _series,
                  rect);
              _path.moveTo(point1.x, point1.y);
              _strokePath.moveTo(point1.x, point1.y);
            }
            startPoint = pointIndex + 1;
          }
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(
              painterKey.index, chart, animationFactor, _points);
        }
      }
      for (int j = dataPoints.length - 1; j >= startPoint; j--) {
        previousSeriesRenderer =
            getPreviousSeriesRenderer(seriesRendererCollection, seriesIndex);
        previousSeriesRendererDetails =
            SeriesHelper.getSeriesRendererDetails(previousSeriesRenderer);
        if (previousSeriesRendererDetails.series.emptyPointSettings.mode !=
                EmptyPointMode.drop ||
            previousSeriesRendererDetails.dataPoints[j].isVisible == true) {
          point2 = calculatePoint(
              dataPoints[j].xValue,
              crossesAt ?? stackedValues.startValues[j],
              xAxisDetails,
              yAxisDetails,
              stateProperties.requireInvertedAxis,
              _series,
              rect);
          _path.lineTo(point2.x, point2.y);
          if (_series.borderDrawMode == BorderDrawMode.excludeBottom) {
            _strokePath.lineTo(point1.x, point2.y);
          } else if (_series.borderDrawMode == BorderDrawMode.all) {
            _strokePath.lineTo(point2.x, point2.y);
          }
        }
      }
    }
    // ignore: unnecessary_null_comparison
    if (_path != null &&
        // ignore: unnecessary_null_comparison
        seriesRendererDetails.segments != null &&
        seriesRendererDetails.segments.isNotEmpty == true) {
      final ChartSegment areaSegment = seriesRendererDetails.segments[0];
      SegmentHelper.getSegmentProperties(areaSegment)
        ..path = _path
        ..strokePath = _strokePath;
      seriesRenderer._drawSegment(canvas, areaSegment);
    }

    clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            rect.left - _series.markerSettings.width,
            rect.top - _series.markerSettings.height,
            rect.right + _series.markerSettings.width,
            rect.bottom + _series.markerSettings.height),
        Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
            seriesRendererDetails.yAxisDetails!.axis.plotOffset));
    canvas.restore();
    if ((_series.animationDuration <= 0 == true ||
            !_renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (_series.markerSettings.isVisible == true ||
            _series.dataLabelSettings.isVisible == true)) {
      canvas.clipRect(clipRect);
      seriesRendererDetails.renderSeriesElements(
          chart, canvas, chartElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }
}
