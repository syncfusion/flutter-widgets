import 'dart:async';
import 'dart:convert';
import 'dart:math';
// ignore: unnecessary_import
import 'dart:typed_data' show Uint8List;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../maps.dart';

import '../common.dart';
import '../controller/map_controller.dart';
import '../controller/map_provider.dart';
import '../elements/bubble.dart';
import '../elements/data_label.dart';
import '../elements/legend.dart';
import '../elements/marker.dart';
import '../elements/toolbar.dart';
import '../elements/tooltip.dart';
import '../layer/vector_layers.dart';
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
/// late MapShapeSource _mapSource;
/// late List<Model> _data;
///
/// @override
/// void initState() {
///   _data = <Model>[
///    Model('India', 280, "Low"),
///    Model('United States of America', 190, "High"),
///    Model('Pakistan', 37, "Low"),
///   ];
///
///   _mapSource = MapShapeSource.asset(
///     'assets/world_map.json',
///     shapeDataField: 'name',
///     dataCount: _data.length,
///     primaryValueMapper: (int index) {
///       return _data[index].country;
///     },
///     dataLabelMapper: (int index) {
///       return _data[index].country;
///     },
///   );
///
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return
///     SfMaps(
///       layers: [
///         MapShapeLayer(
///           source: _mapSource,
///           showDataLabels: true,
///        )
///     ],
///   );
/// }
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
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.asset(
  ///     'assets/Ireland.json',
  ///     shapeDataField: 'name',
  ///   );
  ///
  ///  super.initState();
  /// }
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
  })  : _path = name,
        _type = GeoJSONSourceType.asset,
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
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.network(
  ///     'http://www.json-generator.com/api/json/get/bVqXoJvfjC?indent=2',
  ///   );
  ///
  ///   super.initState();
  /// }
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
  })  : _path = src,
        _type = GeoJSONSourceType.network,
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
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _mapSource = MapShapeSource.memory(
  ///     bytes,
  ///     shapeDataField: 'name'
  ///   );
  /// }
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
  })  : _path = bytes,
        _type = GeoJSONSourceType.memory,
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     shapeColorValueMapper: (int index) {
  ///        return _data[index].storage;
  ///     },
  ///     shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///     ],
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 100, "Low"),
  ///    Model('United States of America', 200, "High"),
  ///    Model('Pakistan', 75, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     shapeColorValueMapper: (int index) {
  ///        return _data[index].count;
  ///     },
  ///     shapeColorMappers: [
  ///        MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///        MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///     ]
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [MapShapeLayer(source: _mapSource)],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     bubbleColorValueMapper: (int index) {
  ///       return _data[index].count;
  ///     },
  ///     bubbleSizeMapper: (int index) {
  ///       return _data[index].count;
  ///     },
  ///     bubbleColorMappers: [
  ///       MapColorMapper(from: 0, to: 100, color: Colors.red),
  ///       MapColorMapper(from: 101, to: 300, color: Colors.yellow)
  ///     ]
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     bubbleColorValueMapper: (int index) {
  ///       return _data[index].storage;
  ///     },
  ///     bubbleSizeMapper: (int index) {
  ///       return _data[index].count;
  ///     },
  ///    bubbleColorMappers: [
  ///      MapColorMapper(value: "Low", color: Colors.red),
  ///      MapColorMapper(value: "High", color: Colors.yellow)
  ///    ]
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     dataLabelMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         showDataLabels: true,
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low"),
  ///    Model('United States of America', 190, "High"),
  ///    Model('Pakistan', 37, "Low"),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     bubbleSizeMapper: (int index) {
  ///       return _data[index].usersCount;
  ///     }
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///           source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low", Colors.red),
  ///    Model('United States of America', 190, "High", Colors.green),
  ///    Model('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     shapeColorValueMapper: (int index) {
  ///       return _data[index].color;
  ///     }
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
  ///   );
  /// }
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
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
  ///
  /// @override
  /// void initState() {
  ///   _data = <Model>[
  ///    Model('India', 280, "Low", Colors.red),
  ///    Model('United States of America', 190, "High", Colors.green),
  ///    Model('Pakistan', 37, "Low", Colors.yellow),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "name",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     },
  ///     bubbleColorValueMapper: (int index) {
  ///       return _data[index].color;
  ///     },
  ///     bubbleSizeMapper: (int index) {
  ///       return _data[index].usersCount;
  ///     }
  ///   );
  ///
  ///   super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///   return SfMaps(
  ///     layers: [
  ///       MapShapeLayer(
  ///         source: _mapSource,
  ///       )
  ///     ],
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
  final IndexedColorValueMapper? bubbleColorValueMapper;

  /// Specifies the GeoJSON data source file.
  final Object _path;

  /// Specifies the type of the source.
  final GeoJSONSourceType _type;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final MapProvider provider = getSourceProvider(_path, _type);
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

class _ShapeBounds {
  _ShapeBounds({
    this.minLongitude,
    this.minLatitude,
    this.maxLongitude,
    this.maxLatitude,
  });

  num? minLongitude;
  num? minLatitude;
  num? maxLongitude;
  num? maxLatitude;

  _ShapeBounds get empty => _ShapeBounds();
}

class _ShapeFileData {
  Map<String, dynamic>? decodedJsonData;
  late Map<String, MapModel> mapDataSource;
  late _ShapeBounds bounds;
  MapModel? initialSelectedModel;

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
    bool isSublayer) async {
  if (shapeFileData.mapDataSource.isNotEmpty) {
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
  // ignore: avoid_as
  return data['ShapeFileData'] as _ShapeFileData;
}

void _readJsonFile(Map<String, dynamic> data) {
  List<dynamic> polygonGeometryData;
  int multipolygonGeometryLength;
  late Map<String, dynamic> geometry;
  Map<String, dynamic>? properties;

  // ignore: avoid_as
  final _ShapeFileData shapeFileData = data['ShapeFileData'] as _ShapeFileData;
  // ignore: avoid_as
  final String? shapeDataField = data['ShapeDataField'] as String?;
  // ignore: avoid_as
  final bool isSublayer = data['IsSublayer'] as bool;
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
      // ignore: avoid_as
      : shapeFileData.decodedJsonData![key].length as int;
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
      // ignore: avoid_as
      geometry = features['geometry'] as Map<String, dynamic>;
      // ignore: avoid_as
      properties = features['properties'] as Map<String, dynamic>;
    } else if (hasGeometries) {
      // ignore: avoid_as
      geometry = shapeFileData.decodedJsonData![key][i] as Map<String, dynamic>;
    }

    if (geometry['type'] == 'Polygon') {
      // ignore: avoid_as
      polygonGeometryData = geometry['coordinates'][0] as List<dynamic>;
      _updateMapDataSource(shapeFileData, shapeDataField, properties,
          polygonGeometryData, isSublayer);
    } else {
      // ignore: avoid_as
      multipolygonGeometryLength = geometry['coordinates'].length as int;
      for (int j = 0; j < multipolygonGeometryLength; j++) {
        // ignore: avoid_as
        polygonGeometryData = geometry['coordinates'][j][0] as List<dynamic>;
        _updateMapDataSource(shapeFileData, shapeDataField, properties,
            polygonGeometryData, isSublayer);
      }
    }
  }
}

void _updateMapDataSource(_ShapeFileData shapeFileData, String? shapeDataField,
    Map<String, dynamic>? properties, List<dynamic> points, bool isSublayer) {
  final String dataPath =
      // ignore: avoid_as
      (properties != null ? (properties[shapeDataField] ?? '') : '') as String;
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
    // ignore: avoid_as
    data = coordinates[i] as List<dynamic>;
    // ignore: avoid_as
    longitude = data[0] as num;
    // ignore: avoid_as
    latitude = data[1] as num;
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

// ignore_for_file: public_member_api_docs
class GeoJSONLayer extends StatefulWidget {
  const GeoJSONLayer({
    required this.source,
    required this.controller,
    this.initialLatLngBounds,
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
  final MapLatLngBounds? initialLatLngBounds;
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
  State<GeoJSONLayer> createState() => _GeoJSONLayerState();
}

class _GeoJSONLayerState extends State<GeoJSONLayer>
    with TickerProviderStateMixin {
  late GlobalKey bubbleKey;
  late MapLayerInheritedWidget ancestor;
  // Converts the given source file to future string based on source type.
  late MapProvider _provider;
  late Future<_ShapeFileData> _computeDataSource;
  late _ShapeFileData shapeFileData;

  late AnimationController toggleAnimationController;
  late AnimationController _hoverBubbleAnimationController;
  late AnimationController bubbleAnimationController;
  late AnimationController dataLabelAnimationController;
  late AnimationController hoverShapeAnimationController;
  late AnimationController selectionAnimationController;
  late AnimationController zoomLevelAnimationController;
  late AnimationController focalLatLngAnimationController;
  late PointerController _pointerController;

  List<Widget>? _markers;

  double? minBubbleValue;
  double? maxBubbleValue;

  bool _shouldUpdateMapDataSource = true;
  bool _hasSublayer = false;
  bool isSublayer = false;

  MapController? _controller;

  Widget _buildGeoJSONLayer(SfMapsThemeData themeData, bool isDesktop) {
    Widget current = ClipRect(
      child: Stack(
        children: <Widget>[
          _GeoJSONLayerRenderObjectWidget(
            controller: _controller!,
            initialLatLngBounds: widget.initialLatLngBounds,
            mapDataSource: shapeFileData.mapDataSource,
            mapSource: widget.source,
            selectedIndex: widget.selectedIndex,
            legend: widget.legend,
            selectionSettings: widget.selectionSettings,
            zoomPanBehavior: widget.zoomPanBehavior,
            bubbleSettings: widget.bubbleSettings.copyWith(
                color: themeData.bubbleColor,
                strokeColor: themeData.bubbleStrokeColor,
                strokeWidth: themeData.bubbleStrokeWidth),
            themeData: themeData,
            isDesktop: isDesktop,
            state: this,
            children: <Widget>[
              if (_hasSublayer)
                SublayerContainer(
                    ancestor: ancestor, children: widget.sublayers!),
              if (_markers != null && _markers!.isNotEmpty)
                MarkerContainer(
                    controller: _controller!,
                    markerTooltipBuilder: widget.markerTooltipBuilder,
                    sublayer: widget.sublayerAncestor,
                    ancestor: ancestor,
                    children: _markers)
            ],
          ),
          if (widget.source.bubbleSizeMapper != null)
            MapBubble(
              key: bubbleKey,
              controller: _controller,
              source: widget.source,
              mapDataSource: shapeFileData.mapDataSource,
              bubbleSettings: widget.bubbleSettings.copyWith(
                  color: themeData.bubbleColor,
                  strokeColor: themeData.bubbleStrokeColor,
                  strokeWidth: themeData.bubbleStrokeWidth),
              legend: widget.legend,
              showDataLabels: widget.showDataLabels,
              themeData: themeData,
              bubbleAnimationController: bubbleAnimationController,
              dataLabelAnimationController: dataLabelAnimationController,
              toggleAnimationController: toggleAnimationController,
              hoverBubbleAnimationController: _hoverBubbleAnimationController,
            ),
          if (widget.showDataLabels)
            MapDataLabel(
              controller: _controller,
              source: widget.source,
              mapDataSource: shapeFileData.mapDataSource,
              settings: widget.dataLabelSettings,
              effectiveTextStyle: Theme.of(context).textTheme.bodySmall!.merge(
                  widget.dataLabelSettings.textStyle ??
                      themeData.dataLabelTextStyle),
              themeData: themeData,
              dataLabelAnimationController: dataLabelAnimationController,
            ),
          if (widget.zoomPanBehavior != null)
            BehaviorViewRenderObjectWidget(
              controller: _controller!,
              zoomPanBehavior: widget.zoomPanBehavior!,
            ),
          if (widget.zoomPanBehavior != null &&
              widget.zoomPanBehavior!.showToolbar &&
              isDesktop)
            MapToolbar(
                controller: _controller,
                zoomPanBehavior: widget.zoomPanBehavior!),
          if (_hasTooltipBuilder())
            MapTooltip(
              key: _controller!.tooltipKey,
              controller: _controller,
              mapSource: widget.source,
              sublayers: widget.sublayers,
              tooltipSettings: widget.tooltipSettings,
              shapeTooltipBuilder: widget.shapeTooltipBuilder,
              bubbleTooltipBuilder: widget.bubbleTooltipBuilder,
              markerTooltipBuilder: widget.markerTooltipBuilder,
              themeData: themeData,
            ),
        ],
      ),
    );

    if (widget.legend != null) {
      current = Legend(
        colorMappers: _getLegendSource(),
        dataSource: shapeFileData.mapDataSource,
        legend: widget.legend!,
        pointerController: _pointerController,
        controller: _controller,
        themeData: themeData,
        child: current,
      );
    }

    return current;
  }

  List<MapColorMapper>? _getLegendSource() {
    switch (widget.legend!.source) {
      case MapElement.bubble:
        return widget.source.bubbleColorMappers;
      case MapElement.shape:
        return widget.source.shapeColorMappers;
    }
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

  SfMapsThemeData _updateThemeData(BuildContext context, ThemeData themeData,
      SfMapsThemeData mapsThemeData) {
    final bool isLightTheme = mapsThemeData.brightness == Brightness.light;
    return mapsThemeData.copyWith(
      layerColor: widget.color ??
          (isSublayer
              ? (isLightTheme
                  ? const Color.fromRGBO(198, 198, 198, 1)
                  : const Color.fromRGBO(71, 71, 71, 1))
              : mapsThemeData.layerColor ??
                  (isLightTheme
                      ? themeData.colorScheme.onSurface.withOpacity(0.11)
                      : themeData.colorScheme.onSurface.withOpacity(0.24))),
      layerStrokeColor: widget.strokeColor ??
          (isSublayer
              ? (isLightTheme
                  ? const Color.fromRGBO(145, 145, 145, 1)
                  : const Color.fromRGBO(133, 133, 133, 1))
              : mapsThemeData.layerStrokeColor ??
                  (isLightTheme
                      ? themeData.colorScheme.onSurface.withOpacity(0.18)
                      : themeData.colorScheme.onSurface.withOpacity(0.43))),
      layerStrokeWidth: widget.strokeWidth ??
          (isSublayer
              ? (isLightTheme ? 0.5 : 0.25)
              : mapsThemeData.layerStrokeWidth),
      shapeHoverStrokeWidth:
          mapsThemeData.shapeHoverStrokeWidth ?? mapsThemeData.layerStrokeWidth,
      legendTextStyle: themeData.textTheme.bodySmall!
          .copyWith(
              color: themeData.textTheme.bodySmall!.color!.withOpacity(0.87))
          .merge(widget.legend?.textStyle ?? mapsThemeData.legendTextStyle),
      markerIconColor: mapsThemeData.markerIconColor ??
          (isLightTheme
              ? const Color.fromRGBO(98, 0, 238, 1)
              : const Color.fromRGBO(187, 134, 252, 1)),
      bubbleColor: widget.bubbleSettings.color ??
          mapsThemeData.bubbleColor ??
          (isLightTheme
              ? const Color.fromRGBO(98, 0, 238, 0.5)
              : const Color.fromRGBO(187, 134, 252, 0.8)),
      bubbleStrokeColor: widget.bubbleSettings.strokeColor ??
          mapsThemeData.bubbleStrokeColor ??
          Colors.transparent,
      bubbleStrokeWidth:
          widget.bubbleSettings.strokeWidth ?? mapsThemeData.bubbleStrokeWidth,
      bubbleHoverStrokeWidth: mapsThemeData.bubbleHoverStrokeWidth ??
          mapsThemeData.bubbleStrokeWidth,
      selectionColor: widget.selectionSettings.color ??
          mapsThemeData.selectionColor ??
          (isLightTheme
              ? themeData.colorScheme.onSurface.withOpacity(0.53)
              : themeData.colorScheme.onSurface.withOpacity(0.85)),
      selectionStrokeColor: widget.selectionSettings.strokeColor ??
          mapsThemeData.selectionStrokeColor ??
          (isLightTheme
              ? themeData.colorScheme.onPrimary.withOpacity(0.29)
              : themeData.colorScheme.surface.withOpacity(0.56)),
      selectionStrokeWidth: widget.selectionSettings.strokeWidth ??
          mapsThemeData.selectionStrokeWidth,
      tooltipColor: widget.tooltipSettings.color ??
          mapsThemeData.tooltipColor ??
          (isLightTheme
              ? const Color.fromRGBO(117, 117, 117, 1)
              : const Color.fromRGBO(245, 245, 245, 1)),
      tooltipStrokeColor: widget.tooltipSettings.strokeColor ??
          mapsThemeData.tooltipStrokeColor,
      tooltipStrokeWidth: widget.tooltipSettings.strokeWidth ??
          mapsThemeData.tooltipStrokeWidth,
      tooltipBorderRadius:
          mapsThemeData.tooltipBorderRadius.resolve(Directionality.of(context)),
      toggledItemColor: widget.legend?.toggledItemColor ??
          mapsThemeData.toggledItemColor ??
          (isLightTheme
              ? themeData.colorScheme.onPrimary
              : themeData.colorScheme.onSurface.withOpacity(0.09)),
      toggledItemStrokeColor: widget.legend?.toggledItemStrokeColor ??
          mapsThemeData.toggledItemStrokeColor ??
          (isLightTheme
              ? themeData.colorScheme.onSurface.withOpacity(0.37)
              : themeData.colorScheme.onSurface.withOpacity(0.17)),
      toggledItemStrokeWidth: widget.legend?.toggledItemStrokeWidth ??
          mapsThemeData.toggledItemStrokeWidth,
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

  Offset _getLegendPointerOffset(double? value) {
    double normalized = 0.0;
    double factor = 0.0;
    final List<MapColorMapper>? colorMappers = _getLegendSource();
    if (value != null && colorMappers != null && colorMappers.isNotEmpty) {
      final int length = colorMappers.length;
      // Range color mapper.
      if (colorMappers[0].from != null) {
        final double slab = 1 / length;
        for (int i = 0; i < length; i++) {
          final MapColorMapper mapper = colorMappers[i];
          if (mapper.from! <= value && mapper.to! >= value) {
            factor = (value - mapper.from!) / (mapper.to! - mapper.from!);
            if (widget.legend!.segmentPaintingStyle ==
                MapLegendPaintingStyle.solid) {
              // Setting the index of the segment based on the hovered
              // tile for solid bar legend types.
              _pointerController.segmentIndex = i;
              normalized += factor;
              break;
            } else {
              normalized += factor * slab;
              break;
            }
          } else if (widget.legend!.segmentPaintingStyle ==
              MapLegendPaintingStyle.gradient) {
            normalized += slab;
          }
        }
      } else {
        // Equal color mapper.
        if (widget.legend!.segmentPaintingStyle ==
            MapLegendPaintingStyle.solid) {
          _pointerController.segmentIndex = value.toInt();
          // To place the pointer at the center of the segment in case of
          // solid bar legend type.
          normalized = 0.5;
        } else {
          normalized = value / (length - 1);
        }
      }
    }
    return Offset(normalized, normalized);
  }

  void _updateLegendPointer(double? value) {
    if (_pointerController.colorValue != value) {
      _pointerController
        ..position = value != null ? _getLegendPointerOffset(value) : null
        ..colorValue = value;
    }
  }

  /// Returns color from [MapColorMapper] based on the data source value.
  Color? _getActualColor(Object? colorValue, List<MapColorMapper>? colorMappers,
      MapModel mapModel) {
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
          mapModel.legendMapperIndex = i;
          mapModel.colorValue = i;
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
          mapModel.legendMapperIndex = i;
          mapModel.colorValue = colorValue;
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

  void _needPathCenterAndWidthCalculation(Map<String, MapModel> mapDataSource) {
    List<Offset> pixelPoints;
    List<dynamic> rawPoints;
    int rawPointsLength, pointsLength;
    mapDataSource.forEach((String key, MapModel mapModel) {
      double signedArea = 0.0, centerX = 0.0, centerY = 0.0;
      rawPointsLength = mapModel.rawPoints.length;
      for (int j = 0; j < rawPointsLength; j++) {
        rawPoints = mapModel.rawPoints[j];
        pointsLength = rawPoints.length;
        pixelPoints = mapModel.pixelPoints![j];
        for (int k = 0; k < pointsLength; k++) {
          if (k > 0) {
            final int l = k - 1;
            if (widget.showDataLabels && l + 1 < pixelPoints.length) {
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
      }
      if (widget.showDataLabels) {
        findPathCenterAndWidth(signedArea, centerX, centerY, mapModel);
      }
    });
  }

  void _obtainDataSource() {
    _computeDataSource = _obtainDataSourceAndBindDataSource()
        .then((_ShapeFileData data) => data);
  }

  Future<_ShapeFileData> _obtainDataSourceAndBindDataSource() async {
    shapeFileData = await _retrieveDataFromShapeFile(
        _provider, widget.source.shapeDataField, shapeFileData, isSublayer);
    if (_shouldUpdateMapDataSource) {
      minBubbleValue = null;
      maxBubbleValue = null;
      for (final MapModel model in shapeFileData.mapDataSource.values) {
        model.reset();
      }
      _bindMapsSourceIntoDataSource();
      _shouldUpdateMapDataSource = false;
    }
    return shapeFileData;
  }

  @override
  void initState() {
    _pointerController = PointerController();
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
    _provider = getSourceProvider(widget.source._path, widget.source._type);
    _obtainDataSource();
    super.initState();
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
  void didUpdateWidget(GeoJSONLayer oldWidget) {
    _shouldUpdateMapDataSource = oldWidget.source != widget.source;
    _hasSublayer = widget.sublayers != null && widget.sublayers!.isNotEmpty;
    isSublayer = widget.sublayerAncestor != null;

    final MapProvider currentProvider =
        getSourceProvider(widget.source._path, widget.source._type);
    if (_provider != currentProvider) {
      _provider = currentProvider;
      shapeFileData.reset();
    }
    if (oldWidget.controller != widget.controller) {
      widget.controller!._parentBox =
          // ignore: avoid_as
          context.findRenderObject()! as _RenderGeoJSONLayer;
    }

    if (_controller != null && _shouldUpdateMapDataSource && !isSublayer) {
      _controller!.visibleFocalLatLng = null;
    }

    if (oldWidget.showDataLabels != widget.showDataLabels &&
        widget.showDataLabels) {
      if (shapeFileData.mapDataSource.values.first.shapePathCenter == null ||
          shapeFileData.mapDataSource.values.first.shapeWidth == null) {
        _needPathCenterAndWidthCalculation(shapeFileData.mapDataSource);
        dataLabelAnimationController.value = 0.0;
        if (mounted) {
          dataLabelAnimationController.forward(from: 0);
        }
      }
    }

    _obtainDataSource();
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
    _pointerController.dispose();
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
    final bool isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    final SfMapsThemeData mapsThemeData =
        _updateThemeData(context, themeData, SfMapsTheme.of(context)!);

    return FutureBuilder<_ShapeFileData>(
      future: _computeDataSource,
      builder: (BuildContext context, AsyncSnapshot<_ShapeFileData> snapshot) {
        if (snapshot.hasData) {
          return _buildGeoJSONLayer(mapsThemeData, isDesktop);
        } else {
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
}

class _GeoJSONLayerRenderObjectWidget extends Stack {
  _GeoJSONLayerRenderObjectWidget({
    required this.controller,
    required this.initialLatLngBounds,
    required this.mapDataSource,
    required this.mapSource,
    required this.selectedIndex,
    required this.legend,
    required this.bubbleSettings,
    required this.selectionSettings,
    required this.zoomPanBehavior,
    required this.themeData,
    required this.isDesktop,
    required this.state,
    List<Widget>? children,
  }) : super(children: children ?? <Widget>[]);

  final MapController controller;
  final MapLatLngBounds? initialLatLngBounds;
  final Map<String, MapModel> mapDataSource;
  final MapShapeSource mapSource;
  final int selectedIndex;
  final MapLegend? legend;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final SfMapsThemeData themeData;
  final bool isDesktop;
  final _GeoJSONLayerState state;
  final MapZoomPanBehavior? zoomPanBehavior;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderGeoJSONLayer(
      controller: controller,
      initialZoomLevel: zoomPanBehavior?.zoomLevel ?? 1.0,
      initialLatLngBounds: initialLatLngBounds,
      mapDataSource: mapDataSource,
      mapSource: mapSource,
      selectedIndex: selectedIndex,
      legend: legend,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      zoomPanBehavior: zoomPanBehavior,
      themeData: themeData,
      isDesktop: isDesktop,
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
      ..isDesktop = isDesktop
      ..context = context;
  }
}

class _RenderGeoJSONLayer extends RenderStack
    implements MouseTrackerAnnotation {
  _RenderGeoJSONLayer({
    required MapController controller,
    required double initialZoomLevel,
    required MapLatLngBounds? initialLatLngBounds,
    required Map<String, MapModel> mapDataSource,
    required MapShapeSource mapSource,
    required int selectedIndex,
    required MapLegend? legend,
    required MapBubbleSettings bubbleSettings,
    required MapSelectionSettings selectionSettings,
    required MapZoomPanBehavior? zoomPanBehavior,
    required SfMapsThemeData themeData,
    required this.isDesktop,
    required this.context,
    required _GeoJSONLayerState state,
  })  : _controller = controller,
        _initialLatLngBounds = initialLatLngBounds,
        _currentZoomLevel = initialZoomLevel,
        _mapDataSource = mapDataSource,
        _mapSource = mapSource,
        _selectedIndex = selectedIndex,
        _legend = legend,
        _bubbleSettings = bubbleSettings,
        _selectionSettings = selectionSettings,
        _zoomPanBehavior = zoomPanBehavior,
        _themeData = themeData,
        _state = state,
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
  final MapLatLngBounds? _initialLatLngBounds;
  double _actualFactor = 1.0;
  double _maximumReachedScaleOnInteraction = 1.0;
  int _pointerCount = 0;
  bool _initailPinchZooming = false;
  Offset _panDistanceBeforeFlinging = Offset.zero;
  bool _avoidPanUpdate = false;
  bool _isFlingAnimationActive = false;
  bool _doubleTapEnabled = false;
  bool _isAnimationOnQueue = false;
  late bool _validForMouseTracker;
  late double _currentZoomLevel;
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

  bool isDesktop;
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
      (isDesktop && (hasBubbleHoverColor || hasShapeHoverColor));

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
    if (value.isNotEmpty && value.values.first.shapePath == null && hasSize) {
      _mapDataSource = value;
      _currentSelectedItem = null;
      _prevSelectedItem = null;
      _previousHoverItem = null;
      _state.dataLabelAnimationController.value = 0.0;
      _state.bubbleAnimationController.value = 0.0;
      _refresh();
      markNeedsPaint();
      SchedulerBinding.instance
          .addPostFrameCallback(_initiateInitialAnimations);
    }
  }

  MapShapeSource? get mapSource => _mapSource;
  MapShapeSource? _mapSource;
  set mapSource(MapShapeSource? value) {
    if (_mapSource == value) {
      return;
    }

    _mapSource = value;
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

  MapLegend? get legend => _legend;
  MapLegend? _legend;
  set legend(MapLegend? value) {
    // Update [MapsShapeLayer.legend] value only when
    // [MapsShapeLayer.legend] property is set to shape.
    if (_legend == value) {
      return;
    }
    _legend = value;
    if (_legend != null && _legend!.enableToggleInteraction) {
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

    if (_mapSource!.primaryValueMapper != null) {
      _handleShapeLayerSelection();
    }
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
  bool get validForMouseTracker => _validForMouseTracker;

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
    final Color selectionColor = _themeData.selectionColor!;
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
      _forwardSelectionColorTween!.begin = (_currentHoverItem != null &&
              _currentInteractedElement == MapLayerElement.shape)
          ? _forwardHoverColorTween.end
          : getActualShapeColor(_currentSelectedItem!);
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
    final Color? toggledShapeColor =
        _themeData.toggledItemColor != Colors.transparent
            ? _themeData.toggledItemColor
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
    return _themeData.shapeHoverColor != null &&
            _themeData.shapeHoverColor != Colors.transparent
        ? _themeData.shapeHoverColor!
        : getSaturatedColor(getActualShapeColor(model));
  }

  Color _getHoverStrokeColor() {
    return (_themeData.shapeHoverStrokeColor != null &&
            _themeData.shapeHoverStrokeColor != Colors.transparent)
        ? _themeData.shapeHoverStrokeColor!
        : getSaturatedColor(_themeData.layerStrokeColor!);
  }

  MapLatLngBounds _getMaxVisibleBounds(MapLatLngBounds initialBounds) {
    final _ShapeBounds maxBounds = _state.shapeFileData.bounds;
    double lat = initialBounds.northeast.latitude;
    double lng = initialBounds.northeast.longitude;
    if (initialBounds.northeast.latitude > maxBounds.maxLatitude!) {
      lat = maxBounds.maxLatitude! as double;
    }
    if (initialBounds.northeast.longitude > maxBounds.maxLongitude!) {
      lng = maxBounds.maxLongitude! as double;
    }
    final MapLatLng northEast = MapLatLng(lat, lng);
    lat = initialBounds.southwest.latitude;
    lng = initialBounds.southwest.longitude;
    if (initialBounds.southwest.latitude < maxBounds.minLatitude!) {
      lat = maxBounds.minLatitude! as double;
    }
    if (initialBounds.southwest.longitude < maxBounds.minLongitude!) {
      lng = maxBounds.minLongitude! as double;
    }
    final MapLatLng southWest = MapLatLng(lat, lng);

    return MapLatLngBounds(northEast, southWest);
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
      MapLatLngBounds? initialBounds =
          _zoomPanBehavior?.latLngBounds ?? _initialLatLngBounds;
      double zoomLevel = _currentZoomLevel;
      if (latlng == null && initialBounds != null) {
        initialBounds = _getMaxVisibleBounds(initialBounds);
        zoomLevel = getZoomLevel(
            initialBounds, _controller.layerType!, _size, _actualFactor);
        latlng = getFocalLatLng(initialBounds);
      }

      if (_zoomPanBehavior != null) {
        _currentZoomLevel = zoomLevel.clamp(
            _zoomPanBehavior!.minZoomLevel, _zoomPanBehavior!.maxZoomLevel);
        _zoomPanBehavior!.zoomLevel = _currentZoomLevel;
        final double inflateWidth =
            _size.width * _currentZoomLevel / 2 - _size.width / 2;
        final double inflateHeight =
            _size.height * _currentZoomLevel / 2 - _size.height / 2;
        _controller.shapeLayerOrigin = Offset(
            paintBounds.left - inflateWidth, paintBounds.top - inflateHeight);
      } else {
        _currentZoomLevel =
            zoomLevel.clamp(kDefaultMinZoomLevel, kDefaultMaxZoomLevel);
      }

      _controller.shapeLayerSizeFactor = _actualFactor * _currentZoomLevel;
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
      mapModel.pixelPoints =
          List<List<Offset>>.filled(rawPointsLength, <Offset>[]);
      shapePath = Path();
      for (int j = 0; j < rawPointsLength; j++) {
        rawPoints = mapModel.rawPoints[j];
        pointsLength = rawPoints.length;
        pixelPoints = mapModel.pixelPoints![j] =
            List<Offset>.filled(pointsLength, Offset.zero);
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
      if (_state.widget.showDataLabels ||
          _state.widget.source.bubbleSizeMapper != null) {
        findPathCenterAndWidth(signedArea, centerX, centerY, mapModel);
      }
      _updateBubbleRadiusAndPath(mapModel);
    });
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
      newVisibleBounds: _zoomDetails!.newVisibleBounds,
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
            _invokeOnZooming(scale,
                localFocalPoint: _downLocalPoint,
                globalFocalPoint: _downGlobalPoint);
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
    // HACK: If the initial pinch zooming is performed then reinitialize
    // the ScaleGestureRecognizer for the web platform alone
    if (!_initailPinchZooming && kIsWeb) {
      _scaleGestureRecognizer.dispose();
      _scaleGestureRecognizer = ScaleGestureRecognizer()
        ..onStart = _handleScaleStart
        ..onUpdate = _handleScaleUpdate
        ..onEnd = _handleScaleEnd;
      _initailPinchZooming = true;
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
    _handlePanningCallback(latLng);
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
    _handleZoomingCallback(newZoomLevel, downPoint: _downLocalPoint);
  }

  // Returns the animation duration for the given distance and
  // friction co-efficient.
  Duration _getFlingAnimationDuration(
      double distance, double frictionCoefficient) {
    final int duration =
        (log(10.0 / distance) / log(frictionCoefficient / 100)).round();
    final int durationInMs = duration * 650;
    return Duration(milliseconds: durationInMs < 350 ? 350 : durationInMs);
  }

  /// Handling zooming using mouse wheel scrolling.
  void _handleScrollEvent(PointerScrollEvent event) {
    if (_zoomPanBehavior != null && _zoomPanBehavior!.enableMouseWheelZooming) {
      _controller.isInInteractive = true;
      _controller.gesture ??= Gesture.scale;
      if (_controller.gesture != Gesture.scale) {
        return;
      }

      if (_currentHoverItem != null) {
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

      _invokeOnZooming(scale,
          localFocalPoint: _downLocalPoint, globalFocalPoint: _downGlobalPoint);
      // When the user didn't scrolled or scaled for certain time period,
      // we will refresh the map to the corresponding zoom level.
      _zoomingDelayTimer?.cancel();
      _zoomingDelayTimer = Timer(const Duration(milliseconds: 250), () {
        _zoomEnd();
      });
    }
  }

  void _invokeOnZooming(double scale,
      {MapLatLng? focalLatLng,
      Offset? localFocalPoint,
      Offset? globalFocalPoint}) {
    final double newZoomLevel = _getZoomLevel(scale);
    final double newShapeLayerSizeFactor =
        _getScale(newZoomLevel) * _controller.shapeLayerSizeFactor;
    final Offset newShapeLayerOffset =
        _controller.getZoomingTranslation(origin: localFocalPoint);
    _controller.visibleFocalLatLng = _controller.getVisibleFocalLatLng(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    final Rect newVisibleBounds = _controller.getVisibleBounds(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    final MapLatLngBounds newVisibleLatLngBounds =
        _controller.getVisibleLatLngBounds(
      newVisibleBounds.topRight,
      newVisibleBounds.bottomLeft,
      newShapeLayerOffset,
      newShapeLayerSizeFactor,
    );
    if (_currentZoomLevel != newZoomLevel) {
      _zoomDetails = MapZoomDetails(
        localFocalPoint: localFocalPoint,
        globalFocalPoint: globalFocalPoint,
        previousZoomLevel: _currentZoomLevel,
        newZoomLevel: newZoomLevel,
        previousVisibleBounds: _zoomDetails != null
            ? _zoomDetails!.newVisibleBounds
            : _controller.visibleLatLngBounds,
        newVisibleBounds: newVisibleLatLngBounds,
        focalLatLng: focalLatLng ?? getFocalLatLng(newVisibleLatLngBounds),
      );
      if (_state.widget.onWillZoom == null ||
          _state.widget.onWillZoom!(_zoomDetails!)) {
        _zoomPanBehavior?.onZooming(_zoomDetails!);
      }
    }
  }

  void _handleZoomingCallback(double newZoomLevel, {Offset? downPoint}) {
    downPoint ??= pixelFromLatLng(
        _controller.visibleFocalLatLng!.latitude,
        _controller.visibleFocalLatLng!.longitude,
        _size,
        _controller.shapeLayerOffset,
        _controller.shapeLayerSizeFactor);
    final double newShapeLayerSizeFactor =
        _getScale(newZoomLevel) * _controller.shapeLayerSizeFactor;
    final Offset newShapeLayerOffset =
        _controller.getZoomingTranslation(origin: downPoint);
    final Rect newVisibleBounds = _controller.getVisibleBounds(
        newShapeLayerOffset, newShapeLayerSizeFactor);
    final MapLatLngBounds newVisibleLatLngBounds =
        _controller.getVisibleLatLngBounds(
      newVisibleBounds.topRight,
      newVisibleBounds.bottomLeft,
      newShapeLayerOffset,
      newShapeLayerSizeFactor,
    );
    if (_currentZoomLevel != newZoomLevel) {
      _zoomDetails = MapZoomDetails(
        localFocalPoint: downPoint,
        globalFocalPoint: localToGlobal(downPoint),
        previousZoomLevel: _currentZoomLevel,
        newZoomLevel: newZoomLevel,
        previousVisibleBounds: _zoomDetails != null
            ? _zoomDetails!.newVisibleBounds
            : _controller.visibleLatLngBounds,
        newVisibleBounds: newVisibleLatLngBounds,
        focalLatLng: getFocalLatLng(newVisibleLatLngBounds),
      );
      if (_state.widget.onWillZoom == null ||
          _state.widget.onWillZoom!(_zoomDetails!)) {
        _zoomPanBehavior?.zoomLevel = _zoomDetails!.newZoomLevel!;
      }
    }
  }

  void _handlePanningCallback(MapLatLng newLatLng) {
    final Offset localFocalPoint = pixelFromLatLng(
        newLatLng.latitude,
        newLatLng.longitude,
        _size,
        _controller.shapeLayerOffset + _panDistanceBeforeFlinging,
        _controller.shapeLayerSizeFactor);
    final Offset previousFocalPoint = pixelFromLatLng(
        _controller.visibleFocalLatLng!.latitude,
        _controller.visibleFocalLatLng!.longitude,
        _size,
        _controller.shapeLayerOffset + _panDistanceBeforeFlinging,
        _controller.shapeLayerSizeFactor);
    final Offset delta =
        _getValidPanDelta(localFocalPoint - previousFocalPoint);
    final Rect visibleBounds =
        _controller.getVisibleBounds(_controller.shapeLayerOffset + delta);
    final MapLatLngBounds newVisibleLatLngBounds =
        _controller.getVisibleLatLngBounds(
      visibleBounds.topRight,
      visibleBounds.bottomLeft,
      _controller.shapeLayerOffset + delta,
    );
    _panDetails = MapPanDetails(
      globalFocalPoint: localToGlobal(localFocalPoint),
      localFocalPoint: localFocalPoint,
      zoomLevel: _zoomPanBehavior!.zoomLevel,
      delta: delta,
      previousVisibleBounds: _panDetails != null
          ? _panDetails!.newVisibleBounds
          : _controller.visibleLatLngBounds,
      newVisibleBounds: newVisibleLatLngBounds,
      focalLatLng: newLatLng,
    );
    if (_state.widget.onWillPan == null ||
        _state.widget.onWillPan!(_panDetails!)) {
      _zoomPanBehavior?.focalLatLng = _panDetails!.focalLatLng;
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
    }
    _zoomPanBehavior!
      ..zoomLevel = details.newZoomLevel!
      ..focalLatLng = details.focalLatLng;
  }

  void _handleZoomLevelChange(double zoomLevel) {
    if (_controller.isInInteractive &&
        !_state.focalLatLngAnimationController.isAnimating &&
        !_state.zoomLevelAnimationController.isAnimating) {
      _currentZoomLevel = zoomLevel;
      markNeedsPaint();
    } else if (_zoomPanBehavior!.zoomLevel != _currentZoomLevel) {
      if (_state.focalLatLngAnimationController.isAnimating) {
        _isAnimationOnQueue = true;
        return;
      }
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
      final MapLatLng focalLatLng =
          _zoomPanBehavior!.focalLatLng ?? _controller.visibleFocalLatLng!;
      _handleZoomingAnimationEnd(focalLatLng);
      if (_isAnimationOnQueue) {
        _isAnimationOnQueue = false;
        _handleFocalLatLngChange(focalLatLng);
      }
    }
  }

  void _handleZoomingAnimationEnd([MapLatLng? latLng]) {
    _isFlingAnimationActive = false;
    _zoomEnd();
    _doubleTapEnabled = false;
  }

  void _zoomEnd() {
    _controller.isInInteractive = false;
    _controller.gesture = null;
    _zoomingDelayTimer?.cancel();
    _zoomingDelayTimer = null;
    _zoomDetails = null;
    _panDetails = null;
    if (_zoomPanBehavior != null && !_state.isSublayer) {
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
    final MapLatLngBounds newVisibleLatLngBounds =
        _controller.getVisibleLatLngBounds(
      visibleBounds.topRight,
      visibleBounds.bottomLeft,
      _controller.shapeLayerOffset + (canAvoidPanUpdate ? Offset.zero : delta),
    );
    _panDetails = MapPanDetails(
      globalFocalPoint: focalPoint,
      localFocalPoint: localFocalPoint,
      zoomLevel: _zoomPanBehavior!.zoomLevel,
      delta: delta,
      previousVisibleBounds: _panDetails != null
          ? _panDetails!.newVisibleBounds
          : _controller.visibleLatLngBounds,
      newVisibleBounds: newVisibleLatLngBounds,
      focalLatLng: getFocalLatLng(newVisibleLatLngBounds),
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
    if (latlng != null &&
        _controller.isInInteractive &&
        !_state.focalLatLngAnimationController.isAnimating &&
        !_state.zoomLevelAnimationController.isAnimating) {
      return;
    } else if (!_controller.isInInteractive ||
        _controller.visibleFocalLatLng != _zoomPanBehavior!.focalLatLng) {
      if (_state.zoomLevelAnimationController.isAnimating) {
        _isAnimationOnQueue = true;
        return;
      }
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
      if (_isAnimationOnQueue) {
        _isAnimationOnQueue = false;
        _handleZoomLevelChange(_zoomPanBehavior!.zoomLevel);
      }
    }
  }

  void _handleFocalLatLngAnimationEnd() {
    _isFlingAnimationActive = false;
    _panEnd();
    _referenceVisibleBounds =
        _controller.getVisibleBounds(_controller.shapeLayerOffset);
    _referenceShapeBounds = _getShapeBounds(
        _controller.shapeLayerSizeFactor, _controller.shapeLayerOffset);
  }

  void _panEnd() {
    _controller.isInInteractive = false;
    _zoomDetails = null;
    _panDetails = null;
    _panDistanceBeforeFlinging = Offset.zero;
    if (!_state.isSublayer) {
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
      _cancelZoomingAnimation();
    }
    if (_state.focalLatLngAnimationController.isAnimating) {
      _cancelFocalLatLngAnimation();
    }
  }

  void _cancelZoomingAnimation() {
    _state.zoomLevelAnimationController.stop();
    _handleZoomingAnimationEnd();
    if (_isAnimationOnQueue) {
      _isAnimationOnQueue = false;
      _zoomPanBehavior!.focalLatLng = _controller.visibleFocalLatLng;
    }
  }

  void _cancelFocalLatLngAnimation() {
    _state.focalLatLngAnimationController.stop();
    _handleFocalLatLngAnimationEnd();
    if (_isAnimationOnQueue) {
      _isAnimationOnQueue = false;
      _zoomPanBehavior!.zoomLevel = _currentZoomLevel;
    }
  }

  void _handleRefresh() {
    if (_state.isSublayer) {
      _refresh();
    }
  }

  void _handleZoomPanChange() {
    if (_state.isSublayer) {
      if (_state._controller!.localScale == 1.0 &&
          _state._controller!.panDistance == Offset.zero) {
        _refresh();
      } else {
        markNeedsPaint();
      }
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
          element: _currentInteractedElement);
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
      _invokeOnZooming(_getScale(newZoomLevel),
          localFocalPoint: _downLocalPoint,
          globalFocalPoint: _downGlobalPoint,
          focalLatLng: _controller.visibleFocalLatLng);
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
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Offset localPosition = renderBox.globalToLocal(event.position);
    _prevSelectedItem = null;
    // Initially currentHoverItem will be previous hovered item and
    // currentInteractedItem is interacting item in present, So we have
    // restricted updating the legend pointer from each pixel changes.
    final bool didUpdateLegend = _currentHoverItem != _currentInteractedItem;
    _performChildHover(localPosition);
    if (_legend != null && _legend!.showPointerOnHover && didUpdateLegend) {
      if ((_currentInteractedElement == MapLayerElement.bubble &&
              _legend!.source == MapElement.bubble) ||
          (_currentInteractedElement == MapLayerElement.shape &&
              _legend!.source == MapElement.shape)) {
        if (_previousHoverItem != null) {
          // Passing null value to offset property in PointerController to
          // render the solid bar legend segment without pointer.
          _state._updateLegendPointer(null);
        }
        _state._updateLegendPointer(
            _currentInteractedItem!.colorValue?.toDouble());
      } else {
        _state._updateLegendPointer(null);
      }
    }
  }

  void _handleExit(PointerExitEvent event) {
    if (_state.mounted) {
      if (_state.widget.source.bubbleSizeMapper != null &&
          _state.bubbleKey.currentContext != null &&
          hasBubbleHoverColor) {
        final ShapeLayerChildRenderBoxBase bubbleRenderObject =
            _state.bubbleKey.currentContext!.findRenderObject()!
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
              _state.widget.bubbleTooltipBuilder != null) &&
          _controller.tooltipKey != null &&
          _controller.tooltipKey!.currentContext != null) {
        final ShapeLayerChildRenderBoxBase tooltipRenderObject =
            _controller.tooltipKey!.currentContext!.findRenderObject()!
                // ignore: avoid_as
                as ShapeLayerChildRenderBoxBase;
        tooltipRenderObject.hideTooltip();
      }

      if (_legend != null && _legend!.showPointerOnHover) {
        _state._updateLegendPointer(null);
      }
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
          !(wasToggled && _legend!.source == MapElement.shape)) {
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
        mapModel.shapePath != null &&
        mapModel.shapePath!.contains(position);
  }

  void _performChildHover(Offset position) {
    final MapModel? currentInteractedItem = _currentInteractedItem;
    _invokeTooltip(
        position: position,
        model: _currentInteractedItem,
        element: _currentInteractedElement,
        kind: PointerKind.hover);
    if (_state.widget.source.bubbleSizeMapper != null &&
        _state.bubbleKey.currentContext != null) {
      final ShapeLayerChildRenderBoxBase bubbleRenderObject =
          _state.bubbleKey.currentContext!.findRenderObject()!
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
            _state.widget.bubbleTooltipBuilder != null) &&
        _controller.tooltipKey != null &&
        _controller.tooltipKey!.currentContext != null) {
      Rect? elementRect;
      final ShapeLayerChildRenderBoxBase tooltipRenderObject =
          _controller.tooltipKey!.currentContext!.findRenderObject()!
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
    if (_legend != null && _legend!.source == MapElement.shape) {
      late MapModel model;
      if (_state.widget.source.shapeColorMappers == null) {
        model =
            mapDataSource.values.elementAt(_controller.currentToggledItemIndex);
      } else {
        for (final MapModel mapModel in _mapDataSource.values) {
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
          ? _themeData.selectionColor!
          : getActualShapeColor(model);
      _forwardToggledShapeColorTween.begin = shapeColor;
      _reverseToggledShapeColorTween.end = shapeColor;
      _state.toggleAnimationController.forward(from: 0);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _validForMouseTracker = true;
    _state.selectionAnimationController.addListener(markNeedsPaint);
    _state.toggleAnimationController.addListener(markNeedsPaint);
    _state.hoverShapeAnimationController.addListener(markNeedsPaint);

    _controller
      ..addZoomingListener(_handleZooming)
      ..addPanningListener(_handlePanning)
      ..addResetListener(_handleReset)
      ..addToolbarZoomedListener(_handleZoomingCallback);
    if (_state.isSublayer) {
      _controller
        ..addRefreshListener(_handleRefresh)
        ..addZoomPanListener(_handleZoomPanChange);
    } else {
      _controller.addToggleListener(_handleToggleChange);

      _state.zoomLevelAnimationController
        ..addListener(_handleZoomLevelAnimation)
        ..addStatusListener(_handleZoomLevelAnimationStatusChange);

      _state.focalLatLngAnimationController
        ..addListener(_handleFocalLatLngAnimation)
        ..addStatusListener(_handleFocalLatLngAnimationStatusChange);
    }
    SchedulerBinding.instance.addPostFrameCallback(_initiateInitialAnimations);
  }

  @override
  void detach() {
    _validForMouseTracker = false;
    _state.dataLabelAnimationController.value = 0.0;
    _state.bubbleAnimationController.value = 0.0;
    _state.selectionAnimationController.removeListener(markNeedsPaint);
    _state.toggleAnimationController.removeListener(markNeedsPaint);
    _state.hoverShapeAnimationController.removeListener(markNeedsPaint);
    _controller
      ..removeZoomingListener(_handleZooming)
      ..removePanningListener(_handlePanning)
      ..removeResetListener(_handleReset)
      ..removeToolbarZoomedListener(_handleZoomingCallback);
    if (_state.isSublayer) {
      _controller
        ..removeRefreshListener(_handleRefresh)
        ..removeZoomPanListener(_handleZoomPanChange);
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
    } else if (isDesktop && event is PointerHoverEvent) {
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
          child.parentData! as StackParentData;
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
              ? (_reverseHoverColorTween.evaluate(_hoverColorAnimation) ??
                  getActualShapeColor(model))
              : getActualShapeColor(model);

          if (_themeData.shapeHoverStrokeWidth! > 0.0 &&
              _themeData.shapeHoverStrokeColor != Colors.transparent) {
            strokePaint
              ..color =
                  _reverseHoverStrokeColorTween.evaluate(_hoverColorAnimation)!
              ..strokeWidth = _themeData.layerStrokeWidth;
          } else {
            strokePaint
              ..color = _themeData.layerStrokeColor!
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
    if (_legend != null && _legend!.source == MapElement.shape) {
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
    if (_legend != null && _legend!.source == MapElement.shape) {
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
              ? _themeData.toggledItemStrokeWidth!
              : _themeData.layerStrokeWidth;
        return;
      } else if (hasToggledIndices && _controller.wasToggled(model)) {
        // Set toggled stroke color to the previously toggled shapes.
        strokePaint
          ..color =
              _forwardToggledShapeStrokeColorTween.end ?? Colors.transparent
          ..strokeWidth = _themeData.toggledItemStrokeWidth!;
        return;
      }
    }

    strokePaint
      ..color = _themeData.layerStrokeColor!
      ..strokeWidth = _themeData.layerStrokeWidth;
  }

  // Returns the color to the shape based on the [shapeColorMappers] and
  // [layerColor] properties.
  Color getActualShapeColor(MapModel model) {
    return model.shapeColor ?? _themeData.layerColor!;
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
          ..color = _themeData.layerStrokeColor!
          ..strokeWidth = _getIntrinsicStrokeWidth(_themeData.layerStrokeWidth);
      }

      if (strokePaint.strokeWidth > 0.0 &&
          strokePaint.color != Colors.transparent) {
        context.canvas.drawPath(_currentHoverItem!.shapePath!, strokePaint);
      }
    }
  }
}
