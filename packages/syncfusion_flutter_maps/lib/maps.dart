library maps;

import 'package:flutter/foundation.dart' show DiagnosticableTree;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'src/layer/layer_base.dart';
import 'src/layer/shape_layer.dart';

export 'src/behavior/zoom_pan_behavior.dart'
    hide BehaviorViewRenderObjectWidget;
export 'src/controller/shape_layer_controller.dart';
export 'src/elements/legend.dart' hide MapLegendWidget;
export 'src/elements/marker.dart' hide MarkerContainer;
export 'src/enum.dart';
export 'src/layer/layer_base.dart';
export 'src/layer/shape_layer.dart';
export 'src/layer/tile_layer.dart';
export 'src/layer/vector_layers.dart' hide MapVectorLayer;
export 'src/settings.dart';

/// A data visualization component that displays statistical information for a
/// geographical area.
///
/// The [SfMaps.layers] is a collection of [MapLayer]. It contains either
/// [MapShapeLayer] and [MapTileLayer].
///
/// ## Shape layer
///
/// The [MapShapeLayer] has the following elements and features,
///
/// * The "data labels", to provide information to users about the respective
/// shape.
/// * The "markers", which denotes a location with built-in symbols and allows
/// displaying custom widgets at a specific latitude and longitude on a map.
/// * The "bubbles", which adds information to shapes such as population
/// density, number of users, and more. Bubbles can be rendered in different
/// colors and sizes based on the data values of their assigned shape.
/// * The "legend", to provide clear information on the data plotted in the map
/// through shapes and bubbles. You can use the legend toggling feature to
/// visualize only the shapes or bubbles which needs to be visualized.
/// * The "color mapping", to categorize the shapes and bubbles on a map by
/// customizing their color based on the underlying value. It is possible to set
/// the shape or bubble color for a specific value or for a range of values.
/// * The "tooltip", to display additional information about shapes and bubbles
/// using the customizable tooltip on a map.
/// * Along with this, the selection feature helps to highlight that area on a
/// map on interaction. You can use the callback for performing any action
/// during shape selection.
///
/// The actual geographical rendering is done here using the
/// [MapShapeLayer.source]. The source which contains the GeoJSON data can be
/// set as the .json file from an asset bundle, network or from [Uint8List] as
/// bytes.
///
/// The [MapShapeSource.shapeDataField] property is used to
/// refer the unique field name in the .json file to identify each shapes and
/// map with the respective data in the data source.
///
/// By default, the value specified for the
/// [MapShapeSource.shapeDataField] in the GeoJSON file will be used in
/// the elements like data labels, tooltip, and legend for their respective
/// shapes.
///
/// However, it is possible to keep a data source and customize these elements
/// based on the requirement. The value of the
/// [MapShapeSource.shapeDataField] will be used to map with the
/// respective data returned in [MapShapeSource.primaryValueMapper]
/// from the data source.
///
/// Once the above mapping is done, you can customize the elements using the
/// APIs like [MapShapeSource.dataLabelMapper],
/// [MapShapeSource.shapeColorMappers], etc.
///
/// ## Example
///
/// This snippet shows how to create the [SfMaps].
/// ```dart
///   @override
///  Widget build(BuildContext context) {
///    return Container(
///        child: const SfMaps(
///          layers: [
///            const MapShapeLayer(
///              source: MapShapeSource.asset(
///                  "assets/world_map.json",
///                  shapeDataField: "continent"),
///            )
///          ],
///        ));
///     }
/// ```
///
/// ## Tile layer
///
/// Tile layer which renders the tiles returned from the Web Map Tile
/// Services (WMTS) like OpenStreetMap, Bing Maps, Google Maps, TomTom etc.
///
/// The [urlTemplate] accepts the URL in WMTS format i.e. {z} — zoom level, {x}
/// and {y} — tile coordinates.
///
/// This URL might vary slightly depends on the providers. The formats can be,
/// https://exampleprovider/{z}/{x}/{y}.png,
/// https://exampleprovider/z={z}/x={x}/y={y}.png,
/// https://exampleprovider/z={z}/x={x}/y={y}.png?key=subscription_key, etc.
///
/// We will replace the {z}, {x}, {y} internally based on the
/// current center point and the zoom level.
///
/// The subscription key may be needed for some of the providers. Please include
/// them in the [urlTemplate] itself as mentioned in above example. Please note
/// that the format may vary between the each map provider. You can check the
/// exact URL format needed for the providers in their official websites.
///
/// Regarding the tile rendering, at the lowest zoom level (Level 0), the map is
/// 256 x 256 pixels and the whole world map renders as a single tile. At each
/// increase in level, the map width and height grow by a factor of 2 i.e. Level
/// 1 is 512 x 512 pixels with 4 tiles ((0, 0), (0, 1), (1, 0), (1, 1) where 0
/// and 1 are {x} and {y} in [MapTileLayer.urlTemplate]), Level 2 is 2048 x 2048
/// pixels with 8 tiles (from (0, 0) to (3, 3)), and so on.
/// (These details are just for your information and all these calculation are
/// done internally.)
///
/// However, based on the size of the [SfMaps] widget, [initialFocalLatLng] and
/// [initialZoomLevel], number of initial tiles needed in the view port alone
/// will be rendered. While zooming and panning, new tiles will be requested and
/// rendered on demand based on the current zoom level and focal point.
/// The current zoom level and focal point can be obtained from the
/// [MapZoomPanBehavior.zoomLevel] and [MapZoomPanBehavior.focalLatLng]
/// respectively. Once the particular tile is rendered, it will be stored in the
/// cache and it will be used from it for the next time for better performance.
///
/// Regarding the cache and clearing it, please check the APIs in
/// [imageCache](https://api.flutter.dev/flutter/painting/imageCache.html).
///
/// ```dart
///   @override
///   Widget build(BuildContext context) {
///     return SfMaps(
///       layers: [
///         MapTileLayer(
///           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
///           initialFocalLatLng: MapLatLng(-23.698042, 133.880753),
///           initialZoomLevel: 3
///         ),
///       ],
///     );
///   }
/// ```
/// See also:
/// * [MapShapeLayer], for enabling the features like data labels, tooltip,
/// bubbles, legends, selection etc.
/// * [MapShapeSource], for providing the data for the elements like data
/// labels, tooltip, bubbles, legends etc.
/// * For enabling zooming and panning, set [MapShapeLayer.zoomPanBehavior] or
/// [MapTileLayer.zoomPanBehavior] with the instance of [MapZoomPanBehavior].
class SfMaps extends StatefulWidget {
  /// Creates a [SfMaps].
  const SfMaps({
    Key? key,
    required this.layers,
  }) : super(key: key);

