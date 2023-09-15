/// Syncfusion Flutter Maps package is a data visualization library for creating
/// beautiful, interactive, and customizable maps from shape files or WMTS
/// services to visualize the geographical area.
///
/// To use, import `package:syncfusion_flutter_maps/maps.dart`.
///
/// See also:
/// * [Syncfusion Flutter Maps product page](https://www.syncfusion.com/flutter-widgets/flutter-maps)
/// * [User guide documentation](https://help.syncfusion.com/flutter/maps/overview)
/// * [Knowledge base](https://www.syncfusion.com/kb/flutter/sfmaps)
library maps;

import 'dart:convert';

import 'package:flutter/foundation.dart'
    show DiagnosticableTree, ObjectFlagProperty;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';

import 'src/common.dart';
import 'src/controller/map_controller.dart';
import 'src/elements/legend.dart';
import 'src/layer/layer_base.dart';
import 'src/layer/shape_layer.dart';
import 'src/layer/tile_layer.dart';
import 'src/layer/zoomable.dart';
import 'src/settings.dart';
import 'src/utils.dart';

export 'maps.dart' hide BehaviorView, BehaviorViewRenderObjectWidget;
export 'src/controller/layer_controller.dart';
export 'src/elements/legend.dart' hide Legend;
export 'src/elements/marker.dart' hide MarkerContainer;
export 'src/enum.dart';
export 'src/layer/layer_base.dart';
export 'src/layer/shape_layer.dart' hide GeoJSONLayer;
export 'src/layer/tile_layer.dart' hide TileLayer;
export 'src/layer/vector_layers.dart' hide MapVectorLayer;
export 'src/settings.dart';

/// Returns the URL template in the required format for the Bing Maps.
///
/// For Bing Maps, an additional step is required. The format of the required
/// URL varies from the other tile services. Hence, we have added this top-level
/// function which returns the URL in the required format.
///
/// You can use the URL template returned from this function to set it to the
/// [MapTileLayer.urlTemplate] property.
///
/// ```dart
///  MapZoomPanBehavior _zoomPanBehavior;
///
///   @override
///   void initState() {
///     _zoomPanBehavior = MapZoomPanBehavior();
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return FutureBuilder(
///         future: getBingUrlTemplate(
///             'http://dev.virtualearth.net/REST/V1/Imagery/Metadata/Road
///             OnDemand?output=json&include=ImageryProviders&key=YOUR_KEY'),
///         builder: (context, snapshot) {
///           if (snapshot.hasData) {
///             return SfMaps(
///               layers: [
///                 MapTileLayer(
///                   initialFocalLatLng: MapLatLng(20.5937, 78.9629),
///                   zoomPanBehavior: _zoomPanBehavior,
///                   initialZoomLevel: 3,
///                   urlTemplate: snapshot.data,
///                 ),
///               ],
///             );
///           }
///           return CircularProgressIndicator();
///         });
///   }
/// ```
Future<String?> getBingUrlTemplate(String url) async {
  final http.Response response = await _fetchResponse(url);
  assert(response.statusCode == 200, 'Invalid key');
  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedJson =
        // ignore: avoid_as
        json.decode(response.body) as Map<String, dynamic>;
    late String imageUrl;
    late String imageUrlSubDomains;
    if (decodedJson['authenticationResultCode'] == 'ValidCredentials') {
      for (final String key in decodedJson.keys) {
        if (key == 'resourceSets') {
          // ignore: avoid_as
          final List<dynamic> resourceSets = decodedJson[key] as List<dynamic>;
          for (final dynamic key in resourceSets[0].keys) {
            if (key == 'resources') {
              final List<dynamic> resources =
                  // ignore: avoid_as
                  resourceSets[0][key] as List<dynamic>;
              final Map<String, dynamic> resourcesMap =
                  // ignore: avoid_as
                  resources[0] as Map<String, dynamic>;
              imageUrl = resourcesMap['imageUrl'].toString();
              final List<dynamic> subDomains =
                  // ignore: avoid_as
                  resourcesMap['imageUrlSubdomains'] as List<dynamic>;
              imageUrlSubDomains = subDomains[0].toString();
              break;
            }
          }
          break;
        }
      }

      final List<String> splitUrl = imageUrl.split('{subdomain}');
      return splitUrl[0] + imageUrlSubDomains + splitUrl[1];
    }
  }
  return null;
}

