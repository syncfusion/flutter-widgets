import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/core.dart' as core;
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../utils.dart';

// ignore_for_file: public_member_api_docs
class MarkerContainer extends Stack {
  MarkerContainer({
    required this.markerTooltipBuilder,
    required this.controller,
    required this.themeData,
    this.sublayer,
    this.ancestor,
    List<Widget>? children,
  }) : super(children: children ?? <Widget>[]);

  final IndexedWidgetBuilder? markerTooltipBuilder;
  final MapController controller;
  final SfMapsThemeData themeData;
  final MapShapeSublayer? sublayer;
  final MapLayerInheritedWidget? ancestor;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderMarkerContainer()
      ..markerTooltipBuilder = markerTooltipBuilder
      ..controller = controller
      ..themeData = themeData
      ..sublayer = sublayer
      ..container = this;
  }

  @override
  void updateRenderObject(
      BuildContext context,
      // ignore: library_private_types_in_public_api
      _RenderMarkerContainer renderObject) {
    renderObject
      ..markerTooltipBuilder = markerTooltipBuilder
      ..themeData = themeData
      ..sublayer = sublayer
      ..container = this;
  }
}

class _RenderMarkerContainer extends RenderStack {
  late MarkerContainer container;
  late MapController controller;
  late SfMapsThemeData themeData;
  GlobalKey? tooltipKey;
  IndexedWidgetBuilder? markerTooltipBuilder;
  MapShapeSublayer? sublayer;

  int getMarkerIndex(MapMarker marker) {
    return container.children.indexOf(marker);
  }

  Size get containerSize => controller.layerType == LayerType.tile
      ? controller.getTileSize(controller.tileCurrentLevelDetails.zoomLevel)
      : controller.shapeLayerBoxSize;

  void _handleZooming(MapZoomDetails details) {
    markNeedsLayout();
  }

  void _handlePanning(MapPanDetails details) {
    markNeedsLayout();
  }

  void _handleZoomPanChange() {
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
      ..addZoomPanListener(_handleZoomPanChange)
      ..addZoomingListener(_handleZooming)
      ..addPanningListener(_handlePanning)
      ..addResetListener(_handleReset)
      ..addRefreshListener(_handleRefresh);
  }

