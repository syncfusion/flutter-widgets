import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../treemap.dart';

enum _MapLegendType { vector, bar }

/// Positions the legend in the different directions.
enum TreemapLegendPosition {
  /// Places the legend at left to the tree map area.
  left,

  /// Places the legend at right to the tree map area.
  right,

  /// Places the legend at top of the tree map area.
  top,

  /// Places the legend at bottom of the tree map area.
  bottom,
}

/// Shapes of the legend's and marker's icon.
enum TreemapIconType {
  /// Legend's and marker's icon will be drawn in the circle shape.
  circle,

  /// Legend's and marker's icon will be drawn in the rectangle shape.
  rectangle,

  /// Legend's and marker's icon will be drawn in the triangle shape.
  triangle,

  /// Legend's and marker's icon will be drawn in the diamond shape.
  diamond,
}

/// Behavior of the legend items when it overflows.
enum TreemapLegendOverflowMode {
  /// It will place all the legend items in single line and enables scrolling.
  scroll,

  /// It will wrap and place the remaining legend items to next line.
  wrap,
}

/// Behavior of the labels when it overflowed from the shape.
enum TreemapLabelOverflow {
  /// It hides the overflowed labels.
  hide,

  /// It does not make any change even if the labels overflowed.
  visible,

  /// It trims the labels based on the available space in their respective
  /// legend item.
  ellipsis
}

/// Option to place the labels either between the bars or on the bar in bar
/// legend.
enum TreemapLegendLabelsPlacement {
  /// [TreemapLegendLabelsPlacement.Item] places labels in the center
  /// of the bar.
  onItem,

  /// [TreemapLegendLabelsPlacement.betweenItems] places labels
  /// in-between two bars.
  betweenItems
}

/// Placement of edge labels in the bar legend.
enum TreemapLegendEdgeLabelsPlacement {
  /// Places the edge labels in inside of the legend items.
  inside,

  /// Place the edge labels in the center of the starting position of the
  /// legend bars.
  center
}

/// Applies gradient or solid color for the bar segments.
enum TreemapLegendPaintingStyle {
  /// Applies solid color for bar segments.
  solid,

  /// Applies gradient color for bar segments.
  gradient
}

