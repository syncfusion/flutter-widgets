import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../common/event_args.dart' show ErrorBarValues;
import '../../common/utils/helper.dart';
import '../axis/axis.dart';
import '../axis/category_axis.dart';
import '../axis/datetime_axis.dart';
import '../axis/datetime_category_axis.dart';
import '../base/chart_base.dart';
import '../chart_series/error_bar_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/stacked_series_base.dart';
import '../chart_series/xy_data_series.dart';
import '../common/data_label.dart';
import '../common/marker.dart';
import '../series_painter/histogram_painter.dart';
import '../trendlines/trendlines.dart';
import '../utils/helper.dart';
import 'cartesian_state_properties.dart';
import 'trackball_marker_settings.dart';

export 'package:syncfusion_flutter_core/core.dart'
    show DataMarkerType, TooltipAlignment;

/// Represents the data label renderer class.
// ignore: must_be_immutable
class DataLabelRenderer extends StatefulWidget {
  /// Creates an instance of data label renderer.
  // ignore: prefer_const_constructors_in_immutables
  DataLabelRenderer({required this.stateProperties, required this.show});

  /// Holds the value of state properties.
  final CartesianStateProperties stateProperties;

  /// Specifies whether to show the data labels.
  bool show;

  /// Specifies the data label renderer state.
  // ignore: library_private_types_in_public_api
  _DataLabelRendererState? state;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    state = _DataLabelRendererState();
    return state!;
  }
}

class _DataLabelRendererState extends State<DataLabelRenderer>
    with SingleTickerProviderStateMixin {
  // List<AnimationController> animationControllersList;

  /// Animation controller for series.
  late AnimationController animationController;

  /// Repaint notifier for crosshair container.
  late ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds:
            widget.stateProperties.renderingDetails.initialRender! ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));

    animationController.forward(from: 0.0);
    // ignore: avoid_unnecessary_containers
    return Container(
        child: CustomPaint(
            painter: _DataLabelPainter(
                stateProperties: widget.stateProperties,
                animation: dataLabelAnimation,
                state: this,
                animationController: animationController,
                notifier: dataLabelRepaintNotifier)));
  }

  @override
  void dispose() {
    // if (animationController != null) {
    animationController.removeListener(repaintDataLabelElements);
    animationController.dispose();
    //   animationController = null;
    // }
    super.dispose();
  }

  /// To repaint data label elements.
  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  void render() {
    setState(() {
      widget.show = true;
    });
  }
}

