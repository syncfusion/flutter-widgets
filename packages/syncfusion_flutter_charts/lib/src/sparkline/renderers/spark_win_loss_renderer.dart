import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../plot_band.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'renderer_base.dart';

/// Represents the render object for spark chart.
class SfSparkWinLossChartRenderObjectWidget
    extends SfSparkChartRenderObjectWidget {
  /// Creates the render object for spark chart.
  const SfSparkWinLossChartRenderObjectWidget(
      {Key? key,
      List<dynamic>? data,
      int? dataCount,
      SparkChartIndexedValueMapper<dynamic>? xValueMapper,
      SparkChartIndexedValueMapper<num>? yValueMapper,
      Color? color,
      SparkChartPlotBand? plotBand,
      this.borderWidth,
      this.borderColor,
      this.tiePointColor,
      bool? isInversed,
      double? axisCrossesAt,
      Color? axisLineColor,
      double? axisLineWidth,
      List<double>? axisLineDashArray,
      Color? firstPointColor,
      Color? lowPointColor,
      Color? highPointColor,
      Color? lastPointColor,
      Color? negativePointColor,
      SparkChartDataDetails? sparkChartDataDetails,
      SfSparkChartThemeData? themeData,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : super(
            key: key,
            data: data,
            dataCount: dataCount,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            isInversed: isInversed,
            axisCrossesAt: axisCrossesAt,
            axisLineColor: axisLineColor,
            axisLineWidth: axisLineWidth,
            axisLineDashArray: axisLineDashArray,
            firstPointColor: firstPointColor,
            lowPointColor: lowPointColor,
            highPointColor: highPointColor,
            lastPointColor: lastPointColor,
            negativePointColor: negativePointColor,
            color: color,
            plotBand: plotBand,
            sparkChartDataDetails: sparkChartDataDetails,
            themeData: themeData,
            coordinatePoints: coordinatePoints,
            dataPoints: dataPoints);

  /// Specifies the area chart border width.
  final double? borderWidth;

  /// Specifies the area chart border color.
  final Color? borderColor;

  /// Specifies the tie point color.
  final Color? tiePointColor;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSparkWinLossChart(
        dataCount: dataCount,
        data: data,
        xValueMapper: xValueMapper,
        yValueMapper: yValueMapper,
        isInversed: isInversed,
        axisCrossesAt: axisCrossesAt,
        axisLineColor: axisLineColor,
        axisLineWidth: axisLineWidth,
        axisLineDashArray: axisLineDashArray,
        firstPointColor: firstPointColor,
        lastPointColor: lastPointColor,
        highPointColor: highPointColor,
        lowPointColor: lowPointColor,
        negativePointColor: negativePointColor,
        color: color,
        plotBand: plotBand,
        tiePointColor: tiePointColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        sparkChartDataDetails: sparkChartDataDetails,
        themeData: themeData,
        coordinatePoints: coordinatePoints,
        dataPoints: dataPoints);
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderSparkWinLossChart renderObject) {
    renderObject
      ..isInversed = isInversed
      ..axisCrossesAt = axisCrossesAt
      ..axisLineColor = axisLineColor
      ..axisLineWidth = axisLineWidth
      ..axisLineDashArray = axisLineDashArray
      ..dataCount = dataCount
      ..data = data
      ..xValueMapper = xValueMapper
      ..yValueMapper = yValueMapper
      ..firstPointColor = firstPointColor
      ..lastPointColor = lastPointColor
      ..highPointColor = highPointColor
      ..lowPointColor = lowPointColor
      ..negativePointColor = negativePointColor
      ..color = color
      ..plotBand = plotBand
      ..tiePointColor = tiePointColor
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..themeData = themeData
      ..coordinatePoints = coordinatePoints
      ..dataPoints = dataPoints;
  }
}

/// Represents the render spark win loss chart class.
class _RenderSparkWinLossChart extends RenderSparkChart {
  /// Creates the render object widget.
  _RenderSparkWinLossChart(
      {List<dynamic>? data,
      int? dataCount,
      SparkChartIndexedValueMapper<dynamic>? xValueMapper,
      SparkChartIndexedValueMapper<num>? yValueMapper,
      bool? isInversed,
      double? axisCrossesAt,
      double? axisLineWidth,
      Color? axisLineColor,
      List<double>? axisLineDashArray,
      Color? color,
      Color? firstPointColor,
      Color? lastPointColor,
      Color? highPointColor,
      Color? lowPointColor,
      Color? negativePointColor,
      SparkChartPlotBand? plotBand,
      Color? tiePointColor,
      double? borderWidth,
      Color? borderColor,
      SfSparkChartThemeData? themeData,
      SparkChartDataDetails? sparkChartDataDetails,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : _tiePointColor = tiePointColor,
        _borderWidth = borderWidth,
        _borderColor = borderColor,
        super(
            data: data,
            dataCount: dataCount,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            isInversed: isInversed,
            axisCrossesAt: axisCrossesAt,
            axisLineWidth: axisLineWidth,
            axisLineColor: axisLineColor,
            axisLineDashArray: axisLineDashArray,
            color: color,
            firstPointColor: firstPointColor,
            lastPointColor: lastPointColor,
            highPointColor: highPointColor,
            lowPointColor: lowPointColor,
            negativePointColor: negativePointColor,
            plotBand: plotBand,
            sparkChartDataDetails: sparkChartDataDetails,
            themeData: themeData,
            coordinatePoints: coordinatePoints,
            dataPoints: dataPoints);

  /// Defines the border width.
  double? _borderWidth;

  /// Returns the border width value.
  double? get borderWidth => _borderWidth;

  /// Set the border width value.
  set borderWidth(double? value) {
    if (_borderWidth != value) {
      _borderWidth = value;
      markNeedsPaint();
    }
  }

  /// Defines the border color.
  Color? _borderColor;

  /// Returns the border color.
  Color? get borderColor => _borderColor;

  /// Set the border color value.
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the tie point color.
  Color? _tiePointColor;

  /// Returns the tie point color.
  Color? get tiePointColor => _tiePointColor;

  /// Set the tie point color.
  set tiePointColor(Color? value) {
    if (_tiePointColor != value) {
      _tiePointColor = value;
      markNeedsPaint();
    }
  }

  /// Specifies the win loss segments.
  late List<Rect> _segments;

  @override
  void calculateRenderingPoints() {
    diffX = maxX! - minX!;
    diffY = maxY! - minY!;
    diffX = diffX == 0 ? 1 : diffX;
    diffY = diffY == 0 ? 1 : diffY;

    _segments = <Rect>[];
    final double xInterval = dataPoints!.length > 1
        ? dataPoints![1].x.toDouble() - dataPoints![0].x.toDouble()
        : dataPoints!.length.toDouble();
    const double columnSpace = 0.5; // Default space for column and winloss
    const double space = columnSpace * 2;
    const double winLossFactor = 0.5;
    const double heightFactor = 40;
    double visibleXPoint;
    double rectHeight;
    double bottom;
    Rect rect;
    double x, y, y2;
    double columnWidth = areaSize!.width / (((maxX! - minX!) / xInterval) + 1);
    columnWidth -= space;
    axisHeight = getAxisHeight();
    if (coordinatePoints!.isNotEmpty) {
      coordinatePoints!.clear();
    }

    for (int i = 0; i < dataPoints!.length; i++) {
      x = dataPoints![i].x.toDouble();
      y = dataPoints![i].y.toDouble();

      visibleXPoint =
          (((x - minX!) / xInterval) * (columnWidth + space)) + (space / 2);
      y2 = (y > axisCrossesAt!)
          ? (areaSize!.height / 2)
          : (y < axisCrossesAt!)
              ? areaSize!.height * winLossFactor
              : ((areaSize!.height * winLossFactor) -
                  (areaSize!.height / heightFactor));
      rectHeight =
          (y != axisCrossesAt) ? (areaSize!.height / 2) : areaSize!.height / 20;
      bottom = y > axisCrossesAt! ? rectHeight - y2 : rectHeight + y2;
      rect =
          Rect.fromLTRB(visibleXPoint, y2, visibleXPoint + columnWidth, bottom);
      _segments.add(rect);
      coordinatePoints!.add(Offset(visibleXPoint + columnWidth / 2, y2));
    }
  }

  /// Method to render win loss series.
  void _renderWinLossSeries(Canvas canvas, Offset offset) {
    final Paint tiePointPaint = Paint()
      ..color = tiePointColor ?? Colors.deepPurple;
    final Paint negativePointPaint = Paint()
      ..color = negativePointColor ?? Colors.red;
    final Paint paint = Paint()..color = color!;
    final Paint strokePaint = Paint()
      ..color = borderColor ?? Colors.transparent
      ..strokeWidth = borderWidth ?? 0
      ..style = PaintingStyle.stroke;

    final bool canDrawBorder = borderColor != null &&
        borderColor != Colors.transparent &&
        borderWidth != null &&
        borderWidth! > 0;
    Rect rect;

    for (int i = 0; i < dataPoints!.length; i++) {
      rect = Rect.fromLTRB(
          _segments[i].left + offset.dx,
          _segments[i].top + offset.dy,
          _segments[i].right + offset.dx,
          _segments[i].bottom + offset.dy);
      if (dataPoints![i].y < axisCrossesAt!) {
        canvas.drawRect(rect, negativePointPaint);
      } else if (dataPoints![i].y == axisCrossesAt) {
        canvas.drawRect(rect, tiePointPaint);
      } else if (dataPoints![i].y == maxY && highPointColor != null) {
        paint.color = highPointColor!;
        canvas.drawRect(rect, paint);
      } else if (dataPoints![i].y == minY && lowPointColor != null) {
        paint.color = lowPointColor!;
        canvas.drawRect(rect, paint);
      } else if (i == 0 && firstPointColor != null) {
        paint.color = firstPointColor!;
        canvas.drawRect(rect, paint);
      } else if (i == _segments.length - 1 && lastPointColor != null) {
        paint.color = lastPointColor!;
        canvas.drawRect(rect, paint);
      } else {
        paint.color = color!;
        canvas.drawRect(rect, paint);
      }

      if (canDrawBorder) {
        canvas.drawRect(rect, strokePaint);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (coordinatePoints != null &&
        coordinatePoints!.isNotEmpty &&
        dataPoints != null &&
        dataPoints!.isNotEmpty) {
      if (plotBand != null) {
        renderPlotBand(context.canvas, offset);
      }

      _renderWinLossSeries(context.canvas, offset);
    }
  }
}
