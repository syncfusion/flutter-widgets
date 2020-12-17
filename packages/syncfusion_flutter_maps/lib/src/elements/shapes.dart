import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../enum.dart';

// ignore_for_file: public_member_api_docs
class ShapeLayerChildRenderBoxBase extends RenderProxyBox {
  void onHover(MapModel item, MapLayerElement element) {}

  void paintTooltip(int elementIndex, Rect elementRect, MapLayerElement element,
      [int sublayerIndex, Offset position]) {}

  void onExit() {}

  void refresh() {}

  void hideTooltip({bool immediately = false}) {}
}

class MapModel {
  MapModel({
    this.primaryKey,
    this.pixelPoints,
    this.rawPoints,
    this.actualIndex,
    this.dataIndex,
    this.legendMapperIndex,
    this.shapePath,
    this.isSelected = false,
    this.shapeColor,
    this.dataLabelText,
    this.visibleDataLabelText,
    this.bubbleColor,
    this.bubbleSizeValue,
    this.bubbleRadius,
    this.bubblePath,
    this.tooltipText,
  });

  /// Contains [sourceDataPath] values.
  String primaryKey;

  /// Contains data Source index.
  int dataIndex;

  /// Specifies an item index in the data source list.
  int actualIndex;

  /// Contains the index of the shape or bubble legend.
  int legendMapperIndex;

  /// Contains pixel points.
  List<List<Offset>> pixelPoints;

  /// Contains coordinate points.
  List<List<dynamic>> rawPoints;

  /// Option to select the particular shape
  /// based on the position of the tap or click.
  ///
  /// Returns `true` when the shape is selected else it will be `false`.
  ///
  /// See also:
  /// * [MapSelectionSettings] option to customize the shape selection.
  bool isSelected = false;

  /// Contains data source Label text.
  String dataLabelText;

  /// Use this text while zooming.
  String visibleDataLabelText;

  /// Contains the tooltip text.
  String tooltipText;

  /// Contains data source color.
  Color shapeColor;

  /// Contains the actual shape color value.
  dynamic shapeColorValue;

  /// Contains the shape path.
  Path shapePath;

  // Center of shape path which is used to position the data labels.
  Offset shapePathCenter;

  // Width for smart position the data labels.
  double shapeWidth;

  /// Contains data source bubble color.
  Color bubbleColor;

  /// Contains data source bubble size.
  double bubbleSizeValue;

  /// Contains data source bubble radius.
  double bubbleRadius;

  /// Contains the bubble path.
  Path bubblePath;

  void reset() {
    dataIndex = null;
    isSelected = false;
    dataLabelText = null;
    visibleDataLabelText = null;
    tooltipText = null;
    shapeColor = null;
    shapeColorValue = null;
    shapePath = null;
    shapePathCenter = null;
    shapeWidth = null;
    bubbleColor = null;
    bubbleSizeValue = null;
    bubbleRadius = null;
    bubblePath = null;
  }
}

class MapIconShape {
  const MapIconShape();

  /// Returns the size based on the value passed to it.
  Size getPreferredSize(Size iconSize, SfMapsThemeData themeData) {
    return iconSize;
  }

  /// Paints the shapes based on the value passed to it.
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SfMapsThemeData themeData,
    Size iconSize,
    Color color,
    Color strokeColor,
    double strokeWidth,
    MapIconType iconType,
  }) {
    iconSize = getPreferredSize(iconSize, themeData);
    final double halfIconWidth = iconSize.width / 2;
    final double halfIconHeight = iconSize.height / 2;
    final bool hasStroke = strokeWidth != null &&
        strokeWidth > 0 &&
        strokeColor != null &&
        strokeColor != Colors.transparent;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color;
    Path path;

    switch (iconType) {
      case MapIconType.circle:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawOval(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawOval(rect, paint);
        }
        break;
      case MapIconType.rectangle:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawRect(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawRect(rect, paint);
        }
        break;
      case MapIconType.triangle:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + iconSize.height)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
      case MapIconType.diamond:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + halfIconHeight)
          ..lineTo(offset.dx + halfIconWidth, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + halfIconHeight)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
    }
  }
}