class _DataLabelPainter extends CustomPainter {
  _DataLabelPainter(
      {required this.stateProperties,
      required this.state,
      required this.animationController,
      required this.animation,
      required ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final CartesianStateProperties stateProperties;

  final _DataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(stateProperties.chartAxis.axisClipRect);
    stateProperties.renderDatalabelRegions = <Rect>[];
    final List<CartesianSeriesRenderer> visibleSeriesRenderers =
        stateProperties.chartSeries.visibleSeriesRenderers;
    SeriesRendererDetails seriesRendererDetails;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer =
          stateProperties.chartSeries.visibleSeriesRenderers[i];
      DataLabelSettingsRenderer dataLabelSettingsRenderer;
      seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      if (seriesRendererDetails.series.dataLabelSettings.isVisible == true &&
          (seriesRendererDetails.animationCompleted == true ||
              seriesRendererDetails.series.animationDuration == 0 ||
              !stateProperties.renderingDetails.initialRender!) &&
          (seriesRendererDetails.needAnimateSeriesElements == false ||
              (stateProperties.seriesDurationFactor <
                      seriesRendererDetails.animationController.value ||
                  seriesRendererDetails.series.animationDuration == 0) ||
              (seriesRendererDetails.animationController.status ==
                  AnimationStatus.dismissed)) &&
          seriesRendererDetails.series.dataLabelSettings.builder == null) {
        seriesRendererDetails.dataLabelSettingsRenderer =
            DataLabelSettingsRenderer(
                seriesRendererDetails.series.dataLabelSettings);
        if (seriesRendererDetails.visibleDataPoints != null &&
            seriesRendererDetails.visibleDataPoints!.isNotEmpty == true) {
          for (int j = 0;
              j < seriesRendererDetails.visibleDataPoints!.length;
              j++) {
            if (seriesRendererDetails.visible! == true &&
                // ignore: unnecessary_null_comparison
                seriesRendererDetails.series.dataLabelSettings != null) {
              dataLabelSettingsRenderer =
                  seriesRendererDetails.dataLabelSettingsRenderer;
              dataLabelSettingsRenderer.renderDataLabel(
                  stateProperties,
                  seriesRendererDetails,
                  seriesRendererDetails.visibleDataPoints![j],
                  animation,
                  canvas,
                  j,
                  dataLabelSettingsRenderer);
            }
          }
        }
        if (animation.value >= 1) {
          seriesRendererDetails.needAnimateSeriesElements = false;
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DataLabelPainter oldDelegate) => true;
}

/// Find rect type series region.
void calculateRectSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties) {
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  final ChartAxisRendererDetails yAxisDetails =
      seriesRendererDetails.yAxisDetails!;
  final num? crossesAt =
      getCrossesAtValue(seriesRendererDetails.renderer, stateProperties);
  final num sideBySideMinimumVal =
      seriesRendererDetails.sideBySideInfo!.minimum;

  final num sideBySideMaximumVal =
      seriesRendererDetails.sideBySideInfo!.maximum;

  final num origin =
      crossesAt ?? math.max(yAxisDetails.visibleRange!.minimum, 0);

  /// Get the rectangle based on points.
  final Rect rect =
      (seriesRendererDetails.seriesType.contains('stackedcolumn') == true ||
                  seriesRendererDetails.seriesType.contains('stackedbar') ==
                      true) &&
              seriesRendererDetails.renderer is StackedSeriesRenderer
          ? calculateRectangle(
              point.xValue + sideBySideMinimumVal,
              seriesRendererDetails.stackingValues[0].endValues[pointIndex],
              point.xValue + sideBySideMaximumVal,
              crossesAt ??
                  seriesRendererDetails
                      .stackingValues[0].startValues[pointIndex],
              seriesRendererDetails.renderer,
              stateProperties)
          : calculateRectangle(
              point.xValue + sideBySideMinimumVal,
              seriesRendererDetails.seriesType == 'rangecolumn'
                  ? point.high
                  : seriesRendererDetails.seriesType == 'boxandwhisker'
                      ? point.maximum
                      : seriesRendererDetails.seriesType == 'waterfall'
                          ? point.endValue
                          : point.yValue,
              point.xValue + sideBySideMaximumVal,
              seriesRendererDetails.seriesType == 'rangecolumn'
                  ? point.low
                  : seriesRendererDetails.seriesType == 'boxandwhisker'
                      ? point.minimum
                      : seriesRendererDetails.seriesType == 'waterfall'
                          ? point.originValue
                          : origin,
              seriesRendererDetails.renderer,
              stateProperties);

  point.region = rect;
  final dynamic series = seriesRendererDetails.series;

  ///Get shadow rect region.
  if (seriesRendererDetails.seriesType != 'stackedcolumn100' &&
      seriesRendererDetails.seriesType != 'stackedbar100' &&
      seriesRendererDetails.seriesType != 'waterfall' &&
      series.isTrackVisible == true) {
    final Rect shadowPointRect = calculateShadowRectangle(
        point.xValue + sideBySideMinimumVal,
        seriesRendererDetails.seriesType == 'rangecolumn'
            ? point.high
            : point.yValue,
        point.xValue + sideBySideMaximumVal,
        seriesRendererDetails.seriesType == 'rangecolumn' ? point.high : origin,
        seriesRendererDetails.renderer,
        stateProperties,
        Offset(xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset));

    point.trackerRectRegion = shadowPointRect;
  }
  if (seriesRendererDetails.seriesType == 'rangecolumn' ||
      seriesRendererDetails.seriesType.contains('hilo') == true ||
      seriesRendererDetails.seriesType.contains('candle') == true ||
      seriesRendererDetails.seriesType.contains('boxandwhisker') == true) {
    point.markerPoint = stateProperties.requireInvertedAxis != true
        ? ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
        : ChartLocation(rect.centerRight.dx, rect.centerRight.dy);
    point.markerPoint2 = stateProperties.requireInvertedAxis != true
        ? ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
        : ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy);
  } else {
    point.markerPoint = stateProperties.requireInvertedAxis != true
        ? (yAxisDetails.axis.isInversed
            ? (point.yValue.isNegative == true
                ? ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
                : ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy))
            : (point.yValue.isNegative == true
                ? ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
                : ChartLocation(rect.topCenter.dx, rect.topCenter.dy)))
        : (yAxisDetails.axis.isInversed
            ? (point.yValue.isNegative == true
                ? ChartLocation(rect.centerRight.dx, rect.centerRight.dy)
                : ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy))
            : (point.yValue.isNegative == true
                ? ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy)
                : ChartLocation(rect.centerRight.dx, rect.centerRight.dy)));
  }
  if (seriesRendererDetails.seriesType == 'waterfall') {
    /// The below values are used to find the chart location of the connector lines of each data point.
    point.originValueLeftPoint = calculatePoint(
        point.xValue + sideBySideMinimumVal,
        point.originValue,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        calculatePlotOffset(
            stateProperties.chartAxis.axisClipRect,
            Offset(
                xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset)));
    point.originValueRightPoint = calculatePoint(
        point.xValue + sideBySideMaximumVal,
        point.originValue,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        calculatePlotOffset(
            stateProperties.chartAxis.axisClipRect,
            Offset(
                xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset)));
    point.endValueLeftPoint = calculatePoint(
        point.xValue + sideBySideMinimumVal,
        point.endValue,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        calculatePlotOffset(
            stateProperties.chartAxis.axisClipRect,
            Offset(
                xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset)));
    point.endValueRightPoint = calculatePoint(
        point.xValue + sideBySideMaximumVal,
        point.endValue,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        calculatePlotOffset(
            stateProperties.chartAxis.axisClipRect,
            Offset(
                xAxisDetails.axis.plotOffset, yAxisDetails.axis.plotOffset)));
  }
}

