import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_maps/src/utils.dart';

import '../common.dart';
import '../controller/map_controller.dart';
import '../enum.dart';
import '../layer/shape_layer.dart';
import '../settings.dart';
import '../utils.dart';

enum _MapLegendType { vector, bar }

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
/// The below code snippet represents how to setting default legend
/// to the shape.
///
/// ```dart
/// List<DataModel> _data;
/// MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    super.initState();
///
///    _data = <DataModel>[
///      DataModel('India', 280, "Low"),
///      DataModel('United States of America', 190, "High"),
///      DataModel('Pakistan', 37, "Low"),
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
///        return _data[index].storage;
///      },
///      shapeColorMappers: [
///        MapColorMapper(value: "Low", color: Colors.red),
///        MapColorMapper(value: "High", color: Colors.green)
///      ],
///    );
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///        title: Text('Default legend'),
///      ),
///      body: Center(
///        child: SfMaps(
///          layers: [
///            MapShapeLayer(
///              source: _mapSource,
///              legend: MapLegend(MapElement.shape),
///            )
///          ],
///        ),
///      ),
///    );
///  }
///
/// class DataModel {
///   const DataModel(this.country, this.count, this.storage);
///
///   final String country;
///   final double count;
///   final String storage;
/// }
/// ```
/// The below code snippet represents how to setting bar legend to the shape.
///
/// ```dart
/// List<DataModel> _data;
/// MapShapeSource _mapSource;
///
///  @override
///  void initState() {
///    super.initState();
///
///    _data = <DataModel>[
///      DataModel('India', 280, "Low"),
///      DataModel('United States of America', 190, "High"),
///      DataModel('Pakistan', 37, "Low"),
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
///        return _data[index].storage;
///      },
///      shapeColorMappers: [
///        MapColorMapper(value: "Low", color: Colors.red),
///        MapColorMapper(value: "High", color: Colors.green)
///      ],
///    );
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(
///        title: Text('Bar legend'),
///      ),
///      body: Center(
///        child: SfMaps(
///          layers: [
///            MapShapeLayer(
///              source: _mapSource,
///              legend: MapLegend.bar(MapElement.shape),
///            )
///          ],
///        ),
///      ),
///    );
///  }
///
/// class DataModel {
///   const DataModel(this.country, this.count, this.storage);
///
///   final String country;
///   final double count;
///   final String storage;
/// }
/// ```
@immutable
class MapLegend extends DiagnosticableTree {
  /// Creates a legend with different styles like circle, rectangle, triangle
  /// and square for the bubbles or shapes.
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
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(MapElement.shape),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * `MapLegend.bar()` named constructor, for bar legend type.
  const MapLegend(
    this.source, {
    this.title,
    this.position = MapLegendPosition.top,
    this.offset,
    this.overflowMode = MapLegendOverflowMode.wrap,
    this.direction,
    this.padding = const EdgeInsets.all(10.0),
    this.spacing = 10.0,
    MapIconType iconType = MapIconType.circle,
    Size iconSize = const Size(8.0, 8.0),
    this.textStyle,
    bool enableToggleInteraction = false,
    Color? toggledItemColor,
    Color? toggledItemStrokeColor,
    double toggledItemStrokeWidth = 1.0,
    double toggledItemOpacity = 1.0,
  })  : _legendType = _MapLegendType.vector,
        _iconType = iconType,
        _iconSize = iconSize,
        _enableToggleInteraction = enableToggleInteraction,
        _toggledItemColor = toggledItemColor,
        _toggledItemStrokeColor = toggledItemStrokeColor,
        _toggledItemStrokeWidth = toggledItemStrokeWidth,
        _toggledItemOpacity = toggledItemOpacity,
        _segmentSize = null,
        _labelsPlacement = null,
        _edgeLabelsPlacement = null,
        _labelOverflow = null,
        _segmentPaintingStyle = null,
        assert(spacing >= 0),
        assert(padding != null),
        assert(toggledItemStrokeWidth >= 0),
        assert(toggledItemOpacity >= 0 && toggledItemOpacity <= 1);

  /// Creates a bar type legend for the bubbles or shapes.
  ///
  /// Information provided in the legend helps to identify the data rendered in
  /// the map shapes or bubbles.
  ///
  /// Defaults to `null`.
  ///
  /// By default, legend will not be shown.
  ///
  /// * labelsPlacement - Places the labels either between the bar items or on
  /// the items. By default, labels placement will be
  /// [MapLegendLabelsPlacement.betweenItems] when setting range color mapping
  /// ([MapColorMapper]) without setting [MapColorMapper.text] property.
  /// In all other cases, it will be [MapLegendLabelsPlacement.onItem].
  ///
  /// * edgeLabelsPlacement - Places the edge labels either inside or at
  /// center of the edges. It doesn't work with
  /// [MapLegendLabelsPlacement.betweenItems]. Defaults to
  /// [MapLegendEdgeLabelsPlacement.inside].
  ///
  /// * segmentPaintingStyle - Option for setting solid or gradient color for
  /// the bar. To enable the gradient, set this as
  /// [MapLegendPaintingStyle.gradient]. Defaults to
  /// [MapLegendPaintingStyle.solid].
  ///
  /// * labelOverflow - Option to trim or remove the legend item's text when
  /// it is overflowed. Defaults to [MapLabelOverflow.hide].
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
  /// If both the [MapShapeSource.shapeColorMappers] and
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
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(MapElement.shape),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * `MapLegend()`, for legend type with different styles like circle,
  /// diamond, rectangle and triangle.
  const MapLegend.bar(
    this.source, {
    this.title,
    this.overflowMode = MapLegendOverflowMode.scroll,
    this.padding = const EdgeInsets.all(10.0),
    this.position = MapLegendPosition.top,
    this.offset,
    this.spacing = 2.0,
    Size? segmentSize,
    this.textStyle,
    this.direction,
    MapLegendLabelsPlacement? labelsPlacement,
    MapLegendEdgeLabelsPlacement edgeLabelsPlacement =
        MapLegendEdgeLabelsPlacement.inside,
    MapLabelOverflow labelOverflow = MapLabelOverflow.visible,
    MapLegendPaintingStyle segmentPaintingStyle = MapLegendPaintingStyle.solid,
  })  : _legendType = _MapLegendType.bar,
        _enableToggleInteraction = false,
        _toggledItemColor = null,
        _toggledItemStrokeColor = null,
        _toggledItemStrokeWidth = 0.0,
        _toggledItemOpacity = 0.0,
        _labelsPlacement = labelsPlacement,
        _edgeLabelsPlacement = edgeLabelsPlacement,
        _labelOverflow = labelOverflow,
        _segmentPaintingStyle = segmentPaintingStyle,
        _segmentSize = segmentSize,
        _iconType = null,
        _iconSize = null,
        assert(spacing >= 0),
        assert(padding != null);

  /// Shows legend for the bubbles or shapes.
  ///
  /// Information provided in the legend helps to identify the data rendered in
  /// the map shapes or bubbles.
  ///
  /// By default, legend will not be shown.
  ///
  /// ## Legend for shape
  ///
  /// [MapElement.shape] shows legend for the shapes.
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
  /// [MapElement.bubble] shows legend for the bubbles.
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
  /// In a rare case, if both the [MapShapeSource.bubbleColorMappers] and
  /// the [MapShapeSource.bubbleColorValueMapper] properties are null,
  /// the legend item's text will be taken from the
  /// [MapShapeSource.shapeDataField] property and the legend item's
  /// icon will have the default color.
  ///
  /// See also:
  /// * [legend], to enable the legend toggle interaction and customize
  /// the appearance of the legend items.
  final MapElement source;

  /// Sets a title for the legend.
  ///
  /// Defaults to null.
  ///
  /// Typically a [Text] widget.
  ///
  /// ## Example
  ///
  /// This snippet shows how to create a map with legends and legend’s title.
  ///
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   _shapeSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "continent",
  ///   );
  /// }
  /// @override
  /// Widget build (BuildContext context) {
  ///     return Scaffold(
  ///       body: SfMaps(
  ///               layers: [
  ///                 MapShapeLayer(
  ///                   source: _shapeSource,
  ///                   legend: MapLegend(MapElement.shape,
  ///                      title: Text (‘World Map’),
  ///                   ),
  ///                 ),
  ///               ],
  ///             ),
  ///           );
  /// }
  /// ...
  ///
  /// See also:
  ///
  /// * `MapLegend()`, to know about the legend in maps.
  final Widget? title;

  /// Sets the padding around the legend.
  ///
  /// Defaults to EdgeInsets.all(10.0).
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                padding: EdgeInsets.all(10.0),
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  final EdgeInsetsGeometry? padding;

  /// Arranges the legend items in either horizontal or vertical direction.
  ///
  /// Defaults to horizontal, if the [position] is top, bottom or null.
  /// Defaults to vertical, if the [position] is left or right.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                direction: Axis.horizontal,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  final Axis? direction;

  /// Positions the legend in the different directions.
  ///
  /// Defaults to [MapLegendPosition.top].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                position: MapLegendPosition.right,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  /// See also:
  /// * [offset], to place the legend in custom position.
  final MapLegendPosition position;

  /// Places the legend in custom position.
  ///
  /// If the [offset] has been set and if the [position] is top, then the legend
  /// will be placed in top but in the position additional to the
  /// actual top position. Also, the legend will not take dedicated position for
  /// it and will be drawn on the top of map.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                offset: Offset(10.0, 10.0),
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  final Offset? offset;

  /// Specifies the space between the each legend items.
  ///
  /// Defaults to 10.0 for default legend and 2.0 for bar legend.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                spacing: 10.0,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  final double spacing;

  /// Customizes the legend item's text style.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                textStyle: TextStyle(color: Colors.red),
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Wraps or scrolls the legend items when it overflows.
  ///
  /// In wrap mode, overflowed items will be wrapped in a new row and will
  /// be positioned from the start.
  ///
  /// If the legend position is left or right, scroll direction is vertical.
  /// If the legend position is top or bottom, scroll direction is horizontal.
  ///
  /// Defaults to [MapLegendOverflowMode.wrap] for default legend and
  /// [MapLegendOverflowMode.scroll] for bar legend.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                overflowMode: MapLegendOverflowMode.scroll,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  /// * [direction], to set the direction of the legend.
  final MapLegendOverflowMode overflowMode;

  /// Enables the toggle interaction for the legend.
  ///
  /// Defaults to false.
  ///
  /// When this is enabled, respective shape or bubble for the legend item will
  /// be toggled on tap or click.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                enableToggleInteraction: true,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  final bool _enableToggleInteraction;

  /// Fills the toggled legend item's icon and the respective shape or bubble
  /// by this color.
  ///
  /// This snippet shows how to set toggledItemColor in [SfMaps].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                enableToggleInteraction: true,
  ///                toggledItemColor: Colors.blueGrey
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeColor], [toggledItemStrokeWidth], to set the stroke
  /// for the toggled legend item's shape or bubble.
  final Color? _toggledItemColor;

  /// Stroke color for the toggled legend item's respective shape or bubble.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                enableToggleInteraction: true,
  ///                toggledItemColor: Colors.blueGrey,
  ///                toggledItemStrokeColor: Colors.white,
  ///                toggledItemStrokeWidth: 0.5
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeWidth], to set the stroke width for the
  /// toggled legend item's shape.
  final Color? _toggledItemStrokeColor;

  /// Stroke width for the toggled legend item's respective shape or
  /// bubble.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemStrokeWidth in [SfMaps].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                enableToggleInteraction: true,
  ///                toggledItemColor: Colors.blueGrey,
  ///                toggledItemStrokeColor: Colors.white,
  ///                toggledItemStrokeWidth: 0.5
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeColor], to set the stroke color for the
  /// toggled legend item's shape.
  final double _toggledItemStrokeWidth;

  /// Sets the toggled legend item's respective shape or
  /// bubble opacity.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemOpacity in [SfMaps].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                enableToggleInteraction: true,
  ///                toggledItemColor: Colors.blueGrey,
  ///                toggledItemStrokeColor: Colors.white,
  ///                toggledItemStrokeWidth: 0.5,
  ///                toggledItemOpacity: 0.5,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  final double _toggledItemOpacity;

  /// Specifies the shape of the legend icon.
  ///
  /// Defaults to [MapIconType.circle].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                iconType: MapIconType.rectangle,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [iconSize], to set the size of the icon.
  final MapIconType? _iconType;

  /// Customizes the size of the bar segments.
  ///
  /// Defaults to Size(80.0, 12.0).
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                segmentSize: Size(70.0, 10.0),
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  final Size? _segmentSize;

  /// Customizes the size of the icon.
  ///
  /// Defaults to Size(12.0, 12.0).
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Default legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend(
  ///                MapElement.shape,
  ///                iconSize: Size(8.0, 8.0),
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [iconType], to set shape of the default legend icon.
  final Size? _iconSize;

  /// Place the labels either between the segments or on the segments.
  ///
  /// By default, label placement will be[MapLegendLabelsPlacement.betweenItems]
  /// when setting range color mapper without setting color mapper text property
  /// otherwise label placement will be [MapLegendLabelsPlacement.onItem].
  ///
  /// This snippet shows how to set label placement in [SfMaps].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                labelsPlacement: MapLegendLabelsPlacement.onItem,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [edgeLabelsPlacement], to place the edge labels either
  /// inside or outside of the bar legend.
  ///
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final MapLegendLabelsPlacement? _labelsPlacement;

  /// Place the edge labels either inside or outside of the bar legend.
  ///
  /// [edgeLabelsPlacement] doesn't works with
  /// [MapLegendLabelsPlacement.betweenItems].
  ///
  /// Defaults to [MapLegendEdgeLabelsPlacement.inside].
  ///
  /// This snippet shows how to set edge label placement in [SfMaps].
  ///
  /// ```dart
  ///  List<DataModel> _data;
  ///  MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///
  ///     _data = <DataModel>[
  ///       DataModel('India', 100, "Low"),
  ///       DataModel('United States of America', 200, "High"),
  ///       DataModel('Pakistan', 75, "Low"),
  ///     ];
  ///
  ///     _mapSource = MapShapeSource.asset("assets/world_map.json",
  ///         shapeDataField: "name",
  ///         dataCount: _data.length, primaryValueMapper: (int index) {
  ///       return _data[index].country;
  ///     }, shapeColorValueMapper: (int index) {
  ///       return _data[index].count;
  ///     }, shapeColorMappers: [
  ///       MapColorMapper(from: 0, to: 100, color: Colors.red),
  ///       MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///     ]);
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text('Bar legend')),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             source: _mapSource,
  ///             legend: MapLegend.bar(
  ///               MapElement.shape,
  ///               edgeLabelsPlacement: MapLegendEdgeLabelsPlacement.inside,
  ///             ),
  ///           )
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final MapLegendEdgeLabelsPlacement? _edgeLabelsPlacement;

  /// Trims or removes the legend text when it is overflowed from the
  /// bar legend.
  /// Defaults to [MapLabelOverflow.hide].
  ///
  /// By default, the legend labels will render even if it overflows form the
  /// bar legend. Using this property, it is possible to remove or trim the
  /// legend labels based on the bar legend size.
  ///
  /// This snippet shows how to set the [overflowMode] for the bar legend text
  ///  in [SfMaps].
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                labelOverflow: MapLabelOverflow.hide,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```
  ///
  /// See also:
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final MapLabelOverflow? _labelOverflow;

  /// Specifies the type of the legend.
  final _MapLegendType _legendType;

  /// Applies gradient or solid color for the bar segments.
  ///
  /// ```dart
  /// List<DataModel> _data;
  /// MapShapeSource _mapSource;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    _data = <DataModel>[
  ///      DataModel('India', 280, "Low"),
  ///      DataModel('United States of America', 190, "High"),
  ///      DataModel('Pakistan', 37, "Low"),
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
  ///        return _data[index].storage;
  ///      },
  ///      shapeColorMappers: [
  ///        MapColorMapper(value: "Low", color: Colors.red),
  ///        MapColorMapper(value: "High", color: Colors.green)
  ///      ],
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      appBar: AppBar(
  ///        title: Text('Bar legend'),
  ///      ),
  ///      body: Center(
  ///        child: SfMaps(
  ///          layers: [
  ///            MapShapeLayer(
  ///              source: _mapSource,
  ///              legend: MapLegend.bar(
  ///                MapElement.shape,
  ///                labelOverflow: MapLabelOverflow.hide,
  ///              ),
  ///            )
  ///          ],
  ///        ),
  ///      ),
  ///    );
  ///  }
  ///
  /// class DataModel {
  ///   const DataModel(this.country, this.count, this.storage);
  ///
  ///   final String country;
  ///   final double count;
  ///   final String storage;
  /// }
  /// ```dart
  ///
  /// See also:
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final MapLegendPaintingStyle? _segmentPaintingStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is MapLegend && other._legendType != _legendType) {
      return false;
    }

    return other is MapLegend &&
        other.padding == padding &&
        other.offset == offset &&
        other.spacing == spacing &&
        other.direction == direction &&
        other.overflowMode == overflowMode &&
        other.position == position &&
        other.textStyle == textStyle &&
        other._enableToggleInteraction == _enableToggleInteraction &&
        other._toggledItemColor == _toggledItemColor &&
        other._toggledItemStrokeColor == _toggledItemStrokeColor &&
        other._toggledItemStrokeWidth == _toggledItemStrokeWidth &&
        other._toggledItemOpacity == _toggledItemOpacity &&
        other.source == source;
  }

  @override
  int get hashCode => hashValues(
        padding,
        offset,
        spacing,
        direction,
        overflowMode,
        position,
        textStyle,
        _enableToggleInteraction,
        _toggledItemColor,
        _toggledItemStrokeColor,
        _toggledItemStrokeWidth,
        _toggledItemOpacity,
        source,
      );

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapLegend copyWith({
    Axis? direction,
    EdgeInsetsGeometry? padding,
    MapLegendPosition? position,
    Widget? title,
    Offset? offset,
    double? spacing,
    MapIconType? iconType,
    TextStyle? textStyle,
    Size? iconSize,
    Size? segmentSize,
    MapLegendOverflowMode? overflowMode,
    bool? enableToggleInteraction,
    Color? toggledItemColor,
    Color? toggledItemStrokeColor,
    double? toggledItemStrokeWidth,
    double? toggledItemOpacity,
    MapElement? source,
    MapLegendLabelsPlacement? labelsPlacement,
    MapLegendEdgeLabelsPlacement? edgeLabelsPlacement,
    MapLabelOverflow? labelOverflow,
    MapLegendPaintingStyle? segmentPaintingStyle,
  }) {
    if (_legendType == _MapLegendType.vector) {
      return MapLegend(
        source ?? this.source,
        title: title ?? this.title,
        direction: direction ?? this.direction,
        padding: padding ?? this.padding,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        spacing: spacing ?? this.spacing,
        iconType: iconType ?? _iconType!,
        textStyle: textStyle ?? this.textStyle,
        iconSize: iconSize ?? _iconSize!,
        overflowMode: overflowMode ?? this.overflowMode,
        enableToggleInteraction:
            enableToggleInteraction ?? _enableToggleInteraction,
        toggledItemColor: toggledItemColor ?? _toggledItemColor,
        toggledItemStrokeColor:
            toggledItemStrokeColor ?? _toggledItemStrokeColor,
        toggledItemStrokeWidth:
            toggledItemStrokeWidth ?? _toggledItemStrokeWidth,
        toggledItemOpacity: toggledItemOpacity ?? _toggledItemOpacity,
      );
    } else {
      return MapLegend.bar(
        source ?? this.source,
        title: title ?? this.title,
        direction: direction ?? this.direction,
        padding: padding ?? this.padding,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        spacing: spacing ?? this.spacing,
        textStyle: textStyle ?? this.textStyle,
        segmentSize: segmentSize ?? _segmentSize,
        overflowMode: overflowMode ?? this.overflowMode,
        labelsPlacement: labelsPlacement ?? _labelsPlacement,
        edgeLabelsPlacement: edgeLabelsPlacement ?? _edgeLabelsPlacement!,
        labelOverflow: labelOverflow ?? _labelOverflow!,
        segmentPaintingStyle: segmentPaintingStyle ?? _segmentPaintingStyle!,
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty<MapElement>('source', source));
    properties.add(EnumProperty<_MapLegendType>('legendType', _legendType));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DoubleProperty('spacing', spacing));
    if (direction != null) {
      properties.add(EnumProperty<Axis>('direction', direction));
    }

    properties
        .add(EnumProperty<MapLegendOverflowMode>('overflowMode', overflowMode));
    properties.add(EnumProperty<MapLegendPosition>('position', position));
    if (textStyle != null) {
      properties.add(textStyle!.toDiagnosticsNode(name: 'textStyle'));
    }

    if (_legendType == _MapLegendType.vector) {
      properties.add(DiagnosticsProperty<Size>('iconSize', _iconSize));
      properties.add(EnumProperty<MapIconType>('iconType', _iconType));
      properties.add(FlagProperty('enableToggleInteraction',
          value: _enableToggleInteraction,
          ifTrue: 'Toggle is enabled',
          ifFalse: 'Toggle is disabled',
          showName: false));
      if (_toggledItemColor != null) {
        properties.add(ColorProperty('toggledItemColor', _toggledItemColor));
      }

      if (_toggledItemStrokeColor != null) {
        properties.add(
            ColorProperty('toggledItemStrokeColor', _toggledItemStrokeColor));
      }

      properties.add(
          DoubleProperty('toggledItemStrokeWidth', _toggledItemStrokeWidth));
      properties.add(DoubleProperty('toggledItemOpacity', _toggledItemOpacity));
    } else {
      properties.add(DiagnosticsProperty<Size>('segmentSize', _segmentSize));
      properties.add(EnumProperty<MapLegendLabelsPlacement>(
          'labelsPlacement', _labelsPlacement));
      properties.add(EnumProperty<MapLegendEdgeLabelsPlacement>(
          'edgeLabelsPlacement', _edgeLabelsPlacement));
      properties.add(
          EnumProperty<MapLabelOverflow>('labelOverflowMode', _labelOverflow));
      properties.add(EnumProperty<MapLegendPaintingStyle>(
          'segmentPaintingStyle', _segmentPaintingStyle));
    }
  }
}

