import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../marker.dart';
import '../plot_band.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'renderer_base.dart';

/// Represents the render object for spark chart.
class SfSparkAreaChartRenderObjectWidget
    extends SfSparkChartRenderObjectWidget {
  /// Creates the render object for spark chart.
  const SfSparkAreaChartRenderObjectWidget({
    Key? key,
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
    this.marker,
    this.labelDisplayMode,
    this.labelStyle,
    SfChartThemeData? themeData,
    SparkChartDataDetails? sparkChartDataDetails,
    List<Offset>? coordinatePoints,
    List<SparkChartPoint>? dataPoints,
  }) : super(
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
            dataPoints: dataPoints,
            coordinatePoints: coordinatePoints);

  /// Specifies the area chart border width.
  final double? borderWidth;

  /// Specifies the area chart border color.
  final Color? borderColor;

  /// Specifies the area chart marker.
  final SparkChartMarker? marker;

  /// Specifies the spark chart data label.
  final SparkChartLabelDisplayMode? labelDisplayMode;

  /// Specifies the spark chart data label style.
  final TextStyle? labelStyle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSparkAreaChart(
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
        marker: marker,
        labelDisplayMode: labelDisplayMode,
        labelStyle: labelStyle,
        sparkChartDataDetails: sparkChartDataDetails,
        themeData: themeData,
        dataPoints: dataPoints,
        coordinatePoints: coordinatePoints);
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderSparkAreaChart renderObject) {
    renderObject
      ..dataCount = dataCount
      ..data = data
      ..xValueMapper = xValueMapper
      ..yValueMapper = yValueMapper
      ..isInversed = isInversed
      ..axisCrossesAt = axisCrossesAt
      ..axisLineColor = axisLineColor
      ..axisLineWidth = axisLineWidth
      ..axisLineDashArray = axisLineDashArray
      ..firstPointColor = firstPointColor
      ..lastPointColor = lastPointColor
      ..highPointColor = highPointColor
      ..lowPointColor = lowPointColor
      ..negativePointColor = negativePointColor
      ..color = color
      ..plotBand = plotBand
      ..borderColor = borderColor
      ..borderWidth = borderWidth
      ..marker = marker
      ..labelDisplayMode = labelDisplayMode
      ..labelStyle = labelStyle
      ..themeData = themeData
      ..dataPoints = dataPoints
      ..coordinatePoints = coordinatePoints;
  }
}