/// Calculate scatter, bubble series data points region.
void calculatePointSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    Rect rect) {
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  final ChartAxisRendererDetails yAxisDetails =
      seriesRendererDetails.yAxisDetails!;
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final ChartLocation currentPoint = calculatePoint(
      point.xValue,
      point.yValue,
      xAxisDetails,
      yAxisDetails,
      stateProperties.requireInvertedAxis,
      seriesRendererDetails.series,
      rect);
  point.markerPoint = currentPoint;
  if (seriesRendererDetails.seriesType == 'scatter') {
    point.region = Rect.fromLTRB(
        currentPoint.x - series.markerSettings.width,
        currentPoint.y - series.markerSettings.width,
        currentPoint.x + series.markerSettings.width,
        currentPoint.y + series.markerSettings.width);
  } else {
    final num bubbleRadius =
        calculateBubbleRadius(seriesRendererDetails, series, point);
    point.region = Rect.fromLTRB(
        currentPoint.x - 2 * bubbleRadius,
        currentPoint.y - 2 * bubbleRadius,
        currentPoint.x + 2 * bubbleRadius,
        currentPoint.y + 2 * bubbleRadius);
  }
}

/// Calculate errorBar series data points region.
void calculateErrorBarSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    Rect rect) {
  if (!point.isGap) {
    final ChartAxisRendererDetails xAxisDetails =
        seriesRendererDetails.xAxisDetails!;
    final ChartAxisRendererDetails yAxisDetails =
        seriesRendererDetails.yAxisDetails!;
    final ErrorBarSeries<dynamic, dynamic> series =
        seriesRendererDetails.series as ErrorBarSeries<dynamic, dynamic>;
    final num actualXValue = point.xValue;
    final num actualYValue = point.yValue;
    final ChartLocation currentPoint = calculatePoint(
        actualXValue,
        actualYValue,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        rect);
    point.currentPoint = currentPoint;
    final ErrorBarValues errorBarValues = point.errorBarValues!;
    if (errorBarValues.horizontalPositiveErrorValue != null) {
      point.horizontalPositiveErrorPoint = calculatePoint(
          errorBarValues.horizontalPositiveErrorValue!,
          actualYValue,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          series,
          rect);
    }
    if (errorBarValues.horizontalNegativeErrorValue != null) {
      point.horizontalNegativeErrorPoint = calculatePoint(
          errorBarValues.horizontalNegativeErrorValue!,
          actualYValue,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          series,
          rect);
    }
    if (errorBarValues.verticalPositiveErrorValue != null) {
      point.verticalPositiveErrorPoint = calculatePoint(
          actualXValue,
          errorBarValues.verticalPositiveErrorValue!,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          series,
          rect);
    }
    if (errorBarValues.verticalNegativeErrorValue != null) {
      point.verticalNegativeErrorPoint = calculatePoint(
          actualXValue,
          errorBarValues.verticalNegativeErrorValue,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          series,
          rect);
    }
  }
}

