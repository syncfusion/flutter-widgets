part of maps;

enum _MarkerAction { insert, removeAt, replace, clear, none }

/// Base class of [MapShapeLayerController] and [MapTileLayerController].
abstract class MapLayerController extends ChangeNotifier {
  List<int> _replaceableIndices;
  int _markersCount;
  int _index = -1;
  _MarkerAction _markerAction = _MarkerAction.none;

  /// Render box of the map layer.
  _RenderShapeLayer _parentBox;

  /// Returns the current markers count.
  int get markersCount => _markersCount;

  /// Adds marker dynamically in the provided index.
  ///
  /// If the [MapShapeLayer.initialMarkersCount] is 10 and if the index given
  /// for the insertMarker method is 10 which is greater than the available
  /// indices, then the marker will be added as a last item.
  ///
  /// See also:
  /// * [MapShapeLayer.markerBuilder], to return the [MapMarker].
  void insertMarker(int index) {
    _markerAction = _MarkerAction.insert;
    assert(index <= markersCount);
    if (index > markersCount) {
      index = markersCount;
    }
    _index = index;
    notifyListeners();
  }

  /// Removes the marker in the provided index.
  void removeMarkerAt(int index) {
    _markerAction = _MarkerAction.removeAt;
    _index = index;
    notifyListeners();
  }

  /// Updates the markers in the given indices dynamically.
  /// See also:
  /// * [MapShapeLayer.markerBuilder], to return the updated [MapMarker].
  void updateMarkers(List<int> indices) {
    _markerAction = _MarkerAction.replace;
    _replaceableIndices = indices;
    notifyListeners();
  }

  /// Clears all the markers.
  void clearMarkers() {
    _markerAction = _MarkerAction.clear;
    notifyListeners();
  }

  @override
  void dispose() {
    _replaceableIndices?.clear();
    _replaceableIndices = null;

    super.dispose();
  }
}

/// Provides option for adding, removing, deleting and updating marker
/// collection.
///
/// You can also get the current markers count and selected shape's index from
/// this.
///
/// You need to set the instance of this to [MapShapeLayer.controller] as
/// shown in the below code snippet.
///
/// ```dart
/// List<Model> data;
/// MapShapeLayerController controller;
/// Random random = Random();
///
/// @override
/// void initState() {
///     data = <Model>[
///       Model(-14.235004, -51.92528),
///       Model(51.16569, 10.451526),
///       Model(-25.274398, 133.775136),
///       Model(20.593684, 78.96288),
///       Model(61.52401, 105.318756)
///     ];
///
///    controller = MapShapeLayerController();
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
///              child: Column(
///                children: [
///                  SfMaps(
///                    layers: <MapLayer>[
///                      MapShapeLayer(
///                       delegate: MapShapeLayerDelegate(
///                          shapeFile: 'assets/world_map.json',
///                          shapeDataField: 'name',
///                        ),
///                        initialMarkersCount: 5,
///                        markerBuilder: (BuildContext context, int index){
///                          return MapMarker(
///                            latitude: data[index].latitude,
///                            longitude: data[index].longitude,
///                            child: Icon(Icons.add_location),
///                          );
///                        },
///                        controller: controller,
///                      ),
///                    ],
///                  ),
///                  RaisedButton(
///                    child: Text('Add marker'),
///                    onPressed: () {
///                      data.add(Model(
///                          -180 + random.nextInt(360).toDouble(),
///                          -55 + random.nextInt(139).toDouble()));
///                      controller.insertMarker(5);
///                    },
///                  ),
///                ],
///              ),
///            ),
///         )
///      ),
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
class MapShapeLayerController extends MapLayerController {
  /// Index of the shape which is selected currently.
  int get selectedIndex => _selectedIndex;
  int _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex == value) {
      return;
    }
    _selectedIndex = value;
    notifyListeners();
  }

  /// Convert pixel point to coordinates.
  MapLatLng pixelToLatLng(Offset position) {
    return _pixelToLatLng(
        position,
        _parentBox.size,
        _parentBox.defaultController.shapeLayerOffset,
        _parentBox.defaultController.shapeLayerSizeFactor);
  }
}

/// Provides an option for adding, removing, deleting and updating marker
/// collection.
class MapTileLayerController extends MapLayerController {
  /// Instance of _MapTileLayerState.
  _MapTileLayerState _state;

  /// Convert pixel point to coordinates.
  MapLatLng pixelToLatLng(Offset position) {
    final Offset localPointCenterDiff = Offset(
        (_state._size.width / 2) - position.dx,
        (_state._size.height / 2) - position.dy);
    final Offset actualCenterPixelPosition = _getPixelFromLatLng(
        _state._currentFocalLatLng, _state._currentZoomLevel);
    final Offset newCenterPoint =
        actualCenterPixelPosition - localPointCenterDiff;
    return _getLatLngFromPixel(newCenterPoint, scale: _state._currentZoomLevel);
  }
}
