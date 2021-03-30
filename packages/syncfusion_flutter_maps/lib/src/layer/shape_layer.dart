import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'dart:ui';

import 'package:collection/collection.dart' show MapEquality;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../behavior/zoom_pan_behavior.dart';
import '../common.dart';
import '../controller/map_controller.dart';
import '../controller/map_provider.dart';
import '../controller/shape_layer_controller.dart';
import '../elements/bubble.dart';
import '../elements/data_label.dart';
import '../elements/legend.dart';
import '../elements/marker.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../enum.dart';
import '../layer/layer_base.dart';
import '../layer/vector_layers.dart';
import '../settings.dart';
import '../utils.dart';
import 'tile_layer.dart';

class _ShapeBounds {
  _ShapeBounds(
      {this.minLongitude,
      this.minLatitude,
      this.maxLongitude,
      this.maxLatitude});

  num? minLongitude;

  num? minLatitude;

  num? maxLongitude;

  num? maxLatitude;

  _ShapeBounds get empty => _ShapeBounds(
      minLongitude: null,
      minLatitude: null,
      maxLongitude: null,
      maxLatitude: null);
}

class _ShapeFileData {
  Map<String, dynamic>? decodedJsonData;

  late Map<String, MapModel> mapDataSource;

  late _ShapeBounds bounds;

  late MapModel initialSelectedModel;

  void reset() {
    decodedJsonData?.clear();
    mapDataSource.clear();
    bounds = bounds.empty;
  }
}

Future<_ShapeFileData> _retrieveDataFromShapeFile(
    MapProvider provider,
    String? shapeDataField,
    _ShapeFileData shapeFileData,
    bool isShapeFileDecoded,
    bool isSublayer) async {
  if (isShapeFileDecoded) {
    return shapeFileData;
  }
  final String assertBundleData = await provider.loadString();
  final Map<String, dynamic> data = <String, dynamic>{
    'AssertBundleData': assertBundleData,
    'ShapeDataField': shapeDataField,
    'ShapeFileData': shapeFileData,
    'IsSublayer': isSublayer
  };
  return compute(_decodeJsonData, data);
}

_ShapeFileData _decodeJsonData(Map<String, dynamic> data) {
  data['ShapeFileData'].decodedJsonData = jsonDecode(data['AssertBundleData']);
  _readJsonFile(data);
  return data['ShapeFileData'];
}

void _readJsonFile(Map<String, dynamic> data) {
  List<dynamic> polygonGeometryData;
  int multipolygonGeometryLength;
  late Map<String, dynamic> geometry;
  Map<String, dynamic>? properties;

  final _ShapeFileData shapeFileData = data['ShapeFileData'];
  final String? shapeDataField = data['ShapeDataField'];
  final bool isSublayer = data['IsSublayer'];
  final bool hasFeatures =
      shapeFileData.decodedJsonData!.containsKey('features');
  final bool hasGeometries =
      shapeFileData.decodedJsonData!.containsKey('geometries');
  final String? key = hasFeatures
      ? 'features'
      : hasGeometries
          ? 'geometries'
          : null;
  final int jsonLength = key == null || key.isEmpty
      ? 0
      : shapeFileData.decodedJsonData![key].length;
  if (isSublayer) {
    shapeFileData.bounds = _ShapeBounds(
        minLatitude: minimumLatitude,
        maxLatitude: maximumLatitude,
        minLongitude: minimumLongitude,
        maxLongitude: maximumLongitude);
  }

  for (int i = 0; i < jsonLength; i++) {
    if (hasFeatures) {
      final dynamic features = shapeFileData.decodedJsonData![key][i];
      geometry = features['geometry'];
      properties = features['properties'];
    } else if (hasGeometries) {
      geometry = shapeFileData.decodedJsonData![key][i];
    }

    if (geometry['type'] == 'Polygon') {
      polygonGeometryData = geometry['coordinates'][0];
      _updateMapDataSource(shapeFileData, shapeDataField, properties,
          polygonGeometryData, isSublayer);
    } else {
      multipolygonGeometryLength = geometry['coordinates'].length;
      for (int j = 0; j < multipolygonGeometryLength; j++) {
        polygonGeometryData = geometry['coordinates'][j][0];
        _updateMapDataSource(shapeFileData, shapeDataField, properties,
            polygonGeometryData, isSublayer);
      }
    }
  }
}

void _updateMapDataSource(_ShapeFileData shapeFileData, String? shapeDataField,
    Map<String, dynamic>? properties, List<dynamic> points, bool isSublayer) {
  final String dataPath =
      properties != null ? (properties[shapeDataField] ?? '') : '';
  shapeFileData.mapDataSource.update(
    dataPath,
    (MapModel model) {
      model.rawPoints.add(points);
      return model;
    },
    ifAbsent: () {
      final int dataSourceIndex = shapeFileData.mapDataSource.length;
      return MapModel(
        primaryKey: dataPath,
        actualIndex: dataSourceIndex,
        legendMapperIndex: dataSourceIndex,
        rawPoints: <List<dynamic>>[points],
      );
    },
  );
  if (!isSublayer) {
    _updateShapeBounds(shapeFileData, points);
  }
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
          min(longitude, shapeFileData.bounds.minLongitude!);
      shapeFileData.bounds.minLatitude =
          min(latitude, shapeFileData.bounds.minLatitude!);
      shapeFileData.bounds.maxLongitude =
          max(longitude, shapeFileData.bounds.maxLongitude!);
      shapeFileData.bounds.maxLatitude =
          max(latitude, shapeFileData.bounds.maxLatitude!);
    }
  }
}

MapProvider _sourceProvider(
    Object geoJsonSource, _MapSourceType geoJSONSourceType) {
  switch (geoJSONSourceType) {
    case _MapSourceType.asset:
      return AssetMapProvider(geoJsonSource.toString());
    case _MapSourceType.network:
      return NetworkMapProvider(geoJsonSource.toString());
    case _MapSourceType.memory:
      // ignore: avoid_as
      return MemoryMapProvider(geoJsonSource as Uint8List);
  }
}

enum _MapSourceType { asset, network, memory }

