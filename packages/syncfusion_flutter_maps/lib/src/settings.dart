import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../maps.dart';

/// Signature used by the [MapShapeLayer.loadingBuilder].
typedef MapLoadingBuilder = Widget Function(BuildContext context);

/// Signature to return the string values from the data source
/// based on the index.
typedef IndexedStringValueMapper = String Function(int index);

/// Signature to return the double values from the data source
/// based on the index.
typedef IndexedDoubleValueMapper = double? Function(int index);

/// Signature to return the colors or other types from the data source based on
/// the index based on which colors will be applied.
typedef IndexedColorValueMapper = dynamic Function(int index);

/// Signature to return the [MapMarker].
typedef MapMarkerBuilder = MapMarker Function(BuildContext context, int index);

/// Signature for a [MapLayer.onWillZoom] callback which returns true or false
/// based on which current zooming completes.
typedef WillZoomCallback = bool Function(MapZoomDetails);

/// Signature for a [MapLayer.onWillPan]  callback which returns true or false
/// based on which current panning completes.
typedef WillPanCallback = bool Function(MapPanDetails);

/// Customizes the shape or bubble color based on the data source and sets the
/// text and icon color for legend items.
///
/// [MapShapeSource.shapeColorMappers] and
/// [MapShapeSource.bubbleColorMappers] accepts collection of
/// [MapColorMapper].
///
/// [MapShapeSource.shapeColorValueMapper] and
/// [MapShapeSource.bubbleColorValueMapper] returns a color or value
/// based on which shape or bubble color will be updated.
///
/// If they return a color, then this color will be applied to the shapes or
/// bubbles straightaway.
///
/// If they return a value other than the color, then you must set the
/// [MapShapeSource.shapeColorMappers] or
/// [MapShapeSource.bubbleColorMappers] property.
///
/// The value returned from the [MapShapeSource.shapeColorValueMapper]
/// and [MapShapeSource.bubbleColorValueMapper] will be used for the
/// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
/// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
/// the respective shape or bubble.
///
/// Legend icon's color and text will be taken from [MapColorMapper.color] or
/// [MapColorMapper.text] respectively.
///
/// The below code snippet represents how color can be applied to the shape
/// based on the [MapColorMapper.value] property of [MapColorMapper].
///
/// ```dart
/// late List<Model> _data;
/// late MapShapeSource _mapSource;
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
/// late List<Model> _data;
/// late MapShapeSource _mapSource;
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
///
/// See also:
/// * [MapShapeSource.shapeColorValueMapper] and
/// [MapShapeSource.shapeColorMappers], to customize the shape colors
/// based on the data.
/// * [MapShapeSource.bubbleColorValueMapper] and
/// [MapShapeSource.bubbleColorMappers], to customize the shape colors
/// based on the data.
@immutable
class MapColorMapper {
  /// Creates a [MapColorMapper].
  const MapColorMapper({
    this.from,
    this.to,
    this.value,
    required this.color,
    this.minOpacity,
    this.maxOpacity,
    this.text,
  })  : assert((from == null && to == null) ||
            (from != null && to != null && from < to && to > from)),
        assert(minOpacity == null || minOpacity != 0),
        assert(maxOpacity == null || maxOpacity != 0);

  /// Sets the range start for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///
  /// See also:
  /// * [to], to set the range end for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double? from;

  /// Sets the range end for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///
  /// See also:
  /// * [from], to set the range start for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double? to;

  /// Sets the value for the equal color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] is equal to this [value].
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///
  /// See also:
  /// * [color], to set the color for the shape or bubble.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final String? value;

  /// Specifies the color applies to the shape or bubble based on the value.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///
  /// See also:
  /// * [from], to set the range start for the range color mapping.
  /// * [to], to set the range end for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final Color color;

  /// Specifies the minimum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///         MapColorMapper(
  ///           value: "Low",
  ///           color: Colors.red,
  ///           minOpacity: 0.3,
  ///           maxOpacity: 0.7),
  ///         MapColorMapper(
  ///           value: "High",
  ///           color: Colors.green,
  ///           minOpacity: 0.5,
  ///           maxOpacity: 0.9)
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
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double? minOpacity;

  /// Specifies the maximum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///         MapColorMapper(
  ///           value: "Low",
  ///           color: Colors.red,
  ///           minOpacity: 0.3,
  ///           maxOpacity: 0.7),
  ///         MapColorMapper(
  ///           value: "High",
  ///           color: Colors.green,
  ///           minOpacity: 0.5,
  ///           maxOpacity: 0.9)
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
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double? maxOpacity;

