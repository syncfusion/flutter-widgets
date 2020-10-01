part of charts;

/// This is similar to the point of the Cartesian chart.
class PointInfo<D> {
  /// Creating an argument constructor of PointInfo class.
  PointInfo(this.x, this.y);

  /// X value of point info
  dynamic x;

  /// Y value of point info
  num y;

  /// Text value of point info
  String text;

  /// Fill color of point info.
  Color fill;

  /// Stores the point info color.
  Color color;

  /// Stores the border color of point info.
  Color borderColor;

  /// Stores the sort value.
  D sortValue;

  /// Stores the border width value.
  num borderWidth;

  /// To set the property of explode.
  bool isExplode;

  /// To set the property of shadow.
  bool isShadow;

  /// To set the property of empty.
  bool isEmpty = false;

  /// To set the property of visible.
  bool isVisible = true;

  /// To set the property of selection.
  bool isSelected = false;

  /// Stores the value of label position.
  Position dataLabelPosition;

  /// Stores the value of chart data label position.
  ChartDataLabelPosition renderPosition;

  /// Stores the value of label rect.
  Rect labelRect;

  /// Stores the value data label size.
  Size dataLabelSize = const Size(0, 0);

  /// To set the saturation region.
  bool saturationRegionOutside = false;

  /// Stores the value of Y ratio.
  num yRatio;

  /// Stores the value of height ratio.
  num heightRatio;

  /// Stores the list value of path region.
  List<Offset> pathRegion;

  /// Stores the value of region.
  Rect region;

  /// Stores the offset value of symbol location.
  Offset symbolLocation;

  /// Stores the value of explode Distance.
  num explodeDistance;

  /// To execute onTooltipRender event or not.
  // ignore: prefer_final_fields
  bool isTooltipRenderEvent = false;

  /// To execute OnDataLabelRender event or not.
  // ignore: prefer_final_fields
  bool labelRenderEvent = false;
}