/// Shows legend for the data rendered in the treemap.
///
/// By default, legend will not be shown.
///
/// If [SfTreemap.colorMappers] is null, then the legend items' icon color and
/// legend item's text will be applied based on the value of
/// [TreemapLevel.color] and the values returned from the
/// [TreemapLevel.groupMapper] callback of first [TreemapLevel] added in the
/// [SfTreemap.levels] collection.
///
/// If [SfTreemap.colorMappers] is not null and [TreemapColorMapper.value]
/// constructor is used, the legend item's icon color will be applied based on
/// the [TreemapColorMapper.color] property and the legend text applied based
/// on the [TreemapColorMapper.value] property.
///
/// And, when using [TreemapColorMapper.range] constructor, the legend item's
/// icon color will be applied based on the [TreemapColorMapper.color]
/// property and the legend text will be applied based on the
/// [TreemapColorMapper.name] property. If the
/// [TreemapColorMapper.name] property is null, then the text will
/// be applied based on the [TreemapColorMapper.from] and
/// [TreemapColorMapper.to] properties
///
/// The below code snippet represents how to setting default legend
/// to the tree map.
///
/// ```dart
/// List<SocialMediaUsers> _source;
///
/// @override
/// void initState() {
///   _source = <SocialMediaUsers>[
///     SocialMediaUsers('India', 'Facebook', 280),
///     SocialMediaUsers('India', 'Instagram', 88),
///     SocialMediaUsers('USA', 'Facebook', 190),
///     SocialMediaUsers('USA', 'Instagram', 120),
///     SocialMediaUsers('Japan', 'Twitter', 48),
///     SocialMediaUsers('Japan', 'Instagram', 31),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemap(
///       dataCount: _source.length,
///       weightValueMapper: (int index) {
///         return _source[index].usersInMillions;
///       },
///       levels: [
///         TreemapLevel(
///           groupMapper: (int index) {
///             return _source[index].country;
///           },
///         ),
///       ],
///       legend: TreemapLegend(),
///     ),
///   );
/// }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// The below code snippet represents how to setting bar legend
/// to the tree map.
///
/// ```dart
/// List<SocialMediaUsers> _source;
///
/// @override
/// void initState() {
///   _source = <SocialMediaUsers>[
///     SocialMediaUsers('India', 'Facebook', 280),
///     SocialMediaUsers('India', 'Instagram', 88),
///     SocialMediaUsers('USA', 'Facebook', 190),
///     SocialMediaUsers('USA', 'Instagram', 120),
///     SocialMediaUsers('Japan', 'Twitter', 48),
///     SocialMediaUsers('Japan', 'Instagram', 31),
///   ];
///   super.initState();
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemap(
///       dataCount: _source.length,
///       weightValueMapper: (int index) {
///         return _source[index].usersInMillions;
///       },
///       levels: [
///         TreemapLevel(
///           groupMapper: (int index) {
///             return _source[index].country;
///           },
///         ),
///       ],
///       legend: TreemapLegend.bar(),
///     ),
///   );
/// }
///
/// class SocialMediaUsers {
///   const SocialMediaUsers(
///     this.country,
///     this.socialMedia,
///     this.usersInMillions,
///   );
///   final String country;
///   final String socialMedia;
///   final double usersInMillions;
/// }
/// ```
///
/// See also:
/// * To render bar legend, refer [TreemapLegend.bar] constructor.
@immutable
class TreemapLegend extends DiagnosticableTree {
  /// Provides additional information about the data rendered in the tree map by
  /// initializing the [SfTreemap.legend] property.
  ///
  /// Defaults to `null`.
  ///
  /// By default, legend will not be shown.
  ///
  /// If [SfTreemap.colorMappers] is null, then the legend items's icon color
  /// and legend item's text applied based on the value of [TreemapLevel.color]
  /// and the [TreemapLevel.groupMapper] properties of first [TreemapLevel]
  /// added in the [SfTreemap.levels] collection respectively.
  ///
  /// If [SfTreemap.colorMappers] is not null and using
  /// TreemapColorMapper.value() constructor, the legend item's icon color
  /// applied based on the [TreemapColorMapper.color] property and the legend
  ///  text applied based on the [TreemapColorMapper.value] property.
  ///
  /// When using [TreemapColorMapper.range] constructor, the legend item's icon
  /// color applied based on the [TreemapColorMapper.color] property and the
  /// legend text applied based on the [TreemapColorMapper.name]
  /// property. If the [TreemapColorMapper.name] property is null,
  /// then the text applied based on the [TreemapColorMapper.from] and
  /// [TreemapColorMapper.to] properties.
  ///
  /// The below code snippet represents how to create default legend to
  /// the tree map.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapLegend.bar] named constructor, for bar legend type.
  const TreemapLegend({
    this.title,
    this.position = TreemapLegendPosition.top,
    this.offset,
    this.overflowMode = TreemapLegendOverflowMode.wrap,
    this.direction,
    this.padding = const EdgeInsets.all(10.0),
    this.spacing = 10.0,
    this.textStyle,
    TreemapIconType iconType = TreemapIconType.circle,
    Size iconSize = const Size(8.0, 8.0),
  })  : _legendType = _MapLegendType.vector,
        _iconType = iconType,
        _iconSize = iconSize,
        _segmentSize = null,
        _labelsPlacement = null,
        _edgeLabelsPlacement = null,
        _labelOverflow = null,
        _segmentPaintingStyle = null,
        assert(spacing >= 0);

  /// Creates a bar type legend for the tree map.
  ///
  /// Information provided in the legend helps to identify the data rendered in
  /// the tree map.
  ///
  /// Defaults to `null`.
  ///
  /// By default, legend will not be shown.
  ///
  /// * labelsPlacement - Places the labels either between the bar items or on
  /// the items. By default, labels placement will be
  /// [TreemapLegendLabelsPlacement.betweenItems] when setting range color
  /// mapping [TreemapColorMapper] without setting
  /// [TreemapColorMapper.name] property. In all other cases, it will
  /// be [TreemapLegendLabelsPlacement.onItem].
  ///
  /// * edgeLabelsPlacement - Places the edge labels either inside or at
  /// center of the edges. It doesn't work with
  /// [TreemapLegendLabelsPlacement.betweenItems]. Defaults to
  /// [TreemapLegendEdgeLabelsPlacement.inside].
  ///
  /// * segmentPaintingStyle - Option for setting solid or gradient color for
  /// the bar. To enable the gradient, set this as
  /// [TreemapLegendPaintingStyle.gradient]. Defaults to
  /// [TreemapLegendPaintingStyle.solid].
  ///
  /// * labelOverflow - Option to trim or remove the legend item's text when
  /// it is overflowed. Defaults to [TreemapLabelOverflow.hide].
  ///
  /// List<SocialMediaUsers> _source;
  ///
  /// ```dart
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(),
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  ///   const SocialMediaUsers(
  ///     this.country,
  ///     this.socialMedia,
  ///     this.usersInMillions,
  ///   );
  ///   final String country;
  ///   final String socialMedia;
  ///   final double usersInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [TreemapLegend], for adding default legend type with different icon
  /// styles like circle, diamond, rectangle and triangle.
  const TreemapLegend.bar({
    this.title,
    this.overflowMode = TreemapLegendOverflowMode.scroll,
    this.padding = const EdgeInsets.all(10.0),
    this.position = TreemapLegendPosition.top,
    this.offset,
    this.spacing = 2.0,
    this.textStyle,
    this.direction,
    Size? segmentSize,
    TreemapLegendLabelsPlacement? labelsPlacement,
    TreemapLegendEdgeLabelsPlacement edgeLabelsPlacement =
        TreemapLegendEdgeLabelsPlacement.inside,
    TreemapLabelOverflow labelOverflow = TreemapLabelOverflow.visible,
    TreemapLegendPaintingStyle segmentPaintingStyle =
        TreemapLegendPaintingStyle.solid,
  })  : _legendType = _MapLegendType.bar,
        _labelsPlacement = labelsPlacement,
        _edgeLabelsPlacement = edgeLabelsPlacement,
        _labelOverflow = labelOverflow,
        _segmentPaintingStyle = segmentPaintingStyle,
        _segmentSize = segmentSize,
        _iconType = null,
        _iconSize = null,
        assert(spacing >= 0);

  /// Enables a title for the legends to provide a small note about the legends.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         title: const Text('Social media users'),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  final Widget? title;

  /// Sets the padding around the legend.
  ///
  /// Defaults to EdgeInsets.all(10.0).
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         padding: const EdgeInsets.all(20),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  final EdgeInsetsGeometry? padding;

  /// Arranges the legend items in either horizontal or vertical direction.
  ///
  /// Defaults to horizontal, if the [position] is top, bottom.
  /// Defaults to vertical, if the [position] is left or right.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         direction: Axis.vertical,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [position], to change the position of the legend.
  final Axis? direction;

  /// Positions the legend in the different directions.
  ///
  /// Defaults to [TreemapLegendPosition.top].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         position: TreemapLegendPosition.bottom,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class SocialMediaUsers {
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  /// See also:
  /// * [offset], to place the legend in custom position.
  final TreemapLegendPosition position;

  /// Places the legend in custom position.
  ///
  /// If the [offset] has been set and if the [position] is top, then the legend
  /// will be placed in top but in the position additional to the
  /// actual top position. Also, the legend will not take dedicated position for
  /// it and will be drawn on the top of map.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         offset: Offset(150, 150),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
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
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         spacing: 20,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  final double spacing;

  /// Customizes the legend item's text style.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         textStyle: TextStyle(
  ///           color: Colors.red,
  ///           fontSize: 16,
  ///           fontStyle: FontStyle.italic,
  ///         ),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
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
  /// Defaults to [TreemapLegendOverflowMode.wrap] for default legend and
  /// [TreemapLegendOverflowMode.scroll] for bar legend.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         overflowMode: TreemapLegendOverflowMode.scroll,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  /// * [direction], to set the direction of the legend.
  final TreemapLegendOverflowMode overflowMode;

  /// Specifies the shape of the legend icon.
  ///
  /// Defaults to [TreemapIconType.circle].
  ///
  /// ```dart
  ///  List<Population> _source;
  ///
  ///   @override
  ///   void initState() {
  ///     _source = <Population>[
  ///       Population('Asia', 'Thailand', 7.54),
  ///       Population('Africa', 'South Africa', 25.4),
  ///       Population('North America', 'Canada', 13.3),
  ///       Population('South America', 'Chile', 19.11),
  ///       Population('Australia', 'New Zealand', 4.93),
  ///       Population('Europe', 'Czech Republic', 10.65),
  ///     ];
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///    return Scaffold(
  ///       appBar: AppBar(title: Text('Treemap legend')),
  ///       body: SfTreemap.dice(
  ///         dataCount: _source.length,
  ///         weightValueMapper: (int index) {
  ///           return _source[index].populationInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  //             padding: EdgeInsets.only(left: 2.5, right: 2.5),
  ///             groupMapper: (int index) {
  ///               return _source[index].continent;
  ///            },
  ///             color: Colors.teal,
  ///           ),
  ///         ],
  ///         legend: TreemapLegend(
  ///           iconType: TreemapIconType.diamond,
  ///         ),
  ///       ),
  ///     );
  ///   }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [iconSize], to set the size of the icon.
  final TreemapIconType? _iconType;

  /// Customizes the size of the bar segments.
  ///
  /// Defaults to Size(80.0, 12.0).
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(
  ///         segmentSize: Size(60, 18),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  final Size? _segmentSize;

  /// Customizes the size of the icon.
  ///
  /// Defaults to Size(12.0, 12.0).
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       legend: TreemapLegend(
  ///         iconSize: Size(12, 12),
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [iconType], to set shape of the default legend icon.
  final Size? _iconSize;

  /// Place the labels either between the segments or on the segments.
  ///
  /// By default, label placement will be
  /// [TreemapLegendLabelsPlacement.betweenItems] when setting range color
  /// mapper without setting color mapper text property otherwise
  /// label placement will be [TreemapLegendLabelsPlacement.onItem].
  ///
  /// This snippet shows how to set label placement in [SfTreemap].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(
  ///         labelsPlacement: TreemapLegendLabelsPlacement.onItem,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [edgeLabelsPlacement], to place the edge labels either
  /// inside or outside of the bar legend.
  ///
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final TreemapLegendLabelsPlacement? _labelsPlacement;

  /// Place the edge labels either inside or outside of the bar legend.
  ///
  /// [edgeLabelsPlacement] doesn't works with
  /// [TreemapLegendLabelsPlacement.betweenItems].
  ///
  /// Defaults to [TreemapLegendEdgeLabelsPlacement.inside].
  ///
  /// This snippet shows how to set edge label placement in [SfTreemap].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(
  ///         edgeLabelsPlacement: TreemapLegendEdgeLabelsPlacement.center,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final TreemapLegendEdgeLabelsPlacement? _edgeLabelsPlacement;

  /// Trims or removes the legend text when it is overflowed from the
  /// bar legend.
  ///
  /// Defaults to [TreemapLabelOverflow.hide].
  ///
  /// By default, the legend labels will render even if it overflows form the
  /// bar legend. Using this property, it is possible to remove or trim the
  /// legend labels based on the bar legend size.
  ///
  /// This snippet shows how to set the [overflowMode] for the bar legend text
  ///  in [SfTreemap].
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(
  ///         labelOverflow: TreemapLabelOverflow.ellipsis,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
  /// }
  /// ```
  ///
  /// See also:
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final TreemapLabelOverflow? _labelOverflow;

  /// Specifies the type of the legend.
  final _MapLegendType _legendType;

  /// Applies gradient or solid color for the bar segments.
  ///
  /// ```dart
  /// List<SocialMediaUsers> _source;
  ///
  /// @override
  /// void initState() {
  ///   _source = <SocialMediaUsers>[
  ///     SocialMediaUsers('India', 'Facebook', 280),
  ///     SocialMediaUsers('India', 'Instagram', 88),
  ///     SocialMediaUsers('USA', 'Facebook', 190),
  ///     SocialMediaUsers('USA', 'Instagram', 120),
  ///     SocialMediaUsers('Japan', 'Twitter', 48),
  ///     SocialMediaUsers('Japan', 'Instagram', 31),
  ///   ];
  ///   super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemap(
  ///       dataCount: _source.length,
  ///       weightValueMapper: (int index) {
  ///         return _source[index].usersInMillions;
  ///       },
  ///       levels: [
  ///         TreemapLevel(
  ///           groupMapper: (int index) {
  ///             return _source[index].country;
  ///           },
  ///         ),
  ///       ],
  ///       colorMappers: [
  ///         TreemapColorMapper.range(
  ///            0,
  ///            10,
  ///            Colors.red,
  ///            name: '10',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            11,
  ///            20,
  ///            Colors.green,
  ///            name: '20',
  ///         ),
  ///         TreemapColorMapper.range(
  ///            21,
  ///            30,
  ///            Colors.blue,
  ///            name: '30',
  ///         ),
  ///       ],
  ///       legend: TreemapLegend.bar(
  ///         segmentPaintingStyle: TreemapLegendPaintingStyle.gradient,
  ///       ),
  ///     ),
  ///   );
  /// }
  ///
  /// class Population {
  ///   const Population(this.continent, this.country,
  ///               this.populationInMillions);
  ///
  ///   final String country;
  ///   final String continent;
  ///   final double populationInMillions;
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
  final TreemapLegendPaintingStyle? _segmentPaintingStyle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is TreemapLegend && other._legendType != _legendType) {
      return false;
    }

    return other is TreemapLegend &&
        other.padding == padding &&
        other.offset == offset &&
        other.spacing == spacing &&
        other.direction == direction &&
        other.overflowMode == overflowMode &&
        other.position == position &&
        other.textStyle == textStyle &&
        other.title == title;
  }

  @override
  int get hashCode => hashValues(padding, offset, spacing, direction,
      overflowMode, position, textStyle, title);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(EnumProperty<_MapLegendType>('legendType', _legendType));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
    properties.add(DoubleProperty('spacing', spacing));
    if (direction != null) {
      properties.add(EnumProperty<Axis>('direction', direction));
    }

    properties.add(
        EnumProperty<TreemapLegendOverflowMode>('overflowMode', overflowMode));
    properties.add(EnumProperty<TreemapLegendPosition>('position', position));
    if (textStyle != null) {
      properties.add(textStyle!.toDiagnosticsNode(name: 'textStyle'));
    }

    if (_legendType == _MapLegendType.vector) {
      properties.add(DiagnosticsProperty<Size>('iconSize', _iconSize));
      properties.add(EnumProperty<TreemapIconType>('iconType', _iconType));
    } else {
      properties.add(DiagnosticsProperty<Size>('segmentSize', _segmentSize));
      properties.add(EnumProperty<TreemapLegendLabelsPlacement>(
          'labelsPlacement', _labelsPlacement));
      properties.add(EnumProperty<TreemapLegendEdgeLabelsPlacement>(
          'edgeLabelsPlacement', _edgeLabelsPlacement));
      properties.add(EnumProperty<TreemapLabelOverflow>(
          'labelOverflowMode', _labelOverflow));
      properties.add(EnumProperty<TreemapLegendPaintingStyle>(
          'segmentPaintingStyle', _segmentPaintingStyle));
    }
  }
}

/// For rendering the tree map legend based on legend type.
class LegendWidget extends StatefulWidget {
  /// Creates a [LegendWidget].
  LegendWidget({required this.dataSource, required this.settings});

  /// map with the respective data in the data source.
  final dynamic dataSource;

  /// Customizes the appearance of the the legend.
  final TreemapLegend settings;

  @override
  _LegendWidgetState createState() => _LegendWidgetState();
}

class _LegendWidgetState extends State<LegendWidget> {
  late TextStyle _textStyle;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    _textStyle = themeData.textTheme.caption!
        .copyWith(color: themeData.textTheme.caption!.color!.withOpacity(0.87))
        .merge(widget.settings.textStyle);
    if (widget.settings.title == null) {
      switch (widget.settings.overflowMode) {
        case TreemapLegendOverflowMode.scroll:
          return _getScrollableWidget();
        case TreemapLegendOverflowMode.wrap:
          return actualChild;
      }
    } else {
      switch (widget.settings.overflowMode) {
        case TreemapLegendOverflowMode.scroll:
          if (widget.settings.position == TreemapLegendPosition.top ||
              widget.settings.position == TreemapLegendPosition.bottom) {
            return Column(
              mainAxisAlignment:
                  widget.settings.position == TreemapLegendPosition.bottom
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [widget.settings.title!, _getScrollableWidget()],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.settings.title!,
                Flexible(fit: FlexFit.loose, child: _getScrollableWidget()),
              ],
            );
          }
        case TreemapLegendOverflowMode.wrap:
          if (widget.settings.position == TreemapLegendPosition.top ||
              widget.settings.position == TreemapLegendPosition.bottom) {
            return Column(
              mainAxisAlignment:
                  widget.settings.position == TreemapLegendPosition.bottom
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [widget.settings.title!, actualChild],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.settings.title!,
                Flexible(fit: FlexFit.loose, child: actualChild)
              ],
            );
          }
      }
    }
  }

  Widget _getScrollableWidget() {
    return SingleChildScrollView(
        scrollDirection:
            widget.settings.position == TreemapLegendPosition.top ||
                    widget.settings.position == TreemapLegendPosition.bottom
                ? Axis.horizontal
                : Axis.vertical,
        child: actualChild);
  }

  Widget get actualChild {
    if (widget.settings._legendType == _MapLegendType.vector) {
      final Widget child = Wrap(
        direction: widget.settings.direction ??
            (widget.settings.position == TreemapLegendPosition.top ||
                    widget.settings.position == TreemapLegendPosition.bottom
                ? Axis.horizontal
                : Axis.vertical),
        spacing: widget.settings.spacing,
        children: _getLegendItems(),
        runSpacing: 6,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.start,
      );

      if (widget.settings.padding != null) {
        return Padding(padding: widget.settings.padding!, child: child);
      }

      return child;
    } else {
      if (widget.settings._segmentPaintingStyle ==
          TreemapLegendPaintingStyle.solid) {
        return _SolidBarLegend(
          dataSource: widget.dataSource,
          settings: widget.settings,
          textStyle: _textStyle,
        );
      } else {
        return _GradientBarLegend(
          dataSource: widget.dataSource,
          settings: widget.settings,
          textStyle: _textStyle,
        );
      }
    }
  }

  /// Returns the list of legend items based on the data source.
  List<Widget> _getLegendItems() {
    final List<Widget> legendItems = <Widget>[];
    if (widget.dataSource != null && widget.dataSource.isNotEmpty) {
      // The legend items calculated based on color mappers.
      if (widget.dataSource is List) {
        final int length = widget.dataSource.length;
        for (int i = 0; i < length; i++) {
          final TreemapColorMapper colorMapper = widget.dataSource[i];
          final String text = colorMapper.from != null
              ? colorMapper.name ?? '${colorMapper.from} - ${colorMapper.to}'
              : colorMapper.value!;
          legendItems.add(_getLegendItem(
            text,
            colorMapper.color,
          ));
        }
      } else {
        // The legend items calculated based on the first level
        // [TreemapLevel.groupMapper] and [TreemapLevel.color] values.
        widget.dataSource.forEach((String key, TreemapTile treeModel) {
          legendItems.add(_getLegendItem(
            treeModel.group,
            treeModel.color,
          ));
        });
      }
    }

    return legendItems;
  }

  /// Returns the legend icon and label.
  Widget _getLegendItem(String text, Color? color) {
    return _LegendItem(
        text: text,
        iconShapeColor: color,
        settings: widget.settings,
        textStyle: _textStyle);
  }
}

