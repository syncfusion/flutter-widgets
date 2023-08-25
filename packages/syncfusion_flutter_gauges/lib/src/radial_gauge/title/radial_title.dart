import 'package:flutter/material.dart';

import '../../radial_gauge/utils/enum.dart';

/// Title of the gauge.
///
/// Takes a string and displays it as the title of the gauge.
/// By default, the text of the gauge will be horizontally center aligned.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///            title: GaugeTitle(
///                    text: 'Gauge Title',
///                    textStyle: TextStyle(
///                                 color: Colors.red,
///                                 fontSize: 12,
///                                 fontStyle: FontStyle.normal,
///                                 fontWeight: FontWeight.w400,
///                                 fontFamily: 'Roboto'
///                               ))
///        ));
///}
/// ```
@immutable
class GaugeTitle {
  /// Creates the gauge title with default or required properties.
  const GaugeTitle(
      {required this.text,
      this.textStyle,
      this.alignment = GaugeAlignment.center,
      this.borderColor,
      this.borderWidth = 0,
      this.backgroundColor});

  /// Text to be displayed as gauge title.
  ///
  /// If the text of the gauge exceeds, then text will be wrapped into
  /// multiple rows.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title'
  ///                   )
  ///        ));
  ///}
  ///```
  final String text;

  /// The style to use for the gauge title text.
  ///
  /// Using [TextStyle] to add the style to the axis labels.
  ///
  /// Defaults to the [TextStyle] property with font size `12.0`
  /// and font family `Segoe UI`.
  ///
  /// Also refer [TextStyle]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    textStyle: TextStyle(
  ///                                 color: Colors.red,
  ///                                 fontSize: 12,
  ///                                 fontStyle: FontStyle.normal,
  ///                                 fontWeight: FontWeight.w400,
  ///                                 fontFamily: 'Roboto'
  ///                               ))
  ///        ));
  ///}
  ///```
  final TextStyle? textStyle;

  /// The color that fills the title of the gauge.
  ///
  /// Changing the background color will cause the gauge title to the new color.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    backgroundColor: Colors.red
  ///                   )
  ///        ));
  ///}
  ///```
  final Color? backgroundColor;

  /// The color that fills the border with the title of the gauge.
  ///
  /// Defaults to `null`.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    borderColor: Colors.red,
  ///                      borderWidth: 1
  ///                   )
  ///        ));
  ///}
  ///```
  final Color? borderColor;

  /// Specifies the border width of the gauge title.
  ///
  /// Defaults to `0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    borderColor: Colors.red,
  ///                    borderWidth: 1
  ///                   )
  ///        ));
  ///}
  ///```
  final double borderWidth;

  /// How the title text should be aligned horizontally.
  ///
  /// The alignment is applicable when the width of the gauge title is
  /// less than the width of the gauge.
  ///
  /// [GaugeAlignment.near] places the title at the beginning of gauge
  /// whereas the [GaugeAlignment.center] moves the gauge title to the center
  /// of gauge and the [GaugeAlignment.far] places the gauge title at the
  /// end of the gauge.
  ///
  /// Defaults to `GaugeAlignment.center`.
  ///
  /// Also refer [GaugeAlignment]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///            title: GaugeTitle(
  ///                    text: 'Gauge Title',
  ///                    alignment: GaugeAlignment.far
  ///                   )
  ///        ));
  ///}
  ///```
  final GaugeAlignment alignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GaugeTitle &&
        other.text == text &&
        other.alignment == alignment &&
        other.textStyle == textStyle &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      text,
      alignment,
      textStyle,
      borderWidth,
      borderColor,
      backgroundColor
    ];
    return Object.hashAll(values);
  }
}