/// For rendering the map legend based on legend type.
class MapLegendWidget extends StatefulWidget {
  /// Creates a [MapMarker].
  MapLegendWidget({
    this.dataSource,
    required this.legend,
    this.themeData,
    this.controller,
    this.toggleAnimationController,
  })  : source = legend.source,
        textStyle = legend.textStyle,
        enableToggleInteraction = legend._enableToggleInteraction,
        toggledItemColor = legend._toggledItemColor,
        toggledItemStrokeColor = legend._toggledItemStrokeColor,
        toggledItemStrokeWidth = legend._toggledItemStrokeWidth,
        toggledItemOpacity = legend._toggledItemOpacity;

  /// map with the respective data in the data source.
  final dynamic dataSource;

  /// Customizes the appearance of the the legend.
  final MapLegend legend;

  /// Shows legend for the bubbles or shapes.
  final MapElement source;

  /// Customizes the legend item's text style.
  final TextStyle? textStyle;

  /// Enables the toggle interaction for the legend.
  final bool enableToggleInteraction;

  /// Fills the toggled legend item's icon and the respective shape or bubble
  /// by this color.
  final Color? toggledItemColor;

  /// Stroke color for the toggled legend item's respective shape or bubble.
  final Color? toggledItemStrokeColor;

  /// Stroke width for the toggled legend item's respective shape or
  /// bubble.
  final double toggledItemStrokeWidth;