class _LegendItem extends LeafRenderObjectWidget {
  const _LegendItem({
    required this.text,
    required this.iconShapeColor,
    required this.settings,
    required this.textStyle,
  });

  final String text;
  final Color? iconShapeColor;
  final TreemapLegend settings;
  final TextStyle textStyle;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLegendItem(
      text: text,
      iconShapeColor: iconShapeColor,
      settings: settings,
      textStyle: textStyle,
      mediaQueryData: MediaQuery.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderLegendItem renderObject) {
    renderObject
      ..text = text
      ..iconShapeColor = iconShapeColor
      ..settings = settings
      ..textStyle = textStyle
      ..mediaQueryData = MediaQuery.of(context);
  }
}

class _RenderLegendItem extends RenderBox {
  _RenderLegendItem({
    required String text,
    required Color? iconShapeColor,
    required TreemapLegend settings,
    required TextStyle textStyle,
    required MediaQueryData mediaQueryData,
  })   : _text = text,
        _iconShapeColor = iconShapeColor,
        _settings = settings,
        _textStyle = textStyle,
        _mediaQueryData = mediaQueryData {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    _updateTextPainter();
  }

  final int _spacing = 3;
  final _TreemapIconShape _iconShape = const _TreemapIconShape();
  late TextPainter _textPainter;

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

