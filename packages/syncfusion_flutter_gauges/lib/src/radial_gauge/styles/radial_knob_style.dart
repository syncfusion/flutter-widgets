import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// A style in which draw needle pointer knob.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 30,
///              knobStyle: KnobStyle(knobRadius: 0.1),
///           )])]
///        ));
///}
/// ```
@immutable
class KnobStyle {
  /// Creates the knob style with default or required properties.
  ///
  /// The arguments [knobRadius], [borderWidth] must be non-negative.
  const KnobStyle(
      {this.knobRadius = 0.08,
      this.borderWidth = 0,
      this.sizeUnit = GaugeSizeUnit.factor,
      this.borderColor,
      this.color})
      : assert(knobRadius >= 0, 'Knob radius must be a non-negative value.'),
        assert(
            borderWidth >= 0,
            'Knob border width must be a '
            'non-negative value.');

  /// Adjusts the knob radius in needle pointer.
  ///
  /// You can specify knob radius value either in logical pixel or
  /// radius factor using the [sizeUnit] property.
  /// if [sizeUnit] is [GaugeSizeUnit.factor], value will be given from 0 to 1.
  /// Here knob radius size is calculated by [knobRadius] * axis radius value.
  ///
  /// Example: [knobRadius] value is 0.2 and axis radius is 100,
  /// knob radius is 20(0.2 * 100) logical pixels.
  /// if [sizeUnit] is [GaugeSizeUnit.logicalPixel], defined value is
  /// set to the knob radius.
  ///
  /// Defaults to 0.08 and `sizeUnit` is `GaugeSizeUnit.factor`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(knobStyle: KnobStyle(knobRadius: 0.2),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double knobRadius;

  /// Calculates the knob radius size either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], pointer knob radius size is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.factor`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///                 knobStyle: KnobStyle(knobRadius: 10,
  ///                 sizeUnit: GaugeSizeUnit.logicalPixel),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit sizeUnit;

  /// Specifies the knob border width in logical pixel.
  ///
  /// Defaults to `0`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///                  knobStyle: KnobStyle(borderWidth: 2,
  ///                  borderColor : Colors.red),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// Specifies the knob color.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer(
  ///              knobStyle: KnobStyle(color: Colors.red),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// Specifies the knob border color.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <Pointer>[
  ///             NeedlePointer(
  ///              knobStyle: KnobStyle(borderColor: Colors.red,
  ///              borderWidth: 2),
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? borderColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is KnobStyle &&
        other.knobRadius == knobRadius &&
        other.borderWidth == borderWidth &&
        other.sizeUnit == sizeUnit &&
        other.borderColor == borderColor &&
        other.color == color;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      knobRadius,
      borderWidth,
      sizeUnit,
      borderColor,
      color
    ];
    return Object.hashAll(values);
  }
}
