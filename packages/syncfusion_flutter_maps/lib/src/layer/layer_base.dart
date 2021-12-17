import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';

/// Base class for the [MapShapeLayer] and [MapTileLayer].
///
/// See also:
/// * [MapShapeLayer],[MapTileLayer] for adding in the [SfMaps.layers].
abstract class MapLayer extends StatelessWidget {
  /// Creates a [MapLayer].
  const MapLayer({
    Key? key,
    this.initialLatLngBounds,
    this.sublayers,
    this.initialMarkersCount = 0,
    this.markerBuilder,
    this.markerTooltipBuilder,
    this.tooltipSettings = const MapTooltipSettings(),
    this.zoomPanBehavior,
    this.onWillZoom,
    this.onWillPan,
  }) : super(key: key);

  /// Option to set the LatLng bounds initially for the tile or shape layer.
  ///
  /// This property cannot be updated dynamically.
  ///
  /// The map will be rendered based on value of [initialLatLngBounds]
  /// property in the visible bounds.
  ///
  /// See also:
  /// * [MapZoomPanBehavior.latLngBounds], for dynamically updating the
  /// LatLng bounds.
  final MapLatLngBounds? initialLatLngBounds;

  /// Collection of [MapShapeSublayer], [MapLineLayer], [MapPolylineLayer],
  /// [MapPolygonLayer], [MapCircleLayer], and [MapArcLayer].
  ///
  /// It is applicable for both the [MapShapeLayer] and [MapTileLayer].
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<DataModel> _data;
  /// int _selectedIndex = -1;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.asset(
  ///     'assets/india.json',
  ///     shapeDataField: 'name',
  ///   );
  ///
  ///   _data = <DataModel>[
  ///     DataModel(MapLatLng(28.7041, 77.1025), MapLatLng(11.1271, 78.6569)),
  ///     DataModel(MapLatLng(28.7041, 77.1025), MapLatLng(9.9312, 76.2673)),
  ///     DataModel(MapLatLng(28.7041, 77.1025), MapLatLng(15.3173, 75.7139)),
  ///     DataModel(MapLatLng(28.7041, 77.1025), MapLatLng(18.1124, 79.0193)),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///     appBar: AppBar(title: Text('Line layer')),
  ///     body: Column(
  ///       children: [
  ///         Container(
  ///           child: SfMaps(
  ///             layers: [
  ///               MapShapeLayer(
  ///                 source: _mapSource,
  ///                 sublayers: [
  ///                   MapLineLayer(
  ///                     lines: List<MapLine>.generate(
  ///                       _data.length,
  ///                       (int index) {
  ///                         return MapLine(
  ///                             from: _data[index].from,
  ///                             to: _data[index].to,
  ///                             dashArray: [8, 3, 4, 2],
  ///                             color: _selectedIndex == index
  ///                                 ? Colors.red
  ///                                 : Colors.blue,
  ///                             width: 2,
  ///                             onTap: () {
  ///                               setState(() {
  ///                                 _selectedIndex = index;
  ///                               });
  ///                             });
  ///                       },
  ///                     ).toSet(),
  ///                   ),
  ///                 ],
  ///               ),
  ///             ],
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   DataModel(this.from, this.to);
  ///
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  final List<MapSublayer>? sublayers;

  /// Option to set markers count initially. It cannot be be updated
  /// dynamically.
  ///
  /// The [MapLayer.markerBuilder] callback will be called number of times equal
  /// to the value specified in the [MapLayer.initialMarkersCount] property.
  /// The default value of the of this property is null.
  ///
  /// See also:
  /// * [markerBuilder], for returning the [MapMarker].
  /// * [MapShapeLayer.controller], [MapTileLayer.controller] for dynamically
  /// updating the markers collection.
  final int initialMarkersCount;