  Color? get iconShapeColor => _iconShapeColor;
  Color? _iconShapeColor;
  set iconShapeColor(Color? value) {
    if (_iconShapeColor == value) {
      return;
    }
    _iconShapeColor = value;
    markNeedsPaint();
  }

  TreemapLegend get settings => _settings;
  TreemapLegend _settings;
  set settings(TreemapLegend value) {
    if (_settings == value) {
      return;
    }
    _settings = value;
    _updateTextPainter();
    markNeedsLayout();
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

  TextStyle get textStyle => _textStyle;
  TextStyle _textStyle;
  set textStyle(TextStyle value) {
    if (_textStyle == value) {
      return;
    }
    _textStyle = value;
    markNeedsLayout();
  }

  void _updateTextPainter() {
    _textPainter.textScaleFactor = _mediaQueryData.textScaleFactor;
    _textPainter.text = TextSpan(text: _text, style: textStyle);
    _textPainter.layout();
  }

  @override
  void performLayout() {
    final double width =
        _settings._iconSize!.width + _spacing + _textPainter.width;
    final double height =
        max(_settings._iconSize!.height, _textPainter.height) + _spacing;
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    Color? iconColor;
    Offset actualOffset;
    iconColor = _iconShapeColor;
    final Size halfIconSize =
        _iconShape.getPreferredSize(_settings._iconSize!) / 2;
    actualOffset =
        offset + Offset(0, (size.height - (halfIconSize.height * 2)) / 2);
    _iconShape.paint(context, actualOffset,
        parentBox: this,
        iconSize: _settings._iconSize!,
        color: iconColor ?? Colors.transparent,
        iconType: _settings._iconType!);

    _textPainter.text = TextSpan(
        style: textStyle.copyWith(color: textStyle.color), text: _text);
    _textPainter.layout();
    actualOffset = offset +
        Offset(_settings._iconSize!.width + _spacing,
            (size.height - _textPainter.height) / 2);
    _textPainter.paint(context.canvas, actualOffset);
  }
}

class _SolidBarLegend extends StatefulWidget {
  const _SolidBarLegend(
      {required this.dataSource,
      required this.settings,
      required this.textStyle});

