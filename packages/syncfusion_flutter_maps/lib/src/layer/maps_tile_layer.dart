part of maps;

/// Tile layer which renders the tiles returned from the Web Map Tile
/// Services (WMTS) like OpenStreetMap, Bing Maps, Google Maps, TomTom etc.
///
/// The [MapTileLayer.urlTemplate] accepts the URL in WMTS format 
/// i.e. {z} — zoom level, {x} and {y} — tile coordinates.
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
/// Please note that the format may vary between the each map providers. You can
/// check the exact URL format needed for the providers in their official 
/// websites.
///
/// Regarding the tile rendering, at the lowest zoom level (Level 0), the map is
/// 256 x 256 pixels and the
/// whole world map renders as a single tile. At each increase in level, the map
/// width and height grow by a factor of 2 i.e. Level 1 is 512 x 512 pixels with
/// 4 tiles ((0, 0), (0, 1), (1, 0), (1, 1) where 0 and 1 are {x} and {y} in
/// [MapTileLayer.urlTemplate]), Level 2 is 2048 x 2048 pixels with 8
/// tiles (from (0, 0) to (3, 3)), and so on.
/// (These details are just for your information and all these calculation are
/// done internally.)
///
/// However, based on the size of the [SfMaps] widget,
/// [MapTileLayer.initialFocalLatLng] and [MapTileLayer.initialZoomLevel] number
/// of initial tiles needed in the view port alone will be rendered. 
/// While zooming and panning, new tiles will be requested and rendered on 
/// demand based on the current zoom level and focal point.
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
/// * For enabling zooming and panning, set [MapTileLayer.zoomPanBehavior] 
/// with the instance of [MapZoomPanBehavior].
class MapTileLayer extends MapLayer {
  /// Creates a [MapTileLayer].
  MapTileLayer({
    Key key,
    @required this.urlTemplate,
    this.initialFocalLatLng = const MapLatLng(0.0, 0.0),
    this.initialZoomLevel = 1,
    this.controller,
    int initialMarkersCount = 0,
    MapMarkerBuilder markerBuilder,
    MapZoomPanBehavior zoomPanBehavior,
    WillZoomCallback onWillZoom,
    WillPanCallback onWillPan,
  })  : assert(initialZoomLevel >= 1 && initialZoomLevel <= 15),
        assert(initialMarkersCount == 0 ||
            initialMarkersCount != 0 && markerBuilder != null),
        super(
          key: key,
          initialMarkersCount: initialMarkersCount,
          markerBuilder: markerBuilder,
          zoomPanBehavior: zoomPanBehavior,
          onWillZoom: onWillZoom,
          onWillPan: onWillPan,
        );

  /// URL to request the tiles from the providers.
  ///
  /// The [MapTileLayer.urlTemplate] accepts the URL in WMTS format 
  /// i.e. {z} — zoom level, {x} and {y} — tile coordinates.
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
  /// include them in the [MapTileLayer.urlTemplate] itself as mentioned in 
  /// above example. Please note that the format may vary between the each 
  /// map providers. You can check the exact URL format needed for the providers
  /// in their official websites.
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
  /// For Bing maps, an additional step is required. The format of the required
  /// URL varies from the other tile services. Hence, we have added a top-level
  /// [getBingUrlTemplate] method which returns the URL in the required format.
  /// You can use the URL returned from this method to pass it to the
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
  ///
  /// Some of the providers provide different map types. For example, Bing Maps
  /// provide map types like Road, Aerial, AerialWithLabels etc. These types too
  /// can be passed in the [MapTileLayer.urlTemplate] itself as shown in the 
  /// above example. You can check the official websites of the tile providers 
  /// to know about the available types and the code for it.
  ///
  /// See also:
  /// * For Bing Maps, use the [getBingUrlTemplate] method to get the URL in
  /// required format and set it to the [MapTileLayer.urlTemplate].
  final String urlTemplate;

