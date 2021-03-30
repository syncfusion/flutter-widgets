import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Applies a theme to descendant Syncfusion barcode widgets.
///
/// To obtain the current theme, use [SfBarcodeTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfBarcodeTheme(
///       data: SfBarcodeThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfBarcodeGenerator(
///         value: 'www.sycfusion.com',
///         symbology: QRCode() ,
///       )
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the barcode widgets.
///
class SfBarcodeTheme extends InheritedTheme {
  /// Initialize the class of SfBarcodeTheme
  const SfBarcodeTheme({Key? key, required this.data, required this.child})
      : super(key: key, child: child);

  /// Specifies the color and typography values for descendant barcode widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfBarcodeTheme(
  ///       data: SfBarcodeThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfBarcodeGenerator(
  ///         value: 'www.sycfusion.com',
  ///         symbology: QRCode() ,
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```

  final SfBarcodeThemeData data;

  /// Specifies a widget that can hold single child.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: SfBarcodeTheme(
  ///       data: SfBarcodeThemeData(
  ///         brightness: Brightness.light
  ///       ),
  ///       child: SfBarcodeGenerator(
  ///         value: 'www.sycfusion.com',
  ///         symbology: QRCode() ,
  ///       )
  ///     ),
  ///   );
  /// }
  /// ```
  @override
  final Widget child;

  /// The data from the closest [SfBarcodeTheme] instance
  /// that encloses the given context.
  ///
  /// Defaults to [SfBarcodeTheme.barcodeThemeData]
  /// if there is no [SfBarcodeTheme] in the given build context.
  static SfBarcodeThemeData of(BuildContext context) {
    final SfBarcodeTheme? sfBarcodeTheme =
        context.dependOnInheritedWidgetOfExactType<SfBarcodeTheme>();
    return sfBarcodeTheme?.data ?? SfTheme.of(context).barcodeThemeData;
  }

  @override
  bool updateShouldNotify(SfBarcodeTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final SfBarcodeTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<SfBarcodeTheme>();
    return identical(this, ancestorTheme)
        ? child
        : SfBarcodeTheme(data: data, child: child);
  }
}

/// Holds the color and typography values for a [SfBarcodeTheme].
/// Applies a theme to descendant Syncfusion barcode widgets.
///
/// To obtain the current theme, use [SfBarcodeTheme.of].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     body: SfBarcodeTheme(
///       data: SfBarcodeThemeData(
///         brightness: Brightness.light
///       ),
///       child: SfBarcodeGenerator(
///         value: 'www.sycfusion.com',
///         symbology: QRCode() ,
///       )
///     ),
///   );
/// }
/// ```
///
/// See also:
///
/// * [SfTheme](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfTheme-class.html)
/// and [SfThemeData](https://pub.dev/documentation/syncfusion_flutter_core/latest/theme/SfThemeData-class.html),
/// for customizing the visual appearance of the barcode widgets.
///
class SfBarcodeThemeData with Diagnosticable {
  /// Initialize the SfBarcode theme data
  factory SfBarcodeThemeData({
    Brightness? brightness,
    Color? backgroundColor,
    Color? barColor,
    Color? textColor,
  }) {
    brightness = brightness ?? Brightness.light;
    final bool isLight = brightness == Brightness.light;
    backgroundColor ??= Colors.transparent;
    barColor ??= isLight ? const Color(0xFF212121) : const Color(0xFFE0E0E0);
    textColor ??= isLight ? const Color(0xFF212121) : const Color(0xFFE0E0E0);

    return SfBarcodeThemeData.raw(
        brightness: brightness,
        backgroundColor: backgroundColor,
        barColor: barColor,
        textColor: textColor);
  }

  /// Create a [SfBarcodeThemeData] given a set of exact values.
  /// All the values must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [SfBarcodeThemeData] constructor.
  const SfBarcodeThemeData.raw({
    required this.brightness,
    required this.backgroundColor,
    required this.barColor,
    required this.textColor,
  });

  /// The brightness of the overall theme of the
  /// application for the barcode widgets.
  ///
  /// If [brightness] is not specified, then based on the
  /// [Theme.of(context).brightness], brightness for
  /// barcode widgets will be applied.
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
  ///            barcodeThemeData: SfBarcodeThemeData(
  ///              brightness: Brightness.dark
  ///              ),
  ///            ),
  ///          child: SfBarcodeGenerator(
  ///            value: 'www.sycfusion.com',
  ///            symbology: QRCode() ,
  ///            showValue: true,
  ///          ),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Brightness brightness;

  /// Specifies the background color of barcode widgets.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            barcodeThemeData: SfBarcodeThemeData(
  ///              backgroundColor: Colors.yellow
  ///              ),
  ///            ),
  ///          child: SfBarcodeGenerator(
  ///            value: 'www.sycfusion.com',
  ///            symbology: QRCode() ,
  ///            showValue: true,
  ///          ),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color backgroundColor;

  /// Specifies the color for barcodes.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            barcodeThemeData: SfBarcodeThemeData(
  ///              barColor: Colors.green
  ///              ),
  ///            ),
  ///          child: SfBarcodeGenerator(
  ///            value: 'www.sycfusion.com',
  ///            symbology: QRCode() ,
  ///            showValue: true,
  ///          ),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color barColor;

  /// Specifies the color for barcode text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    appBar: AppBar(),
  ///      body: Center(
  ///        child: SfTheme(
  ///          data: SfThemeData(
  ///            barcodeThemeData: SfBarcodeThemeData(
  ///              textColor: Colors.blue
  ///              ),
  ///            ),
  ///          child: SfBarcodeGenerator(
  ///            value: 'www.sycfusion.com',
  ///            symbology: QRCode() ,
  ///            showValue: true,
  ///          ),
  ///        ),
  ///      )
  ///   );
  ///}
  /// ```
  final Color textColor;

  /// Creates a copy of this barcode theme data object with the matching fields
  /// replaced with the non-null parameter values.
  SfBarcodeThemeData copyWith({
    Brightness? brightness,
    Color? backgroundColor,
    Color? barColor,
    Color? textColor,
  }) {
    return SfBarcodeThemeData.raw(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barColor: barColor ?? this.barColor,
      textColor: textColor ?? this.textColor,
    );
  }

  /// Returns the barcode theme data
  static SfBarcodeThemeData? lerp(
      SfBarcodeThemeData? a, SfBarcodeThemeData? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return SfBarcodeThemeData(
      backgroundColor: Color.lerp(a!.backgroundColor, b!.backgroundColor, t),
      barColor: Color.lerp(a.barColor, b.barColor, t),
      textColor: Color.lerp(a.textColor, b.textColor, t),
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

    return other is SfBarcodeThemeData &&
        other.backgroundColor == backgroundColor &&
        other.barColor == barColor &&
        other.textColor == textColor;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[backgroundColor, barColor, textColor];
    return hashList(values);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final SfBarcodeThemeData defaultData = SfBarcodeThemeData();
    properties.add(EnumProperty<Brightness>('brightness', brightness,
        defaultValue: defaultData.brightness));
    properties.add(ColorProperty('backgroundColor', backgroundColor,
        defaultValue: defaultData.backgroundColor));
    properties.add(ColorProperty('barColor', barColor,
        defaultValue: defaultData.barColor));
    properties.add(ColorProperty('textColor', textColor,
        defaultValue: defaultData.textColor));
  }
}