/// The source that maps the data source with the shape file and provides
/// data for the elements of the shape layer like data labels, bubbles, tooltip,
/// and shape colors.
///
/// The source can be set as the .json file from an asset bundle, network
/// or from [Uint8List] as bytes. Use the respective constructor depends on the
/// type of the source.
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
///  MapShapeSource _mapSource;
///  List<Model> _data;
///
///  @override
///  void initState() {
///
///    _data = <Model>[
///     Model('India', 280, "Low"),
///     Model('United States of America', 190, "High"),
///     Model('Pakistan', 37, "Low"),
///    ];
///
///    _mapSource = MapShapeSource.asset(
///      'assets/world_map.json',
///      shapeDataField: 'name',
///      dataCount: _data.length,
///      primaryValueMapper: (int index) {
///        return _data[index].country;
///      },
///      dataLabelMapper: (int index) {
///        return _data[index].country;
///      },
///    );
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            source: _mapSource,
///            showDataLabels: true,
///         )
///      ],
///    );
///  }
///
/// class Model {
///  const Model(this.country, this.count, this.storage);
///
///  final String country;
///  final double count;
///  final String storage;
/// }
/// ```
/// See also:
/// * [MapShapeSource.primaryValueMapper], to map the data of the data
/// source collection with the respective [MapShapeSource.shapeDataField] in
/// .json file.
/// * [MapShapeSource.bubbleSizeMapper], to customize the bubble size.
/// * [MapShapeSource.dataLabelMapper], to customize the
/// data label's text.
/// * [MapShapeSource.shapeColorValueMapper] and
/// [MapShapeSource.shapeColorMappers], to customize the shape colors.
/// * [MapShapeSource.bubbleColorValueMapper] and
/// [MapShapeSource.bubbleColorMappers], to customize the
/// bubble colors.
class MapShapeSource extends DiagnosticableTree {
  /// Creates a layer using the .json file from an asset bundle.
  ///
  /// ```dart
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _mapSource = MapShapeSource.asset(
  ///      'assets/Ireland.json',
  ///      shapeDataField: 'name',
  ///    );
  ///  }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Asset sample'),
  ///     ),
  ///     body: Container(
  ///       color: Colors.blue[100],
  ///       child: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             showDataLabels: true,
  ///             color: Colors.orange[100],
  ///           ),
  ///        ],
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  const MapShapeSource.asset(
    String name, {
    this.shapeDataField,
    this.dataCount = 0,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _geoJSONSource = name,
        _geoJSONSourceType = _MapSourceType.asset,
        assert((primaryValueMapper != null && dataCount > 0) ||
            primaryValueMapper == null),
        assert((shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null) ||
            shapeColorMappers == null),
        assert((bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null) ||
            bubbleColorMappers == null);

  /// Creates a layer using the .json file from the network.
  ///
  /// ```dart
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _mapSource = MapShapeSource.network(
  ///      'http://www.json-generator.com/api/json/get/bVqXoJvfjC?indent=2',
  ///    );
  ///
  ///    super.initState();
  ///  }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Network sample'),
  ///     ),
  ///     body: SfMaps(
  ///       layers: [
  ///         MapShapeLayer(
  ///           source: _mapSource,
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  const MapShapeSource.network(
    String src, {
    this.shapeDataField,
    this.dataCount = 0,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _geoJSONSource = src,
        _geoJSONSourceType = _MapSourceType.network,
        assert((primaryValueMapper != null && dataCount > 0) ||
            primaryValueMapper == null),
        assert((shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null) ||
            shapeColorMappers == null),
        assert((bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null) ||
            bubbleColorMappers == null);

  /// Creates a layer using the GeoJSON source as bytes from [Uint8List].
  ///
  /// ```dart
  ///  MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    _mapSource = MapShapeSource.memory(
  ///      bytes,
  ///      shapeDataField: 'name'
  ///    );
  ///  }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Memory sample'),
  ///     ),
  ///     body: Center(
  ///         child: SfMaps(
  ///       layers: [
  ///         MapShapeLayer(
  ///          source: _mapSource,
  ///           showDataLabels: true,
  ///           color: Colors.orange[100],
  ///         ),
  ///       ],
  ///     )),
  ///   );
  /// }
  /// ```
  const MapShapeSource.memory(
    Uint8List bytes, {
    this.shapeDataField,
    this.dataCount = 0,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _geoJSONSource = bytes,
        _geoJSONSourceType = _MapSourceType.memory,
        assert((primaryValueMapper != null && dataCount > 0) ||
            primaryValueMapper == null),
        assert((shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null) ||
            shapeColorMappers == null),
        assert((bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null) ||
            bubbleColorMappers == null);

  /// Field name in the .json file to identify each shape.
  ///
  /// It is used to refer the field name in the .json file to identify
  /// each shape and map that shape with the respective data in
  /// the data source.
  final String? shapeDataField;

  /// Length of the data source.
  final int dataCount;

  /// Collection of [MapColorMapper] which specifies shape's color based on the
  /// data.
  ///
  /// It provides option to set the shape color based on the specific
  /// [MapColorMapper.value] or the range of values which falls between
  /// [MapColorMapper.from] and [MapColorMapper.to].
  ///
  /// Based on the returned values, legend items will be rendered. The text of
  /// legend item will be [MapColorMapper.text] of the [MapColorMapper].
  ///
  /// The below code snippet represents how color can be applied to the shape
  /// based on the [MapColorMapper.value] property of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      shapeColorValueMapper: (int index) {
  ///         return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///         MapColorMapper(value: "Low", color: Colors.red),
  ///         MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  /// The below code snippet represents how color can be applied to the shape
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      shapeColorValueMapper: (int index) {
  ///         return _data[index].count;
  ///      },
  ///      shapeColorMappers: [
  ///         MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///         MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///      ]
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  final List<MapColorMapper>? shapeColorMappers;

  /// Collection of [MapColorMapper] which specifies bubble's color
  /// based on the data.
  ///
  /// It provides option to set the bubble color based on the specific
  /// [MapColorMapper.value] or the range of values which falls between
  /// [MapColorMapper.from] and [MapColorMapper.to].
  ///
  /// The below code snippet represents how color can be applied to the bubble
  /// based on the [MapColorMapper.value] property of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      bubbleColorValueMapper: (int index) {
  ///        return _data[index].count;
  ///      },
  ///      bubbleSizeMapper: (int index) {
  ///        return _data[index].count;
  ///      },
  ///      bubbleColorMappers: [
  ///        MapColorMapper(from: 0, to: 100, color: Colors.red),
  ///        MapColorMapper(from: 101, to: 300, color: Colors.yellow)
  ///      ]
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  /// The below code snippet represents how color can be applied to the bubble
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      bubbleColorValueMapper: (int index) {
  ///        return _data[index].storage;
  ///      },
  ///      bubbleSizeMapper: (int index) {
  ///        return _data[index].count;
  ///      },
  ///     bubbleColorMappers: [
  ///       MapColorMapper(value: "Low", color: Colors.red),
  ///       MapColorMapper(value: "High", color: Colors.yellow)
  ///     ]
  ///   );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  final List<MapColorMapper>? bubbleColorMappers;

  /// Returns the the primary value for the every data in the data source
  /// collection.
  ///
  /// This primary value will be mapped with the [shapeDataField] value in the
  /// respective shape detail in the .json file. This mapping will then be used
  /// in the rendering of bubbles, data labels, shape colors, tooltip
  /// in their respective shape's coordinates.
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///   );
  ///  }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  final IndexedStringValueMapper? primaryValueMapper;

  /// Returns the data label text for each shape.
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      dataLabelMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///   );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showDataLabels: true,
  ///          source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.count, this.storage);
  ///
  ///  final String country;
  ///  final double count;
  ///  final String storage;
  /// }
  /// ```
  final IndexedStringValueMapper? dataLabelMapper;

  /// Returns a value based on which bubble size will be calculated.
  ///
  /// The minimum and maximum size of the bubble can be customized using the
  /// [MapBubbleSettings.minRadius] and [MapBubbleSettings.maxRadius].
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      bubbleSizeMapper: (int index) {
  ///        return _data[index].usersCount;
  ///      }
  ///   );
  ///  }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///            source: _mapSource,
  ///        )
  ///      ],
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.usersCount, this.storage);
  ///
  ///  final String country;
  ///  final double usersCount;
  ///  final String storage;
  /// }
  /// ```
  final IndexedDoubleValueMapper? bubbleSizeMapper;

  /// Returns a color or value based on which shape color will be updated.
  ///
  /// If this returns a color, then this color will be applied to the shape
  /// straightaway.
  ///
  /// If it returns a value other than the color, then you must set the
  /// [MapShapeSource.shapeColorMappers] property.
  ///
  /// The value returned from the [shapeColorValueMapper] will be used for the
  /// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
  /// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
  /// the respective shape.
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      shapeColorValueMapper: (int index) {
  ///        return _data[index].color;
  ///      }
  ///   );
  ///  }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
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
  ///  final Color color;
  /// }
  /// ```
  final IndexedColorValueMapper? shapeColorValueMapper;

  /// Returns a color or value based on which bubble color will be updated.
  ///
  /// If this returns a color, then this color will be applied to the bubble
  /// straightaway.
  ///
  /// If it returns a value other than the color, then you must set the
  /// [MapShapeSource.bubbleColorMappers] property.
  ///
  /// The value returned from the [bubbleColorValueMapper] will be used for the
  /// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
  /// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
  /// the respective bubble.
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      bubbleColorValueMapper: (int index) {
  ///        return _data[index].color;
  ///      },
  ///      bubbleSizeMapper: (int index) {
  ///        return _data[index].usersCount;
  ///      }
  ///   );
  ///  }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
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
  final IndexedColorValueMapper? bubbleColorValueMapper;

  /// Specifies the GeoJSON data source file.
  final Object _geoJSONSource;

  /// Specifies the type of the source.
  final _MapSourceType _geoJSONSourceType;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final MapProvider provider =
        _sourceProvider(_geoJSONSource, _geoJSONSourceType);
    if (provider.shapePath != null) {
      properties.add(StringProperty('', provider.shapePath));
    }
    if (provider.bytes != null) {
      properties.add(StringProperty('', 'Shape source in bytes'));
    }
    properties.add(StringProperty('shapeDataField', shapeDataField));
    properties.add(IntProperty('dataCount', dataCount));
    properties.add(ObjectFlagProperty<IndexedStringValueMapper>.has(
        'primaryValueMapper', primaryValueMapper));
    properties.add(ObjectFlagProperty<List<MapColorMapper>>.has(
        'shapeColorMappers', shapeColorMappers));
    properties.add(ObjectFlagProperty<List<MapColorMapper>>.has(
        'bubbleColorMappers', bubbleColorMappers));
    properties.add(ObjectFlagProperty<IndexedStringValueMapper>.has(
        'dataLabelMapper', dataLabelMapper));
    properties.add(ObjectFlagProperty<IndexedDoubleValueMapper>.has(
        'bubbleSizeMapper', bubbleSizeMapper));
    properties.add(ObjectFlagProperty<IndexedColorValueMapper>.has(
        'shapeColorValueMapper', shapeColorValueMapper));
    properties.add(ObjectFlagProperty<IndexedColorValueMapper>.has(
        'bubbleColorValueMapper', bubbleColorValueMapper));
  }
}

/// Provides option for adding, removing, deleting and updating marker
/// collection.
///
/// You can also get the current markers count, selected shape's index and
/// convert pixel points to latitude and longitude using this.
///
/// You need to set the instance of this to [MapShapeLayer.controller] as
/// shown in the below code snippet.
///
/// ```dart
/// List<Model> _data;
/// MapShapeLayerController controller;
/// MapShapeSource _mapSource;
/// Random random = Random();
///
/// @override
/// void initState() {
///     _data = <Model>[
///       Model(-14.235004, -51.92528),
///       Model(51.16569, 10.451526),
///       Model(-25.274398, 133.775136),
///       Model(20.593684, 78.96288),
///       Model(61.52401, 105.318756)
///     ];
///    _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "name",
///   );
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
///                       source: _mapSource,
///                        initialMarkersCount: 5,
///                        markerBuilder: (BuildContext context, int index){
///                          return MapMarker(
///                            latitude: _data[index].latitude,
///                            longitude: _data[index].longitude,
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
  late _RenderGeoJSONLayer _parentBox;

  /// Returns the current markers count.
  int get markersCount => _markersCount;
  int _markersCount = 0;

  /// Converts pixel point to [MapLatLng].
  MapLatLng pixelToLatLng(Offset position) {
    return getPixelToLatLng(
        position,
        _parentBox.size,
        _parentBox._controller.shapeLayerOffset,
        _parentBox._controller.shapeLayerSizeFactor);
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
/// The [MapShapeSublayer.shapeDataField] property is used to
/// refer the unique field name in the .json file to identify each shapes and
/// map with the respective data in the data source.
///
/// By default, the value specified for the
/// [MapShapeSublayer.shapeDataField] in the GeoJSON source will be used in
/// the elements like data labels, and tooltip for their respective
/// shapes.
///
/// However, it is possible to keep a data source and customize these elements
/// based on the requirement. The value of the
/// [MapShapeSublayer.shapeDataField] will be used to map with the
/// respective data returned in [MapShapeSublayer.primaryValueMapper]
/// from the data source.
///
/// Once the above mapping is done, you can customize the elements using the
/// APIs like [MapShapeSublayer.dataLabelMapper],
/// [MapShapeSublayer.shapeColorMappers], etc.
///
/// The snippet below shows how to render the basic world map using the data
/// from .json file.
///
/// ```dart
/// MapShapeSource _mapSource;
/// MapShapeSource _mapSublayerSource;
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
  });

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
  /// MapShapeSource _mapSource;
  /// MapShapeSource _mapSublayerSource;
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
  /// MapShapeSource _mapSource;
  ///   MapShapeSource _mapSublayerSource;
  ///   List<DataModel> _data;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///
  ///   @override
  ///   void initState() {
  ///     _data = <DataModel>[
  ///       DataModel('Orissa', 280, "Low", Colors.red),
  ///       DataModel('Karnataka', 190, "High", Colors.green),
  ///       DataModel('Tamil Nadu', 37, "Low", Colors.yellow),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///         shapeDataField: "continent");
  ///
  ///     _mapSublayerSource = MapShapeSource.asset("assets/india.json",
  ///         shapeDataField: "name",
  ///         dataCount: _data.length,
  ///         primaryValueMapper: (int index) => _data[index].country,
  ///         shapeColorValueMapper: (int index) => _data[index].color);
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: Padding(
  ///         padding: EdgeInsets.all(15),
  ///         child: SfMaps(
  ///           layers: <MapLayer>[
  ///             MapShapeLayer(
  ///               source: _mapSource,
  ///               zoomPanBehavior: _zoomPanBehavior,
  ///               sublayers: [
  ///                 MapShapeSublayer(
  ///                   source: _mapSublayerSource,
  ///                   shapeTooltipBuilder: (BuildContext context, int index) {
  ///                     if (index == 0) {
  ///                       return Container(
  ///                         child: Icon(Icons.airplanemode_inactive),
  ///                       );
  ///                     } else {
  ///                       return Container(
  ///                         child: Icon(Icons.airplanemode_active),
  ///                       );
  ///                     }
  ///                   },
  ///                 ),
  ///               ],
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     );
  ///   }
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
  ///  MapShapeSource _mapSource;
  ///   MapShapeSource _mapSublayerSource;
  ///   List<DataModel> _data;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///
  ///   @override
  ///   void initState() {
  ///     _data = <DataModel>[
  ///       DataModel('Orissa', 280, "Low", Colors.red),
  ///       DataModel('Karnataka', 190, "High", Colors.green),
  ///       DataModel('Tamil Nadu', 37, "Low", Colors.yellow),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///         shapeDataField: "continent");
  ///
  ///     _mapSublayerSource = MapShapeSource.asset("assets/india.json",
  ///         shapeDataField: "name",
  ///         dataCount: _data.length,
  ///         primaryValueMapper: (int index) => _data[index].country,
  ///         bubbleColorValueMapper: (int index) {
  ///           return _data[index].color;
  ///         },
  ///         bubbleSizeMapper: (int index) {
  ///           return _data[index].usersCount;
  ///         });
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: Padding(
  ///         padding: EdgeInsets.all(15),
  ///         child: SfMaps(
  ///           layers: <MapLayer>[
  ///             MapShapeLayer(
  ///               source: _mapSource,
  ///               zoomPanBehavior: _zoomPanBehavior,
  ///               sublayers: [
  ///                 MapShapeSublayer(
  ///                  source: _mapSublayerSource,
  ///                  bubbleTooltipBuilder: (BuildContext context, int index) {
  ///                     if (index == 0) {
  ///                       return Container(
  ///                         child: Icon(Icons.airplanemode_inactive),
  ///                       );
  ///                     } else {
  ///                       return Container(
  ///                         child: Icon(Icons.airplanemode_active),
  ///                       );
  ///                     }
  ///                   },
  ///                 ),
  ///               ],
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     );
  ///   }
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
  ///  MapShapeSource _mapSource;
  ///   MapShapeSource _mapSublayerSource;
  ///   List<MapLatLng> _data;
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///
  ///   @override
  ///   void initState() {
  ///     _data = <MapLatLng>[
  ///       MapLatLng(11.1271, 78.6569),
  ///       MapLatLng(15.3173, 75.7139),
  ///       MapLatLng(28.7041, 77.1025)
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///         shapeDataField: "continent");
  ///
  ///     _mapSublayerSource = MapShapeSource.asset(
  ///       "assets/india.json",
  ///       shapeDataField: "name",
  ///     );
  ///
  ///     _zoomPanBehavior = MapZoomPanBehavior(
  ///         zoomLevel: 5, focalLatLng: MapLatLng(28.7041, 77.1025));
  ///
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: Padding(
  ///         padding: EdgeInsets.all(15),
  ///         child: SfMaps(
  ///           layers: <MapLayer>[
  ///             MapShapeLayer(
  ///               source: _mapSource,
  ///               zoomPanBehavior: _zoomPanBehavior,
  ///               sublayers: [
  ///                 MapShapeSublayer(
  ///                   source: _mapSublayerSource,
  ///                   initialMarkersCount: 3,
  ///                   markerBuilder: (BuildContext context, int index) {
  ///                     return MapMarker(
  ///                       latitude: _data[index].latitude,
  ///                       longitude: _data[index].longitude,
  ///                     );
  ///                  },
  ///                  markerTooltipBuilder: (BuildContext context, int index) {
  ///                     if(index == 0) {
  ///                       return Container(
  ///                         child: Icon(Icons.airplanemode_inactive),
  ///                       );
  ///                     }
  ///                     else
  ///                     {
  ///                       return Container(
  ///                        child: Icon(Icons.airplanemode_active),
  ///                       );
  ///                      }
  ///                   },
  ///                 ),
  ///               ],
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     );
  ///   }
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
    return _GeoJSONLayer(
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
        ifFalse: 'Data labels are not showing',
        showName: false));
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
/// MapShapeSource _mapSource;
///
/// @override
/// void initState() {
///    _mapSource = MapShapeSource.asset(
///      "assets/world_map.json",
///      shapeDataField: "name",
///   );
///    super.initState();
/// }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: _mapSource,
///        )
///      ],
///    );
///  }
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
  /// MapShapeSource _mapSource;
  /// List<Model> _data;
  ///
  /// @override
  /// void initState() {
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      dataLabelMapper: (int index) {
  ///        return _data[index].country;
  ///      }
  ///   );
  ///    super.initState();
  /// }
  ///
  ///   @override
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
  /// MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "continent",
  ///    );
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
  /// MapShapeSource _mapSource;
  /// List<Model> _data;
  ///
  /// @override
  /// void initState() {
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) => _data[index].country,
  ///      shapeColorValueMapper: (int index) => _data[index].color
  ///    );
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
  /// List<Model> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <Model>[
  ///     Model('India', 280, "Low", Colors.red),
  ///     Model('United States of America', 190, "High", Colors.green),
  ///     Model('Pakistan', 37, "Low", Colors.yellow),
  ///    ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///      dataCount: _data.length,
  ///      primaryValueMapper: (int index) {
  ///        return _data[index].country;
  ///      },
  ///      bubbleColorValueMapper: (int index) {
  ///        return _data[index].color;
  ///      },
  ///      bubbleSizeMapper: (int index) {
  ///        return _data[index].usersCount;
  ///      }
  ///   );
  ///  }
  ///
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleTooltipBuilder: (BuildContext context, int index) {
  ///            if(index == 0) {
  ///               return Container(
  ///                 child: Icon(Icons.airplanemode_inactive),
  ///               );
  ///            }
  ///            else
  ///             {
  ///               return Container(
  ///                 child: Icon(Icons.airplanemode_active),
  ///               );
  ///             }
  ///          },
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
  final IndexedWidgetBuilder? bubbleTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count and selected shape's index from
  /// this.
  ///
  /// ```dart
  /// List<Model> _data;
  /// MapShapeLayerController _controller;
  /// Random _random = Random();
  /// MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///     _data = <Model>[
  ///       Model(-14.235004, -51.92528),
  ///       Model(51.16569, 10.451526),
  ///       Model(-25.274398, 133.775136),
  ///       Model(20.593684, 78.96288),
  ///       Model(61.52401, 105.318756)
  ///     ];
  ///
  ///    _mapSource = MapShapeSource.asset(
  ///      "assets/world_map.json",
  ///      shapeDataField: "name",
  ///   );
  ///
  ///    _controller = MapShapeLayerController();
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
  ///                       source: _mapSource,
  ///                        initialMarkersCount: 5,
  ///                        markerBuilder: (BuildContext context, int index) {
  ///                          return MapMarker(
  ///                            latitude: _data[index].latitude,
  ///                            longitude: _data[index].longitude,
  ///                            child: Icon(Icons.add_location),
  ///                          );
  ///                        },
  ///                        controller: _controller,
  ///                      ),
  ///                    ],
  ///                  ),
  ///                  RaisedButton(
  ///                    child: Text('Add marker'),
  ///                    onPressed: () {
  ///                      _data.add(Model(
  ///                          -180 + _random.nextInt(360).toDouble(),
  ///                          -55 + _random.nextInt(139).toDouble()));
  ///                      _controller.insertMarker(5);
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
  /// * [MapShapeLayer.bubbleSizeMapper], to show the bubbles.
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
  /// List<DataModel> _data;
  ///   MapShapeSource _mapSource;
  ///   int _selectedIndex = -1;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///
  ///     _data = <DataModel>[
  ///       DataModel('India', 280, "Low", Colors.red),
  ///       DataModel('United States of America', 190, "High", Colors.green),
  ///       DataModel('Pakistan', 37, "Low", Colors.yellow),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset(
  ///       "assets/world_map.json",
  ///       shapeDataField: "name",
  ///       dataCount: _data.length,
  ///       primaryValueMapper: (int index) => _data[index].country,
  ///       shapeColorValueMapper: (int index) => _data[index].color,
  ///     );
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: Center(
  ///           child: Container(
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
  ///                         color: Colors.pink,),
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
  ///       )),
  ///     );
  ///   }
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(
  ///      this.country,
  ///      this.usersCount,
  ///      this.storage,
  ///      this.color,
  ///   );
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
        ifFalse: 'Data labels are not showing',
        showName: false));
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
  _ShapeLayer({
    required this.source,
    required this.loadingBuilder,
    required this.controller,
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
      child: _GeoJSONLayer(
        source: widget.source,
        loadingBuilder: widget.loadingBuilder,
        controller: widget.controller,
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

class _GeoJSONLayer extends StatefulWidget {
  const _GeoJSONLayer({
    required this.source,
    required this.controller,
    required this.initialMarkersCount,
    required this.markerBuilder,
    required this.shapeTooltipBuilder,
    required this.bubbleTooltipBuilder,
    required this.markerTooltipBuilder,
    required this.showDataLabels,
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
    required this.dataLabelSettings,
    required this.bubbleSettings,
    required this.selectionSettings,
    required this.tooltipSettings,
    required this.selectedIndex,
    required this.onSelectionChanged,
    this.loadingBuilder,
    this.legend,
    this.zoomPanBehavior,
    this.onWillZoom,
    this.onWillPan,
    this.sublayerAncestor,
    this.sublayers,
  });

  final MapShapeSource source;
  final MapShapeLayerController? controller;
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
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapTooltipSettings tooltipSettings;
  final int selectedIndex;
  final ValueChanged<int>? onSelectionChanged;
  final MapLoadingBuilder? loadingBuilder;
  final MapLegend? legend;
  final MapZoomPanBehavior? zoomPanBehavior;
  final WillZoomCallback? onWillZoom;
  final WillPanCallback? onWillPan;
  final MapShapeSublayer? sublayerAncestor;
  final List<MapSublayer>? sublayers;

  @override
  _GeoJSONLayerState createState() => _GeoJSONLayerState();
}

class _GeoJSONLayerState extends State<_GeoJSONLayer>
    with TickerProviderStateMixin {
  late GlobalKey bubbleKey;
  late _ShapeFileData shapeFileData;
  late SfMapsThemeData _mapsThemeData;
  late MapLayerInheritedWidget ancestor;
  // Converts the given source file to future string based on source type.
  late MapProvider _provider;

  late AnimationController toggleAnimationController;
  late AnimationController _hoverBubbleAnimationController;
  late AnimationController bubbleAnimationController;
  late AnimationController dataLabelAnimationController;
  late AnimationController hoverShapeAnimationController;
  late AnimationController selectionAnimationController;
  late AnimationController zoomLevelAnimationController;
  late AnimationController focalLatLngAnimationController;

  List<Widget>? _markers;
  MapLegend? _legendConfiguration;
  MapLegendWidget? _legendWidget;

  double? minBubbleValue;
  double? maxBubbleValue;

  bool _isShapeFileDecoded = false;
  bool _shouldUpdateMapDataSource = true;
  bool isDesktop = false;
  bool _hasSublayer = false;
  bool isSublayer = false;

  MapController? _controller;

  List<Widget> get _geoJSONLayerChildren {
    final List<Widget> children = <Widget>[];
    if (_hasSublayer) {
      children.add(_sublayerContainer);
    }
    if (_markers != null && _markers!.isNotEmpty) {
      children.add(_markerContainer);
    }

    return children;
  }

  Widget get _shapeLayerRenderObjectWidget => _GeoJSONLayerRenderObjectWidget(
        controller: _controller!,
        mapDataSource: shapeFileData.mapDataSource,
        mapSource: widget.source,
        selectedIndex: widget.selectedIndex,
        legend: _legendWidget,
        selectionSettings: widget.selectionSettings,
        zoomPanBehavior: widget.zoomPanBehavior,
        bubbleSettings: widget.bubbleSettings.copyWith(
            color: _mapsThemeData.bubbleColor,
            strokeColor: _mapsThemeData.bubbleStrokeColor,
            strokeWidth: _mapsThemeData.bubbleStrokeWidth),
        themeData: _mapsThemeData,
        state: this,
        children: _geoJSONLayerChildren,
      );

  Widget get _bubbleWidget => MapBubble(
        key: bubbleKey,
        controller: _controller,
        source: widget.source,
        mapDataSource: shapeFileData.mapDataSource,
        bubbleSettings: widget.bubbleSettings.copyWith(
            color: _mapsThemeData.bubbleColor,
            strokeColor: _mapsThemeData.bubbleStrokeColor,
            strokeWidth: _mapsThemeData.bubbleStrokeWidth),
        legend: _legendWidget,
        showDataLabels: widget.showDataLabels,
        themeData: _mapsThemeData,
        bubbleAnimationController: bubbleAnimationController,
        dataLabelAnimationController: dataLabelAnimationController,
        toggleAnimationController: toggleAnimationController,
        hoverBubbleAnimationController: _hoverBubbleAnimationController,
      );

  Widget get _dataLabelWidget => MapDataLabel(
        controller: _controller,
        source: widget.source,
        mapDataSource: shapeFileData.mapDataSource,
        settings: widget.dataLabelSettings,
        effectiveTextStyle: Theme.of(context).textTheme.caption!.merge(
            widget.dataLabelSettings.textStyle ??
                _mapsThemeData.dataLabelTextStyle),
        themeData: _mapsThemeData,
        dataLabelAnimationController: dataLabelAnimationController,
      );

  Widget get _sublayerContainer =>
      SublayerContainer(ancestor: ancestor, children: widget.sublayers!);

  Widget get _markerContainer => MarkerContainer(
        controller: _controller!,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        sublayer: widget.sublayerAncestor,
        ancestor: ancestor,
        children: _markers,
      );

  Widget get _behaviorViewRenderObjectWidget => BehaviorViewRenderObjectWidget(
      controller: _controller!, zoomPanBehavior: widget.zoomPanBehavior!);

  Widget get _toolbarWidget => MapToolbar(
        controller: _controller,
        onWillZoom: widget.onWillZoom,
        zoomPanBehavior: widget.zoomPanBehavior!,
      );

  Widget get _tooltipWidget => MapTooltip(
        key: _controller!.tooltipKey,
        controller: _controller,
        mapSource: widget.source,
        sublayers: widget.sublayers,
        tooltipSettings: widget.tooltipSettings,
        shapeTooltipBuilder: widget.shapeTooltipBuilder,
        bubbleTooltipBuilder: widget.bubbleTooltipBuilder,
        markerTooltipBuilder: widget.markerTooltipBuilder,
        themeData: _mapsThemeData,
      );

  Widget get _shapeLayerWithElements {
    final List<Widget> children = <Widget>[];
    children.add(_shapeLayerRenderObjectWidget);
    if (widget.source.bubbleSizeMapper != null) {
      children.add(_bubbleWidget);
    }

    if (widget.showDataLabels) {
      children.add(_dataLabelWidget);
    }

    if (!isSublayer) {
      if (widget.zoomPanBehavior != null) {
        children.add(_behaviorViewRenderObjectWidget);
        if (widget.zoomPanBehavior!.showToolbar && isDesktop) {
          children.add(_toolbarWidget);
        }
      }

      if (_hasTooltipBuilder()) {
        children.add(_tooltipWidget);
      }
    }

    return ClipRect(child: Stack(children: children));
  }

  Widget get _shapeLayerWithLegend {
    if (_legendConfiguration != null) {
      _updateLegendWidget();
      if (_legendConfiguration!.offset == null) {
        switch (_legendConfiguration!.position) {
          case MapLegendPosition.top:
            return Column(
              children: <Widget>[_legendWidget!, _expandedShapeLayerWidget],
            );
          case MapLegendPosition.bottom:
            return Column(
                children: <Widget>[_expandedShapeLayerWidget, _legendWidget!]);
          case MapLegendPosition.left:
            return Row(
              children: <Widget>[_legendWidget!, _expandedShapeLayerWidget],
            );
          case MapLegendPosition.right:
            return Row(
              children: <Widget>[_expandedShapeLayerWidget, _legendWidget!],
            );
        }
      } else {
        return _stackedLegendAndShapeLayerWidget;
      }
    }

    return _shapeLayerWithElements;
  }

  Widget get _expandedShapeLayerWidget => Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[_shapeLayerWithElements],
        ),
      );

  /// Returns the legend and map overlapping widget.
  Widget get _stackedLegendAndShapeLayerWidget => Stack(
        children: <Widget>[
          _shapeLayerWithElements,
          Align(
            alignment:
                _getActualLegendAlignment(_legendConfiguration!.position),
            // Padding widget is used to set the custom position to the legend.
            child: Padding(
              padding: _getActualLegendOffset(context),
              child: _legendWidget,
            ),
          ),
        ],
      );

  bool _hasTooltipBuilder() {
    if (isSublayer) {
      return false;
    }

    if (widget.shapeTooltipBuilder != null ||
        widget.bubbleTooltipBuilder != null ||
        widget.markerTooltipBuilder != null) {
      return true;
    } else if (_hasSublayer) {
      final Iterator<MapSublayer> iterator = widget.sublayers!.iterator;
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

  void _updateLegendWidget() {
    _legendWidget = _legendWidget!.copyWith(
      dataSource: _getLegendSource() ?? shapeFileData.mapDataSource,
      legend: _legendConfiguration!,
      themeData: _mapsThemeData,
      controller: _controller,
      toggleAnimationController: toggleAnimationController,
    );
  }

  List<MapColorMapper>? _getLegendSource() {
    switch (widget.legend!.source) {
      case MapElement.bubble:
        return widget.source.bubbleColorMappers;
      case MapElement.shape:
        return widget.source.shapeColorMappers;
    }
  }

  /// Returns the alignment for the legend if we set the legend offset.
  AlignmentGeometry _getActualLegendAlignment(MapLegendPosition position) {
    switch (position) {
      case MapLegendPosition.top:
        return Alignment.topCenter;
      case MapLegendPosition.bottom:
        return Alignment.bottomCenter;
      case MapLegendPosition.left:
        return Alignment.centerLeft;
      case MapLegendPosition.right:
        return Alignment.centerRight;
    }
  }

  /// Returns the padding value to render the legend based on offset value.
  EdgeInsetsGeometry _getActualLegendOffset(BuildContext context) {
    final Offset offset = _legendConfiguration!.offset!;
    final MapLegendPosition legendPosition = _legendConfiguration!.position;
    // Here the default alignment is center for all the positions.
    // So need to handle the offset by multiplied it by 2.
    switch (legendPosition) {
      // Returns the insets for the offset if the legend position is top.
      case MapLegendPosition.top:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            top: offset.dy > 0 ? offset.dy : 0);
      // Returns the insets for the offset if the legend position is left.
      case MapLegendPosition.left:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            left: offset.dx > 0 ? offset.dx : 0);
      // Returns the insets for the offset if the legend position is right.
      case MapLegendPosition.right:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() : 0);
      // Returns the insets for the offset if the legend position is bottom.
      case MapLegendPosition.bottom:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() : 0);
    }
  }

  void _updateThemeData(BuildContext context) {
    final bool isLightTheme = _mapsThemeData.brightness == Brightness.light;
    _mapsThemeData = _mapsThemeData.copyWith(
      layerColor: widget.color ??
          (isSublayer
              ? (isLightTheme
                  ? const Color.fromRGBO(198, 198, 198, 1)
                  : const Color.fromRGBO(71, 71, 71, 1))
              : _mapsThemeData.layerColor),
      layerStrokeColor: widget.strokeColor ??
          (isSublayer
              ? (isLightTheme
                  ? const Color.fromRGBO(145, 145, 145, 1)
                  : const Color.fromRGBO(133, 133, 133, 1))
              : _mapsThemeData.layerStrokeColor),
      layerStrokeWidth: widget.strokeWidth ??
          (isSublayer
              ? (isLightTheme ? 0.5 : 0.25)
              : _mapsThemeData.layerStrokeWidth),
      shapeHoverStrokeWidth: _mapsThemeData.shapeHoverStrokeWidth ??
          _mapsThemeData.layerStrokeWidth,
      legendTextStyle: _legendWidget?.textStyle,
      bubbleColor: widget.bubbleSettings.color ?? _mapsThemeData.bubbleColor,
      bubbleStrokeColor:
          widget.bubbleSettings.strokeColor ?? _mapsThemeData.bubbleStrokeColor,
      bubbleStrokeWidth:
          widget.bubbleSettings.strokeWidth ?? _mapsThemeData.bubbleStrokeWidth,
      bubbleHoverStrokeWidth: _mapsThemeData.bubbleHoverStrokeWidth ??
          _mapsThemeData.bubbleStrokeWidth,
      selectionColor:
          widget.selectionSettings.color ?? _mapsThemeData.selectionColor,
      selectionStrokeColor: widget.selectionSettings.strokeColor ??
          _mapsThemeData.selectionStrokeColor,
      selectionStrokeWidth: widget.selectionSettings.strokeWidth ??
          _mapsThemeData.selectionStrokeWidth,
      tooltipColor: widget.tooltipSettings.color ?? _mapsThemeData.tooltipColor,
      tooltipStrokeColor: widget.tooltipSettings.strokeColor ??
          _mapsThemeData.tooltipStrokeColor,
      tooltipStrokeWidth: widget.tooltipSettings.strokeWidth ??
          _mapsThemeData.tooltipStrokeWidth,
      tooltipBorderRadius: _mapsThemeData.tooltipBorderRadius
          .resolve(Directionality.of(context)),
      toggledItemColor: _legendWidget?.toggledItemColor,
      toggledItemStrokeColor: _legendWidget?.toggledItemStrokeColor,
      toggledItemStrokeWidth: _legendWidget?.toggledItemStrokeWidth,
    );
  }

  Widget _buildShapeLayer() {
    return FutureBuilder<_ShapeFileData>(
      future: _retrieveDataFromShapeFile(
          _provider,
          widget.source.shapeDataField,
          shapeFileData,
          _isShapeFileDecoded,
          isSublayer),
      builder: (BuildContext context, AsyncSnapshot<_ShapeFileData> snapshot) {
        if (snapshot.hasData && _isShapeFileDecoded) {
          shapeFileData = snapshot.data!;
          if (_shouldUpdateMapDataSource) {
            minBubbleValue = null;
            maxBubbleValue = null;
            shapeFileData.mapDataSource.values
                .forEach((MapModel model) => model.reset());
            _bindMapsSourceIntoDataSource();
            _shouldUpdateMapDataSource = false;
          }
          return _shapeLayerWithLegend;
        } else {
          _isShapeFileDecoded = true;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size size = getBoxSize(constraints);
              return Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: widget.loadingBuilder?.call(context),
              );
            },
          );
        }
      },
    );
  }

  /// Updating [modelSource] data index based on [dataMapper]
  /// value and data color based on [colorValueMapper] value.
  void _bindMapsSourceIntoDataSource() {
    if (widget.source.dataCount > 0 &&
        widget.source.primaryValueMapper != null) {
      final bool hasShapeColorValueMapper =
          widget.source.shapeColorValueMapper != null;
      final bool hasDataLabelMapper = widget.source.dataLabelMapper != null;
      final bool hasBubbleColorValueMapper =
          widget.source.bubbleColorValueMapper != null;
      final bool hasBubbleSizeMapper = widget.source.bubbleSizeMapper != null;

      for (int i = 0; i < widget.source.dataCount; i++) {
        final MapModel? mapModel =
            shapeFileData.mapDataSource[widget.source.primaryValueMapper!(i)];
        if (mapModel != null) {
          mapModel.dataIndex = i;
          _updateShapeColor(hasShapeColorValueMapper, i, mapModel);
          if (hasDataLabelMapper) {
            mapModel.dataLabelText = widget.source.dataLabelMapper!(i);
          }

          _updateBubbleColor(hasBubbleColorValueMapper, i, mapModel);
          _validateBubbleSize(hasBubbleSizeMapper, i, mapModel);
          if (mapModel.dataIndex == widget.selectedIndex) {
            mapModel.isSelected = true;
            shapeFileData.initialSelectedModel = mapModel;
          }
        }
      }
    }
  }

  void _updateShapeColor(
      bool hasShapeColorValueMapper, int index, MapModel mapModel) {
    if (hasShapeColorValueMapper) {
      mapModel.shapeColor = _getActualColor(
          widget.source.shapeColorValueMapper!(index),
          widget.source.shapeColorMappers,
          mapModel);
    }
  }

  void _updateBubbleColor(
      bool hasBubbleColorValueMapper, int index, MapModel mapModel) {
    if (hasBubbleColorValueMapper) {
      mapModel.bubbleColor = _getActualColor(
          widget.source.bubbleColorValueMapper!(index),
          widget.source.bubbleColorMappers,
          mapModel);
    }
  }

  void _validateBubbleSize(
      bool hasBubbleSizeMapper, int index, MapModel mapModel) {
    if (hasBubbleSizeMapper) {
      mapModel.bubbleSizeValue = widget.source.bubbleSizeMapper!(index);
      if (minBubbleValue == null) {
        minBubbleValue = mapModel.bubbleSizeValue;
        maxBubbleValue = mapModel.bubbleSizeValue;
      } else if (mapModel.bubbleSizeValue != null) {
        minBubbleValue = min(mapModel.bubbleSizeValue!, minBubbleValue!);
        maxBubbleValue = max(mapModel.bubbleSizeValue!, maxBubbleValue!);
      }
    }
  }

  /// Returns color from [MapColorMapper] based on the data source value.
  Color? _getActualColor(Object? colorValue, List<MapColorMapper>? colorMappers,
      MapModel? mapModel) {
    MapColorMapper mapper;
    if (colorValue == null) {
      return null;
    }

    final int length = colorMappers != null ? colorMappers.length : 0;
    // Handles equal color mapping.
    if (colorValue is String) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers![i];
        assert(mapper.value != null);
        if (mapper.value == colorValue) {
          mapModel?.legendMapperIndex = i;
          return mapper.color;
        }
      }
    }

    // Handles range color mapping.
    if (colorValue is num) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers![i];
        assert(mapper.from != null && mapper.to != null);
        if (mapper.from! <= colorValue && mapper.to! >= colorValue) {
          mapModel?.legendMapperIndex = i;
          if (mapper.minOpacity != null && mapper.maxOpacity != null) {
            return mapper.color.withOpacity(lerpDouble(
                mapper.minOpacity,
                mapper.maxOpacity,
                (colorValue - mapper.from!) / (mapper.to! - mapper.from!))!);
          }
          return mapper.color;
        }
      }
    }

    // ignore: avoid_as
    return colorValue as Color;
  }

  void refreshMarkers(MarkerAction action, [List<int>? indices]) {
    MapMarker marker;
    switch (action) {
      case MarkerAction.insert:
        int index = indices![0];
        assert(index <= widget.controller!._markersCount);
        if (index > widget.controller!._markersCount) {
          index = widget.controller!._markersCount;
        }
        marker = widget.markerBuilder!(context, index);
        if (index < widget.controller!._markersCount) {
          _markers!.insert(index, marker);
        } else if (index == widget.controller!._markersCount) {
          _markers!.add(marker);
        }
        widget.controller!._markersCount++;
        break;
      case MarkerAction.removeAt:
        final int index = indices![0];
        assert(index < widget.controller!._markersCount);
        _markers!.removeAt(index);
        widget.controller!._markersCount--;
        break;
      case MarkerAction.replace:
        for (final int index in indices!) {
          assert(index < widget.controller!._markersCount);
          marker = widget.markerBuilder!(context, index);
          _markers![index] = marker;
        }
        break;
      case MarkerAction.clear:
        _markers!.clear();
        widget.controller!._markersCount = 0;
        break;
    }

    setState(() {
      // Rebuilds to visually update the markers when it was updated or added.
    });
  }

  @override
  void initState() {
    super.initState();
    bubbleKey = GlobalKey();
    shapeFileData = _ShapeFileData()
      ..mapDataSource = <String, MapModel>{}
      ..bounds = _ShapeBounds();
    dataLabelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    bubbleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    toggleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _hoverBubbleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    hoverShapeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    selectionAnimationController = AnimationController(
        vsync: this, value: 1.0, duration: const Duration(milliseconds: 150));
    zoomLevelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    focalLatLngAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));

    if (widget.controller != null) {
      widget.controller!._markersCount = widget.initialMarkersCount;
    }

    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    MapMarker? marker;
    _markers = <Widget>[];
    for (int i = 0; i < widget.initialMarkersCount; i++) {
      marker = widget.markerBuilder!(context, i);
      _markers!.add(marker);
    }

    widget.controller?.addListener(refreshMarkers);
    isSublayer = widget.sublayerAncestor != null;
    _provider = _sourceProvider(
        widget.source._geoJSONSource, widget.source._geoJSONSourceType);
  }