  /// Represents the initial focal latitude and longitude position.
  ///
  /// Based on the size of the [SfMaps] widget,[MapTileLayer.initialFocalLatLng]
  /// and [MapTileLayer.initialZoomLevel] number of initial tiles needed in the 
  /// view port alone will be rendered. While zooming and panning, new tiles 
  /// will be requested and rendered on demand based on the current zoom level 
  /// and focal point. The current zoom level and focal point can be obtained 
  /// from the [MapZoomPanBehavior.zoomLevel] and 
  /// [MapZoomPanBehavior.focalLatLng].
  ///
  /// This properties cannot be changed dynamically.
  ///
  /// Defaults to `MapLatLng(0.0, 0.0)`.
  ///
  /// See also:
  /// * For enabling zooming and panning, set [MapTileLayer.zoomPanBehavior] 
  /// with the instance of [MapZoomPanBehavior].
  /// * [MapZoomPanBehavior.focalLatLng], to dynamically change the center
  /// position.
  /// * [MapZoomPanBehavior.zoomLevel], to dynamically change the zoom level.
  final MapLatLng initialFocalLatLng;

  /// Represents the initial zooming level.
  ///
  /// Based on the size of the [SfMaps] widget,[MapTileLayer.initialFocalLatLng]
  /// and [MapTileLayer.initialZoomLevel] number of initial tiles needed in the 
  /// view port alone will be rendered. While zooming and panning, new tiles 
  /// will be requested and rendered on demand based on the current zoom level 
  /// and focal point. The current zoom level and focal point can be obtained 
  /// from the [MapZoomPanBehavior.zoomLevel] and 
  /// [MapZoomPanBehavior.focalLatLng].
  ///
  /// This properties cannot be changed dynamically.
  ///
  /// Defaults to 1.
  ///
  /// See also:
  /// * For enabling zooming and panning, set [MapTileLayer.zoomPanBehavior] 
  /// with the instance of [MapZoomPanBehavior].
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
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      zoomPanBehavior: zoomPanBehavior,
      controller: controller,
      onWillZoom: onWillZoom,
      onWillPan: onWillPan,
    );
  }
}

class _MapTileLayer extends StatefulWidget {
  _MapTileLayer({
    Key key,
    this.urlTemplate,
    this.initialFocalLatLng,
    this.initialZoomLevel,
    this.zoomPanBehavior,
    this.initialMarkersCount,
    this.markerBuilder,
    this.controller,
    this.onWillZoom,
    this.onWillPan,
  }) : super(key: key);

  /// Represents the actual map providers URL.
  final String urlTemplate;

  /// Represents the latitude and longitude position
  /// which is going to position at center of the widget.
  ///
  /// Defaults to MapLatLng(0.0, 0.0).
  final MapLatLng initialFocalLatLng;

  /// Represents the initial zoom level.
  ///
  /// Defaults to 1.
  final int initialZoomLevel;

  /// Option to configure the zooming.
  final MapZoomPanBehavior zoomPanBehavior;

  /// Represents the number of markers needed at load time.
  final int initialMarkersCount;
  final MapMarkerBuilder markerBuilder;
  final MapTileLayerController controller;
  final WillZoomCallback onWillZoom;
  final WillPanCallback onWillPan;

  @override
  _MapTileLayerState createState() => _MapTileLayerState();
}

class _MapTileLayerState extends State<_MapTileLayer> {
  // Both width and height of each tile is 256.
  static const double tileSize = 256;

  // The [_defaultController] handles the events of the [ZoomPanBehavior].
  _DefaultController _defaultController;

  // Stores the integer zoom level in the [_roundedZoomLevel] field
  // like 1, 2, 3 etc.
  int _roundedZoomLevel;