  final dynamic dataSource;
  final TreemapLegend settings;
  final TextStyle textStyle;

  @override
  _SolidBarLegendState createState() => _SolidBarLegendState();
}

class _SolidBarLegendState extends State<_SolidBarLegend> {
  late Axis _direction;
  late TextDirection _textDirection;
  TreemapLegendLabelsPlacement? _labelsPlacement;
  late TextPainter _textPainter;
  bool _isOverlapSegmentText = false;
  late Size _segmentSize;

  @override
  void initState() {
    _textPainter = TextPainter(textDirection: TextDirection.ltr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _segmentSize = widget.settings._segmentSize ?? const Size(80.0, 12.0);
    _labelsPlacement = widget.settings._labelsPlacement;
    final TextDirection textDirection = Directionality.of(context);
    _direction = widget.settings.direction ??
        (widget.settings.position == TreemapLegendPosition.top ||
                widget.settings.position == TreemapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    _textDirection = textDirection == TextDirection.ltr
        ? textDirection
        : (_direction == Axis.vertical ? TextDirection.ltr : textDirection);
    _textPainter.textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final Widget child = Directionality(
      textDirection: _textDirection,
      child: Wrap(
        direction: _direction,
        spacing: widget.settings.spacing,
        children: _getBarSegments(),
        runSpacing: 6,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.start,
      ),
    );

    if (widget.settings.padding != null) {
      return Padding(padding: widget.settings.padding!, child: child);
    }

    return child;
  }

  List<Widget> _getBarSegments() {
    if (widget.dataSource != null && widget.dataSource.isNotEmpty) {
      if (widget.dataSource is List) {
        return _getSegmentsForColorMapper();
      } else {
        _labelsPlacement = widget.settings._labelsPlacement ??
            TreemapLegendLabelsPlacement.onItem;
        return _getSegmentsForShapeSource();
      }
    }

    return [];
  }

  List<Widget> _getSegmentsForColorMapper() {
    final List<Widget> legendItems = <Widget>[];
    final int length = widget.dataSource.length;
    String? currentText;
    for (int i = 0; i < length; i++) {
      _isOverlapSegmentText = false;
      final TreemapColorMapper colorMapper = widget.dataSource[i];
      _labelsPlacement = _labelsPlacement ??
          (colorMapper.from != null
              ? TreemapLegendLabelsPlacement.betweenItems
              : TreemapLegendLabelsPlacement.onItem);
      if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
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
            _labelsPlacement == TreemapLegendLabelsPlacement.onItem) {
          _isOverlapSegmentText =
              _getTextWidth(currentText) > _segmentSize.width;
        }
      }

      legendItems.add(
          _getSegment(currentText, colorMapper.color, i, length, colorMapper));
    }

    return legendItems;
  }

  List<Widget> _getSegmentsForShapeSource() {
    final List<Widget> barSegments = <Widget>[];
    final int length = widget.dataSource.length;
    // If we use as iterator, it will check first and second model and then
    // check third and fourth model. But we can't check second and third item
    // is overlapping or not. Since the iterator in second model . So we uses
    // two iterator. If we use move next first iterator gives current model and
    // second iterator gives next model.
    final Iterator<TreemapTile> currentIterator =
        widget.dataSource.values.iterator;
    final Iterator<TreemapTile> nextIterator =
        widget.dataSource.values.iterator;
    String? text;
    nextIterator.moveNext();
    while (currentIterator.moveNext()) {
      final TreemapTile treemapModel = currentIterator.current;
      if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
        if (nextIterator.moveNext()) {
          text = _getTrimmedText(
              treemapModel.group, nextIterator.current.group, 0, length);
        } else {
          text =
              _getTrimmedText(currentIterator.current.group, text, 0, length);
        }
      } else if (_direction == Axis.horizontal &&
          _labelsPlacement == TreemapLegendLabelsPlacement.onItem) {
        text = treemapModel.group;
        _isOverlapSegmentText = _getTextWidth(text) > _segmentSize.width;
      }

      barSegments.add(_getSegment(text!, treemapModel.color, 0, length));
    }

    return barSegments;
  }

