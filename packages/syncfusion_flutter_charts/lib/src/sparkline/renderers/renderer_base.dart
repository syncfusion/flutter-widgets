import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_core/theme.dart';
import '../plot_band.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';

/// Represents the render object for spark chart.
@immutable
abstract class SfSparkChartRenderObjectWidget extends LeafRenderObjectWidget {
  /// Creates the render object for spark chart.
  const SfSparkChartRenderObjectWidget(
      {Key? key,
      this.data,
      this.dataCount,
      this.xValueMapper,
      this.yValueMapper,
      this.isInversed,
      this.axisCrossesAt,
      this.axisLineColor,
      this.axisLineWidth,
      this.axisLineDashArray,
      this.firstPointColor,
      this.lowPointColor,
      this.highPointColor,
      this.lastPointColor,
      this.negativePointColor,
      this.color,
      this.plotBand,
      this.sparkChartDataDetails,
      this.themeData,
      this.dataPoints,
      this.coordinatePoints})
      : super(key: key);

  /// Specifies the data source for the series.
  final List<dynamic>? data;

  /// Field in the data source, which is considered as x-value.
  final SparkChartIndexedValueMapper<dynamic>? xValueMapper;

  /// Field in the data source, which is considered as y-value.
  final SparkChartIndexedValueMapper<num>? yValueMapper;

  /// Specifies the data source count.
  final int? dataCount;

  /// Specifies whether to inverse the spark chart.
  final bool? isInversed;

  /// Specifies the horizontal axis line position.
  final double? axisCrossesAt;

  /// Specifies the horizontal axis line width.
  final double? axisLineWidth;

  /// Specifies the axis line color.
  final Color? axisLineColor;

  /// Specifies the axis line dash array.
  final List<double>? axisLineDashArray;

  /// Specifies the high point color.
  final Color? highPointColor;

  /// Specifies the low point color.
  final Color? lowPointColor;

  /// Specifies the negative point color.
  final Color? negativePointColor;

  /// Specifies the first point color.
  final Color? firstPointColor;

  /// Specifies the last point color.
  final Color? lastPointColor;

  /// Specifies the spark chart color.
  final Color? color;

  /// Specifies the spark chart plot band.
  final SparkChartPlotBand? plotBand;

  /// Specifies the spark chart data details.
  final SparkChartDataDetails? sparkChartDataDetails;

  /// Specfies the theme of the spark chart.
  final SfChartThemeData? themeData;

  /// Specifies the series screen coordinate points.
  final List<Offset>? coordinatePoints;

  /// Specifies the series data points.
  final List<SparkChartPoint>? dataPoints;
}

