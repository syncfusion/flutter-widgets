import 'dart:math' as math;
import 'dart:math' as math_lib;
import 'dart:math';
import 'dart:ui' as dart_ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/core.dart';

import './../../circular_chart/utils/helper.dart';
import './../../common/rendering_details.dart';
import './../../common/user_interaction/selection_behavior.dart';
import './../../common/utils/helper.dart';
import './../axis/axis.dart';
import './../axis/category_axis.dart';
import './../axis/datetime_axis.dart';
import './../axis/datetime_category_axis.dart';
import './../axis/logarithmic_axis.dart';
import './../chart_segment/chart_segment.dart';
import './../chart_series/financial_series_base.dart';
import './../chart_series/series.dart';
import './../chart_series/series_renderer_properties.dart';
import './../chart_series/stacked_series_base.dart';
import './../chart_series/xy_data_series.dart';
import './../common/cartesian_state_properties.dart';
import './../common/common.dart';
import './../common/marker.dart';
import './../common/renderer.dart';
import './../common/segment_properties.dart';
import '../../../charts.dart';

/// Return percentage to value.
num? percentageToValue(String? value, num size) {
  if (value != null) {
    return value.contains('%')
        ? (size / 100) * num.tryParse(value.replaceAll(RegExp('%'), ''))!
        : num.tryParse(value);
  }
  return null;
}

/// Draw the text.
void drawText(Canvas canvas, String text, Offset point, TextStyle style,
    [int? angle, bool? isRtl]) {
  final int maxLines = getMaxLinesContent(text);
  final TextSpan span = TextSpan(text: text, style: style);
  final TextPainter tp = TextPainter(
      text: span,
      textDirection: (isRtl ?? false)
          ? dart_ui.TextDirection.rtl
          : dart_ui.TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: maxLines);
  tp.layout();
  canvas.save();
  canvas.translate(point.dx, point.dy);
  Offset labelOffset = Offset.zero;
  if (angle != null && angle > 0) {
    canvas.rotate(degreeToRadian(angle));
    labelOffset = Offset(-tp.width / 2, -tp.height / 2);
  }
  tp.paint(canvas, labelOffset);
  canvas.restore();
}

/// Draw the path.
void drawDashedPath(Canvas canvas, CustomPaintStyle style, Offset moveToPoint,
    Offset lineToPoint,
    [List<double>? dashArray]) {
  bool even = false;
  final Path path = Path();
  path.moveTo(moveToPoint.dx, moveToPoint.dy);
  path.lineTo(lineToPoint.dx, lineToPoint.dy);
  final Paint paint = Paint();
  paint.strokeWidth = style.strokeWidth;
  paint.color = style.color;
  paint.style = style.paintStyle;

  if (dashArray != null) {
    for (int i = 1; i < dashArray.length; i = i + 2) {
      if (dashArray[i] == 0) {
        even = true;
      }
    }
    if (even == false) {
      canvas.drawPath(
          dashPath(
            path,
            dashArray: CircularIntervalList<double>(dashArray),
          )!,
          paint);
    }
  } else {
    canvas.drawPath(path, paint);
  }
}

/// Find the position of point.
num valueToCoefficient(
    num? value, ChartAxisRendererDetails axisRendererDetails) {
  num result = 0;
  if (axisRendererDetails.visibleRange != null && value != null) {
    final VisibleRange range = axisRendererDetails.visibleRange!;
    // ignore: unnecessary_null_comparison
    if (range != null) {
      result = (value - range.minimum) / (range.delta);
      result = axisRendererDetails.axis.isInversed ? (1 - result) : result;
    }
  }
  return result;
}

/// Find logarithmic values.
num calculateLogBaseValue(num value, num base) =>
    math.log(value) / math.log(base);

/// To check if value is within range.
bool withInRange(num value, ChartAxisRendererDetails axisDetails) {
  final ChartAxis axis = axisDetails.axis;
  final num visibleMinimum = axis is LogarithmicAxis
      ? pow(axis.logBase, axisDetails.visibleRange!.minimum)
      : axisDetails.visibleRange!.minimum;
  final num visibleMaximum = axis is LogarithmicAxis
      ? pow(axis.logBase, axisDetails.visibleRange!.maximum)
      : axisDetails.visibleRange!.maximum;
  return (value <= visibleMaximum) && (value >= visibleMinimum);
}

/// To find the proper series color of each point in waterfall chart,
/// which includes intermediate sum, total sum and negative point.
Color? getWaterfallSeriesColor(WaterfallSeries<dynamic, dynamic> series,
        CartesianChartPoint<dynamic> point, Color? seriesColor) =>
    point.isIntermediateSum!
        ? series.intermediateSumColor ?? seriesColor
        : point.isTotalSum!
            ? series.totalSumColor ?? seriesColor
            : point.yValue < 0 == true
                ? series.negativePointsColor ?? seriesColor
                : seriesColor;

/// Get the location of point.
ChartLocation calculatePoint(
    num x,
    num? y,
    ChartAxisRendererDetails xAxisRendererDetails,
    ChartAxisRendererDetails yAxisRendererDetails,
    bool isInverted,
    CartesianSeries<dynamic, dynamic>? series,
    Rect rect) {
  final ChartAxis xAxis = xAxisRendererDetails.axis;
  final ChartAxis yAxis = yAxisRendererDetails.axis;
  x = xAxis is LogarithmicAxis
      ? calculateLogBaseValue(x > 0 ? x : 0, xAxis.logBase)
      : x;
  y = yAxis is LogarithmicAxis
      ? y != null
          ? calculateLogBaseValue(y > 0 ? y : 0, yAxis.logBase)
          : 0
      : y;
  x = valueToCoefficient(x.isInfinite ? 0 : x, xAxisRendererDetails);
  y = valueToCoefficient(
      y != null
          ? y.isInfinite
              ? 0
              : y
          : y,
      yAxisRendererDetails);
  final num xLength = isInverted ? rect.height : rect.width;
  final num yLength = isInverted ? rect.width : rect.height;
  final double locationX =
      rect.left + (isInverted ? (y * yLength) : (x * xLength));
  final double locationY =
      rect.top + (isInverted ? (1 - x) * xLength : (1 - y) * yLength);
  return ChartLocation(locationX, locationY);
}

/// Calculate the minimum points delta.
num calculateMinPointsDelta(
    ChartAxisRenderer axisRenderer,
    List<CartesianSeriesRenderer> seriesRenderers,
    CartesianStateProperties stateProperties) {
  num minDelta = 1.7976931348623157e+308, minVal;
  num? seriesMin;
  dynamic xValues;
  for (final CartesianSeriesRenderer seriesRenderer in seriesRenderers) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    final CartesianSeries<dynamic, dynamic> series =
        seriesRendererDetails.series;
    num value;
    xValues = <dynamic>[];
    final String seriesType = seriesRendererDetails.seriesType;
    final bool isRectSeries = seriesType.contains('column') ||
        seriesType.contains('stackedbar') ||
        seriesType == 'bar' ||
        seriesType == 'histogram' ||
        seriesType == 'waterfall' ||
        seriesType.contains('candle') ||
        seriesType.contains('hilo') ||
        seriesType.contains('box');
    final ChartAxisRendererDetails axisRendererDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    if (seriesRendererDetails.visible! == true &&
        isRectSeries &&
        ((axisRendererDetails.name == series.xAxisName) ||
            (axisRendererDetails.name ==
                    (stateProperties.chart.primaryXAxis.name ??
                        'primaryXAxis') &&
                series.xAxisName == null) ||
            (axisRendererDetails.name ==
                    AxisHelper.getAxisRendererDetails(
                            stateProperties.chartAxis.primaryXAxisRenderer!)
                        .name &&
                series.xAxisName != null))) {
      xValues = axisRenderer is DateTimeAxisRenderer
          ? seriesRendererDetails.overAllDataPoints
              .map<dynamic>((CartesianChartPoint<dynamic>? point) {
              return point!.xValue;
            }).toList()
          : seriesRendererDetails.dataPoints
              .map<dynamic>((CartesianChartPoint<dynamic> point) {
              return point.xValue;
            }).toList();
      xValues.sort();
      if (xValues.length == 1) {
        DateTime? minDate;
        num? minimumInSeconds;
        if (axisRenderer is DateTimeAxisRenderer) {
          minDate = DateTime.fromMillisecondsSinceEpoch(
              seriesRendererDetails.minimumX! as int);
          minDate = minDate.subtract(const Duration(days: 1));
          minimumInSeconds = minDate.millisecondsSinceEpoch;
        }
        seriesMin = (axisRenderer is DateTimeAxisRenderer &&
                seriesRendererDetails.minimumX ==
                    seriesRendererDetails.maximumX)
            ? minimumInSeconds
            : seriesRendererDetails.minimumX;
        minVal = xValues[0] -
            (seriesMin ?? axisRendererDetails.visibleRange!.minimum);
        if (minVal != 0) {
          minDelta = math.min(minDelta, minVal);
        }
      } else {
        for (int i = 0; i < xValues.length; i++) {
          value = xValues[i];
          // ignore: unnecessary_null_comparison
          if (i > 0 && value != null) {
            minVal = value - xValues[i - 1];
            if (minVal != 0) {
              minDelta = math.min(minDelta, minVal);
            }
          }
        }
      }
    }
  }
  if (minDelta == 1.7976931348623157e+308) {
    minDelta = 1;
  }

  return minDelta;
}

/// Draw legend series type icon.
PaintingStyle calculateLegendShapes(Path path, Rect rect, String seriesType) {
  PaintingStyle style = PaintingStyle.fill;
  switch (seriesType) {
    case 'line':
    case 'fastline':
    case 'stackedline':
    case 'stackedline100':
      style = PaintingStyle.stroke;
      break;
    case 'spline':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.splineSeries);
      style = PaintingStyle.stroke;
      break;
    case 'splinearea':
    case 'splinerangearea':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.splineAreaSeries);
      break;
    case 'bar':
    case 'stackedbar':
    case 'stackedbar100':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.barSeries);
      break;
    case 'column':
    case 'stackedcolumn':
    case 'stackedcolumn100':
    case 'rangecolumn':
    case 'histogram':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.columnSeries);
      break;
    case 'area':
    case 'stackedarea':
    case 'rangearea':
    case 'stackedarea100':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.areaSeries);
      break;
    case 'stepline':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.stepLineSeries);
      style = PaintingStyle.stroke;
      break;
    case 'bubble':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.bubbleSeries);
      break;
    case 'hilo':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.hiloSeries);
      style = PaintingStyle.stroke;
      break;
    case 'hiloopenclose':
    case 'candle':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.candleSeries);
      style = PaintingStyle.stroke;
      break;
    case 'waterfall':
    case 'boxandwhisker':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.waterfallSeries);
      break;
    case 'pie':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.pieSeries);
      break;
    case 'doughnut':
    case 'radialbar':
      break;
    case 'steparea':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.stepAreaSeries);
      break;
    case 'pyramid':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.pyramidSeries);
      break;
    case 'funnel':
      getShapesPath(
          path: path, rect: rect, shapeType: ShapeMarkerType.funnelSeries);
      break;
    default:
      path.addArc(
          Rect.fromLTRB(rect.left - rect.width / 2, rect.top - rect.height / 2,
              rect.left + rect.width / 2, rect.top + rect.height / 2),
          0.0,
          2 * math.pi);
      break;
  }
  return style;
}

/// Calculate bar legend icon path.
void calculateBarTypeIconPath(
    Path path, double x, double y, double width, double height) {
  const num padding = 10;
  path.moveTo(x - (width / 2) - padding / 4, y - 3 * (height / 5));
  path.lineTo(x + 3 * (width / 10), y - 3 * (height / 5));
  path.lineTo(x + 3 * (width / 10), y - 3 * (height / 10));
  path.lineTo(x - (width / 2) - padding / 4, y - 3 * (height / 10));
  path.close();
  path.moveTo(
      x - (width / 2) - (padding / 4), y - (height / 5) + (padding / 20));
  path.lineTo(
      x + (width / 2) + (padding / 4), y - (height / 5) + (padding / 20));
  path.lineTo(
      x + (width / 2) + (padding / 4), y + (height / 10) + (padding / 20));
  path.lineTo(
      x - (width / 2) - (padding / 4), y + (height / 10) + (padding / 20));
  path.close();
  path.moveTo(
      x - (width / 2) - (padding / 4), y + (height / 5) + (padding / 10));
  path.lineTo(x - width / 4, y + (height / 5) + (padding / 10));
  path.lineTo(x - width / 4, y + (height / 2) + (padding / 10));
  path.lineTo(
      x - (width / 2) - (padding / 4), y + (height / 2) + (padding / 10));
  path.close();
}

/// Calculate column legend icon path.
void calculateColumnTypeIconPath(
    Path path, double x, double y, double width, double height) {
  const num padding = 10;
  path.moveTo(x - 3 * (width / 5), y - (height / 5));
  path.lineTo(x + 3 * (-width / 10), y - (height / 5));
  path.lineTo(x + 3 * (-width / 10), y + (height / 2));
  path.lineTo(x - 3 * (width / 5), y + (height / 2));
  path.close();
  path.moveTo(
      x - (width / 10) - (width / 20), y - (height / 4) - (padding / 2));
  path.lineTo(
      x + (width / 10) + (width / 20), y - (height / 4) - (padding / 2));
  path.lineTo(x + (width / 10) + (width / 20), y + (height / 2));
  path.lineTo(x - (width / 10) - (width / 20), y + (height / 2));
  path.close();
  path.moveTo(x + 3 * (width / 10), y);
  path.lineTo(x + 3 * (width / 5), y);
  path.lineTo(x + 3 * (width / 5), y + (height / 2));
  path.lineTo(x + 3 * (width / 10), y + (height / 2));
  path.close();
}

/// Calculate area type legend icon path.
void calculateAreaTypeIconPath(
    Path path, double x, double y, double width, double height) {
  const num padding = 10;
  path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
  path.lineTo(x - (width / 4) - (padding / 8), y - (height / 2));
  path.lineTo(x, y + (height / 4));
  path.lineTo(x + (width / 4) + (padding / 8), y - (height / 2) + (height / 4));
  path.lineTo(x + (height / 2) + (padding / 4), y + (height / 2));
  path.close();
}

/// Calculate stepline legend icon path.
void calculateSteplineIconPath(
    Path path, double x, double y, double width, double height) {
  const num padding = 10;
  path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
  path.lineTo(x - (width / 2) + (width / 10), y + (height / 2));
  path.lineTo(x - (width / 2) + (width / 10), y);
  path.lineTo(x - (width / 10), y);
  path.lineTo(x - (width / 10), y + (height / 2));
  path.lineTo(x + (width / 5), y + (height / 2));
  path.lineTo(x + (width / 5), y - (height / 2));
  path.lineTo(x + (width / 2), y - (height / 2));
  path.lineTo(x + (width / 2), y + (height / 2));
  path.lineTo(x + (width / 2) + (padding / 4), y + (height / 2));
}

/// Calculate steparea legend icon path.
void calculateStepAreaIconPath(
    Path path, double x, double y, double width, double height) {
  const num padding = 10;
  path.moveTo(x - (width / 2) - (padding / 4), y + (height / 2));
  path.lineTo(x - (width / 2) - (padding / 4), y - (height / 4));
  path.lineTo(x - (width / 2) + (width / 10), y - (height / 4));
  path.lineTo(x - (width / 2) + (width / 10), y - (height / 2));
  path.lineTo(x - (width / 10), y - (height / 2));
  path.lineTo(x - (width / 10), y);
  path.lineTo(x + (width / 5), y);
  path.lineTo(x + (width / 5), y - (height / 3));
  path.lineTo(x + (width / 2), y - (height / 3));
  path.lineTo(x + (width / 2), y + (height / 2));
  path.close();
}

/// Calculate pie legend icon path.
void calculatePieIconPath(
    Path path, double x, double y, double width, double height) {
  final double r = math.min(height, width) / 2;
  path.moveTo(x, y);
  path.lineTo(x + r, y);
  path.arcTo(Rect.fromCircle(center: Offset(x, y), radius: r),
      degreesToRadians(0).toDouble(), degreesToRadians(270).toDouble(), false);
  path.close();
  path.moveTo(x + width / 10, y - height / 10);
  path.lineTo(x + r, y - height / 10);
  path.arcTo(Rect.fromCircle(center: Offset(x + 2, y - 2), radius: r),
      degreesToRadians(-5).toDouble(), degreesToRadians(-80).toDouble(), false);
  path.close();
}

/// Calculate pyramid legend icon path.
void calculatePyramidIconPath(
    Path path, double x, double y, double width, double height) {
  path.moveTo(x - width / 2, y + height / 2);
  path.lineTo(x + width / 2, y + height / 2);
  path.lineTo(x, y - height / 2);
  path.lineTo(x - width / 2, y + height / 2);
  path.close();
}

/// Calculate funnel legend icon path.
void calculateFunnelIconPath(
    Path path, double x, double y, double width, double height) {
  path.moveTo(x + width / 2, y - height / 2);
  path.lineTo(x, y + height / 2);
  path.lineTo(x - width / 2, y - height / 2);
  path.lineTo(x + width / 2, y - height / 2);
  path.close();
}

/// Calculate the rect bounds for column series and bar series.
Rect calculateRectangle(
    num x1,
    num? y1,
    num x2,
    num? y2,
    CartesianSeriesRenderer seriesRenderer,
    CartesianStateProperties stateProperties) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final Rect rect = calculatePlotOffset(
      stateProperties.chartAxis.axisClipRect,
      Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
          seriesRendererDetails.yAxisDetails!.axis.plotOffset));
  final bool isInverted = stateProperties.requireInvertedAxis;
  final ChartLocation point1 = calculatePoint(
      x1,
      y1,
      seriesRendererDetails.xAxisDetails!,
      seriesRendererDetails.yAxisDetails!,
      isInverted,
      seriesRendererDetails.series,
      rect);
  final ChartLocation point2 = calculatePoint(
      x2,
      y2,
      seriesRendererDetails.xAxisDetails!,
      seriesRendererDetails.yAxisDetails!,
      isInverted,
      seriesRendererDetails.series,
      rect);
  return Rect.fromLTWH(
      math.min(point1.x, point2.x),
      math.min(point1.y, point2.y),
      (point2.x - point1.x).abs(),
      (point2.y - point1.y).abs());
}

/// Calculate the tracker rect bounds for column series and bar series.
Rect calculateShadowRectangle(
    num x1,
    num y1,
    num x2,
    num y2,
    CartesianSeriesRenderer seriesRenderer,
    CartesianStateProperties stateProperties,
    Offset plotOffset) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final Rect rect = calculatePlotOffset(
      stateProperties.chartAxis.axisClipRect,
      Offset(seriesRendererDetails.xAxisDetails!.axis.plotOffset,
          seriesRendererDetails.yAxisDetails!.axis.plotOffset));
  final bool isInverted = stateProperties.requireInvertedAxis;
  final ChartLocation point1 = calculatePoint(
      x1,
      y1,
      seriesRendererDetails.xAxisDetails!,
      seriesRendererDetails.yAxisDetails!,
      isInverted,
      seriesRendererDetails.series,
      rect);
  final ChartLocation point2 = calculatePoint(
      x2,
      y2,
      seriesRendererDetails.xAxisDetails!,
      seriesRendererDetails.yAxisDetails!,
      isInverted,
      seriesRendererDetails.series,
      rect);
  final bool isColumn = seriesRendererDetails.seriesType == 'column';
  final bool isHistogram = seriesRendererDetails.seriesType == 'histogram';
  final bool isStackedColumn =
      seriesRendererDetails.seriesType == 'stackedcolumn';
  final bool isStackedBar = seriesRendererDetails.seriesType == 'stackedbar';
  final bool isRangeColumn = seriesRendererDetails.seriesType == 'rangecolumn';
  ColumnSeries<dynamic, dynamic>? columnSeries;
  BarSeries<dynamic, dynamic>? barSeries;
  StackedColumnSeries<dynamic, dynamic>? stackedColumnSeries;
  StackedBarSeries<dynamic, dynamic>? stackedBarSeries;
  RangeColumnSeries<dynamic, dynamic>? rangeColumnSeries;
  HistogramSeries<dynamic, dynamic>? histogramSeries;
  if (seriesRendererDetails.seriesType == 'column') {
    columnSeries =
        seriesRendererDetails.series as ColumnSeries<dynamic, dynamic>;
  } else if (seriesRendererDetails.seriesType == 'bar') {
    barSeries = seriesRendererDetails.series as BarSeries<dynamic, dynamic>;
  } else if (seriesRendererDetails.seriesType == 'stackedcolumn') {
    stackedColumnSeries =
        seriesRendererDetails.series as StackedColumnSeries<dynamic, dynamic>;
  } else if (seriesRendererDetails.seriesType == 'stackedbar') {
    stackedBarSeries =
        seriesRendererDetails.series as StackedBarSeries<dynamic, dynamic>;
  } else if (seriesRendererDetails.seriesType == 'rangecolumn') {
    rangeColumnSeries =
        seriesRendererDetails.series as RangeColumnSeries<dynamic, dynamic>;
  } else if (seriesRendererDetails.seriesType == 'histogram') {
    histogramSeries =
        seriesRendererDetails.series as HistogramSeries<dynamic, dynamic>;
  }
  return !stateProperties.chart.isTransposed
      ? _getNormalShadowRect(
          rect,
          isColumn,
          isHistogram,
          isRangeColumn,
          isStackedColumn,
          isStackedBar,
          stateProperties,
          plotOffset,
          point1,
          point2,
          columnSeries,
          barSeries,
          stackedColumnSeries,
          stackedBarSeries,
          rangeColumnSeries,
          histogramSeries)
      : _getTransposedShadowRect(
          rect,
          isColumn,
          isHistogram,
          isRangeColumn,
          isStackedColumn,
          isStackedBar,
          stateProperties,
          plotOffset,
          point1,
          point2,
          columnSeries,
          barSeries,
          stackedColumnSeries,
          stackedBarSeries,
          rangeColumnSeries,
          histogramSeries);
}