  /// Returns the [MapMarker] for the given index.
  ///
  /// Markers which be used to denote the locations on the map.
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///    _data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     'assets/world_map.json',
  ///     shapeDataField: 'name',
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) => _data[index].country,
  ///   );
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
  ///                    source: _mapSource,
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: _data[index].latitude,
  ///                        longitude: _data[index].longitude,
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
  /// * [MapMarker], to create a map marker.
  final MapMarkerBuilder? markerBuilder;

  /// Returns the widget for the tooltip of the [MapMarker].
  ///
  /// To show the tooltip for markers, return a customized widget in the
  /// [MapLayer.markerTooltipBuilder]. This widget will then be wrapped in the
  /// in-built shape which comes with the nose at the bottom.
  ///
  /// The [MapLayer.markerTooltipBuilder] will be called when the user interacts
  /// with the markers i.e., while tapping in touch devices and hovering in the
  /// mouse enabled devices.
  ///
  /// ```dart
  /// late List<Model> _worldMapData;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _worldMapData = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     'assets/world_map.json',
  ///     shapeDataField: 'name',
  ///     dataCount: _worldMapData.length,
  ///     primaryValueMapper: (int index) => _worldMapData[index].country,
  ///   );
  ///
  ///    super.initState();
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
  ///              initialMarkersCount: _worldMapData.length,
  ///              markerBuilder: (BuildContext context, int index){
  ///                 return MapMarker(
  ///                  latitude: _worldMapData[index].latitude,
  ///                  longitude: _worldMapData[index].longitude,
  ///                 );
  ///              },
  ///              markerTooltipBuilder: (BuildContext context, int index) {
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
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapLayer.tooltipSettings], to customize the color and stroke of the
  /// tooltip.
  /// * [SfMapsThemeData.tooltipBorderRadius], to customize the corners of the
  /// tooltip.
  final IndexedWidgetBuilder? markerTooltipBuilder;

  /// Customizes the bubble, marker, and shape tooltip's appearance.
  ///
  /// See also:
  /// * [MapShapeLayer.shapeTooltipBuilder], to show the customized tooltip
  /// for the shapes.
  /// * [MapShapeLayer.bubbleTooltipBuilder], to show the customized tooltip
  /// for the bubbles.
  /// * [MapShapeLayer.markerTooltipBuilder],[MapTileLayer.markerTooltipBuilder]
  /// to show the customized tooltip for the markers.
  final MapTooltipSettings tooltipSettings;

  /// Enables zooming and panning in [MapShapeLayer] and [MapTileLayer].
  ///
  /// Zooming and panning will start working when the new instance of
  /// [MapZoomPanBehavior] is set to [zoomPanBehavior] or
  /// [zoomPanBehavior]. However, if you need to restrict pinch
  /// zooming or panning for any specific requirements, you can set the
  /// [MapZoomPanBehavior.enablePinching] and [MapZoomPanBehavior.enablePanning]
  /// properties to false respectively.
  ///
  /// The [MapZoomPanBehavior.focalLatLng] is the focal point of the map layer
  /// based on which zooming happens.
  ///
  /// The default [MapZoomPanBehavior.zoomLevel] value is 1 which will show the
  /// whole map in the viewport for [MapShapeLayer] and the available bounds
  /// for the [MapTileLayer] based on the [MapZoomPanBehavior.focalLatLng]
  /// (Please check the documentation of [MapTileLayer] to know more details
  /// about how [MapZoomPanBehavior.zoomLevel] works in it).
  ///
  /// You can also get the current zoom level and focal position of the
  /// map after the interaction using the [MapZoomPanBehavior.zoomLevel] and
  /// [MapZoomPanBehavior.focalLatLng]. These properties can also be set
  /// dynamically.
  ///
  /// The minimum and maximum zoom levels can be restricted using the
  /// [MapZoomPanBehavior.minZoomLevel] and [MapZoomPanBehavior.maxZoomLevel]
  /// properties respectively. The default values of
  /// [MapZoomPanBehavior.minZoomLevel] and [MapZoomPanBehavior.maxZoomLevel]
  /// are 0 and 15 respectively. However, for [MapTileLayer],
  /// the [MapZoomPanBehavior.maxZoomLevel] may slightly vary depending
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
  ///  late MapShapeSource _mapSource;
  ///  late MapZoomPanBehavior _zoomPanBehavior;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559);
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: Text('Zoom pan'),
  ///       ),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final MapZoomPanBehavior? zoomPanBehavior;

  /// Called whenever zooming is happening.
  ///
  /// If it returns false, zooming will not happen.
  ///
  /// [MapZoomDetails] contains following properties.
  ///  * [MapZoomDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current zooming operation completes i.e. current visible
  ///   bounds.
  ///  * [MapZoomDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current zoom completes. Hence, if it returns false,
  ///   there will be no changes in the UI.
  ///  * [MapZoomDetails.previousZoomLevel] - provides the zoom level
  ///   before the current zooming operation completes i.e. current zoom
  ///   level.
  ///  * [MapZoomDetails.newZoomLevel] - provides the new zoom level
  ///   when the current zoom completes. Hence, if it returns false, there will
  ///   be no changes in the UI.
  ///  * [MapZoomDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapZoomDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  final WillZoomCallback? onWillZoom;

  /// Called whenever panning is happening.
  ///
  /// If it returns false, panning will not happen.
  ///
  /// [MapPanDetails] contains following properties.
  ///  * [MapPanDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current panning operation completes i.e. current visible
  ///   bounds.
  ///  * [MapPanDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current pan completes. Hence, if it returns false,
  ///   there will be no changes in the UI.
  ///  * [MapPanDetails.zoomLevel] - provides the current zoom level.
  ///  * [MapPanDetails.delta] - The difference in pixels between touch start
  ///  and current touch position.
  ///  * [MapPanDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapPanDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  final WillPanCallback? onWillPan;
}