  /// Specifies the text to be used for the legend item.
  ///
  /// By default, [MapColorMapper.from] and [MapColorMapper.to] or
  /// [MapColorMapper.value] will be used as the text of the legend item.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///         MapColorMapper(value: "Low", color: Colors.red, text: 'Low+'),
  ///         MapColorMapper(value: "High", color: Colors.green, text: 'High+')
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
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.

  final String? text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapColorMapper &&
        other.from == from &&
        other.to == to &&
        other.value == value &&
        other.color == color &&
        other.minOpacity == minOpacity &&
        other.maxOpacity == maxOpacity &&
        other.text == text;
  }

  @override
  int get hashCode =>
      Object.hash(from, to, value, color, minOpacity, maxOpacity, text);
}

/// Customizes the appearance of the data labels.
///
/// It is possible to customize the style of the data labels, hide or trim the
/// data labels when it exceeds their respective shapes.
///
/// ```dart
/// late List<Model> _data;
/// late MapShapeSource _mapSource;
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
///           dataLabelSettings:
///                MapDataLabelSettings(
///                    textStyle: TextStyle(color: Colors.red)
///                ),
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
@immutable
class MapDataLabelSettings extends DiagnosticableTree {
  /// Creates a [MapDataLabelSettings].
  const MapDataLabelSettings({
    this.textStyle,
    this.overflowMode = MapLabelOverflow.visible,
  });

  /// Customizes the data label's text style.
  ///
  /// This snippet shows how to set [textStyle] for the data labels in [SfMaps].
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///           dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    textStyle: TextStyle(color: Colors.red)
  ///                ),
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
  final TextStyle? textStyle;

  /// Trims or removes the data label when it is overflowed from the shape.
  ///
  /// Defaults to [MapLabelOverflow.visible].
  ///
  /// By default, the data labels will render even if it overflows form the
  /// shape. Using this property, it is possible to remove or trim the data
  /// labels based on the available space in the shape.
  ///
  /// This snippet shows how to set the [overflowMode] for the data labels in
  /// [SfMaps].
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///           dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    overflowMode: MapLabelOverflow.hide
  ///                ),
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
  final MapLabelOverflow overflowMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapDataLabelSettings &&
        other.textStyle == textStyle &&
        other.overflowMode == overflowMode;
  }

  @override
  int get hashCode => Object.hash(textStyle, overflowMode);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (textStyle != null) {
      properties.add(textStyle!.toDiagnosticsNode(name: 'textStyle'));
    }
    properties
        .add(EnumProperty<MapLabelOverflow>('overflowMode', overflowMode));
  }
}

