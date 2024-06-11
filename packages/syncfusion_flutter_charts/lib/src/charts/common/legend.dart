import 'package:flutter/material.dart';

import '../series/chart_series.dart';
import '../utils/enum.dart';
import '../utils/typedef.dart';
import 'core_legend.dart' as core;

/// Identify the series in chart.
///
/// Legend contains list of chart series/data points in chart. It helps to
/// identify the corresponding data series in chart. The name property of
/// [SfCartesianChart] is used to define the label for the corresponding series
/// legend item and for [SfCircularChart] type chart by default values mapped
/// with xValueMapper will be displayed.
///
/// Provides options such as  isVisible, borderWidth, alignment, opacity,
/// borderColor, padding and so on to customize the appearance of the legend.
@immutable
class Legend {
  /// Creating an argument constructor of Legend class.
  const Legend({
    this.isVisible = false,
    this.position = LegendPosition.auto,
    this.alignment = ChartAlignment.center,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.opacity = 1.0,
    this.height,
    this.width,
    this.padding = 10.0,
    this.iconHeight = 12.0,
    this.iconWidth = 12.0,
    this.shouldAlwaysShowScrollbar = false,
    this.toggleSeriesVisibility = true,
    this.textStyle,
    this.isResponsive = false,
    this.orientation = LegendItemOrientation.auto,
    this.title,
    this.overflowMode = LegendItemOverflowMode.scroll,
    this.legendItemBuilder,
    this.iconBorderColor,
    this.iconBorderWidth,
    this.itemPadding = 15.0,
    this.offset,
    this.image,
  });

  /// Toggles the visibility of the legend.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true
  ///     )
  ///   );
  /// }
  /// ```
  final bool isVisible;

  /// Position of the legend.
  ///
  /// If the chart width is greater than chart height, then the
  /// legend will be placed at the right, else it will be placed
  /// at the bottom of the chart.The available options are auto,
  /// bottom, left, right, and top.
  ///
  /// Defaults to `LegendPosition.auto`.
  ///
  /// Also refer [LegendPosition].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       position: LegendPosition.bottom
  ///     )
  ///   );
  /// }
  /// ```
  final LegendPosition position;

  /// Alignment of the legend.
  ///
  /// Alignment will work if the legend width is greater than
  /// the total legend item's width.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       alignment: ChartAlignment.near
  ///     )
  ///   );
  /// }
  /// ```
  final ChartAlignment alignment;

  /// Background color of the legend.
  ///
  /// Used to change the background color of legend shape.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       backgroundColor: Colors.grey
  ///     )
  ///   );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Toggles the scrollbar visibility.
  ///
  /// When set to false, the scrollbar appears only when scrolling else the
  /// scrollbar fades out. When true, the scrollbar will never fade out and will
  /// always be visible when the items are overflown.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend:Legend(
  ///       isVisible: true,
  ///       shouldAlwaysShowScrollbar: true
  ///     )
  ///   );
  /// }
  /// ```
  final bool shouldAlwaysShowScrollbar;

  /// Border color of the legend.
  ///
  /// Used to change the stroke color of the legend shape.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       borderColor: Colors.red,
  ///       borderWidth: 3
  ///     )
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Border width of the legend.
  ///
  /// Used to change the stroke width of the legend shape.
  ///
  /// Defaults to `0.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       borderColor: Colors.red,
  ///       borderWidth: 3
  ///     )
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Border color of the icon in the legend items.
  ///
  /// Used to change the stroke color of the legend icon shape.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       iconBorderColor: Colors.yellow,
  ///       iconBorderWidth: 4
  ///     )
  ///   );
  /// }
  /// ```
  final Color? iconBorderColor;

  /// Border width of the icon in the legend items.
  ///
  /// Used to change the stroke width of the legend icon shape.
  ///
  /// Defaults to null.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       iconBorderColor: Colors.yellow,
  ///       iconBorderWidth: 4
  ///     )
  ///   );
  /// }
  /// ```
  final double? iconBorderWidth;