  // Stores the current zoom level in the [_currentZoomLevel] field
  // like 1, 1.1, 1.2 etc.
  double _currentZoomLevel;
  double _touchStartZoomLevel;
  MapLatLng _touchStartLatLng;
  MapLatLng _currentFocalLatLng;
  Offset _touchStartLocalPoint;
  Offset _touchStartGlobalPoint;
  Size _size;
  _Gesture _gestureType;
  bool _isSizeChanged = false;
  bool _canRequestNewTiles = false;
  final Map<String, _MapTile> _tiles = {};
  final Map<double, _MapZoomLevel> _levels = {};
  List<Widget> _markers;
  MapZoomDetails _zoomDetails;
  MapPanDetails _panDetails;
  Timer _zoomingDelayTimer;
  MapLatLng _mouseCenterLatLng;
  double _mouseStartZoomLevel;
  Offset _mouseStartLocalPoint;
  Offset _mouseStartGlobalPoint;

  @override
  void initState() {
    super.initState();
    _currentFocalLatLng =
        widget.zoomPanBehavior?.focalLatLng ?? widget.initialFocalLatLng;
    _currentZoomLevel = (widget.zoomPanBehavior != null &&
            widget.zoomPanBehavior.zoomLevel != 1)
        ? widget.zoomPanBehavior.zoomLevel
        : widget.initialZoomLevel.toDouble();
    widget.zoomPanBehavior?.zoomLevel = _currentZoomLevel;
    _roundedZoomLevel = _currentZoomLevel.floor();

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

    _defaultController = _DefaultController();
    widget.zoomPanBehavior?._controller = _defaultController;
    widget.controller?.addListener(refreshMarkers);
    _defaultController?.addZoomingListener(_handleZooming);
    _defaultController?.addPanningListener(_handlePanning);
    _defaultController?.addResetListener(_handleReset);

    _defaultController
      ..onZoomLevelChange = _handleZoomTo
      ..onPanChange = _handlePanTo;
  }

