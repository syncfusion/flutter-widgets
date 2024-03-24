import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../maps.dart';
import '../common.dart';
import '../controller/map_controller.dart';

/// Specifies the legend type.
enum _LegendType {
  /// Vector type.
  vector,

  /// Bar type.
  bar,
}

/// Signature to return a [Widget] for the given value.
typedef MapLegendPointerBuilder = Widget Function(
    BuildContext context, dynamic value);

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
/// late List<DataModel> _data;
/// late MapShapeSource _mapSource;
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
/// late List<DataModel> _data;
/// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
    this.shouldAlwaysShowScrollbar = false,
    this.title,
    this.position = MapLegendPosition.top,
    this.offset,
    this.overflowMode = MapLegendOverflowMode.wrap,
    this.direction,
    this.padding = const EdgeInsets.all(10.0),
    this.spacing = 10.0,
    this.iconType = MapIconType.circle,
    this.iconSize = const Size(8.0, 8.0),
    this.textStyle,
    this.enableToggleInteraction = false,
    this.toggledItemColor,
    this.toggledItemStrokeColor,
    this.toggledItemStrokeWidth = 1.0,
    this.toggledItemOpacity = 0.5,
  })  : _type = _LegendType.vector,
        segmentSize = null,
        labelsPlacement = null,
        edgeLabelsPlacement = MapLegendEdgeLabelsPlacement.inside,
        labelOverflow = MapLabelOverflow.visible,
        segmentPaintingStyle = MapLegendPaintingStyle.solid,
        showPointerOnHover = false,
        pointerBuilder = null,
        pointerColor = null,
        pointerSize = Size.zero,
        assert(spacing >= 0),
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
    this.shouldAlwaysShowScrollbar = false,
    this.title,
    this.overflowMode = MapLegendOverflowMode.scroll,
    this.padding = const EdgeInsets.all(10.0),
    this.position = MapLegendPosition.top,
    this.offset,
    this.spacing = 2.0,
    this.segmentSize,
    this.textStyle,
    this.direction,
    this.labelsPlacement,
    this.edgeLabelsPlacement = MapLegendEdgeLabelsPlacement.inside,
    this.labelOverflow = MapLabelOverflow.visible,
    this.segmentPaintingStyle = MapLegendPaintingStyle.solid,
    this.showPointerOnHover = false,
    this.pointerBuilder,
    this.pointerColor,
    this.pointerSize = const Size(16, 12),
  })  : _type = _LegendType.bar,
        enableToggleInteraction = false,
        toggledItemColor = null,
        toggledItemStrokeColor = null,
        toggledItemStrokeWidth = 0.0,
        toggledItemOpacity = 0.0,
        iconType = MapIconType.circle,
        iconSize = const Size(8.0, 8.0),
        assert(spacing >= 0);

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
  /// * [MapShapeLayer.legend], to enable the legend toggle interaction and
  /// customize the appearance of the legend items.
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
  /// late MapShapeSource _shapeSource;
  ///
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   _shapeSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "continent",
  ///   );
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMaps(
  ///       layers: [
  ///         MapShapeLayer(
  ///           source: _shapeSource,
  ///           legend: MapLegend(
  ///             MapElement.shape,
  ///             title: Text('World Map'),
  ///           ),
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  ///
  /// * `MapLegend()`, to know about the legend in maps.
  final Widget? title;

  ///Toggles the scrollbar visibility.
  ///
  /// When set to false, the scrollbar appears only when scrolling else the
  /// scrollbar fades out. When true, the scrollbar will never fade out and
  /// will always be visible when the items are overflown.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  /// MapShapeLayer(
  ///            legend:MapLegend(
  ///              isVisible: true,
  ///              shouldAlwaysShowScrollbar: true,
  ///                  overflowMode: MapLegendOverflowMode.scroll,
  ///             )
  ///           )
  ///```
  final bool shouldAlwaysShowScrollbar;

  /// Sets the padding around the legend.
  ///
  /// Defaults to EdgeInsets.all(10.0).
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final bool enableToggleInteraction;

  /// Fills the toggled legend item's icon and the respective shape or bubble
  /// by this color.
  ///
  /// This snippet shows how to set toggledItemColor in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final Color? toggledItemColor;

  /// Stroke color for the toggled legend item's respective shape or bubble.
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final Color? toggledItemStrokeColor;

  /// Stroke width for the toggled legend item's respective shape or
  /// bubble.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemStrokeWidth in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final double toggledItemStrokeWidth;

  /// Sets the toggled legend item's text opacity.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemOpacity in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final double toggledItemOpacity;

  /// Specifies the shape of the legend icon.
  ///
  /// Defaults to [MapIconType.circle].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final MapIconType iconType;

  /// Customizes the size of the bar segments.
  ///
  /// Defaults to Size(80.0, 12.0).
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final Size? segmentSize;

  /// Customizes the size of the icon.
  ///
  /// Defaults to Size(12.0, 12.0).
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final Size iconSize;

  /// Place the labels either between the segments or on the segments.
  ///
  /// By default, label placement will be[MapLegendLabelsPlacement.betweenItems]
  /// when setting range color mapper without setting color mapper text property
  /// otherwise label placement will be [MapLegendLabelsPlacement.onItem].
  ///
  /// This snippet shows how to set label placement in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final MapLegendLabelsPlacement? labelsPlacement;

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
  ///  late List<DataModel> _data;
  ///  late MapShapeSource _mapSource;
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
  final MapLegendEdgeLabelsPlacement edgeLabelsPlacement;

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
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  final MapLabelOverflow labelOverflow;

  /// Specifies whether the pointer should be shown while hovering
  /// on the [MapLegend] segments.
  final bool showPointerOnHover;

  /// Returns a widget for the given value.
  ///
  /// The pointer is used to indicate the exact color of the hovering
  /// shape or bubble on the segment.
  ///
  /// The [pointerBuilder] will be called when the user interacts with the
  /// shapes or bubbles i.e., while tapping in touch devices and hovering in
  ///  the mouse enabled devices.
  final MapLegendPointerBuilder? pointerBuilder;

  /// Customizes the size of the pointer.
  final Size pointerSize;

  /// Customizes the color of the pointer.
  final Color? pointerColor;

  /// Specifies the type of the legend.
  final _LegendType _type;

  /// Applies gradient or solid color for the bar segments.
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
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
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final MapLegendPaintingStyle segmentPaintingStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is MapLegend && other._type != _type) {
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
        other.enableToggleInteraction == enableToggleInteraction &&
        other.toggledItemColor == toggledItemColor &&
        other.toggledItemStrokeColor == toggledItemStrokeColor &&
        other.toggledItemStrokeWidth == toggledItemStrokeWidth &&
        other.toggledItemOpacity == toggledItemOpacity &&
        other.source == source &&
        other.showPointerOnHover == showPointerOnHover &&
        other.pointerBuilder == pointerBuilder &&
        other.pointerColor == pointerColor &&
        other.pointerSize == pointerSize;
  }

  @override
  int get hashCode => Object.hash(
        padding,
        offset,
        spacing,
        direction,
        overflowMode,
        position,
        textStyle,
        enableToggleInteraction,
        toggledItemColor,
        toggledItemStrokeColor,
        toggledItemStrokeWidth,
        toggledItemOpacity,
        source,
        showPointerOnHover,
        pointerBuilder,
        pointerColor,
        pointerSize,
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
    bool? showPointerOnHover,
    MapLegendPointerBuilder? pointerBuilder,
    Color? pointerColor,
    Size? pointerSize,
  }) {
    if (_type == _LegendType.vector) {
      return MapLegend(
        source ?? this.source,
        title: title ?? this.title,
        direction: direction ?? this.direction,
        padding: padding ?? this.padding,
        position: position ?? this.position,
        offset: offset ?? this.offset,
        spacing: spacing ?? this.spacing,
        iconType: iconType ?? this.iconType,
        textStyle: textStyle ?? this.textStyle,
        iconSize: iconSize ?? this.iconSize,
        overflowMode: overflowMode ?? this.overflowMode,
        enableToggleInteraction:
            enableToggleInteraction ?? this.enableToggleInteraction,
        toggledItemColor: toggledItemColor ?? this.toggledItemColor,
        toggledItemStrokeColor:
            toggledItemStrokeColor ?? this.toggledItemStrokeColor,
        toggledItemStrokeWidth:
            toggledItemStrokeWidth ?? this.toggledItemStrokeWidth,
        toggledItemOpacity: toggledItemOpacity ?? this.toggledItemOpacity,
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
        segmentSize: segmentSize ?? segmentSize,
        overflowMode: overflowMode ?? this.overflowMode,
        labelsPlacement: labelsPlacement ?? this.labelsPlacement,
        edgeLabelsPlacement: edgeLabelsPlacement ?? this.edgeLabelsPlacement,
        labelOverflow: labelOverflow ?? this.labelOverflow,
        segmentPaintingStyle: segmentPaintingStyle ?? this.segmentPaintingStyle,
        showPointerOnHover: showPointerOnHover ?? this.showPointerOnHover,
        pointerBuilder: pointerBuilder ?? this.pointerBuilder,
        pointerColor: pointerColor ?? this.pointerColor,
        pointerSize: pointerSize ?? this.pointerSize,
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty<MapElement>('source', source));
    properties.add(EnumProperty<_LegendType>('legendType', _type));
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

    if (_type == _LegendType.vector) {
      properties.add(DiagnosticsProperty<Size>('iconSize', iconSize));
      properties.add(EnumProperty<MapIconType>('iconType', iconType));
      properties.add(FlagProperty('enableToggleInteraction',
          value: enableToggleInteraction,
          ifTrue: 'Toggle is enabled',
          ifFalse: 'Toggle is disabled'));
      if (toggledItemColor != null) {
        properties.add(ColorProperty('toggledItemColor', toggledItemColor));
      }

      if (toggledItemStrokeColor != null) {
        properties.add(
            ColorProperty('toggledItemStrokeColor', toggledItemStrokeColor));
      }

      properties.add(
          DoubleProperty('toggledItemStrokeWidth', toggledItemStrokeWidth));
      properties.add(DoubleProperty('toggledItemOpacity', toggledItemOpacity));
    } else {
      properties.add(DiagnosticsProperty<Size>('segmentSize', segmentSize));
      properties.add(EnumProperty<MapLegendLabelsPlacement>(
          'labelsPlacement', labelsPlacement));
      properties.add(EnumProperty<MapLegendEdgeLabelsPlacement>(
          'edgeLabelsPlacement', edgeLabelsPlacement));
      properties.add(
          EnumProperty<MapLabelOverflow>('labelOverflowMode', labelOverflow));
      properties.add(EnumProperty<MapLegendPaintingStyle>(
          'segmentPaintingStyle', segmentPaintingStyle));
    }
  }
}