  String _getTrimmedText(
      String currentText, String? nextText, int index, int length) {
    if (widget.settings._labelOverflow == TreemapLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    final Size barSize = _segmentSize;
    double refCurrentTextWidth;
    double refNextTextWidth;
    if (_direction == Axis.horizontal &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      bool isLastInsideItem = false;
      if (index == length - 1) {
        isLastInsideItem = widget.settings._edgeLabelsPlacement ==
            TreemapLegendEdgeLabelsPlacement.inside;
        refNextTextWidth = _getTextWidth(nextText) / 2;
        refCurrentTextWidth = isLastInsideItem
            ? _getTextWidth(currentText)
            : _getTextWidth(currentText) / 2;
      } else {
        refCurrentTextWidth = _getTextWidth(currentText) / 2;
        refNextTextWidth = index + 1 == length - 1 &&
                widget.settings._edgeLabelsPlacement ==
                    TreemapLegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth >
          barSize.width + widget.settings.spacing;
      if (widget.settings._labelOverflow == TreemapLabelOverflow.ellipsis) {
        final double textWidth = refCurrentTextWidth + refNextTextWidth;
        return _getTrimText(
            currentText,
            widget.textStyle,
            _segmentSize.width + widget.settings.spacing / 2,
            _textPainter,
            textWidth,
            refNextTextWidth,
            isLastInsideItem);
      }
    }

    return currentText;
  }

  String _getText(TreemapColorMapper colorMapper) {
    return colorMapper.from != null
        ? colorMapper.name ??
            (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems
                ? colorMapper.to.toString()
                : (_textDirection == TextDirection.ltr
                    ? '${colorMapper.from} - ${colorMapper.to}'
                    : '${colorMapper.to} - ${colorMapper.from}'))
        : colorMapper.value!;
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }

  /// Returns the bar legend icon and label.
  Widget _getSegment(String text, Color color, int index, int length,
      [TreemapColorMapper? colorMapper]) {
    final Color iconColor = color;
    return _getBarWithLabel(iconColor, index, text, colorMapper, length);
  }

  Widget _getBarWithLabel(Color iconColor, int index, String text,
      TreemapColorMapper? colorMapper, int dataSourceLength) {
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
              padding: EdgeInsets.only(bottom: 7.0),
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

  Widget _getVerticalBar(
      CrossAxisAlignment crossAxisAlignment,
      Color iconColor,
      int index,
      String text,
      TreemapColorMapper? colorMapper,
      Offset textOffset) {
    return Container(
      height: _segmentSize.width,
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Padding(
            // Gap between segment text and icon.
            padding: EdgeInsets.only(right: 7.0),
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
    if (_labelsPlacement == TreemapLegendLabelsPlacement.onItem &&
        widget.settings._labelOverflow != TreemapLabelOverflow.visible) {
      return CrossAxisAlignment.center;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  Widget _getTextWidget(int index, String text, TreemapColorMapper? colorMapper,
      Offset legendOffset) {
    if (index == 0 &&
        colorMapper != null &&
        colorMapper.from != null &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      return _getStartSegmentText(colorMapper, text, legendOffset);
    } else {
      return _getAlignedTextWidget(legendOffset, text, _isOverlapSegmentText);
    }
  }

  Widget _getStartSegmentText(
      TreemapColorMapper colorMapper, String text, Offset legendOffset) {
    bool isStartTextOverlapping = false;
    String startText;
    final List<String> firstSegmentLabels = _getStartSegmentLabel(colorMapper);
    if (firstSegmentLabels.length > 1) {
      startText = firstSegmentLabels[0];
    } else {
      startText = colorMapper.from!.toString();
    }

    if (_direction == Axis.horizontal &&
        widget.settings._labelOverflow != TreemapLabelOverflow.visible &&
        startText.isNotEmpty &&
        text.isNotEmpty) {
      final double refStartTextWidth = widget.settings._edgeLabelsPlacement ==
              TreemapLegendEdgeLabelsPlacement.inside
          ? _getTextWidth(startText)
          : _getTextWidth(startText) / 2;
      final double refCurrentTextWidth = _getTextWidth(text) / 2;
      isStartTextOverlapping = refStartTextWidth + refCurrentTextWidth >
          _segmentSize.width + widget.settings.spacing;
      if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems &&
          widget.settings._labelOverflow == TreemapLabelOverflow.ellipsis) {
        startText = _getTrimText(
            startText,
            widget.textStyle,
            _segmentSize.width + widget.settings.spacing / 2,
            _textPainter,
            refStartTextWidth + refCurrentTextWidth,
            refCurrentTextWidth);
      }
    }

    Offset startTextOffset = _getStartTextOffset(startText);
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

  List<String> _getStartSegmentLabel(TreemapColorMapper colorMapper) {
    if (colorMapper.from != null &&
        colorMapper.name != null &&
        colorMapper.name!.isNotEmpty &&
        colorMapper.name![0] == '{' &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      final List<String> splitText = colorMapper.name!.split('},{');
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
    if ((widget.settings._labelOverflow == TreemapLabelOverflow.hide &&
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
                style: widget.textStyle,
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: widget.settings._labelOverflow ==
                          TreemapLabelOverflow.ellipsis &&
                      _labelsPlacement == TreemapLegendLabelsPlacement.onItem
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              style: widget.textStyle,
            ),
    );
  }

  Offset _getTextOffset(int index, String text, int dataSourceLength) {
    if (_labelsPlacement == TreemapLegendLabelsPlacement.onItem &&
        widget.settings._labelOverflow != TreemapLabelOverflow.visible) {
      return Offset.zero;
    }

    if (_direction == Axis.horizontal) {
      return _getHorizontalTextOffset(index, text, dataSourceLength);
    } else {
      return _getVerticalTextOffset(index, text, dataSourceLength);
    }
  }

  Offset _getVerticalTextOffset(int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      if (index == dataSourceLength - 1) {
        if (widget.settings._edgeLabelsPlacement ==
            TreemapLegendEdgeLabelsPlacement.inside) {
          return Offset(0.0, _segmentSize.width - _textPainter.height);
        }
        return Offset(0.0, _segmentSize.width - _textPainter.height / 2);
      }

      return Offset(
          0.0,
          _segmentSize.width -
              _textPainter.height / 2 +
              widget.settings.spacing / 2);
    } else {
      return Offset(0.0, _segmentSize.width / 2 - _textPainter.height / 2);
    }
  }

  Offset _getHorizontalTextOffset(
      int index, String text, int dataSourceLength) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      final double width = _textDirection == TextDirection.rtl &&
              _segmentSize.width < _textPainter.width
          ? _textPainter.width
          : _segmentSize.width;
      if (index == dataSourceLength - 1) {
        if (widget.settings._edgeLabelsPlacement ==
            TreemapLegendEdgeLabelsPlacement.inside) {
          return Offset(width - _textPainter.width, 0.0);
        }
        return Offset(width - _textPainter.width / 2, 0.0);
      }

      return Offset(
          width - _textPainter.width / 2 + widget.settings.spacing / 2, 0.0);
    } else {
      final double xPosition = _textDirection == TextDirection.rtl &&
              _segmentSize.width < _textPainter.width
          ? _textPainter.width / 2 - _segmentSize.width / 2
          : _segmentSize.width / 2 - _textPainter.width / 2;
      return Offset(xPosition, 0.0);
    }
  }

  Offset _getStartTextOffset(String text) {
    _textPainter.text = TextSpan(text: text, style: widget.textStyle);
    _textPainter.layout();
    if (widget.settings._edgeLabelsPlacement ==
        TreemapLegendEdgeLabelsPlacement.inside) {
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
  _GradientBarLabel(this.label,
      [this.offset = Offset.zero, this.isOverlapping = false]);

  String label;
  Offset offset;
  bool isOverlapping;
}

// ignore: must_be_immutable
class _GradientBarLegend extends StatelessWidget {
  _GradientBarLegend(
      {required this.dataSource,
      required this.settings,
      required this.textStyle});

  final dynamic dataSource;
  final TreemapLegend settings;
  final TextStyle textStyle;
  final List<Color> colors = <Color>[];
  final List<_GradientBarLabel> labels = <_GradientBarLabel>[];

  late Axis _direction;
  late Size _segmentSize;
  late TextPainter _textPainter;
  late double _referenceArea;
  bool _isRTL = false;
  bool _isOverlapSegmentText = false;
  TreemapLegendLabelsPlacement? _labelsPlacement;

  @override
  Widget build(BuildContext context) {
    _labelsPlacement =
        settings._labelsPlacement ?? TreemapLegendLabelsPlacement.betweenItems;
    TextDirection textDirection = Directionality.of(context);
    _isRTL = textDirection == TextDirection.rtl;
    _textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textScaleFactor: MediaQuery.of(context).textScaleFactor);
    _direction = settings.direction ??
        (settings.position == TreemapLegendPosition.top ||
                settings.position == TreemapLegendPosition.bottom
            ? Axis.horizontal
            : Axis.vertical);
    textDirection = _isRTL
        ? (_direction == Axis.vertical ? TextDirection.ltr : textDirection)
        : textDirection;

    final Widget child = Directionality(
      textDirection: textDirection,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final double width =
            constraints.hasBoundedWidth ? constraints.maxWidth : 300;
        final double height =
            constraints.hasBoundedHeight ? constraints.maxHeight : 300;
        _updateSegmentSize(Size(width, height).shortestSide);
        _collectLabelsAndColors();
        return _buildGradientBar();
      }),
    );
    if (settings.padding != null) {
      return Padding(padding: settings.padding!, child: child);
    }

    return child;
  }

  void _updateSegmentSize(double shortestSide) {
    if (_direction == Axis.horizontal) {
      final double availableWidth = settings.padding != null
          ? shortestSide - settings.padding!.horizontal
          : shortestSide;
      _segmentSize = settings._segmentSize == null
          ? Size(availableWidth, 12.0)
          : Size(
              settings._segmentSize!.width > availableWidth
                  ? availableWidth
                  : settings._segmentSize!.width,
              settings._segmentSize!.height);
      return;
    }

    final double availableHeight = settings.padding != null
        ? shortestSide - settings.padding!.vertical
        : shortestSide;
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
        final Iterator<TreemapTile> currentIterator =
            dataSource.values.iterator;
        final Iterator<TreemapTile> nextIterator = dataSource.values.iterator;
        int index = 0;
        nextIterator.moveNext();
        while (currentIterator.moveNext()) {
          final TreemapTile treemapModel = currentIterator.current;
          int positionIndex;
          if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
            slab = _referenceArea / (length - 1);
            positionIndex = index;
          } else {
            slab = _referenceArea / length;
            positionIndex = index + 1;
          }

          if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
            if (nextIterator.moveNext()) {
              text = _getTrimmedText(treemapModel.group, positionIndex, length,
                  slab, nextIterator.current.group);
            } else {
              text = _getTrimmedText(
                  treemapModel.group, positionIndex, length, slab, text);
            }
          } else {
            if (_direction == Axis.horizontal) {
              text = _getTrimmedText(
                  treemapModel.group, positionIndex, length, slab);
            }
          }

          labels.add(_GradientBarLabel(
              text!,
              _getTextOffset(text, positionIndex, length - 1, slab),
              _isOverlapSegmentText));
          colors.add(treemapModel.color);
          index++;
        }
      }
    }
  }