  @override
  void didUpdateWidget(_MapTileLayer oldWidget) {
    if (oldWidget.zoomPanBehavior != widget.zoomPanBehavior) {
      widget.zoomPanBehavior?._controller = _defaultController;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _defaultController?.removeZoomingListener(_handleZooming);
    _defaultController?.removePanningListener(_handlePanning);
    _defaultController?.removeResetListener(_handleReset);
    widget.controller?.removeListener(refreshMarkers);
    _defaultController?.dispose();
    _markers.clear();
    _tiles?.clear();
    _levels?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (_size != null) {
          _isSizeChanged = _size.width != constraints.maxWidth ||
              _size.height != constraints.maxHeight;
        }

        _size = _getBoxSize(constraints);
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
              child: _getTileLayerElements(),
            ),
          ),
        );
      },
    );
  }

  // Add elements in the tile layer.
  Widget _getTileLayerElements() {
    final List<Widget> children = <Widget>[];

    children.add(_getTiles());
    if (_markers != null && _markers.isNotEmpty) {
      children.add(_MapTileMarkerRenderObject(
        children: _markers,
        state: this,
      ));
    }

    if (widget.zoomPanBehavior != null) {
      children.add(_BehaviorViewRenderObjectWidget(
        defaultController: _defaultController,
        zoomPanBehavior: widget.zoomPanBehavior,
      ));
    }

    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior.showToolbar &&
        kIsWeb) {
      children.add(
        _MapToolbar(
          onWillZoom: widget.onWillZoom,
          zoomPanBehavior: widget.zoomPanBehavior,
          defaultController: _defaultController,
        ),
      );
    }

    return Stack(
      children: children,
    );
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
    if (_gestureType != null &&
        _gestureType != _Gesture.pan &&
        !_canRequestNewTiles) {
      return;
    }

    _updateZoomLevel();
    final double tileCount = pow(2, _roundedZoomLevel).toDouble();
    final Offset actualCenterPixelPosition =
        _getPixelFromLatLng(_currentFocalLatLng, _roundedZoomLevel.toDouble());

    final Offset halfSize = Offset(_size.width, _size.height) / 2;

    // The [globalTileStart] and [globalTileEnd] represents the tile start and
    // end factor value based on the zoom level.
    final Offset globalTileStart = Offset(0, 0);
    final Offset globalTileEnd = Offset(tileCount - 1, tileCount - 1);

    // The [visualTileStart] and [visualTileEnd] represents the visual
    // bounds of the tiles in pixel based on the [focalLatLng] value.
    final Offset visualTileStart = actualCenterPixelPosition - halfSize;
    final Offset visualTileEnd = actualCenterPixelPosition + halfSize;

    // The [startX], [startY], [endX] and [endY] represents the visual
    // bounds of the tiles in factor.
    final int startX = (visualTileStart.dx / tileSize).floor();
    final int startY = (visualTileStart.dy / tileSize).floor();
    final int endX = (visualTileEnd.dx / tileSize).ceil();
    final int endY = (visualTileEnd.dy / tileSize).ceil();
    final List<_MapTileCoordinate> tileCoordinates = <_MapTileCoordinate>[];

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        final _MapTileCoordinate tileCoordinate =
            _MapTileCoordinate(i, j, _roundedZoomLevel);

        if ((tileCoordinate.x < globalTileStart.dx ||
                tileCoordinate.x > globalTileEnd.dx) ||
            (tileCoordinate.y < globalTileStart.dy ||
                tileCoordinate.y > globalTileEnd.dy)) {
          continue;
        }
        tileCoordinates.add(tileCoordinate);
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
        _gestureType = null;
        _touchStartLocalPoint = details.localFocalPoint;
        _touchStartGlobalPoint = details.focalPoint;
        _touchStartZoomLevel = _currentZoomLevel.toDouble();
        final Offset localPointCenterDiff = Offset(
            (_size.width / 2) - _touchStartLocalPoint.dx,
            (_size.height / 2) - _touchStartLocalPoint.dy);
        final Offset actualCenterPixelPosition =
            _getPixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel);
        final Offset point = actualCenterPixelPosition - localPointCenterDiff;
        _touchStartLatLng =
            _getLatLngFromPixel(point, scale: _touchStartZoomLevel);

        final Rect newVisibleBounds = Rect.fromCenter(
            center:
                _getPixelFromLatLng(_currentFocalLatLng, _touchStartZoomLevel),
            width: _size.width,
            height: _size.height);
        final MapLatLngBounds newVisibleLatLng = MapLatLngBounds(
            _getLatLngFromPixel(newVisibleBounds.topRight,
                scale: _touchStartZoomLevel),
            _getLatLngFromPixel(newVisibleBounds.bottomLeft,
                scale: _touchStartZoomLevel));

        _zoomDetails = MapZoomDetails(
          newVisibleBounds: newVisibleLatLng,
        ).._newFocalLatLng = _currentFocalLatLng;

        _panDetails = MapPanDetails(
          newVisibleBounds: newVisibleLatLng,
        ).._newFocalLatLng = _currentFocalLatLng;
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

      final double newZoomLevel =
          _getZoomLevel(_touchStartZoomLevel + log(details.scale) / ln2);
      final MapLatLng newFocalLatLng =
          _calculateVisibleLatLng(details.localFocalPoint, newZoomLevel);
      switch (_gestureType) {
        case _Gesture.scale:
          if (widget.zoomPanBehavior.enablePinching) {
            _invokeOnZooming(newZoomLevel, _touchStartLocalPoint,
                _touchStartGlobalPoint, newFocalLatLng);
          }
          return;
        case _Gesture.pan:
          if (widget.zoomPanBehavior.enablePanning) {
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
    _gestureType = null;
    _panDetails = null;
    _zoomDetails = null;
  }

  // This method called for both pinch zooming action and mouse wheel zooming
  // action for passing [MapZoomDetails] parameters to notify user about the
  // zooming details.
  void _invokeOnZooming(double newZoomLevel,
      [Offset localFocalPoint,
      Offset globalFocalPoint,
      MapLatLng newFocalLatLng]) {
    final Rect newVisibleBounds = Rect.fromCenter(
        center: _getPixelFromLatLng(newFocalLatLng, newZoomLevel),
        width: _size.width,
        height: _size.height);

    _zoomDetails = MapZoomDetails(
        localFocalPoint: localFocalPoint,
        globalFocalPoint: globalFocalPoint,
        previousZoomLevel: widget.zoomPanBehavior.zoomLevel,
        newZoomLevel: newZoomLevel,
        previousVisibleBounds: _zoomDetails != null
            ? _zoomDetails.newVisibleBounds
            : _defaultController.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _getLatLngFromPixel(newVisibleBounds.topRight, scale: newZoomLevel),
            _getLatLngFromPixel(newVisibleBounds.bottomLeft,
                scale: newZoomLevel)))
      .._newFocalLatLng = newFocalLatLng;

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
        center: _getPixelFromLatLng(newFocalLatLng, newZoomLevel),
        width: _size.width,
        height: _size.height);

    _panDetails = MapPanDetails(
        globalFocalPoint: globalFocalPoint,
        localFocalPoint: localFocalPoint,
        zoomLevel: widget.zoomPanBehavior.zoomLevel,
        delta: localFocalPoint - touchStartLocalPoint,
        previousVisibleBounds: _panDetails != null
            ? _panDetails.newVisibleBounds
            : _defaultController.visibleLatLngBounds,
        newVisibleBounds: MapLatLngBounds(
            _getLatLngFromPixel(newVisibleBounds.topRight, scale: newZoomLevel),
            _getLatLngFromPixel(newVisibleBounds.bottomLeft,
                scale: newZoomLevel)))
      .._newFocalLatLng = newFocalLatLng;

    if (widget.onWillPan == null || widget.onWillPan(_panDetails)) {
      widget.zoomPanBehavior?.onPanning(_panDetails);
    }
  }

  // Restricting new zoom level value either to
  // [widget.zoomPanBehavior.minZoomLevel] or
  // [widget.zoomPanBehavior.maxZoomLevel] if the new zoom level value is not
  // in zoom level range.
  double _getZoomLevel(double scale) {
    return scale.isNaN
        ? widget.zoomPanBehavior.minZoomLevel
        : _interpolateValue(
            scale,
            widget.zoomPanBehavior.minZoomLevel,
            widget.zoomPanBehavior.maxZoomLevel,
          );
  }

  // This method called when dynamically changing the [zoomLevel] property of
  // ZoomPanBehavior.
  void _handleZoomTo(double zoomLevel, {MapLatLng latlng}) {
    if (_gestureType == null) {
      _invokeOnZooming(widget.zoomPanBehavior.zoomLevel, Offset.zero,
          Offset.zero, latlng ?? _currentFocalLatLng);
    }
  }

  // This method called when dynamically changing the [focalLatLng] property of
  // ZoomPanBehavior.
  void _handlePanTo(MapLatLng latlng) {
    if (_gestureType == null && widget.zoomPanBehavior.focalLatLng != null) {
      _invokeOnPanning(widget.zoomPanBehavior.zoomLevel,
          localFocalPoint: Offset.zero,
          globalFocalPoint: Offset.zero,
          touchStartLocalPoint: Offset.zero,
          newFocalLatLng: widget.zoomPanBehavior.focalLatLng);
    }
  }

  // This method called when doing mouse wheel action in web.
  void _handleMouseWheelZooming(PointerSignalEvent event) {
    if (widget.zoomPanBehavior != null &&
        widget.zoomPanBehavior.enablePinching) {
      if (event is PointerScrollEvent) {
        widget.zoomPanBehavior.handleEvent(event, null);
        _gestureType = _Gesture.scale;
        _mouseStartZoomLevel ??= _currentZoomLevel;
        _mouseCenterLatLng ??= _currentFocalLatLng;
        _mouseStartLocalPoint ??= event.localPosition;
        _mouseStartGlobalPoint ??= event.position;

        final Offset localPointCenterDiff = Offset(
            (_size.width / 2) - _mouseStartLocalPoint.dx,
            (_size.height / 2) - _mouseStartLocalPoint.dy);
        final Offset actualCenterPixelPosition =
            _getPixelFromLatLng(_mouseCenterLatLng, _mouseStartZoomLevel);
        final Offset point = actualCenterPixelPosition - localPointCenterDiff;
        _touchStartLatLng =
            _getLatLngFromPixel(point, scale: _mouseStartZoomLevel);

        final double scale = _defaultController.localScale -
            (event.scrollDelta.dy / _size.height);
        final double newZoomLevel =
            _getZoomLevel(_mouseStartZoomLevel + log(scale) / ln2);
        _defaultController.localScale = scale;
        final MapLatLng newFocalLatLng =
            _calculateVisibleLatLng(event.localPosition, newZoomLevel);
        _invokeOnZooming(newZoomLevel, _mouseStartLocalPoint,
            _mouseStartGlobalPoint, newFocalLatLng);

        _zoomingDelayTimer?.cancel();
        _zoomingDelayTimer = Timer(const Duration(milliseconds: 300), () {
          _defaultController.localScale = 1.0;
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
    widget.zoomPanBehavior?.handleEvent(event, null);
  }

  void _handlePointerMove(PointerMoveEvent event) {
    widget.zoomPanBehavior?.handleEvent(event, null);
  }

  void _handlePointerUp(PointerUpEvent event) {
    widget.zoomPanBehavior?.handleEvent(event, null);
  }

  // Check whether gesture type is scale or pan.
  _Gesture _getGestureType(double scale, Offset focalPoint) {
    // The minimum distance required to start scale or pan gesture.
    final int minScaleDistance = 3;
    if (_touchStartLocalPoint != null) {
      final Offset distance = focalPoint - _touchStartLocalPoint;
      if (scale == 1) {
        final Offset distance = focalPoint - _touchStartLocalPoint;
        return distance.dx.abs() > minScaleDistance ||
                distance.dy.abs() > minScaleDistance
            ? _Gesture.pan
            : null;
      }

      return (distance.dx.abs() > minScaleDistance ||
              distance.dy.abs() > minScaleDistance)
          ? _Gesture.scale
          : null;
    }
    return null;
  }

  // This method invoked when user override the [onZooming] method in
  // [ZoomPanBehavior] and called [super.onZooming(details)].
  void _handleZooming(MapZoomDetails details) {
    _currentZoomLevel = details.newZoomLevel;
    if (_gestureType != null) {
      // Updating map while pinching and scrolling.
      _currentFocalLatLng = details._newFocalLatLng;
      _defaultController.visibleFocalLatLng = _currentFocalLatLng;
      _defaultController.visibleLatLngBounds = details.newVisibleBounds;
      widget.zoomPanBehavior.focalLatLng = _currentFocalLatLng;
    } else {
      // Updating map via toolbar.
      final Rect newVisibleBounds = Rect.fromCenter(
          center: _getPixelFromLatLng(_currentFocalLatLng, _currentZoomLevel),
          width: _size.width,
          height: _size.height);
      _defaultController.visibleLatLngBounds = MapLatLngBounds(
          _getLatLngFromPixel(newVisibleBounds.topRight,
              scale: _currentZoomLevel),
          _getLatLngFromPixel(newVisibleBounds.bottomLeft,
              scale: _currentZoomLevel));
    }

    setState(() {
      _handleTransform();
    });

    widget.zoomPanBehavior.zoomLevel = details.newZoomLevel;
  }

  // This method invoked when user override the [onPanning] method in
  // [ZoomPanBehavior] and called [super.onPanning(details)].
  void _handlePanning(MapPanDetails details) {
    setState(() {
      _currentFocalLatLng = details._newFocalLatLng;
      widget.zoomPanBehavior.focalLatLng = _currentFocalLatLng;
      _defaultController.visibleFocalLatLng = _currentFocalLatLng;
      _defaultController.visibleLatLngBounds = details.newVisibleBounds;
      _handleTransform();
    });
  }

  // This method invoked when user called the [reset] method in
  // [ZoomPanBehavior].
  void _handleReset() {
    setState(() {
      _currentZoomLevel = widget.zoomPanBehavior.minZoomLevel;
      widget.zoomPanBehavior.zoomLevel = widget.zoomPanBehavior.minZoomLevel;
      _handleTransform();
    });
  }

  // Calculate new focal coordinate value while scaling, panning or mouse wheel
  // actions.
  MapLatLng _calculateVisibleLatLng(
      Offset localFocalPoint, double newZoomLevel) {
    final Offset focalStartPoint =
        _getPixelFromLatLng(_touchStartLatLng, newZoomLevel);
    final Offset newCenterPoint = focalStartPoint -
        localFocalPoint +
        Offset(_size.width / 2, _size.height / 2);
    return _getLatLngFromPixel(newCenterPoint, scale: newZoomLevel);
  }

  // This method used to move each tile based on the amount of
  // translation and scaling value in the respective levels.
  Widget _getPositionedTiles(_MapTile tile) {
    final Offset tilePos = tile.tilePos;
    final _MapZoomLevel level = tile.level;
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
    final _MapZoomLevel level = _levels[tileFactor.z];
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

  // Converts the [MapTileLayer.urlTemplate] format into respective map
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
    if ((tileZoom - _roundedZoomLevel).abs() >= 1) {
      // Request new tiles when next zoom level reached.
      _canRequestNewTiles = true;
      _roundedZoomLevel = tileZoom.toInt();
      _requestAndPopulateNewTiles();
      _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
    } else {
      // Scale and transform the existing tiles.
      _canRequestNewTiles = false;
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
      _MapZoomLevel level, MapLatLng center, double zoom) {
    final double scaleDiff =
        _getTotalTileWidth(zoom) / _getTotalTileWidth(level.zoom);
    final Offset scaledPixelOrigin = _getLevelOrigin(center, zoom);
    if (level.origin == null) {
      return;
    }

    level.translatePoint = Offset(
        (level.origin.dx * scaleDiff) - scaledPixelOrigin.dx,
        (level.origin.dy * scaleDiff) - scaledPixelOrigin.dy);
    level.scale = scaleDiff;
  }

  // Calculate tiles visual bounds origin for each new zoom level.
  _MapZoomLevel _updateZoomLevel() {
    final int zoom = _roundedZoomLevel;
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

    _MapZoomLevel level = _levels[zoom];
    if (level == null) {
      // The [_levels] collection contains each integer zoom level origin,
      // scale and translationPoint. The scale and translationPoint are
      // calculated in every pinch zoom level for scaling the tiles.
      level = _levels[zoom.toDouble()] = _MapZoomLevel();
      level.origin =
          _getLevelOrigin(_currentFocalLatLng, zoom.toDouble()) ?? Offset.zero;
      level.zoom = zoom.toDouble();

      if (_gestureType != null && _gestureType == _Gesture.scale) {
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
      for (final level in _levels.entries) {
        _levels[level.key].origin = _getLevelOrigin(
                _currentFocalLatLng, _levels[level.key].zoom.toDouble()) ??
            Offset.zero;
        _updateZoomLevelTransforms(_currentFocalLatLng, _currentZoomLevel);
      }
    }

    return level;
  }

  Offset _getLevelOrigin(MapLatLng center, double zoom) {
    final Offset halfSize = Offset(_size.width / 2.0, _size.height / 2.0);
    return _getPixelFromLatLng(center, zoom) - halfSize;
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

  void refreshMarkers() {
    MapMarker marker;
    switch (widget.controller._markerAction) {
      case _MarkerAction.insert:
        marker = widget.markerBuilder(context, widget.controller._index);
        if (widget.controller._index < widget.controller._markersCount) {
          _markers.insert(widget.controller._index, marker);
        } else if (widget.controller._index ==
            widget.controller._markersCount) {
          _markers.add(marker);
        }
        widget.controller._markersCount++;
        break;
      case _MarkerAction.removeAt:
        assert(widget.controller._index < widget.controller._markersCount);
        _markers.removeAt(widget.controller._index);
        widget.controller._markersCount--;
        break;
      case _MarkerAction.replace:
        for (final int index in widget.controller._replaceableIndices) {
          assert(index < widget.controller._markersCount);
          marker = widget.markerBuilder(context, index);
          assert(marker != null);
          _markers[index] = marker;
        }
        break;
      case _MarkerAction.clear:
        _markers.clear();
        widget.controller._markersCount = 0;
        break;
      case _MarkerAction.none:
        break;
    }

    widget.controller._index = -1;

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
class _MapZoomLevel {
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
  final _MapZoomLevel level;

  /// Add tile to the image.
  final Widget image;

  @override
  int get hashCode => coordinates.hashCode;

  @override
  bool operator ==(other) {
    return other is _MapTile && coordinates == other.coordinates;
  }
}

class _MapTileMarkerRenderObject extends Stack {
  _MapTileMarkerRenderObject({
    Key key,
    List<Widget> children,
    _MapTileLayerState state,
  })  : state = state,
        super(
          key: key,
          children: children ?? <Widget>[],
        );

  final _MapTileLayerState state;

  @override
  _MapRenderTileMarker createRenderObject(BuildContext context) {
    return _MapRenderTileMarker(state: state);
  }
}

class _MapRenderTileMarker extends RenderStack {
  _MapRenderTileMarker({this.state});

  _MapTileLayerState state;

  void _handleZooming(MapZoomDetails details) {
    markNeedsLayout();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsLayout();
  }

  void _handleReset() {
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    state._defaultController.addZoomingListener(_handleZooming);
    state._defaultController.addPanningListener(_handlePanning);
    state._defaultController.addResetListener(_handleReset);
  }

  @override
  void detach() {
    state._defaultController.removeZoomingListener(_handleZooming);
    state._defaultController.removePanningListener(_handlePanning);
    state._defaultController.removeResetListener(_handleReset);
    super.detach();
  }

  @override
  void performLayout() {
    size = state._size;
    RenderBox child = firstChild;
    while (child != null) {
      final _RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      child.layout(constraints, parentUsesSize: true);
      final Offset pixelValues = _getPixelFromLatLng(
          MapLatLng(marker.latitude, marker.longitude),
          state._roundedZoomLevel.toDouble());
      final _MapZoomLevel level =
          state._levels[state._roundedZoomLevel.toDouble()];
      final Offset translationOffset = pixelValues - level.origin;
      childParentData.offset = Offset(translationOffset.dx * level.scale,
              translationOffset.dy * level.scale) +
          level.translatePoint;
      if (marker.child != null) {
        childParentData.offset -=
            Offset(child.size.width / 2, child.size.height / 2);
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      final Rect childRect = Rect.fromLTWH(
          childParentData.offset.dx + offset.dx,
          childParentData.offset.dy + offset.dy,
          child.size.width,
          child.size.height);
      final Rect visibleRect =
          Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

      if (visibleRect.overlaps(childRect)) {
        context.paintChild(child, offset + childParentData.offset);
      }

      child = childParentData.nextSibling;
    }
  }
}