  /// Sets the toggled legend item's respective shape or
  /// bubble opacity.
  final double toggledItemOpacity;

  /// Holds the color and typography values for a [SfMapsTheme].
  /// Use this class to configure a [SfMapsTheme] widget,
  /// or to set the [SfThemeData.mapsThemeData] for a [SfTheme] widget.
  final SfMapsThemeData? themeData;

  /// updating legend toggled indices.
  final MapController? controller;

  /// Applies animation for toggled legend item.
  final AnimationController? toggleAnimationController;

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapLegendWidget copyWith({
    dynamic dataSource,
    required MapLegend? legend,
    required SfMapsThemeData? themeData,
    required MapController? controller,
    required AnimationController? toggleAnimationController,
  }) {
    return MapLegendWidget(
      dataSource: dataSource ?? this.dataSource,
      legend: legend ?? this.legend,
      themeData: themeData ?? this.themeData,
      controller: controller ?? this.controller,
      toggleAnimationController:
          toggleAnimationController ?? this.toggleAnimationController,
    );
  }

  @override
  _MapLegendState createState() => _MapLegendState();
}

class _MapLegendState extends State<MapLegendWidget> {
  @override
  void didUpdateWidget(MapLegendWidget oldWidget) {
    if (oldWidget.legend.source != widget.legend.source) {
      _resetToggleState();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _resetToggleState();
    super.dispose();
  }

  void _resetToggleState() {
    widget.controller!.currentToggledItemIndex = -1;
    widget.controller!.toggledIndices.clear();
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (widget.legend.title == null) {
      switch (widget.legend.overflowMode) {
        case MapLegendOverflowMode.scroll:
          return _scrollableLegend;
        case MapLegendOverflowMode.wrap:
          return actualChild;
      }
    } else {
      if (widget.legend.position == MapLegendPosition.top ||
          widget.legend.position == MapLegendPosition.bottom) {
        return Column(
          mainAxisAlignment: widget.legend.position == MapLegendPosition.top
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children: [
            widget.legend.title!,
            widget.legend.overflowMode == MapLegendOverflowMode.scroll
                ? _scrollableLegend
                : actualChild
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.legend.title!,
            Flexible(
                child:
                    widget.legend.overflowMode == MapLegendOverflowMode.scroll
                        ? _scrollableLegend
                        : actualChild),
          ],
        );
      }
    }
  }

  Widget get _scrollableLegend {
    return SingleChildScrollView(
        scrollDirection: widget.legend.position == MapLegendPosition.top ||
                widget.legend.position == MapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical,
        child: actualChild);
  }

  Widget get actualChild {
    if (widget.legend._legendType == _MapLegendType.vector) {
      return Padding(
        padding: widget.legend.padding!,
        // Mapped the legend properties to the Wrap widget.
        child: Wrap(
          direction: widget.legend.direction ??
              (widget.legend.position == MapLegendPosition.top ||
                      widget.legend.position == MapLegendPosition.bottom
                  ? Axis.horizontal
                  : Axis.vertical),
          spacing: widget.legend.spacing,
          runSpacing: 6,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.start,
          children: _getLegendItems(),
        ),
      );
    } else {
      if (widget.legend._segmentPaintingStyle == MapLegendPaintingStyle.solid) {
        return _SolidBarLegend(
          dataSource: widget.dataSource,
          legend: widget.legend,
          themeData: widget.themeData!,
        );
      } else {
        return _GradientBarLegend(
          dataSource: widget.dataSource,
          settings: widget.legend,
          themeData: widget.themeData!,
        );
      }
    }
  }

  /// Returns the list of legend items based on the data source.
  List<Widget> _getLegendItems() {
    final List<Widget> legendItems = <Widget>[];
    final bool isLegendForBubbles = widget.legend.source == MapElement.bubble;
    if (widget.dataSource != null && widget.dataSource.isNotEmpty) {
      // Here source be either shape color mappers or bubble color mappers.
      if (widget.dataSource is List) {
        final int length = widget.dataSource.length;
        for (int i = 0; i < length; i++) {
          final MapColorMapper colorMapper = widget.dataSource[i];
          final String text = colorMapper.text ??
              colorMapper.value ??
              '${colorMapper.from} - ${colorMapper.to}';
          legendItems.add(_getLegendItem(
            text,
            colorMapper.color,
            i,
            isLegendForBubbles,
          ));
        }
      } else {
        // Here source is map data source.
        widget.dataSource.forEach((String key, MapModel mapModel) {
          legendItems.add(_getLegendItem(
            mapModel.primaryKey,
            isLegendForBubbles ? mapModel.bubbleColor : mapModel.shapeColor,
            mapModel.legendMapperIndex!,
            isLegendForBubbles,
          ));
        });
      }
    }

    return legendItems;
  }

  /// Returns the legend icon and label.
  Widget _getLegendItem(
      String text, Color? color, int index, bool isLegendForBubbles) {
    return _MapLegendItem(
      index: index,
      text: text,
      iconShapeColor: color ??
          (isLegendForBubbles
              ? widget.themeData!.bubbleColor
              : widget.themeData!.layerColor),
      source: widget.legend.source,
      legend: widget.legend,
      themeData: widget.themeData!,
      controller: widget.controller!,
      toggleAnimationController: widget.toggleAnimationController!,
    );
  }
}

class _MapLegendItem extends LeafRenderObjectWidget {
  const _MapLegendItem({
    required this.index,
    required this.text,
    required this.iconShapeColor,
    required this.source,
    required this.legend,
    required this.themeData,
    required this.controller,
    required this.toggleAnimationController,
  });