  void _collectColorMapperLabelsAndColors(int length) {
    if (dataSource.isNotEmpty) {
      final double slab = _referenceArea /
          (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems &&
                  dataSource[0].value != null
              ? length - 1
              : length);
      for (int i = 0; i < length; i++) {
        _isOverlapSegmentText = false;
        final TreemapColorMapper colorMapper = dataSource[i];
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
              _labelsPlacement == TreemapLegendLabelsPlacement.onItem
                  ? i + 1
                  : i;
          if (_labelsPlacement == TreemapLegendLabelsPlacement.onItem) {
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

  void _collectRageColorMapperLabels(int i, TreemapColorMapper colorMapper,
      String text, double slab, int length) {
    if (i == 0 &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      String startText;
      final List<String> firstSegmentLabels =
          _getStartSegmentLabel(colorMapper);
      if (firstSegmentLabels.length > 1) {
        startText = firstSegmentLabels[0];
      } else {
        startText = colorMapper.from!.toString();
      }

      if (_direction == Axis.horizontal &&
          _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems &&
          startText.isNotEmpty &&
          text.isNotEmpty) {
        final double refCurrentTextWidth = settings._edgeLabelsPlacement ==
                TreemapLegendEdgeLabelsPlacement.inside
            ? _getTextWidth(startText)
            : _getTextWidth(startText) / 2;
        final double refNextTextWidth = _getTextWidth(text) / 2;
        _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
        if (settings._labelOverflow == TreemapLabelOverflow.ellipsis) {
          if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
            final double textWidth = refCurrentTextWidth + refNextTextWidth;
            startText = _getTrimText(startText, textStyle, slab, _textPainter,
                textWidth, refNextTextWidth);
          }
        }
      }

      labels.add(_GradientBarLabel(startText,
          _getTextOffset(startText, i, length, slab), _isOverlapSegmentText));
    }

    if (_labelsPlacement == TreemapLegendLabelsPlacement.onItem) {
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
    if (settings._labelOverflow == TreemapLabelOverflow.visible ||
        currentText.isEmpty ||
        (nextText != null && nextText.isEmpty) ||
        nextText == null) {
      return currentText;
    }

    if (_direction == Axis.horizontal &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      double refCurrentTextWidth;
      double refNextTextWidth;
      bool isLastInsideItem = false;
      if (index == length - 1) {
        refNextTextWidth = _getTextWidth(nextText) / 2;

        if (settings._edgeLabelsPlacement ==
            TreemapLegendEdgeLabelsPlacement.inside) {
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
                    TreemapLegendEdgeLabelsPlacement.inside
            ? _getTextWidth(nextText)
            : _getTextWidth(nextText) / 2;
      }
      _isOverlapSegmentText = refCurrentTextWidth + refNextTextWidth > slab;
      if (settings._labelOverflow == TreemapLabelOverflow.ellipsis &&
          _isOverlapSegmentText) {
        if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
          final double textWidth = refCurrentTextWidth + refNextTextWidth;
          return _getTrimText(currentText, textStyle, slab, _textPainter,
              textWidth, refNextTextWidth, isLastInsideItem);
        }
      }
    } else if (_direction == Axis.horizontal &&
        _labelsPlacement == TreemapLegendLabelsPlacement.onItem) {
      final double textWidth = _getTextWidth(currentText);
      _isOverlapSegmentText = textWidth > slab;
      if (_isOverlapSegmentText) {
        return _getTrimText(
            currentText, textStyle, slab, _textPainter, textWidth);
      }
    }

    return currentText;
  }

  double _getTextWidth(String text) {
    _textPainter.text = TextSpan(text: text, style: textStyle);
    _textPainter.layout();
    return _textPainter.width;
  }

  List<String> _getStartSegmentLabel(TreemapColorMapper colorMapper) {
    if (colorMapper.from != null &&
        colorMapper.name != null &&
        colorMapper.name!.isNotEmpty &&
        colorMapper.name![0] == '{' &&
        _labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      final List<String> splitText = colorMapper.name!.split('},{');
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
      String? text, int positionIndex, int length, double slab) {
    _textPainter.text = TextSpan(text: text, style: textStyle);
    _textPainter.layout();
    final bool canAdjustLabelToCenter = settings._edgeLabelsPlacement ==
                TreemapLegendEdgeLabelsPlacement.center &&
            (positionIndex == 0 || positionIndex == length) ||
        (positionIndex > 0 && positionIndex < length) ||
        settings._labelsPlacement == TreemapLegendLabelsPlacement.onItem;
    if (_direction == Axis.horizontal) {
      return _getHorizontalOffset(
          canAdjustLabelToCenter, positionIndex, slab, length);
    } else {
      final double referenceTextWidth = canAdjustLabelToCenter
          ? _textPainter.height / 2
          : (positionIndex == length ? _textPainter.height : 0.0);
      if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
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
      double dx =
          _segmentSize.width - (slab * positionIndex - referenceTextWidth);

      if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
        return Offset(dx, 0.0);
      }

      dx = _segmentSize.width - (slab * positionIndex);

      return Offset(dx + slab / 2 - _textPainter.width / 2, 0.0);
    }

    final double referenceTextWidth = canAdjustLabelToCenter
        ? _textPainter.width / 2
        : (positionIndex == length ? _textPainter.width : 0.0);
    if (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
      return Offset(slab * positionIndex - referenceTextWidth, 0.0);
    }

    return Offset(
        slab * positionIndex - _textPainter.width / 2 - slab / 2, 0.0);
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
        if ((settings._labelOverflow == TreemapLabelOverflow.hide &&
                labels[index].isOverlapping) ||
            labels[index].label.isEmpty) {
          return SizedBox(height: 0.0, width: 0.0);
        }

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Transform.translate(
            offset: labels[index].offset,
            child: Text(
              labels[index].label,
              style: textStyle,
              softWrap: false,
            ),
          ),
        );
      }),
    );
  }

