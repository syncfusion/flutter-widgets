import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data' show Uint8List;
import 'dart:ui';

import 'package:collection/collection.dart' show MapEquality;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../behavior/zoom_pan_behavior.dart';
import '../controller/default_controller.dart';
import '../controller/shape_layer_controller.dart';
import '../elements/bubble.dart';
import '../elements/data_label.dart';
import '../elements/legend.dart';
import '../elements/marker.dart';
import '../elements/shapes.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../enum.dart';
import '../layer/layer_base.dart';
import '../layer/vector_layers.dart';
import '../settings.dart';
import '../utils.dart';

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
///   @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            source: MapShapeSource.asset(
///                "assets/world_map.json",
///                shapeDataField: "name",
///                dataCount: data.length,
///                primaryValueMapper: (index) {
///                  return data[index].country;
///                },
///                dataLabelMapper: (index) {
///                  return data[index].countryCode;
///                }),
///        )
///      ],
///    );
///  }
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
  ///             source: MapShapeSource.asset(
  ///               'assets/Ireland.json',
  ///               shapeDataField: 'name',
  ///            ),
  ///             showDataLabels: true,
  ///             color: Colors.orange[100],
  ///           ),
  ///        ],
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  MapShapeSource.asset(
    String name, {
    this.shapeDataField,
    this.dataCount,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _mapProvider = AssetMapProvider(name),
        assert(name != null),
        assert(dataCount == null || dataCount > 0),
        assert(primaryValueMapper == null ||
            (primaryValueMapper != null && dataCount != null && dataCount > 0)),
        assert(shapeColorMappers == null ||
            (shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null)),
        assert(bubbleColorMappers == null ||
            (bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null));

  /// Creates a layer using the .json file from the network.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(
  ///       title: Text('Network sample'),
  ///     ),
  ///     body: SfMaps(
  ///       layers: [
  ///         MapShapeLayer(
  ///           source: MapShapeSource.network(
  ///             'http://www.json-generator.com/api/json/get/bVqXoJvfjC?indent=2',
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  MapShapeSource.network(
    String src, {
    this.shapeDataField,
    this.dataCount,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _mapProvider = NetworkMapProvider(src),
        assert(src != null),
        assert(dataCount == null || dataCount > 0),
        assert(primaryValueMapper == null ||
            (primaryValueMapper != null && dataCount != null && dataCount > 0)),
        assert(shapeColorMappers == null ||
            (shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null)),
        assert(bubbleColorMappers == null ||
            (bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null));

  /// Creates a layer using the GeoJSON source as bytes from [Uint8List].
  ///
  /// ```dart
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
  ///          source: MapShapeSource.memory(
  ///             bytes,
  ///             shapeDataField: 'name',
  ///             dataCount: 6,
  ///             primaryValueMapper: (index) => dataSource[index].key,
  ///             dataLabelMapper: (index) => dataSource[index].dataLabel,
  ///             shapeColorValueMapper: (index) => dataSource[index].color,
  ///           ),
  ///           showDataLabels: true,
  ///           color: Colors.orange[100],
  ///         ),
  ///       ],
  ///     )),
  ///   );
  /// }
  /// ```
  MapShapeSource.memory(
    Uint8List bytes, {
    this.shapeDataField,
    this.dataCount,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : _mapProvider = MemoryMapProvider(bytes),
        assert(bytes != null),
        assert(dataCount == null || dataCount > 0),
        assert(primaryValueMapper == null ||
            (primaryValueMapper != null && dataCount != null && dataCount > 0)),
        assert(shapeColorMappers == null ||
            (shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null)),
        assert(bubbleColorMappers == null ||
            (bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null));

  /// Field name in the .json file to identify each shape.
  ///
  /// It is used to refer the field name in the .json file to identify
  /// each shape and map that shape with the respective data in
  /// the data source.
  final String shapeDataField;

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
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// The below code snippet represents how color can be applied to the shape
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final List<MapColorMapper> shapeColorMappers;

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
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleColorMappers: [
  ///                MapColorMapper(from: 0, to: 100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// The below code snippet represents how color can be applied to the bubble
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleColorMappers: [
  ///               MapColorMapper(value: "Low", color: Colors.red),
  ///               MapColorMapper(value: "High", color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final List<MapColorMapper> bubbleColorMappers;

  /// Returns the the primary value for the every data in the data source
  /// collection.
  ///
  /// This primary value will be mapped with the [shapeDataField] value in the
  /// respective shape detail in the .json file. This mapping will then be used
  /// in the rendering of bubbles, data labels, shape colors, tooltip
  /// in their respective shape's coordinates.
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper primaryValueMapper;

  /// Returns the data label text for each shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showDataLabels: true,
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              dataLabelMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper dataLabelMapper;

  /// Returns a value based on which bubble size will be calculated.
  ///
  /// The minimum and maximum size of the bubble can be customized using the
  /// [MapBubbleSettings.minRadius] and [MapBubbleSettings.maxRadius].
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///            source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return bubbleData[index].usersCount;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedDoubleValueMapper bubbleSizeMapper;

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
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedColorValueMapper shapeColorValueMapper;

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
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///               bubbleSizeMapper: (index) {
  ///               return bubbleData[index].usersCount;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedColorValueMapper bubbleColorValueMapper;

  /// Converts json file to future string based on asset, network,
  /// memory and file.
  final MapProvider _mapProvider;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_mapProvider.shapePath != null) {
      properties.add(StringProperty(null, _mapProvider.shapePath));
    }
    if (_mapProvider.bytes != null) {
      properties.add(StringProperty(null, 'Shape source in bytes'));
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

class _ShapeBounds {
  _ShapeBounds(
      {this.minLongitude,
      this.minLatitude,
      this.maxLongitude,
      this.maxLatitude});

  num minLongitude;

  num minLatitude;

  num maxLongitude;

  num maxLatitude;

  _ShapeBounds get empty => _ShapeBounds(
      minLongitude: null,
      minLatitude: null,
      maxLongitude: null,
      maxLatitude: null);
}

class _ShapeFileData {
  Map<String, dynamic> decodedJsonData;

  Map<String, MapModel> mapDataSource;

  _ShapeBounds bounds;

  MapModel initialSelectedModel;

  void reset() {
    decodedJsonData?.clear();
    mapDataSource?.clear();
    bounds = bounds?.empty;
  }
}

Future<_ShapeFileData> _retrieveDataFromShapeFile(
    MapProvider provider,
    String shapeDataField,
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
  Map<String, dynamic> geometry;
  Map<String, dynamic> properties;

  final _ShapeFileData shapeFileData = data['ShapeFileData'];
  final String shapeDataField = data['ShapeDataField'];
  final bool isSublayer = data['IsSublayer'];
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
  if (isSublayer) {
    shapeFileData.bounds = _ShapeBounds(
        minLatitude: minimumLatitude,
        maxLatitude: maximumLatitude,
        minLongitude: minimumLongitude,
        maxLongitude: maximumLongitude);
  }

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

void _updateMapDataSource(_ShapeFileData shapeFileData, String shapeDataField,
    Map<String, dynamic> properties, List<dynamic> points, bool isSublayer) {
  final String dataPath =
      properties != null ? properties[shapeDataField] : null;
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
///                       source: MapShapeSource.asset(
///                          'assets/world_map.json',
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
  RenderShapeLayer _parentBox;

  /// Returns the current markers count.
  int get markersCount => _markersCount;
  int _markersCount = 0;

  /// Converts pixel point to [MapLatLng].
  MapLatLng pixelToLatLng(Offset position) {
    return getPixelToLatLng(
        position,
        _parentBox.size,
        _parentBox.controller.shapeLayerOffset,
        _parentBox.controller.shapeLayerSizeFactor);
  }
}

/// The sublayer in which geographical rendering is done.
///
/// This sublayer can be added as a sublayer of both [MapShapeLayer] and
/// [MapTileLayer].
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
///   @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///              "assets/world_map.json",
///              shapeDataField: "name",
///           ),
///          sublayer:[
///             MapShapeSublayer(
///               source: MapShapeSource.asset(
///                  "assets/africa.json",
///                  shapeDataField: "name",
///               ),
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
    Key key,
    @required this.source,
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
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: MapShapeSource.asset(
  ///                "assets/world_map.json",
  ///                shapeDataField: "name",
  ///            sublayers: [
  ///                MapShapeSublayer(
  ///                   source: MapShapeSource.asset(
  ///                      'assets/africa.json',
  ///                      shapeDataField: 'name',
  ///                   ),
  ///                   color: Colors.blue.withOpacity(0.7),
  ///                   strokeColor: Colors.blue,
  ///                 ),
  ///            ],
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
  final MapMarkerBuilder markerBuilder;

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
  final IndexedWidgetBuilder shapeTooltipBuilder;

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
  final IndexedWidgetBuilder bubbleTooltipBuilder;

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
  final IndexedWidgetBuilder markerTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count from this.
  final MapShapeLayerController controller;

  /// Shows or hides the data labels in the sublayer.
  ///
  /// Defaults to `false`.
  final bool showDataLabels;

  /// Color which is used to paint the sublayer shapes.
  final Color color;

  /// Color which is used to paint the stroke of the sublayer shapes.
  final Color strokeColor;

  /// Sets the stroke width of the sublayer shapes.
  final double strokeWidth;

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
  final ValueChanged<int> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return _MapsShapeLayer(
      key: key,
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
      sublayer: this,
    );
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
/// * [source], to provide data for the elements of the [SfMaps] like data
/// labels, bubbles, tooltip, shape colors, and legend.
class MapShapeLayer extends MapLayer {
  /// Creates a [MapShapeLayer].
  const MapShapeLayer({
    Key key,
    @required this.source,
    this.loadingBuilder,
    this.controller,
    List<MapSublayer> sublayers,
    int initialMarkersCount = 0,
    MapMarkerBuilder markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    IndexedWidgetBuilder markerTooltipBuilder,
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
    MapZoomPanBehavior zoomPanBehavior,
    this.onSelectionChanged,
    WillZoomCallback onWillZoom,
    WillPanCallback onWillPan,
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
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            source: MapShapeSource.asset(
  ///                "assets/world_map.json",
  ///                shapeDataField: "name",
  ///                dataCount: data.length,
  ///                primaryValueMapper: (index) {
  ///                  return data[index].country;
  ///                },
  ///                dataLabelMapper: (index) {
  ///                  return data[index].countryCode;
  ///                }),
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
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              source: MapShapeSource.asset(
  ///                'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///              ),
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
  final MapLoadingBuilder loadingBuilder;

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
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              source: MapShapeSource.asset(
  ///                'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///                dataCount: worldMapData.length,
  ///                primaryValueMapper: (index) =>
  ///                             worldMapData[index].primaryKey,
  ///              ),
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
  /// ```
  final IndexedWidgetBuilder shapeTooltipBuilder;

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
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              source: MapShapeSource.asset(
  ///                'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///                dataCount: worldMapData.length,
  ///                primaryValueMapper: (index) =>
  ///                             worldMapData[index].primaryKey,
  ///              ),
  ///              bubbleTooltipBuilder: (BuildContext context, int index) {
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
  /// ```
  final IndexedWidgetBuilder bubbleTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count and selected shape's index from
  /// this.
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
  ///                       source: MapShapeSource.asset(
  ///                          'assets/world_map.json',
  ///                          shapeDataField: 'name',
  ///                        ),
  ///                        initialMarkersCount: 5,
  ///                        markerBuilder: (BuildContext context, int index) {
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
  final MapShapeLayerController controller;

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
  final Color color;

  /// Color which is used to paint the stroke of the shapes.
  final Color strokeColor;

  /// Sets the stroke width of the shapes.
  final double strokeWidth;

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
  final MapLegend legend;

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
  /// int _selectedIndex = -1;
  ///
  /// SfMaps(
  ///   layers: [MultiChildMapShapeLayer(
  ///       source: source,
  ///       selectedIndex: _selectedIndex,
  ///       onSelectionChanged: (int index) {
  ///           setState(() {
  ///              _selectedIndex = (_selectedIndex == index) ? -1 : index;
  ///            });
  ///         },
  ///       )]
  /// )
  ///
  /// ```
  final ValueChanged<int> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return _MapsShapeLayer(
      key: key,
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
      properties.add(IntProperty('markersCount', controller.markersCount));
    } else {
      properties.add(IntProperty('markersCount', initialMarkersCount));
    }
    properties.add(ObjectFlagProperty<MapMarkerBuilder>.has(
        'markerBuilder', markerBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'shapeTooltip', shapeTooltipBuilder));
    properties.add(ObjectFlagProperty<IndexedWidgetBuilder>.has(
        'bubbleTooltip', bubbleTooltipBuilder));
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

    if (strokeColor != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    properties.add(IntProperty('selectedIndex', selectedIndex));
    properties
        .add(dataLabelSettings.toDiagnosticsNode(name: 'dataLabelSettings'));
    if (legend != null) {
      properties.add(legend.toDiagnosticsNode(name: 'legend'));
    }
    properties.add(bubbleSettings.toDiagnosticsNode(name: 'bubbleSettings'));
    properties
        .add(selectionSettings.toDiagnosticsNode(name: 'selectionSettings'));
    properties.add(tooltipSettings.toDiagnosticsNode(name: 'tooltipSettings'));
    if (zoomPanBehavior != null) {
      properties
          .add(zoomPanBehavior.toDiagnosticsNode(name: 'zoomPanBehavior'));
    }
    properties.add(
        ObjectFlagProperty<WillZoomCallback>.has('onWillZoom', onWillZoom));
    properties
        .add(ObjectFlagProperty<WillPanCallback>.has('onWillPan', onWillPan));
  }
}

class _MapsShapeLayer extends StatefulWidget {
  const _MapsShapeLayer({
    Key key,
    this.source,
    this.loadingBuilder,
    this.controller,
    this.sublayers,
    this.initialMarkersCount,
    this.markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    this.markerTooltipBuilder,
    this.showDataLabels,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.legend,
    this.dataLabelSettings,
    this.bubbleSettings,
    this.selectionSettings,
    this.tooltipSettings,
    this.selectedIndex,
    this.zoomPanBehavior,
    this.onSelectionChanged,
    this.onWillZoom,
    this.onWillPan,
    this.sublayer,
  }) : super(key: key);

  final MapShapeSource source;
  final MapLoadingBuilder loadingBuilder;
  final MapShapeLayerController controller;
  final List<MapSublayer> sublayers;
  final int initialMarkersCount;
  final MapMarkerBuilder markerBuilder;
  final IndexedWidgetBuilder shapeTooltipBuilder;
  final IndexedWidgetBuilder bubbleTooltipBuilder;
  final IndexedWidgetBuilder markerTooltipBuilder;
  final bool showDataLabels;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  final MapDataLabelSettings dataLabelSettings;
  final MapLegend legend;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapTooltipSettings tooltipSettings;
  final int selectedIndex;
  final MapZoomPanBehavior zoomPanBehavior;
  final ValueChanged<int> onSelectionChanged;
  final WillZoomCallback onWillZoom;
  final WillPanCallback onWillPan;
  final MapShapeSublayer sublayer;

  @override
  _MapsShapeLayerState createState() => _MapsShapeLayerState();
}

class _MapsShapeLayerState extends State<_MapsShapeLayer>
    with TickerProviderStateMixin {
  GlobalKey bubbleKey;
  GlobalKey tooltipKey;

  List<Widget> _markers;
  MapLegend _legendConfiguration;
  MapLayerLegend _legendWidget;
  _ShapeFileData shapeFileData;
  SfMapsThemeData _mapsThemeData;

  double minBubbleValue;
  double maxBubbleValue;

  bool _isShapeFileDecoded = false;
  bool _shouldUpdateMapDataSource = true;
  bool isDesktop = false;
  bool _hasSublayer = false;
  bool isSublayer = false;

  MapController controller;
  AnimationController toggleAnimationController;
  AnimationController _hoverBubbleAnimationController;
  AnimationController bubbleAnimationController;
  AnimationController dataLabelAnimationController;
  AnimationController hoverShapeAnimationController;
  AnimationController selectionAnimationController;
  AnimationController zoomLevelAnimationController;
  AnimationController focalLatLngAnimationController;

  @override
  void initState() {
    super.initState();
    assert(widget.source != null);
    bubbleKey = GlobalKey();
    tooltipKey = GlobalKey();
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
        vsync: this, value: 1.0, duration: const Duration(milliseconds: 200));
    zoomLevelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    focalLatLngAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));

    if (widget.controller != null) {
      widget.controller._markersCount = widget.initialMarkersCount;
    }

    _hasSublayer = widget.sublayers != null && widget.sublayers.isNotEmpty;
    MapMarker marker;
    _markers = <Widget>[];
    for (int i = 0; i < widget.initialMarkersCount; i++) {
      marker = widget.markerBuilder(context, i);
      assert(marker != null);
      _markers.add(marker);
    }

    widget.controller?.addListener(refreshMarkers);

    isSublayer = widget.sublayer != null;
    // For sublayer, we will use parent's map controller.
    if (!isSublayer) {
      controller = MapController()..tooltipKey = tooltipKey;
    }
  }

  @override
  void dispose() {
    dataLabelAnimationController?.dispose();
    bubbleAnimationController?.dispose();
    selectionAnimationController?.dispose();
    toggleAnimationController?.dispose();
    hoverShapeAnimationController?.dispose();
    _hoverBubbleAnimationController.dispose();
    zoomLevelAnimationController?.dispose();
    focalLatLngAnimationController?.dispose();

    _markers?.clear();
    widget.controller?.removeListener(refreshMarkers);
    if (!isSublayer) {
      controller?.dispose();
    }

    shapeFileData?.reset();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MapsShapeLayer oldWidget) {
    assert(widget.source != null);
    _shouldUpdateMapDataSource = oldWidget.source != widget.source;
    _hasSublayer = widget.sublayers != null && widget.sublayers.isNotEmpty;
    isSublayer = widget.sublayer != null;

    if (oldWidget.source._mapProvider != widget.source._mapProvider) {
      _isShapeFileDecoded = false;
      shapeFileData?.reset();
    }

    if (oldWidget.controller != widget.controller) {
      widget.controller._parentBox = context.findRenderObject();
    }

    if (_shouldUpdateMapDataSource && !isSublayer) {
      controller.visibleFocalLatLng = null;
    }

    super.didUpdateWidget(oldWidget);
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
        widget.source.shapeColorMappers.isNotEmpty);
    assert(widget.selectedIndex != null);

    final ThemeData themeData = Theme.of(context);
    _mapsThemeData = SfMapsTheme.of(context);
    if (widget.legend != null) {
      _legendConfiguration = widget.legend.copyWith(
          textStyle: themeData.textTheme.caption
              .copyWith(
                  color: themeData.textTheme.caption.color.withOpacity(0.87))
              .merge(widget.legend.textStyle ?? _mapsThemeData.legendTextStyle),
          toggledItemColor: _mapsThemeData.toggledItemColor,
          toggledItemStrokeColor: _mapsThemeData.toggledItemStrokeColor,
          toggledItemStrokeWidth: _mapsThemeData.toggledItemStrokeWidth);
      _legendWidget = MapLayerLegend(legend: _legendConfiguration);
    } else {
      _legendConfiguration = null;
    }

    isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows;
    _updateThemeData(context);
    return FutureBuilder<_ShapeFileData>(
      future: _retrieveDataFromShapeFile(
          widget.source._mapProvider,
          widget.source.shapeDataField,
          shapeFileData,
          _isShapeFileDecoded,
          isSublayer),
      builder: (BuildContext context, AsyncSnapshot<_ShapeFileData> snapshot) {
        if (snapshot.hasData && _isShapeFileDecoded) {
          shapeFileData = snapshot.data;
          if (_shouldUpdateMapDataSource) {
            minBubbleValue = null;
            maxBubbleValue = null;
            if (shapeFileData.mapDataSource != null) {
              shapeFileData.mapDataSource.values
                  .forEach((MapModel model) => model.reset());
            }
            _bindMapsSourceIntoDataSource();
            _shouldUpdateMapDataSource = false;
          }
          return _actualChild;
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

  bool _hasTooltipBuilder() {
    if (isSublayer) {
      return false;
    }

    if (widget.shapeTooltipBuilder != null ||
        widget.bubbleTooltipBuilder != null ||
        widget.markerTooltipBuilder != null) {
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

  Widget get _shapeLayerRenderObjectWidget {
    final List<Widget> children = <Widget>[];
    if (widget.source.bubbleSizeMapper != null) {
      children.add(
        MapBubble(
          key: bubbleKey,
          source: widget.source,
          mapDataSource: shapeFileData.mapDataSource,
          bubbleSettings: widget.bubbleSettings.copyWith(
              color: _mapsThemeData.bubbleColor,
              strokeColor: _mapsThemeData.bubbleStrokeColor,
              strokeWidth: _mapsThemeData.bubbleStrokeWidth),
          legend: _legendWidget,
          showDataLabels: widget.showDataLabels,
          themeData: _mapsThemeData,
          controller: controller,
          bubbleAnimationController: bubbleAnimationController,
          dataLabelAnimationController: dataLabelAnimationController,
          toggleAnimationController: toggleAnimationController,
          hoverBubbleAnimationController: _hoverBubbleAnimationController,
        ),
      );
    }

    if (widget.showDataLabels) {
      children.add(
        MapDataLabel(
          source: widget.source,
          mapDataSource: shapeFileData.mapDataSource,
          settings: widget.dataLabelSettings,
          effectiveTextStyle: Theme.of(context).textTheme.caption.merge(
              widget.dataLabelSettings.textStyle ??
                  _mapsThemeData.dataLabelTextStyle),
          themeData: _mapsThemeData,
          controller: controller,
          dataLabelAnimationController: dataLabelAnimationController,
        ),
      );
    }

    if (_hasSublayer) {
      children.add(
        ClipRect(
          child: SublayerContainer(
            controller: controller,
            tooltipKey: tooltipKey,
            children: widget.sublayers,
          ),
        ),
      );
    }

    if (_markers != null && _markers.isNotEmpty) {
      children.add(
        ClipRect(
          child: ShapeLayerMarkerContainer(
            tooltipKey: tooltipKey,
            markerTooltipBuilder: widget.markerTooltipBuilder,
            children: _markers,
            controller: controller,
            sublayer: widget.sublayer,
          ),
        ),
      );
    }

    if (widget.zoomPanBehavior != null) {
      children.add(
        BehaviorViewRenderObjectWidget(
          controller: controller,
          zoomPanBehavior: widget.zoomPanBehavior,
        ),
      );

      if (widget.zoomPanBehavior.showToolbar && isDesktop) {
        children.add(
          MapToolbar(
            onWillZoom: widget.onWillZoom,
            zoomPanBehavior: widget.zoomPanBehavior,
            controller: controller,
          ),
        );
      }
    }

    if (_hasTooltipBuilder()) {
      children.add(
        MapTooltip(
          key: tooltipKey,
          mapSource: widget.source,
          controller: controller,
          sublayers: widget.sublayers,
          tooltipSettings: widget.tooltipSettings,
          shapeTooltipBuilder: widget.shapeTooltipBuilder,
          bubbleTooltipBuilder: widget.bubbleTooltipBuilder,
          markerTooltipBuilder: widget.markerTooltipBuilder,
          themeData: _mapsThemeData,
        ),
      );
    }

    return _MapShapeLayerRenderObjectWidget(
      children: children,
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
      controller: controller,
      state: this,
    );
  }

  Widget get _actualChild {
    if (_legendConfiguration != null) {
      _updateLegendWidget();
      if (_legendConfiguration.offset == null) {
        switch (_legendConfiguration.position) {
          case MapLegendPosition.top:
            return Column(
              children: <Widget>[
                _legendWidget,
                _expandedShapeLayerWidget,
              ],
            );
          case MapLegendPosition.bottom:
            return Column(
              children: <Widget>[
                _expandedShapeLayerWidget,
                _legendWidget,
              ],
            );
          case MapLegendPosition.left:
            return Row(
              children: <Widget>[
                _legendWidget,
                _expandedShapeLayerWidget,
              ],
            );
          case MapLegendPosition.right:
            return Row(
              children: <Widget>[
                _expandedShapeLayerWidget,
                _legendWidget,
              ],
            );
        }
      } else {
        return _stackedLegendAndShapeLayerWidget;
      }
    }

    return _shapeLayerRenderObjectWidget;
  }

  void _updateLegendWidget() {
    _legendWidget = _legendWidget.copyWith(
      dataSource: _getLegendSource() ?? shapeFileData.mapDataSource,
      legend: _legendConfiguration,
      themeData: _mapsThemeData,
      controller: controller,
      toggleAnimationController: toggleAnimationController,
    );
  }

  List<MapColorMapper> _getLegendSource() {
    switch (widget.legend.source) {
      case MapElement.bubble:
        return widget.source.bubbleColorMappers;
        break;
      case MapElement.shape:
        return widget.source.shapeColorMappers;
        break;
    }
    return null;
  }

  Widget get _expandedShapeLayerWidget => Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[_shapeLayerRenderObjectWidget],
        ),
      );

  /// Returns the legend and map overlapping widget.
  Widget get _stackedLegendAndShapeLayerWidget => Stack(
        children: <Widget>[
          _shapeLayerRenderObjectWidget,
          Align(
            alignment: _getActualLegendAlignment(_legendConfiguration.position),
            // Padding widget is used to set the custom position to the legend.
            child: Padding(
              padding: _getActualLegendOffset(context),
              child: _legendWidget,
            ),
          ),
        ],
      );

  /// Returns the alignment for the legend if we set the legend offset.
  AlignmentGeometry _getActualLegendAlignment(MapLegendPosition position) {
    switch (position) {
      case MapLegendPosition.top:
        return Alignment.topCenter;
        break;
      case MapLegendPosition.bottom:
        return Alignment.bottomCenter;
        break;
      case MapLegendPosition.left:
        return Alignment.centerLeft;
        break;
      case MapLegendPosition.right:
        return Alignment.centerRight;
        break;
    }
    return Alignment.topCenter;
  }

  /// Returns the padding value to render the legend based on offset value.
  EdgeInsetsGeometry _getActualLegendOffset(BuildContext context) {
    final Offset offset = _legendConfiguration.offset;
    final MapLegendPosition legendPosition =
        _legendConfiguration.position ?? MapLegendPosition.top;
    // Here the default alignment is center for all the positions.
    // So need to handle the offset by multiplied it by 2.
    switch (legendPosition) {
      // Returns the insets for the offset if the legend position is top.
      case MapLegendPosition.top:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            top: offset.dy > 0 ? offset.dy : 0);
        break;
      // Returns the insets for the offset if the legend position is left.
      case MapLegendPosition.left:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            left: offset.dx > 0 ? offset.dx : 0);
        break;
      // Returns the insets for the offset if the legend position is right.
      case MapLegendPosition.right:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() : 0);
        break;
      // Returns the insets for the offset if the legend position is bottom.
      case MapLegendPosition.bottom:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() : 0);
        break;
    }
    return EdgeInsets.zero;
  }

  /// Updating [modelSource] data index based on [dataMapper]
  /// value and data color based on [colorValueMapper] value.
  void _bindMapsSourceIntoDataSource() {
    if (widget.source.dataCount != null &&
        widget.source.dataCount > 0 &&
        widget.source.primaryValueMapper != null) {
      final bool hasShapeColorValueMapper =
          widget.source.shapeColorValueMapper != null;
      final bool hasDataLabelMapper = widget.source.dataLabelMapper != null;
      final bool hasBubbleColorValueMapper =
          widget.source.bubbleColorValueMapper != null;
      final bool hasBubbleSizeMapper = widget.source.bubbleSizeMapper != null;

      for (int i = 0; i < widget.source.dataCount; i++) {
        final MapModel mapModel =
            shapeFileData.mapDataSource[widget.source.primaryValueMapper(i)];
        if (mapModel != null) {
          mapModel.dataIndex = i;
          _updateShapeColor(hasShapeColorValueMapper, i, mapModel);
          if (hasDataLabelMapper) {
            mapModel.dataLabelText = widget.source.dataLabelMapper(i);
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
          widget.source.shapeColorValueMapper(index),
          widget.source.shapeColorMappers,
          mapModel);
    }
  }

  void _updateBubbleColor(
      bool hasBubbleColorValueMapper, int index, MapModel mapModel) {
    if (hasBubbleColorValueMapper) {
      mapModel.bubbleColor = _getActualColor(
          widget.source.bubbleColorValueMapper(index),
          widget.source.bubbleColorMappers,
          mapModel);
    }
  }

  void _validateBubbleSize(
      bool hasBubbleSizeMapper, int index, MapModel mapModel) {
    if (hasBubbleSizeMapper) {
      mapModel.bubbleSizeValue = widget.source.bubbleSizeMapper(index);
      if (mapModel.bubbleSizeValue != null) {
        if (minBubbleValue == null) {
          minBubbleValue = mapModel.bubbleSizeValue;
          maxBubbleValue = mapModel.bubbleSizeValue;
        } else {
          minBubbleValue = min(mapModel.bubbleSizeValue, minBubbleValue);
          maxBubbleValue = max(mapModel.bubbleSizeValue, maxBubbleValue);
        }
      }
    }
  }

  /// Returns color from [MapColorMapper] based on the data source value.
  Color _getActualColor(
      Object colorValue, List<MapColorMapper> colorMappers, MapModel mapModel) {
    MapColorMapper mapper;
    final int length = colorMappers != null ? colorMappers.length : 0;
    // Handles equal color mapping.
    if (colorValue is String) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers[i];
        assert(mapper.value != null && mapper.color != null);
        if (mapper.value == colorValue) {
          mapModel?.legendMapperIndex = i;
          return mapper.color;
        }
      }
    }

    // Handles range color mapping.
    if (colorValue is num) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers[i];
        assert(
            mapper.from != null && mapper.to != null && mapper.color != null);
        if (mapper.from <= colorValue && mapper.to >= colorValue) {
          mapModel?.legendMapperIndex = i;
          if (mapper.minOpacity != null && mapper.maxOpacity != null) {
            return mapper.color.withOpacity(lerpDouble(
                mapper.minOpacity,
                mapper.maxOpacity,
                (colorValue - mapper.from) / (mapper.to - mapper.from)));
          }
          return mapper.color;
        }
      }
    }

    return colorValue;
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

class _MapShapeLayerRenderObjectWidget extends Stack {
  _MapShapeLayerRenderObjectWidget({
    List<Widget> children,
    this.mapDataSource,
    this.mapSource,
    this.selectedIndex,
    this.legend,
    this.bubbleSettings,
    this.selectionSettings,
    this.zoomPanBehavior,
    this.themeData,
    this.controller,
    this.state,
  }) : super(children: children ?? <Widget>[]);

  final Map<String, MapModel> mapDataSource;
  final MapShapeSource mapSource;
  final int selectedIndex;
  final MapLayerLegend legend;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapZoomPanBehavior zoomPanBehavior;
  final SfMapsThemeData themeData;
  final MapController controller;
  final _MapsShapeLayerState state;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return RenderShapeLayer(
      mapDataSource: mapDataSource,
      mapSource: mapSource,
      selectedIndex: selectedIndex,
      legend: legend,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      zoomPanBehavior: zoomPanBehavior,
      themeData: themeData,
      controller: controller,
      context: context,
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderShapeLayer renderObject) {
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

// ignore_for_file: public_member_api_docs
class RenderShapeLayer extends RenderStack implements MouseTrackerAnnotation {
  RenderShapeLayer({
    Map<String, MapModel> mapDataSource,
    MapShapeSource mapSource,
    int selectedIndex,
    MapLayerLegend legend,
    MapBubbleSettings bubbleSettings,
    MapSelectionSettings selectionSettings,
    MapZoomPanBehavior zoomPanBehavior,
    SfMapsThemeData themeData,
    MapController controller,
    BuildContext context,
    _MapsShapeLayerState state,
  })  : _mapDataSource = mapDataSource,
        _mapSource = mapSource,
        _selectedIndex = selectedIndex,
        _legend = legend,
        _bubbleSettings = bubbleSettings,
        _selectionSettings = selectionSettings,
        _zoomPanBehavior = zoomPanBehavior,
        _themeData = themeData,
        context = context,
        controller = controller,
        _state = state,
        super(textDirection: Directionality.of(state.context)) {
    _scaleGestureRecognizer = ScaleGestureRecognizer()
      ..onStart = _handleScaleStart
      ..onUpdate = _handleScaleUpdate
      ..onEnd = _handleScaleEnd;

    if (!_state.isSublayer) {
      _state.controller
        ..onZoomLevelChange = _handleZoomLevelChange
        ..onPanChange = _handlePanTo;
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
      _currentZoomLevel = _zoomPanBehavior.zoomLevel;
    }

    if (_selectedIndex != -1) {
      _currentSelectedItem = _state.shapeFileData.initialSelectedModel;
      _initializeSelectionTween();
    }

    if (_legend != null && _legend.enableToggleInteraction) {
      _initializeToggledShapeTweenColors();
    }

    if (hasShapeHoverColor) {
      _initializeHoverTweenColors();
    }

    _state.widget.controller?._parentBox = this;
  }

  final _MapsShapeLayerState _state;
  final int _minPanDistance = 5;
  Size _size;
  double _actualFactor = 1.0;
  Size _actualShapeSize;
  Offset _downGlobalPoint;
  Offset _downLocalPoint;
  int _pointerCount = 0;
  bool _singleTapConfirmed = false;
  bool _isZoomedUsingToolbar = false;
  MapModel _prevSelectedItem;
  MapModel _currentSelectedItem;
  MapModel _currentHoverItem;
  MapModel _previousHoverItem;
  MapModel _currentInteractedItem;
  MapLayerElement _currentInteractedElement;
  ScaleGestureRecognizer _scaleGestureRecognizer;
  Animation<double> _selectionColorAnimation;
  Animation<double> _toggleShapeAnimation;
  Timer _zoomingDelayTimer;
  Rect _referenceShapeBounds;
  Rect _referenceVisibleBounds;
  MapZoomDetails _zoomDetails;
  MapPanDetails _panDetails;
  bool _avoidPanUpdate = false;
  double _currentZoomLevel = 1.0;

  Animation<double> _hoverColorAnimation;
  ColorTween _forwardSelectionColorTween;
  ColorTween _forwardSelectionStrokeColorTween;
  ColorTween _reverseSelectionColorTween;
  ColorTween _reverseSelectionStrokeColorTween;
  ColorTween _forwardHoverColorTween;
  ColorTween _forwardHoverStrokeColorTween;
  ColorTween _reverseHoverColorTween;
  ColorTween _reverseHoverStrokeColorTween;
  ColorTween _forwardToggledShapeColorTween;
  ColorTween _forwardToggledShapeStrokeColorTween;
  ColorTween _reverseToggledShapeColorTween;
  ColorTween _reverseToggledShapeStrokeColorTween;

  Animation<double> _zoomLevelAnimation;
  Animation<double> _focalLatLngAnimation;
  MapLatLngTween _focalLatLngTween;
  Tween<double> _zoomLevelTween;

  BuildContext context;
  MapController controller;

  bool get canZoom =>
      _zoomPanBehavior != null &&
      (_zoomPanBehavior.enablePinching || _zoomPanBehavior.enablePanning);

  bool get isInteractive =>
      _state.widget.shapeTooltipBuilder != null ||
      _state.widget.bubbleTooltipBuilder != null ||
      _state.widget.onSelectionChanged != null ||
      (_state.isDesktop && (hasBubbleHoverColor || hasShapeHoverColor));

  bool get hasBubbleHoverColor =>
      _themeData.bubbleHoverColor != Colors.transparent ||
      (_themeData.bubbleHoverStrokeColor != Colors.transparent &&
          _themeData.bubbleHoverStrokeWidth > 0);

  bool get hasShapeHoverColor =>
      _themeData.shapeHoverColor != Colors.transparent ||
      (_themeData.shapeHoverStrokeColor != Colors.transparent &&
          _themeData.shapeHoverStrokeWidth > 0);

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

  MapShapeSource get mapSource => _mapSource;
  MapShapeSource _mapSource;
  set mapSource(MapShapeSource value) {
    if (_mapSource == value) {
      return;
    }

    if (_mapSource != null &&
        value != null &&
        _mapSource._mapProvider != value._mapProvider) {
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
    SchedulerBinding.instance.addPostFrameCallback(_initiateInitialAnimations);
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

  MapLayerLegend get legend => _legend;
  MapLayerLegend _legend;
  set legend(MapLayerLegend value) {
    // Update [MapsShapeLayer.legend] value only when
    // [MapsShapeLayer.legend] property is set to shape.
    if (_legend != null && _legend.source != MapElement.shape ||
        _legend == value) {
      return;
    }
    _legend = value;
    if (_legend.enableToggleInteraction) {
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

  MapZoomPanBehavior get zoomPanBehavior => _zoomPanBehavior;
  MapZoomPanBehavior _zoomPanBehavior;
  set zoomPanBehavior(MapZoomPanBehavior value) {
    if (_zoomPanBehavior == value) {
      return;
    }
    _zoomPanBehavior = value;
    if (_zoomPanBehavior != null) {
      if (_zoomLevelAnimation == null) {
        _initializeZoomPanAnimations();
      }
      _currentZoomLevel = _zoomPanBehavior.zoomLevel;
    }
  }

  int get selectedIndex => _selectedIndex;
  int _selectedIndex;
  set selectedIndex(int value) {
    if (_selectedIndex == value) {
      return;
    }

    assert(_selectedIndex != null);
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
    if (_legend != null && _legend.enableToggleInteraction) {
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
  MouseCursor get cursor => controller.gesture == Gesture.pan
      ? SystemMouseCursors.grabbing
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener get onHover => null;

  @override
  PointerExitEventListener get onExit => _handleExit;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  void _initializeZoomPanAnimations() {
    _zoomLevelAnimation = CurvedAnimation(
        parent: _state.zoomLevelAnimationController, curve: Curves.easeInOut);
    _focalLatLngAnimation = CurvedAnimation(
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
    _forwardSelectionColorTween.end = selectionColor;
    _forwardSelectionStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardSelectionStrokeColorTween.end = _themeData.selectionStrokeColor;

    _reverseSelectionColorTween.begin = selectionColor;
    _reverseSelectionStrokeColorTween.begin = _themeData.selectionStrokeColor;
    _reverseSelectionStrokeColorTween.end = _themeData.layerStrokeColor;
    _updateCurrentSelectedItemTween();
  }

  void _updateCurrentSelectedItemTween() {
    if (_currentSelectedItem != null &&
        (_state.isSublayer || !controller.wasToggled(_currentSelectedItem))) {
      _forwardSelectionColorTween.begin =
          getActualShapeColor(_currentSelectedItem);
    }

    if (_prevSelectedItem != null) {
      _reverseSelectionColorTween.end = getActualShapeColor(_prevSelectedItem);
    }
  }

  void _initializeHoverTweenColors() {
    final Color hoverStrokeColor = _getHoverStrokeColor();
    _forwardHoverStrokeColorTween.begin = _themeData.layerStrokeColor;
    _forwardHoverStrokeColorTween.end = hoverStrokeColor;
    _reverseHoverStrokeColorTween.begin = hoverStrokeColor;
    _reverseHoverStrokeColorTween.end = _themeData.layerStrokeColor;
  }

  Color _getHoverStrokeColor() {
    final bool canAdjustHoverOpacity =
        double.parse(_themeData.layerStrokeColor.opacity.toStringAsFixed(2)) !=
            hoverColorOpacity;
    return _themeData.shapeHoverStrokeColor != null &&
            _themeData.shapeHoverStrokeColor != Colors.transparent
        ? _themeData.shapeHoverStrokeColor
        : _themeData.layerStrokeColor.withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _refresh([MapLatLng latlng]) {
    if (hasSize && _mapDataSource != null && _mapDataSource.isNotEmpty) {
      if (_state.isSublayer) {
        // For tile layer's sublayer.
        if (controller.isTileLayerChild) {
          _size = controller.getTileSize();
          latlng = controller.visibleFocalLatLng;
        }
        // For shape layer's sublayer.
        else {
          _updateMapDataSourceForVisual();
          markNeedsPaint();
          return;
        }
      }
      _computeActualFactor();
      controller.shapeLayerSizeFactor = _actualFactor;
      if (_zoomPanBehavior != null) {
        controller.shapeLayerSizeFactor *= _zoomPanBehavior.zoomLevel;
        final double inflateWidth =
            _size.width * _zoomPanBehavior.zoomLevel / 2 - _size.width / 2;
        final double inflateHeight =
            _size.height * _zoomPanBehavior.zoomLevel / 2 - _size.height / 2;
        controller.shapeLayerOrigin = Offset(
            paintBounds.left - inflateWidth, paintBounds.top - inflateHeight);
      }

      controller.shapeLayerOffset =
          _getTranslationPoint(controller.shapeLayerSizeFactor);
      final Offset offsetBeforeAdjust = controller.shapeLayerOffset;
      _adjustLayerOffsetTo(latlng);
      if (!_state.isSublayer) {
        controller.shapeLayerOrigin +=
            controller.shapeLayerOffset - offsetBeforeAdjust;
        controller.updateVisibleBounds();
      }

      _updateMapDataSourceForVisual();
      markNeedsPaint();
    }
  }

  void _adjustLayerOffsetTo(MapLatLng latlng) {
    latlng ??= _zoomPanBehavior?.focalLatLng;
    if (latlng != null) {
      final Offset focalPoint = pixelFromLatLng(
        latlng.latitude,
        latlng.longitude,
        _size,
        controller.shapeLayerOffset,
        controller.shapeLayerSizeFactor,
      );
      final Offset center =
          _getShapeBounds(controller.shapeLayerSizeFactor).center;
      controller.shapeLayerOffset +=
          center + controller.shapeLayerOffset - focalPoint;
    }
  }

  void _computeActualFactor() {
    final Offset minPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude,
        _state.shapeFileData.bounds.minLongitude,
        _size);
    final Offset maxPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude,
        _state.shapeFileData.bounds.maxLongitude,
        _size);
    _actualShapeSize = Size(
        (maxPoint.dx - minPoint.dx).abs(), (maxPoint.dy - minPoint.dy).abs());
    _actualFactor = min(_size.height / _actualShapeSize.height,
        _size.width / _actualShapeSize.width);
  }

  Offset _getTranslationPoint(double factor, [Rect bounds]) {
    assert(factor != null);
    bounds ??= _getShapeBounds(factor);
    // 0.0 is default translation value.
    final double dx = interpolateValue(
        0.0, _size.width - _actualShapeSize.width, -bounds.left);
    final double dy = interpolateValue(
        0.0, _size.height - _actualShapeSize.height, -bounds.top);
    final Size widgetSize = _state.isSublayer ? size : _size;
    final Offset shift = Offset(
        widgetSize.width - _actualShapeSize.width * factor,
        widgetSize.height - _actualShapeSize.height * factor);
    return Offset(dx + shift.dx / 2, dy + shift.dy / 2);
  }

  Rect _getShapeBounds(double factor, [Offset translation = Offset.zero]) {
    final Offset minPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.minLatitude,
        _state.shapeFileData.bounds.minLongitude,
        _size,
        translation,
        factor);
    final Offset maxPoint = pixelFromLatLng(
        _state.shapeFileData.bounds.maxLatitude,
        _state.shapeFileData.bounds.maxLongitude,
        _size,
        translation,
        factor);
    return Rect.fromPoints(minPoint, maxPoint);
  }

  void _updateMapDataSourceForVisual() {
    if (_mapDataSource != null) {
      Offset point;
      Path shapePath;
      dynamic coordinate;
      List<Offset> pixelPoints;
      List<dynamic> rawPoints;
      int rawPointsLength, pointsLength;
      _mapDataSource.forEach((String key, MapModel mapModel) {
        double signedArea = 0.0, centerX = 0.0, centerY = 0.0;
        rawPointsLength = mapModel.rawPoints.length;
        mapModel.pixelPoints = List<List<Offset>>(rawPointsLength);
        shapePath = Path();
        for (int j = 0; j < rawPointsLength; j++) {
          rawPoints = mapModel.rawPoints[j];
          pointsLength = rawPoints.length;
          pixelPoints = mapModel.pixelPoints[j] = List<Offset>(pointsLength);
          for (int k = 0; k < pointsLength; k++) {
            coordinate = rawPoints[k];
            point = pixelPoints[k] = pixelFromLatLng(
                coordinate[1],
                coordinate[0],
                _size,
                controller.shapeLayerOffset,
                controller.shapeLayerSizeFactor);
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
      double minX, maxX;
      double distance,
          minDistance = double.infinity,
          maxDistance = double.negativeInfinity;

      final List<double> minDistances = <double>[double.infinity];
      final List<double> maxDistances = <double>[double.negativeInfinity];
      for (final List<Offset> points in mapModel.pixelPoints) {
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

      mapModel.shapeWidth = max(maxX, maxDistances.reduce(max)) -
          min(minX, minDistances.reduce(min));
    }
  }

  void _updateBubbleRadiusAndPath(MapModel mapModel) {
    final double bubbleSizeValue = mapModel.bubbleSizeValue;
    if (bubbleSizeValue != null) {
      if (bubbleSizeValue == _state.minBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.minRadius;
      } else if (bubbleSizeValue == _state.maxBubbleValue) {
        mapModel.bubbleRadius = _bubbleSettings.maxRadius;
      } else {
        final double percentage = ((bubbleSizeValue - _state.minBubbleValue) /
                (_state.maxBubbleValue - _state.minBubbleValue)) *
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
            center: mapModel.shapePathCenter,
            radius: mapModel.bubbleRadius,
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
    if (canZoom) {
      if (controller.gesture == Gesture.scale) {
        _zoomEnd();
      }

      controller.isInInteractive = true;
      controller.gesture = null;
      _downGlobalPoint = details.focalPoint;
      _downLocalPoint = details.localFocalPoint;
      _referenceVisibleBounds =
          controller.getVisibleBounds(controller.shapeLayerOffset);
      _referenceShapeBounds = _getShapeBounds(
          controller.shapeLayerSizeFactor, controller.shapeLayerOffset);
      _zoomDetails = MapZoomDetails(
        newVisibleBounds: controller.getVisibleLatLngBounds(
          _referenceVisibleBounds.topRight,
          _referenceVisibleBounds.bottomLeft,
        ),
      );
      _panDetails = MapPanDetails(
        newVisibleBounds: _zoomDetails.newVisibleBounds,
      );
    }
  }

  // Scale and pan are handled in scale gesture.
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    controller.isInInteractive = true;
    controller.gesture ??=
        _getGestureType(details.scale, details.localFocalPoint);
    if (!canZoom || controller.gesture == null) {
      return;
    }

    switch (controller.gesture) {
      case Gesture.scale:
        _singleTapConfirmed = false;
        if (_zoomPanBehavior.enablePinching &&
            controller.shapeLayerSizeFactor * details.scale >= _actualFactor) {
          _invokeOnZooming(details.scale, _downLocalPoint, _downGlobalPoint);
        }
        return;
      case Gesture.pan:
        _singleTapConfirmed = false;
        if (_zoomPanBehavior.enablePanning) {
          _invokeOnPanning(
              details.localFocalPoint, _downLocalPoint, details.focalPoint);
        }
        return;
    }
  }

  void _invokeOnZooming(double scale,
      [Offset localFocalPoint, Offset globalFocalPoint]) {
    final double newZoomLevel = _getZoomLevel(scale);
    final double newShapeLayerSizeFactor = _getScale(newZoomLevel);
    final Offset newShapeLayerOffset =
        controller.getZoomingTranslation(origin: localFocalPoint);
    final Rect newVisibleBounds = controller.getVisibleBounds(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    _zoomDetails = MapZoomDetails(
      localFocalPoint: localFocalPoint,
      globalFocalPoint: globalFocalPoint,
      previousZoomLevel: _zoomPanBehavior.zoomLevel,
      newZoomLevel: newZoomLevel,
      previousVisibleBounds: _zoomDetails != null
          ? _zoomDetails.newVisibleBounds
          : controller.visibleLatLngBounds,
      newVisibleBounds: controller.getVisibleLatLngBounds(
        newVisibleBounds.topRight,
        newVisibleBounds.bottomLeft,
        newShapeLayerOffset,
        newShapeLayerSizeFactor,
      ),
    );
    if (_state.widget.onWillZoom == null ||
        _state.widget.onWillZoom(_zoomDetails)) {
      _zoomPanBehavior?.onZooming(_zoomDetails);
    }
  }

  void _invokeOnPanning(
      Offset localFocalPoint, Offset previousFocalPoint, Offset focalPoint,
      [bool canAvoidPanUpdate = false]) {
    _avoidPanUpdate = canAvoidPanUpdate;
    final Offset delta =
        _getValidPanDelta(localFocalPoint - previousFocalPoint);
    final Rect visibleBounds = controller.getVisibleBounds(
        controller.shapeLayerOffset +
            (canAvoidPanUpdate ? Offset.zero : delta));
    _panDetails = MapPanDetails(
      globalFocalPoint: focalPoint,
      localFocalPoint: localFocalPoint,
      zoomLevel: _zoomPanBehavior.zoomLevel,
      delta: delta,
      previousVisibleBounds: _panDetails != null
          ? _panDetails.newVisibleBounds
          : controller.visibleLatLngBounds,
      newVisibleBounds: controller.getVisibleLatLngBounds(
          visibleBounds.topRight,
          visibleBounds.bottomLeft,
          controller.shapeLayerOffset +
              (canAvoidPanUpdate ? Offset.zero : delta)),
    );
    if (_state.widget.onWillPan == null ||
        _state.widget.onWillPan(_panDetails)) {
      _zoomPanBehavior?.onPanning(_panDetails);
    }
  }

  Offset _getValidPanDelta(Offset delta) {
    final Rect currentShapeBounds = _getShapeBounds(
        controller.shapeLayerSizeFactor, controller.shapeLayerOffset + delta);
    double dx = 0.0, dy = 0.0;
    if (_referenceVisibleBounds.width < _referenceShapeBounds.width) {
      dx = delta.dx;
      if (currentShapeBounds.left > _referenceVisibleBounds.left) {
        dx = _referenceVisibleBounds.left - _referenceShapeBounds.left;
      }

      if (currentShapeBounds.right < _referenceVisibleBounds.right) {
        dx = _referenceVisibleBounds.right - _referenceShapeBounds.right;
      }
    }

    if (_referenceVisibleBounds.height < _referenceShapeBounds.height) {
      dy = delta.dy;
      if (currentShapeBounds.top > _referenceVisibleBounds.top) {
        dy = _referenceVisibleBounds.top - _referenceShapeBounds.top;
      }

      if (currentShapeBounds.bottom < _referenceVisibleBounds.bottom) {
        dy = _referenceVisibleBounds.bottom - _referenceShapeBounds.bottom;
      }
    }

    return Offset(dx, dy);
  }

  Gesture _getGestureType(double scale, Offset point) {
    if (scale == 1) {
      if (_downLocalPoint != null) {
        final Offset distance = point - _downLocalPoint;
        return distance.dx.abs() > _minPanDistance ||
                distance.dy.abs() > _minPanDistance
            ? Gesture.pan
            : null;
      }
    }

    return Gesture.scale;
  }

  Offset _getNormalizedOffset(double zoomLevel) {
    double dx = 0.0, dy = 0.0;
    final Rect currentBounds = controller.currentBounds;
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

  void _validateEdges(double zoomLevel, [Offset origin]) {
    final Offset leftTop = controller.getZoomingTranslation(
        origin: origin,
        scale: _getScale(zoomLevel),
        previousOrigin: controller.shapeLayerOrigin);
    controller.currentBounds = Rect.fromLTWH(leftTop.dx, leftTop.dy,
        _size.width * zoomLevel, _size.height * zoomLevel);
    controller.normalize = _getNormalizedOffset(zoomLevel);
  }

  void _handleZooming(MapZoomDetails details) {
    if (_state.isSublayer) {
      markNeedsPaint();
      return;
    }

    if (controller.isInInteractive && details.localFocalPoint != null) {
      // Updating map while pinching and scrolling.
      controller.localScale = _getScale(details.newZoomLevel);
      controller.pinchCenter = details.localFocalPoint;
      controller.updateVisibleBounds(
          controller.getZoomingTranslation() + controller.normalize,
          controller.shapeLayerSizeFactor * controller.localScale);
      _validateEdges(details.newZoomLevel);
    } else {
      // Updating map via toolbar.
      _downLocalPoint = null;
      _downGlobalPoint = null;
      _isZoomedUsingToolbar = true;
    }
    _zoomPanBehavior.zoomLevel = details.newZoomLevel;
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
      controller.panDistance = details.delta;
      controller
          .updateVisibleBounds(controller.shapeLayerOffset + details.delta);
    }

    markNeedsPaint();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (controller.gesture == null) {
      controller.isInInteractive = false;
      return;
    }

    switch (controller.gesture) {
      case Gesture.scale:
        _zoomEnd();
        break;
      case Gesture.pan:
        _panEnd();
        break;
    }

    controller.gesture = null;
  }

  void _handleRefresh() {
    if (_state.isSublayer) {
      _refresh();
    }
  }

  void _zoomEnd() {
    controller.isInInteractive = false;
    controller.gesture = null;
    _zoomingDelayTimer?.cancel();
    _zoomingDelayTimer = null;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior != null &&
        _zoomPanBehavior.enablePinching &&
        !_state.isSublayer) {
      controller.shapeLayerOffset =
          controller.getZoomingTranslation() + controller.normalize;
      controller.shapeLayerOrigin = controller.getZoomingTranslation(
              previousOrigin: controller.shapeLayerOrigin) +
          controller.normalize;
      controller.shapeLayerSizeFactor *= controller.localScale;
      _updateMapDataSourceForVisual();
      controller.notifyRefreshListeners();
      markNeedsPaint();
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    controller.normalize = Offset.zero;
    controller.localScale = 1.0;
  }

  void _panEnd() {
    controller.isInInteractive = false;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior.enablePanning && !_state.isSublayer) {
      controller.shapeLayerOffset += controller.panDistance;
      controller.shapeLayerOrigin += controller.panDistance;
      _updateMapDataSourceForVisual();
      controller.notifyRefreshListeners();
      markNeedsPaint();
    }

    _downLocalPoint = null;
    _downGlobalPoint = null;
    controller.gesture = null;
    controller.panDistance = Offset.zero;
  }

  /// Handling zooming using mouse wheel scrolling.
  void _handleScrollEvent(PointerScrollEvent event) {
    if (_zoomPanBehavior != null && _zoomPanBehavior.enablePinching) {
      controller.isInInteractive = true;
      controller.gesture ??= Gesture.scale;
      if (controller.gesture != Gesture.scale) {
        return;
      }

      if (_currentHoverItem != null) {
        _previousHoverItem = _currentHoverItem;
        _currentHoverItem = null;
      }
      _downGlobalPoint ??= event.position;
      _downLocalPoint ??= event.localPosition;
      double scale = controller.localScale - (event.scrollDelta.dy / 60);
      if (controller.shapeLayerSizeFactor * scale < _actualFactor) {
        scale = _actualFactor / controller.shapeLayerSizeFactor;
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

  void _handleZoomLevelChange(double zoomLevel, {MapLatLng latlng}) {
    if (controller.isInInteractive &&
        !_state.zoomLevelAnimationController.isAnimating) {
      _currentZoomLevel = zoomLevel;
      markNeedsPaint();
    } else {
      _zoomLevelTween.begin = _currentZoomLevel;
      _zoomLevelTween.end = _zoomPanBehavior.zoomLevel;
      _downLocalPoint = pixelFromLatLng(
          controller.visibleFocalLatLng.latitude,
          controller.visibleFocalLatLng.longitude,
          size,
          controller.shapeLayerOffset,
          controller.shapeLayerSizeFactor);
      controller.isInInteractive = true;
      controller.gesture = Gesture.scale;
      controller.pinchCenter = _downLocalPoint;
      _state.zoomLevelAnimationController.forward(from: 0.0);
    }
  }

  void _handlePanTo(MapLatLng latlng) {
    if (!controller.isInInteractive) {
      _focalLatLngTween.begin = controller.visibleFocalLatLng;
      _focalLatLngTween.end = _zoomPanBehavior.focalLatLng;
      _state.focalLatLngAnimationController.forward(from: 0.0);
    }
  }

  void _handleReset() {
    _zoomPanBehavior.zoomLevel = _zoomPanBehavior.minZoomLevel;
  }

  void _handleZoomLevelAnimation() {
    if (_zoomLevelTween.end != null) {
      _currentZoomLevel = _zoomLevelTween.evaluate(_zoomLevelAnimation);
    }
    controller.localScale = _getScale(_currentZoomLevel);
    controller.updateVisibleBounds(
        controller.getZoomingTranslation() + controller.normalize,
        controller.shapeLayerSizeFactor * controller.localScale);
    _validateEdges(_currentZoomLevel);
    controller.notifyRefreshListeners();
    markNeedsPaint();
  }

  void _handleFocalLatLngAnimation() {
    if (_focalLatLngTween.end != null) {
      controller.visibleFocalLatLng =
          _focalLatLngTween.evaluate(_focalLatLngAnimation);
    }
    _handleZoomPanAnimation();
  }

  void _handleZoomPanAnimation() {
    _validateEdges(
        _currentZoomLevel, Offset(_size.width / 2, _size.height / 2));
    controller.shapeLayerOrigin = controller.getZoomingTranslation(
            origin: Offset(_size.width / 2, _size.height / 2),
            scale: _getScale(_currentZoomLevel),
            previousOrigin: controller.shapeLayerOrigin) +
        controller.normalize;
    controller.shapeLayerSizeFactor = _actualFactor * _currentZoomLevel;
    controller.shapeLayerOffset =
        _getTranslationPoint(controller.shapeLayerSizeFactor) +
            controller.normalize;
    if (_currentZoomLevel != 1) {
      _adjustLayerOffsetTo(controller.visibleFocalLatLng);
    }

    controller.updateVisibleBounds();
    _updateMapDataSourceForVisual();
    controller.notifyRefreshListeners();
    markNeedsPaint();
  }

  void _handleExit(PointerExitEvent event) {
    if (_state.widget.source.bubbleSizeMapper != null && hasBubbleHoverColor) {
      final ShapeLayerChildRenderBoxBase bubbleRenderObject =
          _state.bubbleKey.currentContext.findRenderObject();
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
    _invokeTooltip();
  }

  double _getZoomLevel(double scale) {
    return interpolateValue(
      controller.shapeLayerSizeFactor * scale / _actualFactor,
      _zoomPanBehavior.minZoomLevel,
      _zoomPanBehavior.maxZoomLevel,
    );
  }

  double _getScale(double zoomLevel) {
    return _actualFactor * zoomLevel / controller.shapeLayerSizeFactor;
  }

  void _handleTapUp(Offset localPosition) {
    _handleInteraction(localPosition);
    if (_currentSelectedItem != null) {
      _currentHoverItem = null;
    }
  }

  void _handleHover(PointerHoverEvent event) {
    final RenderBox renderBox = context.findRenderObject();
    final Offset localPosition = renderBox.globalToLocal(event.position);
    _handleInteraction(localPosition, isHover: true);
  }

  bool _isElementLiesOnPosition(Offset position) {
    if (!isInteractive && (_mapDataSource == null || _mapDataSource.isEmpty)) {
      return false;
    }

    double bubbleRadius;
    _currentInteractedItem = null;
    _currentInteractedElement = null;
    for (final MapModel mapModel in _mapDataSource.values) {
      final bool wasToggled = controller.wasToggled(mapModel);
      if (_isBubbleContains(position, mapModel)) {
        _currentInteractedElement = MapLayerElement.bubble;
        if (!wasToggled &&
            (bubbleRadius == null || mapModel.bubbleRadius < bubbleRadius)) {
          bubbleRadius = mapModel.bubbleRadius;
          _currentInteractedItem = mapModel;
        }
      } else if (_isShapeContains(
              position, mapModel, _currentInteractedElement) &&
          !(wasToggled && _state.widget.legend.source == MapElement.shape)) {
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

  void _handleInteraction(Offset position, {bool isHover = false}) {
    if (isHover) {
      _prevSelectedItem = null;
      _performChildHover(position);
    } else {
      _invokeSelectionChangedCallback(_currentInteractedItem);
      _performChildTap(position);
    }
  }

  bool _isBubbleContains(Offset position, MapModel mapModel) {
    return (_state.widget.bubbleTooltipBuilder != null ||
            hasBubbleHoverColor) &&
        mapModel.bubblePath != null &&
        mapModel.bubblePath.contains(position);
  }

  bool _isShapeContains(
      Offset position, MapModel mapModel, MapLayerElement element) {
    return (_state.widget.onSelectionChanged != null ||
            _state.widget.shapeTooltipBuilder != null ||
            hasShapeHoverColor) &&
        element != MapLayerElement.bubble &&
        mapModel.shapePath.contains(position);
  }

  void _invokeSelectionChangedCallback(MapModel mapModel) {
    if (_state.widget.onSelectionChanged != null &&
        mapModel != null &&
        mapModel.dataIndex != null) {
      _state.widget.onSelectionChanged(mapModel.dataIndex);
    }
  }

  void _performChildTap(Offset position) {
    if (_currentInteractedItem != null) {
      _invokeTooltip(
          position: position,
          model: _currentInteractedItem,
          element: _currentInteractedElement);
    }
  }

  void _performChildHover(Offset position) {
    _invokeTooltip(
        position: position,
        model: _currentInteractedItem,
        element: _currentInteractedElement);
    if (_state.widget.source.bubbleSizeMapper != null) {
      final ShapeLayerChildRenderBoxBase bubbleRenderObject =
          _state.bubbleKey.currentContext.findRenderObject();
      bubbleRenderObject.onHover(
          _currentInteractedItem, _currentInteractedElement);
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

  void _invokeTooltip(
      {MapModel model, Offset position, MapLayerElement element}) {
    if ((_state.widget.shapeTooltipBuilder != null ||
        _state.widget.bubbleTooltipBuilder != null)) {
      Rect elementRect;
      final ShapeLayerChildRenderBoxBase tooltipRenderObject =
          controller.tooltipKey.currentContext.findRenderObject();
      if (model != null && element == MapLayerElement.bubble) {
        elementRect = Rect.fromCircle(
            center: model.shapePathCenter, radius: model.bubbleRadius);
      }
      int sublayerIndex;
      if (_state.isSublayer) {
        final RenderSublayerContainer sublayerContainer = parent;
        sublayerIndex =
            sublayerContainer.getSublayerIndex(_state.widget.sublayer);
      }

      // The elementRect is not applicable, if the actual element is shape. The
      // sublayerIndex is not applicable, if the actual layer is shape layer.
      tooltipRenderObject.paintTooltip(
          model?.dataIndex, elementRect, element, sublayerIndex, position);
    }
  }

  void _updateHoverItemTween() {
    if (_currentHoverItem != null) {
      _forwardHoverColorTween.begin = getActualShapeColor(_currentHoverItem);
      _forwardHoverColorTween.end = _getHoverFillColor(_currentHoverItem);
    }

    if (_previousHoverItem != null) {
      _reverseHoverColorTween.begin = _getHoverFillColor(_previousHoverItem);
      _reverseHoverColorTween.end = getActualShapeColor(_previousHoverItem);
    }

    _state.hoverShapeAnimationController.forward(from: 0);
  }

  Color _getHoverFillColor(MapModel model) {
    final bool canAdjustHoverOpacity =
        double.parse(getActualShapeColor(model).opacity.toStringAsFixed(2)) !=
            hoverColorOpacity;
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor
        : getActualShapeColor(model).withOpacity(
            canAdjustHoverOpacity ? hoverColorOpacity : minHoverOpacity);
  }

  void _handleShapeLayerSelection() {
    assert(_selectedIndex < _mapSource.dataCount);
    _prevSelectedItem = _currentSelectedItem;
    if (_selectedIndex == -1) {
      if (_prevSelectedItem != null) {
        _prevSelectedItem.isSelected = false;
      }

      _currentSelectedItem = null;
    } else {
      _currentSelectedItem = _mapDataSource.values.firstWhere(
          (MapModel element) => element.dataIndex == _selectedIndex);
      _currentSelectedItem.isSelected = !_currentSelectedItem.isSelected;
      if (_prevSelectedItem != null) {
        _prevSelectedItem.isSelected = false;
      }
    }

    _updateCurrentSelectedItemTween();
    _state.selectionAnimationController.forward(from: 0);
  }

  void _initializeToggledShapeTweenColors() {
    final Color toggledShapeColor = _themeData.toggledItemColor !=
            Colors.transparent
        ? _themeData.toggledItemColor.withOpacity(_legend.toggledItemOpacity)
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

  void _handleToggleChange() {
    _previousHoverItem = null;
    if (_state.widget.legend != null &&
        _state.widget.legend.source == MapElement.shape) {
      MapModel model;
      if (_state.widget.source.shapeColorMappers == null) {
        model =
            mapDataSource.values.elementAt(controller.currentToggledItemIndex);
      } else {
        for (final mapModel in _mapDataSource.values) {
          if (mapModel.dataIndex != null &&
              mapModel.legendMapperIndex ==
                  controller.currentToggledItemIndex) {
            model = mapModel;
            break;
          }
        }
      }

      final Color shapeColor = (_currentSelectedItem != null &&
              _currentSelectedItem.actualIndex == model.actualIndex)
          ? _themeData.selectionColor
          : getActualShapeColor(model);
      _forwardToggledShapeColorTween.begin = shapeColor;
      _reverseToggledShapeColorTween.end = shapeColor;
      _state.toggleAnimationController.forward(from: 0);
    }
  }

  void _handleZoomLevelAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _zoomLevelTween.end != null) {
      _zoomEnd();
      if (!_isZoomedUsingToolbar) {
        _invokeOnZooming(_getScale(_zoomPanBehavior.zoomLevel));
      }
      _isZoomedUsingToolbar = false;
    }
  }

  void _handleFocalLatLngAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed && _focalLatLngTween.end != null) {
      _referenceVisibleBounds =
          controller.getVisibleBounds(controller.shapeLayerOffset);
      _referenceShapeBounds = _getShapeBounds(
          controller.shapeLayerSizeFactor, controller.shapeLayerOffset);
      final Offset localFocalPoint = pixelFromLatLng(
          _focalLatLngTween.end.latitude,
          _focalLatLngTween.end.longitude,
          size,
          controller.shapeLayerOffset,
          controller.shapeLayerSizeFactor);
      final Offset previousFocalPoint = pixelFromLatLng(
          _focalLatLngTween.begin.latitude,
          _focalLatLngTween.begin.longitude,
          size,
          controller.shapeLayerOffset,
          controller.shapeLayerSizeFactor);
      _invokeOnPanning(localFocalPoint, previousFocalPoint,
          localToGlobal(localFocalPoint), true);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _state.selectionAnimationController?.addListener(markNeedsPaint);
    _state.toggleAnimationController?.addListener(markNeedsPaint);
    _state.hoverShapeAnimationController?.addListener(markNeedsPaint);
    if (_state.isSublayer && controller == null) {
      final RenderSublayerContainer sublayerContainer = parent;
      controller = sublayerContainer.controller;
    }

    if (controller != null) {
      controller
        ..addZoomingListener(_handleZooming)
        ..addPanningListener(_handlePanning)
        ..addResetListener(_handleReset);
      if (_state.isSublayer) {
        controller.addRefreshListener(_handleRefresh);
      } else {
        controller.addToggleListener(_handleToggleChange);
        if (_state.zoomLevelAnimationController != null) {
          _state.zoomLevelAnimationController
            ..addListener(_handleZoomLevelAnimation)
            ..addStatusListener(_handleZoomLevelAnimationStatusChange);
        }

        if (_state.focalLatLngAnimationController != null) {
          _state.focalLatLngAnimationController
            ..addListener(_handleFocalLatLngAnimation)
            ..addStatusListener(_handleFocalLatLngAnimationStatusChange);
        }
      }
    }
    SchedulerBinding.instance.addPostFrameCallback(_initiateInitialAnimations);
  }

  @override
  void detach() {
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    _state.selectionAnimationController?.removeListener(markNeedsPaint);
    _state.toggleAnimationController?.removeListener(markNeedsPaint);
    _state.hoverShapeAnimationController?.removeListener(markNeedsPaint);
    if (controller != null) {
      controller
        ..removeZoomingListener(_handleZooming)
        ..removePanningListener(_handlePanning)
        ..removeResetListener(_handleReset);
      if (_state.isSublayer) {
        controller.removeRefreshListener(_handleRefresh);
      } else {
        controller.removeToggleListener(_handleToggleChange);
        if (_state.zoomLevelAnimationController != null) {
          _state.zoomLevelAnimationController
            ..removeListener(_handleZoomLevelAnimation)
            ..removeStatusListener(_handleZoomLevelAnimationStatusChange);
        }

        if (_state.focalLatLngAnimationController != null) {
          _state.focalLatLngAnimationController
            ..removeListener(_handleFocalLatLngAnimation)
            ..removeStatusListener(_handleFocalLatLngAnimationStatusChange);
        }
      }
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
    if ((isInteractive || canZoom) && event.down && event is PointerDownEvent) {
      _pointerCount++;
      if (canZoom) {
        _scaleGestureRecognizer.addPointer(event);
      }
      _singleTapConfirmed = _pointerCount == 1;
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      if (_singleTapConfirmed) {
        _handleTapUp(event.localPosition);
        _downLocalPoint = null;
        _downGlobalPoint = null;
      }

      _pointerCount = 0;
    } else if (event is PointerScrollEvent) {
      _handleScrollEvent(event);
    } else if (_state.isDesktop && event is PointerHoverEvent) {
      // PointerHoverEvent is applicable only for web platform.
      _handleHover(event);
    } else if (event is PointerMoveEvent && event.delta != Offset.zero) {
      // In sublayer, we haven't handled the scale gestures. If we start panning
      // on a sublayer shape, it takes the tap down and when tap up, it will
      // perform tapping related event. So to avoid that, we had updated
      // _singleTapConfirmed as false.
      _singleTapConfirmed = false;
    }
  }

  @override
  void performLayout() {
    _size = getBoxSize(constraints);
    controller.shapeLayerBoxSize = _size;
    if (!hasSize || size != _size) {
      size = _size;
      _refresh(controller.visibleFocalLatLng);
    }

    final BoxConstraints looseConstraints = BoxConstraints.loose(size);
    RenderBox child = firstChild;
    while (child != null) {
      final StackParentData childParentData = child.parentData;
      child.layout(looseConstraints);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_mapDataSource != null && _mapDataSource.isNotEmpty) {
      context.canvas
        ..save()
        ..clipRect(offset & controller.shapeLayerBoxSize);
      controller.applyTransform(context, offset);
      final bool hasToggledIndices = controller.toggledIndices.isNotEmpty;
      final Paint fillPaint = Paint()..isAntiAlias = true;
      final Paint strokePaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;
      final bool hasPrevSelectedItem = _prevSelectedItem != null &&
          !controller.wasToggled(_prevSelectedItem);

      final bool hasCurrentSelectedItem = _currentSelectedItem != null &&
          !controller.wasToggled(_currentSelectedItem);

      _mapDataSource.forEach((String key, MapModel model) {
        if (_currentHoverItem != null &&
            _currentHoverItem.primaryKey == model.primaryKey) {
          return;
        }

        if (hasCurrentSelectedItem && selectedIndex == model.dataIndex) {
          return;
        }

        if (hasPrevSelectedItem && _prevSelectedItem.primaryKey == key) {
          fillPaint.color =
              _reverseSelectionColorTween.evaluate(_selectionColorAnimation);
          strokePaint
            ..color = _reverseSelectionStrokeColorTween
                .evaluate(_selectionColorAnimation)
            ..strokeWidth = _themeData.selectionStrokeWidth;
        } else if (_previousHoverItem != null &&
            _previousHoverItem.primaryKey == key &&
            !controller.wasToggled(_previousHoverItem) &&
            _previousHoverItem != _currentHoverItem) {
          fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
              ? _reverseHoverColorTween.evaluate(_hoverColorAnimation)
              : getActualShapeColor(model);

          if (_themeData.shapeHoverStrokeWidth > 0.0 &&
              _themeData.shapeHoverStrokeColor != Colors.transparent) {
            strokePaint
              ..color =
                  _reverseHoverStrokeColorTween.evaluate(_hoverColorAnimation)
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

        context.canvas.drawPath(model.shapePath, fillPaint);
        if (strokePaint.strokeWidth > 0.0 &&
            strokePaint.color != Colors.transparent) {
          strokePaint.strokeWidth =
              _getIntrinsicStrokeWidth(strokePaint.strokeWidth);
          context.canvas.drawPath(model.shapePath, strokePaint);
        }
      });

      _drawHoverShape(context, fillPaint, strokePaint);
      _drawSelectedShape(context, fillPaint, strokePaint);
      context.canvas.restore();
      super.paint(context, offset);
    }
  }

  // Returns the color to the shape based on the [shapeColorMappers] and
  // [layerColor] properties.
  Color getActualShapeColor(MapModel model) {
    return model.shapeColor ?? _themeData.layerColor;
  }

  double _getIntrinsicStrokeWidth(double strokeWidth) {
    return strokeWidth /=
        controller.gesture == Gesture.scale ? controller.localScale : 1;
  }

  // Set the color to the toggled and un-toggled shapes based on
  // the [legendController.toggledIndices] collection.
  void _updateFillColor(
      MapModel model, Paint fillPaint, bool hasToggledIndices) {
    fillPaint.style = PaintingStyle.fill;
    if (_state.widget.legend != null &&
        _state.widget.legend.source == MapElement.shape) {
      if (controller.currentToggledItemIndex == model.legendMapperIndex) {
        final Color shapeColor = controller.wasToggled(model)
            ? _forwardToggledShapeColorTween.evaluate(_toggleShapeAnimation)
            : _reverseToggledShapeColorTween.evaluate(_toggleShapeAnimation);
        // Set tween color to the shape based on the currently tapped
        // legend item. If the legend item is toggled, then the
        // [_forwardToggledShapeColorTween] return. If the legend item is
        // un-toggled, then the [_reverseToggledShapeColorTween] return.
        fillPaint.color = shapeColor ?? Colors.transparent;
        return;
      } else if (hasToggledIndices && controller.wasToggled(model)) {
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
        _state.widget.legend.source == MapElement.shape) {
      if (controller.currentToggledItemIndex == model.legendMapperIndex) {
        final Color shapeStrokeColor = controller.wasToggled(model)
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
          ..strokeWidth = controller.wasToggled(model)
              ? _legend.toggledItemStrokeWidth
              : _themeData.layerStrokeWidth;
        return;
      } else if (hasToggledIndices && controller.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled shapes.
        strokePaint
          ..color =
              _forwardToggledShapeStrokeColorTween.end ?? Colors.transparent
          ..strokeWidth = _legend.toggledItemStrokeWidth;
        return;
      }
    }

    strokePaint
      ..color = _themeData.layerStrokeColor
      ..strokeWidth = _themeData.layerStrokeWidth;
  }

  void _drawSelectedShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentSelectedItem != null &&
        !controller.wasToggled(_currentSelectedItem)) {
      fillPaint.color =
          _forwardSelectionColorTween.evaluate(_selectionColorAnimation);
      context.canvas.drawPath(_currentSelectedItem.shapePath, fillPaint);
      if (_themeData.selectionStrokeWidth > 0.0) {
        strokePaint
          ..color = _forwardSelectionStrokeColorTween
              .evaluate(_selectionColorAnimation)
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.selectionStrokeWidth);
        context.canvas.drawPath(_currentSelectedItem.shapePath, strokePaint);
      }
    }
  }

  void _drawHoverShape(
      PaintingContext context, Paint fillPaint, Paint strokePaint) {
    if (_currentHoverItem != null) {
      fillPaint.color = _themeData.shapeHoverColor != Colors.transparent
          ? _forwardHoverColorTween.evaluate(_hoverColorAnimation)
          : getActualShapeColor(_currentHoverItem);
      context.canvas.drawPath(_currentHoverItem.shapePath, fillPaint);
      if (_themeData.shapeHoverStrokeWidth > 0.0 &&
          _themeData.shapeHoverStrokeColor != Colors.transparent) {
        strokePaint
          ..color = _forwardHoverStrokeColorTween.evaluate(_hoverColorAnimation)
          ..strokeWidth =
              _getIntrinsicStrokeWidth(_themeData.shapeHoverStrokeWidth);
      } else {
        strokePaint
          ..color = _themeData.layerStrokeColor
          ..strokeWidth = _getIntrinsicStrokeWidth(_themeData.layerStrokeWidth);
      }

      if (strokePaint.strokeWidth > 0.0 &&
          strokePaint.color != Colors.transparent) {
        context.canvas.drawPath(_currentHoverItem.shapePath, strokePaint);
      }
    }
  }
}

/// Converts json file to future string based on
/// assert, network, memory and file.
abstract class MapProvider {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const MapProvider();

  /// Returns the json file as future string value.
  Future<String> loadString();

  /// Returns shape path which is given.
  String get shapePath;

  /// Returns shape bytes which is given.
  Uint8List get bytes;
}

/// Decodes the given json file as a map.
///
/// This class behaves like similar to [Image.asset].
///
/// See also:
///
/// [MapShapeSource.asset] for the [SfMaps] widget shorthand,
/// backed up by [AssetMapProvider].
class AssetMapProvider extends MapProvider {
  /// Creates an object that decodes a [String] buffer as a map.
  AssetMapProvider(String assetName)
      : assert(assetName != null),
        assert(assetName.isNotEmpty) {
    _shapePath = assetName;
  }

  String _shapePath;

  @override
  Future<String> loadString() async {
    return await rootBundle.loadString(_shapePath);
  }

  @override
  String get shapePath => _shapePath;

  @override
  Uint8List get bytes => null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AssetMapProvider && other.shapePath == shapePath;
  }

  @override
  int get hashCode => hashValues(shapePath, bytes);
}

// Decodes the given map URL from the network.
///
/// The map will be fetched and saved in local temporary directory for map
/// manipulation.
///
/// This class behaves like similar to [Image.network].
///
/// See also:
///
/// [MapShapeSource.network] for the [SfMaps] widget shorthand,
/// backed up by [NetworkMapProvider].
class NetworkMapProvider extends MapProvider {
  /// Creates an object that decodes the map at the given URL.
  NetworkMapProvider(String url)
      : assert(url != null),
        assert(url.isNotEmpty) {
    _url = url;
  }

  String _url;

  @override
  Future<String> loadString() async {
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load json');
    }
  }

  @override
  String get shapePath => _url;

  @override
  Uint8List get bytes => null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is NetworkMapProvider && other.shapePath == shapePath;
  }

  @override
  int get hashCode => hashValues(shapePath, bytes);
}

/// Decodes the given [Uint8List] buffer as an map.
///
/// The provided [bytes] buffer should not be changed after it is provided
/// to a [MemoryMapProvider].
///
/// This class behaves like similar to [Image.memory].
///
/// See also:
///
/// [MapShapeSource.memory] for the [SfMaps] widget shorthand,
/// backed up by [MemoryMapProvider].
class MemoryMapProvider extends MapProvider {
  /// Creates an object that decodes a [Uint8List] buffer as a map.
  MemoryMapProvider(Uint8List bytes) : assert(bytes != null) {
    _mapBytes = bytes;
  }

  Uint8List _mapBytes;

  @override
  Future<String> loadString() async {
    return utf8.decode(_mapBytes);
  }

  @override
  String get shapePath => null;

  @override
  Uint8List get bytes => _mapBytes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MemoryMapProvider && other.bytes == bytes;
  }

  @override
  int get hashCode => hashValues(shapePath, bytes);
}