  final int index;
  final String text;
  final Color iconShapeColor;
  final MapElement source;
  final MapLegend legend;
  final SfMapsThemeData themeData;
  final MapController controller;
  final AnimationController toggleAnimationController;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLegendItem(
      index: index,
      text: text,
      iconShapeColor: iconShapeColor,
      source: source,
      legend: legend,
      themeData: themeData,
      controller: controller,
      toggleAnimationController: toggleAnimationController,
      mediaQueryData: MediaQuery.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderLegendItem renderObject) {
    renderObject
      ..text = text
      ..iconShapeColor = iconShapeColor
      ..source = source
      ..legend = legend
      ..themeData = themeData
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderLegendItem extends RenderBox implements MouseTrackerAnnotation {
  _RenderLegendItem({
    required int index,
    required String text,
    required Color iconShapeColor,
    required MapElement source,
    required MapLegend legend,
    required SfMapsThemeData themeData,
    required MapController controller,
    required AnimationController toggleAnimationController,
    required MediaQueryData mediaQueryData,
  })   : _index = index,
        _text = text,
        _iconShapeColor = iconShapeColor,
        _source = source,
        _legend = legend,
        _themeData = themeData,
        controller = controller,
        _toggleAnimationController = toggleAnimationController,
        _mediaQueryData = mediaQueryData {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _updateTextPainter();
    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;
    _toggleColorAnimation = CurvedAnimation(
        parent: _toggleAnimationController, curve: Curves.easeInOut);
    _iconColorTween = ColorTween();
    _textOpacityTween = Tween();
    _updateToggledIconColor();
  }

  final int _spacing = 3;

  final int _index;

  final double _toggledTextOpacity = 0.5;

  final double _untoggledTextOpacity = 1.0;

  final MapIconShape _iconShape = const MapIconShape();

  final AnimationController _toggleAnimationController;

  MapController controller;

  bool _wasToggled = false;

  late TextPainter _textPainter;

  late TapGestureRecognizer _tapGestureRecognizer;

  late Animation<double> _toggleColorAnimation;

  late Tween _textOpacityTween;

  late ColorTween _iconColorTween;

  late Color _toggledIconColor;

  String get text => _text;
  String _text;

  set text(String value) {
    if (_text == value) {
      return;
    }
    _text = value;
    _updateTextPainter();
    markNeedsLayout();
  }

  Color get iconShapeColor => _iconShapeColor;
  Color _iconShapeColor;

  set iconShapeColor(Color value) {
    if (_iconShapeColor == value) {
      return;
    }
    _iconShapeColor = value;
    markNeedsPaint();
  }

  MapElement get source => _source;
  MapElement _source;

  set source(MapElement value) {
    if (_source == value) {
      return;
    }
    _source = value;
    _wasToggled = false;
    markNeedsPaint();
  }

  MapLegend get legend => _legend;
  MapLegend _legend;

  set legend(MapLegend value) {
    if (_legend == value) {
      return;
    }
    _legend = value;
    _updateTextPainter();
    markNeedsLayout();
  }

  SfMapsThemeData get themeData => _themeData;
  SfMapsThemeData _themeData;

  set themeData(SfMapsThemeData value) {
    if (_themeData == value) {
      return;
    }
    _themeData = value;
    _updateToggledIconColor();
    markNeedsPaint();
  }

  MediaQueryData get mediaQueryData => _mediaQueryData;
  MediaQueryData _mediaQueryData;

  set mediaQueryData(MediaQueryData value) {
    if (_mediaQueryData == value) {
      return;
    }
    _mediaQueryData = value;
    _updateTextPainter();
    markNeedsLayout();
  }

  @override
  MouseCursor get cursor => _legend._enableToggleInteraction
      ? SystemMouseCursors.click
      : SystemMouseCursors.basic;

  @override
  PointerEnterEventListener? get onEnter => null;

  // As onHover property of MouseHoverAnnotation was removed only in the
  // beta channel, once it is moved to stable, will remove this property.
  @override
  // ignore: override_on_non_overriding_member
  PointerHoverEventListener? get onHover => null;

  @override
  PointerExitEventListener? get onExit => null;

  @override
  // ignore: override_on_non_overriding_member
  bool get validForMouseTracker => true;

  void _handleTapUp(TapUpDetails details) {
    _wasToggled = !controller.toggledIndices.contains(_index);
    if (_wasToggled) {
      controller.toggledIndices.add(_index);
      _iconColorTween.begin = _iconShapeColor;
      _iconColorTween.end = _toggledIconColor;
      _textOpacityTween.begin = _untoggledTextOpacity;
      _textOpacityTween.end = _toggledTextOpacity;
    } else {
      controller.toggledIndices.remove(_index);
      _iconColorTween.begin = _toggledIconColor;
      _iconColorTween.end = _iconShapeColor;
      _textOpacityTween.begin = _toggledTextOpacity;
      _textOpacityTween.end = _untoggledTextOpacity;
    }

    controller.currentToggledItemIndex = _index;
    _toggleAnimationController.forward(from: 0);
  }

  void _updateTextPainter() {
    _textPainter.textScaleFactor = _mediaQueryData.textScaleFactor;
    _textPainter.text = TextSpan(text: _text, style: legend.textStyle);
    _textPainter.layout();
  }

  void _updateToggledIconColor() {
    _toggledIconColor = _themeData.toggledItemColor != Colors.transparent
        ? _themeData.toggledItemColor.withOpacity(_legend._toggledItemOpacity)
        : (_themeData.brightness != Brightness.dark
            ? Color.fromRGBO(230, 230, 230, 1.0)
            : Color.fromRGBO(66, 66, 66, 1.0));
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestSelf(Offset position) => _legend._enableToggleInteraction;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    if (_legend._enableToggleInteraction &&
        event.down &&
        event is PointerDownEvent) {
      _tapGestureRecognizer.addPointer(event);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _toggleAnimationController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _toggleAnimationController.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final double width =
        _legend._iconSize!.width + _spacing + _textPainter.width;
    final double height =
        max(_legend._iconSize!.height, _textPainter.height) + _spacing;
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    double toggledLegendItemOpacity;
    Color? iconColor;
    Offset actualOffset;
    if (_wasToggled || controller.currentToggledItemIndex == _index) {
      if (controller.currentToggledItemIndex == _index) {
        iconColor = _iconColorTween.evaluate(_toggleColorAnimation)!;
        toggledLegendItemOpacity =
            _textOpacityTween.evaluate(_toggleColorAnimation);
      } else {
        iconColor = _toggledIconColor;
        toggledLegendItemOpacity = _toggledTextOpacity;
      }
    } else {
      iconColor = _iconShapeColor;
      toggledLegendItemOpacity = _untoggledTextOpacity;
    }

    final Size halfIconSize =
        _iconShape.getPreferredSize(_legend._iconSize!, _themeData) / 2;
    actualOffset =
        offset + Offset(0, (size.height - (halfIconSize.height * 2)) / 2);
    _iconShape.paint(context, actualOffset,
        parentBox: this,
        themeData: themeData,
        iconSize: _legend._iconSize!,
        color: iconColor,
        strokeWidth: 0.0,
        iconType: _legend._iconType!);

    _textPainter.text = TextSpan(
        style: _legend.textStyle!.copyWith(
            color: _legend.textStyle!.color!
                .withOpacity(toggledLegendItemOpacity)),
        text: _text);
    _textPainter.layout();
    actualOffset = offset +
        Offset(_legend._iconSize!.width + _spacing,
            (size.height - _textPainter.height) / 2);
    _textPainter.paint(context.canvas, actualOffset);
  }
}

class _SolidBarLegend extends StatefulWidget {
  const _SolidBarLegend({
    required this.dataSource,
    required this.legend,
    required this.themeData,
  });

  final dynamic dataSource;
  final MapLegend legend;
  final SfMapsThemeData themeData;

  @override
  _SolidBarLegendState createState() => _SolidBarLegendState();
}

class _SolidBarLegendState extends State<_SolidBarLegend> {
  bool _isOverlapSegmentText = false;
  late Axis _direction;
  late TextDirection _textDirection;
  late Size _segmentSize;
  late TextPainter _textPainter;
  MapLegendLabelsPlacement? _labelsPlacement;

  @override
  void initState() {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _segmentSize = widget.legend._segmentSize ?? const Size(80.0, 12.0);
    _labelsPlacement = widget.legend._labelsPlacement;
    final TextDirection textDirection = Directionality.of(context);
    _direction = widget.legend.direction ??
        (widget.legend.position == MapLegendPosition.top ||
                widget.legend.position == MapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    _textDirection = textDirection == TextDirection.ltr
        ? textDirection
        : (_direction == Axis.vertical ? TextDirection.ltr : textDirection);
    _textPainter.textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: widget.legend.padding!,
      child: Directionality(
        textDirection: _textDirection,
        child: Wrap(
          direction: _direction,
          spacing: widget.legend.spacing,
          runSpacing: 6,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.start,
          children: _getBarSegments(),
        ),
      ),
    );
  }

  List<Widget> _getBarSegments() {
    final bool hasBubbleSource = widget.legend.source == MapElement.bubble;
    if (widget.dataSource != null && widget.dataSource.isNotEmpty) {
      if (widget.dataSource is List) {
        return _getSegmentsForColorMapper(hasBubbleSource);
      } else {
        _labelsPlacement =
            widget.legend._labelsPlacement ?? MapLegendLabelsPlacement.onItem;
        return _getSegmentsForShapeSource(hasBubbleSource);
      }
    }

    return [];
  }

  List<Widget> _getSegmentsForColorMapper(bool isLegendForBubbles) {
    final List<Widget> legendItems = <Widget>[];
    final int length = widget.dataSource.length;
    String? currentText;
    for (int i = 0; i < length; i++) {
      _isOverlapSegmentText = false;
      final MapColorMapper colorMapper = widget.dataSource[i];
      _labelsPlacement = _labelsPlacement ??
          (colorMapper.from != null
              ? MapLegendLabelsPlacement.betweenItems
              : MapLegendLabelsPlacement.onItem);
      if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
        if (i == length - 1) {
          currentText = _getTrimmedText(
              _getText(widget.dataSource[i]), currentText, i, length);
        } else {
          if (i == 0) {
            final List<String> firstSegmentLabels =
                _getStartSegmentLabel(colorMapper);
            currentText = (firstSegmentLabels.length > 1
                ? firstSegmentLabels[1]
                : firstSegmentLabels[0]);
          } else {
            currentText = _getText(colorMapper);
          }

          currentText = _getTrimmedText(
              currentText, _getText(widget.dataSource[i + 1]), i, length);
        }
      } else {
        currentText = _getText(colorMapper);
        if (_direction == Axis.horizontal &&
            _labelsPlacement == MapLegendLabelsPlacement.onItem) {
          _isOverlapSegmentText =
              _getTextWidth(currentText) > _segmentSize.width;
        }
      }

      legendItems.add(_getSegment(currentText, colorMapper.color, i,
          isLegendForBubbles, length, colorMapper));
    }

    return legendItems;
  }

  List<Widget> _getSegmentsForShapeSource(bool isLegendForBubbles) {
    final List<Widget> barSegments = <Widget>[];
    final int length = widget.dataSource.length;
    // If we use as iterator, it will check first and second model and then
    // check third and fourth model. But we can't check second and third item
    // is overlapping or not. Since the iterator in second model . So we uses
    // two iterator. If we use move next first iterator gives current model and
    // second iterator gives next model.
    final Iterator<MapModel> currentIterator =
        widget.dataSource.values.iterator;
    final Iterator<MapModel> nextIterator = widget.dataSource.values.iterator;
    String? text;
    nextIterator.moveNext();
    while (currentIterator.moveNext()) {
      final MapModel mapModel = currentIterator.current;
      if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
        if (nextIterator.moveNext()) {
          text = _getTrimmedText(mapModel.primaryKey,
              nextIterator.current.primaryKey, mapModel.actualIndex, length);
        } else {
          text = _getTrimmedText(currentIterator.current.primaryKey, text,
              mapModel.actualIndex, length);
        }
      } else if (_direction == Axis.horizontal &&
          _labelsPlacement == MapLegendLabelsPlacement.onItem) {
        text = mapModel.primaryKey;
        _isOverlapSegmentText = _getTextWidth(text) > _segmentSize.width;
      }

      barSegments.add(_getSegment(
          text!,
          isLegendForBubbles ? mapModel.bubbleColor : mapModel.shapeColor,
          mapModel.legendMapperIndex!,
          isLegendForBubbles,
          length));
    }

    return barSegments;
  }

  String _getTrimmedText(
      String currentText, String? nextText, int index, int length) {
    if (widget.legend._labelOverflow == MapLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    final Size barSize = _segmentSize;
    double refCurrentTextWidth;
    double refNextTextWidth;
    if (_direction == Axis.horizontal &&
        _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      bool isLastInsideItem = false;
      if (index == length - 1) {
        isLastInsideItem = widget.legend._edgeLabelsPlacement ==
            MapLegendEdgeLabelsPlacement.inside;
        refNextTextWidth = _getTextWidth(nextText) / 2;
        refCurrentTextWidth = isLastInsideItem
            ? _getTextWidth(currentText)
            : _getTextWidth(currentText) / 2;
      } else {
        refCurrentTextWidth = _getTextWidth(currentText) / 2;
        refNextTextWidth = index + 1 == length - 1 &&
                widget.legend._edgeLabelsPlacement ==
                    MapLegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth >
          barSize.width + widget.legend.spacing;
      if (widget.legend._labelOverflow == MapLabelOverflow.ellipsis) {
        final double textWidth = refCurrentTextWidth + refNextTextWidth;
        return getTrimText(
            currentText,
            widget.legend.textStyle!,
            _segmentSize.width + widget.legend.spacing / 2,
            _textPainter,
            textWidth,
            refNextTextWidth,
            isLastInsideItem);
      }
    }

    return currentText;
  }

  String _getText(MapColorMapper colorMapper) {
    return colorMapper.text ??
        colorMapper.value ??
        (_labelsPlacement == MapLegendLabelsPlacement.betweenItems
            ? colorMapper.to.toString()
            : (_textDirection == TextDirection.ltr
                ? '${colorMapper.from} - ${colorMapper.to}'
                : '${colorMapper.to} - ${colorMapper.from}'));
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.legend.textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }

  /// Returns the bar legend icon and label.
  Widget _getSegment(
      String text, Color? color, int index, bool isLegendForBubbles, int length,
      [MapColorMapper? colorMapper]) {
    final Color iconColor = color ??
        (isLegendForBubbles
            ? widget.themeData.bubbleColor
            : widget.themeData.layerColor);
    return _getBarWithLabel(iconColor, index, text, colorMapper, length);
  }

  Widget _getBarWithLabel(Color iconColor, int index, String text,
      MapColorMapper? colorMapper, int dataSourceLength) {
    Offset textOffset = _getTextOffset(index, text, dataSourceLength);
    final CrossAxisAlignment crossAxisAlignment =
        _getCrossAxisAlignment(index, dataSourceLength);
    if (_direction == Axis.horizontal) {
      textOffset =
          _textDirection == TextDirection.rtl ? -textOffset : textOffset;
      return Container(
        width: _segmentSize.width,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Padding(
              // Gap between segment text and icon.
              padding: EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: _segmentSize.height,
                color: iconColor,
              ),
            ),
            _getTextWidget(index, text, colorMapper, textOffset),
          ],
        ),
      );
    } else {
      return _getVerticalBar(
          crossAxisAlignment, iconColor, index, text, colorMapper, textOffset);
    }
  }