  /// Opacity of the legend.
  ///
  /// Used to control the transparency of the legend icon shape.
  /// The value ranges from 0 to 1.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       opacity: 0.5
  ///     )
  ///   );
  /// }
  /// ```
  final double opacity;

  /// The height of the legend.
  ///
  /// It takes percentage value from the overall chart height.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       height: '30%'
  ///     )
  ///   );
  /// }
  /// ```
  final String? height;

  /// The width of the legend.
  ///
  /// It takes percentage value from the overall chart width.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       width: '30%'
  ///     )
  ///   );
  /// }
  /// ```
  final String? width;

  /// Padding between the legend items.
  ///
  /// Used to add padding between the icon shape and the text.
  ///
  /// Defaults to `5.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       padding: 4.0
  ///     )
  ///   );
  /// }
  /// ```
  final double padding;

  /// Height of the icon in legend item.
  ///
  /// Used to change the height of the icon shape.
  ///
  /// Defaults to `12`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       iconHeight: 14
  ///     )
  ///   );
  /// }
  /// ```
  final double iconHeight;

  /// Width of the icon in legend item.
  ///
  /// Used to change the width of the icon shape.
  ///
  /// Defaults to `12`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       iconWidth: 14
  ///     )
  ///   );
  /// }
  /// ```
  final double iconWidth;

  /// Toggles the series visibility.
  ///
  /// If it is set to false, then on tapping the legend item,
  /// series visibility will not be toggled.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       toggleSeriesVisibility: false
  ///     )
  ///   );
  /// }
  /// ```
  final bool toggleSeriesVisibility;

  /// Customizes the legend item text.
  ///
  /// Used to change the text color, size, font family, font style, etc.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       textStyle: TextStyle(color: Colors.red)
  ///     )
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Toggles the visibility of the legend.
  ///
  /// If the width or height of the legend is greater than the plot area bounds.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       isResponsive: true
  ///     )
  ///   );
  /// }
  /// ```
  final bool isResponsive;

  /// Orientation of the legend.
  ///
  /// The legend items will be placed either in horizontal or
  /// in vertical orientation. By default, it is set to auto, i.e. if the
  /// legend position is top or bottom, orientation is set
  /// to horizontal, else it is set to vertical.
  ///
  /// Defaults to `LegendItemOrientation.auto`.
  ///
  /// Also refer [LegendItemOrientation].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       orientation: LegendItemOrientation.vertical
  ///     )
  ///   );
  /// }
  /// ```
  final LegendItemOrientation orientation;

  /// Customizes the legend title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       title: LegendTitle(
  ///         text: 'Countries'
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final LegendTitle? title;

  /// Widget builder for legend items.
  ///
  /// Customize the appearance of legend items in
  /// template by using `legendItemBuilder` property of legend.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       legendItemBuilder:
  ///         (String name, dynamic series, dynamic point, int index) {
  ///         return Container(
  ///           height: 30,
  ///           width: 80,
  ///           child: Row(
  ///             children: <Widget>[
  ///               Container(child: Image.asset('images/bike.png')),
  ///               Container(child: Text(index.toString())),
  ///             ]
  ///           )
  ///         );
  ///       }
  ///     )
  ///   );
  /// }
  /// ```
  final LegendItemBuilder? legendItemBuilder;

  /// Overflow legend items.
  ///
  /// The legend items can be placed in multiple rows or scroll can be enabled
  /// using the overflowMode property if size of the total legend items exceeds
  /// the available size. It can be scrolled, wrapped, or left.
  ///
  /// Defaults to `LegendItemOverflowMode.scroll`.
  ///
  /// Also refer [LegendItemOverflowMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       overflowMode: LegendItemOverflowMode.wrap
  ///     )
  ///   );
  /// }
  /// ```
  final LegendItemOverflowMode overflowMode;

  /// Padding of the legend items.
  ///
  /// Used to add padding between the first legend text and the second
  /// legend icon shape.
  ///
  /// Defaults to `10.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       itemPadding: 5
  ///     )
  ///   );
  /// }
  /// ```
  final double itemPadding;