/// Represents the RenderSparkChart class.
abstract class RenderSparkChart extends RenderBox {
  /// Creates the render object widget.
  RenderSparkChart(
      {
      //ignore: avoid_unused_constructor_parameters
      Widget? child,
      List<dynamic>? data,
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
      SparkChartDataDetails? sparkChartDataDetails,
      SfChartThemeData? themeData,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : _data = data,
        _dataCount = dataCount,
        _xValueMapper = xValueMapper,
        _yValueMapper = yValueMapper,
        _isInversed = isInversed,
        _axisCrossesAt = axisCrossesAt,
        _axisLineWidth = axisLineWidth,
        _axisLineDashArray = axisLineDashArray,
        _axisLineColor = axisLineColor,
        _color = color,
        _firstPointColor = firstPointColor,
        _lastPointColor = lastPointColor,
        _highPointColor = highPointColor,
        _lowPointColor = lowPointColor,
        _negativePointColor = negativePointColor,
        _plotBand = plotBand,
        _sparkChartDataDetails = sparkChartDataDetails,
        _themeData = themeData,
        _dataPoints = dataPoints,
        _coordinatePoints = coordinatePoints {
    processDataSource();
    if (isInversed ?? false) {
      inverseDataPoints();
    }
  }

  /// Defines the data source.
  List<dynamic>? _data;

  /// Returns the data source value.
  List<dynamic>? get data => _data;

  /// Set the data source value.
  set data(List<dynamic>? value) {
    if (_data != null && _data != value) {
      _data = value;
      _refreshSparkChart();
      markNeedsPaint();
    }
  }

  /// Defines the data count.
  int? _dataCount;

  /// Returns the data count value.
  int? get dataCount => _dataCount;

  /// Set the data source value.
  set dataCount(int? value) {
    if (_dataCount != null && _dataCount != value) {
      _dataCount = value;
      _refreshSparkChart();
      markNeedsPaint();
    }
  }

  /// Defines the x-value in the data source.
  SparkChartIndexedValueMapper<dynamic>? _xValueMapper;

  /// Returns the xValueMapper value.
  SparkChartIndexedValueMapper<dynamic>? get xValueMapper => _xValueMapper;

  /// Set the xValue Mapper value.
  set xValueMapper(SparkChartIndexedValueMapper<dynamic>? value) {
    if (_xValueMapper != null && _xValueMapper != value) {
      _xValueMapper = value;
      _refreshSparkChart();
      markNeedsPaint();
    }
  }

  /// Defines the y-value in the data source.
  SparkChartIndexedValueMapper<num>? _yValueMapper;

  /// Returns the yValueMapper value.
  SparkChartIndexedValueMapper<num>? get yValueMapper => _yValueMapper;

  /// Set the yValue Mapper value.
  set yValueMapper(SparkChartIndexedValueMapper<num>? value) {
    if (_yValueMapper != null && _yValueMapper != value) {
      _yValueMapper = value;
      _refreshSparkChart();
      markNeedsPaint();
    }
  }

  /// Defines whether to inverse the spark chart.
  bool? _isInversed;

  /// Returns the isInversed.
  bool? get isInversed => _isInversed;

  /// Set the isInversed.
  set isInversed(bool? value) {
    if (_isInversed != value) {
      _isInversed = value;
      inverseDataPoints();
      calculateRenderingPoints();
      markNeedsPaint();
    }
  }

  /// Defines the horizontal axis line position.
  double? _axisCrossesAt;

  /// Returns the axisCrossesAt value.
  double? get axisCrossesAt => _axisCrossesAt;

  /// Set the axisCrossesAt value.
  set axisCrossesAt(double? value) {
    if (_axisCrossesAt != value) {
      _axisCrossesAt = value;
      axisHeight = getAxisHeight();
      markNeedsPaint();
    }
  }

  /// Defines the axis line width.
  double? _axisLineWidth;

  /// Returns the axis line width value.
  double? get axisLineWidth => _axisLineWidth;

  /// Set the axis line width value.
  set axisLineWidth(double? value) {
    if (_axisLineWidth != value) {
      _axisLineWidth = value;
      markNeedsPaint();
    }
  }

  /// Defines the axis line color.
  Color? _axisLineColor;

  /// Returns the axis line color value.
  Color? get axisLineColor => _axisLineColor;

  /// Set the axis line color value.
  set axisLineColor(Color? value) {
    if (_axisLineColor != value) {
      _axisLineColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart theme.
  SfChartThemeData? _themeData;

  /// Returns the spark chart theme.
  SfChartThemeData? get themeData => _themeData;

  /// Sets the spark chart theme.
  set themeData(SfChartThemeData? value) {
    if (_themeData != value) {
      _themeData = value;
      markNeedsPaint();
    }
  }

  /// Defines the series coordinate points.
  List<Offset>? _coordinatePoints;

  /// Returns the series coordinate points.
  List<Offset>? get coordinatePoints => _coordinatePoints;

  /// Sets the series coordinate points.
  set coordinatePoints(List<Offset>? value) {
    if (_coordinatePoints != value) {
      _coordinatePoints = value;
    }
  }

  /// Defines the series data points.
  List<SparkChartPoint>? _dataPoints;

  /// Returns the series data points.
  List<SparkChartPoint>? get dataPoints => _dataPoints;

  /// Sets the series coordinate points.
  set dataPoints(List<SparkChartPoint>? value) {
    if (_dataPoints != value) {
      _dataPoints = value;
    }
  }

  /// Defines the axis line dash array.
  List<double>? _axisLineDashArray;

  /// Returns the axis line dash array value.
  List<double>? get axisLineDashArray => _axisLineDashArray;

  /// Set the axis line dash array value.
  set axisLineDashArray(List<double>? value) {
    if (_axisLineDashArray != value) {
      _axisLineDashArray = value;
      markNeedsPaint();
    }
  }

  /// Defines the first point color.
  Color? _firstPointColor;

  /// Returns the first point color value.
  Color? get firstPointColor => _firstPointColor;

  /// Set the first point color value.
  set firstPointColor(Color? value) {
    if (_firstPointColor != value) {
      _firstPointColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the last point color.
  Color? _lastPointColor;

  /// Returns the last point color vlue.
  Color? get lastPointColor => _lastPointColor;

  /// Set the last point color value.
  set lastPointColor(Color? value) {
    if (_lastPointColor != value) {
      _lastPointColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the high point color.
  Color? _highPointColor;

  /// Returns the high point color value.
  Color? get highPointColor => _highPointColor;

  /// Set the high point color value.
  set highPointColor(Color? value) {
    if (_highPointColor != value) {
      _highPointColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the low point color.
  Color? _lowPointColor;

  /// Returns the low point color value.
  Color? get lowPointColor => _lowPointColor;

  /// Set the low point color value.
  set lowPointColor(Color? value) {
    if (_lowPointColor != value) {
      _lowPointColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the negative point color.
  Color? _negativePointColor;

  /// Returns the negative point color value.
  Color? get negativePointColor => _negativePointColor;

  /// Set the negative point color value.
  set negativePointColor(Color? value) {
    if (_negativePointColor != value) {
      _negativePointColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart series color.
  Color? _color;

  /// Returns the spark chart color.
  Color? get color => _color;

  /// Set the spark chart color value.
  set color(Color? value) {
    if (_color != value) {
      _color = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart plot band.
  SparkChartPlotBand? _plotBand;

  /// Returns the spark chart plot band.
  SparkChartPlotBand? get plotBand => _plotBand;

  /// Sets the spark chart plot band.
  set plotBand(SparkChartPlotBand? value) {
    if (_plotBand != value) {
      _plotBand = value;
      calculatePlotBandPosition();
      markNeedsPaint();
    }
  }

  /// Defines the spark chart data details.
  SparkChartDataDetails? _sparkChartDataDetails;

  /// Returns the spark chart data details.
  SparkChartDataDetails? get sparkChartDataDetails => _sparkChartDataDetails;

  /// Sets the spark chart data details.
  set sparkChartDataDetails(SparkChartDataDetails? value) {
    if (_sparkChartDataDetails != value) {
      _sparkChartDataDetails = value;
    }
  }

  /// Defines the plot band start height.
  double? plotBandStartHeight;

  /// Defines the plot band end height.
  double? plotBandEndHeight;

  /// Specifies the minimum X value.
  double? minX;

  /// Specifies the maximum X value
  double? maxX;

  /// Specifies the minimum Y value.
  double? minY;

  /// Specifies the maximum X value.
  double? maxY;

  /// Defines the Y difference.
  double? diffY;

  /// Defines the X difference.
  double? diffX;

  /// Specifies the axis height.
  double? axisHeight;

  /// Specifies the area size.
  Size? areaSize;

  /// Spark chart area size
  Rect? sparkChartAreaRect;

  /// Specifies the data label values.
  List<String>? dataLabels;

  /// Specifies the data label values.
  List<String>? reversedDataLabels;

  /// Method to find the minX, maxX, minY, maxY.
  void _calculateMinimumMaximumXY(SparkChartPoint currentPoint) {
    minX ??= currentPoint.x.toDouble();
    maxX ??= currentPoint.x.toDouble();
    minX = math.min(minX!, currentPoint.x.toDouble());
    maxX = math.max(maxX!, currentPoint.x.toDouble());
    minY ??= currentPoint.y.toDouble();
    maxY ??= currentPoint.y.toDouble();
    minY = math.min(minY!, currentPoint.y.toDouble());
    maxY = math.max(maxY!, currentPoint.y.toDouble());
  }

  /// Method to process the data source.
  void processDataSource() {
    if (dataPoints!.isNotEmpty) {
      dataPoints!.clear();
    }

    dataLabels = <String>[];
    reversedDataLabels = <String>[];
    minX = maxX = minY = maxY = null;
    SparkChartPoint currentPoint;
    String labelY;
    if (data != null && data!.isNotEmpty && data is List<num>) {
      for (int i = 0; i < data!.length; i++) {
        if (data![i] != null) {
          currentPoint = SparkChartPoint(x: i, y: data![i]);
          labelY = _getDataLabel(data![i]);
          currentPoint.labelY = labelY;
          _calculateMinimumMaximumXY(currentPoint);
          dataPoints!.add(currentPoint);
          dataLabels!.add(_getDataLabel(data![i]));
        }
      }
    } else {
      dynamic xValue;
      num? yValue;
      late String labelX;
      dynamic actualX;
      if (xValueMapper != null &&
          yValueMapper != null &&
          dataCount != null &&
          dataCount! > 0) {
        for (int i = 0; i < dataCount!; i++) {
          xValue = xValueMapper!(i);
          actualX = xValue;
          if (xValue is String) {
            labelX = xValue.toString();
            xValue = i.toDouble();
          } else if (xValue is DateTime) {
            xValue = xValue.millisecondsSinceEpoch;
            labelX = DateFormat.yMd()
                .format(DateTime.fromMillisecondsSinceEpoch(xValue));
          } else if (xValue is num) {
            labelX = _getDataLabel(xValue);
          }

          yValue = yValueMapper!(i);
          labelY = _getDataLabel(yValue);
          // ignore: unnecessary_null_comparison
          if (xValue != null && yValue != null) {
            currentPoint = SparkChartPoint(x: xValue, y: yValue);
            currentPoint.actualX = actualX;
            currentPoint.labelX = labelX;
            currentPoint.labelY = labelY;
            _calculateMinimumMaximumXY(currentPoint);
            dataPoints!.add(currentPoint);
            dataLabels!.add(_getDataLabel(currentPoint.y));
          }
        }
      }
    }
  }

  /// Returns the data label.
  String _getDataLabel(num value) {
    String dataLabel = value.toString();
    if (value is double) {
      value = double.parse(value.toStringAsFixed(3));
      final List<String>? list = dataLabel.split('.');
      if (list != null && list.length > 1 && num.parse(list[1]) == 0) {
        value = value.round();
      }
    }
    dataLabel = value.toString();
    return dataLabel;
  }

  /// Method to calculate axis height.
  double? getAxisHeight() {
    final double value = axisCrossesAt!;
    double? axisLineHeight =
        areaSize!.height - ((areaSize!.height / diffY!) * (-minY!));
    axisLineHeight = minY! < 0 && maxY! <= 0
        ? 0
        : (minY! < 0 && maxY! > 0)
            ? axisHeight
            : areaSize!.height;
    if (value >= minY! && value <= maxY!) {
      axisLineHeight = areaSize!.height -
          (areaSize!.height * ((value - minY!) / diffY!)).roundToDouble();
    }
    return axisLineHeight;
  }

  /// Inverse the data Points.
  void inverseDataPoints() {
    final List<SparkChartPoint> temp = dataPoints!.reversed.toList();
    reversedDataLabels = List<String>.from(dataLabels!.reversed);
    dataLabels!.clear();
    dataLabels!.addAll(reversedDataLabels!);
    dataPoints!.clear();
    dataPoints!.addAll(temp);
    final double tempX = minX!;
    minX = maxX;
    maxX = tempX;
  }

  /// Methods to calculate the visible points.
  void calculateRenderingPoints() {
    if (minX != null && maxX != null && minY != null && maxY != null) {
      diffX = maxX! - minX!;
      diffY = maxY! - minY!;
      axisHeight = getAxisHeight();
      if (coordinatePoints!.isNotEmpty) {
        coordinatePoints!.clear();
      }

      double x;
      double y;
      Offset visiblePoint;

      for (int i = 0; i < dataPoints!.length; i++) {
        x = dataPoints![i].x.toDouble();
        y = dataPoints![i].y.toDouble();
        visiblePoint = transformToCoordinatePoint(minX!, maxX!, minY!, maxY!,
            diffX!, diffY!, areaSize!, x, y, dataPoints!.length);
        coordinatePoints!.add(visiblePoint);
      }
      coordinatePoints = sortScreenCoordiantePoints(coordinatePoints!);
    }
  }

  /// Method to calculate the plot band position.
  void calculatePlotBandPosition() {
    final double height = areaSize!.height;
    final double? start = plotBand == null
        ? 0
        : (plotBand!.start ?? minY!) < minY!
            ? minY
            : (plotBand!.start ?? minY);
    final double? end = plotBand == null
        ? 0
        : (plotBand!.end ?? maxY!) > maxY!
            ? maxY
            : (plotBand!.end ?? maxY);
    plotBandStartHeight = height - ((height / diffY!) * (start! - minY!));
    plotBandEndHeight = height - ((height / diffY!) * (end! - minY!));
  }

  /// Method to render axis line.
  void renderAxisline(Canvas canvas, Offset offset) {
    if (axisLineWidth! > 0 && axisHeight != null) {
      final double x1 = offset.dx;
      final double y1 = offset.dy + axisHeight!;
      final double x2 = offset.dx + areaSize!.width;
      final Offset point1 = Offset(x1, y1);
      final Offset point2 = Offset(x2, y1);
      final Paint paint = Paint()
        ..strokeWidth = axisLineWidth!
        ..style = PaintingStyle.stroke
        ..color = axisLineColor!;
      if (axisLineDashArray != null && axisLineDashArray!.isNotEmpty) {
        drawDashedPath(canvas, paint, point1, point2, axisLineDashArray!);
      } else {
        canvas.drawLine(point1, point2, paint);
      }
    }
  }

  /// Method to render plot band.
  void renderPlotBand(Canvas canvas, Offset offset) {
    if (plotBandStartHeight != plotBandEndHeight) {
      final Paint paint = Paint()..color = plotBand!.color;
      final Rect plotBandRect = Rect.fromLTRB(
          offset.dx,
          offset.dy + plotBandStartHeight!,
          offset.dx + areaSize!.width,
          offset.dy + plotBandEndHeight!);
      if (plotBandRect.top >= sparkChartAreaRect!.top &&
          plotBandRect.bottom >= sparkChartAreaRect!.bottom) {
        canvas.drawRect(plotBandRect, paint);
        if (plotBand!.borderColor != Colors.transparent &&
            plotBand!.borderWidth > 0) {
          final Paint borderPaint = Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = plotBand!.borderWidth
            ..color = plotBand!.borderColor!;
          canvas.drawRect(plotBandRect, borderPaint);
        }
      }
    } else {
      final Paint paint = Paint()
        ..color = plotBand!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      final Offset point1 = Offset(offset.dx, offset.dy + plotBandStartHeight!);
      final Offset point2 =
          Offset(offset.dx + areaSize!.width, offset.dy + plotBandStartHeight!);
      canvas.drawLine(point1, point2, paint);
    }
  }

  /// Method to refresh the spark chart.
  void _refreshSparkChart() {
    processDataSource();
    if (isInversed!) {
      inverseDataPoints();
    }
    calculateRenderingPoints();
    if (plotBand != null) {
      calculatePlotBandPosition();
    }
  }

  @override
  void performLayout() {
    size = Size(constraints.maxWidth, constraints.maxHeight);
    areaSize = size;
    calculateRenderingPoints();
    if (plotBand != null) {
      calculatePlotBandPosition();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    renderAxisline(context.canvas, offset);
    sparkChartAreaRect = context.estimatedBounds;
    if (plotBand != null) {
      renderPlotBand(context.canvas, offset);
    }
  }
}