  Widget _getVerticalBar(CrossAxisAlignment crossAxisAlignment, Color iconColor,
      int index, String text, MapColorMapper? colorMapper, Offset textOffset) {
    return Container(
      height: _segmentSize.width,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Padding(
            // Gap between segment text and icon.
            padding: EdgeInsets.only(right: 10.0),
            child: Container(
              width: _segmentSize.height,
              color: iconColor,
            ),
          ),
          _getTextWidget(index, text, colorMapper, textOffset),
        ],
      ),
    );
  }

  CrossAxisAlignment _getCrossAxisAlignment(int index, int length) {
    if (_labelsPlacement == MapLegendLabelsPlacement.onItem &&
        widget.legend._labelOverflow != MapLabelOverflow.visible) {
      return CrossAxisAlignment.center;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  Widget _getTextWidget(int index, String text, MapColorMapper? colorMapper,
      Offset legendOffset) {
    if (index == 0 &&
        colorMapper != null &&
        colorMapper.from != null &&
        _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      return _getStartSegmentText(colorMapper, text, legendOffset);
    } else {
      return _getAlignedTextWidget(legendOffset, text, _isOverlapSegmentText);
    }
  }

  Widget _getStartSegmentText(
      MapColorMapper colorMapper, String text, Offset legendOffset) {
    bool isStartTextOverlapping = false;
    String? startText;
    final List<String> firstSegmentLabels = _getStartSegmentLabel(colorMapper);
    if (firstSegmentLabels.length > 1) {
      startText = firstSegmentLabels[0];
    } else {
      startText = colorMapper.from?.toString();
    }

    if (_direction == Axis.horizontal &&
        widget.legend._labelOverflow != MapLabelOverflow.visible &&
        startText != null &&
        startText.isNotEmpty &&
        text.isNotEmpty) {
      final double refStartTextWidth = widget.legend._edgeLabelsPlacement ==
              MapLegendEdgeLabelsPlacement.inside
          ? _getTextWidth(startText)
          : _getTextWidth(startText) / 2;
      final double refCurrentTextWidth = _getTextWidth(text) / 2;
      isStartTextOverlapping = refStartTextWidth + refCurrentTextWidth >
          _segmentSize.width + widget.legend.spacing;
      if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
        startText = getTrimText(
            startText,
            widget.legend.textStyle!,
            _segmentSize.width + widget.legend.spacing / 2,
            _textPainter,
            refStartTextWidth + refCurrentTextWidth,
            refCurrentTextWidth);
      }
    }

    Offset startTextOffset = _getStartTextOffset(startText!);
    startTextOffset =
        _textDirection == TextDirection.rtl && _direction == Axis.horizontal
            ? -startTextOffset
            : startTextOffset;
    return Stack(
      children: [
        _getAlignedTextWidget(
            startTextOffset, startText, isStartTextOverlapping),
        _getAlignedTextWidget(legendOffset, text, _isOverlapSegmentText),
      ],
    );
  }

  List<String> _getStartSegmentLabel(MapColorMapper colorMapper) {
    if (colorMapper.from != null &&
        colorMapper.text != null &&
        colorMapper.text!.isNotEmpty &&
        colorMapper.text![0] == '{' &&
        _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      final List<String> splitText = colorMapper.text!.split('},{');
      if (splitText.length > 1) {
        splitText[0] = splitText[0].replaceAll('{', '');
        splitText[1] = splitText[1].replaceAll('}', '');
      }

      return splitText;
    } else {
      return [_getText(colorMapper)];
    }
  }

  Widget _getAlignedTextWidget(Offset offset, String text, bool isOverlapping) {
    if ((widget.legend._labelOverflow == MapLabelOverflow.hide &&
            isOverlapping) ||
        text.isEmpty) {
      return SizedBox(width: 0.0, height: 0.0);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: offset != Offset.zero
          ? Transform.translate(
              offset: offset,
              child: Text(
                text,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: widget.legend.textStyle,
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow:
                  widget.legend._labelOverflow == MapLabelOverflow.ellipsis &&
                          _labelsPlacement == MapLegendLabelsPlacement.onItem
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
              style: widget.legend.textStyle,
            ),
    );
  }

  Offset _getTextOffset(int index, String text, int dataSourceLength) {
    if (_labelsPlacement == MapLegendLabelsPlacement.onItem &&
        widget.legend._labelOverflow != MapLabelOverflow.visible) {
      return Offset.zero;
    }

    if (_direction == Axis.horizontal) {
      return _getHorizontalTextOffset(index, text, dataSourceLength);
    } else {
      return _getVerticalTextOffset(index, text, dataSourceLength);
    }
  }

  Offset _getVerticalTextOffset(int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.legend.textStyle);
    _textPainter.layout();
    if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      if (index == dataSourceLength - 1) {
        if (widget.legend._edgeLabelsPlacement ==
            MapLegendEdgeLabelsPlacement.inside) {
          return Offset(0.0, _segmentSize.width - _textPainter.height);
        }
        return Offset(0.0, _segmentSize.width - _textPainter.height / 2);
      }

      return Offset(
          0.0,
          _segmentSize.width -
              _textPainter.height / 2 +
              widget.legend.spacing / 2);
    } else {
      return Offset(0.0, _segmentSize.width / 2 - _textPainter.height / 2);
    }
  }

  Offset _getHorizontalTextOffset(
      int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.legend.textStyle);
    _textPainter.layout();
    if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      final double width = _textDirection == TextDirection.rtl &&
              _segmentSize.width < _textPainter.width
          ? _textPainter.width
          : _segmentSize.width;
      if (index == dataSourceLength - 1) {
        if (widget.legend._edgeLabelsPlacement ==
            MapLegendEdgeLabelsPlacement.inside) {
          return Offset(width - _textPainter.width, 0.0);
        }
        return Offset(width - _textPainter.width / 2, 0.0);
      }

      return Offset(
          width - _textPainter.width / 2 + widget.legend.spacing / 2, 0.0);
    } else {
      final double xPosition = _textDirection == TextDirection.rtl &&
              _segmentSize.width < _textPainter.width
          ? _textPainter.width / 2 - _segmentSize.width / 2
          : _segmentSize.width / 2 - _textPainter.width / 2;
      return Offset(xPosition, 0.0);
    }
  }

  Offset _getStartTextOffset(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.legend.textStyle);
    _textPainter.layout();
    if (widget.legend._edgeLabelsPlacement ==
        MapLegendEdgeLabelsPlacement.inside) {
      return Offset(0.0, 0.0);
    }

    if (_direction == Axis.horizontal) {
      return Offset(-_textPainter.width / 2, 0.0);
    } else {
      return Offset(0.0, -_textPainter.height / 2);
    }
  }
}

