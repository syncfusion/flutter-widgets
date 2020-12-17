import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';

import '../behavior/zoom_pan_behavior.dart';
import '../controller/default_controller.dart';
import '../controller/shape_layer_controller.dart';
import '../elements/marker.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../layer/layer_base.dart';
import '../layer/shape_layer.dart';
import '../layer/vector_layers.dart';
import '../settings.dart';
import '../utils.dart';

Offset _pixelFromLatLng(MapLatLng latLng, double scale) {
  final double latitude =
      _clip(latLng.latitude, minimumLatitude, maximumLatitude);
  final double longitude =
      _clip(latLng.longitude, minimumLongitude, maximumLongitude);
  final double x = (longitude + 180) / 360;
  final double sinLatitude = sin(latitude * pi / 180);
  final double y = 0.5 - log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * pi);

  final double tileSize = getTotalTileWidth(scale);
  final double pixelX = _clip(x * tileSize + 0.5, 0, tileSize - 1);
  final double pixelY = _clip(y * tileSize + 0.5, 0, tileSize - 1);
  return Offset(pixelX, pixelY);
}

MapLatLng _latLngFromPixel(Offset point, {double scale}) {
  final double tileSize = getTotalTileWidth(scale);
  final double x = (_clip(point.dx, 0, tileSize - 1) / tileSize) - 0.5;
  final double y = 0.5 - (_clip(point.dy, 0, tileSize - 1) / tileSize);

  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

double _clip(double value, double minValue, double maxValue) {
  return min(max(value, minValue), maxValue);
}

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
///                   zoomPanBehavior: MapZoomPanBehavior(),
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
Future<String> getBingUrlTemplate(String url) async {
  final http.Response response = await _fetchResponse(url);
  assert(response.statusCode == 200, 'Invalid key');
  if (response.statusCode == 200) {
    final Map<String, dynamic> decodedJson = json.decode(response.body);
    String imageUrl;
    String imageUrlSubDomains;
    if (decodedJson['authenticationResultCode'] == 'ValidCredentials') {
      for (final String key in decodedJson.keys) {
        if (key == 'resourceSets') {
          final List<dynamic> resourceSets = decodedJson[key];
          for (final key in resourceSets[0].keys) {
            if (key == 'resources') {
              final List<dynamic> resources = (resourceSets[0])[key];
              final Map<String, dynamic> resourcesMap = resources[0];
              imageUrl = resourcesMap['imageUrl'];
              final List<dynamic> subDomains =
                  resourcesMap['imageUrlSubdomains'];
              imageUrlSubDomains = subDomains[0];
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
  return http.get(url);
}

/// Provides options for adding, removing, deleting, updating markers
/// collection and converting pixel points to latitude and longitude.
class MapTileLayerController extends MapLayerController {
  /// Instance of _MapTileLayerState.
  _MapTileLayerState _state;

  /// Returns the current markers count.
  int get markersCount => _markersCount;
  int _markersCount = 0;

  /// Converts pixel point to [MapLatLng].
  MapLatLng pixelToLatLng(Offset position) {
    final Offset localPointCenterDiff = Offset(
        (_state._size.width / 2) - position.dx,
        (_state._size.height / 2) - position.dy);
    final Offset actualCenterPixelPosition =
        _pixelFromLatLng(_state._currentFocalLatLng, _state._currentZoomLevel);
    final Offset newCenterPoint =
        actualCenterPixelPosition - localPointCenterDiff;
    return _latLngFromPixel(newCenterPoint, scale: _state._currentZoomLevel);
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
/// Regarding the cache and clearing it, please check the APIs in [imageCache]
/// (https://api.flutter.dev/flutter/painting/imageCache.html).
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
///
/// See also:
/// * For enabling zooming and panning, set [zoomPanBehavior] with the instance
/// of [MapZoomPanBehavior].
class MapTileLayer extends MapLayer {
  /// Creates a [MapTileLayer].
  MapTileLayer({
    Key key,
    @required this.urlTemplate,
    this.initialFocalLatLng = const MapLatLng(0.0, 0.0),
    this.initialZoomLevel = 1,
    this.controller,
    List<MapSublayer> sublayers,
    int initialMarkersCount = 0,
    MapMarkerBuilder markerBuilder,
    IndexedWidgetBuilder markerTooltipBuilder,
    MapTooltipSettings tooltipSettings = const MapTooltipSettings(),
    MapZoomPanBehavior zoomPanBehavior,
    WillZoomCallback onWillZoom,
    WillPanCallback onWillPan,
  })  : assert(initialZoomLevel >= 1 && initialZoomLevel <= 15),
        assert(initialMarkersCount == 0 ||
            initialMarkersCount != 0 && markerBuilder != null),
        super(
          key: key,
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
  ///
  /// For Bing Maps, an additional step is required. The format of the required
  /// URL varies from the other tile services. Hence, we have added a top-level
  /// [getBingUrlTemplate] function which returns the URL in the required
  /// format. You can use the URL returned from this function to set it to the
  /// [urlTemplate] property.
  ///
  /// ```dart
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
  ///                   zoomPanBehavior: MapZoomPanBehavior(),
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
  ///   List<Model> data;
  ///   MapTileLayerController controller;
  ///   Random random = Random();
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///
  ///     data = <Model>[
  ///       Model(-14.235004, -51.92528),
  ///       Model(51.16569, 10.451526),
  ///       Model(-25.274398, 133.775136),
  ///       Model(20.593684, 78.96288),
  ///       Model(61.52401, 105.318756)
  ///     ];
  ///
  ///     controller = MapTileLayerController();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FutureBuilder(
  ///         future: getBingUrlTemplate(
  ///             'http://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOn
  ///             Demand?output=json&include=ImageryProviders&key=YOUR_KEY'),
  ///         builder: (context, snapshot) {
  ///           if (snapshot.hasData) {
  ///             return Column(
  ///               children: [
  ///                 SfMaps(
  ///                   layers: [
  ///                     MapTileLayer(
  ///                       initialFocalLatLng: MapLatLng(20.5937, 78.9629),
  ///                       zoomPanBehavior: MapZoomPanBehavior(),
  ///                       initialZoomLevel: 3,
  ///                       urlTemplate: snapshot.data,
  ///                       initialMarkersCount: 5,
  ///                       markerBuilder: (BuildContext context, int index) {
  ///                        return MapMarker(
  ///                           latitude: data[index].latitude,
  ///                           longitude: data[index].longitude,
  ///                           child: Icon(Icons.add_location),
  ///                         );
  ///                       },
  ///                     ),
  ///                   ],
  ///                 ),
  ///                 RaisedButton(
  ///                   child: Text('Add marker'),
  ///                   onPressed: () {
  ///                     data.add(Model(-180 + random.nextInt(360).toDouble(),
  ///                         -55 + random.nextInt(139).toDouble()));
  ///                     controller.insertMarker(5);
  ///                   },
  ///                 ),
  ///               ],
  ///             );
  ///           }
  ///           return CircularProgressIndicator();
  ///         });
  ///   }
  /// ```
  final MapTileLayerController controller;

  @override
  Widget build(BuildContext context) {
    return _MapTileLayer(
      key: key,
      urlTemplate: urlTemplate,
      initialFocalLatLng: initialFocalLatLng,
      initialZoomLevel: initialZoomLevel,
      sublayers: sublayers,
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      markerTooltipBuilder: markerTooltipBuilder,
      tooltipSettings: tooltipSettings,
      zoomPanBehavior: zoomPanBehavior,
      controller: controller,
      onWillZoom: onWillZoom,
      onWillPan: onWillPan,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(StringProperty('urlTemplate', urlTemplate));
    properties.add(DiagnosticsProperty<MapLatLng>(
        'initialFocalLatLng', initialFocalLatLng));
    properties.add(IntProperty('initialZoomLevel', initialZoomLevel));
    if (zoomPanBehavior != null) {
      properties
          .add(zoomPanBehavior.toDiagnosticsNode(name: 'zoomPanBehavior'));
    }
    properties.add(ObjectFlagProperty<MapMarkerBuilder>.has(
        'markerBuilder', markerBuilder));
    if (controller != null) {
      properties.add(IntProperty('markersCount', controller.markersCount));
    } else {
      properties.add(IntProperty('markersCount', initialMarkersCount));
    }
    properties.add(
        ObjectFlagProperty<WillZoomCallback>.has('onWillZoom', onWillZoom));
    properties
        .add(ObjectFlagProperty<WillPanCallback>.has('onWillPan', onWillPan));
  }
}

class _MapTileLayer extends StatefulWidget {
  _MapTileLayer({
    Key key,
    this.urlTemplate,
    this.initialFocalLatLng,
    this.initialZoomLevel,
    this.zoomPanBehavior,
    this.sublayers,
    this.initialMarkersCount,
    this.markerBuilder,
    this.markerTooltipBuilder,
    this.tooltipSettings,
    this.controller,
    this.onWillZoom,
    this.onWillPan,
  }) : super(key: key);

  final String urlTemplate;
  final MapLatLng initialFocalLatLng;
  final int initialZoomLevel;
  final MapZoomPanBehavior zoomPanBehavior;
  final List<MapSublayer> sublayers;
  final int initialMarkersCount;
  final MapMarkerBuilder markerBuilder;
  final IndexedWidgetBuilder markerTooltipBuilder;
  final MapTooltipSettings tooltipSettings;
  final MapTileLayerController controller;
  final WillZoomCallback onWillZoom;
  final WillPanCallback onWillPan;

  @override
  _MapTileLayerState createState() => _MapTileLayerState();
}

class _MapTileLayerState extends State<_MapTileLayer>
    with TickerProviderStateMixin {
  // Both width and height of each tile is 256.
  static const double tileSize = 256;
  static const double _frictionCoefficient = 0.0000135;
  // The [MapController] handles the events of the [ZoomPanBehavior].
  MapController _controller;
  AnimationController _zoomLevelAnimationController;
  AnimationController _focalLatLngAnimationController;
  Animation<double> _zoomLevelAnimation;
  Animation<double> _focalLatLngAnimation;
  MapLatLngTween _focalLatLngTween;
  Tween<double> _zoomLevelTween;

  // Stores the integer zoom level in the [_nextZoomLevel] field
  // like 1, 2, 3 etc.
  int _nextZoomLevel;
  final Map<String, _MapTile> _tiles = {};
  final Map<double, MapZoomLevel> _levels = {};
  // Stores the current zoom level in the [_currentZoomLevel] field
  // like 1, 1.1, 1.2 etc.
  double _currentZoomLevel;
  double _touchStartZoomLevel;
  MapLatLng _touchStartLatLng;
  MapLatLng _currentFocalLatLng;
  Offset _touchStartLocalPoint;
  Offset _touchStartGlobalPoint;
  Size _size;

  GlobalKey _tooltipKey;
  Gesture _gestureType;
  bool _isSizeChanged = false;
  bool _isDesktop;
  bool _hasSublayer = false;
  bool _isZoomedUsingToolbar = false;
  List<Widget> _markers;
  MapZoomDetails _zoomDetails;
  MapPanDetails _panDetails;
  Timer _zoomingDelayTimer;
  MapLatLng _mouseCenterLatLng;
  double _mouseStartZoomLevel;
  Offset _mouseStartLocalPoint;
  Offset _mouseStartGlobalPoint;
  Offset _touchStartOffset;
  MapLatLng _newFocalLatLng;
  SfMapsThemeData _mapsThemeData;

  @override
  void initState() {
    super.initState();
    _tooltipKey = GlobalKey();
    _currentFocalLatLng =
        widget.zoomPanBehavior?.focalLatLng ?? widget.initialFocalLatLng;
    _currentZoomLevel = (widget.zoomPanBehavior != null &&
            widget.zoomPanBehavior.zoomLevel != 1)
        ? widget.zoomPanBehavior.zoomLevel
        : widget.initialZoomLevel.toDouble();
    widget.zoomPanBehavior?.zoomLevel = _currentZoomLevel;
    _nextZoomLevel = _currentZoomLevel.floor();
    if (widget.controller != null) {
      widget.controller._markersCount = widget.initialMarkersCount;
    }

    widget.controller?._state = this;
    _markers = <Widget>[];
    for (int i = 0; i < widget.initialMarkersCount; i++) {
      final MapMarker marker = widget.markerBuilder(context, i);
      assert(marker != null);
      _markers.add(marker);
    }

    _zoomLevelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..addListener(_handleZoomLevelAnimation)
      ..addStatusListener(_handleZoomLevelAnimationStatusChange);
    _focalLatLngAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650))
      ..addListener(_handleFocalLatLngAnimation)
      ..addStatusListener(_handleFocalLatLngAnimationStatusChange);
    _zoomLevelAnimation = CurvedAnimation(
        parent: _zoomLevelAnimationController, curve: Curves.easeInOut);
    _focalLatLngAnimation = CurvedAnimation(
        parent: _focalLatLngAnimationController, curve: Curves.decelerate);
    _focalLatLngTween = MapLatLngTween();
    _zoomLevelTween = Tween<double>();
    _hasSublayer = widget.sublayers != null && widget.sublayers.isNotEmpty;
    widget.controller?.addListener(refreshMarkers);
    _controller = MapController()
      ..addZoomingListener(_handleZooming)
      ..addPanningListener(_handlePanning)
      ..addResetListener(_handleReset)
      ..tileLayerZoomLevel = _currentZoomLevel
      ..visibleFocalLatLng = _currentFocalLatLng
      ..onZoomLevelChange = _handleZoomTo
      ..onPanChange = _handlePanTo
      ..tooltipKey = _tooltipKey
      ..isTileLayerChild = true;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset);
    }

    if (_zoomLevelAnimationController != null) {
      _zoomLevelAnimationController
        ..removeListener(_handleZoomLevelAnimation)
        ..removeStatusListener(_handleZoomLevelAnimationStatusChange)
        ..dispose();
    }

    if (_focalLatLngAnimationController != null) {
      _focalLatLngAnimationController
        ..removeListener(_handleFocalLatLngAnimation)
        ..removeStatusListener(_handleFocalLatLngAnimationStatusChange)
        ..dispose();
    }

    widget.controller?.removeListener(refreshMarkers);
    _controller?.dispose();
    _markers.clear();
    _tiles?.clear();
    _levels?.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MapTileLayer oldWidget) {
    _hasSublayer = widget.sublayers != null && widget.sublayers.isNotEmpty;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _mapsThemeData = SfMapsTheme.of(context);
    _mapsThemeData = _mapsThemeData.copyWith(
      tooltipColor: widget.tooltipSettings.color ?? _mapsThemeData.tooltipColor,
      tooltipStrokeColor: widget.tooltipSettings.strokeColor ??
          _mapsThemeData.tooltipStrokeColor,
      tooltipStrokeWidth: widget.tooltipSettings.strokeWidth ??
          _mapsThemeData.tooltipStrokeWidth,
      tooltipBorderRadius: _mapsThemeData.tooltipBorderRadius
          .resolve(Directionality.of(context)),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (_size != null) {
          _isSizeChanged = _size.width != constraints.maxWidth ||
              _size.height != constraints.maxHeight;
        }

        _size = getBoxSize(constraints);
        _controller.tileLayerBoxSize = _size;
        return Container(
          width: _size.width,
          height: _size.height,
          child: Listener(
            onPointerDown: _handlePointerDown,
            onPointerMove: _handlePointerMove,
            onPointerUp: _handlePointerUp,
            onPointerSignal: _handleMouseWheelZooming,
            child: GestureDetector(
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onScaleEnd: _handleScaleEnd,
              child: _getTileLayerElements(context, themeData),
            ),
          ),
        );
      },
    );
  }

  // Add elements in the tile layer.
  Widget _getTileLayerElements(BuildContext context, ThemeData themeData) {
    final List<Widget> children = <Widget>[];
    children.add(_getTiles());
    if (_hasSublayer) {
      children.add(
        ClipRect(
          child: SublayerContainer(
            controller: _controller,
            tooltipKey: _tooltipKey,
            children: widget.sublayers,
          ),
        ),
      );
    }

    if (_markers != null && _markers.isNotEmpty) {
      children.add(ClipRect(
          child: _TileLayerMarkerContainer(
        tooltipKey: _tooltipKey,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        children: _markers,
        controller: _controller,
      )));
    }

    if (widget.zoomPanBehavior != null) {
      children.add(BehaviorViewRenderObjectWidget(
        controller: _controller,
        zoomPanBehavior: widget.zoomPanBehavior,
      ));
    }

    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior.showToolbar &&
        _isDesktop) {
      children.add(
        MapToolbar(
          onWillZoom: widget.onWillZoom,
          zoomPanBehavior: widget.zoomPanBehavior,
          controller: _controller,
        ),
      );
    }

    if (_hasTooltipBuilder()) {
      children.add(
        MapTooltip(
          key: _tooltipKey,
          controller: _controller,
          sublayers: widget.sublayers,
          markerTooltipBuilder: widget.markerTooltipBuilder,
          tooltipSettings: widget.tooltipSettings,
          themeData: _mapsThemeData,
        ),
      );
    }

    return Stack(
      children: children,
    );
  }

  bool _hasTooltipBuilder() {
    if (widget.markerTooltipBuilder != null) {
      return true;
    } else if (_hasSublayer) {
      final Iterator<MapSublayer> iterator = widget.sublayers.iterator;
      while (iterator.moveNext()) {
        final MapSublayer sublayer = iterator.current;
        if ((sublayer is MapShapeSublayer &&
                (sublayer.shapeTooltipBuilder != null ||
                    sublayer.bubbleTooltipBuilder != null ||
                    sublayer.markerTooltipBuilder != null)) ||
            (sublayer is MapVectorLayer && sublayer.tooltipBuilder != null)) {
          return true;
        }
      }
    }
    return false;
  }

  // Generate tiles for the visible bounds and placed the tiles in a positioned
  // widget.
  Widget _getTiles() {
    // Calculate new visible bounds based on the [_currentFocalLatLng] value
    // and request new tiles for the visible bounds. This method called only
    // when new zoom level reached.
    _requestAndPopulateNewTiles();

    // The populated tiles are stored in the [_tiles] collection field.
    final tiles = _tiles.values.toList();
    final List<Widget> positionedTiles = <Widget>[];

    for (final tile in tiles) {
      positionedTiles.add(_getPositionedTiles(tile));
    }

    return Stack(
      children: positionedTiles,
    );
  }

  // Generate tiles for the new zoom level based on the focalLatLng value.
  void _requestAndPopulateNewTiles() {
    _updateZoomLevel();
    final double tileCount = pow(2, _nextZoomLevel).toDouble();
    final Offset actualCenterPixelPosition =
        _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);

    final Offset halfSize = Offset(_size.width, _size.height) / 2;

    // The [globalTileStart] and [globalTileEnd] represents the tile start and
    // end factor value based on the zoom level.
    final Offset globalTileStart = Offset(0, 0);
    final Offset globalTileEnd = Offset(tileCount - 1, tileCount - 1);

    // The [visualTileStart] and [visualTileEnd] represents the visual
    // bounds of the tiles in pixel based on the [focalLatLng] value.
    final Offset visualTileStart = actualCenterPixelPosition - halfSize;
    final Offset visualTileEnd = actualCenterPixelPosition + halfSize;
    final double currentLevelTileSize =
        tileSize * _levels[_nextZoomLevel].scale;

    // The [startX], [startY], [endX] and [endY] represents the visual
    // bounds of the tiles in factor.
    final int startX = (visualTileStart.dx / currentLevelTileSize).floor();
    final int startY = (visualTileStart.dy / currentLevelTileSize).floor();
    final int endX = (visualTileEnd.dx / currentLevelTileSize).ceil();
    final int endY = (visualTileEnd.dy / currentLevelTileSize).ceil();
    final List<_MapTileCoordinate> tileCoordinates = <_MapTileCoordinate>[];

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        final _MapTileCoordinate tileCoordinate =
            _MapTileCoordinate(i, j, _nextZoomLevel);

        if ((tileCoordinate.x < globalTileStart.dx ||
                tileCoordinate.x > globalTileEnd.dx) ||
            (tileCoordinate.y < globalTileStart.dy ||
                tileCoordinate.y > globalTileEnd.dy)) {
          continue;
        }

        final _MapTile tile = _tiles[_tileFactorToKey(tileCoordinate)];
        if (tile != null) {
          continue;
        } else {
          tileCoordinates.add(tileCoordinate);
        }
      }
    }

    final Offset tileCenter = Offset((startX + endX) / 2, (startY + endY) / 2);
    tileCoordinates.sort((a, b) => (a.distanceTo(
                Offset(a.x.toDouble(), a.y.toDouble()), tileCenter) -
            b.distanceTo(Offset(b.x.toDouble(), b.y.toDouble()), tileCenter))
        .toInt());

    for (int i = 0; i < tileCoordinates.length; i++) {
      _addTile(tileCoordinates[i]);
    }
  }

  // This method called when start pinch zooming or panning action.
  void _handleScaleStart(ScaleStartDetails details) {
    if (widget.zoomPanBehavior != null) {
      if (widget.zoomPanBehavior.enablePinching ||
          widget.zoomPanBehavior.enablePanning) {
        _focalLatLngAnimationController?.stop();
        _gestureType = null;
        _touchStartLocalPoint = details.localFocalPoint;
        _touchStartGlobalPoint = details.focalPoint;
        _touchStartZoomLevel = _currentZoomLevel.toDouble();
        final Offset localPointCenterDiff = Offset(
            (_size.width / 2) - _touchStartLocalPoint.dx,
            (_size.height / 2) - _touchStartLocalPoint.dy);
        final Offset actualCenterPixelPosition =
            _pixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel);
        final Offset point = actualCenterPixelPosition - localPointCenterDiff;
        _touchStartLatLng =
            _latLngFromPixel(point, scale: _touchStartZoomLevel);

        final Rect newVisibleBounds = Rect.fromCenter(
            center: _pixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel),
            width: _size.width,
            height: _size.height);
        final MapLatLngBounds newVisibleLatLng = MapLatLngBounds(
            _latLngFromPixel(newVisibleBounds.topRight,
                scale: _touchStartZoomLevel),
            _latLngFromPixel(newVisibleBounds.bottomLeft,
                scale: _touchStartZoomLevel));
        final MapLatLng touchStartFocalLatLng = _calculateVisibleLatLng(
            _touchStartLocalPoint, _touchStartZoomLevel);
        _touchStartOffset =
            _pixelFromLatLng(touchStartFocalLatLng, _touchStartZoomLevel);

        _zoomDetails = MapZoomDetails(newVisibleBounds: newVisibleLatLng);
        _panDetails = MapPanDetails(newVisibleBounds: newVisibleLatLng);
        _newFocalLatLng = _currentFocalLatLng;
      }
    }
  }

  // This method called when doing pinch zooming or panning action.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (widget.zoomPanBehavior != null &&
        (widget.zoomPanBehavior.enablePinching ||
            widget.zoomPanBehavior.enablePanning)) {
      final double zoomLevel = _touchStartZoomLevel + log(details.scale) / ln2;
      if ((widget.zoomPanBehavior.maxZoomLevel != null &&
              zoomLevel > widget.zoomPanBehavior.maxZoomLevel) ||
          (widget.zoomPanBehavior.minZoomLevel != null &&
              zoomLevel < widget.zoomPanBehavior.minZoomLevel)) {
        return;
      }

      _gestureType ??= _getGestureType(details.scale, details.localFocalPoint);
      if (_gestureType == null) {
        return;
      }

      _controller.localScale = details.scale;
      final double newZoomLevel =
          _getZoomLevel(_touchStartZoomLevel + log(details.scale) / ln2);
      switch (_gestureType) {
        case Gesture.scale:
          if (widget.zoomPanBehavior.enablePinching) {
            final MapLatLng newFocalLatLng =
                _calculateVisibleLatLng(_touchStartLocalPoint, newZoomLevel);
            _controller
              ..isInInteractive = true
              ..gesture = _gestureType
              ..localScale = details.scale
              ..pinchCenter = _touchStartLocalPoint;
            _invokeOnZooming(newZoomLevel, _touchStartLocalPoint,
                _touchStartGlobalPoint, newFocalLatLng);
          }
          return;
        case Gesture.pan:
          if (widget.zoomPanBehavior.enablePanning) {
            final MapLatLng newFocalLatLng =
                _calculateVisibleLatLng(details.localFocalPoint, newZoomLevel);
            final Offset newFocalOffset =
                _pixelFromLatLng(newFocalLatLng, newZoomLevel);

            _controller
              ..isInInteractive = true
              ..gesture = _gestureType
              ..localScale = 1.0
              ..panDistance = _touchStartOffset - newFocalOffset;
            _invokeOnPanning(newZoomLevel,
                localFocalPoint: details.localFocalPoint,
                globalFocalPoint: details.focalPoint,
                touchStartLocalPoint: _touchStartLocalPoint,
                newFocalLatLng: newFocalLatLng);
          }
          return;
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    // Calculating the end focalLatLng based on the obtained velocity.
    if (_gestureType == Gesture.pan &&
        details.velocity.pixelsPerSecond.distance >= kMinFlingVelocity) {
      final Offset currentPixelPoint =
          _pixelFromLatLng(_currentFocalLatLng, _currentZoomLevel);
      final FrictionSimulation frictionX = FrictionSimulation(
        _frictionCoefficient,
        currentPixelPoint.dx,
        -details.velocity.pixelsPerSecond.dx,
      );

      final FrictionSimulation frictionY = FrictionSimulation(
        _frictionCoefficient,
        currentPixelPoint.dy,
        -details.velocity.pixelsPerSecond.dy,
      );

      final double duration =
          _getDuration(details.velocity.pixelsPerSecond.distance);

      final MapLatLng latLng = _latLngFromPixel(
          Offset(frictionX.finalX, frictionY.finalX),
          scale: _currentZoomLevel);
      _gestureType = null;
      _focalLatLngAnimationController.duration =
          Duration(milliseconds: (duration * 650).round());
      widget.zoomPanBehavior.focalLatLng = latLng;
    }

    _controller.localScale = 1.0;
    _gestureType = null;
    _panDetails = null;
    _zoomDetails = null;
    _invalidateSublayer();
  }

  // Calculate the time at which movement comes to a stop.
  double _getDuration(double distance) {
    return log(10.0 / distance) / log(_frictionCoefficient / 100);
  }

  void _invalidateSublayer() {
    _controller
      ..isInInteractive = false
      ..normalize = Offset.zero
      ..gesture = null
      ..localScale = 1.0;
    if (_hasSublayer) {
      _controller?.notifyRefreshListeners();
    }
  }

  // This method called for both pinch zooming action and mouse wheel zooming
  // action for passing [MapZoomDetails] parameters to notify user about the
  // zooming details.
  void _invokeOnZooming(double newZoomLevel,
      [Offset localFocalPoint,
      Offset globalFocalPoint,
      MapLatLng newFocalLatLng]) {
    final Rect newVisibleBounds = Rect.fromCenter(
        center: _pixelFromLatLng(newFocalLatLng, newZoomLevel),
        width: _size.width,
        height: _size.height);

    _zoomDetails = MapZoomDetails(
        localFocalPoint: localFocalPoint,
        globalFocalPoint: globalFocalPoint,
        previousZoomLevel: widget.zoomPanBehavior.zoomLevel,
        newZoomLevel: newZoomLevel,
        previousVisibleBounds: _zoomDetails != null
            ? _zoomDetails.newVisibleBounds
            : _controller.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _latLngFromPixel(newVisibleBounds.topRight, scale: newZoomLevel),
            _latLngFromPixel(newVisibleBounds.bottomLeft,
                scale: newZoomLevel)));
    _newFocalLatLng = newFocalLatLng;
    if (widget.onWillZoom == null || widget.onWillZoom(_zoomDetails)) {
      widget.zoomPanBehavior?.onZooming(_zoomDetails);
    }
  }

  void _invokeOnPanning(double newZoomLevel,
      {Offset localFocalPoint,
      Offset globalFocalPoint,
      Offset touchStartLocalPoint,
      MapLatLng newFocalLatLng}) {
    final Rect newVisibleBounds = Rect.fromCenter(
        center: _pixelFromLatLng(newFocalLatLng, newZoomLevel),
        width: _size.width,
        height: _size.height);

    _panDetails = MapPanDetails(
        globalFocalPoint: globalFocalPoint,
        localFocalPoint: localFocalPoint,
        zoomLevel: widget.zoomPanBehavior.zoomLevel,
        delta: localFocalPoint - touchStartLocalPoint,
        previousVisibleBounds: _panDetails != null
            ? _panDetails.newVisibleBounds
            : _controller.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _latLngFromPixel(newVisibleBounds.topRight, scale: newZoomLevel),
            _latLngFromPixel(newVisibleBounds.bottomLeft,
                scale: newZoomLevel)));
    _newFocalLatLng = newFocalLatLng;
    if (widget.onWillPan == null || widget.onWillPan(_panDetails)) {
      widget.zoomPanBehavior?.onPanning(_panDetails);
    }
  }

  // Restricting new zoom level value either to
  // [widget.zoomPanBehavior.minZoomLevel] or
  // [widget.zoomPanBehavior.maxZoomLevel] if the new zoom level value is not
  // in zoom level range.
  double _getZoomLevel(double zoomLevel) {
    return zoomLevel.isNaN
        ? widget.zoomPanBehavior.minZoomLevel
        : interpolateValue(
            zoomLevel,
            widget.zoomPanBehavior.minZoomLevel,
            widget.zoomPanBehavior.maxZoomLevel,
          );
  }

  // This method called when dynamically changing the [zoomLevel] property of
  // ZoomPanBehavior.
  void _handleZoomTo(double zoomLevel, {MapLatLng latlng}) {
    if (_gestureType == null) {
      _zoomLevelTween.begin = _currentZoomLevel;
      _zoomLevelTween.end = widget.zoomPanBehavior.zoomLevel;
      _zoomLevelAnimationController.forward(from: 0.0);
    }
  }

  // This method called when dynamically changing the [focalLatLng] property of
  // ZoomPanBehavior.
  void _handlePanTo(MapLatLng latlng) {
    if (_gestureType == null) {
      _focalLatLngTween.begin = _currentFocalLatLng;
      _focalLatLngTween.end = widget.zoomPanBehavior.focalLatLng;
      _focalLatLngAnimationController.forward(from: 0.0);
    }
  }

  void _handleZoomLevelAnimation() {
    if (_zoomLevelTween.end != null) {
      _currentZoomLevel = _zoomLevelTween.evaluate(_zoomLevelAnimation);
    }
    _handleZoomPanAnimation();
  }

  void _handleFocalLatLngAnimation() {
    if (_focalLatLngTween.end != null) {
      _currentFocalLatLng = _focalLatLngTween.evaluate(_focalLatLngAnimation);
    }
    _handleZoomPanAnimation();
  }

  void _handleZoomPanAnimation() {
    setState(() {
      _handleTransform();
      if (_hasSublayer) {
        _controller.visibleFocalLatLng = _currentFocalLatLng;
        _controller.tileLayerZoomLevel = _currentZoomLevel;
        _invalidateSublayer();
      } else {
        _controller.notifyRefreshListeners();
      }
    });
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_zoomLevelTween.end != null && !_isZoomedUsingToolbar) {
        _invokeOnZooming(widget.zoomPanBehavior.zoomLevel, Offset.zero,
            Offset.zero, _currentFocalLatLng);
      } else {
        _isZoomedUsingToolbar = false;
      }
    }
  }

  void _handleFocalLatLngAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _focalLatLngTween.end != null) {
      final Offset previousFocalPoint =
          _pixelFromLatLng(_focalLatLngTween.begin, _currentZoomLevel);
      final Offset currentFocalPoint =
          _pixelFromLatLng(_focalLatLngTween.end, _currentZoomLevel);
      _invokeOnPanning(_currentZoomLevel,
          localFocalPoint: currentFocalPoint,
          touchStartLocalPoint: previousFocalPoint,
          newFocalLatLng: _currentFocalLatLng);
      _focalLatLngAnimationController.duration =
          const Duration(milliseconds: 650);
    }
  }

  // This method called when doing mouse wheel action in web.
  void _handleMouseWheelZooming(PointerSignalEvent event) {
    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior.enablePinching) {
      if (event is PointerScrollEvent) {
        widget.zoomPanBehavior.handleEvent(event);
        _gestureType = Gesture.scale;
        _mouseStartZoomLevel ??= _currentZoomLevel;
        _mouseCenterLatLng ??= _currentFocalLatLng;
        _mouseStartLocalPoint ??= event.localPosition;
        _mouseStartGlobalPoint ??= event.position;

        final Offset localPointCenterDiff = Offset(
            (_size.width / 2) - _mouseStartLocalPoint.dx,
            (_size.height / 2) - _mouseStartLocalPoint.dy);
        final Offset actualCenterPixelPosition =
            _pixelFromLatLng(_mouseCenterLatLng, _mouseStartZoomLevel);
        final Offset point = actualCenterPixelPosition - localPointCenterDiff;
        _touchStartLatLng =
            _latLngFromPixel(point, scale: _mouseStartZoomLevel);
        double scale = _controller.tileLayerLocalScale -
            (event.scrollDelta.dy / _size.height);
        _controller.tileLayerLocalScale = scale;
        final double newZoomLevel =
            _getZoomLevel(_mouseStartZoomLevel + log(scale) / ln2);
        // If the scale * _mouseStartZoomLevel value goes beyond
        // minZoomLevel, setted the min scale value.
        if (scale * _mouseStartZoomLevel <
            widget.zoomPanBehavior.minZoomLevel) {
          scale = widget.zoomPanBehavior.minZoomLevel / _mouseStartZoomLevel;
        }
        // If the scale * _mouseStartZoomLevel value goes beyond
        // maxZoomLevel, setted the max scale value.
        else if (scale * _mouseStartZoomLevel >
            widget.zoomPanBehavior.maxZoomLevel) {
          scale = widget.zoomPanBehavior.maxZoomLevel / _mouseStartZoomLevel;
        }

        _controller
          ..isInInteractive = true
          ..gesture = _gestureType
          ..localScale = scale
          ..pinchCenter = event.localPosition;
        final MapLatLng newFocalLatLng =
            _calculateVisibleLatLng(event.localPosition, newZoomLevel);
        _invokeOnZooming(newZoomLevel, _mouseStartLocalPoint,
            _mouseStartGlobalPoint, newFocalLatLng);

        _zoomingDelayTimer?.cancel();
        _zoomingDelayTimer = Timer(const Duration(milliseconds: 300), () {
          _invalidateSublayer();
          _controller.tileLayerLocalScale = 1.0;
          _mouseStartZoomLevel = null;
          _mouseStartLocalPoint = null;
          _mouseStartGlobalPoint = null;
          _gestureType = null;
          _mouseCenterLatLng = null;
        });
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    widget.zoomPanBehavior?.handleEvent(event);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    widget.zoomPanBehavior?.handleEvent(event);
  }

  void _handlePointerUp(PointerUpEvent event) {
    widget.zoomPanBehavior?.handleEvent(event);
  }

  // Check whether gesture type is scale or pan.
  Gesture _getGestureType(double scale, Offset focalPoint) {
    // The minimum distance required to start scale or pan gesture.
    final int minScaleDistance = 3;
    if (_touchStartLocalPoint != null) {
      final Offset distance = focalPoint - _touchStartLocalPoint;
      if (scale == 1) {
        final Offset distance = focalPoint - _touchStartLocalPoint;
        return distance.dx.abs() > minScaleDistance ||
                distance.dy.abs() > minScaleDistance
            ? Gesture.pan
            : null;
      }

      return (distance.dx.abs() > minScaleDistance ||
              distance.dy.abs() > minScaleDistance)
          ? Gesture.scale
          : null;
    }
    return null;
  }

  // This method invoked when user override the [onZooming] method in
  // [ZoomPanBehavior] and called [super.onZooming(details)].
  void _handleZooming(MapZoomDetails details) {
    if (_gestureType != null) {
      // Updating map while pinching and scrolling.
      _currentZoomLevel = details.newZoomLevel;
      _controller.tileLayerZoomLevel = _currentZoomLevel;
      _currentFocalLatLng = _newFocalLatLng;
      _controller.visibleFocalLatLng = _currentFocalLatLng;
      _controller.visibleLatLngBounds = details.newVisibleBounds;
      widget.zoomPanBehavior.focalLatLng = _currentFocalLatLng;
      setState(() {
        _handleTransform();
      });
    } else {
      // Updating map via toolbar.
      final Rect newVisibleBounds = Rect.fromCenter(
          center: _pixelFromLatLng(_currentFocalLatLng, details.newZoomLevel),
          width: _size.width,
          height: _size.height);
      _controller.visibleLatLngBounds = MapLatLngBounds(
          _latLngFromPixel(newVisibleBounds.topRight,
              scale: details.newZoomLevel),
          _latLngFromPixel(newVisibleBounds.bottomLeft,
              scale: details.newZoomLevel));
      _isZoomedUsingToolbar = true;
    }

    widget.zoomPanBehavior.zoomLevel = details.newZoomLevel;
  }

  // This method invoked when user override the [onPanning] method in
  // [ZoomPanBehavior] and called [super.onPanning(details)].
  void _handlePanning(MapPanDetails details) {
    setState(() {
      _currentFocalLatLng = _newFocalLatLng;
      widget.zoomPanBehavior.focalLatLng = _currentFocalLatLng;
      _controller.visibleFocalLatLng = _currentFocalLatLng;
      _controller.visibleLatLngBounds = details.newVisibleBounds;
      _handleTransform();
    });
  }

  // This method invoked when user called the [reset] method in
  // [ZoomPanBehavior].
  void _handleReset() {
    widget.zoomPanBehavior.zoomLevel = widget.zoomPanBehavior.minZoomLevel;
  }

  // Calculate new focal coordinate value while scaling, panning or mouse wheel
  // actions.
  MapLatLng _calculateVisibleLatLng(
      Offset localFocalPoint, double newZoomLevel) {
    final Offset focalStartPoint =
        _pixelFromLatLng(_touchStartLatLng, newZoomLevel);
    final Offset newCenterPoint = focalStartPoint -
        localFocalPoint +
        Offset(_size.width / 2, _size.height / 2);
    return _latLngFromPixel(newCenterPoint, scale: newZoomLevel);
  }

  // This method used to move each tile based on the amount of
  // translation and scaling value in the respective levels.
  Widget _getPositionedTiles(_MapTile tile) {
    final Offset tilePos = tile.tilePos;
    final MapZoomLevel level = tile.level;
    final double tileLeftPos =
        (tilePos.dx * level.scale) + level.translatePoint.dx;
    final double tileTopPos =
        (tilePos.dy * level.scale) + level.translatePoint.dy;

    return Positioned(
      left: tileLeftPos,
      top: tileTopPos,
      width: tileSize * level.scale,
      height: tileSize * level.scale,
      child: tile.image,
    );
  }

  // This method is used to request visual tiles and store it in a [_tiles]
  // collection.
  void _addTile(_MapTileCoordinate tileFactor) {
    final String tileFactorToKey = _tileFactorToKey(tileFactor);
    final String url = _getTileUrl(tileFactor.x, tileFactor.y, tileFactor.z);
    final MapZoomLevel level = _levels[tileFactor.z];
    final double tileLeftPos = (tileFactor.x * tileSize) - level.origin.dx;
    final double tileTopPos = (tileFactor.y * tileSize) - level.origin.dy;

    _tiles[tileFactorToKey] = _MapTile(
      coordinates: tileFactor,
      xyzKey: tileFactorToKey,
      tilePos: Offset(tileLeftPos, tileTopPos),
      level: _levels[tileFactor.z],
      image: Image.network(
        url,
        fit: BoxFit.fill,
      ),
    );
  }

  // Converts the [urlTemplate] format into respective map
  // providers URL format.
  String _getTileUrl(int x, int y, int z) {
    String previousLetter;
    String currentLetter;
    String url = '';

    if (widget.urlTemplate.contains('{quadkey}')) {
      final String quadKey = _getQuadKey(x, y, z);
      final splittedQuad = widget.urlTemplate.split('{quadkey}');
      url = splittedQuad[0] + quadKey + splittedQuad[1];
    } else {
      for (int i = 0; i < widget.urlTemplate.length; i++) {
        previousLetter = currentLetter;
        currentLetter = widget.urlTemplate[i];

        if (previousLetter == '{' && widget.urlTemplate[i] == 'x') {
          currentLetter = x.toString();
        } else if (previousLetter == '{' && widget.urlTemplate[i] == 'y') {
          currentLetter = y.toString();
        } else if (previousLetter == '{' && widget.urlTemplate[i] == 'z') {
          currentLetter = z.toString();
        }

        if (widget.urlTemplate[i] != '{' && widget.urlTemplate[i] != '}') {
          url += currentLetter;
        }
      }
    }
    return url;
  }

  // Converts the xyz coordinate into quadKey for bing map.
  String _getQuadKey(int x, int y, int z) {
    final StringBuffer quadKey = StringBuffer();
    for (int i = z; i > 0; i--) {
      int digit = 0;
      final int mask = 1 << (i - 1);
      if ((x & mask) != 0) {
        digit++;
      }
      if ((y & mask) != 0) {
        digit++;
        digit++;
      }
      quadKey.write(digit);
    }
    return quadKey.toString();
  }

  // Scale and transform the existing level tiles if the current zoom level
  // value is in-between the zoom levels i.e.,fractional value. Request
  // new tiles if the current zoom level value reached next zoom level.
  void _handleTransform() {
    final double tileZoom = _currentZoomLevel;
    if ((tileZoom - _nextZoomLevel).abs() >= 1) {
      // Request new tiles when next zoom level reached.
      _nextZoomLevel = tileZoom.toInt();
      _requestAndPopulateNewTiles();
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    } else {
      // Scale and transform the existing tiles.
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    }
  }

  // Calculate amount of scale and translation for all [_levels] while
  // scaling.
  void _updateZoomLevelTransforms(MapLatLng center, double zoom) {
    for (final key in _levels.keys) {
      _updateZoomLevelTransform(_levels[key], center, zoom);
    }
  }

  // Calculate amount of scale and translation for each zoom level while
  // scaling.
  void _updateZoomLevelTransform(
      MapZoomLevel level, MapLatLng center, double zoom) {
    if (level.origin == null) {
      return;
    }
    final double currentScale =
        getTotalTileWidth(zoom) / getTotalTileWidth(level.zoom);
    final Offset scaledPixelOrigin = _getLevelOrigin(center, zoom);
    level.translatePoint = Offset(
        (level.origin.dx * currentScale) - scaledPixelOrigin.dx,
        (level.origin.dy * currentScale) - scaledPixelOrigin.dy);
    level.scale = currentScale;

    if (level.zoom == _nextZoomLevel) {
      _controller.tileCurrentLevelDetails.translatePoint = level.translatePoint;
      _controller.tileCurrentLevelDetails.scale = level.scale;
    }
  }

  // Calculate tiles visual bounds origin for each new zoom level.
  MapZoomLevel _updateZoomLevel() {
    final int zoom = _nextZoomLevel;
    if (zoom == null) {
      return null;
    }

    // Remove zoom-out level tiles from the [_tiles] collection when doing
    // zoom-out action.
    final List<double> removePrevLevels = <double>[];
    for (final level in _levels.entries) {
      final double key = level.key;

      if (_levels.entries.length > 1) {
        if (zoom < key) {
          removePrevLevels.add(key);
        }
      }
    }

    for (final levelKey in removePrevLevels) {
      _removeTilesAtZoom(levelKey);
      _levels.remove(levelKey);
    }

    MapZoomLevel level = _levels[zoom];
    if (level == null) {
      // The [_levels] collection contains each integer zoom level origin,
      // scale and translationPoint. The scale and translationPoint are
      // calculated in every pinch zoom level for scaling the tiles.
      level = _levels[zoom.toDouble()] = MapZoomLevel();
      level.origin =
          _getLevelOrigin(_currentFocalLatLng, zoom.toDouble()) ?? Offset.zero;
      level.zoom = zoom.toDouble();

      if (_gestureType != null && _gestureType == Gesture.scale) {
        _updateZoomLevelTransform(
            level, _currentFocalLatLng, _currentZoomLevel);
      } else {
        level.scale = 1.0;
        level.translatePoint = Offset.zero;
      }
    }

    // Recalculate tiles bounds origin for all existing zoom level
    // when size changed.
    if (_isSizeChanged) {
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    }

    final double totalTileWidth = getTotalTileWidth(level.zoom);
    _controller
      ..totalTileSize = Size(totalTileWidth, totalTileWidth)
      ..tileCurrentLevelDetails = _levels[_nextZoomLevel];
    return level;
  }

  Offset _getLevelOrigin(MapLatLng center, double zoom) {
    final Offset halfSize = Offset(_size.width / 2.0, _size.height / 2.0);
    return _pixelFromLatLng(center, zoom) - halfSize;
  }

  void _removeTilesAtZoom(double zoom) {
    final List<String> removePrevTiles = <String>[];
    for (final tile in _tiles.entries) {
      if (tile.value.coordinates.z != zoom) {
        continue;
      }
      removePrevTiles.add(tile.key);
    }

    for (final key in removePrevTiles) {
      _removeTile(key);
    }
  }

  void _removeTile(String key) {
    final _MapTile tile = _tiles[key];
    if (tile == null) {
      return;
    }

    _tiles.remove(key);
  }

  String _tileFactorToKey(_MapTileCoordinate tileFactor) {
    return '${tileFactor.x}:${tileFactor.y}:${tileFactor.z}';
  }

  void refreshMarkers([MarkerAction action, List<int> indices]) {
    MapMarker marker;
    switch (action) {
      case MarkerAction.insert:
        int index = indices[0];
        assert(index <= widget.controller._markersCount);
        if (index > widget.controller._markersCount) {
          index = widget.controller._markersCount;
        }
        marker = widget.markerBuilder(context, index);
        if (index < widget.controller._markersCount) {
          _markers.insert(index, marker);
        } else if (index == widget.controller._markersCount) {
          _markers.add(marker);
        }
        widget.controller._markersCount++;
        break;
      case MarkerAction.removeAt:
        final int index = indices[0];
        assert(index < widget.controller._markersCount);
        _markers.removeAt(index);
        widget.controller._markersCount--;
        break;
      case MarkerAction.replace:
        for (final int index in indices) {
          assert(index < widget.controller._markersCount);
          marker = widget.markerBuilder(context, index);
          _markers[index] = marker;
        }
        break;
      case MarkerAction.clear:
        _markers.clear();
        widget.controller._markersCount = 0;
        break;
    }

    setState(() {
      // Rebuilds to visually update the markers when it was updated or added.
    });
  }
}

