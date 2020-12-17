import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../behavior/zoom_pan_behavior.dart';
import '../controller/default_controller.dart';
import '../enum.dart';
import '../layer/layer_base.dart';
import '../layer/shape_layer.dart';
import '../utils.dart';
import 'shapes.dart';

// ignore_for_file: public_member_api_docs
class ShapeLayerMarkerContainer extends Stack {
  ShapeLayerMarkerContainer({
    this.tooltipKey,
    this.markerTooltipBuilder,
    List<Widget> children,
    this.controller,
    this.sublayer,
  }) : super(children: children ?? <Widget>[]);

  final GlobalKey tooltipKey;
  final IndexedWidgetBuilder markerTooltipBuilder;
  final MapController controller;
  final MapShapeSublayer sublayer;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderMarkerContainer()
      ..tooltipKey = tooltipKey
      ..markerTooltipBuilder = markerTooltipBuilder
      ..controller = controller
      ..sublayer = sublayer
      ..markerContainer = this;
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderMarkerContainer renderObject) {
    renderObject
      ..markerTooltipBuilder = markerTooltipBuilder
      ..sublayer = sublayer
      ..markerContainer = this;
  }
}

class _RenderMarkerContainer extends RenderStack {
  GlobalKey tooltipKey;

  IndexedWidgetBuilder markerTooltipBuilder;

  MapController controller;

  MapShapeSublayer sublayer;

  ShapeLayerMarkerContainer markerContainer;

  int getMarkerIndex(MapMarker marker) {
    return markerContainer.children.indexOf(marker);
  }

  Size get markerContainerSize =>
      controller.isTileLayerChild ? controller.getTileSize() : size;

  double get shapeLayerSizeFactor => controller.isTileLayerChild
      ? controller.shapeLayerSizeFactor
      : (controller.shapeLayerSizeFactor *
          ((controller.gesture == Gesture.scale) ? controller.localScale : 1));

  Offset get shapeLayerOffset {
    if (!controller.isInInteractive) {
      return controller.shapeLayerOffset;
    } else {
      if (controller.gesture == Gesture.scale) {
        return controller.getZoomingTranslation() + controller.normalize;
      } else {
        return controller.shapeLayerOffset + controller.panDistance;
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

  void _handleRefresh() {
    _updateChildren();
    markNeedsPaint();
  }

  void _updateChildren() {
    final double factor = shapeLayerSizeFactor;
    final Offset translation = shapeLayerOffset;
    RenderBox child = firstChild;
    while (child != null) {
      final RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      childParentData.offset = pixelFromLatLng(marker.latitude,
              marker.longitude, markerContainerSize, translation, factor) -
          Offset(marker.size.width / 2, marker.size.height / 2);
      child = childParentData.nextSibling;
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (controller == null) {
      final RenderShapeLayer subLayerParent = parent.parent;
      controller = subLayerParent.controller;
    }

    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset)
        ..addRefreshListener(_handleRefresh);
    }
  }

  @override
  void detach() {
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset)
        ..removeRefreshListener(_handleRefresh);
    }
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = getBoxSize(constraints);
    final double factor = shapeLayerSizeFactor;
    final Offset translation = shapeLayerOffset;
    RenderBox child = firstChild;
    while (child != null) {
      final RenderMapMarker marker = child;
      final StackParentData childParentData = child.parentData;
      child.layout(constraints, parentUsesSize: true);
      childParentData.offset = pixelFromLatLng(marker.latitude,
              marker.longitude, markerContainerSize, translation, factor) -
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
      if (sublayer != null || controller.visibleBounds.overlaps(childRect)) {
        context.paintChild(child, childParentData.offset);
      }
      child = childParentData.nextSibling;
    }
  }
}

