import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion radial gauges widgets.
///
/// To obtain the current theme, use [SfBarcodeTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfGaugeTheme(
///       data: SfGaugeThemeData(
///         brightness: Brightness.dark,
///         backgroundColor: Colors.grey
///       ),
///       child: SfRadialGauge()
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the radial gauges widgets.
///
class SfGaugeTheme extends InheritedTheme {
  /// Initialize the gauge theme
  const SfGaugeTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant gauges widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfGaugeTheme(
  ///       data: SfGaugeThemeData(
  ///         brightness: Brightness.dark,
  ///         backgroundColor: Colors.grey
  ///       ),
  ///       child: SfRadialGauge()
  ///     ),
  ///   );
  /// }
  /// ```
  final SfGaugeThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfGaugeTheme(
  ///       data: SfGaugeThemeData(
  ///         brightness: Brightness.dark,
  ///         backgroundColor: Colors.grey
  ///       ),
  ///       child: SfRadialGauge()
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfGaugeTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [SfGaugeTheme.gaugeThemeData]
  /// if there is no [SfGaugeTheme] in the given
  /// build context.
  static SfGaugeThemeData? of(BuildContext context) {
    final SfGaugeTheme? sfGaugeTheme =
        context.dependOnInheritedWidgetOfExactType<SfGaugeTheme>();
    return sfGaugeTheme?.data ?? SfTheme.of(context).gaugeThemeData;
  }

  @override
  bool updateShouldNotify(SfGaugeTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfGaugeTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfGaugeTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfGaugeTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfGaugeTheme]. Use
///  this class to configure a [SfGaugeTheme] widget
///
/// To obtain the current theme, use [SfGaugeTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfGaugeTheme(
///       data: SfGaugeThemeData(
///         brightness: Brightness.dark,
///         backgroundColor: Colors.grey
///       ),
///       child: SfRadialGauge()
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the radial gauges widgets.
///
class SfGaugeThemeData with Diagnosticable {
  /// Initialize the gauge theme data
  factory SfGaugeThemeData({
    Brightness? brightness,
    Color? backgroundColor,
    Color? titleColor,
    Color? axisLabelColor,
    Color? axisLineColor,
    Color? majorTickColor,
    Color? minorTickColor,
    Color? markerColor,
    Color? markerBorderColor,
    Color? needleColor,
    Color? knobColor,
    Color? knobBorderColor,
    Color? tailColor,
    Color? tailBorderColor,
    Color? rangePointerColor,
    Color? rangeColor,
    Color? titleBorderColor,
    Color? titleBackgroundColor,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= Colors.transparent;
    titleColor ??= isLight ? const Color(0xFF333333) : const Color(0xFFF5F5F5);
    axisLabelColor ??=
        isLight ? const Color(0xFF333333) : const Color(0xFFF5F5F5);
    axisLineColor ??=
        isLight ? const Color(0xFFDADADA) : const Color(0xFF555555);
    majorTickColor ??=
        isLight ? const Color(0xFF999999) : const Color(0xFF888888);
    minorTickColor ??=
        isLight ? const Color(0xFFC4C4C4) : const Color(0xFF666666);
    markerColor ??= isLight ? const Color(0xFF00A8B5) : const Color(0xFF00A8B5);
    markerBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    needleColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    knobColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    knobBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    tailColor ??= isLight ? const Color(0xFF3A3A3A) : const Color(0xFFEEEEEE);
    tailBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    rangePointerColor ??=
        isLight ? const Color(0xFF00A8B5) : const Color(0xFF00A8B5);
    rangeColor ??= isLight ? const Color(0xFFF67280) : const Color(0xFFF67280);
    titleBorderColor ??= isLight ? Colors.transparent : Colors.transparent;
    titleBackgroundColor ??= isLight ? Colors.transparent : Colors.transparent;

    return SfGaugeThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor,
        titleColor: titleColor,
        axisLabelColor: axisLabelColor,
        axisLineColor: axisLineColor,
        majorTickColor: majorTickColor,
        minorTickColor: minorTickColor,
        markerColor: markerColor,
        markerBorderColor: markerBorderColor,
        needleColor: needleColor,
        knobColor: knobColor,
        knobBorderColor: knobBorderColor,
        tailColor: tailColor,
        tailBorderColor: tailBorderColor,
        rangePointerColor: rangePointerColor,
        rangeColor: rangeColor,
        titleBorderColor: titleBorderColor,
        titleBackgroundColor: titleBackgroundColor);
  }

  /// Create a [SfGaugeThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfGaugeThemeData] constructor.
  ///
  const SfGaugeThemeData.raw(
      {required this.brightness,
      required this.backgroundColor,
      required this.titleColor,
      required this.axisLabelColor,
      required this.axisLineColor,
      required this.majorTickColor,
      required this.minorTickColor,
      required this.markerColor,
      required this.markerBorderColor,
      required this.needleColor,
      required this.knobColor,
      required this.knobBorderColor,
      required this.tailColor,
      required this.tailBorderColor,
      required this.rangePointerColor,
      required this.rangeColor,
      required this.titleBorderColor,
      required this.titleBackgroundColor});

  /// The brightness of the overall theme of the
  /// application for the gauge widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// radial gauge widgets will be applied.
  ///
  /// Also refer [Brightness].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(),
  ///       body: Center(
  ///         child: SfTheme(
  ///           data: SfThemeData(
  ///             gaugeThemeData: SfGaugeThemeData(
  ///               brightness: Brightness.dark
  ///             )
  ///           ),
  ///           child: SfRadialGauge(),
  ///         ),
  ///       )
  ///   );
  /// }
  ///```
  final Brightness brightness;

  /// Specifies the background color of gauge widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     appBar: AppBar(),
  ///       body: Center(
  ///         child: SfTheme(
  ///           data: SfThemeData(
  ///             gaugeThemeData: SfGaugeThemeData(
  ///               backgroundColor: Colors.yellow
  ///             )
  ///           ),
  ///           child: SfRadialGauge(),
  ///         ),
  ///       )
  ///   );
  /// }
  ///```
  final Color backgroundColor;

  /// Specifies the title color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              titleColor: Colors.lightBlue
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            title: GaugeTitle(text: 'Title'),
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color titleColor;

  /// Specifies the axis label color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              axisLabelColor: Colors.red
  ///            )
  ///          ),
  ///          child: SfRadialGauge(),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color axisLabelColor;

  /// Specifies the axis line color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              axisLineColor: Colors.blue
  ///            )
  ///          ),
  ///          child: SfRadialGauge(),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color axisLineColor;

  /// Specifies the major tick line color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              majorTickColor: Colors.red
  ///            )
  ///          ),
  ///          child: SfRadialGauge(),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color majorTickColor;

  /// Specifies the minor tick line color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              minorTickColor: Colors.red[400]
  ///            )
  ///          ),
  ///          child: SfRadialGauge(),
  ///        ),
  ///      )
  ///   );
  ///}
  ///```
  final Color minorTickColor;

  /// Specifies the marker color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              markerColor: Colors.yellow
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  MarkerPointer(
  ///                    markerHeight: 20,
  ///                    markerWidth: 20,
  ///                    markerType: MarkerType.triangle,
  ///                    markerOffset: 17,
  ///                    value: 80,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color markerColor;

  /// Specifies the marker border color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              markerBorderColor: Colors.green
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  MarkerPointer(
  ///                    markerHeight: 20,
  ///                    markerWidth: 20,
  ///                    markerType: MarkerType.triangle,
  ///                    markerOffset: 17,
  ///                    value: 80,
  ///                    borderWidth: 2
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color markerBorderColor;

  /// Specifies the needle color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              needleColor: Colors.teal
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  NeedlePointer(
  ///                    needleStartWidth: 0,
  ///                    needleEndWidth: 5,
  ///                  )
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color needleColor;

  /// Specifies the knob color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              knobColor: Colors.yellow
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  NeedlePointer(
  ///                    needleStartWidth: 0,
  ///                    needleEndWidth: 5,
  ///                  )
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color knobColor;

  /// Specifies the knob border color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              knobBorderColor: Colors.purple
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  NeedlePointer(
  ///                    knobStyle: KnobStyle(
  ///                      borderWidth: 0.05,
  ///                    ),
  ///                    needleStartWidth: 0,
  ///                    needleEndWidth: 5,
  ///                  )
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color knobBorderColor;

  /// Specifies the tail color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              tailColor: Colors.blue
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  NeedlePointer(
  ///                    tailStyle: TailStyle(length: 0.5, width: 3),
  ///                    needleStartWidth: 0,
  ///                    needleEndWidth: 5,
  ///                  )
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color tailColor;

  /// Specifies the tail border color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              tailBorderColor: Colors.redAccent
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  NeedlePointer(
  ///                    tailStyle: TailStyle(length: 0.5, width: 3,
  ///                      borderWidth: 2
  ///                    ),
  ///                    needleStartWidth: 0,
  ///                    needleEndWidth: 5,
  ///                  )
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color tailBorderColor;

  /// Specifies the range pointer color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              rangePointerColor: Colors.red
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                pointers: <GaugePointer>[
  ///                  RangePointer(
  ///                    value: 11.5,
  ///                    width: 0.1,
  ///                    sizeUnit: GaugeSizeUnit.factor,
  ///                  ),
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color rangePointerColor;

  /// Specifies the range color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              rangeColor: Colors.cyan
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            axes: <RadialAxis>[
  ///              RadialAxis(
  ///                radiusFactor: 0.8,
  ///                ranges: <GaugeRange>[
  ///                  GaugeRange(
  ///                    startValue: 0,
  ///                    endValue: 35,
  ///                    sizeUnit: GaugeSizeUnit.factor,
  ///                    rangeOffset: 0.06,
  ///                    startWidth: 0.05,
  ///                    endWidth: 0.25),
  ///                ],
  ///              ),
  ///            ],
  ///          )
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color rangeColor;

  /// Specifies the title border color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              titleBorderColor: Colors.black
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            title: GaugeTitle(text: 'Title'),
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color titleBorderColor;

  /// Specifies the title background color
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            gaugeThemeData: SfGaugeThemeData(
  ///              titleBackgroundColor: Colors.blueAccent
  ///            )
  ///          ),
  ///          child: SfRadialGauge(
  ///            title: GaugeTitle(text: 'Title'),
  ///          ),
  ///        ),
  ///      )
  ///   );
  /// }
  ///```
  final Color titleBackgroundColor;

  /// Creates a copy of this gauge theme data object with the matching fields
  /// replaced with the non-null parameter values.
  SfGaugeThemeData copyWith({
    Brightness? brightness,
    Color? backgroundColor,
    Color? titleColor,
    Color? axisLabelColor,
    Color? axisLineColor,
    Color? majorTickColor,
    Color? minorTickColor,
    Color? markerColor,
    Color? markerBorderColor,
    Color? needleColor,
    Color? knobColor,
    Color? knobBorderColor,
    Color? tailColor,
    Color? tailBorderColor,
    Color? rangePointerColor,
    Color? rangeColor,
    Color? titleBorderColor,
    Color? titleBackgroundColor,
  }) {
    return SfGaugeThemeData.raw(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      axisLabelColor: axisLabelColor ?? this.axisLabelColor,
      axisLineColor: axisLineColor ?? this.axisLineColor,
      majorTickColor: majorTickColor ?? this.majorTickColor,
      minorTickColor: minorTickColor ?? this.minorTickColor,
      markerColor: markerColor ?? this.markerColor,
      markerBorderColor: markerBorderColor ?? this.markerBorderColor,
      needleColor: needleColor ?? this.needleColor,
      knobColor: knobColor ?? this.knobColor,
      knobBorderColor: knobBorderColor ?? this.knobBorderColor,
      tailColor: tailColor ?? this.tailColor,
      tailBorderColor: tailBorderColor ?? this.tailBorderColor,
      rangePointerColor: rangePointerColor ?? this.rangePointerColor,
      rangeColor: rangeColor ?? this.rangeColor,
      titleBorderColor: titleBorderColor ?? this.titleBorderColor,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
    );
  }

  /// Returns the gauge theme data
  static SfGaugeThemeData? lerp(
      SfGaugeThemeData? a, SfGaugeThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfGaugeThemeData(
      backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
      titleColor: Color.lerp(a.titleColor, b.titleColor, t),
      axisLabelColor: Color.lerp(a.axisLabelColor, b.axisLabelColor, t),
      axisLineColor: Color.lerp(a.axisLineColor, b.axisLineColor, t),
      majorTickColor: Color.lerp(a.majorTickColor, b.majorTickColor, t),
      minorTickColor: Color.lerp(a.minorTickColor, b.minorTickColor, t),
      markerColor: Color.lerp(a.markerColor, b.markerColor, t),
      markerBorderColor:
          Color.lerp(a.markerBorderColor, b.markerBorderColor, t),
      needleColor: Color.lerp(a.needleColor, b.needleColor, t),
      knobColor: Color.lerp(a.knobColor, b.knobColor, t),
      knobBorderColor: Color.lerp(a.knobBorderColor, b.knobBorderColor, t),
      tailColor: Color.lerp(a.tailColor, b.tailColor, t),
      tailBorderColor: Color.lerp(a.tailBorderColor, b.tailBorderColor, t),
      rangePointerColor:
          Color.lerp(a.rangePointerColor, b.rangePointerColor, t),
      rangeColor: Color.lerp(a.rangeColor, b.rangeColor, t),
      titleBorderColor: Color.lerp(a.titleBorderColor, b.titleBorderColor, t),
      titleBackgroundColor:
          Color.lerp(a.titleBackgroundColor, b.titleBackgroundColor, t),
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

    return other is SfGaugeThemeData &&
        other.backgroundColor == backgroundColor &&
        other.titleColor == titleColor &&
        other.axisLabelColor == axisLabelColor &&
        other.axisLineColor == axisLineColor &&
        other.majorTickColor == majorTickColor &&
        other.minorTickColor == minorTickColor &&
        other.markerColor == markerColor &&
        other.markerBorderColor == markerBorderColor &&
        other.needleColor == needleColor &&
        other.knobColor == knobColor &&
        other.knobBorderColor == knobBorderColor &&
        other.tailColor == tailColor &&
        other.tailBorderColor == tailBorderColor &&
        other.rangePointerColor == rangePointerColor &&
        other.rangeColor == rangeColor &&
        other.titleBorderColor == titleBorderColor &&
        other.titleBackgroundColor == titleBackgroundColor;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      backgroundColor,
      titleColor,
      axisLabelColor,
      axisLineColor,
      majorTickColor,
      minorTickColor,
      markerColor,
      markerBorderColor,
      needleColor,
      knobColor,
      knobBorderColor,
      tailColor,
      tailBorderColor,
      rangePointerColor,
      rangeColor,
      titleBorderColor,
      titleBackgroundColor
    ];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfGaugeThemeData defaultData = SfGaugeThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('titleColor', titleColor,
        defaultValue: defaultData.titleColor));
    properties.add(ColorProperty('axisLabelColor', axisLabelColor,
        defaultValue: defaultData.axisLabelColor));
    properties.add(ColorProperty('axisLineColor', axisLineColor,
        defaultValue: defaultData.axisLineColor));
    properties.add(ColorProperty('majorTickColor', majorTickColor,
        defaultValue: defaultData.majorTickColor));
    properties.add(ColorProperty('minorTickColor', minorTickColor,
        defaultValue: defaultData.minorTickColor));
    properties.add(ColorProperty('markerColor', markerColor,
        defaultValue: defaultData.markerColor));
    properties.add(ColorProperty('markerBorderColor', markerBorderColor,
        defaultValue: defaultData.markerBorderColor));
    properties.add(ColorProperty('needleColor', needleColor,
        defaultValue: defaultData.needleColor));
    properties.add(ColorProperty('knobColor', knobColor,
        defaultValue: defaultData.knobColor));
    properties.add(ColorProperty('knobBorderColor', knobBorderColor,
        defaultValue: defaultData.knobBorderColor));
    properties.add(ColorProperty('tailColor', tailColor,
        defaultValue: defaultData.tailColor));
    properties.add(ColorProperty('tailBorderColor', tailBorderColor,
        defaultValue: defaultData.tailBorderColor));
    properties.add(ColorProperty('rangePointerColor', rangePointerColor,
        defaultValue: defaultData.rangePointerColor));
    properties.add(ColorProperty('rangeColor', rangeColor,
        defaultValue: defaultData.rangeColor));
    properties.add(ColorProperty('titleBorderColor', titleBorderColor,
        defaultValue: defaultData.titleBorderColor));
    properties.add(ColorProperty('titleBackgroundColor', titleBackgroundColor,
        defaultValue: defaultData.titleBackgroundColor));
  }
}
