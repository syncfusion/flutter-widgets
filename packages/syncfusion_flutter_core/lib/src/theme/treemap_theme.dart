import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

/// Applies a theme to descendant Syncfusion treemap widgets.
///
/// To obtain the current theme, use [SfTreemapTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemapTheme(
///       data: SfTreemapThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfTreemap(),
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the treemap widgets.
///
class SfTreemapTheme extends InheritedTheme {
  ///Initialize the class of SfTreemapTheme
  const SfTreemapTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant Treemap widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemapTheme(
  ///       data: SfTreemapThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfTreemap(),
  ///     ),
  ///   );
  /// }
  /// ```

  final SfTreemapThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfTreemapTheme(
  ///       data: SfTreemapThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfTreemap(),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfTreemapTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfTreemapTheme.treemapThemeData]
  /// if there is no [SfTreemapTheme] in the given build context.
  static SfTreemapThemeData of(BuildContext context) {
    final SfTreemapTheme? sfTreemapTheme =
        context.dependOnInheritedWidgetOfExactType<SfTreemapTheme>();
    return sfTreemapTheme?.data ?? SfTheme.of(context).treemapThemeData;
  }

  @override
  bool updateShouldNotify(SfTreemapTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfTreemapTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfTreemapTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfTreemapTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfTreemapTheme].
/// Applies a theme to descendant Syncfusion treemap widgets.
///
/// To obtain the current theme, use [SfTreemapTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfTreemapTheme(
///       data: SfTreemapThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfTreemap(),
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the treemap widgets.

@immutable
class SfTreemapThemeData with Diagnosticable {
  ///Initialize the sfTreemap theme data
  factory SfTreemapThemeData({
    Brightness? brightness,
    TextStyle? legendTextStyle,
  }) {
    brightness = brightness ?? Brightness.light;

    return SfTreemapThemeData.raw(
        brightness: brightness, legendTextStyle: legendTextStyle);
  }

  /// Create a [SfTreemapThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfTreemapThemeData] constructor.
  const SfTreemapThemeData.raw({
    required this.brightness,
    required this.legendTextStyle,
  });

  /// The brightness of the overall theme of the
  /// application for the treemap widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// treemap widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            treemapThemeData: SfTreemapThemeData(
  ///              brightness: Brightness.dark
  ///              ),
  ///            ),
  ///          child: SfTreemap(),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Brightness brightness;

  /// Specifies the legend text style of treemap widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            treemapThemeData: SfTreemapThemeData(
  ///              legendTextStyle: TextStyle(color: Colors.blue),
  ///              ),
  ///            ),
  ///          child: SfTreemap(),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final TextStyle? legendTextStyle;

  /// Creates a copy of this treemap theme data object with the matching fields
  /// replaced with the non-null parameter values.
  SfTreemapThemeData copyWith({
    Brightness? brightness,
    TextStyle? legendTextStyle,
  }) {
    return SfTreemapThemeData.raw(
        brightness: brightness ?? this.brightness,
        legendTextStyle: legendTextStyle ?? this.legendTextStyle);
  }

  /// Returns the treemap theme data
  static SfTreemapThemeData? lerp(
      SfTreemapThemeData? a, SfTreemapThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfTreemapThemeData(
        legendTextStyle:
            TextStyle.lerp(a!.legendTextStyle, b!.legendTextStyle, t));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SfTreemapThemeData &&
        other.legendTextStyle == legendTextStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[legendTextStyle];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfTreemapThemeData defaultData = SfTreemapThemeData();
    properties.add(DiagnosticsProperty<TextStyle>(
        'legendTextStyle', legendTextStyle,
        defaultValue: defaultData.legendTextStyle));
  }
}