Future<http.Response> _fetchResponse(String url) {
  return http.get(Uri.tryParse(url)!);
}

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
/// @override
/// Widget build(BuildContext context) {
///   return const SfMaps(
///     layers: [
///       MapShapeLayer(
///         source: MapShapeSource.asset(
///             "assets/world_map.json",
///             shapeDataField: "continent",
///         ),
///       )
///     ],
///   );
/// }
/// ```
///
/// ## Tile layer
///
/// Tile layer which renders the tiles returned from the Web Map Tile
/// Services (WMTS) like OpenStreetMap, Bing Maps, Google Maps, TomTom etc.
///
/// The [MapTileLayer.urlTemplate] accepts the URL in WMTS format i.e.
/// {z} — zoom level, {x} and {y} — tile coordinates.
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
/// them in the [MapTileLayer.urlTemplate] itself as mentioned in above example.
/// Please note that the format may vary between the each map provider. You can
/// check the exact URL format needed for the providers in their official
/// websites.
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
/// However, based on the size of the [SfMaps] widget,
/// [MapTileLayer.initialFocalLatLng] and [MapTileLayer.initialZoomLevel],
/// number of initial tiles needed in the view port alone will be rendered.
/// While zooming and panning, new tiles will be requested and rendered on
/// demand based on the current zoom level and focal point. The current zoom
/// level and focal point can be obtained from the
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
/// * For enabling zooming and panning, set [MapLayer.zoomPanBehavior] with the
/// instance of [MapZoomPanBehavior].
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
  State<SfMaps> createState() => _SfMapsState();

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
        children: _buildLayers(widget.layers),
      ),
    );
  }

  /// Returns all layers if everything is the same type of [MapTileLayer].
  /// Otherwise, returns the last layer.
  List<MapLayer> _buildLayers(List<MapLayer> layers) {
    if (layers.length > 1) {
      final bool loadMultiTileLayer =
          layers.every((MapLayer layer) => layer is MapTileLayer);
      return loadMultiTileLayer ? layers : <MapLayer>[layers.last];
    } else {
      return layers;
    }
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

/// The shape sublayer for tile and shape layer.
///
/// This sublayer can be added as a sublayer of both [MapShapeLayer] and
/// [MapTileLayer].
///
/// The actual geographical rendering is done here using the
/// [MapShapeSublayer.source]. The source can be set as the .json file from an
/// asset bundle, network or from [Uint8List] as bytes.
///
/// The [MapShapeSource.shapeDataField] property is used to
/// refer the unique field name in the .json file to identify each shapes and
/// map with the respective data in the data source.
///
/// By default, the value specified for the
/// [MapShapeSource.shapeDataField] in the GeoJSON source will be used in
/// the elements like data labels, and tooltip for their respective
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
/// The snippet below shows how to render the basic world map using the data
/// from .json file.
///
/// ```dart
/// late MapShapeSource _mapSource;
/// late MapShapeSource _mapSublayerSource;
///
/// @override
/// void initState() {
///    _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "name",
///   );
///
///    _mapSublayerSource = MapShapeSource.asset(
///      "assets/africa.json",
///      shapeDataField: "name",
///   );
///
///    super.initState();
/// }
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: _mapSource,
///          sublayers:[
///             MapShapeSublayer(
///               source: _mapSublayerSource,
///               color: Colors.red,
///             ),
///          ]
///        )
///      ],
///    );
///  }
/// ```
/// See also:
/// * [source], to provide data for the elements of this layer like data
/// labels, bubbles, tooltip, and shape colors.
class MapShapeSublayer extends MapSublayer {
  /// Creates a [MapShapeSublayer].
  const MapShapeSublayer({
    Key? key,
    required this.source,
    this.controller,
    this.initialMarkersCount = 0,
    this.markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    this.markerTooltipBuilder,
    this.selectedIndex = -1,
    this.onSelectionChanged,
    this.showDataLabels = false,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.dataLabelSettings = const MapDataLabelSettings(),
    this.bubbleSettings = const MapBubbleSettings(),
    this.selectionSettings = const MapSelectionSettings(),
  }) : super(key: key);

  /// The source that maps the data source with the shape file and provides
  /// data for the elements of the this layer like data labels, bubbles,
  /// tooltip, and shape colors.
  ///
  /// The source can be set as the .json file from an asset bundle, network
  /// or from [Uint8List] as bytes.
  ///
  /// The [MapShapeSource.shapeDataField] property is used to
  /// refer the unique field name in the .json file to identify each shapes and
  /// map with the respective data in the data source.
  ///
  /// By default, the value specified for the [MapShapeSource.shapeDataField]
  /// in the GeoJSON file will be used in the elements like data labels,
  /// tooltip, and legend for their respective shapes.
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
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late MapShapeSource _mapSublayerSource;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///   );
  ///
  ///   _mapSublayerSource = MapShapeSource.asset(
  ///      "assets/africa.json",
  ///      shapeDataField: "name",
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          sublayers:[
  ///             MapShapeSublayer(
  ///               source: _mapSublayerSource,
  ///               color: Colors.red,
  ///             ),
  ///          ]
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [MapShapeSource.primaryValueMapper], to map the data of the data
  /// source collection with the respective
  /// [MapShapeSource.shapeDataField] in .json file.
  /// * [MapShapeSource.bubbleSizeMapper], to customize the bubble size.
  /// * [MapShapeSource.dataLabelMapper], to customize the data label's text.
  /// * [MapShapeSource.shapeColorValueMapper] and
  /// [MapShapeSource.shapeColorMappers], to customize the shape colors.
  /// * [MapShapeSource.bubbleColorValueMapper] and
  /// [MapShapeSource.bubbleColorMappers], to customize the bubble colors.
  final MapShapeSource source;

  /// Option to set markers count initially. It cannot be updated dynamically.
  ///
  /// The [MapLayer.markerBuilder] callback will be called number of times equal
  /// to the value specified in the [MapLayer.initialMarkersCount] property.
  /// The default value of the of this property is null.
  final int initialMarkersCount;

  /// Returns the [MapMarker] for the given index. Markers which be used to
  /// denote the locations on the map.
  ///
  /// It is possible to use the built-in symbols or display a custom widget at
  /// a specific latitude and longitude on a map.
  ///
  /// The [MapLayer.markerBuilder] callback will be called number of times equal
  /// to the value specified in the [MapLayer.initialMarkersCount] property.
  /// The default value of the of this property is null.
  ///
  /// For rendering the custom widget for the marker, pass the required widget
  /// for child in [MapMarker] constructor.
  final MapMarkerBuilder? markerBuilder;

  /// Returns a widget for the shape tooltip based on the index.
  ///
  /// A shape tooltip displays additional information about the shapes on a map.
  /// To show tooltip for the shape, return a widget in
  /// [MapShapeSublayer.shapeTooltipBuilder]. This widget will then be wrapped
  /// in the existing tooltip shape which comes with the nose at the bottom.
  ///
  /// It is possible to customize the stroke appearance using the
  /// [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth].
  /// To customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The [MapShapeSublayer.shapeTooltipBuilder] callback will be called when
  /// the user interacts with the shapes i.e., while tapping in touch devices
  /// and hovering in the mouse enabled devices.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late MapShapeSource _mapSublayerSource;
  /// late List<DataModel> _data;
  /// late MapZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _data = <DataModel>[
  ///     DataModel('Orissa', 280, "Low", Colors.red),
  ///     DataModel('Karnataka', 190, "High", Colors.green),
  ///     DataModel('Tamil Nadu', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///       shapeDataField: "continent");
  ///
  ///   _mapSublayerSource = MapShapeSource.asset("assets/india.json",
  ///       shapeDataField: "name",
  ///       dataCount: _data.length,
  ///       primaryValueMapper: (int index) => _data[index].country,
  ///       shapeColorValueMapper: (int index) => _data[index].color);
  ///
  ///   _zoomPanBehavior = MapZoomPanBehavior(
  ///       zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Padding(
  ///       padding: EdgeInsets.all(15),
  ///       child: SfMaps(
  ///         layers: <MapLayer>[
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapShapeSublayer(
  ///                 source: _mapSublayerSource,
  ///                 shapeTooltipBuilder: (BuildContext context, int index) {
  ///                   if (index == 0) {
  ///                     return Container(
  ///                       child: Icon(Icons.airplanemode_inactive),
  ///                     );
  ///                   } else {
  ///                     return Container(
  ///                       child: Icon(Icons.airplanemode_active),
  ///                     );
  ///                   }
  ///                 },
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(
  ///     this.country,
  ///     this.usersCount,
  ///     this.storage,
  ///     this.color,
  ///   );
  ///
  ///   final String country;
  ///   final double usersCount;
  ///   final String storage;
  ///   final Color color;
  /// }
  /// ```
  final IndexedWidgetBuilder? shapeTooltipBuilder;

  /// Returns a widget for the bubble tooltip based on the index.
  ///
  /// A bubble tooltip displays additional information about the bubble
  /// on a map. To show tooltip for the bubble, return a widget in
  /// [MapShapeSublayer.bubbleTooltipBuilder]. This widget will then be wrapped
  /// in the existing tooltip shape which comes with the nose at the bottom.
  ///
  /// It is possible to customize the stroke appearance using the
  /// [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth].
  /// To customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The [MapShapeSublayer.bubbleTooltipBuilder] callback will be called when
  /// the user interacts with the bubbles i.e., while tapping in touch devices
  /// and hovering in the mouse enabled devices.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late MapShapeSource _mapSublayerSource;
  /// late List<DataModel> _data;
  /// late MapZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _data = <DataModel>[
  ///     DataModel('Orissa', 280, "Low", Colors.red),
  ///     DataModel('Karnataka', 190, "High", Colors.green),
  ///     DataModel('Tamil Nadu', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///       shapeDataField: "continent");
  ///
  ///   _mapSublayerSource = MapShapeSource.asset("assets/india.json",
  ///       shapeDataField: "name",
  ///       dataCount: _data.length,
  ///       primaryValueMapper: (int index) => _data[index].country,
  ///       bubbleColorValueMapper: (int index) {
  ///         return _data[index].color;
  ///       },
  ///       bubbleSizeMapper: (int index) {
  ///         return _data[index].usersCount;
  ///       });
  ///
  ///   _zoomPanBehavior = MapZoomPanBehavior(
  ///       zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Padding(
  ///       padding: EdgeInsets.all(15),
  ///       child: SfMaps(
  ///         layers: <MapLayer>[
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapShapeSublayer(
  ///                source: _mapSublayerSource,
  ///                bubbleTooltipBuilder: (BuildContext context, int index) {
  ///                   if (index == 0) {
  ///                     return Container(
  ///                       child: Icon(Icons.airplanemode_inactive),
  ///                     );
  ///                   } else {
  ///                     return Container(
  ///                       child: Icon(Icons.airplanemode_active),
  ///                     );
  ///                   }
  ///                 },
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(
  ///     this.country,
  ///     this.usersCount,
  ///     this.storage,
  ///     this.color,
  ///   );
  ///
  ///   final String country;
  ///   final double usersCount;
  ///   final String storage;
  ///   final Color color;
  /// }
  /// ```
  final IndexedWidgetBuilder? bubbleTooltipBuilder;

  /// Returns the widget for the tooltip of the [MapMarker].
  ///
  /// To show the tooltip for markers, return a customized widget in this.
  /// This widget will then be wrapped in the in-built shape which comes with
  /// the nose at the bottom.
  ///
  /// This will be called when the user interacts with the markers i.e.,
  /// while tapping in touch devices and hovering in the mouse enabled devices.
  ///
  /// See also:
  /// * [MapLayer.tooltipSettings], to customize the color and stroke of the
  /// tooltip.
  /// * [SfMapsThemeData.tooltipBorderRadius], to customize the corners of the
  /// tooltip.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late MapShapeSource _mapSublayerSource;
  /// late List<MapLatLng> _data;
  /// late MapZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _data = <MapLatLng>[
  ///     MapLatLng(11.1271, 78.6569),
  ///     MapLatLng(15.3173, 75.7139),
  ///     MapLatLng(28.7041, 77.1025)
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///       shapeDataField: "continent");
  ///
  ///   _mapSublayerSource = MapShapeSource.asset(
  ///     "assets/india.json",
  ///     shapeDataField: "name",
  ///   );
  ///
  ///   _zoomPanBehavior = MapZoomPanBehavior(
  ///       zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Padding(
  ///       padding: EdgeInsets.all(15),
  ///       child: SfMaps(
  ///         layers: <MapLayer>[
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///             sublayers: [
  ///               MapShapeSublayer(
  ///                 source: _mapSublayerSource,
  ///                 initialMarkersCount: 3,
  ///                 markerBuilder: (BuildContext context, int index) {
  ///                   return MapMarker(
  ///                     latitude: _data[index].latitude,
  ///                     longitude: _data[index].longitude,
  ///                   );
  ///                },
  ///                markerTooltipBuilder: (BuildContext context, int index) {
  ///                   if(index == 0) {
  ///                     return Container(
  ///                       child: Icon(Icons.airplanemode_inactive),
  ///                     );
  ///                   }
  ///                   else
  ///                   {
  ///                     return Container(
  ///                      child: Icon(Icons.airplanemode_active),
  ///                     );
  ///                    }
  ///                 },
  ///               ),
  ///             ],
  ///           ),
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(
  ///    this.country,
  ///    this.usersCount,
  ///    this.storage,
  ///    this.color,
  ///   );
  ///
  ///   final String country;
  ///   final double usersCount;
  ///   final String storage;
  ///   final Color color;
  /// }
  /// ```
  final IndexedWidgetBuilder? markerTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count from this.
  final MapShapeLayerController? controller;

  /// Shows or hides the data labels in the sublayer.
  ///
  /// Defaults to `false`.
  final bool showDataLabels;

  /// Color which is used to paint the sublayer shapes.
  final Color? color;

  /// Color which is used to paint the stroke of the sublayer shapes.
  final Color? strokeColor;

  /// Sets the stroke width of the sublayer shapes.
  final double? strokeWidth;

  /// Customizes the appearance of the data labels.
  final MapDataLabelSettings dataLabelSettings;

  /// Customizes the appearance of the bubbles.
  final MapBubbleSettings bubbleSettings;

  /// Customizes the appearance of the selected shape.
  final MapSelectionSettings selectionSettings;

  /// Selects the shape in the given index.
  ///
  /// The map passes the selected index to the [onSelectionChanged] callback but
  /// does not actually change this value until the parent widget rebuilds the
  /// maps with the new value.
  ///
  /// To unselect a shape, set -1 to the [MapShapeSublayer.selectedIndex].
  ///
  /// Must not be null. Defaults to -1.
  ///
  /// See also:
  /// * [MapSelectionSettings], to customize the selected shape's appearance.
  /// * [MapShapeSublayer.onSelectionChanged], for getting the current tapped
  /// shape index.
  final int selectedIndex;

  /// Called when the user tapped or clicked on a shape.
  ///
  /// The map passes the selected index to the [onSelectionChanged] callback but
  /// does not actually change this value until the parent widget rebuilds the
  /// maps with the new value.
  final ValueChanged<int>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return GeoJSONLayer(
      source: source,
      controller: controller,
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      shapeTooltipBuilder: shapeTooltipBuilder,
      bubbleTooltipBuilder: bubbleTooltipBuilder,
      markerTooltipBuilder: markerTooltipBuilder,
      showDataLabels: showDataLabels,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      dataLabelSettings: dataLabelSettings,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      tooltipSettings: const MapTooltipSettings(),
      selectedIndex: selectedIndex,
      onSelectionChanged: onSelectionChanged,
      sublayerAncestor: this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(source.toDiagnosticsNode(name: 'source'));
    if (controller != null) {
      properties.add(IntProperty('markersCount', controller!.markersCount));
    } else {
      properties.add(IntProperty('markersCount', initialMarkersCount));
    }

    properties.add(ObjectFlagProperty<MapMarkerBuilder>.has(
        'markerBuilder', markerBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'shapeTooltip', shapeTooltipBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'bubbleTooltip', bubbleTooltipBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'markerTooltip', markerTooltipBuilder));
    properties.add(FlagProperty('showDataLabels',
        value: showDataLabels,
        ifTrue: 'Data labels are showing',
        ifFalse: 'Data labels are not showing'));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties
        .add(dataLabelSettings.toDiagnosticsNode(name: 'dataLabelSettings'));
    properties.add(bubbleSettings.toDiagnosticsNode(name: 'bubbleSettings'));
    properties
        .add(selectionSettings.toDiagnosticsNode(name: 'selectionSettings'));
  }
}

/// The shape layer in which geographical rendering is done.
///
/// The actual geographical rendering is done here using the
/// [MapShapeLayer.source]. The source can be set as the .json file from an
/// asset bundle, network or from [Uint8List] as bytes.
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
/// The snippet below shows how to render the basic world map using the data
/// from .json file.
///
/// ```dart
/// late MapShapeSource _mapSource;
///
/// @override
/// void initState() {
///   _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "name",
///   );
///
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return SfMaps(
///     layers: [
///       MapShapeLayer(
///         source: _mapSource,
///       )
///     ],
///   );
/// }
/// ```
/// See also:
/// * [source], to provide data for the elements of the [SfMaps] like data
/// labels, bubbles, tooltip, shape colors, and legend.
class MapShapeLayer extends MapLayer {
  /// Creates a [MapShapeLayer].
  const MapShapeLayer({
    Key? key,
    required this.source,
    this.loadingBuilder,
    this.controller,
    MapLatLngBounds? initialLatLngBounds,
    List<MapSublayer>? sublayers,
    int initialMarkersCount = 0,
    MapMarkerBuilder? markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    IndexedWidgetBuilder? markerTooltipBuilder,
    this.showDataLabels = false,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.legend,
    this.dataLabelSettings = const MapDataLabelSettings(),
    this.bubbleSettings = const MapBubbleSettings(),
    this.selectionSettings = const MapSelectionSettings(),
    MapTooltipSettings tooltipSettings = const MapTooltipSettings(),
    this.selectedIndex = -1,
    MapZoomPanBehavior? zoomPanBehavior,
    this.onSelectionChanged,
    WillZoomCallback? onWillZoom,
    WillPanCallback? onWillPan,
  }) : super(
          key: key,
          initialLatLngBounds: initialLatLngBounds,
          sublayers: sublayers,
          initialMarkersCount: initialMarkersCount,
          markerBuilder: markerBuilder,
          markerTooltipBuilder: markerTooltipBuilder,
          tooltipSettings: tooltipSettings,
          zoomPanBehavior: zoomPanBehavior,
          onWillZoom: onWillZoom,
          onWillPan: onWillPan,
        );

  /// The source that maps the data source with the shape file and provides
  /// data for the elements of the this layer like data labels, bubbles,
  /// tooltip, and shape colors.
  ///
  /// The source can be set as the .json file from an asset bundle, network
  /// or from [Uint8List] as bytes.
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
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<Model> _data;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     dataLabelMapper: (int index) {
  ///       return _data[index].country;
  ///     }
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: _mapSource,
  ///            showDataLabels: true,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.usersCount, this.storage, this.color);
  ///
  ///  final String country;
  ///  final double usersCount;
  ///  final String storage;
  ///  final Color  color;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeSource.primaryValueMapper], to map the data of the data
  /// source collection with the respective
  /// [MapShapeSource.shapeDataField] in .json file.
  /// * [MapShapeSource.bubbleSizeMapper], to customize the bubble size.
  /// * [MapShapeSource.dataLabelMapper], to customize the
  /// data label's text.
  /// * [MapShapeSource.shapeColorValueMapper] and
  /// [MapShapeSource.shapeColorMappers], to customize the shape colors.
  /// * [MapShapeSource.bubbleColorValueMapper] and
  /// [MapShapeSource.bubbleColorMappers], to customize the
  /// bubble colors.
  final MapShapeSource source;

  /// A builder that specifies the widget to display to the user while the
  /// map is still loading.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "continent",
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              loadingBuilder: (BuildContext context) {
  ///                return Container(
  ///                  height: 25,
  ///                  width: 25,
  ///                  child: const CircularProgressIndicator(
  ///                    strokeWidth: 3,
  ///                  ),
  ///                );
  ///              },
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  /// ```
  final MapLoadingBuilder? loadingBuilder;

  /// Returns a widget for the shape tooltip based on the index.
  ///
  /// A shape tooltip displays additional information about
  /// the shapes on a map. To show tooltip for the shape return a widget in
  /// [MapShapeLayer.shapeTooltipBuilder]. This widget will
  /// then be wrapped in the existing tooltip shape which comes with the nose at
  /// the bottom. It is still possible to customize the stroke appearance using
  /// the [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth].
  ///
  /// To customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The will be called when the user interacts with the shapes i.e., while
  /// tapping in touch devices and hovering in the mouse enabled devices.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<Model> _data;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) => _data[index].country,
  ///     shapeColorValueMapper: (int index) => _data[index].color
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              shapeTooltipBuilder: (BuildContext context, int index) {
  ///                if(index == 0) {
  ///                  return Container(
  ///                    child: Icon(Icons.airplanemode_inactive),
  ///                  );
  ///                }
  ///                else
  ///                {
  ///                  return Container(
  ///                       child: Icon(Icons.airplanemode_active),
  ///                  );
  ///                }
  ///              },
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  ///
  /// class Model {
  ///  const Model(this.country, this.usersCount, this.storage, this.color);
  ///
  ///  final String country;
  ///  final double usersCount;
  ///  final String storage;
  ///  final Color  color;
  /// }
  /// ```
  final IndexedWidgetBuilder? shapeTooltipBuilder;

  /// Returns a widget for the bubble tooltip based on the index.
  ///
  /// A bubble tooltip displays additional information about the bubble on a
  /// map. To show tooltip for the bubble, return a widget in
  /// [MapShapeLayer.bubbleTooltipBuilder]. This widget will then be wrapped in
  /// the existing tooltip shape which comes with the nose at the bottom. It is
  /// still possible to customize the stroke appearance using the
  /// [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth].
  ///
  /// To customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The will be called when the user interacts with the bubbles i.e., while
  /// tapping in touch devices and hovering in the mouse enabled devices.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     bubbleColorValueMapper: (int index) {
  ///       return _data[index].color;
  ///     },
  ///     bubbleSizeMapper: (int index) {
  ///       return _data[index].usersCount;
  ///     }
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///         bubbleTooltipBuilder: (BuildContext context, int index) {
  ///           if(index == 0) {
  ///              return Container(
  ///                child: Icon(Icons.airplanemode_inactive),
  ///              );
  ///           }
  ///           else
  ///            {
  ///              return Container(
  ///                child: Icon(Icons.airplanemode_active),
  ///              );
  ///            }
  ///         },
  ///       )
  ///     ],
  ///   );
  /// }
  ///
  /// class Model {
  ///  const Model(this.country, this.usersCount, this.storage, this.color);
  ///
  ///  final String country;
  ///  final double usersCount;
  ///  final String storage;
  ///  final Color  color;
  /// }
  /// ```
  final IndexedWidgetBuilder? bubbleTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count and selected shape's index from
  /// this.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeLayerController _controller;
  /// late MapShapeSource _mapSource;
  ///
  /// Random _random = Random();
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///      Model(-14.235004, -51.92528),
  ///      Model(51.16569, 10.451526),
  ///      Model(-25.274398, 133.775136),
  ///      Model(20.593684, 78.96288),
  ///      Model(61.52401, 105.318756)
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///   );
  ///
  ///   _controller = MapShapeLayerController();
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: Container(
  ///         height: 350,
  ///         child: Padding(
  ///           padding: EdgeInsets.only(left: 15, right: 15),
  ///           child: Column(
  ///             children: [
  ///               SfMaps(
  ///                 layers: <MapLayer>[
  ///                   MapShapeLayer(
  ///                    source: _mapSource,
  ///                     initialMarkersCount: 5,
  ///                     markerBuilder: (BuildContext context, int index) {
  ///                       return MapMarker(
  ///                         latitude: _data[index].latitude,
  ///                         longitude: _data[index].longitude,
  ///                         child: Icon(Icons.add_location),
  ///                       );
  ///                     },
  ///                     controller: _controller,
  ///                   ),
  ///                 ],
  ///               ),
  ///               RaisedButton(
  ///                 child: Text('Add marker'),
  ///                 onPressed: () {
  ///                   _data.add(Model(
  ///                       -180 + _random.nextInt(360).toDouble(),
  ///                       -55 + _random.nextInt(139).toDouble()));
  ///                   _controller.insertMarker(5);
  ///                 },
  ///               ),
  ///             ],
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Model {
  ///  Model(this.latitude, this.longitude);
  ///
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  final MapShapeLayerController? controller;

  /// Shows or hides the data labels.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [MapDataLabelSettings], to customize the tooltip.
  /// * [MapShapeSource.dataLabelMapper], for customizing the
  /// data label's text.
  final bool showDataLabels;

  /// Color which is used to paint the shapes.
  final Color? color;

  /// Color which is used to paint the stroke of the shapes.
  final Color? strokeColor;

  /// Sets the stroke width of the shapes.
  final double? strokeWidth;

  /// Customizes the appearance of the data labels.
  final MapDataLabelSettings dataLabelSettings;

  /// Customizes the appearance of the bubbles.
  ///
  /// See also:
  /// * [MapShapeSource.bubbleSizeMapper], to show the bubbles.
  final MapBubbleSettings bubbleSettings;

  /// Shows legend for the bubbles or shapes.
  ///
  /// Information provided in the legend helps to identify the data rendered in
  /// the map shapes or bubbles.
  ///
  /// Defaults to `null`.
  ///
  /// By default, legend will not be shown.
  ///
  /// ## Legend for shape
  ///
  /// Set [MapLegend.source] to [MapElement.shape] to show legend for shapes.
  ///
  /// If [MapShapeSource.shapeColorMappers] is not null, then
  /// [MapColorMapper.color] and [MapColorMapper.text] will be used for the
  /// legend item's icon and the legend item's text respectively.
  ///
  /// If [MapShapeSource.shapeColorMappers] is null, the color returned
  /// in the [MapShapeSource.shapeColorValueMapper] will be applied to
  /// the legend item's icon and the legend item's text will be taken from the
  /// [MapShapeSource.shapeDataField].
  ///
  /// In a rare case, if both the [MapShapeSource.shapeColorMappers] and
  /// the [MapShapeSource.shapeColorValueMapper] properties are null,
  /// the legend item's text will be taken from the
  /// [MapShapeSource.shapeDataField] property and the legend item's
  /// icon will have the default color.
  ///
  /// ## Legend for bubbles
  ///
  /// Set [MapLegend.source] to [MapElement.bubble] to show legend for bubbles.
  ///
  /// If [MapShapeSource.bubbleColorMappers] is not null, then
  /// [MapColorMapper.color] and [MapColorMapper.text] will be used for the
  /// legend item's icon and the legend item's text respectively.
  ///
  /// If [MapShapeSource.bubbleColorMappers] is null, the color returned
  /// in the [MapShapeSource.bubbleColorValueMapper] will be applied to
  /// the legend item's icon and the legend item's text will be taken from the
  /// [MapShapeSource.shapeDataField].
  ///
  /// If both the [MapShapeSource.bubbleColorMappers] and
  /// the [MapShapeSource.bubbleColorValueMapper] properties are null,
  /// the legend item's text will be taken from the
  /// [MapShapeSource.shapeDataField] property and the legend item's
  /// icon will have the default color.
  ///
  /// See also:
  /// * [MapLegend.source], to enable legend for shape or bubbles.
  final MapLegend? legend;

  /// Customizes the appearance of the selected shape.
  ///
  /// See also:
  /// * [MapShapeLayer.selectedIndex], for selecting or unselecting a shape.
  /// * [MapShapeLayer.onSelectionChanged], passes the current tapped shape
  /// index.
  final MapSelectionSettings selectionSettings;

  /// Selects the shape in the given index.
  ///
  /// The map passes the selected index to the [onSelectionChanged] callback but
  /// does not actually change this value until the parent widget rebuilds the
  /// maps with the new value.
  ///
  /// To unselect a shape, set -1 to the [MapShapeLayer.selectedIndex].
  ///
  /// Must not be null. Defaults to -1.
  ///
  /// See also:
  /// * [MapSelectionSettings], to customize the selected shape's appearance.
  /// * [MapShapeLayer.onSelectionChanged], for getting the current tapped
  /// shape index.
  final int selectedIndex;

  /// Called when the user tapped or clicked on a shape.
  ///
  /// The map passes the selected index to the [onSelectionChanged] callback but
  /// does not actually change this value until the parent widget rebuilds the
  /// maps with the new value.
  ///
  /// This snippet shows how to use onSelectionChanged callback in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
  /// late int _selectedIndex = -1;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///
  ///   _data = <DataModel>[
  ///     DataModel('India', 280, "Low", Colors.red),
  ///     DataModel('United States of America', 190, "High", Colors.green),
  ///     DataModel('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) => _data[index].country,
  ///     shapeColorValueMapper: (int index) => _data[index].color,
  ///   );
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: Container(
  ///         height: 350,
  ///         child: Padding(
  ///           padding: EdgeInsets.only(left: 15, right: 15),
  ///           child: Column(
  ///             children: [
  ///               SfMaps(
  ///                 layers: <MapLayer>[
  ///                   MapShapeLayer(
  ///                     source: _mapSource,
  ///                     selectedIndex: _selectedIndex,
  ///                     selectionSettings: MapSelectionSettings(
  ///                       color: Colors.pink,
  ///                     ),
  ///                     onSelectionChanged: (int index) {
  ///                       setState(() {
  ///                         _selectedIndex = (_selectedIndex == index) ?
  ///                                -1 : index;
  ///                       });
  ///                     },
  ///                   ),
  ///                 ],
  ///               ),
  ///             ],
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(
  ///      this.country,
  ///      this.usersCount,
  ///      this.storage,
  ///      this.color,
  ///   );
  ///
  ///   final String country;
  ///   final double usersCount;
  ///   final String storage;
  ///   final Color color;
  /// }
  /// ```
  final ValueChanged<int>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return _ShapeLayer(
      source: source,
      loadingBuilder: loadingBuilder,
      controller: controller,
      initialLatLngBounds: initialLatLngBounds,
      sublayers: sublayers,
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      shapeTooltipBuilder: shapeTooltipBuilder,
      bubbleTooltipBuilder: bubbleTooltipBuilder,
      markerTooltipBuilder: markerTooltipBuilder,
      showDataLabels: showDataLabels,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      legend: legend,
      dataLabelSettings: dataLabelSettings,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      tooltipSettings: tooltipSettings,
      selectedIndex: selectedIndex,
      zoomPanBehavior: zoomPanBehavior,
      onSelectionChanged: onSelectionChanged,
      onWillZoom: onWillZoom,
      onWillPan: onWillPan,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(source.toDiagnosticsNode(name: 'source'));
    properties.add(ObjectFlagProperty<MapLoadingBuilder>.has(
        'loadingBuilder', loadingBuilder));
    if (initialLatLngBounds != null) {
      properties.add(DiagnosticsProperty<MapLatLngBounds>(
          'initialLatLngBounds', initialLatLngBounds));
    }
    if (controller != null) {
      properties.add(IntProperty('markersCount', controller!.markersCount));
    } else {
      properties.add(IntProperty('markersCount', initialMarkersCount));
    }
    if (sublayers != null && sublayers!.isNotEmpty) {
      final DebugSublayerTree pointerTreeNode = DebugSublayerTree(sublayers!);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    properties.add(ObjectFlagProperty<MapMarkerBuilder>.has(
        'markerBuilder', markerBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'shapeTooltip', shapeTooltipBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'bubbleTooltip', bubbleTooltipBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'markerTooltip', markerTooltipBuilder));
    properties.add(FlagProperty('showDataLabels',
        value: showDataLabels,
        ifTrue: 'Data labels are showing',
        ifFalse: 'Data labels are not showing'));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties
        .add(dataLabelSettings.toDiagnosticsNode(name: 'dataLabelSettings'));
    if (legend != null) {
      properties.add(legend!.toDiagnosticsNode(name: 'legend'));
    }
    properties.add(bubbleSettings.toDiagnosticsNode(name: 'bubbleSettings'));
    properties
        .add(selectionSettings.toDiagnosticsNode(name: 'selectionSettings'));
    properties.add(tooltipSettings.toDiagnosticsNode(name: 'tooltipSettings'));
    if (zoomPanBehavior != null) {
      properties
          .add(zoomPanBehavior!.toDiagnosticsNode(name: 'zoomPanBehavior'));
    }
    properties.add(
        ObjectFlagProperty<WillZoomCallback>.has('onWillZoom', onWillZoom));
    properties
        .add(ObjectFlagProperty<WillPanCallback>.has('onWillPan', onWillPan));
  }
}

class _ShapeLayer extends StatefulWidget {
  const _ShapeLayer({
    required this.source,
    required this.loadingBuilder,
    required this.controller,
    required this.initialLatLngBounds,
    required this.sublayers,
    required this.initialMarkersCount,
    required this.markerBuilder,
    required this.shapeTooltipBuilder,
    required this.bubbleTooltipBuilder,
    required this.markerTooltipBuilder,
    required this.showDataLabels,
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
    required this.legend,
    required this.dataLabelSettings,
    required this.bubbleSettings,
    required this.selectionSettings,
    required this.tooltipSettings,
    required this.selectedIndex,
    required this.zoomPanBehavior,
    required this.onSelectionChanged,
    required this.onWillZoom,
    required this.onWillPan,
  });

  final MapShapeSource source;
  final MapLoadingBuilder? loadingBuilder;
  final MapShapeLayerController? controller;
  final MapLatLngBounds? initialLatLngBounds;
  final List<MapSublayer>? sublayers;
  final int initialMarkersCount;
  final MapMarkerBuilder? markerBuilder;
  final IndexedWidgetBuilder? shapeTooltipBuilder;
  final IndexedWidgetBuilder? bubbleTooltipBuilder;
  final IndexedWidgetBuilder? markerTooltipBuilder;
  final bool showDataLabels;
  final Color? color;
  final Color? strokeColor;
  final double? strokeWidth;
  final MapDataLabelSettings dataLabelSettings;
  final MapLegend? legend;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapTooltipSettings tooltipSettings;
  final int selectedIndex;
  final MapZoomPanBehavior? zoomPanBehavior;
  final ValueChanged<int>? onSelectionChanged;
  final WillZoomCallback? onWillZoom;
  final WillPanCallback? onWillPan;

  @override
  _ShapeLayerState createState() => _ShapeLayerState();
}

class _ShapeLayerState extends State<_ShapeLayer> {
  late MapController _controller;

  @override
  void initState() {
    _controller = MapController()
      ..tooltipKey = GlobalKey()
      ..layerType = LayerType.shape;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MapLayerInheritedWidget(
      controller: _controller,
      sublayers: widget.sublayers,
      child: GeoJSONLayer(
        source: widget.source,
        loadingBuilder: widget.loadingBuilder,
        controller: widget.controller,
        initialLatLngBounds: widget.initialLatLngBounds,
        sublayers: widget.sublayers,
        initialMarkersCount: widget.initialMarkersCount,
        markerBuilder: widget.markerBuilder,
        shapeTooltipBuilder: widget.shapeTooltipBuilder,
        bubbleTooltipBuilder: widget.bubbleTooltipBuilder,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        showDataLabels: widget.showDataLabels,
        color: widget.color,
        strokeColor: widget.strokeColor,
        strokeWidth: widget.strokeWidth,
        legend: widget.legend,
        dataLabelSettings: widget.dataLabelSettings,
        bubbleSettings: widget.bubbleSettings,
        selectionSettings: widget.selectionSettings,
        tooltipSettings: widget.tooltipSettings,
        selectedIndex: widget.selectedIndex,
        zoomPanBehavior: widget.zoomPanBehavior,
        onSelectionChanged: widget.onSelectionChanged,
        onWillZoom: widget.onWillZoom,
        onWillPan: widget.onWillPan,
      ),
    );
  }
}

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
/// that the format may vary between the each map providers. You can check the
/// exact URL format needed for the providers in their official websites.
///
/// Regarding the tile rendering, at the lowest zoom level (Level 0), the map is
/// 256 x 256 pixels and the
/// whole world map renders as a single tile. At each increase in level, the map
/// width and height grow by a factor of 2 i.e. Level 1 is 512 x 512 pixels with
/// 4 tiles ((0, 0), (0, 1), (1, 0), (1, 1) where 0 and 1 are {x} and {y} in
/// [urlTemplate]), Level 2 is 2048 x 2048 pixels with 8
/// tiles (from (0, 0) to (3, 3)), and so on.
/// (These details are just for your information and all these calculation are
/// done internally.)
///
/// However, based on the size of the [SfMaps] widget, [initialFocalLatLng] and
/// [initialZoomLevel] number of initial tiles needed in the view port alone
/// will be rendered. While zooming and panning, new tiles will be requested and
/// rendered on demand based on the current zoom level and focal point.
/// The current zoom level and focal point can be obtained from the
/// [MapZoomPanBehavior.zoomLevel] and [MapZoomPanBehavior.focalLatLng]
/// respectively. Once the particular tile is rendered, it will be stored in the
/// cache and it will be used from it next time for better performance.
///
/// Regarding the cache and clearing it, please check the APIs in [imageCache].
///
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return SfMaps(
///     layers: [
///       MapTileLayer(
///         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
///         initialFocalLatLng: MapLatLng(-23.698042, 133.880753),
///         initialZoomLevel: 3
///       ),
///     ],
///   );
/// }
/// ```
///
/// See also:
/// * For enabling zooming and panning, set [zoomPanBehavior] with the instance
/// of [MapZoomPanBehavior].
class MapTileLayer extends MapLayer {
  /// Creates a [MapTileLayer].
  const MapTileLayer({
    Key? key,
    required this.urlTemplate,
    this.initialFocalLatLng = const MapLatLng(0.0, 0.0),
    this.initialZoomLevel = 1,
    MapLatLngBounds? initialLatLngBounds,
    this.controller,
    List<MapSublayer>? sublayers,
    int initialMarkersCount = 0,
    MapMarkerBuilder? markerBuilder,
    IndexedWidgetBuilder? markerTooltipBuilder,
    MapTooltipSettings tooltipSettings = const MapTooltipSettings(),
    MapZoomPanBehavior? zoomPanBehavior,
    WillZoomCallback? onWillZoom,
    WillPanCallback? onWillPan,
  })  : assert(initialZoomLevel >= 1 && initialZoomLevel <= 15),
        assert(initialMarkersCount == 0 ||
            initialMarkersCount != 0 && markerBuilder != null),
        super(
          key: key,
          initialLatLngBounds: initialLatLngBounds,
          sublayers: sublayers,
          initialMarkersCount: initialMarkersCount,
          markerBuilder: markerBuilder,
          markerTooltipBuilder: markerTooltipBuilder,
          tooltipSettings: tooltipSettings,
          zoomPanBehavior: zoomPanBehavior,
          onWillZoom: onWillZoom,
          onWillPan: onWillPan,
        );

  /// URL template to request the tiles from the providers.
  ///
  /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} — zoom level,
  /// {x} and {y} — tile coordinates.
  ///
  /// This URL might vary slightly depends on the providers. The formats can be,
  /// https://exampleprovider/{z}/{x}/{y}.png,
  /// https://exampleprovider/z={z}/x={x}/y={y}.png,
  /// https://exampleprovider/z={z}/x={x}/y={y}.png?key=subscription_key, etc.
  ///
  /// We will replace the {z}, {x}, {y} internally based on the
  /// current center point and the zoom level.
  ///
  /// The subscription key may be needed for some of the providers. Please
  /// include them in the [urlTemplate] itself as mentioned in above example.
  /// Please note that the format may vary between the each map provider. You
  /// can check the exact URL format needed for the providers in their official
  /// websites.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapTileLayer(
  ///         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  ///         initialFocalLatLng: MapLatLng(-23.698042, 133.880753),
  ///         initialZoomLevel: 3
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  /// For Bing Maps, an additional step is required. The format of the required
  /// URL varies from the other tile services. Hence, we have added a top-level
  /// [getBingUrlTemplate] function which returns the URL in the required
  /// format. You can use the URL returned from this function to set it to the
  /// [urlTemplate] property.
  ///
  /// ```dart
  /// late MapZoomPanBehavior _zoomPanBehavior;
  ///
  /// @override
  /// void initState() {
  ///   _zoomPanBehavior = MapZoomPanBehavior();
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return FutureBuilder(
  ///       future: getBingUrlTemplate(
  ///           'http://dev.virtualearth.net/REST/V1/Imagery/Metadata/Road
  ///           OnDemand?output=json&include=ImageryProviders&key=YOUR_KEY'),
  ///       builder: (context, snapshot) {
  ///         if (snapshot.hasData) {
  ///           return SfMaps(
  ///             layers: [
  ///               MapTileLayer(
  ///                 initialFocalLatLng: MapLatLng(20.5937, 78.9629),
  ///                 zoomPanBehavior: _zoomPanBehavior,
  ///                 initialZoomLevel: 3,
  ///                 urlTemplate: snapshot.data,
  ///               ),
  ///             ],
  ///           );
  ///         }
  ///         return CircularProgressIndicator();
  ///       });
  /// }
  /// ```
  ///
  /// Some of the providers provide different map types. For example, Bing Maps
  /// provide map types like Road, Aerial, AerialWithLabels etc. These types too
  /// can be passed in the [urlTemplate] itself as shown in the above example.
  /// You can check the official websites of the tile providers to know about
  /// the available types and the code for it.
  ///
  /// See also:
  /// * For Bing Maps, use the [getBingUrlTemplate] method to get the URL in
  /// required format and set it to the [urlTemplate].
  final String urlTemplate;

  /// Represents the initial focal latitude and longitude position.
  ///
  /// Based on the size of the [SfMaps] widget, [initialFocalLatLng] and
  /// [initialZoomLevel], number of initial tiles needed in the view port alone
  /// will be rendered. While zooming and panning, new tiles will be requested
  /// and rendered on demand based on the current zoom level and focal point.
  /// The current zoom level and focal point can be obtained from the
  /// [MapZoomPanBehavior.zoomLevel] and [MapZoomPanBehavior.focalLatLng].
  ///
  /// This property cannot be changed dynamically.
  ///
  /// Defaults to `MapLatLng(0.0, 0.0)`.
  ///
  /// See also:
  /// * For enabling zooming and panning, set [zoomPanBehavior] with the
  /// instance of [MapZoomPanBehavior].
  /// * [MapZoomPanBehavior.focalLatLng], to dynamically change the center
  /// position.
  /// * [MapZoomPanBehavior.zoomLevel], to dynamically change the zoom level.
  final MapLatLng initialFocalLatLng;

  /// Represents the initial zooming level.
  ///
  /// Based on the size of the [SfMaps] widget, [initialFocalLatLng] and
  /// [initialZoomLevel], number of initial tiles needed in the view port alone
  /// will be rendered. While zooming and panning, new tiles will be requested
  /// and rendered on demand based on the current zoom level and focal point.
  /// The current zoom level and focal point can be obtained from the
  /// [MapZoomPanBehavior.zoomLevel] and [MapZoomPanBehavior.focalLatLng].
  ///
  /// This property cannot be changed dynamically.
  ///
  /// Defaults to 1.
  ///
  /// See also:
  /// * For enabling zooming and panning, set [zoomPanBehavior] with the
  /// instance of [MapZoomPanBehavior].
  /// * [MapZoomPanBehavior.focalLatLng], to dynamically change the center
  /// position.
  /// * [MapZoomPanBehavior.zoomLevel], to dynamically change the zoom level.
  final int initialZoomLevel;

  /// Provides options for adding, removing, deleting, updating markers
  /// collection and converting pixel points to latitude and
  /// longitude.
  ///
  ///   ```dart
  /// late List<Model> data;
  /// late MapTileLayerController controller;
  /// late MapZoomPanBehavior _zoomPanBehavior;
  ///
  /// Random random = Random();
  ///
  /// @override
  /// void initState() {
  ///   data = <Model>[
  ///     Model(-14.235004, -51.92528),
  ///     Model(51.16569, 10.451526),
  ///     Model(-25.274398, 133.775136),
  ///     Model(20.593684, 78.96288),
  ///     Model(61.52401, 105.318756)
  ///   ];
  ///
  ///   controller = MapTileLayerController();
  ///   _zoomPanBehavior = MapZoomPanBehavior();
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return FutureBuilder(
  ///       future: getBingUrlTemplate(
  ///           'http://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOn
  ///           Demand?output=json&include=ImageryProviders&key=YOUR_KEY'),
  ///       builder: (context, snapshot) {
  ///         if (snapshot.hasData) {
  ///           return Column(
  ///             children: [
  ///               SfMaps(
  ///                 layers: [
  ///                   MapTileLayer(
  ///                     initialFocalLatLng: MapLatLng(20.5937, 78.9629),
  ///                     zoomPanBehavior: _zoomPanBehavior,
  ///                     initialZoomLevel: 3,
  ///                     urlTemplate: snapshot.data,
  ///                     initialMarkersCount: 5,
  ///                     markerBuilder: (BuildContext context, int index) {
  ///                      return MapMarker(
  ///                         latitude: data[index].latitude,
  ///                         longitude: data[index].longitude,
  ///                         child: Icon(Icons.add_location),
  ///                       );
  ///                     },
  ///                   ),
  ///                 ],
  ///               ),
  ///               RaisedButton(
  ///                 child: Text('Add marker'),
  ///                 onPressed: () {
  ///                   data.add(Model(-180 + random.nextInt(360).toDouble(),
  ///                       -55 + random.nextInt(139).toDouble()));
  ///                   controller.insertMarker(5);
  ///                 },
  ///               ),
  ///             ],
  ///           );
  ///         }
  ///         return CircularProgressIndicator();
  ///       },
  ///   );
  /// }
  /// ```
  final MapTileLayerController? controller;

  @override
  Widget build(BuildContext context) {
    final SfMaps? maps = context.findAncestorWidgetOfExactType<SfMaps>();
    final bool isTransparent = maps != null && maps.layers.indexOf(this) != 0;

    return _TileLayer(
      urlTemplate: urlTemplate,
      initialFocalLatLng: initialFocalLatLng,
      initialZoomLevel: initialZoomLevel,
      initialLatLngBounds: initialLatLngBounds,
      sublayers: sublayers,
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      markerTooltipBuilder: markerTooltipBuilder,
      tooltipSettings: tooltipSettings,
      zoomPanBehavior: zoomPanBehavior,
      controller: controller,
      onWillZoom: onWillZoom,
      onWillPan: onWillPan,
      isTransparent: isTransparent,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(StringProperty('urlTemplate', urlTemplate));
    properties.add(DiagnosticsProperty<MapLatLng>(
        'initialFocalLatLng', initialFocalLatLng));
    properties.add(IntProperty('initialZoomLevel', initialZoomLevel));
    if (initialLatLngBounds != null) {
      properties.add(DiagnosticsProperty<MapLatLngBounds>(
          'initialLatLngBounds', initialLatLngBounds));
    }
    if (sublayers != null && sublayers!.isNotEmpty) {
      final DebugSublayerTree pointerTreeNode = DebugSublayerTree(sublayers!);
      properties.add(pointerTreeNode.toDiagnosticsNode());
    }
    if (zoomPanBehavior != null) {
      properties
          .add(zoomPanBehavior!.toDiagnosticsNode(name: 'zoomPanBehavior'));
    }
    properties.add(ObjectFlagProperty<MapMarkerBuilder>.has(
        'markerBuilder', markerBuilder));
    if (controller != null) {
      properties.add(IntProperty('markersCount', controller!.markersCount));
    } else {
      properties.add(IntProperty('markersCount', initialMarkersCount));
    }
    properties.add(
        ObjectFlagProperty<WillZoomCallback>.has('onWillZoom', onWillZoom));
    properties
        .add(ObjectFlagProperty<WillPanCallback>.has('onWillPan', onWillPan));
  }
}

class _TileLayer extends StatefulWidget {
  const _TileLayer({
    required this.urlTemplate,
    required this.initialFocalLatLng,
    required this.initialZoomLevel,
    required this.initialLatLngBounds,
    required this.zoomPanBehavior,
    required this.sublayers,
    required this.initialMarkersCount,
    required this.markerBuilder,
    required this.markerTooltipBuilder,
    required this.tooltipSettings,
    required this.controller,
    required this.onWillZoom,
    required this.onWillPan,
    required this.isTransparent,
  });

  final String urlTemplate;
  final MapLatLng initialFocalLatLng;
  final int initialZoomLevel;
  final MapLatLngBounds? initialLatLngBounds;
  final MapZoomPanBehavior? zoomPanBehavior;
  final List<MapSublayer>? sublayers;
  final int initialMarkersCount;
  final MapMarkerBuilder? markerBuilder;
  final IndexedWidgetBuilder? markerTooltipBuilder;
  final MapTooltipSettings tooltipSettings;
  final MapTileLayerController? controller;
  final WillZoomCallback? onWillZoom;
  final WillPanCallback? onWillPan;
  final bool isTransparent;

  @override
  _TileLayerState createState() => _TileLayerState();
}

class _TileLayerState extends State<_TileLayer> {
  late MapController _controller;

  @override
  void initState() {
    _controller = MapController()
      ..tooltipKey = GlobalKey()
      ..layerType = LayerType.tile
      ..tileCurrentLevelDetails = TileZoomLevelDetails();
    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior!._zoomController == null) {
      widget.zoomPanBehavior!._zoomController = ZoomableController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MapLayerInheritedWidget(
      controller: _controller,
      zoomController: widget.zoomPanBehavior?._zoomController,
      sublayers: widget.sublayers,
      child: TileLayer(
        urlTemplate: widget.urlTemplate,
        initialFocalLatLng: widget.initialFocalLatLng,
        initialZoomLevel: widget.initialZoomLevel,
        initialLatLngBounds: widget.initialLatLngBounds,
        sublayers: widget.sublayers,
        initialMarkersCount: widget.initialMarkersCount,
        markerBuilder: widget.markerBuilder,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        tooltipSettings: widget.tooltipSettings,
        zoomPanBehavior: widget.zoomPanBehavior,
        controller: widget.controller,
        onWillZoom: widget.onWillZoom,
        onWillPan: widget.onWillPan,
        isTransparent: widget.isTransparent,
      ),
    );
  }
}

/// Base class of the map behaviors.
abstract class MapBehavior extends DiagnosticableTree {
  MapController? _controller;

  /// Render box of the internal widget which handles the [MapZoomPanBehavior].
  ///
  /// The size of this render box can be obtained from the size getter.
  /// This is only valid after the layout phase, and should therefore only be
  /// examined from paint callbacks or interaction event handlers.
  RenderBox get renderBox => _renderBox;
  late RenderBox _renderBox;

  /// Override this method to handle pointer events that hit this render box.
  @mustCallSuper
  void handleEvent(PointerEvent event) {
    _controller?.notifyListeners();
  }

  /// Paints this render box into the given context at the given offset.
  void paint(PaintingContext context, Offset offset) {
    // Implement paint.
  }
}

/// Enables zooming and panning in [MapShapeLayer] and [MapTileLayer].
///
/// Zooming and panning will start working when the new instance of
/// [MapZoomPanBehavior] is set to [MapShapeLayer.zoomPanBehavior] or
/// [MapTileLayer.zoomPanBehavior]. However, if you need to restrict pinch
/// zooming or double tap zooming or panning for any specific requirements,
/// you can set the [enablePinching], [enableDoubleTapZooming], and
/// [enablePanning] properties to false respectively.
///
/// The [focalLatLng] is the focal point of the map layer based on which zooming
/// happens.
///
/// The default [zoomLevel] value is 1 which will show the whole map in the
/// viewport for [MapShapeLayer] and the available bounds for the [MapTileLayer]
/// based on the [focalLatLng] (Please check the documentation of [MapTileLayer]
/// to know more details about how [zoomLevel] works in it).
///
/// You can also get the current zoom level and focal position of the
/// map layer using the [zoomLevel] and [focalLatLng] after the interaction.
///
/// The minimum and maximum zooming levels can be restricted using the
/// [minZoomLevel] and [maxZoomLevel] properties respectively. The default
/// values of [minZoomLevel] and [maxZoomLevel] are 0 and 15 respectively.
/// However, for [MapTileLayer], the [maxZoomLevel] may slightly vary depends
/// on the providers. Check the respective official website of the map
/// tile providers to know about the maximum zoom level it supports.
///
/// By default, there is a toolbar for the zooming operations for the web
/// platform. However, you can change its visibility using the
/// [MapZoomPanBehavior.showToolbar] property.
///
/// [MapZoomPanBehavior] objects are expected to be long-lived, not recreated
/// with each build.
///
/// The procedure and the behavior are similar for both the [MapShapeLayer]
/// and [MapTileLayer].
///
/// ```dart
/// late MapZoomPanBehavior _zoomPanBehavior;
/// late MapShapeSource _mapSource;
///
/// @override
/// void initState() {
///   _mapSource = MapShapeSource.asset(
///     'assets/world_map.json',
///     shapeDataField: 'continent',
///   );
///   _zoomPanBehavior = MapZoomPanBehavior()
///     ..zoomLevel = 4
///     ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
///     ..toolbarSettings = MapToolbarSettings();
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: Text('Zoom pan'),
///     ),
///     body: SfMaps(
///       layers: [
///         MapShapeLayer(
///           source: _mapSource,
///           zoomPanBehavior: _zoomPanBehavior,
///         ),
///       ],
///     ),
///   );
/// }
/// ```
class MapZoomPanBehavior extends MapBehavior {
  /// Creates a new [MapZoomPanBehavior].
  MapZoomPanBehavior({
    double zoomLevel = kDefaultMinZoomLevel,
    MapLatLng? focalLatLng,
    MapLatLngBounds? latLngBounds,
    double minZoomLevel = kDefaultMinZoomLevel,
    double maxZoomLevel = kDefaultMaxZoomLevel,
    bool enablePinching = true,
    bool enablePanning = true,
    bool enableDoubleTapZooming = false,
    bool enableMouseWheelZooming = false,
    bool showToolbar = true,
    MapToolbarSettings toolbarSettings = const MapToolbarSettings(),
  })  : _zoomLevel = zoomLevel.clamp(minZoomLevel, maxZoomLevel),
        _focalLatLng = focalLatLng,
        _latLngBounds = latLngBounds,
        _minZoomLevel = minZoomLevel,
        _maxZoomLevel = maxZoomLevel,
        _enablePinching = enablePinching,
        _enablePanning = enablePanning,
        _enableDoubleTapZooming = enableDoubleTapZooming,
        _enableMouseWheelZooming = enableMouseWheelZooming,
        _showToolbar = showToolbar,
        _toolbarSettings = toolbarSettings,
        _zoomController = ZoomableController();

  /// Current zoom level of the map layer.
  ///
  /// Defaults to 1.
  ///
  /// The default [zoomLevel] value is 1 which will show the whole map in the
  /// viewport for [MapShapeLayer] and the available bounds for the
  /// [MapTileLayer] based on the [focalLatLng] (Please check the documentation
  /// of [MapTileLayer] to know more details about how [zoomLevel] works in it).
  ///
  /// You can also get the current zoom level after interaction using the
  /// [zoomLevel] property.
  double get zoomLevel => _zoomLevel;
  double _zoomLevel;
  set zoomLevel(double value) {
    assert(value >= kDefaultMinZoomLevel);
    assert(value >= minZoomLevel && value <= maxZoomLevel);
    if (_zoomLevel == value || value < minZoomLevel || value > maxZoomLevel) {
      return;
    }

    _zoomLevel = value;
    if (_controller != null && _controller!.layerType == LayerType.shape) {
      _controller!.onZoomLevelChange(value);
      return;
    }

    if (_zoomController!.parentRect != null) {
      _zoomController!.zoomLevel = value;
      // Intimating the zoom controller to update the actual rect based on the
      // new zoom level. This gets works only when there is simultaneous
      // zoom pan property changes has been performed.
      _updateZoomControllerActualRect();
    }
    return;
  }

  /// The [focalLatLng] is the focal point of the map layer based on which
  /// zooming happens.
  ///
  /// The default [zoomLevel] value is 1 which will show the whole map in the
  /// viewport for [MapShapeLayer] and the available bounds for the
  /// [MapTileLayer] based on the [focalLatLng] (Please check the documentation
  /// of [MapTileLayer] to know more details about how [zoomLevel] works in it).
  MapLatLng? get focalLatLng => _focalLatLng;
  MapLatLng? _focalLatLng;
  set focalLatLng(MapLatLng? value) {
    if (_focalLatLng == value) {
      return;
    }

    _focalLatLng = value;
    if (_controller != null && _controller!.layerType == LayerType.shape) {
      _controller!.onPanChange(value);
      return;
    }

    if (_zoomController!.parentRect != null) {
      _updateZoomControllerActualRect();
    }
  }

  /// Specifies the current latlng bounds of the maps. The maps zoom level
  /// and focalLatLng get updated based on the given bounds.
  ///
  /// For dynamic changes, the bounds value get updated with an animation.If
  /// both [latLngBounds] and [MapTileLayer.initialLatLngBounds] or
  /// [MapShapeLayer.initialLatLngBounds] are given, considered [latLngBounds]
  /// values as load time value.
  MapLatLngBounds? get latLngBounds => _latLngBounds;
  MapLatLngBounds? _latLngBounds;
  set latLngBounds(MapLatLngBounds? value) {
    if (_latLngBounds == value) {
      return;
    }

    _latLngBounds = value;
    if (_controller != null) {
      zoomLevel = getZoomLevel(_latLngBounds!, _controller!.layerType!,
              renderBox.size, _controller!.shapeLayerSizeFactor / zoomLevel)
          .clamp(minZoomLevel, maxZoomLevel);
      focalLatLng = getFocalLatLng(_latLngBounds!);
    }
  }

  /// Minimum zoom level of the map layer.
  ///
  /// Defaults to 1.
  double get minZoomLevel => _minZoomLevel;
  double _minZoomLevel;
  set minZoomLevel(double value) {
    assert(value >= kDefaultMinZoomLevel);
    if (_minZoomLevel == value) {
      return;
    }
    _minZoomLevel = value;
    zoomLevel = _zoomLevel.clamp(_minZoomLevel, _maxZoomLevel);
  }

  /// Maximum zoom level of the map layer.
  ///
  /// Defaults to 15.
  ///
  /// However, for [MapTileLayer], the [maxZoomLevel] may slightly vary depends
  /// on the providers. Check the respective official website of the map
  /// tile providers to know about the maximum zoom level it supports.
  double get maxZoomLevel => _maxZoomLevel;
  double _maxZoomLevel;
  set maxZoomLevel(double value) {
    if (_maxZoomLevel == value) {
      return;
    }
    _maxZoomLevel = value;
    zoomLevel = _zoomLevel.clamp(_minZoomLevel, _maxZoomLevel);
  }

  /// Option to enable pinch zooming support.
  ///
  /// Defaults to `true`.
  ///
  /// For the web platform, track pad and mouse wheel zooming will be enabled
  /// based on this property.
  bool get enablePinching => _enablePinching;
  bool _enablePinching;
  set enablePinching(bool value) {
    if (_enablePinching == value) {
      return;
    }
    _enablePinching = value;
  }

  /// Enables panning across the map layer.
  ///
  /// Defaults to `true`.
  bool get enablePanning => _enablePanning;
  bool _enablePanning;
  set enablePanning(bool value) {
    if (_enablePanning == value) {
      return;
    }
    _enablePanning = value;
  }

  /// Enables double tap across the map layer.
  ///
  /// Defaults to `false`.
  bool get enableDoubleTapZooming => _enableDoubleTapZooming;
  bool _enableDoubleTapZooming;
  set enableDoubleTapZooming(bool value) {
    if (_enableDoubleTapZooming == value) {
      return;
    }
    _enableDoubleTapZooming = value;
  }

  /// Enables mouse wheel zooming in map
  ///
  /// Defaults to `false`.
  bool get enableMouseWheelZooming => _enableMouseWheelZooming;
  bool _enableMouseWheelZooming;
  set enableMouseWheelZooming(bool value) {
    if (_enableMouseWheelZooming == value) {
      return;
    }
    _enableMouseWheelZooming = value;
  }

  /// Shows zooming toolbar in the web platform.
  ///
  /// Defaults to `true` in web platform.
  ///
  /// However, you can use this property to change its visibility.
  bool get showToolbar => _showToolbar;
  bool _showToolbar;
  set showToolbar(bool value) {
    if (_showToolbar == value) {
      return;
    }
    _showToolbar = value;
  }

  /// Provides options for customizing the appearance of the toolbar
  /// in the web platform.
  MapToolbarSettings get toolbarSettings => _toolbarSettings;
  MapToolbarSettings _toolbarSettings;
  set toolbarSettings(MapToolbarSettings value) {
    if (_toolbarSettings == value) {
      return;
    }
    _toolbarSettings = value;
  }

  /// The controller which stores the actual zoomLevel and actual rect for the
  /// interaction or animation changes.
  ///
  /// It intimate its listeners, when changing the zoomLevel and actual rect
  /// values.
  ZoomableController? _zoomController;

  /// Called whenever zooming is happening.
  ///
  /// Subclasses can override this method to do any custom operations based on
  /// the details provided in the [MapZoomDetails]. When
  /// `super.onZooming(details)` is not called, zooming will not happen.
  ///
  /// [MapZoomDetails] contains following properties.
  ///  * [MapZoomDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current zooming operation completes i.e. current visible
  ///   bounds.
  ///  * [MapZoomDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current zoom completes. Hence, if the
  ///   `super.onZooming(details)` is not called, there will be no changes in
  ///   the UI.
  ///  * [MapZoomDetails.previousZoomLevel] - provides the zoom level
  ///   before the current zooming operation completes i.e. current zoom
  ///   level.
  ///  * [MapZoomDetails.newZoomLevel] - provides the new zoom level
  ///   when the current zoom completes. Hence, if the
  ///   `super.onZooming(details)` is not called, there will be no
  ///   changes in the UI.
  ///  * [MapZoomDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapZoomDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  void onZooming(MapZoomDetails details) {
    if (_controller != null) {
      _latLngBounds = details.newVisibleBounds;
      if (_controller!.layerType == LayerType.shape) {
        _controller!.notifyZoomingListeners(details);
        _controller!.notifyListeners();
      } else {
        _controller!
          ..isInInteractive = true
          ..gesture = Gesture.scale;
        zoomLevel = details.newZoomLevel!;
        focalLatLng = details.focalLatLng;
        _controller!.notifyListeners();
      }
    }
  }

  /// Called whenever panning is happening.
  ///
  /// Subclasses can override this method to do any custom operations based on
  /// the details provided in the [MapPanDetails]. When
  /// `super.onPanning(details)` is not called, panning will not happen.
  ///
  /// [MapPanDetails] contains following properties.
  ///  * [MapPanDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current panning operation completes i.e. current visible
  ///   bounds.
  ///  * [MapPanDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current pan completes. Hence, if the
  ///   `super.onPanning(details)` is not called, there will be no changes in
  ///   the UI.
  ///  * [MapPanDetails.zoomLevel] - provides the current zoom level.
  ///  * [MapPanDetails.delta] - The difference in pixels between touch start
  ///  and current touch position.
  ///  * [MapPanDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapPanDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  void onPanning(MapPanDetails details) {
    if (_controller != null) {
      _latLngBounds = details.newVisibleBounds;
      if (_controller!.layerType == LayerType.shape) {
        _controller!.notifyPanningListeners(details);
        _controller!.notifyListeners();
      } else {
        _controller!
          ..isInInteractive = true
          ..gesture = Gesture.pan
          ..localScale = 1.0
          ..panDistance += details.delta!;
        focalLatLng = details.focalLatLng;
        _controller!.notifyListeners();
      }
    }
  }

  /// When this method is called, the map will be reset to the
  /// [MapZoomPanBehavior.minZoomLevel].
  void reset() {
    if (_controller != null) {
      zoomLevel = minZoomLevel;
      if (_controller!.layerType == LayerType.shape) {
        _controller!.notifyListeners();
      }
    }
  }

  // Converts the current focalLatLng into a offset and validates it with
  // zoom controller actual rect to perform animation.
  void _updateZoomControllerActualRect() {
    final Offset center = pixelFromLatLng(_focalLatLng!.latitude,
        _focalLatLng!.longitude, Size.square(getTotalTileWidth(_zoomLevel)));
    final Offset newOffset = Offset(
        _zoomController!.parentRect!.width / 2 - center.dx,
        _zoomController!.parentRect!.height / 2 - center.dy);
    final Offset delta = newOffset - _zoomController!.actualRect.topLeft;
    if (delta != Offset.zero) {
      _zoomController!.actualRect =
          (_zoomController!.actualRect.topLeft + delta) &
              _zoomController!.actualRect.size;
      return;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DoubleProperty('zoomLevel', zoomLevel));
    properties.add(DoubleProperty('minZoomLevel', minZoomLevel));
    properties.add(DoubleProperty('maxZoomLevel', maxZoomLevel));
    properties.add(FlagProperty('enablePanning',
        value: enablePanning,
        ifTrue: 'Panning is enabled',
        ifFalse: 'Panning is disabled'));
    properties.add(FlagProperty('enablePinching',
        value: enablePinching,
        ifTrue: 'Pinching is enabled',
        ifFalse: 'Pinching is disabled'));
    properties.add(FlagProperty('enableDoubleTapZooming',
        value: enableDoubleTapZooming,
        ifTrue: 'Double tap is enabled',
        ifFalse: 'Double tap is disabled'));
    properties.add(FlagProperty('enableMouseWheelZooming',
        value: enableMouseWheelZooming,
        ifTrue: 'Mouse wheel is enabled',
        ifFalse: 'Mouse wheel is disabled'));
    properties.add(DiagnosticsProperty<MapLatLng>('focalLatLng', focalLatLng));
    properties.add(
        DiagnosticsProperty<MapLatLngBounds>('latLngBounds', latLngBounds));
    properties.add(FlagProperty('showToolbar',
        value: showToolbar,
        ifTrue: 'Toolbar is enabled',
        ifFalse: 'Toolbar is disabled'));
    properties.add(
      toolbarSettings.toDiagnosticsNode(name: 'toolbarSettings'),
    );
  }
}

/// Latitude and longitude in the maps.
@immutable
class MapLatLng {
  /// Creates a [MapLatLng].
  const MapLatLng(
    this.latitude,
    this.longitude,
  );

  /// The latitude in the maps.
  final double latitude;

  /// The longitude in the maps.
  final double longitude;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapLatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  /// Linearly interpolating between two [MapLatLng].
  ///
  /// The arguments must not be null.
  static MapLatLng? lerp(MapLatLng? a, MapLatLng? b, double t) {
    if (a == null || b == null) {
      return null;
    }

    return MapLatLng(a.latitude + (b.latitude - a.latitude) * t,
        a.longitude + (b.longitude - a.longitude) * t);
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'MapLatLng($latitude, $longitude)';
}

/// Bounds of the maps.
@immutable
class MapLatLngBounds {
  /// Creates a [MapLatLngBounds].
  const MapLatLngBounds(this.northeast, this.southwest);

  /// The northeast [MapLatLng] bound.
  final MapLatLng northeast;

  /// The southwest [MapLatLng] bound.
  final MapLatLng southwest;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapLatLngBounds &&
        other.northeast == northeast &&
        other.southwest == southwest;
  }

  @override
  int get hashCode => Object.hash(northeast, southwest);

  @override
  String toString() => 'MapLatLngBounds($northeast, $southwest)';
}

/// Contains details about the current zoom position.
class MapZoomDetails {
  /// Creates a [MapZoomDetails].
  MapZoomDetails({
    this.localFocalPoint,
    this.globalFocalPoint,
    this.previousZoomLevel,
    this.newZoomLevel,
    this.focalLatLng,
    this.previousVisibleBounds,
    this.newVisibleBounds,
  });

  /// The local focal point of the pointers in contact with the screen.
  final Offset? localFocalPoint;

  /// The global focal point of the pointers in contact with the screen.
  final Offset? globalFocalPoint;

  /// Provides the zoom level before the current zooming operation completes
  /// i.e. current zoom level.
  final double? previousZoomLevel;

  /// Provides the new zoom level when the current zoom completes.
  ///
  /// Hence, if the `super.onZooming(details)` is not called, there will be no
  /// changes in the UI.
  final double? newZoomLevel;

  /// Represents the new focal latitude and longitude position.
  final MapLatLng? focalLatLng;

  /// Provides the visible bounds before the current zooming operation completes
  /// i.e. current visible bounds.
  final MapLatLngBounds? previousVisibleBounds;

  /// Provides the new visible bounds when the current zoom completes.
  ///
  /// Hence, if the `super.onZooming(details)` is not called, there will be no
  /// changes in the UI.
  final MapLatLngBounds? newVisibleBounds;
}

/// Contains details about the current pan position.
class MapPanDetails {
  /// Creates a [MapPanDetails].
  MapPanDetails({
    this.localFocalPoint,
    this.globalFocalPoint,
    this.zoomLevel,
    this.focalLatLng,
    this.delta,
    this.previousVisibleBounds,
    this.newVisibleBounds,
  });

  /// The local focal point of the pointers in contact with the screen.
  final Offset? localFocalPoint;

  /// The global focal point of the pointers in contact with the screen.
  final Offset? globalFocalPoint;

  /// Provides the current zoom level.
  final double? zoomLevel;

  /// Provides the current focal latLng.
  final MapLatLng? focalLatLng;

  /// The difference in pixels between touch start and current touch position.
  final Offset? delta;

  /// Provides the visible bounds before the current panning operation
  /// completes i.e. current visible bounds.
  final MapLatLngBounds? previousVisibleBounds;

  /// Provides the new visible bounds when the current pan completes.
  ///
  /// Hence, if the `super.onPanning(details)` is not called, there will be no
  /// changes in the UI.
  final MapLatLngBounds? newVisibleBounds;
}

/// Widget for [MapZoomPanBehavior].
class BehaviorView extends StatefulWidget {
  /// Creates [BehaviorView].
  const BehaviorView({
    Key? key,
    required this.zoomLevel,
    required this.focalLatLng,
    required this.controller,
    required this.behavior,
    required this.onWillZoom,
    this.enableMouseWheelZooming,
    required this.onWillPan,
  }) : super(key: key);

  /// Denotes the zoom level of the zoomable widget.
  final double zoomLevel;

  /// Denotes the focalLatLng of the zoomable widget.
  final MapLatLng focalLatLng;

  /// Used to coordinate with [MapShapeLayer] and its elements.
  final MapController controller;

  /// Enables zooming and panning in [MapShapeLayer] and [MapTileLayer].
  final MapZoomPanBehavior behavior;

  /// Called whenever zooming is happening.
  final WillZoomCallback? onWillZoom;

  /// Called whenever panning is happening.
  final WillPanCallback? onWillPan;

  /// Enables mouse wheel zooming in map
  ///
  /// Defaults to `false` in web platform.
  ///
  /// ```dart
  /// SfMaps(
  ///    layers: [
  ///    MapShapeLayer(
  ///      zoomPanBehavior: MapZoomPanBehavior(
  ///       enableMouseWheelZooming : true ),
  ///         ),
  ///      ]
  ///   ),
  ///```
  final bool? enableMouseWheelZooming;

  @override
  State<BehaviorView> createState() => _BehaviorViewState();
}

class _BehaviorViewState extends State<BehaviorView> {
  Size? _size;
  late double _currentZoomLevel;
  late MapLatLng _currentFocalLatLng;
  Rect? _initialRect;

  Offset _pixelFromLatLng(MapLatLng latLng, double scale) {
    final double latitude =
        latLng.latitude.clamp(minimumLatitude, maximumLatitude);
    final double longitude =
        latLng.longitude.clamp(minimumLongitude, maximumLongitude);
    return pixelFromLatLng(
        latitude, longitude, Size.square(getTotalTileWidth(scale)));
  }

  MapLatLng _pixelToLatLng(Offset point, double scale) {
    return pixelToLatLng(point, Size.square(getTotalTileWidth(scale)));
  }

  bool _invokeOnZooming({
    required Offset localFocalPoint,
    required Offset globalFocalPoint,
    required double newZoomLevel,
    required MapLatLng newFocalLatLng,
    required double scale,
    required Offset? pinchCenter,
  }) {
    newZoomLevel = newZoomLevel.clamp(
        widget.behavior.minZoomLevel, widget.behavior.maxZoomLevel);
    final Rect previousVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(
          widget.behavior.focalLatLng!, widget.behavior.zoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds previousVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(previousVisibleBounds.topRight, widget.behavior.zoomLevel),
      _pixelToLatLng(
          previousVisibleBounds.bottomLeft, widget.behavior.zoomLevel),
    );
    widget.controller
      ..localScale = scale
      ..pinchCenter = pinchCenter ?? Offset.zero;

    final Rect newVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(newFocalLatLng, newZoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds newVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(newVisibleBounds.topRight, newZoomLevel),
      _pixelToLatLng(newVisibleBounds.bottomLeft, newZoomLevel),
    );

    final MapZoomDetails zoomDetails = MapZoomDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.behavior.zoomLevel,
      newZoomLevel: newZoomLevel,
      previousVisibleBounds: previousVisibleLatLngBounds,
      newVisibleBounds: newVisibleLatLngBounds,
      focalLatLng: newFocalLatLng,
    );

    if (widget.onWillZoom == null || widget.onWillZoom!(zoomDetails)) {
      if (widget.behavior._zoomController!.actionType !=
              ActionType.pinchFling ||
          widget.behavior._zoomController!.actionType != ActionType.panFling) {
        widget.behavior.onZooming(zoomDetails);
      }
      return true;
    }

    return false;
  }

  void _handleToolbarZooming(double newZoomLevel) {
    newZoomLevel = newZoomLevel.clamp(
        widget.behavior.minZoomLevel, widget.behavior.maxZoomLevel);
    final Rect previousVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(
          widget.behavior.focalLatLng!, widget.behavior.zoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds previousVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(previousVisibleBounds.topRight, widget.behavior.zoomLevel),
      _pixelToLatLng(
          previousVisibleBounds.bottomLeft, widget.behavior.zoomLevel),
    );

    final Rect newVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(widget.behavior.focalLatLng!, newZoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds newVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(newVisibleBounds.topRight, newZoomLevel),
      _pixelToLatLng(newVisibleBounds.bottomLeft, newZoomLevel),
    );
    final Offset localFocalPoint = newVisibleBounds.center;
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Offset globalFocalPoint = renderBox.localToGlobal(localFocalPoint);
    final MapZoomDetails zoomDetails = MapZoomDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: widget.behavior.zoomLevel,
      newZoomLevel: newZoomLevel,
      previousVisibleBounds: previousVisibleLatLngBounds,
      newVisibleBounds: newVisibleLatLngBounds,
      focalLatLng: widget.behavior.focalLatLng,
    );
    if (widget.onWillZoom == null || widget.onWillZoom!(zoomDetails)) {
      widget.behavior.zoomLevel = zoomDetails.newZoomLevel!;
    }
  }

  bool _invokeOnPanning({
    required Offset localFocalPoint,
    required Offset globalFocalPoint,
    required double newZoomLevel,
    required MapLatLng newFocalLatLng,
    required Offset delta,
  }) {
    final Rect previousVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(
          widget.behavior.focalLatLng!, widget.behavior.zoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds previousVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(previousVisibleBounds.topRight, widget.behavior.zoomLevel),
      _pixelToLatLng(
          previousVisibleBounds.bottomLeft, widget.behavior.zoomLevel),
    );

    final Rect newVisibleBounds = Rect.fromCenter(
      center: _pixelFromLatLng(newFocalLatLng, newZoomLevel),
      width: _size!.width,
      height: _size!.height,
    );
    final MapLatLngBounds newVisibleLatLngBounds = MapLatLngBounds(
      _pixelToLatLng(newVisibleBounds.topRight, newZoomLevel),
      _pixelToLatLng(newVisibleBounds.bottomLeft, newZoomLevel),
    );

    final MapPanDetails panDetails = MapPanDetails(
      globalFocalPoint: globalFocalPoint,
      localFocalPoint: localFocalPoint,
      zoomLevel: widget.behavior.zoomLevel,
      delta: delta,
      previousVisibleBounds: previousVisibleLatLngBounds,
      newVisibleBounds: newVisibleLatLngBounds,
      focalLatLng: newFocalLatLng,
    );
    widget.controller.visibleLatLngBounds = panDetails.newVisibleBounds;
    if (widget.onWillPan == null || widget.onWillPan!(panDetails)) {
      if (widget.behavior._zoomController!.actionType !=
              ActionType.pinchFling ||
          widget.behavior._zoomController!.actionType != ActionType.panFling) {
        widget.behavior.onPanning(panDetails);
      }
      return true;
    }

    return false;
  }

  void _handleZoomableChange(ZoomPanDetails details) {
    final Offset focalPoint = Offset(
        (_size!.width / 2) - details.actualRect.left,
        (_size!.height / 2) - details.actualRect.top);
    final MapLatLng newFocalLatLng = pixelToLatLng(
        focalPoint, Size.square(getTotalTileWidth(details.newZoomLevel)));
    _currentZoomLevel = details.newZoomLevel;
    _currentFocalLatLng = newFocalLatLng;

    if (widget.behavior._zoomController!.actionType == ActionType.pinch ||
        widget.behavior._zoomController!.actionType == ActionType.tap) {
      _invokeOnZooming(
        localFocalPoint: details.localFocalPoint,
        globalFocalPoint: details.globalFocalPoint,
        newZoomLevel: _currentZoomLevel,
        newFocalLatLng: newFocalLatLng,
        scale: details.scale,
        pinchCenter: details.pinchCenter,
      );
    } else if (widget.behavior._zoomController!.actionType == ActionType.pan) {
      _invokeOnPanning(
        localFocalPoint: details.localFocalPoint,
        globalFocalPoint: details.globalFocalPoint,
        newZoomLevel: _currentZoomLevel,
        newFocalLatLng: newFocalLatLng,
        delta: details.actualRect.topLeft - details.previousRect.topLeft,
      );
    }
  }

  void _handleZoomableEnd(ZoomPanDetails details) {
    widget.controller
      ..isInInteractive = false
      ..normalize = Offset.zero
      ..panDistance = Offset.zero
      ..gesture = null
      ..localScale = 1.0
      ..notifyRefreshListeners();
  }

  bool _handleZoomableFling(ZoomPanDetails details) {
    final Offset focalPoint = Offset(
        (_size!.width / 2) - details.actualRect.left,
        (_size!.height / 2) - details.actualRect.top);
    final MapLatLng newFocalLatLng = pixelToLatLng(
        focalPoint, Size.square(getTotalTileWidth(details.newZoomLevel)));
    _currentZoomLevel = details.newZoomLevel;
    _currentFocalLatLng = newFocalLatLng;
    bool canFling = false;

    if ((widget.behavior._zoomController!.actionType ==
            ActionType.pinchFling) &&
        _currentZoomLevel != details.previousZoomLevel) {
      canFling = _invokeOnZooming(
        localFocalPoint: details.localFocalPoint,
        globalFocalPoint: details.globalFocalPoint,
        newZoomLevel: _currentZoomLevel,
        newFocalLatLng: newFocalLatLng,
        scale: details.scale,
        pinchCenter: details.pinchCenter,
      );
    } else if (widget.behavior._zoomController!.actionType ==
            ActionType.panFling &&
        details.previousRect != details.actualRect) {
      canFling = _invokeOnPanning(
        localFocalPoint: details.localFocalPoint,
        globalFocalPoint: details.globalFocalPoint,
        newZoomLevel: _currentZoomLevel,
        newFocalLatLng: newFocalLatLng,
        delta: details.actualRect.topLeft - details.previousRect.topLeft,
      );
    }

    return canFling;
  }

  Rect _getInitialRect() {
    widget.behavior._zoomController!.parentRect = Offset.zero & _size!;
    final double tileSize = getTotalTileWidth(_currentZoomLevel);
    final Offset center =
        _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);
    final Rect initialRect =
        Offset(_size!.width / 2 - center.dx, _size!.height / 2 - center.dy) &
            Size.square(tileSize);
    return initialRect;
  }

  @override
  void initState() {
    _currentFocalLatLng = widget.focalLatLng;
    _currentZoomLevel = widget.zoomLevel;
    widget.behavior._zoomLevel = _currentZoomLevel;
    widget.behavior._focalLatLng = _currentFocalLatLng;
    widget.controller.addToolbarZoomedListener(_handleToolbarZooming);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeToolbarZoomedListener(_handleToolbarZooming);
    widget.behavior
      .._zoomController?.dispose()
      .._zoomController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size newSize = getBoxSize(constraints);
        if (_size == null || _size != newSize) {
          _size = newSize;
          _currentFocalLatLng = widget.focalLatLng;
          _currentZoomLevel = widget.zoomLevel;
          widget.behavior
            .._zoomLevel = _currentZoomLevel
            .._focalLatLng = _currentFocalLatLng;
          _initialRect = _getInitialRect();
        }

        return Zoomable(
          initialZoomLevel: widget.behavior.zoomLevel,
          initialRect: _initialRect!,
          minZoomLevel: widget.behavior.minZoomLevel,
          maxZoomLevel: widget.behavior.maxZoomLevel,
          zoomController: widget.behavior._zoomController!,
          enablePinching: widget.behavior.enablePinching,
          enablePanning: widget.behavior.enablePanning,
          enableDoubleTapZooming: widget.behavior.enableDoubleTapZooming,
          enableMouseWheelZooming: widget.behavior.enableMouseWheelZooming,
          onUpdate: _handleZoomableChange,
          onComplete: _handleZoomableEnd,
          onFling: _handleZoomableFling,
          frictionCoefficient: 0.009,
          child: BehaviorViewRenderObjectWidget(
            controller: widget.controller,
            zoomPanBehavior: widget.behavior,
          ),
        );
      },
    );
  }
}

/// Render object widget of the internal widget which handles
/// the [MapZoomPanBehavior].
class BehaviorViewRenderObjectWidget extends LeafRenderObjectWidget {
  /// Creates [BehaviorViewRenderObjectWidget].
  const BehaviorViewRenderObjectWidget({
    Key? key,
    required this.controller,
    required this.zoomPanBehavior,
  }) : super(key: key);

  /// Used to coordinate with [MapShapeLayer] and its elements.
  final MapController controller;

  /// Enables zooming and panning in [MapShapeLayer] and [MapTileLayer].
  final MapZoomPanBehavior zoomPanBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBehaviorView(
      listener: controller,
      zoomPanBehavior: zoomPanBehavior,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderBehaviorView renderObject) {
    renderObject
      ..controller = controller
      ..zoomPanBehavior = zoomPanBehavior;
  }
}

class _RenderBehaviorView extends RenderBox implements MouseTrackerAnnotation {
  _RenderBehaviorView({
    required MapController listener,
    required MapZoomPanBehavior zoomPanBehavior,
  })  : controller = listener,
        _zoomPanBehavior = zoomPanBehavior {
    _zoomPanBehavior._renderBox = this;
    _zoomPanBehavior._controller = controller;
  }

  MapController controller;
  late bool _validForMouseTracker;

  MapZoomPanBehavior get zoomPanBehavior => _zoomPanBehavior;
  MapZoomPanBehavior _zoomPanBehavior;
  set zoomPanBehavior(MapZoomPanBehavior value) {
    if (_zoomPanBehavior == value) {
      return;
    }
    _zoomPanBehavior = value;
    value._renderBox = this;
    value._controller = controller;
  }

  void _handleBehaviorChange() {
    markNeedsPaint();
  }

  void _handleEnter(PointerEnterEvent event) {
    zoomPanBehavior.handleEvent(event);
  }

  void _handleExit(PointerExitEvent event) {
    zoomPanBehavior.handleEvent(event);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    controller.addListener(_handleBehaviorChange);
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    controller.removeListener(_handleBehaviorChange);
    super.detach();
  }

  @override
  MouseCursor get cursor => controller.gesture == Gesture.pan
      ? SystemMouseCursors.grabbing
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => _handleEnter;

  @override
  PointerExitEventListener? get onExit => _handleExit;

  @override
  bool get validForMouseTracker => _validForMouseTracker;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (size.contains(position)) {
      result.add(BoxHitTestEntry(this, position));
    }
    return false;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    zoomPanBehavior.handleEvent(event);
  }

  @override
  void performLayout() {
    size = getBoxSize(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    zoomPanBehavior.paint(context, offset);
    super.paint(context, offset);
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