  @override
  void didChangeDependencies() {
    if (_controller == null) {
      ancestor = context
          .dependOnInheritedWidgetOfExactType<MapLayerInheritedWidget>()!;
      _controller = ancestor.controller;
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_GeoJSONLayer oldWidget) {
    _shouldUpdateMapDataSource = oldWidget.source != widget.source;
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    isSublayer = widget.sublayerAncestor != null;

    final MapProvider currentProvider = _sourceProvider(
        widget.source._geoJSONSource, widget.source._geoJSONSourceType);
    if (_provider != currentProvider) {
      _provider = currentProvider;
      _isShapeFileDecoded = false;
      shapeFileData.reset();
    }

    if (oldWidget.controller != widget.controller) {
      widget.controller!._parentBox =
          // ignore: avoid_as
          context.findRenderObject() as _RenderGeoJSONLayer;
    }

    if (_controller != null && _shouldUpdateMapDataSource && !isSublayer) {
      _controller!.visibleFocalLatLng = null;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    dataLabelAnimationController.dispose();
    bubbleAnimationController.dispose();
    selectionAnimationController.dispose();
    toggleAnimationController.dispose();
    hoverShapeAnimationController.dispose();
    _hoverBubbleAnimationController.dispose();
    zoomLevelAnimationController.dispose();
    focalLatLngAnimationController.dispose();

    _markers?.clear();
    widget.controller?.removeListener(refreshMarkers);
    if (!isSublayer) {
      _controller?.dispose();
    }

    shapeFileData.reset();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.showDataLabels ||
        (widget.showDataLabels && widget.source.shapeDataField != null));
    assert(widget.source.bubbleSizeMapper == null ||
        widget.source.bubbleSizeMapper != null &&
            widget.source.primaryValueMapper != null);
    assert(widget.source.dataLabelMapper == null ||
        (widget.source.dataLabelMapper != null && widget.showDataLabels));
    assert(widget.source.shapeColorMappers == null ||
        widget.source.shapeColorMappers!.isNotEmpty);

    final ThemeData themeData = Theme.of(context);
    _mapsThemeData = SfMapsTheme.of(context)!;
    if (widget.legend != null) {
      _legendConfiguration = widget.legend!.copyWith(
          textStyle: themeData.textTheme.caption!
              .copyWith(
                  color: themeData.textTheme.caption!.color!.withOpacity(0.87))
              .merge(
                  widget.legend!.textStyle ?? _mapsThemeData.legendTextStyle),
          toggledItemColor: _mapsThemeData.toggledItemColor,
          toggledItemStrokeColor: _mapsThemeData.toggledItemStrokeColor,
          toggledItemStrokeWidth: _mapsThemeData.toggledItemStrokeWidth);
      _legendWidget = MapLegendWidget(legend: _legendConfiguration!);
    } else {
      _legendConfiguration = null;
    }

    isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    _updateThemeData(context);
    return _buildShapeLayer();
  }
}

class _GeoJSONLayerRenderObjectWidget extends Stack {
  _GeoJSONLayerRenderObjectWidget({
    required this.controller,
    required this.mapDataSource,
    required this.mapSource,
    required this.selectedIndex,
    required this.legend,
    required this.bubbleSettings,
    required this.selectionSettings,
    required this.zoomPanBehavior,
    required this.themeData,
    required this.state,
    List<Widget>? children,
  }) : super(children: children ?? <Widget>[]);

