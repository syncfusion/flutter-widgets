part of maps;

class _MarkerContainer extends Stack {
  _MarkerContainer({
    Key key,
    List<Widget> children,
    this.defaultController,
    this.state,
  }) : super(key: key, children: children ?? <Widget>[]);

  final _DefaultController defaultController;
  final _MapsShapeLayerState state;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderMarkerContainer()
      ..defaultController = defaultController
      ..state = state;
  }
}

class _RenderMarkerContainer extends RenderStack {
  _DefaultController defaultController;

  _MapsShapeLayerState state;

  double get shapeLayerSizeFactor =>
      defaultController.shapeLayerSizeFactor *
      (defaultController.gesture == _Gesture.scale
          ? defaultController.localScale
          : 1);

  Offset get shapeLayerOffset {
    if (!defaultController.isInInteractive) {
      return defaultController.shapeLayerOffset;
    } else {
      if (defaultController.gesture == _Gesture.scale) {
        return defaultController.getZoomingTranslation() +
            defaultController.adjustment;
      } else {
        return defaultController.shapeLayerOffset +
            defaultController.panDistance;
      }
    }
  }

  void _handleZooming(MapZoomDetails details) {
    _updateChildren();
    markNeedsPaint();
  }

  void _handlePanning(MapPanDetails details) {
    _updateChildren();
    markNeedsPaint();
  }

  void _handleReset() {
    _updateChildren();
    markNeedsPaint();
  }

  void _updateChildren() {
    final double factor = shapeLayerSizeFactor;
    final Offset translation = shapeLayerOffset;
    RenderBox child = firstChild;
    while (child != null) {
      final _RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      childParentData.offset = _pixelFromLatLng(
              marker.latitude, marker.longitude, size, translation, factor) -
          Offset(marker.size.width / 2, marker.size.height / 2);
      child = childParentData.nextSibling;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (defaultController != null) {
      defaultController.addZoomingListener(_handleZooming);
      defaultController.addPanningListener(_handlePanning);
      defaultController.addResetListener(_handleReset);
    }
  }

  @override
  void detach() {
    if (defaultController != null) {
      defaultController.removeZoomingListener(_handleZooming);
      defaultController.removePanningListener(_handlePanning);
      defaultController.removeResetListener(_handleReset);
    }
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = _getBoxSize(constraints);
    final double factor = shapeLayerSizeFactor;
    final Offset translation = shapeLayerOffset;
    RenderBox child = firstChild;
    while (child != null) {
      final _RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      child.layout(constraints, parentUsesSize: true);
      childParentData.offset = _pixelFromLatLng(
              marker.latitude, marker.longitude, size, translation, factor) -
          Offset(marker.size.width / 2, marker.size.height / 2);
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      final Rect childRect = Rect.fromLTWH(childParentData.offset.dx,
          childParentData.offset.dy, child.size.width, child.size.height);
      if (defaultController.visibleBounds.overlaps(childRect)) {
        context.paintChild(child, childParentData.offset);
      }
      child = childParentData.nextSibling;
    }
  }
}

/// Markers be used to denote the locations on the map.
///
/// It is possible to use the built-in symbols or display a custom widget at a
/// specific latitude and longitude on a map.
///
/// The [MapLayer.markerBuilder] callback will be called number of times equal
/// to the value specified in the [MapLayer.initialMarkersCount] property.
/// The default value of the of this property is null.
///
/// For rendering the custom widget for the marker, pass the required widget
/// for child in [MapMarker] constructor.
///
/// ```dart
/// List<Model> data;
///
/// @override
/// void initState() {
///    data = const <Model>[
///      Model('Brazil', -14.235004, -51.92528),
///      Model('Germany', 51.16569, 10.451526),
///      Model('Australia', -25.274398, 133.775136),
///      Model('India', 20.593684, 78.96288),
///      Model('Russia', 61.52401, 105.318756)
///    ];
///
///    super.initState();
/// }
///
///  @override
/// Widget build(BuildContext context) {
///    return Scaffold(
///      body: Center(
///          child: Container(
///            height: 350,
///            child: Padding(
///              padding: EdgeInsets.only(left: 15, right: 15),
///              child: SfMaps(
///                layers: <MapLayer>[
///                  MapShapeLayer(
///                    delegate: MapShapeLayerDelegate(
///                      shapeFile: 'assets/world_map.json',
///                      shapeDataField: 'name',
///                      dataCount: data.length,
///                      primaryValueMapper: (index) => data[index].country,
///                    ),
///                    initialMarkersCount: 5,
///                    markerBuilder: (BuildContext context, int index){
///                      return MapMarker(
///                        latitude: data[index].latitude,
///                        longitude: data[index].longitude,
///                      );
///                    },
///                  ),
///                ],
///              ),
///            ),
///          )
///      ),
///    );
///  }
///
/// class Model {
///  const Model(this.country, this.latitude, this.longitude);
///
///  final String country;
///  final double latitude;
///  final double longitude;
/// }
/// ```
/// See also:
/// * [MapShapeLayerController], for dynamically updating the markers.
class MapMarker extends SingleChildRenderObjectWidget {
  /// Creates a [MapMarker].
  const MapMarker({
    Key key,
    @required this.latitude,
    @required this.longitude,
    this.size,
    this.iconColor,
    this.iconStrokeColor,
    this.iconStrokeWidth = 1.0,
    this.iconType = MapIconType.circle,
    Widget child,
  })  : assert(longitude != null),
        assert(latitude != null),
        super(key: key, child: child);

