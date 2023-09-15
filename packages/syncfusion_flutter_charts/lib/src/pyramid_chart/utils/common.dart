import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../circular_chart/utils/enum.dart';

/// This is similar to the point of the Cartesian chart.
class PointInfo<D> {
  /// Creating an argument constructor of PointInfo class.
  PointInfo(this.x, this.y);

  /// X value of point info.
  dynamic x;

  /// Y value of point info.
  num? y;

  /// Text value of point info.
  String? text;

  /// Fill color of point info.
  late Color fill;

  /// Stores the point info color.
  late Color color;

  /// Stores the border color of point info.
  late Color borderColor;

  /// Stores the sort value.
  D? sortValue;

  /// Stores the border width value.
  late num borderWidth;

  /// To set the property of explode.
  bool isExplode = false;

  /// To set the property of shadow.
  bool isShadow = false;

  /// To set the property of empty.
  bool isEmpty = false;

  /// To set the property of visible.
  bool isVisible = true;

  /// To set the property of selection.
  bool isSelected = false;

  /// Stores the value of label position.
  Position? dataLabelPosition;

  /// Stores the value of chart data label position.
  ChartDataLabelPosition? renderPosition;

  /// Stores the value of label rect.
  Rect? labelRect;

  /// To check if labels collide.
  bool _isLabelCollide = false;

  /// Stores the value data label size.
  Size dataLabelSize = Size.zero;

  /// To set the saturation region.
  bool saturationRegionOutside = false;

  /// Stores the value of Y ratio.
  late num yRatio;

  /// Stores the value of height ratio.
  late num heightRatio;

  /// Stores the list value of path region.
  late List<Offset> pathRegion;

  /// Stores the value of region.
  Rect? region;

  /// Stores the offset value of symbol location.
  late Offset symbolLocation;

  /// Stores the value of explode Distance.
  num? explodeDistance;

  /// To execute onTooltipRender event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// To execute OnDataLabelRender event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;
}

// ignore: avoid_classes_with_only_static_members
/// Helper class handling PointInfo class private fields.
class PointInfoHelper {
  /// Returns the value of isLabelCollide flag for the given point.
  static bool getIsLabelCollide(PointInfo<dynamic> point) =>
      point._isLabelCollide;

  /// Sets the value of isLabelCollide flag for the given point.
  static void setIsLabelCollide(PointInfo<dynamic> point, bool isLabelCollide) {
    point._isLabelCollide = isLabelCollide;
  }
}