/// Customizes the appearance of the bubbles.
///
/// It is possible to customize the radius, color, opacity and stroke of the
/// bubbles.
///
/// ```dart
/// late List<Model> _data;
/// late MapShapeSource _mapSource;
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
///        return _data[index].count;
///      },
///    );
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: _mapSource,
///          bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
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
@immutable
class MapBubbleSettings extends DiagnosticableTree {
  /// Creates a [MapBubbleSettings].
  const MapBubbleSettings({
    this.minRadius = 10.0,
    this.maxRadius = 50.0,
    this.color,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Minimum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeSource.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///        return _data[index].count;
  ///      },
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
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
  final double minRadius;

  /// Maximum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeSource.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///        return _data[index].count;
  ///      },
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
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
  final double maxRadius;

  /// Default color of the bubbles.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///        return _data[index].count;
  ///      },
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleSettings: MapBubbleSettings(color: Colors.red),
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
  ///
  /// See also:
  /// * [MapShapeSource.bubbleColorMappers] and
  /// [MapShapeSource.bubbleColorValueMapper], to customize the bubble
  /// colors based on the data.
  final Color? color;

  /// Stroke width of the bubbles.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///        return _data[index].count;
  ///      },
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleSettings: MapBubbleSettings(
  ///             strokeWidth: 2.0,
  ///             strokeColor: Colors.red,
  ///          ),
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
  ///
  /// See also:
  /// * [strokeColor], to set the stroke color.
  final double? strokeWidth;

  /// Stroke color of the bubbles.
  ///
  /// ```dart
  /// late List<Model> _data;
  /// late MapShapeSource _mapSource;
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
  ///        return _data[index].count;
  ///      },
  ///    );
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: _mapSource,
  ///          bubbleSettings: MapBubbleSettings(
  ///             strokeWidth: 2.0,
  ///             strokeColor: Colors.red,
  ///          ),
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
  ///
  /// See also:
  /// * [strokeWidth], to set the stroke width.
  final Color? strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapBubbleSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.minRadius == minRadius &&
        other.maxRadius == maxRadius;
  }

  @override
  int get hashCode =>
      Object.hash(color, strokeWidth, strokeColor, maxRadius, minRadius);

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapBubbleSettings copyWith({
    double? minRadius,
    double? maxRadius,
    Color? color,
    double? strokeWidth,
    Color? strokeColor,
  }) {
    return MapBubbleSettings(
      minRadius: minRadius ?? this.minRadius,
      maxRadius: maxRadius ?? this.maxRadius,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    properties.add(DoubleProperty('strokeWidth', strokeWidth));

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    properties.add(DoubleProperty('minRadius', minRadius));
    properties.add(DoubleProperty('maxRadius', maxRadius));
  }
}

/// Customizes the appearance of the selected shape.
///
/// ```dart
/// late List<DataModel> _data;
/// late MapShapeSource _mapSource;
/// int _selectedIndex = -1;
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
///                         color: Colors.black),
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
@immutable
class MapSelectionSettings extends DiagnosticableTree {
  /// Creates a [MapSelectionSettings].
  const MapSelectionSettings({this.color, this.strokeColor, this.strokeWidth});

  /// Fills the selected shape by this color.
  ///
  /// This snippet shows how to set selection color in [SfMaps].
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
  /// int _selectedIndex = -1;
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
  ///                         color: Colors.black),
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
  /// See also:
  /// * [strokeColor], to set stroke color for selected shape.
  final Color? color;

  /// Applies stroke color for the selected shape.
  ///
  /// This snippet shows how to set stroke color for the selected shape.
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
  /// int _selectedIndex = -1;
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
  ///                         strokeColor: Colors.white,
  ///                         strokeWidth: 2.0,
  ///                     ),
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
  /// See also:
  /// * [Color], to set selected shape color.
  final Color? strokeColor;

  /// Stroke width which applies to the selected shape.
  ///
  /// This snippet shows how to set stroke width for the selected shape.
  ///
  /// ```dart
  /// late List<DataModel> _data;
  /// late MapShapeSource _mapSource;
  /// int _selectedIndex = -1;
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
  ///                         strokeColor: Colors.white,
  ///                         strokeWidth: 2.0,
  ///                     ),
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
  final double? strokeWidth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapSelectionSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor;
  }

  @override
  int get hashCode => Object.hash(color, strokeWidth, strokeColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }
  }
}

/// Customizes the appearance of the bubble's or shape's tooltip.
///
/// ```dart
/// late MapShapeSource _mapSource;
/// late List<Model> _data;
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
///              tooltipSettings: MapTooltipSettings(color: Colors.red),
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
///
/// See also:
/// * [MapShapeLayer.shapeTooltipBuilder], for showing the completely
/// customized widget inside the tooltip.
@immutable
class MapTooltipSettings extends DiagnosticableTree {
  /// Creates a [MapTooltipSettings].
  const MapTooltipSettings({
    this.hideDelay = 3.0,
    this.color,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Specifies the duration of the tooltip visibility.
  ///
  /// The default value of the [hideDelay] property is 3.
  ///
  /// By default, the tooltip will disappear after 3 seconds of inactivity. You
  /// can always show the tooltip without hiding it by setting double.infinity
  /// to the [hideDelay] property.
  ///
  /// When you perform a zoom/pan operation, a window resize, or a change of
  /// orientation, the tooltip will disappear.
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<DataModel> _data;
  ///
  /// @override
  /// void initState() {
  ///   _data = <DataModel>[
  ///     DataModel('Asia', '44,579,000 sq. km.'),
  ///     DataModel('Africa', '30,370,000 sq. km.'),
  ///     DataModel('Europe', '10,180,000 sq. km.'),
  ///     DataModel('North America', '24,709,000 sq. km.'),
  ///     DataModel('South America', '17,840,000 sq. km.'),
  ///     DataModel('Australia', '8,600,000 sq. km.'),
  ///   ];
  ///
  ///   _mapSource = MapShapeSource.asset(
  ///     "assets/world_map.json",
  ///     shapeDataField: "continent",
  ///     dataCount: _data.length,
  ///     primaryValueMapper: (int index) => _data[index].continent,
  ///   );
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMaps(
  ///       layers: <MapLayer>[
  ///         MapShapeLayer(
  ///           source: _mapSource,
  ///           tooltipSettings: MapTooltipSettings(
  ///             hideDelay: double.infinity,
  ///           ),
  ///           shapeTooltipBuilder: (BuildContext context, int index) {
  ///             if (index == 0) {
  ///               return Icon(Icons.airplanemode_inactive);
  ///             } else {
  ///               return Icon(Icons.airplanemode_active);
  ///             }
  ///           },
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class DataModel {
  ///   const DataModel(this.continent, this.area);
  ///
  ///   final String continent;
  ///   final String area;
  /// }
  /// ```
  final double hideDelay;

  /// Fills the tooltip by this color.
  ///
  /// This snippet shows how to set the tooltip color in [SfMaps].
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<Model> _data;
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
  ///              tooltipSettings: MapTooltipSettings(color: Colors.red),
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
  /// See also:
  /// * [strokeColor], for customizing the stroke color of the tooltip.
  /// * [strokeWidth] for customizing the stroke width of the tooltip.
  final Color? color;

  /// Specifies the stroke width applies to the tooltip.
  ///
  /// This snippet shows how to customize the stroke width in [SfMaps].
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<Model> _data;
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
  ///              tooltipSettings: MapTooltipSettings(
  ///                strokeWidth: 2.0,
  ///                strokeColor: Colors.black,
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
  /// * [strokeColor], for customizing the stroke color of the tooltip.
  final double? strokeWidth;

  /// Specifies the stroke color applies to the tooltip.
  ///
  /// This snippet shows how to customize stroke color in [SfMaps].
  ///
  /// ```dart
  /// late MapShapeSource _mapSource;
  /// late List<Model> _data;
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
  ///              tooltipSettings: MapTooltipSettings(
  ///                strokeWidth: 2.0,
  ///                strokeColor: Colors.black,
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
  ///
  /// See also:
  /// * [strokeWidth] for customizing the stroke width of the tooltip.
  final Color? strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapTooltipSettings &&
        other.hideDelay == hideDelay &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor;
  }

  @override
  int get hashCode => Object.hash(hideDelay, color, strokeWidth, strokeColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('hideDelay', hideDelay));
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    properties.add(DoubleProperty('strokeWidth', strokeWidth));

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }
  }
}

/// Provides options for customizing the appearance of the toolbar in the web
/// platform.
///
/// ```dart
///  late MapZoomPanBehavior _zoomPanBehavior;
///  late MapShapeSource _mapSource;
///
///   @override
///   void initState() {
///     _mapSource = MapShapeSource.asset(
///       'assets/world_map.json',
///       shapeDataField: 'continent',
///     );
///     _zoomPanBehavior = MapZoomPanBehavior()
///       ..zoomLevel = 4
///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
///       ..toolbarSettings = MapToolbarSettings();
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
class MapToolbarSettings extends DiagnosticableTree {
  /// Creates a [MapToolbarSettings].
  const MapToolbarSettings({
    this.iconColor,
    this.itemBackgroundColor,
    this.itemHoverColor,
    this.direction = Axis.horizontal,
    this.position = MapToolbarPosition.topRight,
  });

