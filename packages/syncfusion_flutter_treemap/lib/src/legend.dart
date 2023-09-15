import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_core/legend_internal.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../treemap.dart';

/// Specifies the legend type.
enum _LegendType {
  /// Vector type.
  vector,

  /// Bar type.
  bar,
}

/// Signature to return a [Widget] for the given value.
typedef TreemapLegendPointerBuilder = Widget Function(
    BuildContext context, dynamic value);

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
  /// [TreemapLegendLabelsPlacement.onItem] places labels in the center
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
/// late List<SocialMediaUsers> _source;
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
/// late List<SocialMediaUsers> _source;
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
  /// If [SfTreemap.colorMappers] is null, then the legend item's icon color
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
  /// late List<SocialMediaUsers> _source;
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
    this.shouldAlwaysShowScrollbar = false,
    this.title,
    this.position = TreemapLegendPosition.top,
    this.offset,
    this.overflowMode = TreemapLegendOverflowMode.wrap,
    this.direction,
    this.padding = const EdgeInsets.all(10.0),
    this.spacing = 10.0,
    this.textStyle,
    this.iconType = TreemapIconType.circle,
    this.iconSize = const Size(8.0, 8.0),
  })  : _type = _LegendType.vector,
        segmentSize = null,
        labelsPlacement = null,
        edgeLabelsPlacement = TreemapLegendEdgeLabelsPlacement.inside,
        labelOverflow = TreemapLabelOverflow.visible,
        segmentPaintingStyle = TreemapLegendPaintingStyle.solid,
        showPointerOnHover = false,
        pointerBuilder = null,
        pointerColor = null,
        pointerSize = const Size(16, 12),
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
  /// ```dart
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
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
    this.shouldAlwaysShowScrollbar = false,
    this.title,
    this.overflowMode = TreemapLegendOverflowMode.scroll,
    this.padding = const EdgeInsets.all(10.0),
    this.position = TreemapLegendPosition.top,
    this.offset,
    this.spacing = 2.0,
    this.textStyle,
    this.direction,
    this.segmentSize,
    this.labelsPlacement,
    this.edgeLabelsPlacement = TreemapLegendEdgeLabelsPlacement.inside,
    this.labelOverflow = TreemapLabelOverflow.visible,
    this.segmentPaintingStyle = TreemapLegendPaintingStyle.solid,
    this.showPointerOnHover = false,
    this.pointerBuilder,
    this.pointerColor,
    this.pointerSize = const Size(16, 12),
  })  : _type = _LegendType.bar,
        iconType = TreemapIconType.circle,
        iconSize = const Size(8.0, 8.0),
        assert(spacing >= 0);

  /// Enables a title for the legends to provide a small note about the legends.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  final Widget? title;

  /// Sets the padding around the legend.
  ///
  /// Defaults to EdgeInsets.all(10.0).
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  final EdgeInsetsGeometry? padding;

  /// Arranges the legend items in either horizontal or vertical direction.
  ///
  /// Defaults to horizontal, if the [position] is top, bottom.
  /// Defaults to vertical, if the [position] is left or right.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  /// * [position], to change the position of the legend.
  final Axis? direction;

  /// Positions the legend in the different directions.
  ///
  /// Defaults to [TreemapLegendPosition.top].
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  /// See also:
  /// * [offset], to place the legend in custom position.
  final TreemapLegendPosition position;

  ///Toggles the scrollbar visibility.
  ///
  /// When set to false, the scrollbar appears only when scrolling else the
  /// scrollbar fades out. When true, the scrollbar will never fade out and
  /// will always be visible when the items are overflown.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  /// SfTreemap(
  ///            legend:Legend(
  ///              isVisible: true,
  ///              shouldAlwaysShowScrollbar: true,
  ///              overflowMode: TreemapLegendOverflowMode.scroll,
  ///             )
  ///           )
  ///```
  final bool shouldAlwaysShowScrollbar;

  /// Places the legend in custom position.
  ///
  /// If the [offset] has been set and if the [position] is top, then the legend
  /// will be placed in top but in the position additional to the
  /// actual top position. Also, the legend will not take dedicated position for
  /// it and will be drawn on the top of treemap.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  /// * [position], to set the position of the legend.
  final Offset? offset;

  /// Specifies the space between the each legend items.
  ///
  /// Defaults to 10.0 for default legend and 2.0 for bar legend.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  final double spacing;

  /// Customizes the legend item's text style.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  /// late List<SocialMediaUsers> _source;
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
  /// * [position], to set the position of the legend.
  /// * [direction], to set the direction of the legend.
  final TreemapLegendOverflowMode overflowMode;

  /// Specifies the shape of the legend icon.
  ///
  /// Defaults to [TreemapIconType.circle].
  ///
  /// ```dart
  ///  late List<SocialMediaUsers> _source;
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
  ///   @override
  ///   Widget build(BuildContext context) {
  ///    return Scaffold(
  ///       appBar: AppBar(title: Text('Treemap legend')),
  ///       body: SfTreemap.dice(
  ///         dataCount: _source.length,
  ///         weightValueMapper: (int index) {
  ///           return _source[index].usersInMillions;
  ///         },
  ///         levels: [
  ///           TreemapLevel(
  ///             padding: EdgeInsets.only(left: 2.5, right: 2.5),
  ///             groupMapper: (int index) {
  ///               return _source[index].country;
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
  /// * [iconSize], to set the size of the icon.
  final TreemapIconType iconType;

  /// Customizes the size of the bar segments.
  ///
  /// Defaults to Size(80.0, 12.0).
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
  ///       legend: TreemapLegend.bar(
  ///         segmentSize: Size(60, 18),
  ///       ),
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
  final Size? segmentSize;

  /// Customizes the size of the icon.
  ///
  /// Defaults to Size(12.0, 12.0).
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
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
  /// * [iconType], to set shape of the default legend icon.
  final Size iconSize;

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
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
  ///       legend: TreemapLegend.bar(
  ///         labelsPlacement: TreemapLegendLabelsPlacement.onItem,
  ///       ),
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
  /// * [edgeLabelsPlacement], to place the edge labels either
  /// inside or outside of the bar legend.
  ///
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final TreemapLegendLabelsPlacement? labelsPlacement;

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
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
  ///       legend: TreemapLegend.bar(
  ///         edgeLabelsPlacement: TreemapLegendEdgeLabelsPlacement.center,
  ///       ),
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
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  final TreemapLegendEdgeLabelsPlacement edgeLabelsPlacement;

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
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
  ///       legend: TreemapLegend.bar(
  ///         labelOverflow: TreemapLabelOverflow.ellipsis,
  ///       ),
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
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final TreemapLabelOverflow labelOverflow;

  /// Applies gradient or solid color for the bar segments.
  ///
  /// ```dart
  /// late List<SocialMediaUsers> _source;
  /// late List<TreemapColorMapper> _colorMappers;
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
  ///   _colorMappers = <TreemapColorMapper>[
  ///     TreemapColorMapper.range(
  ///         from: 0, to: 10, color: Colors.red, name: '10'),
  ///     TreemapColorMapper.range(
  ///         from: 11, to: 20, color: Colors.green, name: '20'),
  ///     TreemapColorMapper.range(
  ///         from: 21, to: 30, color: Colors.blue, name: '30'),
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
  ///       colorMappers: _colorMappers,
  ///       legend: TreemapLegend.bar(
  ///         segmentPaintingStyle: TreemapLegendPaintingStyle.gradient,
  ///       ),
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
  /// * [labelsPlacement], place the labels either between the segments or
  /// on the segments.
  /// * [labelOverflow], to trims or removes the legend text
  /// when it is overflowed from the bar legend.
  /// * [edgeLabelsPlacement], to place the edge labels either inside or
  /// outside of the bar legend.
  final TreemapLegendPaintingStyle segmentPaintingStyle;

  /// Specifies whether the pointer should be shown while hovering
  /// on the [TreemapLegend] segments.
  final bool showPointerOnHover;

  /// Returns a widget for the given value.
  ///
  /// The pointer is used to indicate the exact color of the hovering tile.
  ///
  /// The [pointerBuilder] will be called when the user interacts with the
  /// tiles i.e., while tapping in touch devices and hovering in
  ///  the mouse enabled devices.
  final TreemapLegendPointerBuilder? pointerBuilder;

  /// Customizes the size of the pointer.
  final Size pointerSize;

  /// Customizes the color of the pointer.
  final Color? pointerColor;

  /// Specifies the type of the legend.
  final _LegendType _type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is TreemapLegend && other._type != _type) {
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
  int get hashCode => Object.hash(padding, offset, spacing, direction,
      overflowMode, position, textStyle, title);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<_LegendType>('legendType', _type));
    if (padding != null) {
      properties
          .add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    }
    if (offset != null) {
      properties.add(DiagnosticsProperty<Offset>('offset', offset));
    }
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
    if (_type == _LegendType.vector) {
      properties.add(DiagnosticsProperty<Size>('iconSize', iconSize));
      properties.add(EnumProperty<TreemapIconType>('iconType', iconType));
    } else {
      if (segmentSize != null) {
        properties.add(DiagnosticsProperty<Size>('segmentSize', segmentSize));
      }
      properties.add(EnumProperty<TreemapLegendLabelsPlacement>(
          'labelsPlacement', labelsPlacement));
      properties.add(EnumProperty<TreemapLegendEdgeLabelsPlacement>(
          'edgeLabelsPlacement', edgeLabelsPlacement));
      properties.add(EnumProperty<TreemapLabelOverflow>(
          'labelOverflowMode', labelOverflow));
      properties.add(EnumProperty<TreemapLegendPaintingStyle>(
          'segmentPaintingStyle', segmentPaintingStyle));
    }
  }
}