/// Calculate shadow rectangle for normal rect series.
Rect _getNormalShadowRect(
    Rect rect,
    bool isColumn,
    bool isHistogram,
    bool isRangeColumn,
    bool isStackedColumn,
    bool isStackedBar,
    CartesianStateProperties stateProperties,
    Offset plotOffset,
    ChartLocation point1,
    ChartLocation point2,
    ColumnSeries<dynamic, dynamic>? columnSeries,
    BarSeries<dynamic, dynamic>? barSeries,
    StackedColumnSeries<dynamic, dynamic>? stackedColumnSeries,
    StackedBarSeries<dynamic, dynamic>? stackedBarSeries,
    RangeColumnSeries<dynamic, dynamic>? rangeColumnSeries,
    HistogramSeries<dynamic, dynamic>? histogramSeries) {
  return Rect.fromLTWH(
      isColumn
          ? math.min(point1.x, point2.x) +
              (-columnSeries!.trackBorderWidth - columnSeries.trackPadding)
          : isHistogram
              ? math.min(point1.x, point2.x) +
                  (-histogramSeries!.trackBorderWidth -
                      histogramSeries.trackPadding)
              : isRangeColumn
                  ? math.min(point1.x, point2.x) +
                      (-rangeColumnSeries!.trackBorderWidth -
                          rangeColumnSeries.trackPadding)
                  : isStackedColumn
                      ? math.min(point1.x, point2.x) +
                          (-stackedColumnSeries!.trackBorderWidth -
                              stackedColumnSeries.trackPadding)
                      : isStackedBar
                          ? stateProperties.chartAxis.axisClipRect.left
                          : stateProperties.chartAxis.axisClipRect.left,
      isColumn || isHistogram || isRangeColumn
          ? rect.top
          : isStackedColumn
              ? rect.top
              : isStackedBar
                  ? (math.min(point1.y, point2.y) -
                      stackedBarSeries!.trackBorderWidth -
                      stackedBarSeries.trackPadding)
                  : (math.min(point1.y, point2.y) -
                      barSeries!.trackBorderWidth -
                      barSeries.trackPadding),
      isColumn
          ? (point2.x - point1.x).abs() +
              (columnSeries!.trackBorderWidth * 2) +
              columnSeries.trackPadding * 2
          : isHistogram
              ? (point2.x - point1.x).abs() +
                  (histogramSeries!.trackBorderWidth * 2) +
                  histogramSeries.trackPadding * 2
              : isRangeColumn
                  ? (point2.x - point1.x).abs() +
                      (rangeColumnSeries!.trackBorderWidth * 2) +
                      rangeColumnSeries.trackPadding * 2
                  : isStackedColumn
                      ? (point2.x - point1.x).abs() +
                          (stackedColumnSeries!.trackBorderWidth * 2) +
                          stackedColumnSeries.trackPadding * 2
                      : isStackedBar
                          ? stateProperties.chartAxis.axisClipRect.width
                          : stateProperties.chartAxis.axisClipRect.width,
      isColumn || isHistogram || isRangeColumn
          ? (stateProperties.chartAxis.axisClipRect.height - 2 * plotOffset.dy)
          : isStackedColumn
              ? (stateProperties.chartAxis.axisClipRect.height -
                  2 * plotOffset.dy)
              : isStackedBar
                  ? (point2.y - point1.y).abs() +
                      stackedBarSeries!.trackBorderWidth * 2 +
                      stackedBarSeries.trackPadding * 2
                  : (point2.y - point1.y).abs() +
                      barSeries!.trackBorderWidth * 2 +
                      barSeries.trackPadding * 2);
}

/// Calculate shadow rectangle for transposed rect series.
Rect _getTransposedShadowRect(
    Rect rect,
    bool isColumn,
    bool isHistogram,
    bool isRangeColumn,
    bool isStackedColumn,
    bool isStackedBar,
    CartesianStateProperties stateProperties,
    Offset plotOffset,
    ChartLocation point1,
    ChartLocation point2,
    ColumnSeries<dynamic, dynamic>? columnSeries,
    BarSeries<dynamic, dynamic>? barSeries,
    StackedColumnSeries<dynamic, dynamic>? stackedColumnSeries,
    StackedBarSeries<dynamic, dynamic>? stackedBarSeries,
    RangeColumnSeries<dynamic, dynamic>? rangeColumnSeries,
    HistogramSeries<dynamic, dynamic>? histogramSeries) {
  return Rect.fromLTWH(
      isColumn || isRangeColumn || isHistogram
          ? stateProperties.chartAxis.axisClipRect.left
          : isStackedColumn
              ? stateProperties.chartAxis.axisClipRect.left
              : isStackedBar
                  ? math.min(point1.x, point2.x) +
                      (-stackedBarSeries!.trackBorderWidth -
                          stackedBarSeries.trackPadding)
                  : math.min(point1.x, point2.x) +
                      (-barSeries!.trackBorderWidth - barSeries.trackPadding),
      isColumn
          ? (math.min(point1.y, point2.y) -
              columnSeries!.trackBorderWidth -
              columnSeries.trackPadding)
          : isHistogram
              ? (math.min(point1.y, point2.y) -
                  histogramSeries!.trackBorderWidth -
                  histogramSeries.trackPadding)
              : isRangeColumn
                  ? (math.min(point1.y, point2.y) -
                      rangeColumnSeries!.trackBorderWidth -
                      rangeColumnSeries.trackPadding)
                  : isStackedColumn
                      ? (math.min(point1.y, point2.y) -
                          stackedColumnSeries!.trackBorderWidth -
                          stackedColumnSeries.trackPadding)
                      : isStackedBar
                          ? rect.top
                          : rect.top,
      isColumn || isRangeColumn || isHistogram
          ? stateProperties.chartAxis.axisClipRect.width
          : isStackedColumn
              ? stateProperties.chartAxis.axisClipRect.width
              : isStackedBar
                  ? (point2.x - point1.x).abs() +
                      (stackedBarSeries!.trackBorderWidth * 2) +
                      stackedBarSeries.trackPadding * 2
                  : (point2.x - point1.x).abs() +
                      (barSeries!.trackBorderWidth * 2) +
                      barSeries.trackPadding * 2,
      isColumn
          ? ((point2.y - point1.y).abs() +
              columnSeries!.trackBorderWidth * 2 +
              columnSeries.trackPadding * 2)
          : isHistogram
              ? ((point2.y - point1.y).abs() +
                  histogramSeries!.trackBorderWidth * 2 +
                  histogramSeries.trackPadding * 2)
              : isRangeColumn
                  ? (point2.y - point1.y).abs() +
                      rangeColumnSeries!.trackBorderWidth * 2 +
                      rangeColumnSeries.trackPadding * 2
                  : isStackedColumn
                      ? (point2.y - point1.y).abs() +
                          stackedColumnSeries!.trackBorderWidth * 2 +
                          stackedColumnSeries.trackPadding * 2
                      : isStackedBar
                          ? (stateProperties.chartAxis.axisClipRect.height -
                              2 * plotOffset.dy)
                          : (stateProperties.chartAxis.axisClipRect.height -
                              2 * plotOffset.dy));
}