/// Represents the class for legend widget.
class Legend extends StatefulWidget {
  /// Constructor of [SfLegendWidget].
  const Legend({
    Key? key,
    this.colorMappers,
    this.dataSource,
    required this.legend,
    required this.pointerController,
    required this.child,
    required this.themeData,
    this.controller,
  })  : assert(colorMappers != null || dataSource != null),
        super(key: key);

  // Collection of [MapColorMapper] which specifies map color based
  /// on the data.
  final List<MapColorMapper>? colorMappers;

  /// Internal grouped data.
  final Map<String, MapModel>? dataSource;

  /// Specifies the legend properties.
  final MapLegend legend;

  /// Specifies the pointer controller.
  final PointerController pointerController;

  /// Specifies the child of the legend.
  final Widget child;

  /// Specifies the maps controller class.
  final MapController? controller;

  /// Specifies the maps theme data.
  final SfMapsThemeData themeData;

  @override
  State<Legend> createState() => _LegendState();
}

class _LegendState extends State<Legend> {
  List<int>? _toggledIndices;

  /// Generates the list of legend items based on the data source.
  List<LegendItem> _getLegendItems() {
    final List<LegendItem> legendItems = <LegendItem>[];
    final bool isLegendForBubbles = widget.legend.source == MapElement.bubble;

    if (widget.colorMappers != null && widget.colorMappers!.isNotEmpty) {
      // The legend items calculated based on color mappers.
      final int length = widget.colorMappers!.length;
      for (int index = 0; index < length; index++) {
        final MapColorMapper colorMapper = widget.colorMappers![index];

        if (widget.legend._type == _LegendType.bar &&
            widget.legend.labelsPlacement ==
                MapLegendLabelsPlacement.betweenItems) {
          if (index == 0) {
            final String startValue = _getStartSegmentLabel(colorMapper);
            legendItems
                .add(LegendItem(text: startValue, color: colorMapper.color));
          } else {
            final String text = colorMapper.text ??
                colorMapper.value ??
                colorMapper.to.toString();
            legendItems.add(LegendItem(text: text, color: colorMapper.color));
          }
        } else {
          final String text = colorMapper.text ??
              colorMapper.value ??
              '${colorMapper.from} - ${colorMapper.to}';
          legendItems.add(LegendItem(text: text, color: colorMapper.color));
        }
      }
    } else if (widget.dataSource != null && widget.dataSource!.isNotEmpty) {
      widget.dataSource!.forEach((String key, MapModel mapModel) {
        legendItems.add(
          LegendItem(
            text: mapModel.primaryKey,
            color: isLegendForBubbles
                ? mapModel.bubbleColor ?? widget.themeData.bubbleColor
                : mapModel.shapeColor ?? widget.themeData.layerColor,
          ),
        );
      });
    }

    return legendItems;
  }