/// Represents the class for SfLegend.
class Legend extends StatelessWidget {
  /// Constructor of [Legend].
  const Legend({
    Key? key,
    this.colorMappers,
    this.dataSource,
    required this.legend,
    required this.controller,
    required this.child,
  })  : assert(colorMappers != null || dataSource != null),
        super(key: key);

  /// Collection of [TreemapColorMapper] which specifies treemap color based
  /// on the data.
  final List<TreemapColorMapper>? colorMappers;

  /// Internal grouped data.
  final Map<String, TreemapTile>? dataSource;

  /// Specifies the legend properties.
  final TreemapLegend legend;

  /// Specifies the pointer controller.
  final PointerController controller;

  /// Specifies the child of the legend.
  final Widget child;

  List<LegendItem> _getLegendItems() {
    final List<LegendItem> items = <LegendItem>[];
    final TreemapLegendLabelsPlacement labelsPlacement =
        _getActualLabelsPlacement();
    if (colorMappers != null) {
      // The legend items calculated based on color mappers.
      if (colorMappers!.isNotEmpty) {
        final int length = colorMappers!.length;
        for (int index = 0; index < length; index++) {
          final TreemapColorMapper colorMapper = colorMappers![index];
          if (legend._type == _LegendType.bar &&
              labelsPlacement == TreemapLegendLabelsPlacement.betweenItems) {
            if (index == 0) {
              final String startValue = _getStartSegmentLabel(colorMapper);
              items.add(LegendItem(text: startValue, color: colorMapper.color));
            } else {
              final String text = colorMapper.from != null
                  ? colorMapper.name ?? colorMapper.to.toString()
                  : colorMapper.value!;
              items.add(LegendItem(text: text, color: colorMapper.color));
            }
          } else {
            final String text = colorMapper.from != null
                ? colorMapper.name ?? '${colorMapper.from} - ${colorMapper.to}'
                : colorMapper.value!;
            items.add(LegendItem(text: text, color: colorMapper.color));
          }
        }
      }
    } else if (dataSource != null && dataSource!.isNotEmpty) {
      // The legend items calculated based on the first level's
      // [TreemapLevel.groupMapper] and [TreemapLevel.color] values.
      dataSource!.forEach((String key, TreemapTile tile) {
        items.add(LegendItem(text: tile.group, color: tile.color));
      });
    }
    return items;
  }