/// Represents the tile factor like x position, y position and scale value.
class _MapTileCoordinate {
  /// Creates a [_MapTileCoordinate].
  _MapTileCoordinate(this.x, this.y, this.z);

  /// Represents the x-coordinate of the tile.
  int x;

  /// Represents the y-coordinate of the tile.
  int y;

  /// Represents the scale value of the tile.
  int z;

  double distanceTo(Offset startPoint, Offset endPoint) {
    final double dx = startPoint.dx - endPoint.dx;
    final double dy = startPoint.dy - endPoint.dy;
    return sqrt(dx * dx + dy * dy);
  }

  @override
  String toString() => '_MapTileCoordinate($x, $y, $z)';

  @override
  bool operator ==(dynamic other) {
    if (other is _MapTileCoordinate) {
      return x == other.x && y == other.y && z == other.z;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(x.hashCode, y.hashCode, z.hashCode);
}

/// Provides the information about the current and previous zoom level.
class MapZoomLevel {
  /// Represents the visual tiles origin.
  Offset origin;

  /// Represents the tile zoom level.
  double zoom;

  /// Provides the distance moved from the origin when doing pinch zooming.
  Offset translatePoint;

  /// Represents the fractional zoom value.
  double scale;
}

/// Represents the information about the tile.
class _MapTile {
  /// Creates a [_MapTile].
  _MapTile({
    this.xyzKey,
    this.coordinates,
    this.tilePos,
    this.level,
    this.image,
  });

  /// Provides a unique key for each tile. The format of [xyzKey] looks `x:y:z`,
  /// where z denotes zoom level, x and y denotes tile coordinates.
  final String xyzKey;

  /// Represents the tile x-position, y-position and scale value.
  final _MapTileCoordinate coordinates;

  /// Represents the tile left and top position.
  final Offset tilePos;

  /// Represents the scale transform details of the tile.
  final MapZoomLevel level;

  /// Add tile to the image.
  final Widget image;

  @override
  int get hashCode => coordinates.hashCode;

  @override
  bool operator ==(other) {
    return other is _MapTile && coordinates == other.coordinates;
  }
}

class _TileLayerMarkerContainer extends Stack {
  _TileLayerMarkerContainer({
    Key tooltipKey,
    IndexedWidgetBuilder markerTooltipBuilder,
    List<Widget> children,
    MapController controller,
  })  : tooltipKey = tooltipKey,
        markerTooltipBuilder = markerTooltipBuilder,
        controller = controller,
        super(
          children: children ?? <Widget>[],
        );

  final Key tooltipKey;
  final IndexedWidgetBuilder markerTooltipBuilder;
  final MapController controller;

  @override
  _MapRenderTileMarker createRenderObject(BuildContext context) {
    return _MapRenderTileMarker(
      tooltipKey: tooltipKey,
      markerTooltipBuilder: markerTooltipBuilder,
      controller: controller,
      markerContainer: this,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _MapRenderTileMarker renderObject) {
    renderObject
      ..markerTooltipBuilder = markerTooltipBuilder
      ..markerContainer = this;
  }
}

class _MapRenderTileMarker extends RenderStack {
  _MapRenderTileMarker({
    this.tooltipKey,
    this.markerTooltipBuilder,
    this.state,
    this.markerContainer,
    this.controller,
  });

  Key tooltipKey;
  IndexedWidgetBuilder markerTooltipBuilder;
  MapController controller;
  _MapTileLayerState state;
  _TileLayerMarkerContainer markerContainer;

  int getMarkerIndex(MapMarker marker) {
    return markerContainer.children.indexOf(marker);
  }

  void _handleZooming(MapZoomDetails details) {
    markNeedsLayout();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsLayout();
  }

  void _handleReset() {
    markNeedsLayout();
  }

  void _handleRefresh() {
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    controller
      ..addZoomingListener(_handleZooming)
      ..addPanningListener(_handlePanning)
      ..addResetListener(_handleReset)
      ..addRefreshListener(_handleRefresh);
  }

  @override
  void detach() {
    controller
      ..removeZoomingListener(_handleZooming)
      ..removePanningListener(_handlePanning)
      ..removeResetListener(_handleReset)
      ..removeRefreshListener(_handleRefresh);
    super.detach();
  }

  @override
  void performLayout() {
    size = controller.tileLayerBoxSize;
    RenderBox child = firstChild;
    while (child != null) {
      final RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      child.layout(constraints, parentUsesSize: true);
      final Offset pixelValues = _pixelFromLatLng(
          MapLatLng(marker.latitude, marker.longitude),
          controller.tileCurrentLevelDetails.zoom);
      final MapZoomLevel level = controller.tileCurrentLevelDetails;
      final Offset translationOffset = pixelValues - level.origin;
      childParentData.offset = Offset(translationOffset.dx * level.scale,
              translationOffset.dy * level.scale) +
          level.translatePoint -
          Offset(child.size.width / 2, child.size.height / 2);
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    final Rect visibleRect =
        Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      final Rect childRect = Rect.fromLTWH(
          childParentData.offset.dx + offset.dx,
          childParentData.offset.dy + offset.dy,
          child.size.width,
          child.size.height);
      if (visibleRect.overlaps(childRect)) {
        context.paintChild(child, offset + childParentData.offset);
      }

      child = childParentData.nextSibling;
    }
  }
}