class _GradientBarLabel {
  _GradientBarLabel(this.label, this.offset, [this.isOverlapping]);

  String? label;

  Offset offset;

  bool? isOverlapping;
}

// ignore: must_be_immutable
class _GradientBarLegend extends StatelessWidget {
  _GradientBarLegend({
    required this.dataSource,
    this.source,
    required this.settings,
    required this.themeData,
  });

  final dynamic dataSource;
  final MapElement? source;
  final MapLegend settings;
  final SfMapsThemeData themeData;
  final List<Color> colors = <Color>[];
  final List<_GradientBarLabel> labels = <_GradientBarLabel>[];

  bool _isRTL = false;
  bool _isOverlapSegmentText = false;
  late Axis _direction;
  late Size _segmentSize;
  late TextPainter _textPainter;
  late double _referenceArea;
  MapLegendLabelsPlacement? _labelsPlacement;

  @override
  Widget build(BuildContext context) {
    _labelsPlacement =
        settings._labelsPlacement ?? MapLegendLabelsPlacement.betweenItems;
    _isRTL = Directionality.of(context) == TextDirection.rtl;
    _textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
    _direction = settings.direction ??
        (settings.position == MapLegendPosition.top ||
                settings.position == MapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    return Padding(
      padding: settings.padding!,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        _updateSegmentSize(getBoxSize(constraints).shortestSide);
        _collectLabelsAndColors();
        return _buildGradientBar();
      }),
    );
  }

  void _updateSegmentSize(double shortestSide) {
    if (_direction == Axis.horizontal) {
      final double availableWidth = shortestSide - settings.padding!.horizontal;
      _segmentSize = settings._segmentSize == null
          ? Size(availableWidth, 12.0)
          : Size(
              settings._segmentSize!.width > availableWidth
                  ? availableWidth
                  : settings._segmentSize!.width,
              settings._segmentSize!.height);
      return;
    }

    final double availableHeight = shortestSide - settings.padding!.vertical;
    _segmentSize = settings._segmentSize == null
        ? Size(12.0, availableHeight)
        : Size(
            settings._segmentSize!.width,
            settings._segmentSize!.height > availableHeight
                ? availableHeight
                : settings._segmentSize!.height);
  }

  void _collectLabelsAndColors() {
    final int length = dataSource.length;
    _referenceArea = _direction == Axis.horizontal
        ? _segmentSize.width
        : _segmentSize.height;
    final bool isLegendForBubbles = settings.source == MapElement.bubble;
    if (dataSource != null && dataSource.isNotEmpty) {
      if (dataSource is List) {
        _collectColorMapperLabelsAndColors(length);
      } else {
        final int length = dataSource.length;
        String? text;
        double slab;
        // If we use as iterator, it will check first and second model and
        // then check third and fourth model. But we can't check second and
        // third item is overlapping or not. Since the iterator in second model.
        // So we uses two iterator. If we use move next first iterator gives
        // current model and second iterator gives next model.
        final Iterator<MapModel> currentIterator = dataSource.values.iterator;
        final Iterator<MapModel> nextIterator = dataSource.values.iterator;
        nextIterator.moveNext();
        while (currentIterator.moveNext()) {
          final MapModel mapModel = currentIterator.current;
          int positionIndex;
          if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
            slab = _referenceArea / (length - 1);
            positionIndex = mapModel.actualIndex;
          } else {
            slab = _referenceArea / length;
            positionIndex = mapModel.actualIndex + 1;
          }
          if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
            if (nextIterator.moveNext()) {
              text = _getTrimmedText(mapModel.primaryKey, positionIndex, length,
                  slab, nextIterator.current.primaryKey);
            } else {
              text = _getTrimmedText(
                  mapModel.primaryKey, positionIndex, length, slab, text);
            }
          } else {
            if (_direction == Axis.horizontal) {
              text = _getTrimmedText(
                  mapModel.primaryKey, positionIndex, length, slab);
            }
          }

          labels.add(_GradientBarLabel(
              text,
              _getTextOffset(text!, positionIndex, length - 1, slab),
              _isOverlapSegmentText));
          final Color iconColor = (isLegendForBubbles
                  ? mapModel.bubbleColor
                  : mapModel.shapeColor) ??
              (isLegendForBubbles
                  ? themeData.bubbleColor
                  : themeData.layerColor);

          colors.add(iconColor);
        }
      }
    }
  }

  void _collectColorMapperLabelsAndColors(int length) {
    if (dataSource.isNotEmpty) {
      final double slab = _referenceArea /
          (_labelsPlacement == MapLegendLabelsPlacement.betweenItems &&
                  dataSource[0].value != null
              ? length - 1
              : length);
      for (int i = 0; i < length; i++) {
        _isOverlapSegmentText = false;
        final MapColorMapper colorMapper = dataSource[i];
        String text;
        if (i == 0) {
          final List<String> firstSegmentLabels =
              _getStartSegmentLabel(colorMapper);
          text = (firstSegmentLabels.length > 1
              ? firstSegmentLabels[1]
              : firstSegmentLabels[0]);
        } else {
          text = _getActualText(colorMapper);
        }

        if (dataSource[0].from != null) {
          _collectRageColorMapperLabels(i, colorMapper, text, slab, length);
        } else {
          final int positionIndex =
              _labelsPlacement == MapLegendLabelsPlacement.onItem ? i + 1 : i;
          if (_labelsPlacement == MapLegendLabelsPlacement.onItem) {
            text = _getTrimmedText(text, i, length, slab);
          } else if (i < length - 1) {
            text = _getTrimmedText(
                text, i, length, slab, _getActualText(dataSource[i + 1]));
          }
          // For equal color mapper, slab is equals to the color mapper
          // length -1.
          labels.add(_GradientBarLabel(
              text,
              _getTextOffset(text, positionIndex, length - 1, slab),
              _isOverlapSegmentText));
        }

        colors.add(colorMapper.color);
      }
    }
  }

  void _collectRageColorMapperLabels(
      int i, MapColorMapper colorMapper, String text, double slab, int length) {
    if (i == 0 && _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      String? startText;
      final List<String> firstSegmentLabels =
          _getStartSegmentLabel(colorMapper);
      if (firstSegmentLabels.length > 1) {
        startText = firstSegmentLabels[0];
      } else {
        startText = colorMapper.from?.toString();
      }

      if (_direction == Axis.horizontal &&
          _labelsPlacement == MapLegendLabelsPlacement.betweenItems &&
          startText != null &&
          startText.isNotEmpty &&
          text.isNotEmpty) {
        final double refCurrentTextWidth =
            settings._edgeLabelsPlacement == MapLegendEdgeLabelsPlacement.inside
                ? _getTextWidth(startText)
                : _getTextWidth(startText) / 2;
        final double refNextTextWidth = _getTextWidth(text) / 2;
        _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
        if (settings._labelOverflow == MapLabelOverflow.ellipsis) {
          if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
            final double textWidth = refCurrentTextWidth + refNextTextWidth;
            startText = getTrimText(startText, settings.textStyle!, slab,
                _textPainter, textWidth, refNextTextWidth);
          }
        }
      }

      labels.add(_GradientBarLabel(startText,
          _getTextOffset(startText!, i, length, slab), _isOverlapSegmentText));
    }

    if (_labelsPlacement == MapLegendLabelsPlacement.onItem) {
      text = _getTrimmedText(text, i, length, slab);
    } else if (i < length - 1) {
      text = _getTrimmedText(
          text, i, length, slab, _getActualText(dataSource[i + 1]));
    }

    // For range color mapper, slab is equals to the color mapper
    // length. So adding +1 to point out its position index.
    labels.add(_GradientBarLabel(text,
        _getTextOffset(text, i + 1, length, slab), _isOverlapSegmentText));
  }

  String _getTrimmedText(String currentText, int index, int length, double slab,
      [String? nextText]) {
    if (settings._labelOverflow == MapLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    if (_direction == Axis.horizontal &&
        _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      double refCurrentTextWidth;
      double refNextTextWidth;
      bool isLastInsideItem = false;
      if (index == length - 1) {
        refNextTextWidth = _getTextWidth(nextText) / 2;

        if (settings._edgeLabelsPlacement ==
            MapLegendEdgeLabelsPlacement.inside) {
          refCurrentTextWidth = _getTextWidth(currentText);
          isLastInsideItem = true;
        } else {
          refCurrentTextWidth = _getTextWidth(currentText) / 2;
          isLastInsideItem = false;
        }
      } else {
        refCurrentTextWidth = _getTextWidth(currentText) / 2;
        refNextTextWidth = index + 1 == length - 1 &&
                settings._edgeLabelsPlacement ==
                    MapLegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
      if (settings._labelOverflow == MapLabelOverflow.ellipsis &&
          _isOverlapSegmentText) {
        if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
          final double textWidth = refCurrentTextWidth + refNextTextWidth;
          return getTrimText(currentText, settings.textStyle!, slab,
              _textPainter, textWidth, refNextTextWidth, isLastInsideItem);
        }
      }
    } else if (_direction == Axis.horizontal &&
        _labelsPlacement == MapLegendLabelsPlacement.onItem) {
      final double textWidth = _getTextWidth(currentText);
      _isOverlapSegmentText = textWidth > slab;
      if (_isOverlapSegmentText) {
        return getTrimText(
            currentText, settings.textStyle!, slab, _textPainter, textWidth);
      }
    }

    return currentText;
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: settings.textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }

  List<String> _getStartSegmentLabel(MapColorMapper colorMapper) {
    if (colorMapper.from != null &&
        colorMapper.text != null &&
        colorMapper.text!.isNotEmpty &&
        colorMapper.text![0] == '{' &&
        _labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      final List<String> splitText = colorMapper.text!.split('},{');
      if (splitText.length > 1) {
        splitText[0] = splitText[0].replaceAll('{', '');
        splitText[1] = splitText[1].replaceAll('}', '');
      }

      return splitText;
    } else {
      return [_getActualText(colorMapper)];
    }
  }

  Offset _getTextOffset(
      String text, int positionIndex, int length, double slab) {
    _textPainter.text = TextSpan(text: text, style: settings.textStyle);
    _textPainter.layout();
    final bool canAdjustLabelToCenter =
        settings._edgeLabelsPlacement == MapLegendEdgeLabelsPlacement.center &&
                (positionIndex == 0 || positionIndex == length) ||
            (positionIndex > 0 && positionIndex < length) ||
            settings._labelsPlacement == MapLegendLabelsPlacement.onItem;
    if (_direction == Axis.horizontal) {
      return _getHorizontalOffset(
          canAdjustLabelToCenter, positionIndex, slab, length);
    } else {
      final double referenceTextWidth = canAdjustLabelToCenter
          ? _textPainter.height / 2
          : (positionIndex == length ? _textPainter.height : 0.0);
      if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
        return Offset(0.0, slab * positionIndex - referenceTextWidth);
      }

      return Offset(
          0.0, (slab * positionIndex) - referenceTextWidth - slab / 2);
    }
  }

  Offset _getHorizontalOffset(
      bool canAdjustLabelToCenter, int positionIndex, double slab, int length) {
    if (_isRTL) {
      final double referenceTextWidth = canAdjustLabelToCenter
          ? -_textPainter.width / 2
          : (positionIndex == 0 ? -_textPainter.width : 0.0);
      final double dx =
          _segmentSize.width - (slab * positionIndex - referenceTextWidth);

      if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
        return Offset(dx, 0.0);
      }

      return Offset(dx + slab / 2, 0.0);
    }

    final double referenceTextWidth = canAdjustLabelToCenter
        ? _textPainter.width / 2
        : (positionIndex == length ? _textPainter.width : 0.0);
    if (_labelsPlacement == MapLegendLabelsPlacement.betweenItems) {
      return Offset(slab * positionIndex - referenceTextWidth, 0.0);
    }

    return Offset(slab * positionIndex - referenceTextWidth - slab / 2, 0.0);
  }

  Widget _buildGradientBar() {
    return _direction == Axis.horizontal
        ? Column(children: _getChildren())
        : Row(children: _getChildren());
  }

  List<Widget> _getChildren() {
    double? labelBoxWidth = _segmentSize.width;
    double? labelBoxHeight;
    Alignment startAlignment = Alignment.centerLeft;
    Alignment endAlignment = Alignment.centerRight;

    if (_direction == Axis.vertical) {
      labelBoxWidth = null;
      labelBoxHeight = _segmentSize.height;
      startAlignment = Alignment.topCenter;
      endAlignment = Alignment.bottomCenter;
    }

    if (_isRTL && _direction == Axis.horizontal) {
      final Alignment temp = startAlignment;
      startAlignment = endAlignment;
      endAlignment = temp;
    }

    return [
      Container(
        width: _segmentSize.width,
        height: _segmentSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: startAlignment, end: endAlignment, colors: colors),
        ),
      ),
      SizedBox(
          width: _direction == Axis.vertical ? 7.0 : 0.0,
          height: _direction == Axis.horizontal ? 7.0 : 0.0),
      Container(
          width: labelBoxWidth, height: labelBoxHeight, child: _getLabels()),
    ];
  }

  Widget _getLabels() {
    return Stack(
      textDirection: TextDirection.ltr,
      children: List.generate(labels.length, (int index) {
        if ((settings._labelOverflow == MapLabelOverflow.hide &&
                labels[index].isOverlapping!) ||
            labels[index].label!.isEmpty) {
          return SizedBox(width: 0.0, height: 0.0);
        }

        return Directionality(
            textDirection: TextDirection.ltr,
            child: Transform.translate(
              offset: labels[index].offset,
              child: Text(
                labels[index].label!,
                style: settings.textStyle,
                softWrap: false,
              ),
            ));
      }),
    );
  }

  String _getActualText(MapColorMapper colorMapper) {
    return colorMapper.text ??
        colorMapper.value ??
        (_labelsPlacement == MapLegendLabelsPlacement.betweenItems
            ? colorMapper.to.toString()
            : (_isRTL
                ? '${colorMapper.to} - ${colorMapper.from}'
                : '${colorMapper.from} - ${colorMapper.to}'));
  }
}