  final MapController controller;
  final Map<String, MapModel> mapDataSource;
  final MapShapeSource mapSource;
  final int selectedIndex;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final SfMapsThemeData themeData;
  final _GeoJSONLayerState state;
  final MapLegendWidget? legend;
  final MapZoomPanBehavior? zoomPanBehavior;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderGeoJSONLayer(
      controller: controller,
      mapDataSource: mapDataSource,
      mapSource: mapSource,
      selectedIndex: selectedIndex,
      legend: legend,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      zoomPanBehavior: zoomPanBehavior,
      themeData: themeData,
      context: context,
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderGeoJSONLayer renderObject) {
    renderObject
      ..mapDataSource = mapDataSource
      ..mapSource = mapSource
      ..selectedIndex = selectedIndex
      ..legend = legend
      ..bubbleSettings = bubbleSettings
      ..selectionSettings = selectionSettings
      ..zoomPanBehavior = zoomPanBehavior
      ..themeData = themeData
      ..context = context;
  }
}

class _RenderGeoJSONLayer extends RenderStack
    implements MouseTrackerAnnotation {
  _RenderGeoJSONLayer({
    required MapController controller,
    required Map<String, MapModel> mapDataSource,
    required MapShapeSource mapSource,
    required int selectedIndex,
    required MapLegendWidget? legend,
    required MapBubbleSettings bubbleSettings,
    required MapSelectionSettings selectionSettings,
    required MapZoomPanBehavior? zoomPanBehavior,
    required SfMapsThemeData themeData,
    required BuildContext context,
    required _GeoJSONLayerState state,
  })   : _controller = controller,
        _mapDataSource = mapDataSource,
        _mapSource = mapSource,
        _selectedIndex = selectedIndex,
        _legend = legend,
        _bubbleSettings = bubbleSettings,
        _selectionSettings = selectionSettings,
        _zoomPanBehavior = zoomPanBehavior,
        _themeData = themeData,
        _state = state,
        context = context,
        super(textDirection: Directionality.of(state.context)) {
    _scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onStart = _handleScaleStart
      ..onUpdate = _handleScaleUpdate
      ..onEnd = _handleScaleEnd;

    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;

    if (!_state.isSublayer) {
      _controller
        ..onZoomLevelChange = _handleZoomLevelChange
        ..onPanChange = _handleFocalLatLngChange;
    }

    _forwardToggledShapeColorTween = ColorTween();
    _forwardToggledShapeStrokeColorTween = ColorTween();
    _reverseToggledShapeColorTween = ColorTween();
    _reverseToggledShapeStrokeColorTween = ColorTween();

    _hoverColorAnimation = CurvedAnimation(
        parent: _state.hoverShapeAnimationController, curve: Curves.easeInOut);
    _forwardHoverColorTween = ColorTween();
    _forwardHoverStrokeColorTween = ColorTween();
    _reverseHoverColorTween = ColorTween();
    _reverseHoverStrokeColorTween = ColorTween();

    _toggleShapeAnimation = CurvedAnimation(
        parent: _state.toggleAnimationController, curve: Curves.easeInOut);

    if (_zoomPanBehavior != null) {
      _initializeZoomPanAnimations();
      _currentZoomLevel = _zoomPanBehavior!.zoomLevel;
    }

    if (_selectedIndex != -1) {
      _currentSelectedItem = _state.shapeFileData.initialSelectedModel;
      _initializeSelectionTween();
    }

    if (_legend != null && _legend!.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }

    if (hasShapeHoverColor) {
      _initializeHoverTweenColors();
    }

    _state.widget.controller?._parentBox = this;
  }

  static const double _frictionCoefficient = 0.005;
  final _GeoJSONLayerState _state;
  final int _minPanDistance = 5;
  final MapController _controller;
  double _actualFactor = 1.0;
  double _currentZoomLevel = 1.0;
  double _maximumReachedScaleOnInteraction = 1.0;
  int _pointerCount = 0;
  Offset _panDistanceBeforeFlinging = Offset.zero;
  bool _isZoomedUsingToolbar = false;
  bool _avoidPanUpdate = false;
  bool _isFlingAnimationActive = false;
  bool _doubleTapEnabled = false;
  late Size _size;
  late Size _actualShapeSize;
  late ScaleGestureRecognizer _scaleGestureRecognizer;
  late TapGestureRecognizer _tapGestureRecognizer;
  late Animation<double> _selectionColorAnimation;
  late Animation<double> _toggleShapeAnimation;
  late Animation<double> _hoverColorAnimation;
  late ColorTween _forwardSelectionStrokeColorTween;
  late ColorTween _reverseSelectionColorTween;
  late ColorTween _reverseSelectionStrokeColorTween;
  late ColorTween _forwardHoverColorTween;
  late ColorTween _forwardHoverStrokeColorTween;
  late ColorTween _reverseHoverColorTween;
  late ColorTween _reverseHoverStrokeColorTween;
  late ColorTween _forwardToggledShapeColorTween;
  late ColorTween _forwardToggledShapeStrokeColorTween;
  late ColorTween _reverseToggledShapeColorTween;
  late ColorTween _reverseToggledShapeStrokeColorTween;
  late CurvedAnimation _flingZoomLevelCurvedAnimation;
  late CurvedAnimation _flingFocalLatLngCurvedAnimation;
  late CurvedAnimation _focalLatLngCurvedAnimation;
  late MapLatLngTween _focalLatLngTween;
  late Tween<double> _zoomLevelTween;

  Offset? _downGlobalPoint;
  Offset? _downLocalPoint;
  MapModel? _prevSelectedItem;
  MapModel? _currentSelectedItem;
  MapModel? _currentHoverItem;
  MapModel? _previousHoverItem;
  MapModel? _currentInteractedItem;
  MapLayerElement? _currentInteractedElement;
  Timer? _zoomingDelayTimer;
  Timer? _doubleTapTimer;
  Rect? _referenceShapeBounds;
  Rect? _referenceVisibleBounds;
  MapZoomDetails? _zoomDetails;
  MapPanDetails? _panDetails;
  ColorTween? _forwardSelectionColorTween;
  CurvedAnimation? _zoomLevelCurvedAnimation;

  BuildContext context;

  bool get canZoom =>
      _zoomPanBehavior != null &&
      (_zoomPanBehavior!.enablePinching ||
          _zoomPanBehavior!.enablePanning ||
          _zoomPanBehavior!.enableDoubleTapZooming);

  bool get isInteractive =>
      _state.widget.shapeTooltipBuilder != null ||
      _state.widget.bubbleTooltipBuilder != null ||
      _state.widget.onSelectionChanged != null ||
      (_state.isDesktop && (hasBubbleHoverColor || hasShapeHoverColor));

  bool get hasBubbleHoverColor =>
      _themeData.bubbleHoverColor != Colors.transparent ||
      (_themeData.bubbleHoverStrokeColor != Colors.transparent &&
          _themeData.bubbleHoverStrokeWidth! > 0);

  bool get hasShapeHoverColor =>
      _themeData.shapeHoverColor != Colors.transparent ||
      (_themeData.shapeHoverStrokeColor != Colors.transparent &&
          _themeData.shapeHoverStrokeWidth! > 0);

  Map<String, MapModel> get mapDataSource => _mapDataSource;
  Map<String, MapModel> _mapDataSource;
  set mapDataSource(Map<String, MapModel> value) {
    if (const MapEquality<String, MapModel>().equals(_mapDataSource, value)) {
      return;
    }

    _mapDataSource = value;
    _refresh();
    markNeedsPaint();
  }

  MapShapeSource? get mapSource => _mapSource;
  MapShapeSource? _mapSource;
  set mapSource(MapShapeSource? value) {
    if (_mapSource == value) {
      return;
    }

    if (_mapSource != null &&
        value != null &&
        _sourceProvider(
                _mapSource!._geoJSONSource, _mapSource!._geoJSONSourceType) !=
            _sourceProvider(value._geoJSONSource, value._geoJSONSourceType)) {
      _mapSource = value;
      return;
    }

    _mapSource = value;
    _currentSelectedItem = null;
    _prevSelectedItem = null;
    _previousHoverItem = null;
    _refresh();
    markNeedsPaint();
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    SchedulerBinding.instance?.addPostFrameCallback(_initiateInitialAnimations);
  }

  MapBubbleSettings get bubbleSettings => _bubbleSettings;
  MapBubbleSettings _bubbleSettings;
  set bubbleSettings(MapBubbleSettings value) {
    if (_bubbleSettings == value) {
      return;
    }
    if (_bubbleSettings.minRadius != value.minRadius ||
        _bubbleSettings.maxRadius != value.maxRadius) {
      _bubbleSettings = value;
      _mapDataSource.forEach((String key, MapModel mapModel) {
        _updateBubbleRadiusAndPath(mapModel);
      });
    } else {
      _bubbleSettings = value;
    }
    markNeedsPaint();
  }

  MapLegendWidget? get legend => _legend;
  MapLegendWidget? _legend;
  set legend(MapLegendWidget? value) {
    // Update [MapsShapeLayer.legend] value only when
    // [MapsShapeLayer.legend] property is set to shape.
    if (_legend != null && _legend!.source != MapElement.shape ||
        _legend == value) {
      return;
    }
    _legend = value;
    if (_legend!.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }
    markNeedsPaint();
  }

  MapSelectionSettings get selectionSettings => _selectionSettings;
  MapSelectionSettings _selectionSettings;
  set selectionSettings(MapSelectionSettings value) {
    if (_selectionSettings == value) {
      return;
    }
    _selectionSettings = value;
  }

  MapZoomPanBehavior? get zoomPanBehavior => _zoomPanBehavior;
  MapZoomPanBehavior? _zoomPanBehavior;
  set zoomPanBehavior(MapZoomPanBehavior? value) {
    if (_zoomPanBehavior == value) {
      return;
    }
    _zoomPanBehavior = value;
    if (_zoomPanBehavior != null) {
      if (_zoomLevelCurvedAnimation == null) {
        _initializeZoomPanAnimations();
      }
      _currentZoomLevel = _zoomPanBehavior!.zoomLevel;
    }
  }

  int get selectedIndex => _selectedIndex;
  int _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex == value) {
      return;
    }