/// Represents the render spark area chart class.
class _RenderSparkAreaChart extends RenderSparkChart {
  /// Creates the render object widget.
  _RenderSparkAreaChart(
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
      SparkChartMarker? marker,
      SparkChartLabelDisplayMode? labelDisplayMode,
      TextStyle? labelStyle,
      SparkChartDataDetails? sparkChartDataDetails,
      SfChartThemeData? themeData,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : _borderWidth = borderWidth,
        _borderColor = borderColor,
        _marker = marker,
        _labelDisplayMode = labelDisplayMode,
        _labelStyle = labelStyle,
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

  /// Returns the dash arry value.
  Color? get borderColor => _borderColor;

  /// Set the line width value.
  set borderColor(Color? value) {
    if (_borderColor != value) {
      _borderColor = value;
      markNeedsPaint();
    }
  }

  /// Defines the marker for spark chart.
  SparkChartMarker? _marker;

  /// Gets the marker for spark chart.
  SparkChartMarker? get marker => _marker;

  /// Sets the marker for spark chart.
  set marker(SparkChartMarker? value) {
    if (_marker != value) {
      _marker = value;
      markNeedsPaint();
    }
  }

  /// Defines the spark chart data label mode.
  SparkChartLabelDisplayMode? _labelDisplayMode;

  /// Returns the spark chart data label mode.
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

  /// Specifies the low point in series.
  num? _lowPoint;

  /// Specifies the high point in series.
  num? _highPoint;

  @override
  void processDataSource() {
    super.processDataSource();
    if (dataPoints != null && dataPoints!.isNotEmpty) {
      final List<SparkChartPoint> temp =
          List<SparkChartPoint>.from(dataPoints!);
      final List<String> tempDataLabels = List<String>.from(dataLabels!);
      dataLabels!.clear();
      dataPoints!.clear();
      final SparkChartPoint point1 =
          SparkChartPoint(x: temp[0].x, y: minY!.toDouble());
      point1.labelX = temp[0].labelX;
      point1.labelY = temp[0].labelY;
      dataPoints!.add(point1);
      dataPoints!.addAll(temp);
      final SparkChartPoint point2 =
          SparkChartPoint(x: temp[temp.length - 1].x, y: minY!.toDouble());
      point2.labelX = temp[temp.length - 1].labelX;
      point2.labelY = temp[temp.length - 1].labelY;
      dataPoints!.add(point2);
      dataLabels!.add('0');
      dataLabels!.addAll(tempDataLabels);
      dataLabels!.add('0');
    }
  }

  /// Render area series.
  void _renderAreaSeries(Canvas canvas, Offset offset) {
    final Paint paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;
    final Path path = Path();
    Size size;
    _labelStyle = themeData!.dataLabelTextStyle;
    _highPoint = coordinatePoints![0].dy;
    _lowPoint = coordinatePoints![0].dy;

    for (int i = 0; i < coordinatePoints!.length; i++) {
      if (_highPoint! < coordinatePoints![i].dy) {
        _highPoint = coordinatePoints![i].dy;
      }

      if (_lowPoint! > coordinatePoints![i].dy) {
        _lowPoint = coordinatePoints![i].dy;
      }

      if (i == 0) {
        path.moveTo(offset.dx + coordinatePoints![i].dx,
            offset.dy + coordinatePoints![i].dy);
      }

      if (i < coordinatePoints!.length - 1) {
        path.lineTo(offset.dx + coordinatePoints![i + 1].dx,
            offset.dy + coordinatePoints![i + 1].dy);
      }

      if (i >= 1 &&
          i <= coordinatePoints!.length - 2 &&
          labelDisplayMode != SparkChartLabelDisplayMode.none &&
          labelStyle != null) {
        size = getTextSize(dataLabels![i], labelStyle!);
        dataPoints![i].dataLabelOffset = Offset(
            (offset.dx + coordinatePoints![i].dx) - size.width / 2,
            offset.dy +
                (marker != null &&
                        marker!.displayMode != SparkChartMarkerDisplayMode.none
                    ? (dataPoints![i].y > 0
                        ? (coordinatePoints![i].dy -
                            size.height -
                            marker!.size / 2)
                        : (coordinatePoints![i].dy + marker!.size / 2))
                    : dataPoints![i].y > 0
                        ? (coordinatePoints![i].dy - size.height)
                        : (coordinatePoints![i].dy + size.height)));
        if (dataPoints![i].dataLabelOffset!.dx <= offset.dx) {
          dataPoints![i].dataLabelOffset =
              Offset(offset.dx, dataPoints![i].dataLabelOffset!.dy);
        }

        if (dataPoints![i].dataLabelOffset!.dx >= offset.dx + areaSize!.width) {
          dataPoints![i].dataLabelOffset = Offset(
              (offset.dx + areaSize!.width) - size.width,
              dataPoints![i].dataLabelOffset!.dy);
        }

        if (dataPoints![i].dataLabelOffset!.dy <= offset.dy) {
          dataPoints![i].dataLabelOffset = Offset(
              dataPoints![i].dataLabelOffset!.dx,
              offset.dy +
                  (marker != null &&
                          marker!.displayMode !=
                              SparkChartMarkerDisplayMode.none
                      ? marker!.size / 2 + size.height
                      : size.height));
        }

        if (dataPoints![i].dataLabelOffset!.dy >=
            offset.dy + areaSize!.height) {
          dataPoints![i].dataLabelOffset = Offset(
              dataPoints![i].dataLabelOffset!.dx,
              (offset.dy + areaSize!.height) -
                  (marker != null &&
                          marker!.displayMode !=
                              SparkChartMarkerDisplayMode.none
                      ? marker!.size / 2 + size.height
                      : size.height));
        }
      }
    }

    canvas.drawPath(path, paint);
    if (borderColor != null &&
        borderColor != Colors.transparent &&
        borderWidth != null &&
        borderWidth! > 0) {
      _renderAreaSeriesBorder(canvas, offset);
    }
  }

  /// Method to render the area series border.
  void _renderAreaSeriesBorder(Canvas canvas, Offset offset) {
    final Paint strokePaint = Paint()
      ..color = borderColor!
      ..strokeWidth = borderWidth!
      ..style = PaintingStyle.stroke;

    final Path strokePath = Path();
    for (int i = 1; i < coordinatePoints!.length - 1; i++) {
      if (i == 1) {
        strokePath.moveTo(offset.dx + coordinatePoints![i].dx,
            offset.dy + coordinatePoints![i].dy);
      }

      if (i < coordinatePoints!.length - 2) {
        strokePath.lineTo(offset.dx + coordinatePoints![i + 1].dx,
            offset.dy + coordinatePoints![i + 1].dy);
      }
    }

    canvas.drawPath(strokePath, strokePaint);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (coordinatePoints != null &&
        coordinatePoints!.isNotEmpty &&
        dataPoints != null &&
        dataPoints!.isNotEmpty) {
      _renderAreaSeries(context.canvas, offset);
      if (marker != null &&
          marker!.displayMode != SparkChartMarkerDisplayMode.none &&
          marker!.borderWidth > 0) {
        renderMarker(
            context.canvas,
            offset,
            marker!,
            coordinatePoints!,
            dataPoints!,
            color!,
            'Area',
            _highPoint!,
            _lowPoint!,
            axisCrossesAt!,
            themeData!,
            lowPointColor,
            highPointColor,
            negativePointColor,
            firstPointColor,
            lastPointColor);
      }
      if (labelDisplayMode != null &&
          labelDisplayMode != SparkChartLabelDisplayMode.none) {
        renderDataLabel(
            context.canvas,
            dataLabels!,
            dataPoints!,
            coordinatePoints!,
            labelStyle!,
            labelDisplayMode!,
            'Area',
            themeData!,
            offset,
            color!,
            _highPoint!,
            _lowPoint!);
      }
    }
  }
}
