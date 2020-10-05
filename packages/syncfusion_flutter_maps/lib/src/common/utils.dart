part of maps;

Future<_ShapeFileData> _retrieveDataFromShapeFile(
    String file,
    String shapeDataField,
    _ShapeFileData shapeFileData,
    bool isShapeFileDecoded) async {
  if (isShapeFileDecoded) {
    return shapeFileData;
  }
  final String assertBundleData = await rootBundle.loadString(file);
  final Map<String, dynamic> data = <String, dynamic>{
    'AssertBundleData': assertBundleData,
    'ShapeDataField': shapeDataField,
    'ShapeFileData': shapeFileData
  };
  return compute(_decodeJsonData, data);
}

/// Returns the URL template in the required format for the Bing Maps.
///
/// For Bing maps, an additional step is required. The format of the required
/// URL varies from the other tile services. Hence, we have added this top-level
/// method which returns the URL in the required format.
///
/// You can use the URL template returned from this method to pass it to the
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
      for (final key in decodedJson.keys) {
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

_ShapeFileData _decodeJsonData(Map<String, dynamic> data) {
  data['ShapeFileData'].decodedJsonData = jsonDecode(data['AssertBundleData']);
  _readJsonFile(data);
  return data['ShapeFileData'];
}

void _readJsonFile(Map<String, dynamic> data) {
  final _ShapeFileData shapeFileData = data['ShapeFileData'];
  final String shapeDataField = data['ShapeDataField'];

  List<dynamic> polygonGeometryData;
  int multipolygonGeometryLength;
  Map<String, dynamic> geometry;
  Map<String, dynamic> properties;
  final bool hasFeatures =
      shapeFileData.decodedJsonData.containsKey('features');
  final bool hasGeometries =
      shapeFileData.decodedJsonData.containsKey('geometries');
  final String key = hasFeatures
      ? 'features'
      : hasGeometries
          ? 'geometries'
          : null;
  final int jsonLength =
      key.isEmpty ? 0 : shapeFileData.decodedJsonData[key].length;

  for (int i = 0; i < jsonLength; i++) {
    if (hasFeatures) {
      final dynamic features = shapeFileData.decodedJsonData[key][i];
      geometry = features['geometry'];
      properties = features['properties'];
    } else if (hasGeometries) {
      geometry = shapeFileData.decodedJsonData[key][i];
    }

    if (geometry['type'] == 'Polygon') {
      polygonGeometryData = geometry['coordinates'][0];
      _updateMapDataSource(
          shapeFileData, shapeDataField, properties, polygonGeometryData);
    } else {
      multipolygonGeometryLength = geometry['coordinates'].length;
      for (int j = 0; j < multipolygonGeometryLength; j++) {
        polygonGeometryData = geometry['coordinates'][j][0];
        _updateMapDataSource(
            shapeFileData, shapeDataField, properties, polygonGeometryData);
      }
    }
  }
}

void _updateMapDataSource(_ShapeFileData shapeFileData, String shapeDataField,
    Map<String, dynamic> properties, List<dynamic> points) {
  final String dataPath =
      properties != null ? properties[shapeDataField] : null;
  shapeFileData.source.update(
    dataPath,
    (_MapModel model) {
      model.rawPoints.add(points);
      return model;
    },
    ifAbsent: () {
      final int dataSourceIndex = shapeFileData.source.length;
      return _MapModel(
        primaryKey: dataPath,
        actualIndex: dataSourceIndex,
        legendMapperIndex: dataSourceIndex,
        rawPoints: <List<dynamic>>[points],
      );
    },
  );

  _updateShapeBounds(shapeFileData, points);
}

void _updateShapeBounds(
    _ShapeFileData shapeFileData, List<dynamic> coordinates) {
  List<dynamic> data;
  num longitude, latitude;
  final int length = coordinates.length;
  for (int i = 0; i < length; i++) {
    data = coordinates[i];
    longitude = data[0];
    latitude = data[1];
    if (shapeFileData.bounds.minLongitude == null) {
      shapeFileData.bounds.minLongitude = longitude;
      shapeFileData.bounds.minLatitude = latitude;
      shapeFileData.bounds.maxLongitude = longitude;
      shapeFileData.bounds.maxLatitude = latitude;
    } else {
      shapeFileData.bounds.minLongitude =
          min(longitude, shapeFileData.bounds.minLongitude);
      shapeFileData.bounds.minLatitude =
          min(latitude, shapeFileData.bounds.minLatitude);
      shapeFileData.bounds.maxLongitude =
          max(longitude, shapeFileData.bounds.maxLongitude);
      shapeFileData.bounds.maxLatitude =
          max(latitude, shapeFileData.bounds.maxLatitude);
    }
  }
}

Size _getBoxSize(BoxConstraints constraints) {
  final double width = constraints.hasBoundedWidth ? constraints.maxWidth : 300;
  final double height =
      constraints.hasBoundedHeight ? constraints.maxHeight : 300;
  return Size(width, height);
}

Offset _pixelFromLatLng(num latitude, num longitude, Size size,
    [Offset offset = const Offset(0, 0), double factor = 1.0]) {
  assert(latitude != null);
  assert(longitude != null);
  assert(size != null);

  final double x = (longitude + 180.0) / 360.0;
  final double sinLatitude = sin(latitude * pi / 180.0);
  final double y =
      0.5 - log((1.0 + sinLatitude) / (1.0 - sinLatitude)) / (4.0 * pi);
  final double mapSize = size.longestSide * factor;
  final double dx = offset.dx + _clip(x * mapSize + 0.5, 0.0, mapSize - 1);
  final double dy = offset.dy + _clip(y * mapSize + 0.5, 0.0, mapSize - 1);
  return Offset(dx, dy);
}

MapLatLng _pixelToLatLng(
    Offset offset, Size size, Offset translation, double factor) {
  final double mapSize = size.longestSide * factor;
  final double x =
      (_clip(offset.dx - translation.dx, 0, mapSize - 1) / mapSize) - 0.5;
  final double y =
      0.5 - (_clip(offset.dy - translation.dy, 0, mapSize - 1) / mapSize);
  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

// Get boundary value.
double _clip(double value, double minValue, double maxValue) {
  return min(max(value, minValue), maxValue);
}

double _interpolateValue(double value, double min, double max) {
  assert(min != null);
  max ??= value;
  if (value > max) {
    value = max;
  } else if (value < min) {
    value = min;
  }
  return value;
}

double _getActualCircleRadius(double circleRadius, double strokeWidth) {
  return strokeWidth > circleRadius
      ? circleRadius / 2
      : circleRadius - strokeWidth / 2;
}

Offset _getPixelFromLatLng(MapLatLng latLng, double scale) {
  final double _minLatitude = -85.05112878;
  final double _maxLatitude = 85.05112878;
  final double _minLongitude = -180;
  final double _maxLongitude = 180;

  final double latitude = _clip(latLng.latitude, _minLatitude, _maxLatitude);
  final double longitude =
      _clip(latLng.longitude, _minLongitude, _maxLongitude);
  final double x = (longitude + 180) / 360;
  final double sinLatitude = sin(latitude * pi / 180);
  final double y = 0.5 - log((1 + sinLatitude) / (1 - sinLatitude)) / (4 * pi);

  final double tileSize = _getTotalTileWidth(scale);
  final double pixelX = _clip(x * tileSize + 0.5, 0, tileSize - 1);
  final double pixelY = _clip(y * tileSize + 0.5, 0, tileSize - 1);
  return Offset(pixelX, pixelY);
}

MapLatLng _getLatLngFromPixel(Offset point, {double scale}) {
  final double tileSize = _getTotalTileWidth(scale);
  final double x = (_clip(point.dx, 0, tileSize - 1) / tileSize) - 0.5;
  final double y = 0.5 - (_clip(point.dy, 0, tileSize - 1) / tileSize);

  final double latitude = 90 - 360 * atan(exp(-y * 2 * pi)) / pi;
  final double longitude = 360 * x;
  return MapLatLng(latitude, longitude);
}

double _getTotalTileWidth(double zoom) {
  return 256 * pow(2, zoom);
}

// Default hover color opacity value.
const double _hoverColorOpacity = 0.7;

// If shape color opacity is same hover color opacity,
// hover is not visible in UI.
// So need to decrease hover opacity
const double _minHoverOpacity = 0.5;
