import 'package:flutter/foundation.dart' show DiagnosticableTree;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../maps.dart';
import 'controller/map_controller.dart';
import 'layer/zoomable.dart';
import 'utils.dart';

// ignore_for_file: public_member_api_docs
enum Gesture { scale, pan }

enum MarkerAction { insert, removeAt, replace, clear }

enum LayerType { shape, tile }

enum GeoJSONSourceType { asset, network, memory }

/// Specifies the layer for tooltip.
enum MapLayerElement {
  /// Shows tooltip for shape layer.
  shape,

  /// Shows tooltip for bubble.
  bubble,

  /// Shows tooltip for marker.
  marker,

  /// Shows tooltip for vector layers.
  vector,
}

/// Specifies the kind of pointer.
enum PointerKind {
  /// Indicates the pointer kind as touch.
  touch,

  /// Indicates the pointer kind as hover.
  hover
}

/// Provides the information about the current and previous zoom level.
class TileZoomLevelDetails {
  /// Represents the visual tiles origin.
  Offset? origin;

  /// Represents the tile zoom level.
  late double zoomLevel;

  /// Provides the distance moved from the origin when doing pinch zooming.
  Offset translatePoint = Offset.zero;

  /// Represents the fractional zoom value.
  double scale = 1.0;
}

class MapModel {
  MapModel({
    required this.primaryKey,
    required this.actualIndex,
    required this.rawPoints,
    this.pixelPoints,
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
    this.colorValue,
  });

  /// Contains [sourceDataPath] values.
  late String primaryKey;

  /// Contains data Source index.
  int? dataIndex;

  /// Specifies an item index in the data source list.
  late int actualIndex;

  /// Contains the index of the shape or bubble legend.
  int? legendMapperIndex;

  /// Contains pixel points.
  List<List<Offset>>? pixelPoints;

  /// Contains coordinate points.
  late List<List<dynamic>> rawPoints;

  /// Option to select the particular shape
  /// based on the position of the tap or click.
  ///
  /// Returns `true` when the shape is selected else it will be `false`.
  ///
  /// See also:
  /// * [MapSelectionSettings] option to customize the shape selection.
  bool isSelected = false;

  /// Contains data source Label text.
  String? dataLabelText;

  /// Use this text while zooming.
  String? visibleDataLabelText;

  /// Contains the tooltip text.
  String? tooltipText;

  /// Contains data source color.
  Color? shapeColor;

  /// Contains the actual shape color value.
  dynamic shapeColorValue;

  /// Contains the shape path.
  Path? shapePath;

  // Center of shape path which is used to position the data labels.
  Offset? shapePathCenter;

  // Width for smart position the data labels.
  double? shapeWidth;

  /// Contains data source bubble color.
  Color? bubbleColor;

  /// Contains data source bubble size.
  double? bubbleSizeValue;

  /// Contains data source bubble radius.
  double? bubbleRadius;

  /// Contains the bubble path.
  Path? bubblePath;

  /// Contains the color value.
  dynamic colorValue;

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
    colorValue = null;
  }
}

/// Base class for shape and tile layer for internal usage.
class MapLayerInheritedWidget extends InheritedWidget {
  /// Creates [MapLayerInheritedWidget].
  const MapLayerInheritedWidget(
      {required Widget child,
      required this.controller,
      this.zoomController,
      this.sublayers})
      : super(child: child);

  /// Creates [MapController].
  final MapController controller;

  /// Creates [ZoomableController].
  final ZoomableController? zoomController;

  /// Collection of [MapShapeSublayer], [MapLineLayer], [MapPolylineLayer],
  /// [MapPolygonLayer], [MapCircleLayer], and [MapArcLayer].
  final List<MapSublayer>? sublayers;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

/// Adds [MapSublayer] into a stack widget.
class SublayerContainer extends Stack {
  /// Creates a [SublayerContainer].
  const SublayerContainer({
    required this.ancestor,
    required List<MapSublayer> children,
  }) : super(children: children);

  final MapLayerInheritedWidget ancestor;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return RenderSublayerContainer(container: this, context: context);
  }
}

/// Adds [MapSublayer] into a stack widget.
class RenderSublayerContainer extends RenderStack {
  /// Creates a [RenderSublayerContainer].
  RenderSublayerContainer({
    required this.container,
    required this.context,
  }) : super(textDirection: Directionality.of(context));

  /// The build context.
  final BuildContext context;

  final SublayerContainer container;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
    RenderBox? child = firstChild;
    while (child != null) {
      final StackParentData childParentData =
          // ignore: avoid_as
          child.parentData! as StackParentData;
      child.layout(constraints);
      child = childParentData.nextSibling;
    }
  }
}

class ShapeLayerChildRenderBoxBase extends RenderProxyBox {
  void onHover(MapModel? item, MapLayerElement? element) {
    // Handle hover interaction here.
  }

  void paintTooltip(int? elementIndex, Rect? elementRect,
      MapLayerElement? element, PointerKind kind,
      [int? sublayerIndex, Offset? position]) {}

  void onExit() {
    // Handle exit interaction here.
  }

  void refresh() {
    /// Refresh/repaint the current view.
  }

  void hideTooltip({bool immediately = false}) {
    // Hides the tooltip.
  }
}

class MapIconShape {
  const MapIconShape();

  /// Returns the size based on the value passed to it.
  Size getPreferredSize(Size iconSize, SfMapsThemeData? themeData) {
    return iconSize;
  }

  /// Paints the shapes based on the value passed to it.
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SfMapsThemeData themeData,
    required Size iconSize,
    required Color color,
    required double strokeWidth,
    required MapIconType iconType,
    Color? strokeColor,
  }) {
    iconSize = getPreferredSize(iconSize, themeData);
    final double halfIconWidth = iconSize.width / 2;
    final double halfIconHeight = iconSize.height / 2;
    final bool hasStroke = strokeWidth > 0 &&
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

class DebugSublayerTree extends DiagnosticableTree {
  DebugSublayerTree(this.sublayers);

  final List<MapSublayer> sublayers;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    if (sublayers.isNotEmpty) {
      return sublayers.map<DiagnosticsNode>((MapSublayer sublayer) {
        return sublayer.toDiagnosticsNode();
      }).toList();
    }
    return super.debugDescribeChildren();
  }

  @override
  String toStringShort() {
    return sublayers.length > 1
        ? 'contains ${sublayers.length} sublayers'
        : 'contains ${sublayers.length} sublayer';
  }
}
