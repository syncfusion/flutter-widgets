import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../plot_band.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'renderer_base.dart';

/// Represents the render object for spark chart.
class SfSparkBarChartRenderObjectWidget extends SfSparkChartRenderObjectWidget {
  /// Creates the render object for spark chart.
  const SfSparkBarChartRenderObjectWidget(
      {Key? key,
      this.borderWidth,
      this.borderColor,
      List<dynamic>? data,
      int? dataCount,
      SparkChartIndexedValueMapper<dynamic>? xValueMapper,
      SparkChartIndexedValueMapper<num>? yValueMapper,
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
      Color? color,
      SparkChartPlotBand? plotBand,
      this.labelDisplayMode,
      this.labelStyle,
      SfChartThemeData? themeData,
      SparkChartDataDetails? sparkChartDataDetails,
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

  /// Specifies the bar chart border width.
  final double? borderWidth;

  /// Specifies the bar chart border color.
  final Color? borderColor;

  /// Specifies the spark chart data label display mode.
  final SparkChartLabelDisplayMode? labelDisplayMode;

  /// Specifies the spark chart data label style.
  final TextStyle? labelStyle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSparkBarChart(
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
        borderColor: borderColor,
        borderWidth: borderWidth,
        labelDisplayMode: labelDisplayMode,
        labelStyle: labelStyle,
        sparkChartDataDetails: sparkChartDataDetails,
        themeData: themeData,
        coordinatePoints: coordinatePoints,
        dataPoints: dataPoints);
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderSparkBarChart renderObject) {
    renderObject
      ..isInversed = isInversed
      ..axisCrossesAt = axisCrossesAt!
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
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..labelDisplayMode = labelDisplayMode
      ..labelStyle = labelStyle
      ..themeData = themeData
      ..coordinatePoints = coordinatePoints
      ..dataPoints = dataPoints;
  }
}

/// Represents the render spark bar chart class.
class _RenderSparkBarChart extends RenderSparkChart {
  /// Creates the render object widget.
  _RenderSparkBarChart(
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
      double? borderWidth,
      Color? borderColor,
      SparkChartLabelDisplayMode? labelDisplayMode,
      TextStyle? labelStyle,
      SparkChartDataDetails? sparkChartDataDetails,
      SfChartThemeData? themeData,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : _borderWidth = borderWidth,
        _borderColor = borderColor,
        _labelDisplayMode = labelDisplayMode,
        _labelStyle = labelStyle,
        _axisCrossesAt = axisCrossesAt,
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

  /// Defines the dash array.
  Color? _borderColor;

  /// Returns the border color.
  Color? get borderColor => _borderColor;

  /// Set the border color.
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart data label mode.
  SparkChartLabelDisplayMode? _labelDisplayMode;

  /// Returns the spark chart data label display mode.
  SparkChartLabelDisplayMode? get labelDisplayMode => _labelDisplayMode;

  /// Sets the spark chart data label mode.
  set labelDisplayMode(SparkChartLabelDisplayMode? value) {
    if (_labelDisplayMode != value) {
      _labelDisplayMode = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart data label text style.
  TextStyle? _labelStyle;

  /// Returns the spark chart data label text style.
  TextStyle? get labelStyle => _labelStyle;

  /// Sets the spark chart data label mode.
  set labelStyle(TextStyle? value) {
    if (_labelStyle != value) {
      _labelStyle = value;
      markNeedsPaint();
    }
  }

  /// Defines the horizontal axis line position.
  double? _axisCrossesAt;

  /// Returns the axisCrossesAt value.
  @override
  double get axisCrossesAt => _axisCrossesAt!;

  /// Set the axisCrossesAt value.
  @override
  set axisCrossesAt(double? value) {
    if (_axisCrossesAt != value) {
      _axisCrossesAt = value!;
      calculateRenderingPoints();
      markNeedsPaint();
    }
  }

  /// Specifies the win loss segments.
  List<Rect>? _segments;

  /// Specifies the low point in series.
  late num _lowPoint;

  /// Specifies the high point in series
  late num _highPoint;

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
    final double? axisBaseValue = minY! < 0 ? minY : 0;
    double visibleXPoint;
    Rect rect;
    double top, x, y, y2, columnHeight, currentColumnHeight, yPoint;
    double columnWidth = areaSize!.width / (((maxX! - minX!) / xInterval) + 1);
    columnWidth -= space;
    diffY = maxY! - axisBaseValue!;
    axisHeight = getAxisHeight();
    if (coordinatePoints!.isNotEmpty) {
      coordinatePoints!.clear();
    }

    for (int i = 0; i < dataPoints!.length; i++) {
      x = dataPoints![i].x.toDouble();
      y = dataPoints![i].y.toDouble();
      visibleXPoint =
          (((x - minX!) / xInterval) * (columnWidth + space)) + (space / 2);
      columnHeight = (areaSize!.height / diffY!) * (y - axisBaseValue);
      currentColumnHeight = (y == axisBaseValue && y > axisCrossesAt)
          ? ((dataPoints!.length != 1 && diffY != 1)
                  ? (areaSize!.height / diffY!) * axisBaseValue
                  : (columnHeight.toInt() | 1))
              .toDouble()
          : (y == maxY &&
                  y < axisCrossesAt &&
                  dataPoints!.length != 1 &&
                  diffY != 1)
              ? (areaSize!.height / diffY!) * maxY!
              : columnHeight;
      y2 = (areaSize!.height - currentColumnHeight).abs();
      top = (y2 > axisHeight!) ? axisHeight! : y2;
      rect = Rect.fromLTRB(visibleXPoint, top, visibleXPoint + columnWidth,
          top + (y2 - axisHeight!).abs());
      _segments!.add(rect);
      yPoint = y >= axisCrossesAt ? rect.top : rect.bottom;
      coordinatePoints!.add(Offset(visibleXPoint + columnWidth / 2, yPoint));
    }
  }

  /// Returns the axis height.
  @override
  double getAxisHeight() {
    final double value = axisCrossesAt;
    final double minimumColumnValue = minY! < 0 ? minY! : 0;
    double? axisLineHeight =
        areaSize!.height - ((areaSize!.height / diffY!) * (-minY!));
    axisLineHeight = (minY! < 0 && maxY! <= 0)
        ? 0
        : (minY! < 0 && maxY! > 0)
            ? axisHeight
            : areaSize!.height;
    if (value >= minimumColumnValue && value <= maxY!) {
      axisLineHeight = areaSize!.height -
          (areaSize!.height * ((value - minimumColumnValue) / diffY!))
              .roundToDouble();
    }
    return axisLineHeight!;
  }

  /// Method to calculate the plot band position.
  @override
  void calculatePlotBandPosition() {
    final double height = areaSize!.height;
    final double start =
        (plotBand!.start ?? minY!) < minY! ? minY! : (plotBand!.start ?? minY!);
    final double end =
        (plotBand!.end ?? maxY!) > maxY! ? maxY! : (plotBand!.end ?? maxY!);
    final double baseValue = minY! < 0 ? minY! : 0;
    plotBandStartHeight = height - ((height / diffY!) * (start - baseValue));
    plotBandEndHeight = height - ((height / diffY!) * (end - baseValue));
  }

  /// Method to render bar series.
  void _renderBarSeries(Canvas canvas, Offset offset) {
    Color currentColor;
    Paint paint;
    final Paint strokePaint = Paint()
      ..color = borderColor ?? Colors.transparent
      ..strokeWidth = borderWidth ?? 0
      ..style = PaintingStyle.stroke;

    Size size;
    double yPosition;
    final bool canDrawBorder = borderColor != null &&
        borderColor != Colors.transparent &&
        borderWidth != null &&
        borderWidth! > 0;
    Rect rect;
    _labelStyle = themeData!.dataLabelTextStyle;
    _highPoint = coordinatePoints![0].dy;
    _lowPoint = coordinatePoints![0].dy;
    for (int i = 0; i < _segments!.length; i++) {
      if (_highPoint < coordinatePoints![i].dy) {
        _highPoint = coordinatePoints![i].dy;
      }

      if (_lowPoint > coordinatePoints![i].dy) {
        _lowPoint = coordinatePoints![i].dy;
      }
      rect = Rect.fromLTRB(
          _segments![i].left + offset.dx,
          _segments![i].top + offset.dy,
          _segments![i].right + offset.dx,
          _segments![i].bottom + offset.dy);
      if (dataPoints![i].y == maxY && highPointColor != null) {
        currentColor = highPointColor!;
      } else if (dataPoints![i].y == minY && lowPointColor != null) {
        currentColor = lowPointColor!;
      } else if (i == 0 && firstPointColor != null) {
        currentColor = firstPointColor!;
      } else if (i == _segments!.length - 1 && lastPointColor != null) {
        currentColor = lastPointColor!;
      } else if (dataPoints![i].y < axisCrossesAt &&
          negativePointColor != null) {
        currentColor = negativePointColor!;
      } else {
        currentColor = color!;
      }
      dataPoints![i].color = currentColor;
      paint = Paint()..color = currentColor;
      canvas.drawRect(rect, paint);
      if (canDrawBorder) {
        canvas.drawRect(rect, strokePaint);
      }

      if (labelDisplayMode != SparkChartLabelDisplayMode.none &&
          labelStyle != null) {
        size = getTextSize(dataLabels![i], labelStyle!);
        yPosition = dataPoints![i].y > 0
            ? ((_segments![i].topCenter.dy + offset.dy) - size.height)
            : (_segments![i].bottomCenter.dy + offset.dy);
        dataPoints![i].dataLabelOffset = Offset(
            (offset.dx + _segments![i].topCenter.dx) - size.width / 2,
            yPosition);

        if (dataPoints![i].dataLabelOffset!.dy <= offset.dy) {
          dataPoints![i].dataLabelOffset = Offset(
              dataPoints![i].dataLabelOffset!.dx, offset.dy + size.height);
        }
        if (dataPoints![i].dataLabelOffset!.dy >=
            offset.dy + areaSize!.height) {
          dataPoints![i].dataLabelOffset = Offset(
              dataPoints![i].dataLabelOffset!.dx,
              (offset.dy + areaSize!.height) - size.height);
        }
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (coordinatePoints != null &&
        coordinatePoints!.isNotEmpty &&
        dataPoints != null &&
        dataPoints!.isNotEmpty) {
      _renderBarSeries(context.canvas, offset);
      if (labelDisplayMode != null &&
          labelDisplayMode != SparkChartLabelDisplayMode.none) {
        renderDataLabel(
            context.canvas,
            dataLabels!,
            dataPoints!,
            coordinatePoints!,
            labelStyle!,
            labelDisplayMode!,
            'Bar',
            themeData!,
            offset,
            color!,
            _highPoint,
            _lowPoint,
            _segments!);
      }
    }
  }
}