  String _getStartSegmentLabel(MapColorMapper colorMapper) {
    String startText;
    if (colorMapper.from != null &&
        colorMapper.text != null &&
        colorMapper.text!.isNotEmpty &&
        colorMapper.text![0] == '{') {
      startText = colorMapper.text!;
    } else if (colorMapper.from != null &&
        colorMapper.text != null &&
        colorMapper.text!.isNotEmpty) {
      startText = '{${colorMapper.from}},{${colorMapper.text}}';
    } else {
      if (colorMapper.from != null) {
        startText = '{${colorMapper.from}},{${colorMapper.to}}';
      } else {
        startText = colorMapper.text ?? colorMapper.value!;
      }
    }
    return startText;
  }

  MapLegendLabelsPlacement _getActualLabelsPlacement() {
    if (widget.legend.labelsPlacement != null) {
      return widget.legend.labelsPlacement!;
    }

    if (widget.colorMappers != null && widget.colorMappers!.isNotEmpty) {
      return widget.colorMappers![0].from != null
          ? MapLegendLabelsPlacement.betweenItems
          : MapLegendLabelsPlacement.onItem;
    }

    return MapLegendLabelsPlacement.onItem;
  }

  LegendPaintingStyle _getEffectiveSegmentPaintingStyle(
      MapLegendPaintingStyle paintingStyle) {
    switch (paintingStyle) {
      case MapLegendPaintingStyle.solid:
        return LegendPaintingStyle.solid;
      case MapLegendPaintingStyle.gradient:
        return LegendPaintingStyle.gradient;
    }
  }