  String _getStartSegmentLabel(TreemapColorMapper colorMapper) {
    String startText;
    if (colorMapper.from != null &&
        colorMapper.name != null &&
        colorMapper.name!.isNotEmpty &&
        colorMapper.name![0] == '{') {
      startText = colorMapper.name!;
    } else if (colorMapper.from != null &&
        colorMapper.name != null &&
        colorMapper.name!.isNotEmpty) {
      startText = '{${colorMapper.from}},{${colorMapper.name}}';
    } else {
      if (colorMapper.from != null) {
        startText = '{${colorMapper.from}},{${colorMapper.to}}';
      } else {
        startText = colorMapper.value!;
      }
    }
    return startText;
  }

  TreemapLegendLabelsPlacement _getActualLabelsPlacement() {
    if (legend.labelsPlacement != null) {
      return legend.labelsPlacement!;
    }

    if (colorMappers != null && colorMappers!.isNotEmpty) {
      return colorMappers![0].from != null
          ? TreemapLegendLabelsPlacement.betweenItems
          : TreemapLegendLabelsPlacement.onItem;
    }

    return TreemapLegendLabelsPlacement.onItem;
  }

  LegendPaintingStyle _getEffectiveSegmentPaintingStyle(
      TreemapLegendPaintingStyle paintingStyle) {
    switch (paintingStyle) {
      case TreemapLegendPaintingStyle.solid:
        return LegendPaintingStyle.solid;
      case TreemapLegendPaintingStyle.gradient:
        return LegendPaintingStyle.gradient;
    }
  }