/// Calculate the side by side range for column and bar series.
VisibleRange calculateSideBySideInfo(CartesianSeriesRenderer seriesRenderer,
    CartesianStateProperties stateProperties) {
  num? rectPosition;
  num? count;
  num seriesSpacing;
  num? pointSpacing;
  final SfCartesianChart chart = stateProperties.chart;
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  if (seriesRendererDetails.seriesType == 'column' &&
      chart.enableSideBySideSeriesPlacement) {
    final ColumnSeriesRenderer columnSeriesRenderer =
        seriesRenderer as ColumnSeriesRenderer;
    _calculateSideBySidePositions(columnSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = seriesRendererDetails.isIndicator
        ? stateProperties.sideBySideIndicatorCount
        : stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'histogram' &&
      chart.enableSideBySideSeriesPlacement) {
    final HistogramSeriesRenderer histogramSeriesRenderer =
        seriesRenderer as HistogramSeriesRenderer;
    _calculateSideBySidePositions(histogramSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'bar' &&
      chart.enableSideBySideSeriesPlacement) {
    final BarSeriesRenderer barSeriesRenderer =
        seriesRenderer as BarSeriesRenderer;
    _calculateSideBySidePositions(barSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if ((seriesRendererDetails.seriesType.contains('stackedcolumn') ==
              true ||
          seriesRendererDetails.seriesType.contains('stackedbar') == true) &&
      chart.enableSideBySideSeriesPlacement) {
    final StackedSeriesRenderer stackedRectSeriesRenderer =
        seriesRenderer as StackedSeriesRenderer;
    _calculateSideBySidePositions(stackedRectSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'rangecolumn' &&
      chart.enableSideBySideSeriesPlacement) {
    final RangeColumnSeriesRenderer rangeColumnSeriesRenderer =
        seriesRenderer as RangeColumnSeriesRenderer;
    _calculateSideBySidePositions(rangeColumnSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'hilo' &&
      chart.enableSideBySideSeriesPlacement) {
    final HiloSeriesRenderer hiloSeriesRenderer =
        seriesRenderer as HiloSeriesRenderer;
    _calculateSideBySidePositions(hiloSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'hiloopenclose' &&
      chart.enableSideBySideSeriesPlacement) {
    final HiloOpenCloseSeriesRenderer hiloOpenCloseSeriesRenderer =
        seriesRenderer as HiloOpenCloseSeriesRenderer;
    _calculateSideBySidePositions(hiloOpenCloseSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'candle' &&
      chart.enableSideBySideSeriesPlacement) {
    final CandleSeriesRenderer candleSeriesRenderer =
        seriesRenderer as CandleSeriesRenderer;
    _calculateSideBySidePositions(candleSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'boxandwhisker' &&
      chart.enableSideBySideSeriesPlacement) {
    final BoxAndWhiskerSeriesRenderer boxAndWhiskerSeriesRenderer =
        seriesRenderer as BoxAndWhiskerSeriesRenderer;
    _calculateSideBySidePositions(boxAndWhiskerSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  } else if (seriesRendererDetails.seriesType == 'waterfall' &&
      chart.enableSideBySideSeriesPlacement) {
    final WaterfallSeriesRenderer waterfallSeriesRenderer =
        seriesRenderer as WaterfallSeriesRenderer;
    _calculateSideBySidePositions(waterfallSeriesRenderer, stateProperties);
    rectPosition = seriesRendererDetails.rectPosition;
    count = stateProperties.sideBySideSeriesCount;
  }

  if (seriesRendererDetails.seriesType == 'column') {
    final ColumnSeries<dynamic, dynamic> columnSeries =
        series as ColumnSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? columnSeries.spacing : 0;
    assert(columnSeries.width == null || columnSeries.width! <= 1,
        'The width of the column series must be less than or equal 1.');
    pointSpacing = columnSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'histogram') {
    final HistogramSeries<dynamic, dynamic> histogramSeries =
        series as HistogramSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? histogramSeries.spacing : 0;
    assert(histogramSeries.width! <= 1,
        'The width of the histogram series must be less than or equal 1.');
    pointSpacing = histogramSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'stackedcolumn' ||
      seriesRendererDetails.seriesType == 'stackedcolumn100' ||
      seriesRendererDetails.seriesType == 'stackedbar' ||
      seriesRendererDetails.seriesType == 'stackedbar100') {
    final StackedSeriesBase<dynamic, dynamic> stackedRectSeries =
        series as StackedSeriesBase<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? stackedRectSeries.spacing : 0;
    pointSpacing = stackedRectSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'rangecolumn') {
    final RangeColumnSeries<dynamic, dynamic> rangeColumnSeries =
        series as RangeColumnSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? rangeColumnSeries.spacing : 0;
    assert(rangeColumnSeries.width == null || rangeColumnSeries.width! <= 1,
        'The width of the range column series must be less than or equal 1.');
    pointSpacing = rangeColumnSeries.width;
  } else if (seriesRendererDetails.seriesType == 'hilo') {
    final HiloSeries<dynamic, dynamic> hiloSeries =
        series as HiloSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? hiloSeries.spacing : 0;
    pointSpacing = hiloSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'hiloopenclose') {
    final HiloOpenCloseSeries<dynamic, dynamic> hiloOpenCloseSeries =
        series as HiloOpenCloseSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? hiloOpenCloseSeries.spacing : 0;
    pointSpacing = hiloOpenCloseSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'candle') {
    final CandleSeries<dynamic, dynamic> candleSeries =
        series as CandleSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? candleSeries.spacing : 0;
    pointSpacing = candleSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'boxandwhisker') {
    final BoxAndWhiskerSeries<dynamic, dynamic> boxAndWhiskerSeries =
        series as BoxAndWhiskerSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? boxAndWhiskerSeries.spacing : 0;
    assert(boxAndWhiskerSeries.width! <= 1,
        'The width of the box plot series must be less than or equal to 1.');
    pointSpacing = boxAndWhiskerSeries.width!;
  } else if (seriesRendererDetails.seriesType == 'waterfall') {
    final WaterfallSeries<dynamic, dynamic> waterfallSeries =
        series as WaterfallSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? waterfallSeries.spacing : 0;
    assert(waterfallSeries.width! <= 1,
        'The width of the waterfall series must be less than or equal to 1.');
    pointSpacing = waterfallSeries.width!;
  } else {
    final BarSeries<dynamic, dynamic> barSeries =
        series as BarSeries<dynamic, dynamic>;
    seriesSpacing =
        chart.enableSideBySideSeriesPlacement ? barSeries.spacing : 0;
    // assert(barSeries.width == null || barSeries.width! <= 1,
    //     'The width of the bar series must be less than or equal to 1.');
    pointSpacing = barSeries.width;
  }
  final num position =
      !chart.enableSideBySideSeriesPlacement ? 0 : rectPosition!;
  final num rectCount = !chart.enableSideBySideSeriesPlacement ? 1 : count!;

  /// Gets the minimum point delta in series.
  final num minPointsDelta = seriesRendererDetails.minDelta ??
      calculateMinPointsDelta(seriesRendererDetails.xAxisDetails!.axisRenderer,
          stateProperties.seriesRenderers, stateProperties);
  final num width = minPointsDelta * pointSpacing!;
  final num location = position / rectCount - 0.5;
  VisibleRange doubleRange = VisibleRange(location, location + (1 / rectCount));

  /// Side by side range will be calculated based on calculated width.
  if ((doubleRange.minimum is num) && (doubleRange.maximum is num)) {
    doubleRange =
        VisibleRange(doubleRange.minimum * width, doubleRange.maximum * width);
    doubleRange.delta = doubleRange.maximum - doubleRange.minimum;
    final num radius = seriesSpacing * doubleRange.delta;
    doubleRange = VisibleRange(
        doubleRange.minimum + radius / 2, doubleRange.maximum - radius / 2);
    doubleRange.delta = doubleRange.maximum - doubleRange.minimum;
  }
  return doubleRange;
}

/// The method returns rotated text location for the given angle.
ChartLocation getRotatedTextLocation(double pointX, double pointY,
    String labelText, TextStyle textStyle, int angle, ChartAxis axis) {
  if (angle > 0) {
    final Size textSize = measureText(labelText, textStyle);
    final Size rotateTextSize = measureText(labelText, textStyle, angle);

    /// label rotation for 0 to 90.
    pointX += ((rotateTextSize.width - textSize.width).abs() / 2) +
        (((angle > 90 ? 90 : angle) / 90) * textSize.height);

    /// label rotation for 90 to 180.
    pointX += (angle > 90) ? (rotateTextSize.width - textSize.height).abs() : 0;
    pointY += (angle > 90)
        ? (angle / 180) * textSize.height -
            (((180 - angle) / 180) * textSize.height)
        : 0;

    /// label rotation 180 to 270.
    pointX -= (angle > 180) ? (angle / 270) * textSize.height : 0;
    pointY += (angle > 180)
        ? (rotateTextSize.height - textSize.height).abs() -
            (angle / 270) * textSize.height
        : 0;

    /// Label rotation 270 to 360.
    pointX -=
        (angle > 270) ? (rotateTextSize.width - textSize.height).abs() : 0;
    pointY -= (angle > 270)
        ? (((angle - 270) / 90) * textSize.height) +
            (textSize.height * ((angle - 270) / 90)) / 2
        : 0;
// ignore: unnecessary_null_comparison
    if (axis != null && axis.labelRotation.isNegative) {
      final num rotation = axis.labelRotation.abs();
      if (rotation > 15 && rotation < 90) {
        pointX -= (rotateTextSize.width - textSize.height).abs() / 2;
        pointY -= ((90 - rotation) / 90) / 2 * textSize.height;
      } else if (rotation > 90 && rotation < 180) {
        pointX += rotation > 164
            ? 0
            : (rotateTextSize.width - textSize.height).abs() / 2 +
                ((rotation - 90) / 90) / 2 * textSize.height;
        pointY += (rotation / 180) / 2 * textSize.height;
      } else if (rotation > 195 && rotation < 270) {
        pointX -= (rotateTextSize.width - textSize.height).abs() / 2;
      } else if (rotation > 270 && rotation < 360) {
        pointX += (rotateTextSize.width - textSize.height).abs() / 2;
      }
    }
  }
  return ChartLocation(pointX, pointY);
}

/// Checking whether new series and old series are similar.
bool isSameSeries(dynamic oldSeries, dynamic newSeries) {
  return oldSeries.runtimeType == newSeries.runtimeType &&
      oldSeries.key == newSeries.key;
}

/// Calculate the side by side position for rect series.
void _calculateSideBySidePositions(CartesianSeriesRenderer seriesRenderer,
    CartesianStateProperties stateProperties) {
  final List<CartesianSeriesRenderer> seriesCollection =
      _findRectSeriesCollection(stateProperties);
  int rectCount = 0;
  int indicatorPosition = 0;
  num? position;
  List<_StackingGroup>? stackingGroupPos;
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  for (final dynamic seriesRenderer in seriesCollection) {
    if (seriesRenderer is ColumnSeriesRenderer ||
        seriesRenderer is BarSeriesRenderer ||
        seriesRenderer is RangeColumnSeriesRenderer ||
        seriesRenderer is HiloSeriesRenderer ||
        seriesRenderer is HiloOpenCloseSeriesRenderer ||
        seriesRenderer is HistogramSeriesRenderer ||
        seriesRenderer is CandleSeriesRenderer ||
        seriesRenderer is BoxAndWhiskerSeriesRenderer ||
        seriesRenderer is WaterfallSeriesRenderer) {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      seriesRendererDetails.rectPosition =
          seriesRendererDetails.isIndicator ? indicatorPosition++ : rectCount++;
    }
  }
  if (seriesRenderer is StackedSeriesRenderer) {
    for (int i = 0; i < seriesCollection.length; i++) {
      StackedSeriesBase<dynamic, dynamic>? series;
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesCollection[i]);
      if (seriesCollection[i] is StackedSeriesRenderer) {
        seriesRenderer = seriesCollection[i];
        series =
            seriesRendererDetails.series as StackedSeriesBase<dynamic, dynamic>;
      }
      // ignore: unnecessary_null_comparison
      if (seriesRenderer != null && seriesRenderer is StackedSeriesRenderer) {
        final String groupName = series!.groupName;
        // ignore: unnecessary_null_comparison
        if (groupName != null) {
          stackingGroupPos ??= <_StackingGroup>[];
          if (stackingGroupPos.isEmpty) {
            seriesRendererDetails.rectPosition = rectCount;
            stackingGroupPos.add(_StackingGroup(groupName, rectCount++));
          } else if (stackingGroupPos.isNotEmpty) {
            for (int j = 0; j < stackingGroupPos.length; j++) {
              if (groupName == stackingGroupPos[j].groupName) {
                seriesRendererDetails.rectPosition =
                    stackingGroupPos[j].stackCount;
                break;
              } else if (groupName != stackingGroupPos[j].groupName &&
                  j == stackingGroupPos.length - 1) {
                seriesRendererDetails.rectPosition = rectCount;
                stackingGroupPos.add(_StackingGroup(groupName, rectCount++));
                break;
              }
            }
          }
        } else {
          if (position == null) {
            seriesRendererDetails.rectPosition = rectCount;
            position = rectCount++;
          } else {
            seriesRendererDetails.rectPosition = position;
          }
        }
      }
    }
  }
  if (seriesRendererDetails.seriesType.contains('stackedcolumn') == true ||
      seriesRendererDetails.seriesType.contains('stackedbar') == true) {
    stateProperties.sideBySideSeriesCount = rectCount;
  }
}

/// Find the column and bar series collection in axes.
List<CartesianSeriesRenderer> findSeriesCollection(
    CartesianStateProperties stateProperties,
    //ignore: unused_element
    [bool? isRect]) {
  final List<CartesianSeriesRenderer> seriesRendererCollection =
      <CartesianSeriesRenderer>[];
  for (int xAxisIndex = 0;
      xAxisIndex < stateProperties.chartAxis.horizontalAxisRenderers.length;
      xAxisIndex++) {
    final ChartAxisRenderer xAxisRenderer =
        stateProperties.chartAxis.horizontalAxisRenderers[xAxisIndex];
    final ChartAxisRendererDetails xAxisRendererDetails =
        AxisHelper.getAxisRendererDetails(xAxisRenderer);
    for (int xSeriesIndex = 0;
        xSeriesIndex < xAxisRendererDetails.seriesRenderers.length;
        xSeriesIndex++) {
      final CartesianSeriesRenderer xAxisSeriesRenderer =
          xAxisRendererDetails.seriesRenderers[xSeriesIndex];
      for (int yAxisIndex = 0;
          yAxisIndex < stateProperties.chartAxis.verticalAxisRenderers.length;
          yAxisIndex++) {
        final ChartAxisRenderer yAxisRenderer =
            stateProperties.chartAxis.verticalAxisRenderers[yAxisIndex];
        final ChartAxisRendererDetails yAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(yAxisRenderer);
        for (int ySeriesIndex = 0;
            ySeriesIndex < yAxisRendererDetails.seriesRenderers.length;
            ySeriesIndex++) {
          final CartesianSeriesRenderer yAxisSeriesRenderer =
              yAxisRendererDetails.seriesRenderers[ySeriesIndex];
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(xAxisSeriesRenderer);
          if (xAxisSeriesRenderer == yAxisSeriesRenderer &&
              (seriesRendererDetails.seriesType.contains('column') == true ||
                  seriesRendererDetails.seriesType.contains('bar') == true ||
                  seriesRendererDetails.seriesType.contains('hilo') == true ||
                  seriesRendererDetails.seriesType.contains('candle') == true ||
                  seriesRendererDetails.seriesType.contains('stackedarea') ==
                      true ||
                  seriesRendererDetails.seriesType.contains('stackedline') ==
                      true ||
                  seriesRendererDetails.seriesType == 'histogram' ||
                  seriesRendererDetails.seriesType == 'boxandwhisker') &&
              seriesRendererDetails.visible! == true) {
            if (!seriesRendererCollection.contains(yAxisSeriesRenderer)) {
              seriesRendererCollection.add(yAxisSeriesRenderer);
            }
          }
        }
      }
    }
  }
  return seriesRendererCollection;
}

/// Convert normal rect to rounded rect by using border radius.
RRect getRRectFromRect(Rect rect, BorderRadius borderRadius) {
  return RRect.fromRectAndCorners(
    rect,
    bottomLeft: borderRadius.bottomLeft,
    bottomRight: borderRadius.bottomRight,
    topLeft: borderRadius.topLeft,
    topRight: borderRadius.topRight,
  );
}

/// Find the rect series collection in axes.
List<CartesianSeriesRenderer> _findRectSeriesCollection(
    CartesianStateProperties stateProperties) {
  int rectSeriesCount = 0;
  int rectIndicatorCount = 0;
  final List<CartesianSeriesRenderer> seriesRenderCollection =
      <CartesianSeriesRenderer>[];
  for (int xAxisIndex = 0;
      xAxisIndex < stateProperties.chartAxis.horizontalAxisRenderers.length;
      xAxisIndex++) {
    final ChartAxisRenderer xAxisRenderer =
        stateProperties.chartAxis.horizontalAxisRenderers[xAxisIndex];
    final ChartAxisRendererDetails xAxisRendererDetails =
        AxisHelper.getAxisRendererDetails(xAxisRenderer);
    for (int xSeriesIndex = 0;
        xSeriesIndex < xAxisRendererDetails.seriesRenderers.length;
        xSeriesIndex++) {
      final CartesianSeriesRenderer xAxisSeriesRenderer =
          xAxisRendererDetails.seriesRenderers[xSeriesIndex];
      for (int yAxisIndex = 0;
          yAxisIndex < stateProperties.chartAxis.verticalAxisRenderers.length;
          yAxisIndex++) {
        final ChartAxisRenderer yAxisRenderer =
            stateProperties.chartAxis.verticalAxisRenderers[yAxisIndex];
        final ChartAxisRendererDetails yAxisRendererDetails =
            AxisHelper.getAxisRendererDetails(yAxisRenderer);
        for (int ySeriesIndex = 0;
            ySeriesIndex < yAxisRendererDetails.seriesRenderers.length;
            ySeriesIndex++) {
          final CartesianSeriesRenderer yAxisSeriesRenderer =
              yAxisRendererDetails.seriesRenderers[ySeriesIndex];
          final SeriesRendererDetails seriesRendererDetails =
              SeriesHelper.getSeriesRendererDetails(xAxisSeriesRenderer);
          if (xAxisSeriesRenderer == yAxisSeriesRenderer &&
              (seriesRendererDetails.seriesType.contains('column') == true ||
                  seriesRendererDetails.seriesType.contains('waterfall') ==
                      true ||
                  (seriesRendererDetails.seriesType.contains('bar') == true &&
                      !seriesRendererDetails.seriesType.contains('errorbar')) ||
                  seriesRendererDetails.seriesType.contains('hilo') == true ||
                  seriesRendererDetails.seriesType == 'candle' ||
                  seriesRendererDetails.seriesType == 'histogram' ||
                  seriesRendererDetails.seriesType == 'boxandwhisker') &&
              seriesRendererDetails.visible! == true) {
            if (!seriesRenderCollection.contains(yAxisSeriesRenderer)) {
              seriesRenderCollection.add(yAxisSeriesRenderer);
              if (seriesRendererDetails.isIndicator) {
                rectIndicatorCount++;
              } else {
                rectSeriesCount++;
              }
            }
          }
        }
      }
    }
  }
  stateProperties.sideBySideSeriesCount = rectSeriesCount;
  stateProperties.sideBySideIndicatorCount = rectIndicatorCount;
  return seriesRenderCollection;
}

/// To calculate plot offset.
Rect calculatePlotOffset(Rect axisClipRect, Offset plotOffset) => Rect.fromLTWH(
    axisClipRect.left + plotOffset.dx,
    axisClipRect.top + plotOffset.dy,
    axisClipRect.width - 2 * plotOffset.dx,
    axisClipRect.height - 2 * plotOffset.dy);

/// Get gradient fill colors.
Paint getLinearGradientPaint(
    LinearGradient gradientFill, Rect region, bool isInvertedAxis) {
  Paint gradientPaint;
  gradientPaint = Paint()
    ..shader = gradientFill.createShader(region)
    ..style = PaintingStyle.fill;
  return gradientPaint;
}

/// Method to get the shader paint.
Paint getShaderPaint(Shader shader) {
  Paint shaderPaint;
  shaderPaint = Paint()
    ..shader = shader
    ..style = PaintingStyle.fill;
  return shaderPaint;
}

/// Gets the the actual label value for tooltip and data label etc.
String getLabelValue(dynamic value, dynamic axis, [int? showDigits]) {
  if (value.toString().split('.').length > 1) {
    final String str = value.toString();
    final List<dynamic> list = str.split('.');
    value = double.parse(value.toStringAsFixed(showDigits ?? 3));
    value = (list[1] == '0' ||
            list[1] == '00' ||
            list[1] == '000' ||
            list[1] == '0000' ||
            list[1] == '00000' ||
            list[1] == '000000' ||
            list[1] == '0000000')
        ? value.round()
        : value;
  }
  final dynamic text = axis is NumericAxis && axis.numberFormat != null
      ? axis.numberFormat!.format(value)
      : value;
  return ((axis.labelFormat != null && axis.labelFormat != '')
      ? axis.labelFormat.replaceAll(RegExp('{value}'), text.toString())
      : text.toString()) as String;
}

/// Calculate the X value from the current screen point.
double pointToXValue(bool requireInvertedAxis, ChartAxisRenderer axisRenderer,
    Rect rect, double x, double y) {
  // ignore: unnecessary_null_comparison
  if (axisRenderer != null) {
    if (!requireInvertedAxis) {
      return _coefficientToValue(x / rect.width, axisRenderer);
    }
    return _coefficientToValue(1 - (y / rect.height), axisRenderer);
  }
  return double.nan;
}

/// Calculate the Y value from the current screen point.
// ignore: unused_element
double pointToYValue(bool requireInvertedAxis, ChartAxisRenderer axisRenderer,
    Rect rect, double x, double y) {
  // ignore: unnecessary_null_comparison
  if (axisRenderer != null) {
    if (!requireInvertedAxis) {
      return _coefficientToValue(1 - (y / rect.height), axisRenderer);
    }
    return _coefficientToValue(x / rect.width, axisRenderer);
  }
  return double.nan;
}

/// Returns coefficient-based value.
double _coefficientToValue(double coefficient, ChartAxisRenderer axisRenderer) {
  double result;
  final ChartAxisRendererDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(axisRenderer);
  coefficient =
      axisRendererDetails.axis.isInversed ? 1 - coefficient : coefficient;
  result = axisRendererDetails.visibleRange!.minimum +
      (axisRendererDetails.visibleRange!.delta * coefficient);
  return result;
}

/// To repaint chart and axes.
void needsRepaintChart(
    CartesianStateProperties stateProperties,
    List<ChartAxisRenderer> oldChartAxisRenderers,
    List<CartesianSeriesRenderer> oldChartSeriesRenderers) {
  if (stateProperties.chartSeries.visibleSeriesRenderers.length ==
      oldChartSeriesRenderers.length) {
    for (int seriesIndex = 0;
        seriesIndex < stateProperties.seriesRenderers.length;
        seriesIndex++) {
      _canRepaintChartSeries(
          stateProperties, oldChartSeriesRenderers, seriesIndex);
    }
  } else {
    // ignore: avoid_function_literals_in_foreach_calls
    stateProperties.seriesRenderers.forEach(
        (CartesianSeriesRenderer seriesRenderer) =>
            SeriesHelper.getSeriesRendererDetails(seriesRenderer).needsRepaint =
                true);
  }
  if (stateProperties.chartAxis.axisRenderersCollection.length ==
      oldChartAxisRenderers.length) {
    for (int axisIndex = 0;
        axisIndex < oldChartAxisRenderers.length;
        axisIndex++) {
      _canRepaintAxis(stateProperties, oldChartAxisRenderers, axisIndex);
      if (stateProperties.chartAxis.needsRepaint) {
        break;
      }
    }
  } else {
    stateProperties.chartAxis.needsRepaint = true;
  }
}

/// To check series repaint.
void _canRepaintChartSeries(CartesianStateProperties stateProperties,
    List<CartesianSeriesRenderer> oldChartSeriesRenderers, int seriesIndex) {
  final CartesianSeriesRenderer seriesRenderer =
      stateProperties.seriesRenderers[seriesIndex];
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final CartesianSeriesRenderer oldWidgetSeriesRenderer =
      oldChartSeriesRenderers[seriesIndex];
  final SeriesRendererDetails oldSeriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(oldWidgetSeriesRenderer);
  final CartesianSeries<dynamic, dynamic> oldWidgetSeries =
      oldSeriesRendererDetails.series;
  if (series.animationDuration != oldWidgetSeries.animationDuration ||
      oldSeriesRendererDetails.stateProperties.chartSeries !=
          stateProperties.chartSeries ||
      series.color?.value != oldWidgetSeries.color?.value ||
      series.width != oldWidgetSeries.width ||
      series.isVisible != oldWidgetSeries.isVisible ||
      series.enableTooltip != oldWidgetSeries.enableTooltip ||
      series.name != oldWidgetSeries.name ||
      series.gradient != oldWidgetSeries.gradient ||
      seriesRendererDetails.xAxisDetails!.visibleRange?.delta !=
          oldSeriesRendererDetails.xAxisDetails!.visibleRange?.delta ||
      seriesRendererDetails.xAxisDetails!.visibleRange?.maximum !=
          oldSeriesRendererDetails.xAxisDetails!.visibleRange?.maximum ||
      seriesRendererDetails.xAxisDetails!.visibleRange?.minimum !=
          oldSeriesRendererDetails.xAxisDetails!.visibleRange?.minimum ||
      seriesRendererDetails.xAxisDetails!.visibleRange?.interval !=
          oldSeriesRendererDetails.xAxisDetails!.visibleRange?.interval ||
      seriesRendererDetails.xAxisDetails!.axis.isVisible !=
          oldSeriesRendererDetails.xAxisDetails!.axis.isVisible ||
      seriesRendererDetails.xAxisDetails!.bounds !=
          oldSeriesRendererDetails.xAxisDetails!.bounds ||
      seriesRendererDetails.xAxisDetails!.axis.isInversed !=
          oldSeriesRendererDetails.xAxisDetails!.axis.isInversed ||
      seriesRendererDetails.xAxisDetails!.axis.desiredIntervals !=
          oldSeriesRendererDetails.xAxisDetails!.axis.desiredIntervals ||
      seriesRendererDetails.xAxisDetails!.axis.enableAutoIntervalOnZooming !=
          oldSeriesRendererDetails
              .xAxisDetails!.axis.enableAutoIntervalOnZooming ||
      seriesRendererDetails.xAxisDetails!.axis.opposedPosition !=
          oldSeriesRendererDetails.xAxisDetails!.axis.opposedPosition ||
      seriesRendererDetails.xAxisDetails!.orientation !=
          oldSeriesRendererDetails.xAxisDetails!.orientation ||
      seriesRendererDetails.xAxisDetails!.axis.plotOffset !=
          oldSeriesRendererDetails.xAxisDetails!.axis.plotOffset ||
      seriesRendererDetails.xAxisDetails!.axis.rangePadding !=
          oldSeriesRendererDetails.xAxisDetails!.axis.rangePadding ||
      seriesRendererDetails.dataPoints.length !=
          oldSeriesRendererDetails.dataPoints.length ||
      seriesRendererDetails.yAxisDetails!.visibleRange?.delta !=
          oldSeriesRendererDetails.yAxisDetails!.visibleRange?.delta ||
      seriesRendererDetails.yAxisDetails!.visibleRange?.maximum !=
          oldSeriesRendererDetails.yAxisDetails!.visibleRange?.maximum ||
      seriesRendererDetails.yAxisDetails!.visibleRange?.minimum !=
          oldSeriesRendererDetails.yAxisDetails!.visibleRange?.minimum ||
      seriesRendererDetails.yAxisDetails!.visibleRange?.interval !=
          oldSeriesRendererDetails.yAxisDetails!.visibleRange?.interval ||
      seriesRendererDetails.yAxisDetails!.axis.isVisible !=
          oldSeriesRendererDetails.yAxisDetails!.axis.isVisible ||
      seriesRendererDetails.yAxisDetails!.bounds !=
          oldSeriesRendererDetails.yAxisDetails!.bounds ||
      seriesRendererDetails.yAxisDetails!.axis.isInversed !=
          oldSeriesRendererDetails.yAxisDetails!.axis.isInversed ||
      seriesRendererDetails.yAxisDetails!.axis.desiredIntervals !=
          oldSeriesRendererDetails.yAxisDetails!.axis.desiredIntervals ||
      seriesRendererDetails.yAxisDetails!.axis.enableAutoIntervalOnZooming !=
          oldSeriesRendererDetails
              .yAxisDetails!.axis.enableAutoIntervalOnZooming ||
      seriesRendererDetails.yAxisDetails!.axis.opposedPosition !=
          oldSeriesRendererDetails.yAxisDetails!.axis.opposedPosition ||
      seriesRendererDetails.yAxisDetails!.orientation !=
          oldSeriesRendererDetails.yAxisDetails!.orientation ||
      seriesRendererDetails.yAxisDetails!.axis.plotOffset !=
          oldSeriesRendererDetails.yAxisDetails!.axis.plotOffset ||
      seriesRendererDetails.yAxisDetails!.axis.rangePadding !=
          oldSeriesRendererDetails.yAxisDetails!.axis.rangePadding ||
      series.animationDuration != oldWidgetSeries.animationDuration ||
      series.borderColor != oldWidgetSeries.borderColor ||
      series.borderWidth != oldWidgetSeries.borderWidth ||
      series.sizeValueMapper != oldWidgetSeries.sizeValueMapper ||
      series.emptyPointSettings.borderWidth !=
          oldWidgetSeries.emptyPointSettings.borderWidth ||
      series.emptyPointSettings.borderColor !=
          oldWidgetSeries.emptyPointSettings.borderColor ||
      series.emptyPointSettings.color !=
          oldWidgetSeries.emptyPointSettings.color ||
      series.emptyPointSettings.mode !=
          oldWidgetSeries.emptyPointSettings.mode ||
      seriesRendererDetails.maximumX != oldSeriesRendererDetails.maximumX ||
      seriesRendererDetails.maximumY != oldSeriesRendererDetails.maximumY ||
      seriesRendererDetails.minimumX != oldSeriesRendererDetails.minimumX ||
      seriesRendererDetails.minimumY != oldSeriesRendererDetails.minimumY ||
      series.dashArray.length != oldWidgetSeries.dashArray.length ||
      series.dataSource.length != oldWidgetSeries.dataSource.length ||
      series.markerSettings.width != oldWidgetSeries.markerSettings.width ||
      series.markerSettings.color?.value !=
          oldWidgetSeries.markerSettings.color?.value ||
      series.markerSettings.borderColor?.value !=
          oldWidgetSeries.markerSettings.borderColor?.value ||
      series.markerSettings.isVisible !=
          oldWidgetSeries.markerSettings.isVisible ||
      series.markerSettings.borderWidth !=
          oldWidgetSeries.markerSettings.borderWidth ||
      series.markerSettings.height != oldWidgetSeries.markerSettings.height ||
      series.markerSettings.shape != oldWidgetSeries.markerSettings.shape ||
      series.dataLabelSettings.color?.value !=
          oldWidgetSeries.dataLabelSettings.color?.value ||
      series.dataLabelSettings.isVisible !=
          oldWidgetSeries.dataLabelSettings.isVisible ||
      series.dataLabelSettings.labelAlignment !=
          oldWidgetSeries.dataLabelSettings.labelAlignment ||
      series.dataLabelSettings.opacity !=
          oldWidgetSeries.dataLabelSettings.opacity ||
      series.dataLabelSettings.alignment !=
          oldWidgetSeries.dataLabelSettings.alignment ||
      series.dataLabelSettings.angle !=
          oldWidgetSeries.dataLabelSettings.angle ||
      (series.dataLabelSettings.textStyle != null &&
          (series.dataLabelSettings.textStyle?.color?.value !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.color?.value ||
              series.dataLabelSettings.textStyle?.fontStyle !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontStyle ||
              series.dataLabelSettings.textStyle?.fontFamily !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontFamily ||
              series.dataLabelSettings.textStyle?.fontSize !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontSize ||
              series.dataLabelSettings.textStyle?.fontWeight !=
                  oldWidgetSeries.dataLabelSettings.textStyle?.fontWeight)) ||
      series.dataLabelSettings.borderColor.value !=
          oldWidgetSeries.dataLabelSettings.borderColor.value ||
      series.dataLabelSettings.borderWidth !=
          oldWidgetSeries.dataLabelSettings.borderWidth ||
      series.dataLabelSettings.margin.right !=
          oldWidgetSeries.dataLabelSettings.margin.right ||
      series.dataLabelSettings.margin.bottom !=
          oldWidgetSeries.dataLabelSettings.margin.bottom ||
      series.dataLabelSettings.margin.top !=
          oldWidgetSeries.dataLabelSettings.margin.top ||
      series.dataLabelSettings.margin.left !=
          oldWidgetSeries.dataLabelSettings.margin.left ||
      series.dataLabelSettings.borderRadius !=
          oldWidgetSeries.dataLabelSettings.borderRadius) {
    seriesRendererDetails.needsRepaint = true;
  } else {
    seriesRendererDetails.needsRepaint = false;
  }
}

/// To check axis repaint.
void _canRepaintAxis(CartesianStateProperties stateProperties,
    List<ChartAxisRenderer> oldChartAxisRenderers, int axisIndex) {
  // ignore: unnecessary_null_comparison
  if (stateProperties.chartAxis.axisRenderersCollection != null &&
      stateProperties.chartAxis.axisRenderersCollection.isNotEmpty) {
    final ChartAxisRenderer axisRenderer =
        stateProperties.chartAxis.axisRenderersCollection[axisIndex];
    final ChartAxisRenderer oldWidgetAxisRenderer =
        oldChartAxisRenderers[axisIndex];
    final ChartAxisRendererDetails axisRendererDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer);
    final ChartAxisRendererDetails oldAxisRendererDetails =
        AxisHelper.getAxisRendererDetails(oldWidgetAxisRenderer);
    final ChartAxis axis = axisRendererDetails.axis;
    final ChartAxis oldWidgetAxis = oldAxisRendererDetails.axis;
    if (axis.rangePadding.index != oldWidgetAxis.rangePadding.index ||
        axis.plotOffset != oldWidgetAxis.plotOffset ||
        axisRendererDetails.orientation != oldAxisRendererDetails.orientation ||
        axis.opposedPosition != oldWidgetAxis.opposedPosition ||
        axis.minorTicksPerInterval != oldWidgetAxis.minorTicksPerInterval ||
        axis.desiredIntervals != oldWidgetAxis.desiredIntervals ||
        axis.isInversed != oldWidgetAxis.isInversed ||
        axisRendererDetails.bounds != oldAxisRendererDetails.bounds ||
        axis.majorGridLines.dashArray?.length !=
            oldWidgetAxis.majorGridLines.dashArray?.length ||
        axis.majorGridLines.width != oldWidgetAxis.majorGridLines.width ||
        axis.majorGridLines.color != oldWidgetAxis.majorGridLines.color ||
        axis.title != oldWidgetAxis.title ||
        axisRendererDetails.visibleRange?.interval !=
            oldAxisRendererDetails.visibleRange?.interval ||
        axisRendererDetails.visibleRange?.minimum !=
            oldAxisRendererDetails.visibleRange?.minimum ||
        axisRendererDetails.visibleRange?.maximum !=
            oldAxisRendererDetails.visibleRange?.maximum ||
        axisRendererDetails.visibleRange?.delta !=
            oldAxisRendererDetails.visibleRange?.delta ||
        axisRendererDetails.isInsideTickPosition !=
            oldAxisRendererDetails.isInsideTickPosition ||
        axis.maximumLabels != oldWidgetAxis.maximumLabels ||
        axis.minorGridLines.dashArray?.length !=
            oldWidgetAxis.minorGridLines.dashArray?.length ||
        axis.minorGridLines.width != oldWidgetAxis.minorGridLines.width ||
        axis.minorGridLines.color != oldWidgetAxis.minorGridLines.color ||
        axis.tickPosition.index != oldWidgetAxis.tickPosition.index) {
      stateProperties.chartAxis.needsRepaint = true;
    } else {
      stateProperties.chartAxis.needsRepaint = false;
    }
  }
}

/// To get interactive tooltip label.
dynamic getInteractiveTooltipLabel(
    dynamic value, ChartAxisRenderer axisRenderer) {
  final ChartAxisRendererDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(axisRenderer);
  final ChartAxis axis = axisRendererDetails.axis;
  if (axisRenderer is CategoryAxisRenderer) {
    final CategoryAxisDetails categoryAxisRendererDetails =
        axisRendererDetails as CategoryAxisDetails;
    value = value < 0 == true ? 0 : value;
    value = categoryAxisRendererDetails.labels[
        (value.round() >= categoryAxisRendererDetails.labels.length == true
                ? (value.round() > categoryAxisRendererDetails.labels.length ==
                        true
                    ? categoryAxisRendererDetails.labels.length - 1
                    : value - 1)
                : value)
            .round()];
  } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
    final DateTimeCategoryAxisDetails dateTimeAxisDetails =
        axisRendererDetails as DateTimeCategoryAxisDetails;
    value = value < 0 == true ? 0 : value;
    value = dateTimeAxisDetails.labels[
        (value.round() >= dateTimeAxisDetails.labels.length == true
                ? (value.round() > dateTimeAxisDetails.labels.length == true
                    ? dateTimeAxisDetails.labels.length - 1
                    : value - 1)
                : value)
            .round()];
  } else if (axisRenderer is DateTimeAxisRenderer) {
    final DateTimeAxis dateTimeAxis = axisRendererDetails.axis as DateTimeAxis;
    final num interval = axisRendererDetails.visibleRange!.minimum.ceil();
    final num previousInterval = (axisRendererDetails.visibleLabels.isNotEmpty)
        ? axisRendererDetails
            .visibleLabels[axisRendererDetails.visibleLabels.length - 1].value
        : interval;
    final DateFormat dateFormat = dateTimeAxis.dateFormat ??
        getDateTimeLabelFormat(
            axisRenderer, interval.toInt(), previousInterval.toInt());
    value =
        dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  } else {
    value = axis is LogarithmicAxis ? math.pow(10, value) : value;
    value = getLabelValue(value, axis, axis.interactiveTooltip.decimalPlaces);
  }
  return value;
}

/// Returns the path of marker shapes.
Path getMarkerShapesPath(DataMarkerType markerType, Offset position, Size size,
    [SeriesRendererDetails? seriesRendererDetails,
    int? index,
    TrackballBehavior? trackballBehavior,
    Animation<double>? animationController,
    ChartSegment? segment]) {
  final Path path = Path();
  final Rect rect = segment != null && segment is ScatterSegment
      ? Rect.fromLTWH(
          position.dx - ((segment.animationFactor * size.width) / 2),
          position.dy - ((segment.animationFactor * size.height) / 2),
          segment.animationFactor * size.width,
          segment.animationFactor * size.height)
      : Rect.fromLTWH(position.dx - size.width / 2,
          position.dy - size.height / 2, size.width, size.height);
  switch (markerType) {
    case DataMarkerType.circle:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.circle);
      }
      break;
    case DataMarkerType.rectangle:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.rectangle);
      }
      break;
    case DataMarkerType.image:
      {
        // ignore: unnecessary_null_comparison
        if (seriesRendererDetails!.series != null) {
          _loadMarkerImage(seriesRendererDetails.renderer, trackballBehavior);
        }
      }
      break;
    case DataMarkerType.pentagon:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.pentagon);
      }
      break;
    case DataMarkerType.verticalLine:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.verticalLine);
      }
      break;
    case DataMarkerType.invertedTriangle:
      {
        getShapesPath(
            path: path,
            rect: rect,
            shapeType: ShapeMarkerType.invertedTriangle);
      }
      break;
    case DataMarkerType.horizontalLine:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.horizontalLine);
      }
      break;
    case DataMarkerType.diamond:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.diamond);
      }
      break;
    case DataMarkerType.triangle:
      {
        getShapesPath(
            path: path, rect: rect, shapeType: ShapeMarkerType.triangle);
      }
      break;
    case DataMarkerType.none:
      break;
  }
  return path;
}