  /// Places the legend in custom position.
  ///
  /// If the [offset] has been set, the legend is moved from its actual
  /// position. For example, if the [position] is `top`, then the legend
  /// will be placed in the top but in the position added to the
  /// actual top position.
  ///
  /// Also, the legend will not take a dedicated position for it and will be
  /// drawn on the top of the chart's plot area.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       offset: Offset(20,40)
  ///     )
  ///   );
  /// }
  /// ```
  final Offset? offset;

  /// Used to add image to the legend icon.
  ///
  /// Default image size is `10.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       image: const AssetImage('images/bike.png')
  ///     )
  ///   );
  /// }
  /// ```
  final ImageProvider? image;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is Legend &&
        other.isVisible == isVisible &&
        other.position == position &&
        other.alignment == alignment &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.opacity == opacity &&
        other.height == height &&
        other.width == width &&
        other.padding == padding &&
        other.iconHeight == iconHeight &&
        other.iconWidth == iconWidth &&
        other.toggleSeriesVisibility == toggleSeriesVisibility &&
        other.textStyle == textStyle &&
        other.isResponsive == isResponsive &&
        other.orientation == orientation &&
        other.title == title &&
        other.overflowMode == overflowMode &&
        other.legendItemBuilder == legendItemBuilder &&
        other.iconBorderColor == iconBorderColor &&
        other.iconBorderWidth == iconBorderWidth &&
        other.itemPadding == itemPadding &&
        other.image == image;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      position,
      alignment,
      backgroundColor,
      borderColor,
      borderWidth,
      opacity,
      height,
      width,
      padding,
      iconHeight,
      iconWidth,
      toggleSeriesVisibility,
      textStyle,
      isResponsive,
      orientation,
      title,
      overflowMode,
      legendItemBuilder,
      iconBorderColor,
      iconBorderWidth,
      itemPadding,
      image
    ];
    return Object.hashAll(values);
  }
}

/// Customizes the legend title.
///
/// Takes a string and display the legend title.By default,the legend title
/// horizontally center aligned to the chart's width and it will placed at
/// the bottom of the chart.
///
/// Provides Options to customize the [text], [textStyle] and [alignment]
/// properties.
@immutable
class LegendTitle {
  /// Creating an argument constructor of LegendTitle class.
  const LegendTitle({
    this.text,
    this.textStyle,
    this.alignment = ChartAlignment.center,
  });

  /// Legend title text.
  ///
  /// Used to change the text of the title.
  ///
  /// Defaults to `‘’`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       title: ChartTitle(
  ///         text: 'Legend title'
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final String? text;

  /// Customize the legend title text.
  ///
  /// Used to change the text color, size, font family, fontStyle, and
  /// font weight for the legend title.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       title: ChartTitle(
  ///         text: 'Legend title',
  ///         textStyle: TextStyle(color: Colors.red)
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Alignment of the legend title.
  ///
  /// Used to change the alignment of the title text.
  ///
  /// It can be `ChartAlignment.near`,`ChartAlignment.center`, or
  /// `ChartAlignment.far`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment]
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     legend: Legend(
  ///       isVisible: true,
  ///       title: ChartTitle(
  ///         text: 'Legend title',
  ///         alignment: ChartAlignment.near
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final ChartAlignment alignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is LegendTitle &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.text == text;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[text, textStyle, alignment];
    return Object.hashAll(values);
  }
}

class ChartLegendItem extends core.LegendItem {
  ChartLegendItem({
    required super.text,
    required super.iconType,
    required super.iconColor,
    required super.iconBorderWidth,
    super.iconBorderColor,
    super.shader,
    super.imageProvider,
    super.overlayMarkerType,
    super.degree,
    super.endAngle,
    super.startAngle,
    super.isToggled = false,
    super.onTap,
    super.onRender,
    this.series,
    required this.seriesIndex,
    this.pointIndex = -1,
  });

  final ChartSeriesRenderer? series;
  final int seriesIndex;
  final int pointIndex;
}