  /// The collection of map shape layer in which geographical rendering is done.
  ///
  /// The snippet below shows how to render the basic world map using the data
  /// from .json file.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [MapShapeLayer.source], to provide data for the elements of the
  /// [SfMaps] like data labels, bubbles, tooltip, shape colors, and legend.
  final List<MapLayer> layers;

  @override
  _SfMapsState createState() => _SfMapsState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (layers.isNotEmpty) {
      final _DebugLayerTree pointerTreeNode = _DebugLayerTree(layers);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
  }
}

class _SfMapsState extends State<SfMaps> {
  @override
  Widget build(BuildContext context) {
    assert(widget.layers.isNotEmpty);
    return _MapsRenderObjectWidget(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[widget.layers.last],
      ),
    );
  }
}

class _MapsRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _MapsRenderObjectWidget({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  _RenderMaps createRenderObject(BuildContext context) {
    return _RenderMaps();
  }
}

class _RenderMaps extends RenderProxyBox {
  @override
  void performLayout() {
    final double width =
        constraints.hasBoundedWidth ? constraints.maxWidth : 300;
    final double height =
        constraints.hasBoundedHeight ? constraints.maxHeight : 300;
    if (child != null) {
      child!.layout(BoxConstraints.loose(Size(width, height)),
          parentUsesSize: true);
      size = child!.size;
    }
  }
}

class _DebugLayerTree extends DiagnosticableTree {
  _DebugLayerTree(this.layers);

  final List<MapLayer> layers;

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    if (layers.isNotEmpty) {
      return layers.map<DiagnosticsNode>((MapLayer layer) {
        return layer.toDiagnosticsNode();
      }).toList();
    }
    return super.debugDescribeChildren();
  }

  @override
  String toStringShort() {
    return layers.length > 1
        ? 'contains ${layers.length} layers'
        : 'contains ${layers.length} layer';
  }
}