  /// Specifies the color applies to the tooltip icons.
  ///
  ///```dart
  ///  late MapZoomPanBehavior _zoomPanBehavior;
  ///  late MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
  ///       ..toolbarSettings = MapToolbarSettings(iconColor: Colors.blue);
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
  final Color? iconColor;

  /// Specifies the color applies to the tooltip icon's background.
  ///
  ///```dart
  /// late MapZoomPanBehavior _zoomPanBehavior;
  /// late MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
  ///       ..toolbarSettings = MapToolbarSettings(
  ///           itemBackgroundColor: Colors.blue);
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
  final Color? itemBackgroundColor;

  /// Specifies the color applies to the tooltip icon's background on hovering.
  ///
  ///```dart
  /// late MapZoomPanBehavior _zoomPanBehavior;
  /// late MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
  ///       ..toolbarSettings = MapToolbarSettings(
  ///           itemHoverColor: Colors.red);
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
  final Color? itemHoverColor;

  /// Arranges the toolbar items in either horizontal or vertical direction.
  ///
  /// Defaults to [Axis.horizontal].
  ///
  ///```dart
  /// late MapZoomPanBehavior _zoomPanBehavior;
  /// late MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
  ///       ..toolbarSettings = MapToolbarSettings(
  ///           direction: Axis.vertical);
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
  final Axis direction;

  /// Option to position the toolbar in all the corners of the maps.
  ///
  /// Defaults to [MapToolbarPosition.topRight].
  ///
  ///```dart
  /// late MapZoomPanBehavior _zoomPanBehavior;
  /// late MapShapeSource _mapSource;
  ///
  ///   @override
  ///   void initState() {
  ///     _mapSource = MapShapeSource.asset(
  ///       'assets/world_map.json',
  ///       shapeDataField: 'continent',
  ///     );
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559)
  ///       ..toolbarSettings = MapToolbarSettings(
  ///           position: MapToolbarPosition.topRight);
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
  final MapToolbarPosition position;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (iconColor != null) {
      properties.add(ColorProperty('iconColor', iconColor));
    }
    if (itemBackgroundColor != null) {
      properties.add(ColorProperty('itemBackgroundColor', itemBackgroundColor));
    }

    if (itemHoverColor != null) {
      properties.add(ColorProperty('itemHoverColor', itemHoverColor));
    }
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<MapToolbarPosition>('position', position));
  }
}