/// Represents the stacking info class.
class StackingInfo {
  /// Creates an instance of stacking info class.
  StackingInfo(this.groupName, this.stackingValues);

  /// Holds the group name.
  String groupName;

  /// Holds the list of stacking values.
  // ignore: prefer_final_fields
  List<double>? stackingValues;
}

class _StackingGroup {
  _StackingGroup(this.groupName, this.stackCount);

  String groupName;
  int stackCount;
}

/// To load marker image.
// ignore: avoid_void_async
void _loadMarkerImage(CartesianSeriesRenderer seriesRenderer,
    TrackballBehavior? trackballBehavior) async {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  if ((trackballBehavior != null &&
          trackballBehavior.markerSettings != null &&
          trackballBehavior.markerSettings!.shape == DataMarkerType.image &&
          trackballBehavior.markerSettings!.image != null) ||
      // ignore: unnecessary_null_comparison
      (series.markerSettings != null &&
          (series.markerSettings.isVisible ||
              seriesRendererDetails.seriesType == 'scatter') &&
          series.markerSettings.shape == DataMarkerType.image &&
          series.markerSettings.image != null)) {
    calculateImage(seriesRendererDetails.stateProperties, seriesRendererDetails,
        trackballBehavior);
  }
}

/// Gets the chart location of the annotation.
ChartLocation getAnnotationLocation(CartesianChartAnnotation annotation,
    CartesianStateProperties stateProperties) {
  final String? xAxisName = annotation.xAxisName;
  final String? yAxisName = annotation.yAxisName;
  ChartAxisRenderer? xAxisRenderer, yAxisRenderer;
  num? xValue;
  Rect axisClipRect;
  ChartLocation? location;
  if (annotation.coordinateUnit == CoordinateUnit.logicalPixel) {
    location = annotation.region == AnnotationRegion.chart
        ? ChartLocation(annotation.x.toDouble(), annotation.y.toDouble())
        : ChartLocation(
            stateProperties.chartAxis.axisClipRect.left + annotation.x,
            stateProperties.chartAxis.axisClipRect.top + annotation.y);
  } else if (annotation.coordinateUnit == CoordinateUnit.point) {
    for (int i = 0;
        i < stateProperties.chartAxis.axisRenderersCollection.length;
        i++) {
      final ChartAxisRenderer axisRenderer =
          stateProperties.chartAxis.axisRenderersCollection[i];
      final ChartAxisRendererDetails axisRendererDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      if (xAxisName == axisRendererDetails.name ||
          (xAxisName == null && axisRendererDetails.name == 'primaryXAxis')) {
        xAxisRenderer = axisRenderer;
        if (xAxisRenderer is CategoryAxisRenderer) {
          final CategoryAxisDetails categoryAxisDetails =
              AxisHelper.getAxisRendererDetails(axisRenderer)
                  as CategoryAxisDetails;
          if (annotation.x != null &&
              num.tryParse(annotation.x.toString()) != null) {
            xValue = num.tryParse(annotation.x.toString())!;
          } else if (annotation.x is String) {
            xValue = categoryAxisDetails.labels.indexOf(annotation.x);
          }
        } else if (xAxisRenderer is DateTimeAxisRenderer) {
          xValue = annotation.x is DateTime
              ? (annotation.x).millisecondsSinceEpoch
              : annotation.x;
        } else if (xAxisRenderer is DateTimeCategoryAxisRenderer) {
          final DateTimeCategoryAxisDetails dateTimeCategoryAxisDetails =
              AxisHelper.getAxisRendererDetails(xAxisRenderer)
                  as DateTimeCategoryAxisDetails;
          if (annotation.x != null &&
              num.tryParse(annotation.x.toString()) != null) {
            xValue = num.tryParse(annotation.x.toString())!;
          } else {
            xValue = annotation.x is num
                ? annotation.x
                : (annotation.x is DateTime
                    ? dateTimeCategoryAxisDetails.labels.indexOf(
                        dateTimeCategoryAxisDetails.dateFormat
                            .format(annotation.x))
                    : dateTimeCategoryAxisDetails.labels.indexOf(annotation.x));
          }
        } else {
          xValue = annotation.x is DateTime
              ? (annotation.x).millisecondsSinceEpoch
              : annotation.x;
        }
      } else if (yAxisName == axisRendererDetails.name ||
          (yAxisName == null && axisRendererDetails.name == 'primaryYAxis')) {
        yAxisRenderer = axisRenderer;
      }
    }

    if (xAxisRenderer != null && yAxisRenderer != null) {
      axisClipRect = calculatePlotOffset(
          stateProperties.chartAxis.axisClipRect,
          Offset(
              AxisHelper.getAxisRendererDetails(xAxisRenderer).axis.plotOffset,
              AxisHelper.getAxisRendererDetails(yAxisRenderer)
                  .axis
                  .plotOffset));
      location = calculatePoint(
          xValue!,
          annotation.y,
          AxisHelper.getAxisRendererDetails(xAxisRenderer),
          AxisHelper.getAxisRendererDetails(yAxisRenderer),
          stateProperties.requireInvertedAxis,
          null,
          axisClipRect);
    }
  } else {
    if (annotation.region == AnnotationRegion.chart) {
      location = ChartLocation(
          stateProperties.renderingDetails.chartContainerRect.left +
              percentageToValue(
                      annotation.x.contains('%') == true
                          ? annotation.x
                          : annotation.x + '%',
                      stateProperties
                          .renderingDetails.chartContainerRect.right)!
                  .toDouble(),
          stateProperties.renderingDetails.chartContainerRect.top +
              percentageToValue(
                      annotation.y.contains('%') == true
                          ? annotation.y
                          : annotation.y + '%',
                      stateProperties
                          .renderingDetails.chartContainerRect.bottom)!
                  .toDouble());
    } else {
      location = ChartLocation(
          stateProperties.chartAxis.axisClipRect.left +
              percentageToValue(
                      annotation.x.contains('%') == true
                          ? annotation.x
                          : annotation.x + '%',
                      stateProperties.chartAxis.axisClipRect.right -
                          stateProperties.chartAxis.axisClipRect.left)!
                  .toDouble(),
          stateProperties.chartAxis.axisClipRect.top +
              percentageToValue(
                      annotation.y.contains('%') == true
                          ? annotation.y
                          : annotation.y + '%',
                      stateProperties.chartAxis.axisClipRect.bottom)!
                  .toDouble());
    }
  }
  return location!;
}

/// Draw tooltip arrow head.
void drawTooltipArrowhead(
    Canvas canvas,
    Path backgroundPath,
    Paint fillPaint,
    Paint strokePaint,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
    double x4,
    double y4) {
  backgroundPath.moveTo(x1, y1);
  backgroundPath.lineTo(x2, y2);
  backgroundPath.lineTo(x3, y3);
  backgroundPath.lineTo(x4, y4);
  backgroundPath.lineTo(x1, y1);
  fillPaint.isAntiAlias = true;
  canvas.drawPath(backgroundPath, strokePaint);
  canvas.drawPath(backgroundPath, fillPaint);
}

/// Calculate rounded rect from rect and corner radius.
RRect getRoundedCornerRect(Rect rect, double cornerRadius) =>
    RRect.fromRectAndCorners(
      rect,
      bottomLeft: Radius.circular(cornerRadius),
      bottomRight: Radius.circular(cornerRadius),
      topLeft: Radius.circular(cornerRadius),
      topRight: Radius.circular(cornerRadius),
    );

/// Calculate the X value from the current screen point.
double pointToXVal(SfCartesianChart chart, ChartAxisRenderer axisRenderer,
    Rect rect, double x, double y) {
  // ignore: unnecessary_null_comparison
  if (axisRenderer != null) {
    return _coefficientToValue(x / rect.width, axisRenderer);
  }
  return double.nan;
}

/// Calculate the Y value from the current screen point.
double pointToYVal(SfCartesianChart chart, ChartAxisRenderer axisRenderer,
    Rect rect, double x, double y) {
  // ignore: unnecessary_null_comparison
  if (axisRenderer != null) {
    return _coefficientToValue(1 - (y / rect.height), axisRenderer);
  }
  return double.nan;
}

/// Gets the x position of validated rect.
Rect validateRectXPosition(
    Rect labelRect, CartesianStateProperties stateProperties) {
  Rect validatedRect = labelRect;
  if (labelRect.right >= stateProperties.chartAxis.axisClipRect.right) {
    validatedRect = Rect.fromLTRB(
        labelRect.left -
            (labelRect.right - stateProperties.chartAxis.axisClipRect.right),
        labelRect.top,
        stateProperties.chartAxis.axisClipRect.right,
        labelRect.bottom);
  } else if (labelRect.left <= stateProperties.chartAxis.axisClipRect.left) {
    validatedRect = Rect.fromLTRB(
        stateProperties.chartAxis.axisClipRect.left,
        labelRect.top,
        labelRect.right +
            (stateProperties.chartAxis.axisClipRect.left - labelRect.left),
        labelRect.bottom);
  }
  return validatedRect;
}

/// Gets the y position of validated rect.
Rect validateRectYPosition(
    Rect labelRect, CartesianStateProperties stateProperties) {
  Rect validatedRect = labelRect;
  if (labelRect.bottom >= stateProperties.chartAxis.axisClipRect.bottom) {
    validatedRect = Rect.fromLTRB(
        labelRect.left,
        labelRect.top -
            (labelRect.bottom - stateProperties.chartAxis.axisClipRect.bottom),
        labelRect.right,
        stateProperties.chartAxis.axisClipRect.bottom);
  } else if (labelRect.top <= stateProperties.chartAxis.axisClipRect.top) {
    validatedRect = Rect.fromLTRB(
        labelRect.left,
        stateProperties.chartAxis.axisClipRect.top,
        labelRect.right,
        labelRect.bottom +
            (stateProperties.chartAxis.axisClipRect.top - labelRect.top));
  }
  return validatedRect;
}

/// This method will validate whether the tooltip exceeds the screen or not.
Rect validateRectBounds(Rect tooltipRect, Rect boundary) {
  Rect validatedRect = tooltipRect;
  double difference = 0;

  /// Padding between the corners.
  const double padding = 0.5;

  if (tooltipRect.left < boundary.left) {
    difference = (boundary.left - tooltipRect.left) + padding;
    validatedRect = Rect.fromLTRB(
        validatedRect.left + difference,
        validatedRect.top,
        validatedRect.right + difference,
        validatedRect.bottom);
  }
  if (tooltipRect.right > boundary.right) {
    difference = (tooltipRect.right - boundary.right) + padding;
    validatedRect = Rect.fromLTRB(
        validatedRect.left - difference,
        validatedRect.top,
        validatedRect.right - difference,
        validatedRect.bottom);
  }
  if (tooltipRect.top < boundary.top) {
    difference = (boundary.top - tooltipRect.top) + padding;
    validatedRect = Rect.fromLTRB(
        validatedRect.left,
        validatedRect.top + difference,
        validatedRect.right,
        validatedRect.bottom + difference);
  }

  if (tooltipRect.bottom > boundary.bottom) {
    difference = (tooltipRect.bottom - boundary.bottom) + padding;
    validatedRect = Rect.fromLTRB(
        validatedRect.left,
        validatedRect.top - difference,
        validatedRect.right,
        validatedRect.bottom - difference);
  }

  return validatedRect;
}

/// To render a rect for stacked series.
void renderStackingRectSeries(
    Paint? fillPaint,
    Paint? strokePaint,
    Path path,
    double animationFactor,
    CartesianSeriesRenderer seriesRenderer,
    Canvas canvas,
    RRect segmentRect,
    CartesianChartPoint<dynamic> currentPoint,
    int currentSegmentIndex) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final StackedSeriesBase<dynamic, dynamic> series =
      seriesRendererDetails.series as StackedSeriesBase<dynamic, dynamic>;
  if (seriesRendererDetails.isSelectionEnable == true) {
    final SelectionBehaviorRenderer? selectionBehaviorRenderer =
        seriesRendererDetails.selectionBehaviorRenderer;
    SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
        .selectionRenderer
        ?.checkWithSelectionState(
            seriesRendererDetails.segments[currentSegmentIndex],
            seriesRendererDetails.chart);
  }
  if (fillPaint != null) {
    series.animationDuration > 0
        ? animateStackedRectSeries(
            canvas,
            segmentRect,
            fillPaint,
            seriesRendererDetails,
            animationFactor,
            currentPoint,
            seriesRendererDetails.stateProperties)
        : canvas.drawRRect(segmentRect, fillPaint);
  }
  if (strokePaint != null) {
    if (seriesRendererDetails.dashArray![0] != 0 &&
        seriesRendererDetails.dashArray![1] != 0) {
      drawDashedLine(
          canvas, seriesRendererDetails.dashArray!, strokePaint, path);
    } else {
      series.animationDuration > 0
          ? animateStackedRectSeries(
              canvas,
              segmentRect,
              strokePaint,
              seriesRendererDetails,
              animationFactor,
              currentPoint,
              seriesRendererDetails.stateProperties)
          : canvas.drawRRect(segmentRect, strokePaint);
    }
  }
}

/// Draw stacked area path.
void drawStackedAreaPath(
    Path path,
    Path strokePath,
    CartesianSeriesRenderer seriesRenderer,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint) {
  Rect pathRect;
  dynamic stackedAreaSegment;
  pathRect = path.getBounds();
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  stackedAreaSegment = seriesRendererDetails.segments[0];
  final SegmentProperties segmentProperties =
      SegmentHelper.getSegmentProperties(stackedAreaSegment);
  segmentProperties.pathRect = pathRect;
  if (seriesRendererDetails.isSelectionEnable == true) {
    final SelectionBehaviorRenderer? selectionBehaviorRenderer =
        seriesRendererDetails.selectionBehaviorRenderer;
    SelectionHelper.getRenderingDetails(selectionBehaviorRenderer!)
        .selectionRenderer
        ?.checkWithSelectionState(
            seriesRendererDetails.segments[0], seriesRendererDetails.chart);
  }
  canvas.drawPath(
      path,
      (series.gradient == null)
          ? fillPaint
          : seriesRendererDetails.segments[0].getFillPaint());
  strokePaint = seriesRendererDetails.segments[0].getStrokePaint();

  if (strokePaint.color != Colors.transparent) {
    drawDashedLine(canvas, series.dashArray, strokePaint, strokePath);
  }
}

/// Render stacked line series.
void renderStackedLineSeries(
    StackedSeriesBase<dynamic, dynamic> series,
    Canvas canvas,
    Paint strokePaint,
    double x1,
    double y1,
    double x2,
    double y2) {
  final Path path = Path();
  path.moveTo(x1, y1);
  path.lineTo(x2, y2);
  drawDashedLine(canvas, series.dashArray, strokePaint, path);
}