  @override
  void detach() {
    controller
      ..removeZoomPanListener(_handleZoomPanChange)
      ..removeZoomingListener(_handleZooming)
      ..removePanningListener(_handlePanning)
      ..removeResetListener(_handleReset)
      ..removeRefreshListener(_handleRefresh);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = controller.layerType == LayerType.shape
        ? controller.shapeLayerBoxSize
        : controller.tileLayerBoxSize!;
    final double factor = getLayerSizeFactor(controller);
    final Offset translation = getTranslationOffset(controller);
    RenderBox? child = firstChild;
    while (child != null) {
      // ignore: avoid_as
      final _RenderMapMarker marker = child as _RenderMapMarker;
      final StackParentData childParentData =
          // ignore: avoid_as
          child.parentData! as StackParentData;
      child.layout(constraints, parentUsesSize: true);
      childParentData.offset = pixelFromLatLng(marker.latitude,
          marker.longitude, containerSize, translation, factor);
      if (controller.layerType == LayerType.tile) {
        final TileZoomLevelDetails level = controller.tileCurrentLevelDetails;
        childParentData.offset =
            childParentData.offset.scale(level.scale, level.scale) +
                level.translatePoint;
      }
      childParentData.offset -=
          Offset(marker.size.width / 2, marker.size.height / 2);
      if (marker.alignment != Alignment.center) {
        final Alignment effectiveAlignment =
            marker.alignment.resolve(textDirection);
        childParentData.offset -= Offset(
            effectiveAlignment.x * marker.size.width / 2,
            effectiveAlignment.y * marker.size.height / 2);
      }

      if (marker.offset != Offset.zero) {
        childParentData.offset += Offset(marker.offset.dx, marker.offset.dy);
      }

      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final StackParentData childParentData =
          // ignore: avoid_as
          child.parentData! as StackParentData;
      final Rect childRect = Rect.fromLTWH(childParentData.offset.dx,
          childParentData.offset.dy, child.size.width, child.size.height);
      if (sublayer != null || controller.visibleBounds!.overlaps(childRect)) {
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
/// late List<Model> data;
/// late MapShapeSource _mapSource;
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
///    _mapSource = MapShapeSource.asset(
///      'assets/world_map.json',
///      shapeDataField: 'name',
///      dataCount: data.length,
///      primaryValueMapper: (int index) => data[index].country,
///    );
///    super.initState();
/// }
///
/// @override
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
///                    source: _mapSource,
///                    initialMarkersCount: 5,
///                    markerBuilder: (BuildContext context, int index) {
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
    Key? key,
    required this.latitude,
    required this.longitude,
    this.size,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.iconColor,
    this.iconStrokeColor,
    this.iconStrokeWidth,
    this.iconType = MapIconType.circle,
    Widget? child,
  }) : super(key: key, child: child);

  /// Sets the latitude for the marker on the map.
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  final Size? size;

  /// Sets the alignment for the marker on the map.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        alignment: Alignment.topLeft,
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
  final AlignmentGeometry alignment;

  /// Places the marker position in additional to the given offset.
  ///
  /// Defaults to Offset.zero.
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        offset: Offset(20.0, 10.0),
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
  final Offset offset;

  /// Sets the icon color for the marker.
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  final Color? iconColor;

  /// Sets the icon's stroke color for the marker.
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  final Color? iconStrokeColor;

  /// Sets the icon's stroke width for the marker.
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
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
  final double? iconStrokeWidth;

  /// Sets the icon's shape of the marker.
  ///
  /// Defaults to [MapIconType.circle].
  ///
  /// ```dart
  /// late List<Model> data;
  /// late MapShapeSource _mapSource;
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
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/world_map.json',
  ///      shapeDataField: 'name',
  ///      dataCount: data.length,
  ///      primaryValueMapper: (int index) => data[index].country,
  ///    );
  ///    super.initState();
  /// }
  ///
  /// @override
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index) {
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                        iconType: MapIconType.triangle,
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
  final MapIconType iconType;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMapMarker(
      longitude: longitude,
      latitude: latitude,
      markerSize: size,
      alignment: alignment,
      offset: offset,
      iconColor: iconColor,
      iconStrokeColor: iconStrokeColor,
      iconStrokeWidth: iconStrokeWidth,
      iconType: iconType,
      marker: this,
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  void updateRenderObject(BuildContext context, _RenderMapMarker renderObject) {
    renderObject
      ..longitude = longitude
      ..latitude = latitude
      ..markerSize = size
      ..alignment = alignment
      ..offset = offset
      ..iconColor = iconColor
      ..iconStrokeColor = iconStrokeColor
      ..iconStrokeWidth = iconStrokeWidth
      ..iconType = iconType
      ..marker = this;
  }
}

class _RenderMapMarker extends RenderProxyBox
    implements MouseTrackerAnnotation {
  _RenderMapMarker({
    required double longitude,
    required double latitude,
    required Size? markerSize,
    required AlignmentGeometry alignment,
    required Offset offset,
    required Color? iconColor,
    required Color? iconStrokeColor,
    required double? iconStrokeWidth,
    required MapIconType iconType,
    required this.marker,
  })  : _longitude = longitude,
        _latitude = latitude,
        _markerSize = markerSize,
        _alignment = alignment,
        _offset = offset,
        _iconColor = iconColor,
        _iconStrokeColor = iconStrokeColor,
        _iconStrokeWidth = iconStrokeWidth,
        _iconType = iconType {
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
  }

  final Size _defaultMarkerSize = const Size(14.0, 14.0);
  late TapGestureRecognizer _tapGestureRecognizer;

  MapMarker marker;

  double get latitude => _latitude;
  double _latitude;
  set latitude(double value) {
    if (_latitude == value) {
      return;
    }
    _latitude = value;
    markNeedsLayout();
  }

  double get longitude => _longitude;
  double _longitude;
  set longitude(double value) {
    if (_longitude == value) {
      return;
    }
    _longitude = value;
    markNeedsLayout();
  }

  Size? get markerSize => _markerSize;
  Size? _markerSize;
  set markerSize(Size? value) {
    if (_markerSize == value) {
      return;
    }
    _markerSize = value;
    markNeedsLayout();
  }

  AlignmentGeometry get alignment => _alignment;
  AlignmentGeometry _alignment;
  set alignment(AlignmentGeometry value) {
    if (_alignment == value) {
      return;
    }
    _alignment = value;
    markNeedsLayout();
  }

  Offset get offset => _offset;
  Offset _offset;
  set offset(Offset value) {
    if (_offset == value) {
      return;
    }
    _offset = value;
    markNeedsLayout();
  }

  Color? get iconColor => _iconColor;
  Color? _iconColor;
  set iconColor(Color? value) {
    if (_iconColor == value) {
      return;
    }
    _iconColor = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  Color? get iconStrokeColor => _iconStrokeColor;
  Color? _iconStrokeColor;
  set iconStrokeColor(Color? value) {
    if (_iconStrokeColor == value) {
      return;
    }
    _iconStrokeColor = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  double? get iconStrokeWidth => _iconStrokeWidth;
  double? _iconStrokeWidth;
  set iconStrokeWidth(double? value) {
    if (_iconStrokeWidth == value) {
      return;
    }
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
    _iconType = value;
    if (child == null) {
      markNeedsPaint();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _handleInteraction();
  }

  void _handlePointerEnter(PointerEnterEvent event) {
    _handleInteraction(PointerKind.hover);
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (owner != null) {
      final _RenderMarkerContainer markerContainer =
          // ignore: avoid_as
          parent! as _RenderMarkerContainer;
      if (markerContainer.markerTooltipBuilder != null) {
        final ShapeLayerChildRenderBoxBase tooltipRenderBox =
            markerContainer.controller.tooltipKey!.currentContext!
                // ignore: avoid_as
                .findRenderObject()! as ShapeLayerChildRenderBoxBase;
        tooltipRenderBox.hideTooltip();
      }
    }
  }

  void _handleInteraction([PointerKind kind = PointerKind.touch]) {
    if (owner != null) {
      int? sublayerIndex;
      final _RenderMarkerContainer markerContainerRenderBox =
          // ignore: avoid_as
          parent! as _RenderMarkerContainer;
      if (markerContainerRenderBox.markerTooltipBuilder != null) {
        if (markerContainerRenderBox.sublayer != null) {
          sublayerIndex = markerContainerRenderBox
              .container.ancestor!.sublayers!
              .indexOf(markerContainerRenderBox.sublayer!);
        }

        final ShapeLayerChildRenderBoxBase tooltipRenderBox =
            markerContainerRenderBox.controller.tooltipKey!.currentContext!
                // ignore: avoid_as
                .findRenderObject()! as ShapeLayerChildRenderBoxBase;
        // ignore: avoid_as
        final StackParentData childParentData = parentData! as StackParentData;
        tooltipRenderBox.paintTooltip(
            markerContainerRenderBox.getMarkerIndex(marker),
            childParentData.offset & size,
            MapLayerElement.marker,
            kind,
            // [sublayerIndex] is applicable only when the markers
            // added to the [MapShapeSublayer].
            sublayerIndex);
      }
    }
  }

  @override
  MouseCursor get cursor => SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => _handlePointerEnter;

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
      _handleInteraction(PointerKind.hover);
    }
  }

  @override
  void performLayout() {
    if (_markerSize != null) {
      child?.layout(BoxConstraints.tight(_markerSize!));
      size = _markerSize!;
    } else {
      if (child != null) {
        child!.layout(constraints.loosen(), parentUsesSize: true);
        size = child!.size;
      } else {
        size = _defaultMarkerSize;
      }
    }
  }

  core.ShapeMarkerType _getEffectiveShapeType() {
    switch (_iconType) {
      case MapIconType.circle:
        return core.ShapeMarkerType.circle;
      case MapIconType.diamond:
        return core.ShapeMarkerType.diamond;
      case MapIconType.rectangle:
        return core.ShapeMarkerType.rectangle;
      case MapIconType.triangle:
        return core.ShapeMarkerType.triangle;
    }
  }

  Paint? _getBorderPaint() {
    final _RenderMarkerContainer markerContainer =
        parent! as _RenderMarkerContainer;
    final SfMapsThemeData themeData = markerContainer.themeData;
    if (_iconStrokeWidth != null && _iconStrokeWidth! > 0) {
      return Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _iconStrokeWidth ?? themeData.markerIconStrokeWidth
        ..color = _iconStrokeColor ?? themeData.markerIconStrokeColor!;
    }

    return null;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final _RenderMarkerContainer markerContainer =
        parent! as _RenderMarkerContainer;
    if (child == null) {
      core.paint(
          canvas: context.canvas,
          rect: paintBounds,
          shapeType: _getEffectiveShapeType(),
          paint: Paint()
            ..color = _iconColor ?? markerContainer.themeData.markerIconColor!,
          borderPaint: _getBorderPaint());
    } else {
      context.paintChild(child!, offset);
    }
  }
}
