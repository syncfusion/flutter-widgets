import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion spark chart widgets.
///
/// To obtain the current theme, use [SfSparkChartTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfSparkChartTheme(
///       data: SfSparkChartThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfSparkLineChart(),
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the spark chart widgets.
///
class SfSparkChartTheme extends InheritedTheme {
  /// Initialize the class of SfSparkChartTheme
  const SfSparkChartTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant
  /// spark chart widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfSparkChartTheme(
  ///       data: SfSparkChartThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfSparkLineChart(),
  ///     ),
  ///   );
  /// }
  /// ```

  final SfSparkChartThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfSparkChartTheme(
  ///       data: SfSparkChartThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfSparkLineChart(),
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfSparkChartTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfSparkChartTheme.SparkChartThemeData]
  /// if there is no [SfSparkChartTheme] in the given build context.
  static SfSparkChartThemeData of(BuildContext context) {
    final SfSparkChartTheme? sfSparkChartTheme =
        context.dependOnInheritedWidgetOfExactType<SfSparkChartTheme>();
    return sfSparkChartTheme?.data ?? SfTheme.of(context).sparkChartThemeData;
  }

  @override
  bool updateShouldNotify(SfSparkChartTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfSparkChartTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfSparkChartTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfSparkChartTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfSparkChartTheme].
/// Applies a theme to descendant Syncfusion spark charts widgets.
///
/// To obtain the current theme, use [SfSparkChartTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfSparkChartTheme(
///       data: SfSparkChartThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfSparkLineChart(),
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the spark chart widgets.
///
@immutable
class SfSparkChartThemeData with Diagnosticable {
  /// Initialize the Sfspark chart theme data
  const SfSparkChartThemeData({
    this.backgroundColor,
    this.color,
    this.axisLineColor,
    this.markerFillColor,
    this.dataLabelBackgroundColor,
    this.tooltipColor,
    this.trackballLineColor,
    this.tooltipLabelColor,
    this.dataLabelTextStyle,
    this.trackballTextStyle,
  });

  /// Create a [SfSparkChartThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfSparkChartThemeData] constructor.
  factory SfSparkChartThemeData.raw({
    Brightness? brightness,
    Color? backgroundColor,
    Color? color,
    Color? axisLineColor,
    Color? markerFillColor,
    Color? dataLabelBackgroundColor,
    Color? tooltipColor,
    Color? trackballLineColor,
    Color? tooltipLabelColor,
    TextStyle? dataLabelTextStyle,
    TextStyle? trackballTextStyle,
  }) {
    brightness = brightness ?? Brightness.light;

    return SfSparkChartThemeData(
      backgroundColor: backgroundColor,
      color: color,
      axisLineColor: axisLineColor,
      markerFillColor: markerFillColor,
      dataLabelBackgroundColor: dataLabelBackgroundColor,
      tooltipColor: tooltipColor,
      trackballLineColor: trackballLineColor,
      tooltipLabelColor: tooltipLabelColor,
      dataLabelTextStyle: dataLabelTextStyle,
      trackballTextStyle: trackballTextStyle,
    );
  }

  /// Specifies the background color of spark chart widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            SparkChartThemeData: SfSparkChartThemeData(
  ///              backgroundColor: Colors.yellow
  ///              ),
  ///            ),
  ///          child: SfSparkLineChart(),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color? backgroundColor;

  /// Specifies the color for axis line.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             axisLineColor: Colors.blue
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? axisLineColor;

  /// Specifies the color of the spark chart.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             color: Colors.blue
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? color;

  /// Specifies the color for chart marker.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             markerFillColor: Colors.red
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? markerFillColor;

  /// Specifies the background color for data labels.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             dataLabelBackgroundColor: Colors.red
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? dataLabelBackgroundColor;

  /// Specifies the color of the tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             tooltipColor: Colors.teal
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? tooltipColor;

  /// Specifies the tooltip line color.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             trackballLineColor: Colors.red
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? trackballLineColor;

  /// Specifies the text color of the tooltip.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///       child: SfTheme(
  ///         data: SfThemeData(
  ///           sparkChartThemeData: SfSparkChartThemeData(
  ///             tooltipLabelColor: Colors.amber
  ///           )
  ///         ),
  ///         child: SfSparkLineChart(),
  ///       ),
  ///     )
  ///   );
  /// }
  ///```

  final Color? tooltipLabelColor;

  /// Specifies the data label text style for spark chart label text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            SparkChartThemeData: SfSparkChartThemeData(
  ///              dataLabelTextStyle: TextStyle(color: Colors.blue)
  ///              ),
  ///            ),
  ///          child: SfSparkLineChart(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle? dataLabelTextStyle;