/// Calculate data point region for path series like line, area, etc.,
void calculatePathSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    Rect rect,
    double markerHeight,
    double markerWidth,
    [VisibleRange? sideBySideInfo,
    CartesianChartPoint<dynamic>? nextPoint,
    num? midX,
    num? midY]) {
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  final ChartAxisRendererDetails yAxisDetails =
      seriesRendererDetails.yAxisDetails!;
  final num? sideBySideMinimumVal =
      seriesRendererDetails.sideBySideInfo?.minimum;

  final num? sideBySideMaximumVal =
      seriesRendererDetails.sideBySideInfo?.maximum;
  if (seriesRendererDetails.seriesType != 'rangearea' &&
      seriesRendererDetails.seriesType != 'splinerangearea' &&
      (seriesRendererDetails.seriesType.contains('hilo') == false) &&
      (seriesRendererDetails.seriesType.contains('candle') == false) &&
      seriesRendererDetails.seriesType.contains('boxandwhisker') == false) {
    if (seriesRendererDetails.seriesType == 'spline' &&
        pointIndex <= seriesRendererDetails.dataPoints.length - 2) {
      point.controlPoint = seriesRendererDetails.drawControlPoints[pointIndex];
      point.startControl = calculatePoint(
          point.controlPoint![0].dx,
          point.controlPoint![0].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      point.endControl = calculatePoint(
          point.controlPoint![1].dx,
          point.controlPoint![1].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }
    if (seriesRendererDetails.seriesType == 'splinearea' &&
        pointIndex != 0 &&
        pointIndex <= seriesRendererDetails.dataPoints.length - 1) {
      point.controlPoint =
          seriesRendererDetails.drawControlPoints[pointIndex - 1];
      point.startControl = calculatePoint(
          point.controlPoint![0].dx,
          point.controlPoint![0].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      point.endControl = calculatePoint(
          point.controlPoint![1].dx,
          point.controlPoint![1].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }

    if (seriesRendererDetails.seriesType == 'stepline') {
      point.currentPoint = calculatePoint(
          point.xValue,
          point.yValue,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }
    final ChartLocation currentPoint =
        (seriesRendererDetails.seriesType == 'stackedarea' ||
                    seriesRendererDetails.seriesType == 'stackedarea100' ||
                    seriesRendererDetails.seriesType == 'stackedline' ||
                    seriesRendererDetails.seriesType == 'stackedline100') &&
                seriesRendererDetails.renderer is StackedSeriesRenderer
            ? calculatePoint(
                point.xValue,
                seriesRendererDetails.stackingValues[0].endValues[pointIndex],
                xAxisDetails,
                yAxisDetails,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                rect)
            : calculatePoint(
                point.xValue,
                point.yValue,
                xAxisDetails,
                yAxisDetails,
                stateProperties.requireInvertedAxis,
                seriesRendererDetails.series,
                rect);

    point.region = Rect.fromLTWH(currentPoint.x - markerWidth,
        currentPoint.y - markerHeight, 2 * markerWidth, 2 * markerHeight);
    point.markerPoint = currentPoint;
  } else {
    num? value1, value2;
    value1 = (point.low != null &&
            point.high != null &&
            (point.low < point.high) == true)
        ? point.high
        : point.low;
    value2 = (point.low != null &&
            point.high != null &&
            (point.low > point.high) == true)
        ? point.high
        : point.low;
    if (seriesRendererDetails.seriesType == 'boxandwhisker') {
      value1 = (point.minimum != null &&
              point.maximum != null &&
              point.minimum! < point.maximum!)
          ? point.maximum
          : point.minimum;
      value2 = (point.minimum != null &&
              point.maximum != null &&
              point.minimum! > point.maximum!)
          ? point.maximum
          : point.minimum;
    }
    point.markerPoint = calculatePoint(
        point.xValue,
        yAxisDetails.axis.isInversed ? value2 : value1,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        rect);
    point.markerPoint2 = calculatePoint(
        point.xValue,
        yAxisDetails.axis.isInversed ? value1 : value2,
        xAxisDetails,
        yAxisDetails,
        stateProperties.requireInvertedAxis,
        seriesRendererDetails.series,
        rect);
    if (seriesRendererDetails.seriesType == 'splinerangearea' &&
        pointIndex != 0 &&
        pointIndex <= seriesRendererDetails.dataPoints.length - 1) {
      point.controlPointshigh = seriesRendererDetails.drawHighControlPoints[
          seriesRendererDetails.dataPoints.indexOf(point) - 1];

      point.highStartControl = calculatePoint(
          point.controlPointshigh![0].dx,
          point.controlPointshigh![0].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.highEndControl = calculatePoint(
          point.controlPointshigh![1].dx,
          point.controlPointshigh![1].dy,
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }
    if (seriesRendererDetails.seriesType == 'splinerangearea' &&
        pointIndex >= 0 &&
        pointIndex <= seriesRendererDetails.dataPoints.length - 2) {
      point.controlPointslow = seriesRendererDetails.drawLowControlPoints[
          seriesRendererDetails.dataPoints.indexOf(point)];

      point.lowStartControl = calculatePoint(
          point.controlPointslow![0].dx,
          point.controlPointslow![0].dy,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.lowEndControl = calculatePoint(
          point.controlPointslow![1].dx,
          point.controlPointslow![1].dy,
          xAxisDetails,
          yAxisDetails,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }

    if (seriesRendererDetails.seriesType == 'hilo' &&
        point.low != null &&
        point.high != null) {
      point.lowPoint = calculatePoint(
          point.xValue,
          point.low,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      point.highPoint = calculatePoint(
          point.xValue,
          point.high,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    } else if ((seriesRendererDetails.seriesType == 'hiloopenclose' ||
            seriesRendererDetails.seriesType == 'candle') &&
        point.open != null &&
        point.close != null &&
        point.low != null &&
        point.high != null) {
      final num center = (point.xValue + sideBySideMinimumVal) +
          (((point.xValue + sideBySideMaximumVal) -
                  (point.xValue + sideBySideMinimumVal)) /
              2);
      point.openPoint = calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.open,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.closePoint = calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.close,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      if (seriesRendererDetails.series.dataLabelSettings.isVisible == true) {
        point.centerOpenPoint = calculatePoint(
            point.xValue,
            point.open,
            seriesRendererDetails.xAxisDetails!,
            seriesRendererDetails.yAxisDetails!,
            stateProperties.requireInvertedAxis,
            seriesRendererDetails.series,
            rect);

        point.centerClosePoint = calculatePoint(
            point.xValue,
            point.close,
            seriesRendererDetails.xAxisDetails!,
            seriesRendererDetails.yAxisDetails!,
            stateProperties.requireInvertedAxis,
            seriesRendererDetails.series,
            rect);
      }

      point.centerHighPoint = calculatePoint(
          center,
          point.high,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.centerLowPoint = calculatePoint(
          center,
          point.low,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.lowPoint = calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.low,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
      point.highPoint = calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.high,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }

    if (seriesRendererDetails.seriesType.contains('boxandwhisker') == true &&
        point.minimum != null &&
        point.maximum != null &&
        point.upperQuartile != null &&
        point.lowerQuartile != null &&
        point.median != null) {
      final num center = (point.xValue + sideBySideMinimumVal) +
          (((point.xValue + sideBySideMaximumVal) -
                  (point.xValue + sideBySideMinimumVal)) /
              2);

      point.centerMeanPoint = calculatePoint(
          center,
          point.mean,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.minimumPoint = calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.minimum,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.maximumPoint = calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.maximum,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.centerMinimumPoint = calculatePoint(
          center,
          point.minimum,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.centerMaximumPoint = calculatePoint(
          center,
          point.maximum,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.lowerQuartilePoint = calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.lowerQuartile,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.upperQuartilePoint = calculatePoint(
          point.xValue + sideBySideMaximumVal,
          point.upperQuartile,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.medianPoint = calculatePoint(
          point.xValue + sideBySideMinimumVal,
          point.median,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);

      point.centerMedianPoint = calculatePoint(
          center,
          point.median,
          seriesRendererDetails.xAxisDetails!,
          seriesRendererDetails.yAxisDetails!,
          seriesRendererDetails.stateProperties.requireInvertedAxis,
          seriesRendererDetails.series,
          rect);
    }
    point.region = seriesRendererDetails.seriesType.contains('hilo') == true ||
            seriesRendererDetails.seriesType.contains('candle') == true ||
            seriesRendererDetails.seriesType.contains('boxandwhisker') == true
        ? !stateProperties.requireInvertedAxis
            ? Rect.fromLTWH(
                point.markerPoint!.x,
                point.markerPoint!.y,
                seriesRendererDetails.series.borderWidth,
                point.markerPoint2!.y - point.markerPoint!.y)
            : Rect.fromLTWH(
                point.markerPoint2!.x,
                point.markerPoint2!.y,
                (point.markerPoint!.x - point.markerPoint2!.x).abs(),
                seriesRendererDetails.series.borderWidth)
        : Rect.fromLTRB(
            point.markerPoint!.x - markerWidth,
            point.markerPoint!.y - markerHeight,
            point.markerPoint!.x + markerWidth,
            point.markerPoint2!.y);
    if (seriesRendererDetails.seriesType.contains('boxandwhisker') == true) {
      point.boxRectRegion = calculateRectangle(
          point.xValue + sideBySideMinimumVal,
          point.upperQuartile!,
          point.xValue + sideBySideMaximumVal,
          point.lowerQuartile!,
          seriesRendererDetails.renderer,
          stateProperties);
    }
  }
}

/// Finding outliers region.
void calculateOutlierRegion(CartesianChartPoint<dynamic> point,
    ChartLocation outlierPosition, num outlierWidth) {
  point.outlierRegion!.add(Rect.fromLTRB(
      outlierPosition.x - outlierWidth,
      outlierPosition.y - outlierWidth,
      outlierPosition.x + outlierWidth,
      outlierPosition.y + outlierWidth));
}

/// Finding tooltip region.
void calculateTooltipRegion(
    CartesianChartPoint<dynamic> point,
    int seriesIndex,
    SeriesRendererDetails seriesRendererDetails,
    CartesianStateProperties stateProperties,
    [Trendline? trendline,
    TrendlineRenderer? trendlineRenderer,
    int? trendlineIndex]) {
  final SfCartesianChart chart = stateProperties.chart;
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final num? crossesAt =
      getCrossesAtValue(seriesRendererDetails.renderer, stateProperties);
  // ignore: unnecessary_null_comparison
  if ((series.enableTooltip != null ||
          // ignore: unnecessary_null_comparison
          seriesRendererDetails.chart.trackballBehavior != null ||
          seriesRendererDetails.series.onPointTap != null ||
          seriesRendererDetails.series.onPointDoubleTap != null ||
          seriesRendererDetails.series.onPointLongPress != null) &&
      (series.enableTooltip ||
          seriesRendererDetails.chart.trackballBehavior.enable == true ||
          seriesRendererDetails.series.onPointTap != null ||
          seriesRendererDetails.series.onPointDoubleTap != null ||
          seriesRendererDetails.series.onPointLongPress != null) &&
      // ignore: unnecessary_null_comparison
      point != null &&
      !point.isGap &&
      !point.isDrop &&
      seriesRendererDetails.regionalData != null) {
    bool isTrendline = false;
    if (trendline != null) {
      isTrendline = true;
    }
    final List<String> regionData = <String>[];
    num binWidth = 0;
    String? date;
    final List<dynamic> regionRect = <dynamic>[];
    if (seriesRendererDetails.renderer is HistogramSeriesRenderer) {
      binWidth = seriesRendererDetails.histogramValues.binWidth!;
    }
    if (xAxisDetails is DateTimeAxisDetails) {
      final DateTimeAxis xAxis = xAxisDetails.axis as DateTimeAxis;
      final num interval = xAxisDetails.visibleRange!.minimum.ceil();
      final num prevInterval = (xAxisDetails.visibleLabels.isNotEmpty)
          ? xAxisDetails
              .visibleLabels[xAxisDetails.visibleLabels.length - 1].value
          : interval;
      final DateFormat dateFormat = xAxis.dateFormat ??
          getDateTimeLabelFormat(xAxisDetails.axisRenderer, interval.toInt(),
              prevInterval.toInt());
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    } else if (xAxisDetails is DateTimeCategoryAxisDetails) {
      date = point.x is DateTime
          ? xAxisDetails.dateFormat.format(point.x)
          : point.x.toString();
    }
    xAxisDetails is CategoryAxisDetails
        ? regionData.add(point.x.toString())
        : (xAxisDetails is DateTimeAxisDetails ||
                xAxisDetails is DateTimeCategoryAxisDetails)
            ? regionData.add(date!.toString())
            : seriesRendererDetails.seriesType != 'histogram'
                ? regionData.add(getLabelValue(point.xValue, xAxisDetails.axis,
                        chart.tooltipBehavior.decimalPlaces)
                    .toString())
                : regionData.add(
                    '${getLabelValue(point.xValue - binWidth / 2, xAxisDetails.axis, chart.tooltipBehavior.decimalPlaces)} - ${getLabelValue(point.xValue + binWidth / 2, xAxisDetails.axis, chart.tooltipBehavior.decimalPlaces)}');

    if (seriesRendererDetails.seriesType.contains('range') == true &&
            !isTrendline ||
        seriesRendererDetails.seriesType.contains('hilo') == true ||
        seriesRendererDetails.seriesType.contains('candle') == true ||
        seriesRendererDetails.seriesType.contains('boxandwhisker') == true) {
      if (seriesRendererDetails.seriesType != 'hiloopenclose' &&
          seriesRendererDetails.seriesType != 'candle' &&
          seriesRendererDetails.seriesType != 'boxandwhisker') {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
      } else if (seriesRendererDetails.seriesType != 'boxandwhisker') {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
        regionData.add(point.open.toString());
        regionData.add(point.close.toString());
      } else {
        regionData.add(point.minimum.toString());
        regionData.add(point.maximum.toString());
        regionData.add(point.lowerQuartile.toString());
        regionData.add(point.upperQuartile.toString());
        regionData.add(point.median.toString());
        regionData.add(point.mean.toString());
      }
    } else {
      regionData.add(point.yValue.toString());
    }
    regionData.add(isTrendline
        ? trendlineRenderer!.name ?? ''
        : series.name ?? 'series $seriesIndex');
    regionRect.add(
        seriesRendererDetails.seriesType.contains('boxandwhisker') == true
            ? point.boxRectRegion
            : point.region);
    regionRect.add((seriesRendererDetails.isRectSeries == true) ||
            seriesRendererDetails.seriesType.contains('hilo') == true ||
            seriesRendererDetails.seriesType.contains('candle') == true ||
            seriesRendererDetails.seriesType.contains('boxandwhisker') == true
        ? seriesRendererDetails.seriesType == 'column' ||
                seriesRendererDetails.seriesType.contains('stackedcolumn') ==
                    true ||
                seriesRendererDetails.seriesType == 'histogram'
            ? (point.yValue > (crossesAt ?? 0)) == true
                ? point.region!.topCenter
                : point.region!.bottomCenter
            : seriesRendererDetails.seriesType.contains('hilo') == true ||
                    seriesRendererDetails.seriesType.contains('candle') ==
                        true ||
                    seriesRendererDetails.seriesType
                            .contains('boxandwhisker') ==
                        true
                ? point.region!.topCenter
                : point.region!.topCenter
        : (seriesRendererDetails.seriesType.contains('rangearea') == true
            ? (isTrendline
                ? Offset(point.markerPoint!.x, point.markerPoint!.y)
                : Offset(point.markerPoint!.x, point.markerPoint!.y))
            : point.region!.center));
    regionRect.add(
        isTrendline ? trendlineRenderer!.fillColor : point.pointColorMapper);
    regionRect.add(point.bubbleSize);
    regionRect.add(point);
    regionRect.add(point.outlierRegion);
    regionRect.add(point.outlierRegionPosition);
    if (seriesRendererDetails.seriesType.contains('stacked') == true) {
      regionData.add((point.cumulativeValue).toString());
    }
    regionData.add('$isTrendline');
    if (isTrendline) {
      regionRect.add(trendline);
    }
    seriesRendererDetails.regionalData![regionRect] = regionData;
    point.regionData = regionData;
  }
}

/// Paint the image marker.
void drawImageMarker(SeriesRendererDetails? seriesRendererDetails,
    Canvas canvas, double pointX, double pointY,
    [TrackballMarkerSettings? trackballMarkerSettings,
    CartesianStateProperties? stateProperties]) {
  final MarkerSettingsRenderer? markerSettingsRenderer =
      seriesRendererDetails?.markerSettingsRenderer;

  if (seriesRendererDetails != null && markerSettingsRenderer!.image != null) {
    final double imageWidth =
        2.0 * seriesRendererDetails.series.markerSettings.width;
    final double imageHeight =
        2.0 * seriesRendererDetails.series.markerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    paintImage(
        canvas: canvas,
        rect: positionRect,
        image: markerSettingsRenderer.image!,
        fit: BoxFit.fill);
  }

  if (stateProperties?.trackballMarkerSettingsRenderer.image != null) {
    final double imageWidth = 2 * trackballMarkerSettings!.width;
    final double imageHeight = 2 * trackballMarkerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    paintImage(
        canvas: canvas,
        rect: positionRect,
        image: stateProperties!.trackballMarkerSettingsRenderer.image!,
        fit: BoxFit.fill);
  }
}

/// This method is for to calculate and rendering the length and Offsets of the dashed lines.
void drawDashedLine(
    Canvas canvas, List<double> dashArray, Paint paint, Path path) {
  bool even = false;
  for (int i = 1; i < dashArray.length; i = i + 2) {
    if (dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false) {
    paint.isAntiAlias = false;
    canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(dashArray),
        )!,
        paint);
  } else {
    canvas.drawPath(path, paint);
  }
}

/// To dispose the old segments.
void disposeOldSegments(
    SfCartesianChart chart, SeriesRendererDetails seriesRendererDetails) {
  if (!chart.legend.isVisible! &&
      !seriesRendererDetails.isSelectionEnable &&
      !chart.zoomPanBehavior.enableDoubleTapZooming &&
      !chart.zoomPanBehavior.enableMouseWheelZooming &&
      !chart.zoomPanBehavior.enablePanning &&
      !chart.zoomPanBehavior.enablePinching &&
      !chart.zoomPanBehavior.enableSelectionZooming) {
    seriesRendererDetails.dispose();
  }
}