  /// Sets the longitude for the marker on the map.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final double longitude;

  /// Sets the latitude for the marker on the map.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final double latitude;

  /// Sets the size for the marker on the map.
  ///
  /// Defaults to Size(14.0, 14.0).
  ///
  /// If child is given, then the size of the child will be the size of the
  /// marker.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        size: Size(18, 18),
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final Size size;

  /// Sets the icon color for the marker.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        iconColor: Colors.green[200],
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final Color iconColor;

  /// Sets the icon's stroke color for the marker.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        iconStrokeColor: Colors.green[900],
  ///                        iconStrokeWidth: 2,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final Color iconStrokeColor;

  /// Sets the icon's stroke width for the marker.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        iconStrokeColor: Colors.green[900],
  ///                        iconStrokeWidth: 2,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final double iconStrokeWidth;

  /// Sets the icon's shape of the marker.
  ///
  /// Defaults to [MapIconType.circle].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        iconStrokeColor: Colors.green[900],
  ///                        iconType: MapIconType.triangle,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],s
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  final MapIconType iconType;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMapMarker(
      longitude: longitude,
      latitude: latitude,
      markerSize: size,
      iconColor: iconColor,
      iconStrokeColor: iconStrokeColor,
      iconStrokeWidth: iconStrokeWidth,
      iconType: iconType,
      themeData: SfMapsTheme.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderMapMarker renderObject) {
    renderObject
      ..longitude = longitude
      ..latitude = latitude
      ..markerSize = size
      ..iconColor = iconColor
      ..iconStrokeColor = iconStrokeColor
      ..iconStrokeWidth = iconStrokeWidth
      ..iconType = iconType
      ..themeData = SfMapsTheme.of(context);
  }
}

class _RenderMapMarker extends RenderProxyBox {
  _RenderMapMarker({
    double longitude,
    double latitude,
    Size markerSize,
    Color iconColor,
    Color iconStrokeColor,
    double iconStrokeWidth,
    MapIconType iconType,
    SfMapsThemeData themeData,
  })  : _longitude = longitude,
        _latitude = latitude,
        _markerSize = markerSize,
        _iconColor = iconColor,
        _iconStrokeColor = iconStrokeColor,
        _iconStrokeWidth = iconStrokeWidth,
        _iconType = iconType,
        _themeData = themeData;

  final _MapIconShape _iconShape = const _MapIconShape();

  final Size _defaultMarkerSize = const Size(14.0, 14.0);

  double get latitude => _latitude;
  double _latitude;
  set latitude(double value) {
    if (_latitude == value) {
      return;
    }
    assert(value != null);
    _latitude = value;

    if (super.parent is _RenderMarkerContainer) {
      _updatePosition();
    }
    markNeedsPaint();
  }

  double get longitude => _longitude;
  double _longitude;
  set longitude(double value) {
    if (_longitude == value) {
      return;
    }
    assert(value != null);
    _longitude = value;

    if (super.parent is _RenderMarkerContainer) {
      _updatePosition();
    }
    markNeedsPaint();
  }

  Size get markerSize => _markerSize;
  Size _markerSize;
  set markerSize(Size value) {
    if (_markerSize == value) {
      return;
    }
    _markerSize = value;
    if (super.parent is _RenderMarkerContainer) {
      _updatePosition();
    }
    markNeedsLayout();
  }

  Color get iconColor => _iconColor;
  Color _iconColor;
  set iconColor(Color value) {
    if (_iconColor == value) {
      return;
    }
    _iconColor = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  Color get iconStrokeColor => _iconStrokeColor;
  Color _iconStrokeColor;
  set iconStrokeColor(Color value) {
    if (_iconStrokeColor == value) {
      return;
    }
    _iconStrokeColor = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  double get iconStrokeWidth => _iconStrokeWidth;
  double _iconStrokeWidth;
  set iconStrokeWidth(double value) {
    if (_iconStrokeWidth == value) {
      return;
    }
    assert(value != null);
    _iconStrokeWidth = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  MapIconType get iconType => _iconType;
  MapIconType _iconType;
  set iconType(MapIconType value) {
    if (_iconType == value) {
      return;
    }
    assert(value != null);
    _iconType = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  void _updatePosition() {
    final _RenderMarkerContainer parent = super.parent;
    final StackParentData childParentData = parentData;
    if (parent != null) {
      childParentData.offset = _pixelFromLatLng(
              _latitude,
              _longitude,
              parent.size,
              parent.shapeLayerOffset,
              parent.shapeLayerSizeFactor) -
          Offset(size.width / 2, size.height / 2);
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    if (_markerSize != null) {
      child?.layout(BoxConstraints.tight(_markerSize));
      size = _markerSize;
    } else {
      if (child != null) {
        child.layout(constraints.loosen(), parentUsesSize: true);
        size = child.size;
      } else {
        size = _defaultMarkerSize;
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      _iconShape.paint(context, offset,
          parentBox: this,
          themeData: _themeData,
          iconSize: size,
          color: _iconColor ?? _themeData.markerIconColor,
          strokeColor: _iconStrokeColor ?? _themeData.markerIconStrokeColor,
          strokeWidth: _iconStrokeWidth ?? _themeData.markerIconStrokeWidth,
          iconType: _iconType);
    } else {
      context.paintChild(child, offset);
    }
  }
}