  /// Specifies the trackball text style for spark chart label text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            SparkChartThemeData: SfSparkChartThemeData(
  ///              trackballTextStyle: TextStyle(color: Colors.blue)
  ///              ),
  ///            ),
  ///          child: SfSparkLineChart(),
  ///        ),
  ///      )
  ///   );
  /// }
  /// ```
  final TextStyle? trackballTextStyle;

  /// Creates a copy of this spark chart theme data object with the
  /// matching fields
  /// replaced with the non-null parameter values.
  SfSparkChartThemeData copyWith({
    Brightness? brightness,
    Color? backgroundColor,
    Color? color,
    Color? axisLineColor,
    Color? markerFillColor,
    Color? dataLabelBackgroundColor,
    Color? tooltipColor,
    Color? trackballLineColor,
    Color? tooltipLabelColor,
    TextStyle? dataLabelTextStyle,
    TextStyle? trackballTextStyle,
  }) {
    return SfSparkChartThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        color: color ?? this.color,
        axisLineColor: axisLineColor ?? this.axisLineColor,
        markerFillColor: markerFillColor ?? this.markerFillColor,
        dataLabelBackgroundColor:
            dataLabelBackgroundColor ?? this.dataLabelBackgroundColor,
        tooltipColor: tooltipColor ?? this.tooltipColor,
        trackballLineColor: trackballLineColor ?? this.trackballLineColor,
        tooltipLabelColor: tooltipLabelColor ?? this.tooltipLabelColor,
        dataLabelTextStyle: dataLabelTextStyle ?? this.dataLabelTextStyle,
        trackballTextStyle: trackballTextStyle ?? this.trackballTextStyle);
  }

  /// Returns the spark chart theme data
  static SfSparkChartThemeData? lerp(
      SfSparkChartThemeData? a, SfSparkChartThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfSparkChartThemeData(
      backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
      color: Color.lerp(a.color, b.color, t),
      axisLineColor: Color.lerp(a.axisLineColor, b.axisLineColor, t),
      markerFillColor: Color.lerp(a.markerFillColor, b.markerFillColor, t),
      dataLabelBackgroundColor:
          Color.lerp(a.dataLabelBackgroundColor, b.dataLabelBackgroundColor, t),
      tooltipColor: Color.lerp(a.tooltipColor, b.tooltipColor, t),
      trackballLineColor:
          Color.lerp(a.trackballLineColor, b.trackballLineColor, t),
      tooltipLabelColor:
          Color.lerp(a.tooltipLabelColor, b.tooltipLabelColor, t),
      dataLabelTextStyle:
          TextStyle.lerp(a.dataLabelTextStyle, b.dataLabelTextStyle, t),
      trackballTextStyle:
          TextStyle.lerp(a.trackballTextStyle, b.trackballTextStyle, t),
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

    return other is SfSparkChartThemeData &&
        other.backgroundColor == backgroundColor &&
        other.color == color &&
        other.axisLineColor == axisLineColor &&
        other.markerFillColor == markerFillColor &&
        other.dataLabelBackgroundColor == dataLabelBackgroundColor &&
        other.tooltipColor == tooltipColor &&
        other.trackballLineColor == trackballLineColor &&
        other.tooltipLabelColor == tooltipLabelColor &&
        other.dataLabelTextStyle == dataLabelTextStyle &&
        other.trackballTextStyle == trackballTextStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      backgroundColor,
      color,
      axisLineColor,
      markerFillColor,
      dataLabelBackgroundColor,
      tooltipColor,
      trackballLineColor,
      tooltipLabelColor,
      dataLabelTextStyle,
      trackballTextStyle,
    ];
    return Object.hashAll(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const SfSparkChartThemeData defaultData = SfSparkChartThemeData();
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties
        .add(ColorProperty('color', color, defaultValue: defaultData.color));
    properties.add(ColorProperty('axisLineColor', axisLineColor,
        defaultValue: defaultData.axisLineColor));
    properties.add(ColorProperty('markerFillColor', markerFillColor,
        defaultValue: defaultData.markerFillColor));
    properties.add(ColorProperty(
        'dataLabelBackgroundColor', dataLabelBackgroundColor,
        defaultValue: defaultData.dataLabelBackgroundColor));
    properties.add(ColorProperty('tooltipColor', tooltipColor,
        defaultValue: defaultData.tooltipColor));
    properties.add(ColorProperty('trackballLineColor', trackballLineColor,
        defaultValue: defaultData.trackballLineColor));
    properties.add(ColorProperty('tooltipLabelColor', tooltipLabelColor,
        defaultValue: defaultData.tooltipLabelColor));
    properties.add(
      DiagnosticsProperty<TextStyle>('dataLabelTextStyle', dataLabelTextStyle,
          defaultValue: defaultData.dataLabelTextStyle),
    );
    properties.add(
      DiagnosticsProperty<TextStyle>('trackballTextStyle', trackballTextStyle,
          defaultValue: defaultData.trackballTextStyle),
    );
  }
}
