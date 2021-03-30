import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

/// Applies a theme to descendant Syncfusion maps widgets.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfMapsTheme(
///       data: SfMapsThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfMaps()
///     ),
///   );
/// }
/// ```
class SfMapsTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const SfMapsTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant maps widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMapsTheme(
  ///       data: SfMapsThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfMaps()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfMapsThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfMapsTheme(
  ///       data: SfMapsThemeData(
  ///         brightness: Brightness.dark,
  ///       ),
  ///       child: SfMaps()
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfMapsTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfThemeData.mapsThemeData] if there is no
  /// [SfMapsTheme] in the given build context.
  static SfMapsThemeData? of(BuildContext context) {
    final SfMapsTheme? mapsTheme =
        context.dependOnInheritedWidgetOfExactType<SfMapsTheme>();
    return mapsTheme?.data ?? SfTheme.of(context).mapsThemeData;
  }

  @override
  bool updateShouldNotify(SfMapsTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfMapsTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfMapsTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfMapsTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfMapsTheme]. Use this class
/// to configure a [SfMapsTheme] widget, or to set the
/// [SfThemeData.mapsThemeData] for a [SfTheme] widget.
///
/// To obtain the current theme, use [SfMapsTheme.of].
///
/// The maps elements are,
///
/// * The "data labels", to provide information to users about the respective
/// shape.
/// * The "markers", which denotes a location with built-in symbols and allows
/// displaying custom widgets at a specific latitude and longitude on a map.
/// * The "bubbles", which adds information to shapes such as population
/// density, number of users, and more. Bubbles can be rendered in different
/// colors and sizes based on the data values of their assigned shape.
/// * The "legend", to provide clear information on the data plotted in the map.
/// You can use the legend toggling feature to visualize only the shapes to
/// which needs to be visualized.
/// * The "color mapping", to categorize the shapes on a map by customizing
/// their color based on the underlying value. It is possible to set the shape
/// color for a specific value or for a range of values.
/// * The "tooltip", to display additional information about shapes and bubbles
/// using the customizable tooltip on a map.
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the maps.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfMapsTheme(
///       data: SfMapsThemeData(
///         brightness: Brightness.dark,
///       ),
///       child: SfMaps()
///     ),
///   );
/// }
/// ```
class SfMapsThemeData with Diagnosticable {
  /// Returns a new instance of [SfMapsThemeData.raw] for the given values.
  ///
  /// If any of the values are null, the default values will be set.
  factory SfMapsThemeData({
    Brightness? brightness,
    Color? layerColor,
    Color? layerStrokeColor,
    double? layerStrokeWidth,
    Color? shapeHoverColor,
    Color? shapeHoverStrokeColor,
    double? shapeHoverStrokeWidth,
    TextStyle? legendTextStyle,
    Color? markerIconColor,
    Color? markerIconStrokeColor,
    double? markerIconStrokeWidth,
    TextStyle? dataLabelTextStyle,
    Color? bubbleColor,
    Color? bubbleStrokeColor,
    double? bubbleStrokeWidth,
    Color? bubbleHoverColor,
    Color? bubbleHoverStrokeColor,
    double? bubbleHoverStrokeWidth,
    Color? selectionColor,
    Color? selectionStrokeColor,
    double? selectionStrokeWidth,
    Color? tooltipColor,
    Color? tooltipStrokeColor,
    double? tooltipStrokeWidth,
    BorderRadiusGeometry? tooltipBorderRadius,
    Color? toggledItemColor,
    Color? toggledItemStrokeColor,
    double? toggledItemStrokeWidth,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    layerColor ??= isLight
        ? const Color.fromRGBO(224, 224, 224, 1)
        : const Color.fromRGBO(97, 97, 97, 1);
    layerStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 0.5)
        : const Color.fromRGBO(224, 224, 224, 0.5);
    layerStrokeWidth ??= 1.0;
    markerIconColor ??= isLight
        ? const Color.fromRGBO(98, 0, 238, 1)
        : const Color.fromRGBO(187, 134, 252, 1);
    markerIconStrokeWidth ??= 1.0;
    bubbleColor ??= isLight
        ? const Color.fromRGBO(98, 0, 238, 0.5)
        : const Color.fromRGBO(187, 134, 252, 0.8);
    bubbleStrokeColor ??= Colors.transparent;
    bubbleStrokeWidth ??= 1.0;
    selectionColor ??= isLight
        ? const Color.fromRGBO(117, 117, 117, 1)
        : const Color.fromRGBO(224, 224, 224, 1);
    selectionStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 1)
        : const Color.fromRGBO(97, 97, 97, 1);
    selectionStrokeWidth ??= 0.5;
    tooltipColor ??= isLight
        ? const Color.fromRGBO(117, 117, 117, 1)
        : const Color.fromRGBO(245, 245, 245, 1);
    tooltipStrokeWidth ??= 1.0;
    tooltipBorderRadius ??= BorderRadius.all(Radius.circular(4.0));
    toggledItemColor ??= isLight
        ? const Color.fromRGBO(245, 245, 245, 1)
        : const Color.fromRGBO(66, 66, 66, 1);
    toggledItemStrokeColor ??= isLight
        ? const Color.fromRGBO(158, 158, 158, 1)
        : const Color.fromRGBO(97, 97, 97, 1);

    return SfMapsThemeData.raw(
      brightness: brightness,
      layerColor: layerColor,
      layerStrokeColor: layerStrokeColor,
      shapeHoverColor: shapeHoverColor,
      shapeHoverStrokeColor: shapeHoverStrokeColor,
      legendTextStyle: legendTextStyle,
      markerIconColor: markerIconColor,
      markerIconStrokeColor: markerIconStrokeColor,
      dataLabelTextStyle: dataLabelTextStyle,
      bubbleColor: bubbleColor,
      bubbleStrokeColor: bubbleStrokeColor,
      bubbleStrokeWidth: bubbleStrokeWidth,
      bubbleHoverColor: bubbleHoverColor,
      bubbleHoverStrokeColor: bubbleHoverStrokeColor,
      bubbleHoverStrokeWidth: bubbleHoverStrokeWidth,
      selectionColor: selectionColor,
      selectionStrokeColor: selectionStrokeColor,
      tooltipColor: tooltipColor,
      tooltipStrokeColor: tooltipStrokeColor,
      tooltipStrokeWidth: tooltipStrokeWidth,
      tooltipBorderRadius: tooltipBorderRadius,
      selectionStrokeWidth: selectionStrokeWidth,
      layerStrokeWidth: layerStrokeWidth,
      shapeHoverStrokeWidth: shapeHoverStrokeWidth,
      markerIconStrokeWidth: markerIconStrokeWidth,
      toggledItemColor: toggledItemColor,
      toggledItemStrokeColor: toggledItemStrokeColor,
      toggledItemStrokeWidth: toggledItemStrokeWidth,
    );
  }

  /// Create a [SfMapsThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfMapsThemeData] constructor.
  const SfMapsThemeData.raw({
    required this.brightness,
    required this.layerColor,
    required this.layerStrokeColor,
    required this.layerStrokeWidth,
    required this.shapeHoverColor,
    required this.shapeHoverStrokeColor,
    required this.shapeHoverStrokeWidth,
    required this.legendTextStyle,
    required this.markerIconColor,
    required this.markerIconStrokeColor,
    required this.markerIconStrokeWidth,
    required this.dataLabelTextStyle,
    required this.bubbleColor,
    required this.bubbleStrokeColor,
    required this.bubbleStrokeWidth,
    required this.bubbleHoverColor,
    required this.bubbleHoverStrokeColor,
    required this.bubbleHoverStrokeWidth,
    required this.selectionColor,
    required this.selectionStrokeColor,
    required this.selectionStrokeWidth,
    required this.tooltipColor,
    required this.tooltipStrokeColor,
    required this.tooltipStrokeWidth,
    required this.tooltipBorderRadius,
    required this.toggledItemColor,
    required this.toggledItemStrokeColor,
    required this.toggledItemStrokeWidth,
  });

  /// The brightness of the overall theme of the
  /// application for the maps widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// maps widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              brightness: Brightness.dark
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Brightness brightness;

  /// Specifies the fill color for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerColor: Colors.red[400]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color layerColor;

  /// Specifies the stroke color for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerStrokeColor: Colors.red
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color layerStrokeColor;

  /// Specifies the stroke width for maps layer.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              layerStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double layerStrokeWidth;

  /// Specifies the color which should apply on the shapes while hovering in
  /// the web platform.
  ///
  /// By default, the transparency of your current shape color will be altered
  /// and applied while hovering. This might be useful if you are having
  /// different color for each shape.
  ///
  /// However, if you set this property, this color
  /// will be commonly applied to the all the shapes while hovering.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              shapeHoverColor : Colors.grey
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [shapeHoverStrokeColor], [shapeHoverStrokeWidth], to set the stroke
  /// for the hovered shapes.
  final Color? shapeHoverColor;

  /// Specifies the color which should apply on the stroke of the shapes while
  /// hovering in the web platform.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              shapeHoverStrokeColor : Colors.black
  ///              shapeHoverStrokeWidth : 2.0
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color? shapeHoverStrokeColor;

  /// Specifies the stroke which should apply on the stroke of the shapes while
  /// hovering in the web platform.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              shapeHoverStrokeColor : Colors.black
  ///              shapeHoverStrokeWidth : 2.0
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double? shapeHoverStrokeWidth;

  /// Specifies the text style of the legend.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              legendTextStyle: TextStyle(decoration:
  ///              TextDecoration.underline)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle? legendTextStyle;

  /// Specifies the fill color for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconColor: Colors.green[400]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color markerIconColor;

  /// Specifies the stroke color for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconStrokeColor: Colors.green[900]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color? markerIconStrokeColor;

  /// Specifies the stroke width for marker icon.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              markerIconStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double markerIconStrokeWidth;

  /// Specifies the TextStyle for data label.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              dataLabelTextStyle: TextStyle(color: Colors.red)
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle? dataLabelTextStyle;

  /// Specifies the fill color for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleColor: Colors.blue
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color bubbleColor;

  /// Specifies the stroke color for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleStrokeColor: Colors.indigo
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color bubbleStrokeColor;

  /// Specifies the stroke width for bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleStrokeWidth: 3
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double bubbleStrokeWidth;

  /// Specifies the color which should apply on the bubbles while hovering in
  /// the web platform.
  ///
  /// By default, the transparency of your current bubble color will be altered
  /// and applied while hovering. This might be useful if you are having
  /// different color for each bubble.
  ///
  /// However, if you set this property, this color
  /// will be commonly applied to the all the bubbles while hovering.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleHoverColor : Colors.grey
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [bubbleHoverStrokeColor], [bubbleHoverStrokeWidth], to set the stroke
  /// for the hovered shapes.
  final Color? bubbleHoverColor;

  /// Specifies the color which should apply on the stroke of the bubbles while
  /// hovering in the web platform.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleHoverStrokeColor : Colors.black
  ///              bubbleHoverStrokeWidth : 2.0
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color? bubbleHoverStrokeColor;

  /// Specifies the stroke which should apply on the stroke of the bubbles while
  /// hovering in the web platform.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              bubbleHoverStrokeColor : Colors.black
  ///              bubbleHoverStrokeWidth : 2.0
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double? bubbleHoverStrokeWidth;

  /// Specifies the fill color for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionColor: Colors.indigo[200]
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color selectionColor;

  /// Specifies the stroke color for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionStrokeColor: Colors.indigo
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color selectionStrokeColor;

  /// Specifies the stroke width for selected shape.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              selectionStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double selectionStrokeWidth;

  /// Specifies the fill color for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipColor: Colors.tealAccent
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color tooltipColor;

  /// Specifies the stroke color for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipStrokeColor: Colors.teal
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color? tooltipStrokeColor;

  /// Specifies the stroke width for tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              tooltipStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double tooltipStrokeWidth;

  /// Specifies the border radius of the tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///             tooltipBorderRadius: BorderRadiusDirectional.only(
  ///              topEnd: Radius.elliptical(20, 20),
  ///              bottomStart: Radius.elliptical(20, 20),
  ///              ),
  ///            ),
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [BorderRadius](https://api.flutter.dev/flutter/painting/BorderRadius-class.html),
  /// for setting the corner radii.
  /// * [BorderRadiusDirectional](https://api.flutter.dev/flutter/painting/BorderRadiusDirectional-class.html),
  /// for setting the corner radii based on the text direction.
  final BorderRadiusGeometry tooltipBorderRadius;

  /// Fills the toggled legend item's icon and the respective shape or bubble
  /// by this color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledItemColor: Colors.yellow
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeColor], [toggledItemStrokeWidth], to set the stroke
  /// for the toggled legend item's shape or bubble.
  final Color toggledItemColor;

  /// Stroke color for the toggled legend item's respective shape or bubble.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledItemStrokeColor: Colors.green,
  ///              toggledItemStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final Color toggledItemStrokeColor;

  /// Stroke width for the toggled legend item's respective shape or bubble.
  ///
  /// Defaults to 1.0.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            mapsThemeData: SfMapsThemeData(
  ///              toggledItemStrokeColor: Colors.green,
  ///              toggledItemStrokeWidth: 2
  ///            )
  ///          ),
  ///          child: SfMaps(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final double? toggledItemStrokeWidth;

  /// Creates a copy of this theme but with the given
  /// fields replaced with the new values.
  SfMapsThemeData copyWith({
    Brightness? brightness,
    Color? layerColor,
    Color? layerStrokeColor,
    double? layerStrokeWidth,
    Color? shapeHoverColor,
    Color? shapeHoverStrokeColor,
    double? shapeHoverStrokeWidth,
    TextStyle? legendTextStyle,
    Color? markerIconColor,
    Color? markerIconStrokeColor,
    double? markerIconStrokeWidth,
    TextStyle? dataLabelTextStyle,
    Color? bubbleColor,
    Color? bubbleStrokeColor,
    double? bubbleStrokeWidth,
    Color? bubbleHoverColor,
    Color? bubbleHoverStrokeColor,
    double? bubbleHoverStrokeWidth,
    Color? selectionColor,
    Color? selectionStrokeColor,
    double? selectionStrokeWidth,
    Color? tooltipColor,
    Color? tooltipStrokeColor,
    double? tooltipStrokeWidth,
    BorderRadiusGeometry? tooltipBorderRadius,
    Color? toggledItemColor,
    Color? toggledItemStrokeColor,
    double? toggledItemStrokeWidth,
  }) {
    return SfMapsThemeData.raw(
      brightness: brightness ?? this.brightness,
      layerColor: layerColor ?? this.layerColor,
      layerStrokeColor: layerStrokeColor ?? this.layerStrokeColor,
      layerStrokeWidth: layerStrokeWidth ?? this.layerStrokeWidth,
      shapeHoverColor: shapeHoverColor ?? this.shapeHoverColor,
      shapeHoverStrokeColor:
          shapeHoverStrokeColor ?? this.shapeHoverStrokeColor,
      shapeHoverStrokeWidth:
          shapeHoverStrokeWidth ?? this.shapeHoverStrokeWidth,
      legendTextStyle: legendTextStyle ?? this.legendTextStyle,
      markerIconColor: markerIconColor ?? this.markerIconColor,
      markerIconStrokeColor:
          markerIconStrokeColor ?? this.markerIconStrokeColor,
      markerIconStrokeWidth:
          markerIconStrokeWidth ?? this.markerIconStrokeWidth,
      dataLabelTextStyle: dataLabelTextStyle ?? this.dataLabelTextStyle,
      bubbleColor: bubbleColor ?? this.bubbleColor,
      bubbleStrokeColor: bubbleStrokeColor ?? this.bubbleStrokeColor,
      bubbleStrokeWidth: bubbleStrokeWidth ?? this.bubbleStrokeWidth,
      bubbleHoverColor: bubbleHoverColor ?? this.bubbleHoverColor,
      bubbleHoverStrokeColor:
          bubbleHoverStrokeColor ?? this.bubbleHoverStrokeColor,
      bubbleHoverStrokeWidth:
          bubbleHoverStrokeWidth ?? this.bubbleHoverStrokeWidth,
      selectionColor: selectionColor ?? this.selectionColor,
      selectionStrokeColor: selectionStrokeColor ?? this.selectionStrokeColor,
      selectionStrokeWidth: selectionStrokeWidth ?? this.selectionStrokeWidth,
      tooltipColor: tooltipColor ?? this.tooltipColor,
      tooltipStrokeColor: tooltipStrokeColor ?? this.tooltipStrokeColor,
      tooltipStrokeWidth: tooltipStrokeWidth ?? this.tooltipStrokeWidth,
      tooltipBorderRadius: tooltipBorderRadius ?? this.tooltipBorderRadius,
      toggledItemColor: toggledItemColor ?? this.toggledItemColor,
      toggledItemStrokeColor:
          toggledItemStrokeColor ?? this.toggledItemStrokeColor,
      toggledItemStrokeWidth:
          toggledItemStrokeWidth ?? this.toggledItemStrokeWidth,
    );
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  static SfMapsThemeData? lerp(
      SfMapsThemeData? a, SfMapsThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfMapsThemeData(
      layerColor: Color.lerp(a!.layerColor, b!.layerColor, t),
      layerStrokeColor: Color.lerp(a.layerStrokeColor, b.layerStrokeColor, t),
      layerStrokeWidth: lerpDouble(a.layerStrokeWidth, b.layerStrokeWidth, t),
      shapeHoverColor: Color.lerp(a.shapeHoverColor, b.shapeHoverColor, t),
      shapeHoverStrokeColor:
          Color.lerp(a.shapeHoverStrokeColor, b.shapeHoverStrokeColor, t),
      shapeHoverStrokeWidth:
          lerpDouble(a.shapeHoverStrokeWidth, b.shapeHoverStrokeWidth, t),
      legendTextStyle: TextStyle.lerp(a.legendTextStyle, b.legendTextStyle, t),
      markerIconColor: Color.lerp(a.markerIconColor, b.markerIconColor, t),
      markerIconStrokeColor:
          Color.lerp(a.markerIconStrokeColor, b.markerIconStrokeColor, t),
      markerIconStrokeWidth:
          lerpDouble(a.markerIconStrokeWidth, b.markerIconStrokeWidth, t),
      dataLabelTextStyle:
          TextStyle.lerp(a.dataLabelTextStyle, b.dataLabelTextStyle, t),
      bubbleColor: Color.lerp(a.bubbleColor, b.bubbleColor, t),
      bubbleStrokeColor:
          Color.lerp(a.bubbleStrokeColor, b.bubbleStrokeColor, t),
      bubbleStrokeWidth:
          lerpDouble(a.bubbleStrokeWidth, b.bubbleStrokeWidth, t),
      bubbleHoverColor: Color.lerp(a.bubbleHoverColor, b.bubbleHoverColor, t),
      bubbleHoverStrokeColor:
          Color.lerp(a.bubbleHoverStrokeColor, b.bubbleHoverStrokeColor, t),
      bubbleHoverStrokeWidth:
          lerpDouble(a.bubbleHoverStrokeWidth, b.bubbleHoverStrokeWidth, t),
      selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
      selectionStrokeColor:
          Color.lerp(a.selectionStrokeColor, b.selectionStrokeColor, t),
      selectionStrokeWidth:
          lerpDouble(a.selectionStrokeWidth, b.selectionStrokeWidth, t),
      tooltipColor: Color.lerp(a.tooltipColor, b.tooltipColor, t),
      tooltipStrokeColor:
          Color.lerp(a.tooltipStrokeColor, b.tooltipStrokeColor, t),
      tooltipStrokeWidth:
          lerpDouble(a.tooltipStrokeWidth, b.tooltipStrokeWidth, t),
      tooltipBorderRadius: BorderRadiusGeometry.lerp(
          a.tooltipBorderRadius, b.tooltipBorderRadius, t),
      toggledItemColor: Color.lerp(a.toggledItemColor, b.toggledItemColor, t),
      toggledItemStrokeColor:
          Color.lerp(a.toggledItemStrokeColor, b.toggledItemStrokeColor, t),
      toggledItemStrokeWidth:
          lerpDouble(a.toggledItemStrokeWidth, b.toggledItemStrokeWidth, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SfMapsThemeData &&
        other.layerColor == layerColor &&
        other.layerStrokeColor == layerStrokeColor &&
        other.layerStrokeWidth == layerStrokeWidth &&
        other.shapeHoverColor == shapeHoverColor &&
        other.shapeHoverStrokeColor == shapeHoverStrokeColor &&
        other.shapeHoverStrokeWidth == shapeHoverStrokeWidth &&
        other.legendTextStyle == legendTextStyle &&
        other.markerIconColor == markerIconColor &&
        other.markerIconStrokeColor == markerIconStrokeColor &&
        other.markerIconStrokeWidth == markerIconStrokeWidth &&
        other.dataLabelTextStyle == dataLabelTextStyle &&
        other.bubbleColor == bubbleColor &&
        other.bubbleStrokeColor == bubbleStrokeColor &&
        other.bubbleStrokeWidth == bubbleStrokeWidth &&
        other.bubbleHoverColor == bubbleHoverColor &&
        other.bubbleHoverStrokeColor == bubbleHoverStrokeColor &&
        other.bubbleHoverStrokeWidth == bubbleHoverStrokeWidth &&
        other.selectionColor == selectionColor &&
        other.selectionStrokeColor == selectionStrokeColor &&
        other.selectionStrokeWidth == selectionStrokeWidth &&
        other.tooltipColor == tooltipColor &&
        other.tooltipStrokeColor == tooltipStrokeColor &&
        other.tooltipStrokeWidth == tooltipStrokeWidth &&
        other.tooltipBorderRadius == tooltipBorderRadius &&
        other.toggledItemColor == toggledItemColor &&
        other.toggledItemStrokeColor == toggledItemStrokeColor &&
        other.toggledItemStrokeWidth == toggledItemStrokeWidth;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      layerColor,
      layerStrokeColor,
      layerStrokeWidth,
      shapeHoverColor,
      shapeHoverStrokeColor,
      shapeHoverStrokeWidth,
      legendTextStyle,
      markerIconColor,
      markerIconStrokeColor,
      markerIconStrokeWidth,
      dataLabelTextStyle,
      bubbleColor,
      bubbleStrokeColor,
      bubbleStrokeWidth,
      bubbleHoverColor,
      bubbleHoverStrokeColor,
      bubbleHoverStrokeWidth,
      selectionColor,
      selectionStrokeColor,
      selectionStrokeWidth,
      tooltipColor,
      tooltipStrokeColor,
      tooltipStrokeWidth,
      tooltipBorderRadius,
      toggledItemColor,
      toggledItemStrokeColor,
      toggledItemStrokeWidth,
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfMapsThemeData defaultData = SfMapsThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('layerColor', layerColor,
        defaultValue: defaultData.layerColor));
    properties.add(ColorProperty('layerStrokeColor', layerStrokeColor,
        defaultValue: defaultData.layerStrokeColor));
    properties.add(DoubleProperty('layerStrokeWidth', layerStrokeWidth,
        defaultValue: defaultData.layerStrokeWidth));
    properties.add(ColorProperty('shapeHoverColor', shapeHoverColor,
        defaultValue: defaultData.shapeHoverColor));
    properties.add(ColorProperty('shapeHoverStrokeColor', shapeHoverStrokeColor,
        defaultValue: defaultData.shapeHoverStrokeColor));
    properties.add(DoubleProperty(
        'shapeHoverStrokeWidth', shapeHoverStrokeWidth,
        defaultValue: defaultData.shapeHoverStrokeWidth));
    properties.add(DiagnosticsProperty<TextStyle>(
        'legendTextStyle', legendTextStyle,
        defaultValue: defaultData.legendTextStyle));
    properties.add(ColorProperty('markerIconColor', markerIconColor,
        defaultValue: defaultData.markerIconColor));
    properties.add(ColorProperty('markerIconStrokeColor', markerIconStrokeColor,
        defaultValue: defaultData.markerIconStrokeColor));
    properties.add(DoubleProperty(
        'markerIconStrokeWidth', markerIconStrokeWidth,
        defaultValue: defaultData.markerIconStrokeWidth));
    properties.add(DiagnosticsProperty<TextStyle>(
        'dataLabelTextStyle', dataLabelTextStyle,
        defaultValue: defaultData.dataLabelTextStyle));
    properties.add(ColorProperty('bubbleColor', bubbleColor,
        defaultValue: defaultData.bubbleColor));
    properties.add(ColorProperty('bubbleStrokeColor', bubbleStrokeColor,
        defaultValue: defaultData.bubbleStrokeColor));
    properties.add(DoubleProperty('bubbleStrokeWidth', bubbleStrokeWidth,
        defaultValue: defaultData.bubbleStrokeWidth));
    properties.add(ColorProperty('bubbleHoverColor', bubbleHoverColor,
        defaultValue: defaultData.bubbleHoverColor));
    properties.add(ColorProperty(
        'bubbleHoverStrokeColor', bubbleHoverStrokeColor,
        defaultValue: defaultData.bubbleHoverStrokeColor));
    properties.add(DoubleProperty(
        'bubbleHoverStrokeWidth', bubbleHoverStrokeWidth,
        defaultValue: defaultData.bubbleHoverStrokeWidth));
    properties.add(ColorProperty('selectionColor', selectionColor,
        defaultValue: defaultData.selectionColor));
    properties.add(ColorProperty('selectionStrokeColor', selectionStrokeColor,
        defaultValue: defaultData.selectionStrokeColor));
    properties.add(DoubleProperty('selectionStrokeWidth', selectionStrokeWidth,
        defaultValue: defaultData.selectionStrokeWidth));
    properties.add(ColorProperty('tooltipColor', tooltipColor,
        defaultValue: defaultData.tooltipColor));
    properties.add(ColorProperty('tooltipStrokeColor', tooltipStrokeColor,
        defaultValue: defaultData.tooltipStrokeColor));
    properties.add(DoubleProperty('tooltipStrokeWidth', tooltipStrokeWidth,
        defaultValue: defaultData.tooltipStrokeWidth));
    properties.add(DiagnosticsProperty<BorderRadiusGeometry>(
        'tooltipBorderRadius', tooltipBorderRadius,
        defaultValue: defaultData.tooltipBorderRadius));
    properties.add(ColorProperty('toggledItemColor', toggledItemColor,
        defaultValue: defaultData.toggledItemColor));
    properties.add(ColorProperty(
        'toggledItemStrokeColor', toggledItemStrokeColor,
        defaultValue: defaultData.toggledItemStrokeColor));
    properties.add(DoubleProperty(
        'toggledItemStrokeWidth', toggledItemStrokeWidth,
        defaultValue: defaultData.toggledItemStrokeWidth));
  }
}