/// Markers can be used to denote the locations on the map.
///
/// It is possible to use the built-in symbols or display a custom widget at a
/// specific latitude and longitude on a map.
///
/// The [MapLayer.markerBuilder] callback will be called number of times equal
/// to the value specified in the [MapLayer.initialMarkersCount] property.
/// The default value of this property is null.
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
///                    source: MapShapeSource.asset(
///                      'assets/world_map.json',
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
/// * [MapShapeLayerController], [MapTileLayerController] for dynamically
/// updating the markers.
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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
  final double latitude;

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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
  final double longitude;

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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
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
  ///                    source: MapShapeSource.asset(
  ///                      'assets/world_map.json',
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
  /// * [MapShapeLayerController], [MapTileLayerController] for dynamically
  /// updating the markers.
  final MapIconType iconType;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMapMarker(
      longitude: longitude,
      latitude: latitude,
      markerSize: size,
      iconColor: iconColor,
      iconStrokeColor: iconStrokeColor,
      iconStrokeWidth: iconStrokeWidth,
      iconType: iconType,
      themeData: SfMapsTheme.of(context),
      marker: this,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMapMarker renderObject) {
    renderObject
      ..longitude = longitude
      ..latitude = latitude
      ..markerSize = size
      ..iconColor = iconColor
      ..iconStrokeColor = iconStrokeColor
      ..iconStrokeWidth = iconStrokeWidth
      ..iconType = iconType
      ..themeData = SfMapsTheme.of(context)
      ..marker = this;
  }
}

class RenderMapMarker extends RenderProxyBox implements MouseTrackerAnnotation {
  RenderMapMarker({
    double longitude,
    double latitude,
    Size markerSize,
    Color iconColor,
    Color iconStrokeColor,
    double iconStrokeWidth,
    MapIconType iconType,
    SfMapsThemeData themeData,
    MapMarker marker,
  })  : _longitude = longitude,
        _latitude = latitude,
        _markerSize = markerSize,
        _iconColor = iconColor,
        _iconStrokeColor = iconStrokeColor,
        _iconStrokeWidth = iconStrokeWidth,
        _iconType = iconType,
        _themeData = themeData,
        marker = marker {
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final MapIconShape _iconShape = const MapIconShape();

  final Size _defaultMarkerSize = const Size(14.0, 14.0);

  TapGestureRecognizer _tapGestureRecognizer;

  MapMarker marker;

  double get latitude => _latitude;
  double _latitude;
  set latitude(double value) {
    if (_latitude == value) {
      return;
    }
    assert(value != null);
    _latitude = value;

    if (parent is _RenderMarkerContainer) {
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

    if (parent is _RenderMarkerContainer) {
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
    if (parent is _RenderMarkerContainer) {
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

  void _handleTapUp(TapUpDetails details) {
    _handleInteraction();
  }

  void _handlePointerEnter(PointerEnterEvent event) {
    _handleInteraction();
  }

  void _handlePointerExit(PointerExitEvent event) {
    _handleInteraction(isExit: true);
  }

  void _handleInteraction({bool isExit = false}) {
    // For [MapMarker] shape and tile layer, we had different parent classes.
    // So, we used the dynamic keyword to access both parent commonly.
    final dynamic markerParent = parent;
    int sublayerIndex;
    if (markerParent.markerTooltipBuilder != null) {
      if (markerParent is _RenderMarkerContainer &&
          markerParent.sublayer != null) {
        final RenderShapeLayer shapeLayerRenderBox = markerParent.parent.parent;
        final RenderSublayerContainer sublayerContainer =
            shapeLayerRenderBox.parent;
        sublayerIndex =
            sublayerContainer.getSublayerIndex(markerParent.sublayer);
      }

      final ShapeLayerChildRenderBoxBase tooltipRenderObject =
          markerParent.controller.tooltipKey.currentContext.findRenderObject();
      final StackParentData childParentData = parentData;
      // The [sublayerIndex] is not applicable, if the actual layer is
      // shape or tile layer.
      tooltipRenderObject.paintTooltip(
          isExit ? null : markerParent.getMarkerIndex(marker),
          childParentData.offset & size,
          MapLayerElement.marker,
          sublayerIndex);
    }
  }

  void _updatePosition() {
    final _RenderMarkerContainer markerParent = parent;
    final StackParentData childParentData = parentData;
    if (parent != null) {
      childParentData.offset = pixelFromLatLng(
              _latitude,
              _longitude,
              markerParent.size,
              markerParent.shapeLayerOffset,
              markerParent.shapeLayerSizeFactor) -
          Offset(size.width / 2, size.height / 2);
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => _handlePointerEnter;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handlePointerExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) {
    // For [MapMarker] shape and tile layer, we had different parent classes.
    // So, we used the dynamic keyword to access both parent commonly.
    final dynamic markerParent = parent;
    return markerParent.markerTooltipBuilder != null;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (event.down && event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerHoverEvent) {
      _handleInteraction();
    }
  }

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
