import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../utils/enum.dart';
import 'circular_series.dart';
import 'renderer_extension.dart';

/// It is the data type for the circular chart and it has the properties is used to assign at the value
/// declaration of the circular chart.
///
/// It provides the options for color, stroke color, fill color, radius, angle to customize the circular chart.
///
class ChartPoint<D> {
  /// Creating an argument constructor of ChartPoint class.
  ChartPoint([this.x, this.y, this.radius, this.pointColor, this.sortValue]);

  /// X value of chart point.
  dynamic x;

  /// Y value of chart point.
  num? y;

  /// Degree of chart point.
  num? degree;

  /// Start angle of chart point.
  num? startAngle;

  /// End angle of chart point.
  num? endAngle;

  /// Middle angle of chart point.
  num? midAngle;

  /// Center position of chart point.
  Offset? center;

  /// Text value of chart point.
  String? text;

  /// Fill  color of the chart point.
  late Color fill;

  /// Color of chart point.
  late Color color;

  /// Stroke color of chart point.
  late Color strokeColor;

  /// Sort value of chart point.
  D? sortValue;

  /// Stroke width of chart point.
  late num strokeWidth;

  /// Inner radius of chart point.
  num? innerRadius;

  /// Outer radius of chart point.
  num? outerRadius;

  /// To set the explode value of chart point.
  bool? isExplode;

  /// To set the shadow value of chart point.
  bool? isShadow;

  /// To set the empty value of chart point.
  bool isEmpty = false;

  /// To set the visibility of chart point.
  bool isVisible = true;

  /// To set the selected or unselected of chart point.
  bool isSelected = false;

  /// Data label position of chart point.
  late Position dataLabelPosition;

  /// Render position of chart point.
  ChartDataLabelPosition? renderPosition;

  /// Label rect of chart point.
  late Rect labelRect;

  /// Size of the Data label of chart point.
  Size dataLabelSize = Size.zero;

  /// Saturation region value of chart point.
  bool saturationRegionOutside = false;

  /// Y ratio of chart point.
  late num yRatio;

  /// Height Ratio of chart point.
  late num heightRatio;

  /// Radius of the chart point.
  String? radius;

  /// Color property of the chart point.
  Color? pointColor;

  /// To store the trimmed text, if the label renders outside the container area.
  String? trimmedText;

  /// Stores the segment overflow data label trimmed text.
  String? overflowTrimmedText;

  /// To execute [onTooltipRender] event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// To execute [onDataLabelRender] event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;

  /// Current point index.
  late int index;

  // Data type
  dynamic _data;

  /// PointShader Mapper.
  ChartShaderMapper<dynamic>? _pointShaderMapper;

  /// Holds the value either 0 or 1 to denote whether the current label is positioned smartly.
  num? _isLabelUpdated;

  /// Holds the shifted angle of chart point.
  num? _newAngle;

  /// Shader of chart point.
  Shader? get shader =>
      _pointShaderMapper != null && center != null && outerRadius != null
          ? _pointShaderMapper!(
              _data,
              index,
              fill,
              Rect.fromCircle(
                center: center!,
                radius: outerRadius!.toDouble(),
              ),
            )
          : null;

  /// Path of circular Series.
  Rect? _pathRect;
}

// ignore: avoid_classes_with_only_static_members
/// Helper class for handling private fields.
class PointHelper {
  /// Returns the value of pathRect for given point.
  static Rect? getPathRect(ChartPoint<dynamic> point) => point._pathRect;

  /// Returns the value that data label is updated or not.
  static num? getLabelUpdated(ChartPoint<dynamic> point) =>
      point._isLabelUpdated;

  /// Stores the value of pathRect for a given point.
  static void setPathRect(ChartPoint<dynamic> point, Rect? pathRect) {
    point._pathRect = pathRect;
  }

  /// Stores the value 1 or 0 to indicate the label is updated or not.
  static void setLabelUpdated(ChartPoint<dynamic> point, num? isLabelUpdated) {
    point._isLabelUpdated = isLabelUpdated;
  }

  /// Returns the value of `_pointShaderMapper` for given point.
  static ChartShaderMapper<dynamic>? getPointShaderMapper(
          ChartPoint<dynamic> point) =>
      point._pointShaderMapper;

  /// Return the value of the shifted data label angle.
  static num? getNewAngle(ChartPoint<dynamic> point) => point._newAngle;

  /// Stores the shifted data label angle.
  static void setNewAngle(ChartPoint<dynamic> point, num? newAngle) {
    point._newAngle = newAngle;
  }
}

/// To get current point
ChartPoint<dynamic> getCircularPoint(
    CircularSeriesRendererExtension seriesRenderer, int pointIndex) {
  final CircularSeries<dynamic, dynamic> series = seriesRenderer.series;
  late ChartPoint<dynamic> currentPoint;
  final ChartIndexedValueMapper<dynamic>? xMap = series.xValueMapper;
  final ChartIndexedValueMapper<dynamic>? yMap = series.yValueMapper;
  final ChartIndexedValueMapper<dynamic>? sortFieldMap =
      series.sortFieldValueMapper;
  final ChartIndexedValueMapper<String>? radiusMap = series.pointRadiusMapper;
  final ChartIndexedValueMapper<Color>? colorMap = series.pointColorMapper;
  final ChartShaderMapper<dynamic>? shadeMap = series.pointShaderMapper;

  /// Can be either a string or num value
  dynamic xVal;
  num? yVal;
  String? radiusVal;
  Color? colorVal;
  String? sortVal;
  if (xMap != null) {
    xVal = xMap(pointIndex);
  }

  if (xVal != null) {
    if (yMap != null) {
      yVal = yMap(pointIndex);
    }

    if (radiusMap != null) {
      radiusVal = radiusMap(pointIndex);
    }

    if (colorMap != null) {
      colorVal = colorMap(pointIndex);
    }
    if (sortFieldMap != null) {
      sortVal = sortFieldMap(pointIndex);
    }

    currentPoint =
        ChartPoint<dynamic>(xVal, yVal, radiusVal, colorVal, sortVal);
  }
  currentPoint.index = pointIndex;
  if (shadeMap != null) {
    currentPoint._pointShaderMapper = shadeMap;
  } else {
    currentPoint._pointShaderMapper = null;
  }
  currentPoint.center = seriesRenderer.center;

  return currentPoint;
}