/// Painter method for stacked area series.
void stackedAreaPainter(
    Canvas canvas,
    dynamic seriesRenderer,
    CartesianStateProperties stateProperties,
    Animation<double>? seriesAnimation,
    Animation<double>? chartElementAnimation,
    PainterKey painterKey) {
  Rect clipRect, axisClipRect;
  final int seriesIndex = painterKey.index;
  final SfCartesianChart chart = stateProperties.chart;
  final RenderingDetails renderingDetails = stateProperties.renderingDetails;
  seriesRenderer.seriesRendererDetails
      .storeSeriesProperties(stateProperties.chartState, seriesIndex);
  double animationFactor;
  final num? crossesAt = getCrossesAtValue(seriesRenderer, stateProperties);
  final List<CartesianChartPoint<dynamic>> dataPoints =
      seriesRenderer.seriesRendererDetails.dataPoints;

  /// Clip rect will be added for series.
  if (seriesRenderer.seriesRendererDetails.visible! == true) {
    final dynamic series = seriesRenderer.seriesRendererDetails.series;
    canvas.save();
    axisClipRect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.clipRect(axisClipRect);
    animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
    if (seriesRenderer.seriesRendererDetails.reAnimate == true ||
        ((!(renderingDetails.widgetNeedUpdate ||
                    renderingDetails.isLegendToggled) ||
                !stateProperties.oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0 == true)) {
      performLinearAnimation(
          stateProperties,
          seriesRenderer.seriesRendererDetails.xAxisDetails!.axis,
          canvas,
          animationFactor);
    }

    final Path path = Path(), strokePath = Path();
    final Rect rect = stateProperties.chartAxis.axisClipRect;
    ChartLocation point1, point2;
    final ChartAxisRendererDetails xAxisDetails =
            seriesRenderer.seriesRendererDetails.xAxisDetails!,
        yAxisDetails = seriesRenderer.seriesRendererDetails.yAxisDetails!;
    CartesianChartPoint<dynamic>? point;
    final dynamic stackAreaSeries = seriesRenderer.seriesRendererDetails.series;
    final List<Offset> points = <Offset>[];
    if (dataPoints.isNotEmpty) {
      int startPoint = 0;
      final StackedValues stackedValues =
          seriesRenderer.seriesRendererDetails.stackingValues[0];
      List<CartesianSeriesRenderer> seriesRendererCollection;
      CartesianSeriesRenderer previousSeriesRenderer;
      seriesRendererCollection = findSeriesCollection(stateProperties);
      point1 = calculatePoint(
          dataPoints[0].xValue,
          math_lib.max(yAxisDetails.visibleRange!.minimum,
              crossesAt ?? stackedValues.startValues[0]),
          xAxisDetails,
          yAxisDetails,
          stateProperties.requireInvertedAxis,
          stackAreaSeries,
          rect);
      path.moveTo(point1.x, point1.y);
      strokePath.moveTo(point1.x, point1.y);
      if (seriesRenderer.seriesRendererDetails.visibleDataPoints == null ||
          seriesRenderer.seriesRendererDetails.visibleDataPoints!.isNotEmpty ==
              true) {
        seriesRenderer.seriesRendererDetails.visibleDataPoints =
            <CartesianChartPoint<dynamic>>[];
      }

      seriesRenderer.seriesRendererDetails
          .setSeriesProperties(seriesRenderer.seriesRendererDetails);
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.seriesRendererDetails.calculateRegionData(
            stateProperties, seriesRenderer, seriesIndex, point, pointIndex);
        if (point.isVisible) {
          point1 = calculatePoint(
              dataPoints[pointIndex].xValue,
              stackedValues.endValues[pointIndex],
              xAxisDetails,
              yAxisDetails,
              stateProperties.requireInvertedAxis,
              stackAreaSeries,
              rect);
          points.add(Offset(point1.x, point1.y));
          path.lineTo(point1.x, point1.y);
          strokePath.lineTo(point1.x, point1.y);
        } else {
          if (stackAreaSeries.emptyPointSettings.mode != EmptyPointMode.drop) {
            for (int j = pointIndex - 1; j >= startPoint; j--) {
              point2 = calculatePoint(
                  dataPoints[j].xValue,
                  crossesAt ?? stackedValues.startValues[j],
                  xAxisDetails,
                  yAxisDetails,
                  stateProperties.requireInvertedAxis,
                  stackAreaSeries,
                  rect);
              path.lineTo(point2.x, point2.y);
              if (stackAreaSeries.borderDrawMode ==
                  BorderDrawMode.excludeBottom) {
                strokePath.lineTo(point1.x, point2.y);
              } else if (stackAreaSeries.borderDrawMode == BorderDrawMode.all) {
                strokePath.lineTo(point2.x, point2.y);
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
                  stackAreaSeries,
                  rect);
              path.moveTo(point1.x, point1.y);
              strokePath.moveTo(point1.x, point1.y);
            }
            startPoint = pointIndex + 1;
          }
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer._createSegments(
              painterKey.index, chart, animationFactor, points);
        }
      }
      for (int j = dataPoints.length - 1; j >= startPoint; j--) {
        previousSeriesRenderer =
            getPreviousSeriesRenderer(seriesRendererCollection, seriesIndex);
        final SeriesRendererDetails previousSeriesRendererDetails =
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
              stackAreaSeries,
              rect);
          path.lineTo(point2.x, point2.y);
          if (stackAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
            strokePath.lineTo(point1.x, point2.y);
          } else if (stackAreaSeries.borderDrawMode == BorderDrawMode.all) {
            strokePath.lineTo(point2.x, point2.y);
          }
        }
      }
    }
    // ignore: unnecessary_null_comparison
    if (path != null &&
        seriesRenderer.seriesRendererDetails.segments != null &&
        seriesRenderer.seriesRendererDetails.segments.isNotEmpty == true) {
      final dynamic areaSegment =
          seriesRenderer.seriesRendererDetails.segments[0];
      seriesRenderer.seriesRendererDetails.drawSegment(
          canvas,
          areaSegment
            .._path = path
            .._strokePath = strokePath);
    }

    clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            rect.left - stackAreaSeries.markerSettings.width,
            rect.top - stackAreaSeries.markerSettings.height,
            rect.right + stackAreaSeries.markerSettings.width,
            rect.bottom + stackAreaSeries.markerSettings.height),
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.restore();
    if ((stackAreaSeries.animationDuration <= 0 == true ||
            !renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (stackAreaSeries.markerSettings.isVisible == true ||
            stackAreaSeries.dataLabelSettings.isVisible == true ||
            stackAreaSeries.errorBarSettings.isVisible! == true)) {
      canvas.clipRect(clipRect);
      seriesRenderer.seriesRendererDetails
          .renderSeriesElements(chart, canvas, chartElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }
}

/// To get previous series renderer.
CartesianSeriesRenderer getPreviousSeriesRenderer(
    List<CartesianSeriesRenderer> seriesRendererCollection, num seriesIndex) {
  for (int i = 0; i < seriesRendererCollection.length; i++) {
    if (seriesIndex ==
            seriesRendererCollection.indexOf(seriesRendererCollection[i]) &&
        i != 0) {
      return seriesRendererCollection[i - 1];
    }
  }
  return seriesRendererCollection[0];
}

/// Rect painter for stacked series.
void stackedRectPainter(Canvas canvas, dynamic seriesRenderer,
    CartesianStateProperties stateProperties, PainterKey painterKey) {
  if (seriesRenderer.seriesRendererDetails.visible! == true) {
    canvas.save();
    Rect clipRect, axisClipRect;
    CartesianChartPoint<dynamic> point;
    final XyDataSeries<dynamic, dynamic> series =
        seriesRenderer.seriesRendererDetails.series;
    final RenderingDetails renderingDetails = stateProperties.renderingDetails;
    final int seriesIndex = painterKey.index;
    final Animation<double> seriesAnimation =
        seriesRenderer.seriesRendererDetails.seriesAnimation;
    final Animation<double> chartElementAnimation =
        seriesRenderer.seriesRendererDetails.seriesElementAnimation;
    seriesRenderer.seriesRendererDetails
        .storeSeriesProperties(stateProperties.chartState, seriesIndex);
    double animationFactor;
    // ignore: unnecessary_null_comparison
    animationFactor = seriesAnimation != null &&
            (seriesRenderer.seriesRendererDetails.reAnimate == true ||
                (!(renderingDetails.widgetNeedUpdate ||
                    renderingDetails.isLegendToggled)))
        ? seriesAnimation.value
        : 1;

    /// Clip rect will be added for series.
    axisClipRect = calculatePlotOffset(
        stateProperties.chartAxis.axisClipRect,
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.clipRect(axisClipRect);
    int segmentIndex = -1;
    if (seriesRenderer.seriesRendererDetails.visibleDataPoints == null ||
        seriesRenderer.seriesRendererDetails.visibleDataPoints!.isNotEmpty ==
            true) {
      seriesRenderer.seriesRendererDetails.visibleDataPoints =
          <CartesianChartPoint<dynamic>>[];
    }

    seriesRenderer.seriesRendererDetails
        .setSeriesProperties(seriesRenderer.seriesRendererDetails);
    for (int pointIndex = 0;
        pointIndex < seriesRenderer.seriesRendererDetails.dataPoints.length;
        pointIndex++) {
      point = seriesRenderer.seriesRendererDetails.dataPoints[pointIndex];
      seriesRenderer.seriesRendererDetails.calculateRegionData(
          stateProperties, seriesRenderer, painterKey.index, point, pointIndex);
      if (point.isVisible && !point.isGap) {
        seriesRenderer.seriesRendererDetails.drawSegment(
            canvas,
            seriesRenderer._createSegments(
                point, segmentIndex += 1, painterKey.index, animationFactor));
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
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.restore();
    if ((series.animationDuration <= 0 ||
            !renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      canvas.clipRect(clipRect);
      seriesRenderer.seriesRendererDetails.renderSeriesElements(
          stateProperties.chart, canvas, chartElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(painterKey.index, painterKey.name, true);
    }
  }
}

/// Painter for stacked line series.
void stackedLinePainter(
    Canvas canvas,
    dynamic seriesRenderer,
    Animation<double>? seriesAnimation,
    CartesianStateProperties stateProperties,
    Animation<double>? chartElementAnimation,
    PainterKey painterKey) {
  Rect clipRect;
  double animationFactor;
  final RenderingDetails renderingDetails = stateProperties.renderingDetails;
  if (seriesRenderer.seriesRendererDetails.visible! == true) {
    final XyDataSeries<dynamic, dynamic> series =
        seriesRenderer.seriesRendererDetails.series;
    canvas.save();
    animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
    final int seriesIndex = painterKey.index;
    StackedValues? stackedValues;
    seriesRenderer.seriesRendererDetails
        .storeSeriesProperties(stateProperties.chartState, seriesIndex);
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    if (seriesRenderer is StackedSeriesRenderer &&
        seriesRendererDetails.stackingValues.isNotEmpty == true) {
      stackedValues = seriesRendererDetails.stackingValues[0];
    }
    final Rect rect = seriesRenderer
        .seriesRendererDetails.stateProperties.chartAxis.axisClipRect;

    /// Clip rect will be added for series.
    final Rect axisClipRect = calculatePlotOffset(
        rect,
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.clipRect(axisClipRect);
    if (seriesRenderer.seriesRendererDetails.reAnimate == true ||
        ((!(renderingDetails.widgetNeedUpdate ||
                    renderingDetails.isLegendToggled) ||
                !stateProperties.oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0)) {
      performLinearAnimation(
          stateProperties,
          seriesRenderer.seriesRendererDetails.xAxisDetails!.axis,
          canvas,
          animationFactor);
    }

    int segmentIndex = -1;
    double? currentCummulativePos, nextCummulativePos;
    CartesianChartPoint<dynamic>? startPoint, endPoint, currentPoint, nextPoint;
    if (seriesRenderer.seriesRendererDetails.visibleDataPoints == null ||
        seriesRenderer.seriesRendererDetails.visibleDataPoints!.isNotEmpty ==
            true) {
      seriesRenderer.seriesRendererDetails.visibleDataPoints =
          <CartesianChartPoint<dynamic>>[];
    }

    seriesRenderer.seriesRendererDetails
        .setSeriesProperties(seriesRenderer.seriesRendererDetails);
    for (int pointIndex = 0;
        pointIndex < seriesRenderer.seriesRendererDetails.dataPoints.length;
        pointIndex++) {
      currentPoint =
          seriesRenderer.seriesRendererDetails.dataPoints[pointIndex];
      seriesRenderer.seriesRendererDetails.calculateRegionData(stateProperties,
          seriesRenderer, seriesIndex, currentPoint, pointIndex);
      if ((currentPoint!.isVisible && !currentPoint.isGap) &&
          startPoint == null &&
          stackedValues != null) {
        startPoint = currentPoint;
        currentCummulativePos = stackedValues.endValues[pointIndex];
      }
      if (pointIndex + 1 <
          seriesRenderer.seriesRendererDetails.dataPoints.length) {
        nextPoint =
            seriesRenderer.seriesRendererDetails.dataPoints[pointIndex + 1];
        if (startPoint != null && nextPoint!.isGap) {
          startPoint = null;
        } else if (nextPoint!.isVisible &&
            !nextPoint.isGap &&
            stackedValues != null) {
          endPoint = nextPoint;
          nextCummulativePos = stackedValues.endValues[pointIndex + 1];
        }
      }

      if (startPoint != null && endPoint != null) {
        seriesRenderer.seriesRendererDetails.drawSegment(
            canvas,
            seriesRenderer._createSegments(
                startPoint,
                endPoint,
                segmentIndex += 1,
                seriesIndex,
                animationFactor,
                currentCummulativePos!,
                nextCummulativePos!));
        endPoint = startPoint = null;
      }
    }
    clipRect = calculatePlotOffset(
        Rect.fromLTRB(
            rect.left - series.markerSettings.width,
            rect.top - series.markerSettings.height,
            rect.right + series.markerSettings.width,
            rect.bottom + series.markerSettings.height),
        Offset(
            seriesRenderer.seriesRendererDetails.xAxisDetails?.axis?.plotOffset,
            seriesRenderer
                .seriesRendererDetails.yAxisDetails?.axis?.plotOffset));
    canvas.restore();
    if ((series.animationDuration <= 0 ||
            !renderingDetails.initialRender! ||
            animationFactor >= stateProperties.seriesDurationFactor) &&
        (series.markerSettings.isVisible ||
            series.dataLabelSettings.isVisible)) {
      canvas.clipRect(clipRect);
      seriesRenderer.seriesRendererDetails.renderSeriesElements(
          stateProperties.chart, canvas, chartElementAnimation);
    }
    if (animationFactor >= 1) {
      stateProperties.setPainterKey(seriesIndex, painterKey.name, true);
    }
  }
}

/// To find MonotonicSpline.
List<num?>? _getMonotonicSpline(List<num> xValues, List<num> yValues,
    List<num?> yCoef, int dataCount, List<num?> dx) {
  final int count = dataCount;
  int index = -1;

  final List<num?> slope = List<num?>.filled(count - 1, null);
  final List<num?> coefficient = List<num?>.filled(count, null);

  for (int i = 0; i < count - 1; i++) {
    dx[i] = xValues[i + 1] - xValues[i];
    slope[i] = (yValues[i + 1] - yValues[i]) / dx[i]!;
    if (slope[i]!.toDouble() == double.infinity) {
      slope[i] = 0;
    }
  }
  // Add the first and last coefficient value as Slope[0] and Slope[n-1]
  if (slope.isEmpty) {
    return null;
  }

  slope[0] != null && slope[0]!.isNaN
      ? coefficient[++index] = 0
      : coefficient[++index] = slope[0];

  for (int i = 0; i < dx.length - 1; i++) {
    if (slope.length > i + 1) {
      final num m = slope[i]!, next = slope[i + 1]!;
      if (m * next <= 0) {
        coefficient[++index] = 0;
      } else {
        if (dx[i] == 0) {
          coefficient[++index] = 0;
        } else {
          final double firstPoint = dx[i]!.toDouble(),
              nextPoint = dx[i + 1]!.toDouble();
          final double interPoint = firstPoint + nextPoint;
          coefficient[++index] = 3 *
              interPoint /
              (((interPoint + nextPoint) / m) +
                  ((interPoint + firstPoint) / next));
        }
      }
    }
  }
  slope[slope.length - 1] != null && slope[slope.length - 1]!.isNaN
      ? coefficient[++index] = 0
      : coefficient[++index] = slope[slope.length - 1];

  yCoef.addAll(coefficient);

  return yCoef;
}

/// To find CardinalSpline.
List<num?> _getCardinalSpline(List<num> xValues, List<num> yValues,
    List<num?> yCoef, int dataCount, double tension) {
  if (tension < 0.1) {
    tension = 0;
  } else if (tension > 1) {
    tension = 1;
  }

  final int count = dataCount;

  final List<num?> tangentsX = List<num?>.filled(count, null);

  if (count <= 2) {
    for (int i = 0; i < count; i++) {
      tangentsX[i] = 0;
    }
  } else {
    for (int i = 0; i < count; i++) {
      if (i == 0 && xValues.length > 2) {
        tangentsX[i] = tension * (xValues[i + 2] - xValues[i]);
      } else if (i == count - 1 && count - 3 >= 0) {
        tangentsX[i] = tension * (xValues[count - 1] - xValues[count - 3]);
      } else if (i - 1 >= 0 && xValues.length > i + 1) {
        tangentsX[i] = tension * (xValues[i + 1] - xValues[i - 1]);
      }
      if (tangentsX[i] != null && tangentsX[i]!.isNaN) {
        tangentsX[i] = 0;
      }
    }
  }

  yCoef.addAll(tangentsX);
  return yCoef;
}

/// To find NaturalSpline.
List<num?> naturalSpline(List<num> xValues, List<num> yValues,
    List<num?> yCoeff, int dataCount, SplineType? splineType) {
  const double a = 6;
  final int count = dataCount;
  int i, k;
  final List<num?> yCoef = List<num?>.filled(count, null);
  double d1, d2, d3, dy1, dy2;
  num p;

  final List<num?> u = List<num?>.filled(count, null);
  if (splineType == SplineType.clamped && xValues.length > 1) {
    u[0] = 0.5;
    final num d0 = (xValues[1] - xValues[0]) / (yValues[1] - yValues[0]);
    final num dn = (xValues[count - 1] - xValues[count - 2]) /
        (yValues[count - 1] - yValues[count - 2]);
    yCoef[0] =
        (3 * (yValues[1] - yValues[0]) / (xValues[1] - xValues[0])) - (3 * d0);
    yCoef[count - 1] = (3 * dn) -
        ((3 * (yValues[count - 1] - yValues[count - 2])) /
            (xValues[count - 1] - xValues[count - 2]));

    if (yCoef[0] == double.infinity || yCoef[0]!.isNaN) {
      yCoef[0] = 0;
    }

    if (yCoef[count - 1] == double.infinity || yCoef[count - 1]!.isNaN) {
      yCoef[count - 1] = 0;
    }
  } else {
    yCoef[0] = u[0] = 0;
    yCoef[count - 1] = 0;
  }

  for (i = 1; i < count - 1; i++) {
    yCoef[i] = 0;
    if ((!yValues[i + 1].isNaN) &&
        (!yValues[i - 1].isNaN) &&
        (!yValues[i].isNaN) &&
        // ignore: unnecessary_null_comparison
        yValues[i + 1] != null &&
        // ignore: unnecessary_null_comparison
        xValues[i + 1] != null &&
        // ignore: unnecessary_null_comparison
        yValues[i - 1] != null &&
        // ignore: unnecessary_null_comparison
        xValues[i - 1] != null &&
        // ignore: unnecessary_null_comparison
        xValues[i] != null &&
        // ignore: unnecessary_null_comparison
        yValues[i] != null) {
      d1 = xValues[i].toDouble() - xValues[i - 1].toDouble();
      d2 = xValues[i + 1].toDouble() - xValues[i - 1].toDouble();
      d3 = xValues[i + 1].toDouble() - xValues[i].toDouble();
      dy1 = yValues[i + 1].toDouble() - yValues[i].toDouble();
      dy2 = yValues[i].toDouble() - yValues[i - 1].toDouble();
      if (xValues[i] == xValues[i - 1] || xValues[i] == xValues[i + 1]) {
        yCoef[i] = 0;
        u[i] = 0;
      } else {
        p = 1 / ((d1 * yCoef[i - 1]!) + (2 * d2));
        yCoef[i] = -p * d3;
        // ignore: unnecessary_null_comparison
        if (d1 != null && u[i - 1] != null) {
          u[i] = p * ((a * ((dy1 / d3) - (dy2 / d1))) - (d1 * u[i - 1]!));
        }
      }
    }
  }

  for (k = count - 2; k >= 0; k--) {
    if (u[k] != null && yCoef[k] != null && yCoef[k + 1] != null) {
      yCoef[k] = (yCoef[k]! * yCoef[k + 1]!) + u[k]!;
    }
  }

  yCoeff.addAll(yCoef);
  return yCoeff;
}

/// To find Monotonic ControlPoints.
List<Offset> _calculateMonotonicControlPoints(
    double pointX,
    double pointY,
    double pointX1,
    double pointY1,
    double coefficientY,
    double coefficientY1,
    double dx,
    List<Offset> controlPoints) {
  final num value = dx / 3;
  final List<double?> values = List<double?>.filled(4, null);
  values[0] = pointX + value;
  values[1] = pointY + (coefficientY * value);
  values[2] = pointX1 - value;
  values[3] = pointY1 - (coefficientY1 * value);
  controlPoints.add(Offset(values[0]!, values[1]!));
  controlPoints.add(Offset(values[2]!, values[3]!));
  return controlPoints;
}

/// To find Cardinal ControlPoints.
List<Offset> _calculateCardinalControlPoints(
    double pointX,
    double pointY,
    double pointX1,
    double pointY1,
    double coefficientY,
    double coefficientY1,
    CartesianSeriesRenderer seriesRenderer,
    List<Offset> controlPoints) {
  double yCoefficient = coefficientY;
  double y1Coefficient = coefficientY1;
  if (SeriesHelper.getSeriesRendererDetails(seriesRenderer).xAxisDetails
      is DateTimeAxisDetails) {
    yCoefficient = coefficientY / dateTimeInterval(seriesRenderer);
    y1Coefficient = coefficientY1 / dateTimeInterval(seriesRenderer);
  }
  final List<double?> values = List<double?>.filled(4, null);
  values[0] = pointX + (coefficientY / 3);
  values[1] = pointY + (yCoefficient / 3);
  values[2] = pointX1 - (coefficientY1 / 3);
  values[3] = pointY1 - (y1Coefficient / 3);
  controlPoints.add(Offset(values[0]!, values[1]!));
  controlPoints.add(Offset(values[2]!, values[3]!));
  return controlPoints;
}

/// Calculate the dateTime intervals for cardinal spline type.
num dateTimeInterval(CartesianSeriesRenderer seriesRenderer) {
  final DateTimeAxis xAxis =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer).xAxisDetails!.axis
          as DateTimeAxis;
  final DateTimeIntervalType actualIntervalType = xAxis.intervalType;
  num intervalInMilliseconds;
  if (actualIntervalType == DateTimeIntervalType.years) {
    intervalInMilliseconds = 365 * 24 * 60 * 60 * 1000;
  } else if (actualIntervalType == DateTimeIntervalType.months) {
    intervalInMilliseconds = 30 * 24 * 60 * 60 * 1000;
  } else if (actualIntervalType == DateTimeIntervalType.days) {
    intervalInMilliseconds = 24 * 60 * 60 * 1000;
  } else if (actualIntervalType == DateTimeIntervalType.hours) {
    intervalInMilliseconds = 60 * 60 * 1000;
  } else if (actualIntervalType == DateTimeIntervalType.minutes) {
    intervalInMilliseconds = 60 * 1000;
  } else if (actualIntervalType == DateTimeIntervalType.seconds) {
    intervalInMilliseconds = 1000;
  } else {
    intervalInMilliseconds = 30 * 24 * 60 * 60 * 1000;
  }
  return intervalInMilliseconds;
}

/// Triggers marker event.
MarkerRenderArgs? triggerMarkerRenderEvent(
    SeriesRendererDetails seriesRendererDetails,
    Size size,
    DataMarkerType markerType,
    int pointIndex,
    Animation<double>? animationController,
    [ChartSegment? segment]) {
  MarkerRenderArgs? markerargs;
  final int seriesIndex = seriesRendererDetails
      .stateProperties.chartSeries.visibleSeriesRenderers
      .indexOf(seriesRendererDetails.renderer);
  final XyDataSeries<dynamic, dynamic> series =
      seriesRendererDetails.series as XyDataSeries<dynamic, dynamic>;
  final MarkerSettingsRenderer markerSettingsRenderer =
      seriesRendererDetails.markerSettingsRenderer!;
  markerSettingsRenderer.color = series.markerSettings.color;
  final bool isScatter = segment != null && segment is ScatterSegment;
  if (seriesRendererDetails.chart.onMarkerRender != null) {
    markerargs = MarkerRenderArgs(
        pointIndex,
        seriesIndex,
        seriesRendererDetails
            .visibleDataPoints![pointIndex].overallDataPointIndex!);
    markerargs.markerHeight = size.height;
    markerargs.markerWidth = size.width;
    markerargs.shape = markerType;
    markerargs.color =
        isScatter ? segment.fillPaint!.color : markerSettingsRenderer.color;
    markerargs.borderColor = isScatter
        ? segment.strokePaint!.color
        : markerSettingsRenderer.borderColor;
    markerargs.borderWidth = isScatter
        ? segment.strokePaint!.strokeWidth
        : markerSettingsRenderer.borderWidth;
    seriesRendererDetails.chart.onMarkerRender!(markerargs);
    size = Size(markerargs.markerWidth, markerargs.markerHeight);
    markerType = markerargs.shape;
    markerSettingsRenderer.color = markerargs.color;
    markerSettingsRenderer.borderColor = markerargs.borderColor;
    markerSettingsRenderer.borderWidth = markerargs.borderWidth;

    if (isScatter) {
      segment.fillPaint!.color = (markerargs.color != null &&
              segment.fillPaint!.color != markerargs.color
          ? markerargs.color
          : segment.fillPaint!.color)!;
      segment.strokePaint!.color = (markerargs.borderColor != null &&
              segment.strokePaint!.color != markerargs.borderColor
          ? markerargs.borderColor
          : segment.strokePaint!.color)!;
      // ignore: unnecessary_null_comparison
      segment.strokePaint!.strokeWidth = markerargs.borderWidth != null &&
              segment.strokePaint!.strokeWidth != markerargs.borderWidth
          ? markerargs.borderWidth
          : segment.strokePaint!.strokeWidth;
    }
  }
  return markerargs;
}

/// To find Natural ControlPoints.
List<Offset> calculateControlPoints(List<num> xValues, List<num?> yValues,
    double yCoef, double nextyCoef, int i, List<Offset> controlPoints) {
  final List<double?> values = List<double?>.filled(4, null);
  final double x = xValues[i].toDouble();
  final double y = yValues[i]!.toDouble();
  final double nextX = xValues[i + 1].toDouble();
  final double nextY = yValues[i + 1]!.toDouble();
  const double oneThird = 1 / 3.0;
  double deltaX2 = nextX - x;
  deltaX2 = deltaX2 * deltaX2;
  final double dx1 = (2 * x) + nextX;
  final double dx2 = x + (2 * nextX);
  final double dy1 = (2 * y) + nextY;
  final double dy2 = y + (2 * nextY);
  final double y1 =
      oneThird * (dy1 - (oneThird * deltaX2 * (yCoef + (0.5 * nextyCoef))));
  final double y2 =
      oneThird * (dy2 - (oneThird * deltaX2 * ((0.5 * yCoef) + nextyCoef)));
  values[0] = dx1 * oneThird;
  values[1] = y1;
  values[2] = dx2 * oneThird;
  values[3] = y2;
  controlPoints.add(Offset(values[0]!, values[1]!));
  controlPoints.add(Offset(values[2]!, values[3]!));
  return controlPoints;
}

/// To calculate spline area control points.
void calculateSplineAreaControlPoints(CartesianSeriesRenderer seriesRenderer) {
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final dynamic series = seriesRendererDetails.series;
  List<num?>? yCoef = <num?>[];
  List<num?>? lowCoef = <num?>[];
  List<num?>? highCoef = <num?>[];
  final List<num> xValues = <num>[];
  final List<num> yValues = <num>[];
  final List<num> highValues = <num>[];
  final List<num> lowValues = <num>[];
  final SplineType? splineType = series.splineType;
  int i;
  for (i = 0; i < seriesRendererDetails.dataPoints.length; i++) {
    xValues.add(seriesRendererDetails.dataPoints[i].xValue);
    if (seriesRenderer is SplineAreaSeriesRenderer ||
        seriesRenderer is SplineSeriesRenderer) {
      yValues.add(seriesRendererDetails.dataPoints[i].yValue);
    } else if (seriesRenderer is SplineRangeAreaSeriesRenderer) {
      highValues.add(seriesRendererDetails.dataPoints[i].high);
      lowValues.add(seriesRendererDetails.dataPoints[i].low);
    }
  }

  if (xValues.isNotEmpty) {
    final List<num?> dx = List<num?>.filled(xValues.length - 1, null);

    /// Check the type of spline.
    if (splineType == SplineType.monotonic) {
      if (seriesRenderer is SplineAreaSeriesRenderer ||
          seriesRenderer is SplineSeriesRenderer) {
        yCoef =
            _getMonotonicSpline(xValues, yValues, yCoef, xValues.length, dx);
      } else {
        lowCoef = _getMonotonicSpline(
            xValues, lowValues, lowCoef, xValues.length, dx);
        highCoef = _getMonotonicSpline(
            xValues, highValues, highCoef, xValues.length, dx);
      }
    } else if (splineType == SplineType.cardinal) {
      if (series is SplineAreaSeries || series is SplineSeries) {
        yCoef = _getCardinalSpline(xValues, yValues, yCoef, xValues.length,
            series.cardinalSplineTension);
      } else {
        lowCoef = _getCardinalSpline(xValues, lowValues, lowCoef,
            xValues.length, series.cardinalSplineTension);
        highCoef = _getCardinalSpline(xValues, highValues, highCoef,
            xValues.length, series.cardinalSplineTension);
      }
    } else {
      if (series is SplineAreaSeries ||
          seriesRenderer is SplineSeriesRenderer) {
        yCoef =
            naturalSpline(xValues, yValues, yCoef, xValues.length, splineType);
      } else {
        lowCoef = naturalSpline(
            xValues, lowValues, lowCoef, xValues.length, splineType);
        highCoef = naturalSpline(
            xValues, highValues, highCoef, xValues.length, splineType);
      }
    }
    (seriesRenderer is SplineAreaSeriesRenderer ||
            seriesRenderer is SplineSeriesRenderer)
        ? _updateSplineAreaControlPoints(
            seriesRenderer, splineType, xValues, yValues, yCoef, dx)
        : _findSplineRangeAreaControlPoint(
            seriesRenderer as SplineRangeAreaSeriesRenderer,
            splineType,
            xValues,
            lowValues,
            highValues,
            dx,
            lowCoef,
            highCoef);
  }
}

/// To update the dynamic points of the spline area.
void _updateSplineAreaControlPoints(
    dynamic seriesRenderer,
    SplineType? splineType,
    List<num> xValues,
    List<num> yValues,
    List<num?>? yCoef,
    List<num?>? dx) {
  double x, y, nextX, nextY;
  List<Offset> controlPoints;
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  for (int pointIndex = 0; pointIndex < xValues.length - 1; pointIndex++) {
    controlPoints = <Offset>[];
    // ignore: unnecessary_null_comparison
    if (xValues[pointIndex] != null &&
        // ignore: unnecessary_null_comparison
        yValues[pointIndex] != null &&
        // ignore: unnecessary_null_comparison
        xValues[pointIndex + 1] != null &&
        // ignore: unnecessary_null_comparison
        yValues[pointIndex + 1] != null) {
      x = xValues[pointIndex].toDouble();
      y = yValues[pointIndex].toDouble();
      nextX = xValues[pointIndex + 1].toDouble();
      nextY = yValues[pointIndex + 1].toDouble();
      if (splineType == SplineType.monotonic) {
        controlPoints = _calculateMonotonicControlPoints(
            x,
            y,
            nextX,
            nextY,
            yCoef![pointIndex]!.toDouble(),
            yCoef[pointIndex + 1]!.toDouble(),
            dx![pointIndex]!.toDouble(),
            controlPoints);
        seriesRendererDetails.drawControlPoints.add(controlPoints);
      } else if (splineType == SplineType.cardinal) {
        controlPoints = _calculateCardinalControlPoints(
            x,
            y,
            nextX,
            nextY,
            yCoef![pointIndex]!.toDouble(),
            yCoef[pointIndex + 1]!.toDouble(),
            seriesRenderer,
            controlPoints);
        seriesRendererDetails.drawControlPoints.add(controlPoints);
      } else {
        controlPoints = calculateControlPoints(
            xValues,
            yValues,
            yCoef![pointIndex]!.toDouble(),
            yCoef[pointIndex + 1]!.toDouble(),
            pointIndex,
            controlPoints);
        seriesRendererDetails.drawControlPoints.add(controlPoints);
      }
    }
  }
}

/// Calculate spline range area control point.
void _findSplineRangeAreaControlPoint(
    SplineRangeAreaSeriesRenderer seriesRenderer,
    SplineType? splineType,
    List<num> xValues,
    List<num> lowValues,
    List<num> highValues,
    List<num?>? dx,
    List<num?>? lowCoef,
    List<num?>? highCoef) {
  List<Offset> controlPointslow, controlPointshigh;
  double x, low, high, nextX, nextlow, nexthigh;
  int pointIndex;
  for (pointIndex = 0; pointIndex < xValues.length - 1; pointIndex++) {
    controlPointslow = <Offset>[];
    controlPointshigh = <Offset>[];
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
    // ignore: unnecessary_null_comparison
    if (xValues[pointIndex] != null &&
        seriesRendererDetails.dataPoints[pointIndex].low != null &&
        seriesRendererDetails.dataPoints[pointIndex].high != null &&
        // ignore: unnecessary_null_comparison
        xValues[pointIndex + 1] != null &&
        seriesRendererDetails.dataPoints[pointIndex + 1].low != null &&
        seriesRendererDetails.dataPoints[pointIndex + 1].high != null) {
      x = xValues[pointIndex].toDouble();
      low = seriesRendererDetails.dataPoints[pointIndex].low.toDouble();
      high = seriesRendererDetails.dataPoints[pointIndex].high.toDouble();
      nextX = xValues[pointIndex + 1].toDouble();
      nextlow = seriesRendererDetails.dataPoints[pointIndex + 1].low.toDouble();
      nexthigh =
          seriesRendererDetails.dataPoints[pointIndex + 1].high.toDouble();
      if (splineType == SplineType.monotonic) {
        controlPointslow = _calculateMonotonicControlPoints(
            x,
            low,
            nextX,
            nextlow,
            lowCoef![pointIndex]!.toDouble(),
            lowCoef[pointIndex + 1]!.toDouble(),
            dx![pointIndex]!.toDouble(),
            controlPointslow);
        seriesRendererDetails.drawLowControlPoints.add(controlPointslow);
        controlPointshigh = _calculateMonotonicControlPoints(
            x,
            high,
            nextX,
            nexthigh,
            highCoef![pointIndex]!.toDouble(),
            highCoef[pointIndex + 1]!.toDouble(),
            dx[pointIndex]!.toDouble(),
            controlPointshigh);
        seriesRendererDetails.drawHighControlPoints.add(controlPointshigh);
      } else if (splineType == SplineType.cardinal) {
        controlPointslow = _calculateCardinalControlPoints(
            x,
            low,
            nextX,
            nextlow,
            lowCoef![pointIndex]!.toDouble(),
            lowCoef[pointIndex + 1]!.toDouble(),
            seriesRenderer,
            controlPointslow);
        seriesRendererDetails.drawLowControlPoints.add(controlPointslow);
        controlPointshigh = _calculateCardinalControlPoints(
            x,
            high,
            nextX,
            nexthigh,
            highCoef![pointIndex]!.toDouble(),
            highCoef[pointIndex + 1]!.toDouble(),
            seriesRenderer,
            controlPointshigh);
        seriesRendererDetails.drawHighControlPoints.add(controlPointshigh);
      } else {
        controlPointslow = calculateControlPoints(
            xValues,
            lowValues,
            lowCoef![pointIndex]!.toDouble(),
            lowCoef[pointIndex + 1]!.toDouble(),
            pointIndex,
            controlPointslow);
        seriesRendererDetails.drawLowControlPoints.add(controlPointslow);
        controlPointshigh = calculateControlPoints(
            xValues,
            highValues,
            highCoef![pointIndex]!.toDouble(),
            highCoef[pointIndex + 1]!.toDouble(),
            pointIndex,
            controlPointshigh);
        seriesRendererDetails.drawHighControlPoints.add(controlPointshigh);
      }
    }
  }
}

/// Get the old axis (for stock chart animation).
ChartAxisRenderer? getOldAxisRenderer(ChartAxisRenderer axisRenderer,
    List<ChartAxisRenderer> oldAxisRendererList) {
  for (int i = 0; i < oldAxisRendererList.length; i++) {
    if (AxisHelper.getAxisRendererDetails(oldAxisRendererList[i]).name ==
        AxisHelper.getAxisRendererDetails(axisRenderer).name) {
      return oldAxisRendererList[i];
    }
  }
  return null;
}

/// To get chart point.
CartesianChartPoint<dynamic>? getChartPoint(
    CartesianSeriesRenderer seriesRenderer, dynamic data, int pointIndex) {
  dynamic xVal,
      yVal,
      highVal,
      lowVal,
      openVal,
      closeVal,
      volumeVal,
      sortVal,
      sizeVal,
      colorVal,
      textVal,
      minVal,
      minimumVal,
      maximumVal;
  bool? isIntermediateSum, isTotalSum;
  CartesianChartPoint<dynamic>? currentPoint;
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  final dynamic series = seriesRendererDetails.series;
  final ChartIndexedValueMapper<dynamic>? xMap = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic>? yMap = series.yValueMapper;
  final ChartIndexedValueMapper<num>? highMap = series.highValueMapper;
  final ChartIndexedValueMapper<num>? lowMap = series.lowValueMapper;
  final ChartIndexedValueMapper<bool>? isIntermediateSumMap =
      series.intermediateSumPredicate;
  final ChartIndexedValueMapper<bool>? isTotalSumMap = series.totalSumPredicate;
  final ChartIndexedValueMapper<dynamic>? sortFieldMap =
      series.sortFieldValueMapper;
  final ChartIndexedValueMapper<Color>? pointColorMap = series.pointColorMapper;
  final dynamic sizeMap = series.sizeValueMapper;
  final ChartIndexedValueMapper<String>? pointTextMap = series.dataLabelMapper;

  if (seriesRenderer is HistogramSeriesRenderer) {
    minVal = seriesRendererDetails.histogramValues.minValue;
    yVal = seriesRendererDetails.histogramValues.yValues!
        .where((dynamic x) =>
            x >= minVal == true &&
            x < (minVal + seriesRendererDetails.histogramValues.binWidth) ==
                true)
        .length;
    xVal = minVal + seriesRendererDetails.histogramValues.binWidth! / 2;
    minVal += seriesRendererDetails.histogramValues.binWidth;
    seriesRendererDetails.histogramValues.minValue = minVal;
  } else {
    if (xMap != null) {
      xVal = xMap(pointIndex);
    }

    if (yMap != null) {
      yVal = (series is RangeColumnSeries ||
              series is RangeAreaSeries ||
              series is HiloSeries ||
              series is HiloOpenCloseSeries ||
              series is SplineRangeAreaSeries ||
              series is CandleSeries)
          ? null
          : yMap(pointIndex);
    }
  }

  if (xVal != null) {
    if (yVal != null) {
      assert(
          yVal.runtimeType == num ||
              yVal.runtimeType == double ||
              yVal.runtimeType == int ||
              yVal.runtimeType.toString() == 'List<num?>' ||
              yVal.runtimeType.toString() == 'List<num>' ||
              yVal.runtimeType.toString() == 'List<double?>' ||
              yVal.runtimeType.toString() == 'List<double>' ||
              yVal.runtimeType.toString() == 'List<int?>' ||
              yVal.runtimeType.toString() == 'List<int>',
          'The Y value will accept only number or list of numbers.');
    }
    if (yVal != null && series is BoxAndWhiskerSeries) {
      final List<dynamic> yValues = yVal;
      //ignore: always_specify_types
      yValues.removeWhere((value) => value == null);
      maximumVal = yValues.cast<num>().reduce(max);
      minimumVal = yValues.cast<num>().reduce(min);
    }
    if (highMap != null) {
      highVal = highMap(pointIndex);
    }

    if (lowMap != null) {
      lowVal = lowMap(pointIndex);
    }

    if (series is FinancialSeriesBase) {
      final FinancialSeriesBase<dynamic, dynamic> financialSeries =
          seriesRendererDetails.series as FinancialSeriesBase<dynamic, dynamic>;
      final ChartIndexedValueMapper<num>? openMap =
          financialSeries.openValueMapper;
      final ChartIndexedValueMapper<num>? closeMap =
          financialSeries.closeValueMapper;
      final ChartIndexedValueMapper<num>? volumeMap =
          financialSeries.volumeValueMapper;

      if (openMap != null) {
        openVal = openMap(pointIndex);
      }

      if (closeMap != null) {
        closeVal = closeMap(pointIndex);
      }

      if (volumeMap != null && financialSeries is HiloOpenCloseSeries) {
        volumeVal = volumeMap(pointIndex);
      }
    }

    if (sortFieldMap != null) {
      sortVal = sortFieldMap(pointIndex);
    }

    if (sizeMap != null) {
      sizeVal = sizeMap(pointIndex);
    }

    if (pointColorMap != null) {
      colorVal = pointColorMap(pointIndex);
    }

    if (pointTextMap != null) {
      textVal = pointTextMap(pointIndex);
    }

    if (isIntermediateSumMap != null) {
      isIntermediateSum = isIntermediateSumMap(pointIndex);
      isIntermediateSum ??= false;
    } else {
      isIntermediateSum = false;
    }

    if (isTotalSumMap != null) {
      isTotalSum = isTotalSumMap(pointIndex);
      isTotalSum ??= false;
    } else {
      isTotalSum = false;
    }
    currentPoint = CartesianChartPoint<dynamic>(
        xVal,
        yVal,
        textVal,
        colorVal,
        sizeVal,
        highVal,
        lowVal,
        openVal,
        closeVal,
        volumeVal,
        sortVal,
        minimumVal,
        maximumVal,
        isIntermediateSum,
        isTotalSum);
  }
  return currentPoint;
}

/// Gets the minimum value.
num findMinValue(num axisValue, num pointValue) =>
    math.min(axisValue, pointValue);

/// Gets the maximum value.
num findMaxValue(num axisValue, num pointValue) =>
    math.max(axisValue, pointValue);

/// This method finds whether the given point has been updated/changed and returns a boolean value.
bool findChangesInPoint(
    CartesianChartPoint<dynamic> point,
    CartesianChartPoint<dynamic> oldPoint,
    SeriesRendererDetails seriesRendererDetails) {
  if (seriesRendererDetails.series.sortingOrder ==
      seriesRendererDetails.oldSeries?.sortingOrder) {
    if (seriesRendererDetails.renderer is CandleSeriesRenderer ||
        seriesRendererDetails.seriesType.contains('range') == true ||
        seriesRendererDetails.seriesType.contains('hilo') == true) {
      return point.x != oldPoint.x ||
          point.high != oldPoint.high ||
          point.low != oldPoint.low ||
          point.open != oldPoint.open ||
          point.close != oldPoint.close ||
          point.volume != oldPoint.volume ||
          point.sortValue != oldPoint.sortValue;
    } else if (seriesRendererDetails.seriesType == 'waterfall') {
      return point.x != oldPoint.x ||
          (point.y != null && (point.y != oldPoint.y)) ||
          point.sortValue != oldPoint.sortValue ||
          point.isIntermediateSum != oldPoint.isIntermediateSum ||
          point.isTotalSum != oldPoint.isTotalSum;
    } else if (seriesRendererDetails.seriesType == 'boxandwhisker') {
      if (point.y.length != oldPoint.y.length ||
          point.x != oldPoint.x ||
          point.sortValue != oldPoint.sortValue) {
        return true;
      } else {
        point.y.sort();
        for (int i = 0; i < point.y.length; i++) {
          if (point.y[i] != oldPoint.y[i]) {
            return true;
          }
        }
        return false;
      }
    } else {
      return point.x != oldPoint.x ||
          point.y != oldPoint.y ||
          point.bubbleSize != oldPoint.bubbleSize ||
          point.sortValue != oldPoint.sortValue;
    }
  } else {
    return true;
  }
}

/// To calculate range Y on zoom mode X.
VisibleRange calculateYRangeOnZoomX(
    VisibleRange actualRange, dynamic axisRenderer) {
  num? mini, maxi;
  final dynamic axis = axisRenderer.axis;
  final List<CartesianSeriesRenderer> seriesRenderers =
      axisRenderer.seriesRenderers;
  final num? minimum = axis.minimum, maximum = axis.maximum;
  for (int i = 0;
      i < seriesRenderers.length && seriesRenderers.isNotEmpty;
      i++) {
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderers[i]);
    final dynamic xAxisRenderer = seriesRendererDetails.xAxisDetails;
    xAxisRenderer.calculateRangeAndInterval(
        axisRenderer.stateProperties, 'AnchoringRange');
    final VisibleRange xRange = xAxisRenderer.visibleRange;
    if (seriesRendererDetails.yAxisDetails == axisRenderer &&
        // ignore: unnecessary_null_comparison
        xRange != null &&
        seriesRendererDetails.visible! == true) {
      final List<CartesianChartPoint<dynamic>> dataPoints =
          getSampledData(seriesRendererDetails);
      for (int j = 0; j < dataPoints.length; j++) {
        final CartesianChartPoint<dynamic> point = dataPoints[j];
        if (point.xValue >= xRange.minimum == true &&
            point.xValue <= xRange.maximum == true) {
          if (point.cumulativeValue != null || point.yValue != null) {
            final num yValue = point.cumulativeValue != null
                ? point.cumulativeValue!
                : point.yValue;
            mini = min(mini ?? yValue, yValue);
            maxi = max(maxi ?? yValue, yValue);
          } else if (point.high != null && point.low != null) {
            mini = min(mini ?? point.low, point.low);
            maxi = max(maxi ?? point.high, point.high);
          }
        }
      }
    }
  }
  return VisibleRange(minimum ?? (mini ?? actualRange.minimum),
      maximum ?? (maxi ?? actualRange.maximum));
}

/// Bool to calculate for Y range.
bool needCalculateYRange(num? minimum, num? maximum,
    CartesianStateProperties stateProperties, AxisOrientation orientation) {
  final SfCartesianChart chart = stateProperties.chart;
  return !(minimum != null && maximum != null) &&
      (stateProperties.rangeChangeBySlider ||
          (((stateProperties.zoomedState ?? false) ||
                  stateProperties.zoomProgress ||
                  stateProperties.chart.indicators.isNotEmpty) &&
              (!stateProperties.requireInvertedAxis
                  ? (orientation == AxisOrientation.vertical &&
                      chart.zoomPanBehavior.zoomMode == ZoomMode.x)
                  : (orientation == AxisOrientation.horizontal &&
                      chart.zoomPanBehavior.zoomMode == ZoomMode.y))));
}

/// This method returns the axisRenderer for the given axis from given collection, if not found returns null.
ChartAxisRenderer? findExistingAxisRenderer(
    ChartAxis axis, List<ChartAxisRenderer> axisRenderers) {
  for (final ChartAxisRenderer axisRenderer in axisRenderers) {
    if (identical(axis, AxisHelper.getAxisRendererDetails(axisRenderer).axis)) {
      return axisRenderer;
    }
  }
  return null;
}

/// Method to get the old segment index value.
int getOldSegmentIndex(ChartSegment segment) {
  final SegmentProperties segmentProperties =
      SegmentHelper.getSegmentProperties(segment);
  if (segmentProperties.oldSeriesRenderer != null) {
    for (final ChartSegment oldSegment in SeriesHelper.getSeriesRendererDetails(
            segmentProperties.oldSeriesRenderer!)
        .segments) {
      final SegmentProperties oldSegmentProperties =
          SegmentHelper.getSegmentProperties(oldSegment);
      if (segment.runtimeType == oldSegment.runtimeType &&
          (SeriesHelper.getSeriesRendererDetails(
                      segmentProperties.seriesRenderer)
                  .xAxisDetails is CategoryAxisRenderer
              ? oldSegmentProperties.currentPoint!.x ==
                  segmentProperties.currentPoint!.x
              : oldSegmentProperties.currentPoint!.xValue ==
                  segmentProperties.currentPoint!.xValue)) {
        final SeriesRendererDetails rendererDetails =
            SeriesHelper.getSeriesRendererDetails(
                segmentProperties.oldSeriesRenderer!);
        return rendererDetails.segments.indexOf(oldSegment);
      }
    }
  }
  return -1;
}

/// This method determines whether all the series animations have been completed and renders the datalabel.
void setAnimationStatus(CartesianStateProperties stateProperties) {
  if (stateProperties.totalAnimatingSeries ==
      stateProperties.animationCompleteCount) {
    stateProperties.renderingDetails.animateCompleted = true;
    stateProperties.animationCompleteCount = 0;
  } else {
    stateProperties.renderingDetails.animateCompleted = false;
  }
  if (stateProperties.renderDataLabel != null) {
    if (stateProperties.renderDataLabel!.state!.mounted == true) {
      stateProperties.renderDataLabel!.state?.render();
    }
  }
}

/// Calculate date time nice interval.
int calculateDateTimeNiceInterval(
    ChartAxisRenderer axisRenderer, Size size, VisibleRange range,
    [DateTime? startDate, DateTime? endDate]) {
  final ChartAxis axis = AxisHelper.getAxisRendererDetails(axisRenderer).axis;
  DateTime? visibleMinimum, visibleMaximum;
  DateTimeIntervalType? actualIntervalType;
  if (axis is DateTimeAxis) {
    visibleMinimum = axis.visibleMinimum;
    visibleMaximum = axis.visibleMaximum;
  } else if (axis is DateTimeCategoryAxis) {
    visibleMinimum = axis.visibleMinimum;
    visibleMaximum = axis.visibleMaximum;
  }
  final bool notDoubleInterval =
      (visibleMinimum == null || visibleMaximum == null) ||
          (axis.interval != null && axis.interval! % 1 == 0) ||
          (axis.interval == null);
  const int perDay = 24 * 60 * 60 * 1000;
  startDate ??= DateTime.fromMillisecondsSinceEpoch(range.minimum.toInt());
  endDate ??= DateTime.fromMillisecondsSinceEpoch(range.maximum.toInt());
  num? interval;
  const num hours = 24, minutes = 60, seconds = 60, milliseconds = 1000;
  final num totalDays =
      ((startDate.millisecondsSinceEpoch - endDate.millisecondsSinceEpoch) /
              perDay)
          .abs();
  dynamic axisRendererDetails;
  if (axis is DateTimeAxis) {
    axisRendererDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer) as DateTimeAxisDetails;
    actualIntervalType = axis.intervalType;
  } else if (axis is DateTimeCategoryAxis) {
    axisRendererDetails = AxisHelper.getAxisRendererDetails(axisRenderer)
        as DateTimeCategoryAxisDetails;
    actualIntervalType = axis.intervalType;
  }
  switch (actualIntervalType) {
    case DateTimeIntervalType.years:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays / 365, size);
      break;
    case DateTimeIntervalType.months:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays / 30, size);
      break;
    case DateTimeIntervalType.days:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays, size);
      break;
    case DateTimeIntervalType.hours:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * hours, size);
      break;
    case DateTimeIntervalType.minutes:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * hours * minutes, size);
      break;
    case DateTimeIntervalType.seconds:
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * hours * minutes * seconds, size);
      break;
    case DateTimeIntervalType.milliseconds:
      interval = axisRendererDetails.calculateNumericNiceInterval(axisRenderer,
          totalDays * hours * minutes * seconds * milliseconds, size);
      break;
    case DateTimeIntervalType.auto:

      /// For years.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays / 365, size);
      if (interval! >= 1) {
        _setActualIntervalType(axisRenderer, DateTimeIntervalType.years);
        return interval.floor();
      }

      /// For months.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays / 30, size);
      if (interval! >= 1) {
        _setActualIntervalType(
            axisRenderer,
            notDoubleInterval
                ? DateTimeIntervalType.months
                : DateTimeIntervalType.years);
        return interval.floor();
      }

      /// For days.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays, size);
      if (interval! >= 1) {
        _setActualIntervalType(
            axisRenderer,
            notDoubleInterval
                ? DateTimeIntervalType.days
                : DateTimeIntervalType.months);
        return interval.floor();
      }

      /// For hours.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * 24, size);
      if (interval! >= 1) {
        _setActualIntervalType(
            axisRenderer,
            notDoubleInterval
                ? DateTimeIntervalType.hours
                : DateTimeIntervalType.days);
        return interval.floor();
      }

      /// For minutes.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * 24 * 60, size);
      if (interval! >= 1) {
        _setActualIntervalType(
            axisRenderer,
            notDoubleInterval
                ? DateTimeIntervalType.minutes
                : DateTimeIntervalType.hours);
        return interval.floor();
      }

      /// For seconds.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * 24 * 60 * 60, size);
      if (interval! >= 1) {
        _setActualIntervalType(
            axisRenderer,
            notDoubleInterval
                ? DateTimeIntervalType.seconds
                : DateTimeIntervalType.minutes);
        return interval.floor();
      }

      /// For milliseconds.
      interval = axisRendererDetails.calculateNumericNiceInterval(
          axisRenderer, totalDays * 24 * 60 * 60 * 1000, size);
      _setActualIntervalType(
          axisRenderer,
          notDoubleInterval
              ? DateTimeIntervalType.milliseconds
              : DateTimeIntervalType.seconds);
      return interval! < 1 ? interval.ceil() : interval.floor();
    // ignore: no_default_cases
    default:
      break;
  }
  _setActualIntervalType(axisRenderer, actualIntervalType!);
  return interval! < 1 ? interval.ceil() : interval.floor();
}

