import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../marker.dart';
import '../plot_band.dart';
import '../utils/enum.dart';
import '../utils/helper.dart';
import 'renderer_base.dart';

/// Represents the render object for spark chart.
class SfSparkLineChartRenderObjectWidget
    extends SfSparkChartRenderObjectWidget {
  /// Creates the render object for spark chart.
  const SfSparkLineChartRenderObjectWidget(
      {Key? key,
      this.width,
      this.dashArray,
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

  /// Specifies the line width.
  final double? width;

  /// Specifies the dash array.
  final List<double>? dashArray;

  /// Specifies the area chart marker.
  final SparkChartMarker? marker;

  /// Specifies the spark chart data label.
  final SparkChartLabelDisplayMode? labelDisplayMode;

  /// Specifies the spark chart data label style.
  final TextStyle? labelStyle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSparkLineChart(
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
        width: width,
        dashArray: dashArray,
        marker: marker,
        labelDisplayMode: labelDisplayMode,
        labelStyle: labelStyle,
        themeData: themeData!,
        sparkChartDataDetails: sparkChartDataDetails,
        coordinatePoints: coordinatePoints,
        dataPoints: dataPoints);
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderSparkLineChart renderObject) {
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
      ..width = width
      ..dashArray = dashArray
      ..marker = marker
      ..labelDisplayMode = labelDisplayMode
      ..labelStyle = labelStyle
      ..themeData = themeData
      ..coordinatePoints = coordinatePoints
      ..dataPoints = dataPoints;
  }
}

/// Represents the render spark line class.
class _RenderSparkLineChart extends RenderSparkChart {
  /// Creates the render object widget.
  _RenderSparkLineChart(
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
      double? width,
      List<double>? dashArray,
      SparkChartMarker? marker,
      SparkChartLabelDisplayMode? labelDisplayMode,
      TextStyle? labelStyle,
      SparkChartDataDetails? sparkChartDataDetails,
      SfChartThemeData? themeData,
      List<Offset>? coordinatePoints,
      List<SparkChartPoint>? dataPoints})
      : _width = width,
        _dashArray = dashArray,
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
            themeData: themeData,
            sparkChartDataDetails: sparkChartDataDetails,
            coordinatePoints: coordinatePoints,
            dataPoints: dataPoints);

  /// Defines the line width.
  double? _width;

  /// Returns the line width value.
  double? get width => _width;

  /// Set the line width value.
  set width(double? value) {
    if (_width != value) {
      _width = value;
      markNeedsPaint();
    }
  }

  /// Defines the dash array.
  List<double>? _dashArray;

  /// Returns the dash array value.
  List<double>? get dashArray => _dashArray;

  /// Set the line width value.
  set dashArray(List<double>? value) {
    if (_dashArray != value) {
      _dashArray = value;
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
  late num _lowPoint;

  /// Specifies the high point in series.
  late num _highPoint;

  /// Render line series.
  void _renderLineSeries(Canvas canvas, Offset offset) {
    if (width != null && width! > 0) {
      _labelStyle = themeData!.dataLabelTextStyle;
      final Paint paint = Paint()
        ..strokeWidth = width!
        ..style = PaintingStyle.stroke
        ..color = color!;

      Size size;
      double yPosition;
      _highPoint = coordinatePoints![0].dy;
      _lowPoint = coordinatePoints![0].dy;
      if (dashArray != null && dashArray!.isNotEmpty) {
        Offset point1, point2;
        for (int i = 0; i < coordinatePoints!.length; i++) {
          if (_highPoint < coordinatePoints![i].dy) {
            _highPoint = coordinatePoints![i].dy;
          }

          if (_lowPoint > coordinatePoints![i].dy) {
            _lowPoint = coordinatePoints![i].dy;
          }

          if (i < coordinatePoints!.length - 1) {
            point1 = Offset(offset.dx + coordinatePoints![i].dx,
                offset.dy + coordinatePoints![i].dy);
            point2 = Offset(offset.dx + coordinatePoints![i + 1].dx,
                offset.dy + coordinatePoints![i + 1].dy);
            drawDashedPath(canvas, paint, point1, point2, dashArray);
          }
          if (labelDisplayMode != SparkChartLabelDisplayMode.none &&
              labelStyle != null) {
            size = getTextSize(dataLabels![i], labelStyle!);
            yPosition = marker != null &&
                    marker!.displayMode != SparkChartMarkerDisplayMode.none
                ? (dataPoints![i].y > 0
                    ? (coordinatePoints![i].dy - size.height - marker!.size / 2)
                    : (coordinatePoints![i].dy + marker!.size / 2))
                : dataPoints![i].y > 0
                    ? (coordinatePoints![i].dy - size.height)
                    : (coordinatePoints![i].dy);
            dataPoints![i].dataLabelOffset = Offset(
                (offset.dx + coordinatePoints![i].dx) - size.width / 2,
                offset.dy + yPosition);
            _positionDataLabels(dataPoints![i], size, offset);
          }
        }
      } else {
        final Path path = Path();
        for (int i = 0; i < coordinatePoints!.length; i++) {
          if (_highPoint < coordinatePoints![i].dy) {
            _highPoint = coordinatePoints![i].dy;
          }

          if (_lowPoint > coordinatePoints![i].dy) {
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
          if (labelDisplayMode != SparkChartLabelDisplayMode.none &&
              labelStyle != null) {
            size = getTextSize(dataLabels![i], labelStyle!);

            yPosition = marker != null &&
                    marker!.displayMode != SparkChartMarkerDisplayMode.none
                ? (dataPoints![i].y > 0
                    ? (coordinatePoints![i].dy - size.height - marker!.size / 2)
                    : (coordinatePoints![i].dy + marker!.size / 2))
                : dataPoints![i].y > 0
                    ? (coordinatePoints![i].dy - size.height)
                    : (coordinatePoints![i].dy);
            dataPoints![i].dataLabelOffset = Offset(
                (offset.dx + coordinatePoints![i].dx) - size.width / 2,
                offset.dy + yPosition);
            _positionDataLabels(dataPoints![i], size, offset);
          }
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  void _positionDataLabels(
      SparkChartPoint dataPoint, Size size, Offset offset) {
    if (dataPoint.dataLabelOffset!.dx <= offset.dx) {
      dataPoint.dataLabelOffset =
          Offset(offset.dx, dataPoint.dataLabelOffset!.dy);
    }
    if (dataPoint.dataLabelOffset!.dx >= offset.dx + areaSize!.width) {
      dataPoint.dataLabelOffset = Offset(
          (offset.dx + areaSize!.width) - size.width,
          dataPoint.dataLabelOffset!.dy);
    }

    if (dataPoint.dataLabelOffset!.dy <= offset.dy) {
      dataPoint.dataLabelOffset = Offset(
          dataPoint.dataLabelOffset!.dx,
          offset.dy +
              (marker != null &&
                      marker!.displayMode != SparkChartMarkerDisplayMode.none
                  ? marker!.size / 2 + size.height
                  : size.height));
    }

    if (dataPoint.dataLabelOffset!.dy >= offset.dy + areaSize!.height) {
      dataPoint.dataLabelOffset = Offset(
          dataPoint.dataLabelOffset!.dx,
          (offset.dy + areaSize!.height) -
              (marker != null &&
                      marker!.displayMode != SparkChartMarkerDisplayMode.none
                  ? marker!.size / 2 + size.height
                  : size.height));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (coordinatePoints != null &&
        coordinatePoints!.isNotEmpty &&
        dataPoints != null &&
        dataPoints!.isNotEmpty) {
      _renderLineSeries(context.canvas, offset);

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
            'Line',
            _highPoint,
            _lowPoint,
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
            'Line',
            themeData!,
            offset,
            color!,
            _highPoint,
            _lowPoint);
      }
    }
  }
}