  LegendLabelOverflow _getEffectiveLabelOverflow(
      MapLabelOverflow labelOverflow) {
    switch (labelOverflow) {
      case MapLabelOverflow.visible:
        return LegendLabelOverflow.visible;
      case MapLabelOverflow.hide:
        return LegendLabelOverflow.hide;
      case MapLabelOverflow.ellipsis:
        return LegendLabelOverflow.ellipsis;
    }
  }

  LegendEdgeLabelsPlacement _getEffectiveEdgeLabelsPlacement(
      MapLegendEdgeLabelsPlacement edgeLabelsPlacement) {
    switch (edgeLabelsPlacement) {
      case MapLegendEdgeLabelsPlacement.center:
        return LegendEdgeLabelsPlacement.center;
      case MapLegendEdgeLabelsPlacement.inside:
        return LegendEdgeLabelsPlacement.inside;
    }
  }

  LegendLabelsPlacement _getEffectiveLabelPlacement(
      MapLegendLabelsPlacement labelsPlacement) {
    switch (labelsPlacement) {
      case MapLegendLabelsPlacement.betweenItems:
        return LegendLabelsPlacement.betweenItems;
      case MapLegendLabelsPlacement.onItem:
        return LegendLabelsPlacement.onItem;
    }
  }

  LegendPosition _getEffectivePosition(MapLegendPosition position) {
    switch (position) {
      case MapLegendPosition.top:
        return LegendPosition.top;
      case MapLegendPosition.bottom:
        return LegendPosition.bottom;
      case MapLegendPosition.left:
        return LegendPosition.left;
      case MapLegendPosition.right:
        return LegendPosition.right;
    }
  }