void _setActualIntervalType(
    ChartAxisRenderer axisRenderer, DateTimeIntervalType intervalType) {
  if (axisRenderer is DateTimeAxisRenderer) {
    final DateTimeAxisDetails dateTimeAxisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer) as DateTimeAxisDetails;
    dateTimeAxisDetails.actualIntervalType = intervalType;
  } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
    final DateTimeCategoryAxisDetails dateTimeCategoryAxisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer)
            as DateTimeCategoryAxisDetails;
    dateTimeCategoryAxisDetails.actualIntervalType = intervalType;
  }
}

/// To get the label format of the date-time axis.
DateFormat getDateTimeLabelFormat(ChartAxisRenderer axisRenderer,
    [int? interval, int? prevInterval]) {
  DateFormat? format;
  final ChartAxisRendererDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(axisRenderer);
  final bool notDoubleInterval = (axisRendererDetails.axis.interval != null &&
          axisRendererDetails.axis.interval! % 1 == 0) ||
      axisRendererDetails.axis.interval == null;
  DateTimeIntervalType? actualIntervalType;
  VisibleRange? visibleRange;
  num? minimum;
  if (axisRenderer is DateTimeAxisRenderer) {
    final DateTimeAxisDetails dateTimeAxisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer) as DateTimeAxisDetails;
    actualIntervalType = dateTimeAxisDetails.actualIntervalType;
    visibleRange = dateTimeAxisDetails.visibleRange;
    minimum = dateTimeAxisDetails.min;
  } else if (axisRenderer is DateTimeCategoryAxisRenderer) {
    final DateTimeCategoryAxisDetails dateTimeCategoryAxisDetails =
        AxisHelper.getAxisRendererDetails(axisRenderer)
            as DateTimeCategoryAxisDetails;
    visibleRange = dateTimeCategoryAxisDetails.visibleRange;
    minimum = dateTimeCategoryAxisDetails.min;
    actualIntervalType = dateTimeCategoryAxisDetails.actualIntervalType;
  }
  switch (actualIntervalType) {
    case DateTimeIntervalType.years:
      format = notDoubleInterval ? DateFormat.y() : DateFormat.MMMd();
      break;
    case DateTimeIntervalType.months:
      format = (minimum == interval || interval == prevInterval)
          ? _getFirstLabelFormat(actualIntervalType)
          : _getDateTimeFormat(
              actualIntervalType, visibleRange, interval, prevInterval);

      break;
    case DateTimeIntervalType.days:
      format = (minimum == interval || interval == prevInterval)
          ? _getFirstLabelFormat(actualIntervalType)
          : _getDateTimeFormat(
              actualIntervalType, visibleRange, interval, prevInterval);
      break;
    case DateTimeIntervalType.hours:
      format = DateFormat.j();
      break;
    case DateTimeIntervalType.minutes:
      format = DateFormat.Hm();
      break;
    case DateTimeIntervalType.seconds:
      format = DateFormat.ms();
      break;
    case DateTimeIntervalType.milliseconds:
      final DateFormat? dateFormat = DateFormat('ss.SSS');
      format = dateFormat;
      break;
    case DateTimeIntervalType.auto:
      break;
    // ignore: no_default_cases
    default:
      break;
  }
  return format!;
}