/// Base class for all vector shapes like [MapLineLayer], [MapCircleLayer],
/// [MapArcLayer], [MapPolylineLayer], and [MapPolygonLayer].
abstract class MapSublayer extends StatelessWidget {
  /// Creates a [MapSublayer].
  const MapSublayer({Key? key, this.tooltipBuilder}) : super(key: key);

  /// Returns a widget for the map line tooltip based on the index.
  ///
  /// A map line tooltip displays additional information about the purpose of
  /// the shape drawn. To show tooltip for the shape return a completely
  /// customized widget in [MapSublayer.tooltipBuilder].
  ///
  /// The [MapSublayer.tooltipBuilder] callback will be called when the
  /// user interacts with the shape.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<DataModel> _data;
  /// int _selectedIndex = -1;
  ///
  ///  @override
  ///  void initState() {
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/usa.json',
  ///    );
  ///
  ///    _data = <DataModel>[
  ///      DataModel(MapLatLng(40.7128, -74.0060),
  ///        MapLatLng(44.9778, -93.2650)),
  ///      DataModel(MapLatLng(40.7128, -74.0060),
  ///        MapLatLng(33.4484, -112.0740)),
  ///      DataModel(MapLatLng(40.7128, -74.0060),
  ///        MapLatLng(29.7604, -95.3698)),
  ///      DataModel(MapLatLng(40.7128, -74.0060),
  ///        MapLatLng(39.7392, -104.9903)),
  ///    ];
  ///    super.initState();
  ///  }
  ///
  ///  @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Line layer')),
  ///       body: Column(
  ///         children: [
  ///           Container(
  ///             child: SfMaps(
  ///               layers: [
  ///                 MapShapeLayer(
  ///                   source: _mapSource,
  ///                   sublayers: [
  ///                     MapLineLayer(
  ///                       lines: List<MapLine>.generate(
  ///                         _data.length,
  ///                         (int index) {
  ///                           return MapLine(
  ///                               from: _data[index].from,
  ///                               to: _data[index].to,
  ///                               dashArray: [8, 3, 4, 2],
  ///                               color: _selectedIndex == index
  ///                                   ? Colors.red
  ///                                   : Colors.blue,
  ///                               width: 2,
  ///                               onTap: () {
  ///                                 setState(() {
  ///                                   _selectedIndex = index;
  ///                                 });
  ///                               });
  ///                         },
  ///                       ).toSet(),
  ///                       tooltipBuilder: (BuildContext context, int index) {
  ///                         if (index == 0) {
  ///                           return Container(
  ///                             child: Icon(Icons.airplanemode_inactive),
  ///                           );
  ///                         } else {
  ///                           return Container(
  ///                             child: Icon(Icons.airplanemode_active),
  ///                           );
  ///                         }
  ///                       },
  ///                     ),
  ///                   ],
  ///                 ),
  ///               ],
  ///             ),
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  ///
  /// class DataModel {
  ///   DataModel(this.from, this.to);
  ///   MapLatLng from;
  ///   MapLatLng to;
  /// }
  /// ```
  final IndexedWidgetBuilder? tooltipBuilder;
}