  LegendOverflowMode _getEffectiveOverflowMode(
      MapLegendOverflowMode overflowMode) {
    switch (overflowMode) {
      case MapLegendOverflowMode.scroll:
        return LegendOverflowMode.scroll;
      case MapLegendOverflowMode.wrap:
        return LegendOverflowMode.wrap;
    }
  }

  ShapeMarkerType _getEffectiveLegendIconType(MapIconType iconType) {
    switch (iconType) {
      case MapIconType.circle:
        return ShapeMarkerType.circle;
      case MapIconType.diamond:
        return ShapeMarkerType.diamond;
      case MapIconType.triangle:
        return ShapeMarkerType.triangle;
      case MapIconType.rectangle:
        return ShapeMarkerType.rectangle;
    }
  }

  @override
  void initState() {
    _toggledIndices = <int>[];
    super.initState();
  }

  @override
  void didUpdateWidget(Legend oldWidget) {
    if (oldWidget.legend.source != widget.legend.source ||
        oldWidget.legend._type != widget.legend._type) {
      _toggledIndices?.clear();
      widget.controller!
        ..toggledIndices.clear()
        ..currentToggledItemIndex = -1;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _toggledIndices?.clear();
    _toggledIndices = null;
    super.dispose();
  }

  Color? _getEffectiveToggledItemColor() {
    if (widget.themeData.toggledItemColor != Colors.transparent) {
      return widget.themeData.toggledItemColor!
          .withOpacity(widget.legend.toggledItemOpacity);
    }
    return widget.themeData.toggledItemColor;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.legend._type) {
      case _LegendType.vector:
        return SfLegend(
          shouldAlwaysShowScrollbar: widget.legend.shouldAlwaysShowScrollbar,
          items: _getLegendItems(),
          title: widget.legend.title,
          direction: widget.legend.direction,
          offset: widget.legend.offset,
          padding: widget.legend.padding,
          position: _getEffectivePosition(widget.legend.position),
          overflowMode: _getEffectiveOverflowMode(widget.legend.overflowMode),
          itemSpacing: widget.legend.spacing,
          textStyle: widget.themeData.legendTextStyle,
          iconType: _getEffectiveLegendIconType(widget.legend.iconType),
          iconSize: widget.legend.iconSize,
          toggledIndices: _toggledIndices,
          onToggledIndicesChanged: widget.legend.enableToggleInteraction
              ? (List<int> indices, int currentIndex) {
                  setState(() {
                    widget.controller!.toggledIndices.clear();
                    widget.controller!.toggledIndices.addAll(indices);
                    widget.controller!.currentToggledItemIndex = currentIndex;
                    _toggledIndices = indices;
                  });
                }
              : null,
          toggledIconColor: _getEffectiveToggledItemColor(),
          toggledTextOpacity: widget.legend.toggledItemOpacity,
          child: widget.child,
        );
      case _LegendType.bar:
        return SfLegend.bar(
          items: _getLegendItems(),
          title: widget.legend.title,
          shouldAlwaysShowScrollbar: widget.legend.shouldAlwaysShowScrollbar,
          position: _getEffectivePosition(widget.legend.position),
          overflowMode: _getEffectiveOverflowMode(widget.legend.overflowMode),
          itemSpacing: widget.legend.spacing,
          direction: widget.legend.direction,
          offset: widget.legend.offset,
          padding: widget.legend.padding,
          textStyle: widget.themeData.legendTextStyle,
          labelsPlacement:
              _getEffectiveLabelPlacement(_getActualLabelsPlacement()),
          edgeLabelsPlacement: _getEffectiveEdgeLabelsPlacement(
              widget.legend.edgeLabelsPlacement),
          labelOverflow:
              _getEffectiveLabelOverflow(widget.legend.labelOverflow),
          segmentSize: widget.legend.segmentSize,
          segmentPaintingStyle: _getEffectiveSegmentPaintingStyle(
              widget.legend.segmentPaintingStyle),
          pointerBuilder: widget.legend.pointerBuilder,
          pointerColor: widget.legend.pointerColor,
          pointerSize: widget.legend.showPointerOnHover
              ? widget.legend.pointerSize
              : Size.zero,
          pointerController: widget.pointerController,
          child: widget.child,
        );
    }
  }
}