    _selectedIndex = value;
    if (_forwardSelectionColorTween == null) {
      _initializeSelectionTween();
    }

    _handleShapeLayerSelection();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;
  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;

    if (_forwardSelectionColorTween != null) {
      _updateSelectionTweenColors();
    }
    if (_legend != null && _legend!.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }

    if (hasShapeHoverColor) {
      _initializeHoverTweenColors();
    }

    markNeedsPaint();
  }

  @override
  Rect get paintBounds => Offset.zero & _size;

  @override
  MouseCursor get cursor => _controller.gesture == Gesture.pan
      ? SystemMouseCursors.grabbing
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  void _initializeZoomPanAnimations() {
    _flingZoomLevelCurvedAnimation = CurvedAnimation(
        parent: _state.zoomLevelAnimationController, curve: Curves.decelerate);
    _flingFocalLatLngCurvedAnimation = CurvedAnimation(
        parent: _state.focalLatLngAnimationController,
        curve: Curves.decelerate);
    _zoomLevelCurvedAnimation = CurvedAnimation(
        parent: _state.zoomLevelAnimationController, curve: Curves.easeInOut);
    _focalLatLngCurvedAnimation = CurvedAnimation(
        parent: _state.focalLatLngAnimationController, curve: Curves.easeInOut);
    _focalLatLngTween = MapLatLngTween();
    _zoomLevelTween = Tween<double>();
  }

  void _initializeSelectionTween() {
    _selectionColorAnimation = CurvedAnimation(
        parent: _state.selectionAnimationController, curve: Curves.easeInOut);
    _forwardSelectionColorTween = ColorTween();
    _forwardSelectionStrokeColorTween = ColorTween();
    _reverseSelectionColorTween = ColorTween();
    _reverseSelectionStrokeColorTween = ColorTween();
    _updateSelectionTweenColors();
  }

  void _updateSelectionTweenColors() {
    final Color selectionColor = _themeData.selectionColor;
    _forwardSelectionColorTween!.end = selectionColor;
    _forwardSelectionStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardSelectionStrokeColorTween.end = _themeData.selectionStrokeColor;

    _reverseSelectionColorTween.begin = selectionColor;
    _reverseSelectionStrokeColorTween.begin = _themeData.selectionStrokeColor;
    _reverseSelectionStrokeColorTween.end = _themeData.layerStrokeColor;
    _updateCurrentSelectedItemTween();
  }

  void _updateCurrentSelectedItemTween() {
    if (_currentSelectedItem != null &&
        (_state.isSublayer || !_controller.wasToggled(_currentSelectedItem!))) {
      _forwardSelectionColorTween!.begin =
          getActualShapeColor(_currentSelectedItem!);
    }

    if (_prevSelectedItem != null) {
      _reverseSelectionColorTween.end = getActualShapeColor(_prevSelectedItem!);
    }
  }

  void _initializeHoverTweenColors() {
    final Color hoverStrokeColor = _getHoverStrokeColor();
    _forwardHoverStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardHoverStrokeColorTween.end = hoverStrokeColor;
    _reverseHoverStrokeColorTween.begin = hoverStrokeColor;
    _reverseHoverStrokeColorTween.end = _themeData.layerStrokeColor;
  }

  void _updateHoverItemTween() {
    if (_currentHoverItem != null) {
      _forwardHoverColorTween.begin = getActualShapeColor(_currentHoverItem!);
      _forwardHoverColorTween.end = _getHoverFillColor(_currentHoverItem!);
    }

    if (_previousHoverItem != null) {
      _reverseHoverColorTween.begin = _getHoverFillColor(_previousHoverItem!);
      _reverseHoverColorTween.end = getActualShapeColor(_previousHoverItem!);
    }

    _state.hoverShapeAnimationController.forward(from: 0);
  }

  void _initializeToggledShapeTweenColors() {
    final Color? toggledShapeColor = _themeData.toggledItemColor !=
            Colors.transparent
        ? _themeData.toggledItemColor.withOpacity(_legend!.toggledItemOpacity)
        : null;

    _forwardToggledShapeColorTween.end = toggledShapeColor;
    _forwardToggledShapeStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardToggledShapeStrokeColorTween.end =
        _themeData.toggledItemStrokeColor != Colors.transparent
            ? _themeData.toggledItemStrokeColor
            : null;

    _reverseToggledShapeColorTween.begin = toggledShapeColor;
    _reverseToggledShapeStrokeColorTween.begin =
        _themeData.toggledItemStrokeColor != Colors.transparent
            ? _themeData.toggledItemStrokeColor
            : null;
    _reverseToggledShapeStrokeColorTween.end = _themeData.layerStrokeColor;
  }

  Color _getHoverFillColor(MapModel model) {
    final bool canAdjustHoverOpacity =
        double.parse(getActualShapeColor(model).opacity.toStringAsFixed(2)) !=
            hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor!
        : getActualShapeColor(model).withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  Color _getHoverStrokeColor() {
    final bool canAdjustHoverOpacity =
        double.parse(_themeData.layerStrokeColor.opacity.toStringAsFixed(2)) !=
            hoverColorOpacity;
    return _themeData.shapeHoverStrokeColor != null &&
            _themeData.shapeHoverStrokeColor != Colors.transparent
        ? _themeData.shapeHoverStrokeColor!
        : _themeData.layerStrokeColor.withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _refresh([MapLatLng? latlng]) {
    if (hasSize && _mapDataSource.isNotEmpty) {
      if (_state.isSublayer) {
        // For tile layer's sublayer.
        if (_controller.layerType == LayerType.tile) {
          _size = _controller.getTileSize();
          latlng = _controller.visibleFocalLatLng;
        }
        // For shape layer's sublayer.
        else {
          _updateMapDataSourceForVisual();
          markNeedsPaint();
          return;
        }
      }
      _computeActualFactor();
      _controller.shapeLayerSizeFactor = _actualFactor;
      if (_zoomPanBehavior != null) {
        _controller.shapeLayerSizeFactor *= _zoomPanBehavior!.zoomLevel;
        final double inflateWidth =
            _size.width * _zoomPanBehavior!.zoomLevel / 2 - _size.width / 2;
        final double inflateHeight =
            _size.height * _zoomPanBehavior!.zoomLevel / 2 - _size.height / 2;
        _controller.shapeLayerOrigin = Offset(
            paintBounds.left - inflateWidth, paintBounds.top - inflateHeight);
      }

      _controller.shapeLayerOffset =
          _getTranslationPoint(_controller.shapeLayerSizeFactor);
      final Offset offsetBeforeAdjust = _controller.shapeLayerOffset;
      _adjustLayerOffsetTo(latlng);
      if (!_state.isSublayer) {
        _controller.shapeLayerOrigin +=
            _controller.shapeLayerOffset - offsetBeforeAdjust;
        _controller.updateVisibleBounds();
      }

      _updateMapDataSourceForVisual();
      markNeedsPaint();
    }
  }

  void _computeActualFactor() {
    final Offset minPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude!,
        _state.shapeFileData.bounds.minLongitude!,
        _size);
    final Offset maxPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude!,
        _state.shapeFileData.bounds.maxLongitude!,
        _size);
    _actualShapeSize = Size(
        (maxPoint.dx - minPoint.dx).abs(), (maxPoint.dy - minPoint.dy).abs());
    _actualFactor = min(_size.height / _actualShapeSize.height,
        _size.width / _actualShapeSize.width);
  }

  Offset _getTranslationPoint(double factor, [Rect? bounds]) {
    bounds ??= _getShapeBounds(factor);
    // 0.0 is default translation value.
    // We cant use the clamp() directly here because the upperLimit must be
    // greater than or equal to lowerLimit. This shows assert error when using.
    // So, we have used the min and max mathematical function for clamping.
    final double dx =
        min(max(0.0, _size.width - _actualShapeSize.width), -bounds.left);
    final double dy =
        min(max(0.0, _size.height - _actualShapeSize.height), -bounds.top);
    final Size widgetSize = _state.isSublayer ? size : _size;
    final Offset shift = Offset(
        widgetSize.width - _actualShapeSize.width * factor,
        widgetSize.height - _actualShapeSize.height * factor);
    return Offset(dx + shift.dx / 2, dy + shift.dy / 2);
  }

  Rect _getShapeBounds(double factor, [Offset translation = Offset.zero]) {
    final Offset minPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude!,
        _state.shapeFileData.bounds.minLongitude!,
        _size,
        translation,
        factor);
    final Offset maxPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude!,
        _state.shapeFileData.bounds.maxLongitude!,
        _size,
        translation,
        factor);
    return Rect.fromPoints(minPoint, maxPoint);
  }

  void _adjustLayerOffsetTo(MapLatLng? latlng) {
    latlng ??= _zoomPanBehavior?.focalLatLng;
    if (latlng != null) {
      final Offset focalPoint = pixelFromLatLng(
        latlng.latitude,
        latlng.longitude,
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor,
      );
      final Offset center =
          _getShapeBounds(_controller.shapeLayerSizeFactor).center;
      _controller.shapeLayerOffset +=
          center + _controller.shapeLayerOffset - focalPoint;
    }
  }

  void _updateMapDataSourceForVisual() {
    Offset point;
    Path shapePath;
    dynamic coordinate;
    List<Offset> pixelPoints;
    List<dynamic> rawPoints;
    int rawPointsLength, pointsLength;
    _mapDataSource.forEach((String key, MapModel mapModel) {
      double signedArea = 0.0, centerX = 0.0, centerY = 0.0;
      rawPointsLength = mapModel.rawPoints.length;
      mapModel.pixelPoints = List.filled(rawPointsLength, []);
      shapePath = Path();
      for (int j = 0; j < rawPointsLength; j++) {
        rawPoints = mapModel.rawPoints[j];
        pointsLength = rawPoints.length;
        pixelPoints =
            mapModel.pixelPoints![j] = List.filled(pointsLength, Offset.zero);
        for (int k = 0; k < pointsLength; k++) {
          coordinate = rawPoints[k];
          point = pixelPoints[k] = pixelFromLatLng(
              coordinate[1],
              coordinate[0],
              _size,
              _controller.shapeLayerOffset,
              _controller.shapeLayerSizeFactor);
          if (k == 0) {
            shapePath.moveTo(point.dx, point.dy);
          } else {
            shapePath.lineTo(point.dx, point.dy);
            final int l = k - 1;
            if ((_state.widget.showDataLabels ||
                    _state.widget.source.bubbleSizeMapper != null) &&
                l + 1 < pixelPoints.length) {
              // Used mathematical formula to find
              // the center of polygon points.
              final double x0 = pixelPoints[l].dx, y0 = pixelPoints[l].dy;
              final double x1 = pixelPoints[l + 1].dx,
                  y1 = pixelPoints[l + 1].dy;
              signedArea += (x0 * y1) - (y0 * x1);
              centerX += (x0 + x1) * (x0 * y1 - x1 * y0);
              centerY += (y0 + y1) * (x0 * y1 - x1 * y0);
            }
          }
        }
        shapePath.close();
      }

      mapModel.shapePath = shapePath;
      _findPathCenterAndWidth(signedArea, centerX, centerY, mapModel);
      _updateBubbleRadiusAndPath(mapModel);
    });
  }

  void _findPathCenterAndWidth(
      double signedArea, double centerX, double centerY, MapModel mapModel) {
    if (_state.widget.showDataLabels ||
        _state.widget.source.bubbleSizeMapper != null) {
      // Used mathematical formula to find the center of polygon points.
      signedArea /= 2;
      centerX = centerX / (6 * signedArea);
      centerY = centerY / (6 * signedArea);
      mapModel.shapePathCenter = Offset(centerX, centerY);
      double? minX, maxX;
      double distance,
          minDistance = double.infinity,
          maxDistance = double.negativeInfinity;

      final List<double> minDistances = <double>[double.infinity];
      final List<double> maxDistances = <double>[double.negativeInfinity];
      for (final List<Offset> points in mapModel.pixelPoints!) {
        for (final Offset point in points) {
          distance = (centerY - point.dy).abs();
          if (point.dx < centerX) {
            // Collected all points which is less 10 pixels distance from
            // 'center y' to position the labels more smartly.
            if (minX != null && distance < 10) {
              minDistances.add(point.dx);
            }
            if (distance < minDistance) {
              minX = point.dx;
              minDistance = distance;
            }
          } else if (point.dx > centerX) {
            if (maxX != null && distance < 10) {
              maxDistances.add(point.dx);
            }

            if (distance > maxDistance) {
              maxX = point.dx;
              maxDistance = distance;
            }
          }
        }
      }

      mapModel.shapeWidth = max(maxX!, maxDistances.reduce(max)) -
          min(minX!, minDistances.reduce(min));
    }
  }

  void _updateBubbleRadiusAndPath(MapModel mapModel) {
    final double? bubbleSizeValue = mapModel.bubbleSizeValue;
    if (bubbleSizeValue != null) {
      if (bubbleSizeValue == _state.minBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.minRadius;
      } else if (bubbleSizeValue == _state.maxBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.maxRadius;
      } else {
        final double percentage = ((bubbleSizeValue - _state.minBubbleValue!) /
                (_state.maxBubbleValue! - _state.minBubbleValue!)) *
            100;
        mapModel.bubbleRadius = bubbleSettings.minRadius +
            (bubbleSettings.maxRadius - bubbleSettings.minRadius) *
                (percentage / 100);
      }
    }

    if ((_state.widget.bubbleTooltipBuilder != null || hasBubbleHoverColor) &&
        mapModel.bubbleRadius != null) {
      mapModel.bubblePath = Path()
        ..addOval(
          Rect.fromCircle(
            center: mapModel.shapePathCenter!,
            radius: mapModel.bubbleRadius!,
          ),
        );
    }
  }

  // Invoking animation for data label and bubble.
  void _initiateInitialAnimations(Duration timeStamp) {
    if (_state.mounted) {
      if (_state.widget.source.bubbleSizeMapper != null) {
        _state.bubbleAnimationController.forward(from: 0);
      } else if (_state.widget.showDataLabels) {
        _state.dataLabelAnimationController.forward(from: 0);
      }
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (canZoom &&
        !_state.zoomLevelAnimationController.isAnimating &&
        !_state.focalLatLngAnimationController.isAnimating) {
      if (_controller.gesture == Gesture.scale) {
        _zoomEnd();
      }

      _controller.isInInteractive = true;
      _controller.gesture = null;
      _startInteraction(details.localFocalPoint, details.focalPoint);
    }
  }

  void _startInteraction(Offset localFocalPoint, Offset globalFocalPoint) {
    _maximumReachedScaleOnInteraction = 1.0;
    _downGlobalPoint = globalFocalPoint;
    _downLocalPoint = localFocalPoint;
    _referenceVisibleBounds =
        _controller.getVisibleBounds(_controller.shapeLayerOffset);
    _referenceShapeBounds = _getShapeBounds(
        _controller.shapeLayerSizeFactor, _controller.shapeLayerOffset);
    _zoomDetails = MapZoomDetails(
      newVisibleBounds: _controller.getVisibleLatLngBounds(
        _referenceVisibleBounds!.topRight,
        _referenceVisibleBounds!.bottomLeft,
      ),
    );
    _panDetails = MapPanDetails(
      newVisibleBounds: _zoomDetails!.newVisibleBounds!,
    );
  }

  // Scale and pan are handled in scale gesture.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (canZoom &&
        !_doubleTapEnabled &&
        !_state.zoomLevelAnimationController.isAnimating &&
        !_state.focalLatLngAnimationController.isAnimating) {
      final double zoomLevel = _getZoomLevel(details.scale);
      final double scale = _getScale(zoomLevel);
      _controller.isInInteractive = true;
      // Before the completion of the double tap zooming animation, when we
      // zoomed or panned the _downLocalPoint will be null. So we had updated
      // the current offset as interaction start offsets.
      if (_downLocalPoint == null) {
        _startInteraction(details.localFocalPoint, details.focalPoint);
      }

      _controller.gesture ??= _getGestureType(scale, details.localFocalPoint);
      if (_controller.gesture == null) {
        return;
      } else if (_controller.gesture == Gesture.scale &&
          zoomLevel == _currentZoomLevel) {
        _resetDoubleTapTimer();
        return;
      }

      // We have stored the [_previousMaximumScale] value to check whether
      // the last fling is zoomed in or out.
      if (_controller.localScale < scale) {
        _maximumReachedScaleOnInteraction = scale;
      }

      _resetDoubleTapTimer();
      switch (_controller.gesture!) {
        case Gesture.scale:
          if (_zoomPanBehavior!.enablePinching &&
              !_state.zoomLevelAnimationController.isAnimating &&
              !_state.focalLatLngAnimationController.isAnimating) {
            _invokeOnZooming(scale, _downLocalPoint, _downGlobalPoint);
          }
          return;
        case Gesture.pan:
          if (_zoomPanBehavior!.enablePanning &&
              !_state.focalLatLngAnimationController.isAnimating &&
              !_state.zoomLevelAnimationController.isAnimating) {
            _invokeOnPanning(
                details.localFocalPoint, _downLocalPoint!, details.focalPoint);
          }
          return;
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_controller.gesture == null) {
      _controller.isInInteractive = false;
      return;
    } else if (_state.zoomLevelAnimationController.isAnimating ||
        _state.focalLatLngAnimationController.isAnimating) {
      return;
    }
    if (_zoomPanBehavior != null &&
        details.velocity.pixelsPerSecond.distance >= kMinFlingVelocity) {
      _resetDoubleTapTimer();
      // Calculating the end focalLatLng based on the obtained velocity.
      if (_controller.gesture == Gesture.pan &&
          _zoomPanBehavior!.enablePanning) {
        _startFlingAnimationForPanning(details);
      }
      // Calculating the end zoomLevel based on the obtained velocity.
      else if (_controller.gesture == Gesture.scale &&
          _zoomPanBehavior!.enablePinching) {
        _startFlingAnimationForPinching(details);
      }
    } else {
      switch (_controller.gesture!) {
        case Gesture.scale:
          _zoomEnd();
          break;
        case Gesture.pan:
          _panEnd();
          break;
      }

      _controller.gesture = null;
    }
  }

  void _startFlingAnimationForPanning(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    final Offset currentPixelPoint = pixelFromLatLng(
        _controller.visibleFocalLatLng!.latitude,
        _controller.visibleFocalLatLng!.longitude,
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor);
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

    final MapLatLng latLng = getPixelToLatLng(
        Offset(frictionX.finalX, frictionY.finalX),
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor);
    _state.focalLatLngAnimationController.duration = _getFlingAnimationDuration(
        details.velocity.pixelsPerSecond.distance, _frictionCoefficient);
    _controller.isInInteractive = false;
    _panDistanceBeforeFlinging = _controller.panDistance;
    _zoomPanBehavior!.focalLatLng = latLng;
  }

  void _startFlingAnimationForPinching(ScaleEndDetails details) {
    _isFlingAnimationActive = true;
    final int direction =
        _controller.localScale >= _maximumReachedScaleOnInteraction ? 1 : -1;
    double newZoomLevel = _currentZoomLevel +
        (direction *
            (details.velocity.pixelsPerSecond.distance / kMaxFlingVelocity) *
            _zoomPanBehavior!.maxZoomLevel);
    newZoomLevel = newZoomLevel.clamp(
        _zoomPanBehavior!.minZoomLevel, _zoomPanBehavior!.maxZoomLevel);
    _state.zoomLevelAnimationController.duration = _getFlingAnimationDuration(
        details.velocity.pixelsPerSecond.distance, _frictionCoefficient);
    _controller.isInInteractive = false;
    _zoomPanBehavior!.zoomLevel = newZoomLevel;
  }

  // Returns the animation duration for the given distance and
  // friction co-efficient.
  Duration _getFlingAnimationDuration(
      double distance, double frictionCoefficient) {
    final int duration =
        (log(10.0 / distance) / log(frictionCoefficient / 100)).round();
    final int durationInMs = (duration * 650).round();
    return Duration(milliseconds: durationInMs < 350 ? 350 : durationInMs);
  }

  /// Handling zooming using mouse wheel scrolling.
  void _handleScrollEvent(PointerScrollEvent event) {
    if (_zoomPanBehavior != null && _zoomPanBehavior!.enablePinching) {
      _controller.isInInteractive = true;
      _controller.gesture ??= Gesture.scale;
      if (_controller.gesture != Gesture.scale) {
        return;
      }

      if (_currentHoverItem != null) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = null;
      }
      _downGlobalPoint ??= event.position;
      _downLocalPoint ??= event.localPosition;
      // In flutter, the default mouse wheel scroll delta value is 20. Here, the
      // scale measurement was chosen at random on all devices, to feel normal
      // including trackpads and mousewheels.
      double scale = _controller.localScale - (event.scrollDelta.dy / 200);
      if (_controller.shapeLayerSizeFactor * scale < _actualFactor) {
        scale = _actualFactor / _controller.shapeLayerSizeFactor;
      }

      _invokeOnZooming(scale, _downLocalPoint, _downGlobalPoint);
      // When the user didn't scrolled or scaled for certain time period,
      // we will refresh the map to the corresponding zoom level.
      _zoomingDelayTimer?.cancel();
      _zoomingDelayTimer = Timer(const Duration(milliseconds: 250), () {
        _zoomEnd();
      });
    }
  }

  void _invokeOnZooming(double scale,
      [Offset? localFocalPoint, Offset? globalFocalPoint]) {
    final double newZoomLevel = _getZoomLevel(scale);
    final double newShapeLayerSizeFactor = _getScale(newZoomLevel);
    final Offset newShapeLayerOffset =
        _controller.getZoomingTranslation(origin: localFocalPoint);
    final Rect newVisibleBounds = _controller.getVisibleBounds(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    _zoomDetails = MapZoomDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: _zoomPanBehavior!.zoomLevel,
      newZoomLevel: newZoomLevel,
      previousVisibleBounds: _zoomDetails != null
          ? _zoomDetails!.newVisibleBounds
          : _controller.visibleLatLngBounds,
      newVisibleBounds: _controller.getVisibleLatLngBounds(
        newVisibleBounds.topRight,
        newVisibleBounds.bottomLeft,
        newShapeLayerOffset,
        newShapeLayerSizeFactor,
      ),
    );
    if (_state.widget.onWillZoom == null ||
        _state.widget.onWillZoom!(_zoomDetails!)) {
      _zoomPanBehavior?.onZooming(_zoomDetails!);
    }
  }

  void _handleZooming(MapZoomDetails details) {
    if (_state.isSublayer) {
      markNeedsPaint();
      return;
    }

    if (_controller.isInInteractive && details.localFocalPoint != null) {
      // Updating map while pinching and scrolling.
      _controller.localScale = _getScale(details.newZoomLevel!);
      _controller.pinchCenter = details.localFocalPoint!;
      _controller.updateVisibleBounds(
          _controller.getZoomingTranslation() + _controller.normalize,
          _controller.shapeLayerSizeFactor * _controller.localScale);
      _validateEdges(details.newZoomLevel!);
    } else if (!_doubleTapEnabled) {
      // Updating map via toolbar.
      _downLocalPoint = null;
      _downGlobalPoint = null;
      _isZoomedUsingToolbar = true;
    }
    _zoomPanBehavior!.zoomLevel = details.newZoomLevel!;
  }

  void _handleZoomLevelChange(double zoomLevel, {MapLatLng? latlng}) {
    if (_controller.isInInteractive &&
        !_state.focalLatLngAnimationController.isAnimating &&
        !_state.zoomLevelAnimationController.isAnimating) {
      _currentZoomLevel = zoomLevel;
      markNeedsPaint();
    } else if (_zoomPanBehavior!.zoomLevel != _currentZoomLevel) {
      if (!_isFlingAnimationActive && !_doubleTapEnabled) {
        _state.zoomLevelAnimationController.duration =
            const Duration(milliseconds: 650);
      }
      _zoomLevelTween.begin = _currentZoomLevel;
      _zoomLevelTween.end = _zoomPanBehavior!.zoomLevel;
      if (!_isFlingAnimationActive && !_doubleTapEnabled) {
        _downLocalPoint = pixelFromLatLng(
            _controller.visibleFocalLatLng!.latitude,
            _controller.visibleFocalLatLng!.longitude,
            _size,
            _controller.shapeLayerOffset,
            _controller.shapeLayerSizeFactor);
      }
      _controller.isInInteractive = true;
      _controller.gesture = Gesture.scale;
      _controller.pinchCenter = _downLocalPoint!;
      _state.zoomLevelAnimationController.forward(from: 0.0);
    }
  }

  void _handleZoomLevelAnimation() {
    if (_zoomLevelTween.end != null) {
      _currentZoomLevel = _zoomLevelTween.evaluate(_isFlingAnimationActive
          ? _flingZoomLevelCurvedAnimation
          : _zoomLevelCurvedAnimation!);
    }
    _controller.localScale = _getScale(_currentZoomLevel);
    _controller.updateVisibleBounds(
        _controller.getZoomingTranslation() + _controller.normalize,
        _controller.shapeLayerSizeFactor * _controller.localScale);
    _validateEdges(_currentZoomLevel);
    _controller.notifyRefreshListeners();
    markNeedsPaint();
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _zoomLevelTween.end != null) {
      _handleZoomingAnimationEnd();
    }
  }

  void _handleZoomingAnimationEnd() {
    _isFlingAnimationActive = false;
    _zoomEnd();
    if (!_isZoomedUsingToolbar && !_doubleTapEnabled) {
      _invokeOnZooming(_getScale(_currentZoomLevel));
    }
    _isZoomedUsingToolbar = false;
    _doubleTapEnabled = false;
  }

  void _zoomEnd() {
    _controller.isInInteractive = false;
    _controller.gesture = null;
    _zoomingDelayTimer?.cancel();
    _zoomingDelayTimer = null;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior != null &&
        _zoomPanBehavior!.enablePinching &&
        !_state.isSublayer) {
      _controller.shapeLayerOffset =
          _controller.getZoomingTranslation() + _controller.normalize;
      _controller.shapeLayerOrigin = _controller.getZoomingTranslation(
              previousOrigin: _controller.shapeLayerOrigin) +
          _controller.normalize;
      _controller.shapeLayerSizeFactor *= _controller.localScale;
      _updateMapDataSourceForVisual();
      _controller.notifyRefreshListeners();
      markNeedsPaint();
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    _controller.normalize = Offset.zero;
    _controller.localScale = 1.0;
  }

  void _invokeOnPanning(
      Offset localFocalPoint, Offset previousFocalPoint, Offset focalPoint,
      [bool canAvoidPanUpdate = false]) {
    _avoidPanUpdate = canAvoidPanUpdate;
    final Offset delta =
        _getValidPanDelta(localFocalPoint - previousFocalPoint);
    final Rect visibleBounds = _controller.getVisibleBounds(
        _controller.shapeLayerOffset +
            (canAvoidPanUpdate ? Offset.zero : delta));
    _panDetails = MapPanDetails(
      globalFocalPoint: focalPoint,
      localFocalPoint: localFocalPoint,
      zoomLevel: _zoomPanBehavior!.zoomLevel,
      delta: delta,
      previousVisibleBounds: _panDetails != null
          ? _panDetails!.newVisibleBounds
          : _controller.visibleLatLngBounds,
      newVisibleBounds: _controller.getVisibleLatLngBounds(
          visibleBounds.topRight,
          visibleBounds.bottomLeft,
          _controller.shapeLayerOffset +
              (canAvoidPanUpdate ? Offset.zero : delta)),
    );
    if (_state.widget.onWillPan == null ||
        _state.widget.onWillPan!(_panDetails!)) {
      _zoomPanBehavior?.onPanning(_panDetails!);
    }
  }

  void _handlePanning(MapPanDetails details) {
    if (_avoidPanUpdate) {
      _avoidPanUpdate = false;
      return;
    }

    if (_currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
    }

    if (!_state.isSublayer) {
      _controller.panDistance = details.delta!;
      _controller
          .updateVisibleBounds(_controller.shapeLayerOffset + details.delta!);
    }

    markNeedsPaint();
  }

  void _handleFocalLatLngChange(MapLatLng? latlng) {
    if (!_controller.isInInteractive ||
        _controller.visibleFocalLatLng != _zoomPanBehavior!.focalLatLng) {
      if (!_isFlingAnimationActive) {
        _state.focalLatLngAnimationController.duration =
            const Duration(milliseconds: 650);
      }

      if (_state.focalLatLngAnimationController.isAnimating) {
        _panDistanceBeforeFlinging = _controller.panDistance;
      }

      _focalLatLngTween.begin = _controller.visibleFocalLatLng;
      _focalLatLngTween.end = _zoomPanBehavior!.focalLatLng;
      _downLocalPoint = pixelFromLatLng(
          _controller.visibleFocalLatLng!.latitude,
          _controller.visibleFocalLatLng!.longitude,
          _size,
          _controller.shapeLayerOffset + _panDistanceBeforeFlinging,
          _controller.shapeLayerSizeFactor);
      _referenceVisibleBounds =
          _controller.getVisibleBounds(_controller.shapeLayerOffset);
      _referenceShapeBounds = _getShapeBounds(
          _controller.shapeLayerSizeFactor, _controller.shapeLayerOffset);
      _controller.isInInteractive = true;
      _controller.gesture = Gesture.pan;
      _state.focalLatLngAnimationController.forward(from: 0.0);
    }
  }

  void _handleFocalLatLngAnimation() {
    final MapLatLng latLng = _focalLatLngTween.evaluate(_isFlingAnimationActive
        ? _flingFocalLatLngCurvedAnimation
        : _focalLatLngCurvedAnimation);

    final Offset localFocalPoint = pixelFromLatLng(
        latLng.latitude,
        latLng.longitude,
        _size,
        _controller.shapeLayerOffset + _panDistanceBeforeFlinging,
        _controller.shapeLayerSizeFactor);
    final Offset delta = _getValidPanDelta(_downLocalPoint! - localFocalPoint);
    _controller.panDistance = _panDistanceBeforeFlinging + delta;
    _controller.updateVisibleBounds(
        _controller.shapeLayerOffset + _panDistanceBeforeFlinging + delta);
    _controller.notifyRefreshListeners();
    markNeedsPaint();
  }

  void _handleFocalLatLngAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _focalLatLngTween.end != null) {
      _handleFocalLatLngAnimationEnd();
    }
  }

  void _handleFocalLatLngAnimationEnd() {
    _isFlingAnimationActive = false;
    _panEnd();
    _referenceVisibleBounds =
        _controller.getVisibleBounds(_controller.shapeLayerOffset);
    _referenceShapeBounds = _getShapeBounds(
        _controller.shapeLayerSizeFactor, _controller.shapeLayerOffset);
    final Offset localFocalPoint = pixelFromLatLng(
        _controller.visibleFocalLatLng!.latitude,
        _controller.visibleFocalLatLng!.longitude,
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor);
    final Offset previousFocalPoint = pixelFromLatLng(
        _focalLatLngTween.begin!.latitude,
        _focalLatLngTween.begin!.longitude,
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor);
    _invokeOnPanning(localFocalPoint, previousFocalPoint,
        localToGlobal(localFocalPoint), true);
  }

  void _panEnd() {
    _controller.isInInteractive = false;
    _zoomDetails = null;
    _panDetails = null;
    _panDistanceBeforeFlinging = Offset.zero;
    if (_zoomPanBehavior!.enablePanning && !_state.isSublayer) {
      _controller.shapeLayerOffset += _controller.panDistance;
      _controller.shapeLayerOrigin += _controller.panDistance;
      _updateMapDataSourceForVisual();
      _controller.notifyRefreshListeners();
      markNeedsPaint();
    }

    _referenceVisibleBounds = null;
    _referenceShapeBounds = null;
    _downLocalPoint = null;
    _downGlobalPoint = null;
    _controller.gesture = null;
    _controller.panDistance = Offset.zero;
  }

  void _handleFlingAnimations() {
    if (_state.zoomLevelAnimationController.isAnimating && !_doubleTapEnabled) {
      _state.zoomLevelAnimationController.stop();
      _isZoomedUsingToolbar = false;
      _handleZoomingAnimationEnd();
    }
    if (_state.focalLatLngAnimationController.isAnimating) {
      _state.focalLatLngAnimationController.stop();
      _handleFocalLatLngAnimationEnd();
    }
  }

  void _handleRefresh() {
    if (_state.isSublayer) {
      _refresh();
    }
  }

  void _handleReset() {
    _zoomPanBehavior!.zoomLevel = _zoomPanBehavior!.minZoomLevel;
  }

  void _handleTapUp(TapUpDetails details) {
    _handleTap(details.localPosition, PointerDeviceKind.touch);
  }

  void _handleTap(Offset position, PointerDeviceKind deviceKind) {
    _invokeSelectionChangedCallback(_currentInteractedItem);
    if (_currentInteractedItem != null &&
        deviceKind != PointerDeviceKind.mouse) {
      _invokeTooltip(
          position: position,
          model: _currentInteractedItem,
          element: _currentInteractedElement!);
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    if (_currentSelectedItem != null) {
      _currentHoverItem = null;
    }
  }

  void _handleDoubleTap() {
    if (_controller.gesture == null && _zoomPanBehavior != null) {
      double newZoomLevel = _currentZoomLevel + 1;
      newZoomLevel = newZoomLevel.clamp(
          _zoomPanBehavior!.minZoomLevel, _zoomPanBehavior!.maxZoomLevel);
      if (newZoomLevel == _currentZoomLevel) {
        return;
      }

      _state.zoomLevelAnimationController.duration =
          const Duration(milliseconds: 200);
      _doubleTapEnabled = true;
      // Based on the isInInteractive value we have updated the maps at
      // _handleZooming(). To avoid this at double tap zooming, we have reset
      // the isInInteractive.
      _controller.isInInteractive = false;
      _invokeOnZooming(
          _getScale(newZoomLevel), _downLocalPoint, _downGlobalPoint);
    }
  }

  void _resetDoubleTapTimer() {
    _pointerCount = 0;
    if (_doubleTapTimer != null) {
      _doubleTapTimer?.cancel();
      _doubleTapTimer = null;
    }
  }

  void _handleHover(PointerHoverEvent event) {
    // ignore: avoid_as
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(event.position);
    _prevSelectedItem = null;
    _performChildHover(localPosition);
  }

  void _handleExit(PointerExitEvent event) {
    if (_state.widget.source.bubbleSizeMapper != null && hasBubbleHoverColor) {
      final ShapeLayerChildRenderBoxBase bubbleRenderObject =
          _state.bubbleKey.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      bubbleRenderObject.onExit();
    }

    if (hasShapeHoverColor && _currentHoverItem != null) {
      _previousHoverItem = _currentHoverItem;
      _currentHoverItem = null;
      _updateHoverItemTween();
    }

    // In sublayer, we have updated [hitTestSelf] as true only if the cursor
    // position lies inside a shape. If not, we will make it as false.
    // When setting false to [hitTestSelf], the framework will invoke the
    // [_handleExit] method in desktop. To hide the previous rendered tooltip,
    // we had passed the null value for model.
    if ((_state.widget.shapeTooltipBuilder != null ||
        _state.widget.bubbleTooltipBuilder != null)) {
      final ShapeLayerChildRenderBoxBase tooltipRenderObject =
          _controller.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      tooltipRenderObject.hideTooltip();
    }
  }

  Gesture? _getGestureType(double scale, Offset point) {
    if (scale == 1) {
      if (_downLocalPoint != null) {
        final Offset distance = point - _downLocalPoint!;
        return distance.dx.abs() > _minPanDistance ||
                distance.dy.abs() > _minPanDistance
            ? Gesture.pan
            : null;
      }
    }

    return Gesture.scale;
  }

  Offset _getValidPanDelta(Offset delta) {
    final Rect currentShapeBounds = _getShapeBounds(
        _controller.shapeLayerSizeFactor, _controller.shapeLayerOffset + delta);
    double dx = 0.0, dy = 0.0;
    if (_referenceVisibleBounds!.width < _referenceShapeBounds!.width) {
      dx = delta.dx;
      if (currentShapeBounds.left > _referenceVisibleBounds!.left) {
        dx = _referenceVisibleBounds!.left - _referenceShapeBounds!.left;
      }

      if (currentShapeBounds.right < _referenceVisibleBounds!.right) {
        dx = _referenceVisibleBounds!.right - _referenceShapeBounds!.right;
      }
    }

    if (_referenceVisibleBounds!.height < _referenceShapeBounds!.height) {
      dy = delta.dy;
      if (currentShapeBounds.top > _referenceVisibleBounds!.top) {
        dy = _referenceVisibleBounds!.top - _referenceShapeBounds!.top;
      }

      if (currentShapeBounds.bottom < _referenceVisibleBounds!.bottom) {
        dy = _referenceVisibleBounds!.bottom - _referenceShapeBounds!.bottom;
      }
    }

    return Offset(dx, dy);
  }

  void _validateEdges(double zoomLevel, [Offset? origin]) {
    final Offset leftTop = _controller.getZoomingTranslation(
        origin: origin,
        scale: _getScale(zoomLevel),
        previousOrigin: _controller.shapeLayerOrigin);
    _controller.currentBounds = Rect.fromLTWH(leftTop.dx, leftTop.dy,
        _size.width * zoomLevel, _size.height * zoomLevel);
    _controller.normalize = _getNormalizedOffset(zoomLevel);
  }

  Offset _getNormalizedOffset(double zoomLevel) {
    double dx = 0.0, dy = 0.0;
    final Rect currentBounds = _controller.currentBounds;
    if (currentBounds.left > paintBounds.left) {
      dx = paintBounds.left - currentBounds.left;
    }

    if (currentBounds.right < paintBounds.right) {
      dx = paintBounds.right - currentBounds.right;
    }

    if (currentBounds.top > paintBounds.top) {
      dy = paintBounds.top - currentBounds.top;
    }

    if (currentBounds.bottom < paintBounds.bottom) {
      dy = paintBounds.bottom - currentBounds.bottom;
    }

    return Offset(dx, dy);
  }

  double _getZoomLevel(double scale) {
    return (_controller.shapeLayerSizeFactor * scale / _actualFactor).clamp(
      _zoomPanBehavior!.minZoomLevel,
      _zoomPanBehavior!.maxZoomLevel,
    );
  }

  double _getScale(double zoomLevel) {
    return _actualFactor * zoomLevel / _controller.shapeLayerSizeFactor;
  }

  bool _isElementLiesOnPosition(Offset position) {
    if (!isInteractive && _mapDataSource.isEmpty) {
      return false;
    }

    double? bubbleRadius;
    _currentInteractedItem = null;
    _currentInteractedElement = null;
    for (final MapModel mapModel in _mapDataSource.values) {
      final bool wasToggled = _controller.wasToggled(mapModel);
      if (_isBubbleContains(position, mapModel)) {
        _currentInteractedElement = MapLayerElement.bubble;
        if (!wasToggled &&
            (bubbleRadius == null || mapModel.bubbleRadius! < bubbleRadius)) {
          bubbleRadius = mapModel.bubbleRadius;
          _currentInteractedItem = mapModel;
        }
      } else if (_isShapeContains(
              position, mapModel, _currentInteractedElement) &&
          !(wasToggled && _state.widget.legend!.source == MapElement.shape)) {
        _currentInteractedItem = mapModel;
        _currentInteractedElement = MapLayerElement.shape;
        if (!(_state.widget.bubbleTooltipBuilder != null ||
            hasBubbleHoverColor)) {
          break;
        }
      }
    }

    return _currentInteractedItem != null && _currentInteractedElement != null;
  }

  bool _isBubbleContains(Offset position, MapModel mapModel) {
    return (_state.widget.bubbleTooltipBuilder != null ||
            hasBubbleHoverColor) &&
        mapModel.bubblePath != null &&
        mapModel.bubblePath!.contains(position);
  }

  bool _isShapeContains(
      Offset position, MapModel mapModel, MapLayerElement? element) {
    return (_state.widget.onSelectionChanged != null ||
            _state.widget.shapeTooltipBuilder != null ||
            hasShapeHoverColor) &&
        element != MapLayerElement.bubble &&
        mapModel.shapePath!.contains(position);
  }

  void _performChildHover(Offset position) {
    final MapModel? currentInteractedItem = _currentInteractedItem;
    _invokeTooltip(
        position: position,
        model: _currentInteractedItem,
        element: _currentInteractedElement,
        kind: PointerKind.hover);
    if (_state.widget.source.bubbleSizeMapper != null) {
      final ShapeLayerChildRenderBoxBase bubbleRenderObject =
          _state.bubbleKey.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      bubbleRenderObject.onHover(
          currentInteractedItem, _currentInteractedElement);
    }

    if (hasShapeHoverColor &&
        (_currentSelectedItem == null ||
            _currentSelectedItem != _currentInteractedItem)) {
      if (_currentInteractedElement == MapLayerElement.shape &&
          _currentHoverItem != _currentInteractedItem) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = _currentInteractedItem;
        _updateHoverItemTween();
      } else if ((_currentHoverItem != null &&
              _currentHoverItem != _currentInteractedItem) ||
          (_currentInteractedElement == MapLayerElement.bubble &&
              _currentHoverItem == _currentInteractedItem)) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = null;
        _updateHoverItemTween();
      }
    }
  }

  void _invokeSelectionChangedCallback(MapModel? mapModel) {
    if (_state.widget.onSelectionChanged != null &&
        mapModel != null &&
        mapModel.dataIndex != null) {
      _state.widget.onSelectionChanged!(mapModel.dataIndex!);
    }
  }

  void _invokeTooltip(
      {MapModel? model,
      Offset? position,
      MapLayerElement? element,
      PointerKind kind = PointerKind.touch}) {
    if ((_state.widget.shapeTooltipBuilder != null ||
        _state.widget.bubbleTooltipBuilder != null)) {
      Rect? elementRect;
      final ShapeLayerChildRenderBoxBase tooltipRenderObject =
          _controller.tooltipKey!.currentContext!.findRenderObject()
              // ignore: avoid_as
              as ShapeLayerChildRenderBoxBase;
      if (model != null && element == MapLayerElement.bubble) {
        elementRect = Rect.fromCircle(
            center: model.shapePathCenter!, radius: model.bubbleRadius!);
      }
      int? sublayerIndex;
      if (_state.isSublayer) {
        sublayerIndex =
            _state.ancestor.sublayers!.indexOf(_state.widget.sublayerAncestor!);
      }

      // The elementRect is not applicable, if the actual element is shape. The
      // sublayerIndex is not applicable, if the actual layer is shape layer.
      tooltipRenderObject.paintTooltip(model?.dataIndex, elementRect, element,
          kind, sublayerIndex, position);
    }
  }

  void _handleShapeLayerSelection() {
    assert(_selectedIndex < _mapSource!.dataCount);
    _prevSelectedItem = _currentSelectedItem;
    if (_selectedIndex == -1) {
      if (_prevSelectedItem != null) {
        _prevSelectedItem!.isSelected = false;
      }

      _currentSelectedItem = null;
    } else {
      _currentSelectedItem = _mapDataSource.values.firstWhere(
          (MapModel element) => element.dataIndex == _selectedIndex);
      _currentSelectedItem!.isSelected = !_currentSelectedItem!.isSelected;
      if (_prevSelectedItem != null) {
        _prevSelectedItem!.isSelected = false;
      }
    }

    _updateCurrentSelectedItemTween();
    _state.selectionAnimationController.forward(from: 0);
  }

  void _handleToggleChange() {
    _previousHoverItem = null;
    if (_state.widget.legend != null &&
        _state.widget.legend!.source == MapElement.shape) {
      late MapModel model;
      if (_state.widget.source.shapeColorMappers == null) {
        model =
            mapDataSource.values.elementAt(_controller.currentToggledItemIndex);
      } else {
        for (final mapModel in _mapDataSource.values) {
          if (mapModel.dataIndex != null &&
              mapModel.legendMapperIndex ==
                  _controller.currentToggledItemIndex) {
            model = mapModel;
            break;
          }
        }
      }

      final Color shapeColor = (_currentSelectedItem != null &&
              _currentSelectedItem!.actualIndex == model.actualIndex)
          ? _themeData.selectionColor
          : getActualShapeColor(model);
      _forwardToggledShapeColorTween.begin = shapeColor;
      _reverseToggledShapeColorTween.end = shapeColor;
      _state.toggleAnimationController.forward(from: 0);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _state.selectionAnimationController.addListener(markNeedsPaint);
    _state.toggleAnimationController.addListener(markNeedsPaint);
    _state.hoverShapeAnimationController.addListener(markNeedsPaint);

    _controller
      ..addZoomingListener(_handleZooming)
      ..addPanningListener(_handlePanning)
      ..addResetListener(_handleReset);
    if (_state.isSublayer) {
      _controller.addRefreshListener(_handleRefresh);
    } else {
      _controller.addToggleListener(_handleToggleChange);

      _state.zoomLevelAnimationController
        ..addListener(_handleZoomLevelAnimation)
        ..addStatusListener(_handleZoomLevelAnimationStatusChange);

      _state.focalLatLngAnimationController
        ..addListener(_handleFocalLatLngAnimation)
        ..addStatusListener(_handleFocalLatLngAnimationStatusChange);
    }
    SchedulerBinding.instance?.addPostFrameCallback(_initiateInitialAnimations);
  }

  @override
  void detach() {
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    _state.selectionAnimationController.removeListener(markNeedsPaint);
    _state.toggleAnimationController.removeListener(markNeedsPaint);
    _state.hoverShapeAnimationController.removeListener(markNeedsPaint);
    _controller
      ..removeZoomingListener(_handleZooming)
      ..removePanningListener(_handlePanning)
      ..removeResetListener(_handleReset);
    if (_state.isSublayer) {
      _controller.removeRefreshListener(_handleRefresh);
    } else {
      _controller.removeToggleListener(_handleToggleChange);

      _state.zoomLevelAnimationController
        ..removeListener(_handleZoomLevelAnimation)
        ..removeStatusListener(_handleZoomLevelAnimationStatusChange);

      _state.focalLatLngAnimationController
        ..removeListener(_handleFocalLatLngAnimation)
        ..removeStatusListener(_handleFocalLatLngAnimationStatusChange);
    }
    _zoomingDelayTimer?.cancel();
    super.detach();
  }

  @override
  bool hitTestSelf(Offset position) {
    final bool hasHitTestSelf = _isElementLiesOnPosition(position);
    return canZoom || hasHitTestSelf;
  }

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    _zoomPanBehavior?.handleEvent(event);
    if (event is PointerDownEvent && event.down && (isInteractive || canZoom)) {
      if (isInteractive &&
          !_state.zoomLevelAnimationController.isAnimating &&
          !_state.focalLatLngAnimationController.isAnimating) {
        _tapGestureRecognizer.addPointer(event);
      } else {
        _handleFlingAnimations();
      }

      if (canZoom) {
        _scaleGestureRecognizer.addPointer(event);
        if (_zoomPanBehavior!.enableDoubleTapZooming) {
          _doubleTapTimer ??= Timer(kDoubleTapTimeout, _resetDoubleTapTimer);
        }
      }
    } else if (event is PointerUpEvent && canZoom) {
      if (_doubleTapTimer != null && _doubleTapTimer!.isActive) {
        _pointerCount++;
      }

      if (_pointerCount == 2) {
        _downLocalPoint = event.localPosition;
        _downGlobalPoint = event.position;
        _resetDoubleTapTimer();
        _handleDoubleTap();
      }
    } else if (event is PointerCancelEvent && isInteractive) {
      _handleTap(event.localPosition, event.kind);
    } else if (event is PointerScrollEvent) {
      _handleScrollEvent(event);
    } else if (_state.isDesktop && event is PointerHoverEvent) {
      // PointerHoverEvent is applicable only for web platform.
      _handleHover(event);
    }
  }

  @override
  void performLayout() {
    _size = getBoxSize(constraints);
    _controller.shapeLayerBoxSize = _size;
    if (!hasSize || size != _size) {
      size = _size;
      _refresh(_controller.visibleFocalLatLng);
    }

    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    RenderBox? child = firstChild;
    while (child != null) {
      final StackParentData childParentData =
          // ignore: avoid_as
          child.parentData as StackParentData;
      child.layout(looseConstraints);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_mapDataSource.isNotEmpty) {
      context.canvas.save();
      _controller.applyTransform(context, offset);
      final bool hasToggledIndices = _controller.toggledIndices.isNotEmpty;
      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      final bool hasPrevSelectedItem = _prevSelectedItem != null &&
          !_controller.wasToggled(_prevSelectedItem!);
      final bool hasCurrentSelectedItem = _currentSelectedItem != null &&
          !_controller.wasToggled(_currentSelectedItem!);

      _mapDataSource.forEach((String key, MapModel model) {
        if (_currentHoverItem != null &&
            _currentHoverItem!.primaryKey == model.primaryKey) {
          return;
        }

        if (hasCurrentSelectedItem && selectedIndex == model.dataIndex) {
          return;
        }

        if (hasPrevSelectedItem && _prevSelectedItem!.primaryKey == key) {
          fillPaint.color =
              _reverseSelectionColorTween.evaluate(_selectionColorAnimation)!;
          strokePaint
            ..color = _reverseSelectionStrokeColorTween
                .evaluate(_selectionColorAnimation)!
            ..strokeWidth = _themeData.selectionStrokeWidth;
        } else if (_previousHoverItem != null &&
            _previousHoverItem!.primaryKey == key &&
            !_controller.wasToggled(_previousHoverItem!) &&
            _previousHoverItem != _currentHoverItem) {
          fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
              ? _reverseHoverColorTween.evaluate(_hoverColorAnimation)!
              : getActualShapeColor(model);

          if (_themeData.shapeHoverStrokeWidth! > 0.0 &&
              _themeData.shapeHoverStrokeColor != Colors.transparent) {
            strokePaint
              ..color =
                  _reverseHoverStrokeColorTween.evaluate(_hoverColorAnimation)!
              ..strokeWidth = _themeData.layerStrokeWidth;
          } else {
            strokePaint
              ..color = _themeData.layerStrokeColor
              ..strokeWidth = _themeData.layerStrokeWidth;
          }
        } else {
          _updateFillColor(model, fillPaint, hasToggledIndices);
          _updateStrokePaint(model, strokePaint, hasToggledIndices);
        }

        context.canvas.drawPath(model.shapePath!, fillPaint);
        if (strokePaint.strokeWidth > 0.0 &&
            strokePaint.color != Colors.transparent) {
          strokePaint.strokeWidth =
              _getIntrinsicStrokeWidth(strokePaint.strokeWidth);
          context.canvas.drawPath(model.shapePath!, strokePaint);
        }
      });

      _drawHoverShape(context, fillPaint, strokePaint);
      _drawSelectedShape(context, fillPaint, strokePaint);
      context.canvas.restore();
      super.paint(context, offset);
    }
  }

  // Set the color to the toggled and un-toggled shapes based on
  // the [legendController.toggledIndices] collection.
  void _updateFillColor(
      MapModel model, Paint fillPaint, bool hasToggledIndices) {
    fillPaint.style = PaintingStyle.fill;
    if (_state.widget.legend != null &&
        _state.widget.legend!.source == MapElement.shape) {
      if (_controller.currentToggledItemIndex == model.legendMapperIndex) {
        final Color? shapeColor = _controller.wasToggled(model)
            ? _forwardToggledShapeColorTween.evaluate(_toggleShapeAnimation)
            : _reverseToggledShapeColorTween.evaluate(_toggleShapeAnimation);
        // Set tween color to the shape based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledShapeColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledShapeColorTween] return.
        fillPaint.color = shapeColor ?? Colors.transparent;
        return;
      } else if (hasToggledIndices && _controller.wasToggled(model)) {
        // Set toggled color to the previously toggled shapes.
        fillPaint.color =
            _forwardToggledShapeColorTween.end ?? Colors.transparent;
        return;
      }
    }

    fillPaint.color = getActualShapeColor(model);
  }

  // Set the stroke paint to the toggled and un-toggled shapes based on
  // the [legendController.toggledIndices] collection.
  void _updateStrokePaint(
      MapModel model, Paint strokePaint, bool hasToggledIndices) {
    if (_state.widget.legend != null &&
        _state.widget.legend!.source == MapElement.shape) {
      if (_controller.currentToggledItemIndex == model.legendMapperIndex) {
        final Color? shapeStrokeColor = _controller.wasToggled(model)
            ? _forwardToggledShapeStrokeColorTween
                .evaluate(_toggleShapeAnimation)
            : _reverseToggledShapeStrokeColorTween
                .evaluate(_toggleShapeAnimation);
        // Set tween color to the shape stroke based on the currently
        // tapped legend item. If the legend item is toggled, then the
        // [_forwardToggledShapeStrokeColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledShapeStrokeColorTween] return.
        strokePaint
          ..color = shapeStrokeColor ?? Colors.transparent
          ..strokeWidth = _controller.wasToggled(model)
              ? _legend!.toggledItemStrokeWidth
              : _themeData.layerStrokeWidth;
        return;
      } else if (hasToggledIndices && _controller.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled shapes.
        strokePaint
          ..color =
              _forwardToggledShapeStrokeColorTween.end ?? Colors.transparent
          ..strokeWidth = _legend!.toggledItemStrokeWidth;
        return;
      }
    }

    strokePaint
      ..color = _themeData.layerStrokeColor
      ..strokeWidth = _themeData.layerStrokeWidth;
  }

  // Returns the color to the shape based on the [shapeColorMappers] and
  // [layerColor] properties.
  Color getActualShapeColor(MapModel model) {
    return model.shapeColor ?? _themeData.layerColor;
  }

  double _getIntrinsicStrokeWidth(double strokeWidth) {
    return strokeWidth /=
        _controller.gesture == Gesture.scale ? _controller.localScale : 1;
  }

  void _drawSelectedShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentSelectedItem != null &&
        !_controller.wasToggled(_currentSelectedItem!)) {
      fillPaint.color =
          _forwardSelectionColorTween!.evaluate(_selectionColorAnimation)!;
      context.canvas.drawPath(_currentSelectedItem!.shapePath!, fillPaint);
      if (_themeData.selectionStrokeWidth > 0.0) {
        strokePaint
          ..color = _forwardSelectionStrokeColorTween
              .evaluate(_selectionColorAnimation)!
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.selectionStrokeWidth);
        context.canvas.drawPath(_currentSelectedItem!.shapePath!, strokePaint);
      }
    }
  }

  void _drawHoverShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentHoverItem != null) {
      fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColorTween.evaluate(_hoverColorAnimation)!
          : getActualShapeColor(_currentHoverItem!);
      context.canvas.drawPath(_currentHoverItem!.shapePath!, fillPaint);
      if (_themeData.shapeHoverStrokeWidth! > 0.0 &&
          _themeData.shapeHoverStrokeColor != Colors.transparent) {
        strokePaint
          ..color =
              _forwardHoverStrokeColorTween.evaluate(_hoverColorAnimation)!
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.shapeHoverStrokeWidth!);
      } else {
        strokePaint
          ..color = _themeData.layerStrokeColor
          ..strokeWidth = _getIntrinsicStrokeWidth(_themeData.layerStrokeWidth);
      }

      if (strokePaint.strokeWidth > 0.0 &&
          strokePaint.color != Colors.transparent) {
        context.canvas.drawPath(_currentHoverItem!.shapePath!, strokePaint);
      }
    }
  }
}