/// Calculate the dateTime format.
DateFormat? _getDateTimeFormat(DateTimeIntervalType? actualIntervalType,
    VisibleRange? visibleRange, int? interval, int? prevInterval) {
  final DateTime minimum = DateTime.fromMillisecondsSinceEpoch(interval!);
  final DateTime maximum = DateTime.fromMillisecondsSinceEpoch(prevInterval!);
  DateFormat? format;
  final bool isIntervalDecimal = visibleRange!.interval % 1 == 0;
  if (actualIntervalType == DateTimeIntervalType.months) {
    format = minimum.year == maximum.year
        ? (isIntervalDecimal ? DateFormat.MMM() : DateFormat.MMMd())
        : DateFormat('yyy MMM');
  } else if (actualIntervalType == DateTimeIntervalType.days) {
    format = minimum.month != maximum.month
        ? (isIntervalDecimal ? DateFormat.MMMd() : DateFormat.MEd())
        : DateFormat.d();
  }

  return format;
}

/// Returns the first label format for date time values.
DateFormat? _getFirstLabelFormat(DateTimeIntervalType? actualIntervalType) {
  DateFormat? format;

  if (actualIntervalType == DateTimeIntervalType.months) {
    format = DateFormat('yyy MMM');
  } else if (actualIntervalType == DateTimeIntervalType.days) {
    format = DateFormat.MMMd();
  } else if (actualIntervalType == DateTimeIntervalType.minutes) {
    format = DateFormat.Hm();
  }

  return format;
}

/// Method to set the minimum and maximum value of category axis.
void setCategoryMinMaxValues(
    ChartAxisRenderer axisRenderer,
    bool isXVisibleRange,
    bool isYVisibleRange,
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    int dataLength,
    SeriesRendererDetails seriesRendererDetails) {
  final ChartAxisRendererDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(axisRenderer);
  final String seriesType = seriesRendererDetails.seriesType;
  final bool anchorRangeToVisiblePoints =
      seriesRendererDetails.yAxisDetails!.axis.anchorRangeToVisiblePoints;
  if (isYVisibleRange) {
    seriesRendererDetails.minimumX ??= point.xValue;
    seriesRendererDetails.maximumX ??= point.xValue;
  }
  if ((isXVisibleRange || !anchorRangeToVisiblePoints) &&
      !seriesType.contains('range') &&
      !seriesType.contains('hilo') &&
      !seriesType.contains('candle') &&
      seriesType != 'boxandwhisker' &&
      seriesType != 'waterfall') {
    seriesRendererDetails.minimumY ??= point.yValue;
    seriesRendererDetails.maximumY ??= point.yValue;
  }
  if (isYVisibleRange && point.xValue != null) {
    seriesRendererDetails.minimumX =
        math.min(seriesRendererDetails.minimumX!, point.xValue);
    seriesRendererDetails.maximumX =
        math.max(seriesRendererDetails.maximumX!, point.xValue);
  }
  if (isXVisibleRange || !anchorRangeToVisiblePoints) {
    if (point.yValue != null &&
        (!seriesType.contains('range') &&
            !seriesType.contains('hilo') &&
            !seriesType.contains('candle') &&
            seriesType != 'boxandwhisker' &&
            seriesType != 'waterfall')) {
      seriesRendererDetails.minimumY =
          math.min(seriesRendererDetails.minimumY!, point.yValue);
      seriesRendererDetails.maximumY =
          math.max(seriesRendererDetails.maximumY!, point.yValue);
    }

    if (point.high != null) {
      axisRendererDetails.highMin =
          findMinValue(axisRendererDetails.highMin ?? point.high, point.high);
      axisRendererDetails.highMax =
          findMaxValue(axisRendererDetails.highMax ?? point.high, point.high);
    }
    if (point.low != null) {
      axisRendererDetails.lowMin =
          findMinValue(axisRendererDetails.lowMin ?? point.low, point.low);
      axisRendererDetails.lowMax =
          findMaxValue(axisRendererDetails.lowMax ?? point.low, point.low);
    }
    if (point.maximum != null) {
      axisRendererDetails.highMin = findMinValue(
          axisRendererDetails.highMin ?? point.maximum!, point.maximum!);
      axisRendererDetails.highMax = findMaxValue(
          axisRendererDetails.highMax ?? point.minimum!, point.maximum!);
    }
    if (point.minimum != null) {
      axisRendererDetails.lowMin = findMinValue(
          axisRendererDetails.lowMin ?? point.minimum!, point.minimum!);
      axisRendererDetails.lowMax = findMaxValue(
          axisRendererDetails.lowMax ?? point.minimum!, point.minimum!);
    }
    if (seriesType == 'waterfall') {
      /// Empty point is not applicable for Waterfall series.
      point.yValue ??= 0;
      seriesRendererDetails.minimumY = findMinValue(
          seriesRendererDetails.minimumY ?? point.yValue, point.yValue);
      seriesRendererDetails.maximumY = findMaxValue(
          seriesRendererDetails.maximumY ?? point.maxYValue, point.maxYValue);
    } else if (seriesType == 'errorbar') {
      updateErrorBarAxisRange(seriesRendererDetails, point);
    }
  }

  if (pointIndex >= dataLength - 1) {
    if (seriesType.contains('range') ||
        seriesType.contains('hilo') ||
        seriesType.contains('candle') ||
        seriesType == 'boxandwhisker') {
      axisRendererDetails.lowMin ??= 0;
      axisRendererDetails.lowMax ??= 5;
      axisRendererDetails.highMin ??= 0;
      axisRendererDetails.highMax ??= 5;
      seriesRendererDetails.minimumY =
          math.min(axisRendererDetails.lowMin!, axisRendererDetails.highMin!);
      seriesRendererDetails.maximumY =
          math.max(axisRendererDetails.lowMax!, axisRendererDetails.highMax!);
    }
    seriesRendererDetails.minimumY ??= 0;
    seriesRendererDetails.maximumY ??= 5;
  }
}