  LegendLabelOverflow _getEffectiveLabelOverflow(
      TreemapLabelOverflow labelOverflow) {
    switch (labelOverflow) {
      case TreemapLabelOverflow.visible:
        return LegendLabelOverflow.visible;
      case TreemapLabelOverflow.hide:
        return LegendLabelOverflow.hide;
      case TreemapLabelOverflow.ellipsis:
        return LegendLabelOverflow.ellipsis;
    }
  }

  LegendEdgeLabelsPlacement _getEffectiveEdgeLabelsPlacement(
      TreemapLegendEdgeLabelsPlacement edgeLabelsPlacement) {
    switch (edgeLabelsPlacement) {
      case TreemapLegendEdgeLabelsPlacement.center:
        return LegendEdgeLabelsPlacement.center;
      case TreemapLegendEdgeLabelsPlacement.inside:
        return LegendEdgeLabelsPlacement.inside;
    }
  }

  LegendLabelsPlacement _getEffectiveLabelPlacement(
      TreemapLegendLabelsPlacement labelsPlacement) {
    switch (labelsPlacement) {
      case TreemapLegendLabelsPlacement.betweenItems:
        return LegendLabelsPlacement.betweenItems;
      case TreemapLegendLabelsPlacement.onItem:
        return LegendLabelsPlacement.onItem;
    }
  }

  LegendPosition _getEffectivePosition(TreemapLegendPosition position) {
    switch (position) {
      case TreemapLegendPosition.top:
        return LegendPosition.top;
      case TreemapLegendPosition.bottom:
        return LegendPosition.bottom;
      case TreemapLegendPosition.left:
        return LegendPosition.left;
      case TreemapLegendPosition.right:
        return LegendPosition.right;
    }
  }

  LegendOverflowMode _getEffectiveOverflowMode(
      TreemapLegendOverflowMode overflowMode) {
    switch (overflowMode) {
      case TreemapLegendOverflowMode.scroll:
        return LegendOverflowMode.scroll;
      case TreemapLegendOverflowMode.wrap:
        return LegendOverflowMode.wrap;
    }
  }

  ShapeMarkerType _getEffectiveLegendIconType(TreemapIconType iconType) {
    switch (iconType) {
      case TreemapIconType.circle:
        return ShapeMarkerType.circle;
      case TreemapIconType.diamond:
        return ShapeMarkerType.diamond;
      case TreemapIconType.triangle:
        return ShapeMarkerType.triangle;
      case TreemapIconType.rectangle:
        return ShapeMarkerType.rectangle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle legendTextStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .merge(SfTreemapTheme.of(context).legendTextStyle)
        .merge(legend.textStyle);
    switch (legend._type) {
      case _LegendType.vector:
        return SfLegend(
          shouldAlwaysShowScrollbar: legend.shouldAlwaysShowScrollbar,
          items: _getLegendItems(),
          direction: legend.direction,
          offset: legend.offset,
          padding: legend.padding,
          position: _getEffectivePosition(legend.position),
          overflowMode: _getEffectiveOverflowMode(legend.overflowMode),
          itemSpacing: legend.spacing,
          textStyle: legendTextStyle,
          title: legend.title,
          iconType: _getEffectiveLegendIconType(legend.iconType),
          iconSize: legend.iconSize,
          child: child,
        );
      case _LegendType.bar:
        return SfLegend.bar(
          shouldAlwaysShowScrollbar: legend.shouldAlwaysShowScrollbar,
          items: _getLegendItems(),
          title: legend.title,
          position: _getEffectivePosition(legend.position),
          overflowMode: _getEffectiveOverflowMode(legend.overflowMode),
          itemSpacing: legend.spacing,
          direction: legend.direction,
          offset: legend.offset,
          padding: legend.padding,
          textStyle: legendTextStyle,
          labelsPlacement:
              _getEffectiveLabelPlacement(_getActualLabelsPlacement()),
          edgeLabelsPlacement:
              _getEffectiveEdgeLabelsPlacement(legend.edgeLabelsPlacement),
          labelOverflow: _getEffectiveLabelOverflow(legend.labelOverflow),
          segmentSize: legend.segmentSize,
          segmentPaintingStyle:
              _getEffectiveSegmentPaintingStyle(legend.segmentPaintingStyle),
          pointerBuilder: legend.pointerBuilder,
          pointerColor: legend.pointerColor,
          pointerSize:
              legend.showPointerOnHover ? legend.pointerSize : Size.zero,
          pointerController: controller,
          child: child,
        );
    }
  }
}