  String _getActualText(TreemapColorMapper colorMapper) {
    return colorMapper.from != null
        ? colorMapper.name ??
            (_labelsPlacement == TreemapLegendLabelsPlacement.betweenItems
                ? colorMapper.to.toString()
                : (_isRTL
                    ? '${colorMapper.to} - ${colorMapper.from}'
                    : '${colorMapper.from} - ${colorMapper.to}'))
        : colorMapper.value!;
  }
}

class _TreemapIconShape {
  const _TreemapIconShape();

  /// Returns the size based on the value passed to it.
  Size getPreferredSize(Size iconSize) => iconSize;

  /// Paints the shapes based on the value passed to it.
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required Size iconSize,
    required Color color,
    Color? strokeColor,
    double? strokeWidth,
    required TreemapIconType iconType,
  }) {
    iconSize = getPreferredSize(iconSize);
    final double halfIconWidth = iconSize.width / 2;
    final double halfIconHeight = iconSize.height / 2;
    final bool hasStroke = strokeWidth != null &&
        strokeWidth > 0 &&
        strokeColor != null &&
        strokeColor != Colors.transparent;
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..color = color;
    Path path;

    switch (iconType) {
      case TreemapIconType.circle:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawOval(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawOval(rect, paint);
        }
        break;
      case TreemapIconType.rectangle:
        final Rect rect = Rect.fromLTWH(
            offset.dx, offset.dy, iconSize.width, iconSize.height);
        context.canvas.drawRect(rect, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawRect(rect, paint);
        }
        break;
      case TreemapIconType.triangle:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + iconSize.height)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
      case TreemapIconType.diamond:
        path = Path()
          ..moveTo(offset.dx + halfIconWidth, offset.dy)
          ..lineTo(offset.dx + iconSize.width, offset.dy + halfIconHeight)
          ..lineTo(offset.dx + halfIconWidth, offset.dy + iconSize.height)
          ..lineTo(offset.dx, offset.dy + halfIconHeight)
          ..close();
        context.canvas.drawPath(path, paint);
        if (hasStroke) {
          paint
            ..strokeWidth = strokeWidth
            ..color = strokeColor
            ..style = PaintingStyle.stroke;
          context.canvas.drawPath(path, paint);
        }
        break;
    }
  }
}

String _getTrimText(String text, TextStyle style, double maxWidth,
    TextPainter painter, double width,
    [double? nextTextHalfWidth, bool isInsideLastItem = false]) {
  final int actualTextLength = text.length;
  String trimmedText = text;
  int trimLength = 3; // 3 dots
  while (width > maxWidth) {
    if (trimmedText.length <= 4) {
      trimmedText = trimmedText[0] + '...';
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      break;
    } else {
      trimmedText = text.replaceRange(
          actualTextLength - trimLength, actualTextLength, '...');
      painter.text = TextSpan(style: style, text: trimmedText);
      painter.layout();
      trimLength++;
    }

    if (isInsideLastItem && nextTextHalfWidth != null) {
      width = painter.width + nextTextHalfWidth;
    } else {
      width = nextTextHalfWidth != null
          ? painter.width / 2 + nextTextHalfWidth
          : painter.width;
    }
  }

  return trimmedText;
}