/// Method to calculate the date time visible range.
void calculateDateTimeVisibleRange(
    Size availableSize, ChartAxisRenderer axisRenderer) {
  final ChartAxisRendererDetails axisRendererDetails =
      AxisHelper.getAxisRendererDetails(axisRenderer);
  final VisibleRange actualRange = axisRendererDetails.actualRange!;
  final CartesianStateProperties stateProperties =
      axisRendererDetails.stateProperties;
  axisRendererDetails.setOldRangeFromRangeController();
  axisRendererDetails.visibleRange = stateProperties.rangeChangeBySlider &&
          axisRendererDetails.rangeMinimum != null &&
          axisRendererDetails.rangeMaximum != null
      ? VisibleRange(
          axisRendererDetails.rangeMinimum, axisRendererDetails.rangeMaximum)
      : VisibleRange(actualRange.minimum, actualRange.maximum);
  final VisibleRange visibleRange = axisRendererDetails.visibleRange!;
  visibleRange.delta = actualRange.delta;
  visibleRange.interval = actualRange.interval;
  bool canAutoScroll = false;
  if (axisRendererDetails.axis.autoScrollingDelta != null &&
      axisRendererDetails.axis.autoScrollingDelta! > 0 &&
      !stateProperties.isRedrawByZoomPan) {
    canAutoScroll = true;
    if (axisRenderer is DateTimeAxisRenderer) {
      final DateTimeAxisDetails dateTimeAxisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer)
              as DateTimeAxisDetails;
      dateTimeAxisDetails.updateScrollingDelta();
    } else {
      final DateTimeCategoryAxisDetails dateTimeCategoryAxisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer)
              as DateTimeCategoryAxisDetails;
      dateTimeCategoryAxisDetails.updateAutoScrollingDelta(
          dateTimeCategoryAxisDetails.axis.autoScrollingDelta!, axisRenderer);
    }
  }
  if ((!canAutoScroll || (stateProperties.zoomedState ?? false)) &&
      !(stateProperties.rangeChangeBySlider &&
          !stateProperties.canSetRangeController)) {
    axisRendererDetails.setZoomFactorAndPosition(
        axisRenderer, stateProperties.zoomedAxisRendererStates);
  }
  if (axisRendererDetails.zoomFactor < 1 ||
      axisRendererDetails.zoomPosition > 0 ||
      (axisRendererDetails.axis.rangeController != null &&
          !stateProperties.renderingDetails.initialRender!)) {
    stateProperties.zoomProgress = true;
    axisRendererDetails.calculateZoomRange(axisRenderer, availableSize);
    visibleRange.interval =
        axisRendererDetails.axis.enableAutoIntervalOnZooming &&
                stateProperties.zoomProgress &&
                !canAutoScroll &&
                (axisRenderer is DateTimeAxisRenderer ||
                    axisRenderer is DateTimeCategoryAxisRenderer)
            ? axisRenderer.calculateInterval(visibleRange, availableSize)
            : visibleRange.interval;
    if (axisRenderer is DateTimeAxisRenderer) {
      visibleRange.minimum = (visibleRange.minimum).floor();
      visibleRange.maximum = (visibleRange.maximum).floor();
    }
    if (axisRendererDetails.axis.rangeController != null &&
        stateProperties.isRedrawByZoomPan &&
        stateProperties.canSetRangeController &&
        stateProperties.zoomProgress) {
      stateProperties.rangeChangedByChart = true;
      axisRendererDetails.setRangeControllerValues(axisRenderer);
    }
  }
  axisRendererDetails.setZoomValuesFromRangeController();
}

/// This method used to return the cross value of the axis.
num? getCrossesAtValue(CartesianSeriesRenderer seriesRenderer,
    CartesianStateProperties stateProperties) {
  num? crossesAt;
  final int seriesIndex = stateProperties.chartSeries.visibleSeriesRenderers
      .indexOf(seriesRenderer);
  final List<ChartAxisRenderer> axisCollection =
      stateProperties.requireInvertedAxis
          ? stateProperties.chartAxis.verticalAxisRenderers
          : stateProperties.chartAxis.horizontalAxisRenderers;
  for (int i = 0; i < axisCollection.length; i++) {
    final ChartAxisRendererDetails axisRendererDetails =
        AxisHelper.getAxisRendererDetails(axisCollection[i]);
    if (SeriesHelper.getSeriesRendererDetails(
                stateProperties.chartSeries.visibleSeriesRenderers[seriesIndex])
            .xAxisDetails!
            .name ==
        axisRendererDetails.name) {
      crossesAt = axisRendererDetails.crossValue;
      break;
    }
  }
  return crossesAt;
}

/// Method to get the tooltip padding data.
List<Offset?> getTooltipPaddingData(SeriesRendererDetails seriesRendererDetails,
    bool isTrendLine, Rect region, Rect paddedRegion, Offset? tooltipPosition) {
  Offset? padding, position;
  if (seriesRendererDetails.seriesType == 'bubble' && !isTrendLine) {
    padding = Offset(region.center.dx - region.centerLeft.dx,
        2 * (region.center.dy - region.topCenter.dy));
    position = Offset(tooltipPosition!.dx, paddedRegion.top);
    if (region.top < 0) {
      padding = Offset(padding.dx, padding.dy + region.top);
    }
  } else if (seriesRendererDetails.seriesType == 'scatter') {
    padding = Offset(seriesRendererDetails.series.markerSettings.width,
        seriesRendererDetails.series.markerSettings.height / 2);
    position = Offset(tooltipPosition!.dx, tooltipPosition.dy);
  } else if (seriesRendererDetails.seriesType.contains('rangearea') == true) {
    padding = Offset(seriesRendererDetails.series.markerSettings.width,
        seriesRendererDetails.series.markerSettings.height / 2);
    position = Offset(tooltipPosition!.dx, tooltipPosition.dy);
  } else {
    padding = (seriesRendererDetails.series.markerSettings.isVisible == true)
        ? Offset(
            seriesRendererDetails.series.markerSettings.width / 2,
            seriesRendererDetails.series.markerSettings.height / 2 +
                seriesRendererDetails.series.markerSettings.borderWidth / 2)
        : const Offset(2, 2);
  }
  return <Offset?>[padding, position ?? tooltipPosition];
}

/// Returns the old series renderer instance for the given series renderer.
CartesianSeriesRenderer? getOldSeriesRenderer(
    CartesianStateProperties stateProperties,
    SeriesRendererDetails seriesRendererDetails,
    int seriesIndex,
    List<CartesianSeriesRenderer> oldSeriesRenderers) {
  if (stateProperties.renderingDetails.widgetNeedUpdate &&
      seriesRendererDetails.xAxisDetails!.zoomFactor == 1 &&
      seriesRendererDetails.yAxisDetails!.zoomFactor == 1 &&
      // ignore: unnecessary_null_comparison
      oldSeriesRenderers != null &&
      oldSeriesRenderers.isNotEmpty &&
      oldSeriesRenderers.length - 1 >= seriesIndex &&
      SeriesHelper.getSeriesRendererDetails(oldSeriesRenderers[seriesIndex])
              .seriesName ==
          seriesRendererDetails.seriesName) {
    return oldSeriesRenderers[seriesIndex];
  } else {
    return null;
  }
}

/// Returns the old chart point for the given point and series index if present.
CartesianChartPoint<dynamic>? getOldChartPoint(
    CartesianStateProperties stateProperties,
    SeriesRendererDetails seriesRendererDetails,
    Type segmentType,
    int seriesIndex,
    int pointIndex,
    CartesianSeriesRenderer? oldSeriesRenderer,
    List<CartesianSeriesRenderer> oldSeriesRenderers) {
  final RenderingDetails renderingDetails = stateProperties.renderingDetails;
  return seriesRendererDetails.reAnimate == false &&
          (seriesRendererDetails.series.animationDuration > 0 &&
              renderingDetails.widgetNeedUpdate &&
              !renderingDetails.isLegendToggled &&
              // ignore: unnecessary_null_comparison
              oldSeriesRenderers != null &&
              oldSeriesRenderers.isNotEmpty &&
              oldSeriesRenderer != null &&
              SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer)
                      .segments
                      .isNotEmpty ==
                  true &&
              SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer)
                      .segments[0]
                      .runtimeType ==
                  segmentType &&
              oldSeriesRenderers.length - 1 >= seriesIndex &&
              SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer)
                          .dataPoints
                          .length -
                      1 >=
                  pointIndex)
      ? seriesRendererDetails.seriesType == 'fastline'
          ? SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer)
              .sampledDataPoints[pointIndex]
          : SeriesHelper.getSeriesRendererDetails(oldSeriesRenderer)
              .dataPoints[pointIndex]
      : null;
}

/// Boolean to check whether it is necessary to render the axis tooltip.
bool shouldShowAxisTooltip(CartesianStateProperties stateProperties) {
  bool requireAxisTooltip = false;
  for (int i = 0;
      i < stateProperties.chartAxis.axisRenderersCollection.length;
      i++) {
    final ChartAxisRendererDetails axisRendererDetails =
        AxisHelper.getAxisRendererDetails(
            stateProperties.chartAxis.axisRenderersCollection[i]);
    requireAxisTooltip = axisRendererDetails.axis.maximumLabelWidth != null ||
        axisRendererDetails.axis.labelsExtent != null;
    if (axisRendererDetails.axis.multiLevelLabels != null) {
      requireAxisTooltip =
          axisRendererDetails.visibleAxisMultiLevelLabels.isNotEmpty;
    }
    if (requireAxisTooltip) {
      break;
    }
  }
  return requireAxisTooltip;
}

/// Method to get the visible data point index.
int? getVisibleDataPointIndex(
    int? pointIndex, SeriesRendererDetails seriesRendererDetails) {
  int? index;
  final List<CartesianChartPoint<dynamic>> dataPoints =
      getSampledData(seriesRendererDetails);
  if (pointIndex != null) {
    if (pointIndex < dataPoints[0].overallDataPointIndex! ||
        pointIndex > dataPoints[dataPoints.length - 1].overallDataPointIndex!) {
      index = null;
    } else if (pointIndex > dataPoints.length - 1) {
      for (int i = 0; i < dataPoints.length; i++) {
        if (pointIndex == dataPoints[i].overallDataPointIndex) {
          index = dataPoints[i].visiblePointIndex;
        }
      }
    } else {
      index = dataPoints[pointIndex].visiblePointIndex;
    }
  }
  return index;
}

/// Method to check whether the series is line series type.
bool isLineTypeSeries(String seriesType) {
  return seriesType == 'line' ||
      seriesType == 'spline' ||
      seriesType == 'stepline' ||
      seriesType == 'stackedline' ||
      seriesType == 'stackedline100';
}

/// A circular array for dash offsets and lengths.
class CircularIntervalList<T> {
  /// Creates an instance of circular interval list.
  CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;

  /// Returns the next value.
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}

/// Gets the R-squared value.
double? getRSquaredValue(CartesianSeriesRenderer series, Trendline trendline,
    List<double>? slope, double? intercept) {
  double rSquare = 0.0;
  const int power = 2;
  final List<int> xValue = <int>[];
  final List<double> yValue = <double>[];
  final SeriesRendererDetails seriesRendererDetails =
      SeriesHelper.getSeriesRendererDetails(series);
  double yMean = 0;
  const int startXValue = 1;
  final DateTime excelDate = DateTime(1900);
  final List<CartesianChartPoint<dynamic>> dataPoints =
      getSampledData(seriesRendererDetails);
  for (int i = 0; i < dataPoints.length; i++) {
    xValue.add(
        seriesRendererDetails.xAxisDetails?.axisRenderer is DateTimeAxisRenderer
            ? dataPoints[i].x.difference(excelDate).inDays
            : i + startXValue);
    yValue.add(dataPoints[i].y.toDouble());
    yMean += dataPoints[i].y.toDouble();
  }
  yMean = yMean / yValue.length;
  // Total sum of square (ssTot)
  double ssTot = 0.0;
  for (int j = 0; j < yValue.length; j++) {
    ssTot += math.pow(yValue[j] - yMean, power);
  }
  // Sum of squares due to regression (ssReg)
  double ssReg = 0.0;
  if (trendline.type == TrendlineType.linear) {
    for (int k = 0; k < yValue.length; k++) {
      ssReg += math.pow(((slope![0] * xValue[k]) + intercept!) - yMean, power);
    }
  }
  if (trendline.type == TrendlineType.exponential) {
    for (int k = 0; k < yValue.length; k++) {
      ssReg += math.pow(
          (intercept! * math.exp(slope![0] * xValue[k])) - yMean, power);
    }
  }
  if (trendline.type == TrendlineType.logarithmic) {
    for (int k = 0; k < yValue.length; k++) {
      ssReg += math.pow(
          ((slope![0] * math.log(xValue[k])) + intercept!) - yMean, power);
    }
  }
  if (trendline.type == TrendlineType.power) {
    for (int k = 0; k < yValue.length; k++) {
      ssReg += math.pow(
          (intercept! * math.pow(xValue[k], slope![0])) - yMean, power);
    }
  }
  if (trendline.type == TrendlineType.polynomial) {
    for (int k = 0; k < yValue.length; k++) {
      double yCap = 0.0;
      for (int i = 0; i < slope!.length; i++) {
        yCap += slope[i] * math.pow(xValue[k], i);
      }
      ssReg += math.pow(yCap - yMean, power);
    }
  }
  rSquare = ssReg / ssTot;
  return rSquare.isNaN ? 0 : rSquare;
}

/// To calculate and return the bubble size.
double calculateBubbleRadius(
    SeriesRendererDetails seriesRendererDetails,
    CartesianSeries<dynamic, dynamic> series,
    CartesianChartPoint<dynamic> currentPoint) {
  final BubbleSeries<dynamic, dynamic> bubbleSeries =
      series as BubbleSeries<dynamic, dynamic>;
  num bubbleRadius, sizeRange, radiusRange, maxSize, minSize;
  const num defaultBubbleSize = 4;
  maxSize = seriesRendererDetails.maxSize!;
  minSize = seriesRendererDetails.minSize!;
  sizeRange = maxSize - minSize;
  final num minRadius = bubbleSeries.minimumRadius,
      maxRadius = bubbleSeries.maximumRadius;
  final double bubbleSize =
      ((currentPoint.bubbleSize) ?? defaultBubbleSize).toDouble();
  assert(minRadius >= 0 && bubbleSeries.maximumRadius >= 0,
      'The min radius and max radius of the bubble should be greater than or equal to 0.');
  if (bubbleSeries.sizeValueMapper == null) {
    // ignore: unnecessary_null_comparison
    minRadius != null ? bubbleRadius = minRadius : bubbleRadius = maxRadius;
  } else {
    if (sizeRange == 0) {
      bubbleRadius = bubbleSize == 0 ? minRadius : maxRadius;
    } else {
      radiusRange = maxRadius - minRadius;
      bubbleRadius =
          minRadius + radiusRange * ((bubbleSize.abs() / maxSize).abs());
    }
  }
  return bubbleRadius.toDouble();
}

/// Cartesian point to pixel.
Offset calculatePointToPixel(
    CartesianChartPoint<dynamic> point, dynamic seriesRenderer) {
  final num x = point.x;
  final num y = point.y;
  final SeriesRendererDetails seriesRendererDetails;
  if (seriesRenderer is SeriesRendererDetails == false) {
    seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  } else {
    seriesRendererDetails = seriesRenderer;
  }
  final ChartAxisRendererDetails xAxisDetails =
      seriesRendererDetails.xAxisDetails!;
  final ChartAxisRendererDetails yAxisDetails =
      seriesRendererDetails.yAxisDetails!;

  final bool isInverted =
      seriesRendererDetails.stateProperties.requireInvertedAxis;

  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;
  final ChartLocation location = calculatePoint(
      x,
      y,
      xAxisDetails,
      yAxisDetails,
      isInverted,
      series,
      seriesRendererDetails.stateProperties.chartAxis.axisClipRect);

  return Offset(location.x, location.y);
}

/// Cartesian pixel to point.
CartesianChartPoint<dynamic> calculatePixelToPoint(
    Offset position, dynamic seriesRenderer) {
  SeriesRendererDetails seriesRendererDetails;
  if (seriesRenderer is SeriesRendererDetails) {
    seriesRendererDetails = seriesRenderer;
  } else {
    seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(seriesRenderer);
  }
  if (seriesRendererDetails.xAxisDetails == null) {
    seriesRendererDetails = SeriesHelper.getSeriesRendererDetails(
        seriesRendererDetails.stateProperties.oldSeriesRenderers[0]);
  }
  ChartAxisRendererDetails xAxisDetails = seriesRendererDetails.xAxisDetails!;
  ChartAxisRendererDetails yAxisDetails = seriesRendererDetails.yAxisDetails!;

  final ChartAxis xAxis = xAxisDetails.axis;
  final ChartAxis yAxis = yAxisDetails.axis;

  final CartesianSeries<dynamic, dynamic> series = seriesRendererDetails.series;

  final Rect rect =
      seriesRendererDetails.stateProperties.chartAxis.axisClipRect;

  if (series.xAxisName != null || series.yAxisName != null) {
    for (final ChartAxisRenderer axisRenderer in seriesRendererDetails
        .stateProperties.chartAxis.axisRenderersCollection) {
      final ChartAxisRendererDetails axisDetails =
          AxisHelper.getAxisRendererDetails(axisRenderer);
      if (axisDetails.name == series.xAxisName) {
        xAxisDetails = axisDetails;
      } else if (axisDetails.name == series.yAxisName) {
        yAxisDetails = axisDetails;
      }
    }
  } else {
    xAxisDetails = xAxisDetails;
    yAxisDetails = yAxisDetails;
  }

  num xValue = pointToXValue(
      seriesRendererDetails.stateProperties.requireInvertedAxis,
      xAxisDetails.axisRenderer,
      rect,
      position.dx - (rect.left + xAxis.plotOffset),
      position.dy - (rect.top + yAxis.plotOffset));
  num yValue = pointToYValue(
      seriesRendererDetails.stateProperties.requireInvertedAxis,
      yAxisDetails.axisRenderer,
      rect,
      position.dx - (rect.left + xAxis.plotOffset),
      position.dy - (rect.top + yAxis.plotOffset));

  if (xAxisDetails is LogarithmicAxisDetails) {
    final LogarithmicAxis axis = xAxis as LogarithmicAxis;
    xValue = math.pow(xValue, calculateLogBaseValue(xValue, axis.logBase));
  } else {
    xValue = xValue;
  }
  if (yAxisDetails is LogarithmicAxisDetails) {
    final LogarithmicAxis axis = yAxis as LogarithmicAxis;
    yValue = math.pow(yValue, calculateLogBaseValue(yValue, axis.logBase));
  } else {
    yValue = yValue;
  }
  return CartesianChartPoint<dynamic>(xValue, yValue);
}

/// To get seriesType of the cartesian series renderer.
String getSeriesType(CartesianSeriesRenderer seriesRenderer) {
  String seriesType = '';

  if (seriesRenderer is AreaSeriesRenderer) {
    seriesType = 'area';
  } else if (seriesRenderer is BarSeriesRenderer) {
    seriesType = 'bar';
  } else if (seriesRenderer is BubbleSeriesRenderer) {
    seriesType = 'bubble';
  } else if (seriesRenderer is ColumnSeriesRenderer) {
    seriesType = 'column';
  } else if (seriesRenderer is FastLineSeriesRenderer) {
    seriesType = 'fastline';
  } else if (seriesRenderer is LineSeriesRenderer) {
    seriesType = 'line';
  } else if (seriesRenderer is ScatterSeriesRenderer) {
    seriesType = 'scatter';
  } else if (seriesRenderer is SplineSeriesRenderer) {
    seriesType = 'spline';
  } else if (seriesRenderer is StepLineSeriesRenderer) {
    seriesType = 'stepline';
  } else if (seriesRenderer is StackedColumnSeriesRenderer) {
    seriesType = 'stackedcolumn';
  } else if (seriesRenderer is StackedBarSeriesRenderer) {
    seriesType = 'stackedbar';
  } else if (seriesRenderer is StackedAreaSeriesRenderer) {
    seriesType = 'stackedarea';
  } else if (seriesRenderer is StackedArea100SeriesRenderer) {
    seriesType = 'stackedarea100';
  } else if (seriesRenderer is StackedLineSeriesRenderer) {
    seriesType = 'stackedline';
  } else if (seriesRenderer is StackedLine100SeriesRenderer) {
    seriesType = 'stackedline100';
  } else if (seriesRenderer is RangeColumnSeriesRenderer) {
    seriesType = 'rangecolumn';
  } else if (seriesRenderer is RangeAreaSeriesRenderer) {
    seriesType = 'rangearea';
  } else if (seriesRenderer is StackedColumn100SeriesRenderer) {
    seriesType = 'stackedcolumn100';
  } else if (seriesRenderer is StackedBar100SeriesRenderer) {
    seriesType = 'stackedbar100';
  } else if (seriesRenderer is SplineAreaSeriesRenderer) {
    seriesType = 'splinearea';
  } else if (seriesRenderer is StepAreaSeriesRenderer) {
    seriesType = 'steparea';
  } else if (seriesRenderer is HiloSeriesRenderer) {
    seriesType = 'hilo';
  } else if (seriesRenderer is HiloOpenCloseSeriesRenderer) {
    seriesType = 'hiloopenclose';
  } else if (seriesRenderer is CandleSeriesRenderer) {
    seriesType = 'candle';
  } else if (seriesRenderer is HistogramSeriesRenderer) {
    seriesType = 'histogram';
  } else if (seriesRenderer is SplineRangeAreaSeriesRenderer) {
    seriesType = 'splinerangearea';
  } else if (seriesRenderer is BoxAndWhiskerSeriesRenderer) {
    seriesType = 'boxandwhisker';
  } else if (seriesRenderer is WaterfallSeriesRenderer) {
    seriesType = 'waterfall';
  } else if (seriesRenderer is ErrorBarSeriesRenderer) {
    seriesType = 'errorbar';
  }

  return seriesType;
}
