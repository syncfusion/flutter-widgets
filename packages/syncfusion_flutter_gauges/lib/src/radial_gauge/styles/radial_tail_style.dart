import 'package:flutter/material.dart';

import '../../radial_gauge/utils/enum.dart';

/// Style for drawing pointer's tail.
///
/// ```dart
///Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis
///          ( pointers: <GaugePointer>[
///             NeedlePointer( value: 20, tailStyle:
///                 TailStyle(width: 5, lengthFactor: 0.2)
///           )])]
///        ));
///}
/// ```
@immutable
class TailStyle {
  /// Creates the tail style with default or required properties.
  const TailStyle(
      {this.color,
      this.width = 0,
      this.length = 0,
      this.borderWidth = 0,
      this.gradient,
      this.lengthUnit = GaugeSizeUnit.factor,
      this.borderColor})
      : assert(width >= 0, 'Tail width must be a non-negative value.'),
        assert(length >= 0, 'Tail length must be a non-negative value.'),
        assert(
            borderWidth >= 0,
            'Tail border width must be a '
            'non-negative value.');

  /// Specifies the color of the tail.
  ///
  /// Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(color: Colors.lightBlue, width: 10, length: 0.1)
  ///           )])]
  ///        ));
  ///}
  ///```
  final Color? color;

  /// Specifies the width of the tail.
  ///
  /// Defaults to `0`.
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(width: 10, length: 0.1)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double width;

  /// Adjusts the tail length from center.
  ///
  /// You can specify length value either in logical pixel or
  /// radius factor using the [lengthUnit] property.
  /// If [lengthUnit] is [GaugeSizeUnit.factor], value will be given from 0
  /// to 1. Here tail length is calculated by [length] * axis radius value.
  ///
  /// Example: [length] value is 0.5 and axis radius is 100, tail
  /// length is 50(0.5 * 100) logical pixels from axis center.
  /// if [lengthUnit] is [GaugeSizeUnit.logicalPixel], defined value length
  /// from axis center.
  ///
  /// Defaults to `0` and [lengthUnit] is `GaugeSizeUnit.factor`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(width: 10,length: 0.2)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double length;

  /// Calculates the pointer tail length either in logical pixel or
  /// radius factor.
  ///
  /// Using [GaugeSizeUnit], pointer tail length is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.factor`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(length: 30,
  ///                 lengthUnit: GaugeSizeUnit.logicalPixel, width: 10)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the border width of tail.
  ///
  /// Defaults to `0`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                 borderColor: Colors.red)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final double borderWidth;

  /// Specifies the border color of tail.
  ///
  /// Defaults to `null`.
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                 borderColor: Colors.red)
  ///           )])]
  ///        ));
  ///}
  /// ```
  final Color? borderColor;

  /// A gradient to use when filling the needle tail.
  ///
  /// [gradient] of [TailStyle] only support [LinearGradient].
  /// You can use this to display the depth effect of the needle pointer.
  ///
  /// Defaults to `null`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///          ( pointers: <GaugePointer>[
  ///             NeedlePointer( tailStyle:
  ///                 TailStyle(borderWidth: 2,width: 10,length: 0.2,
  ///                    gradient: LinearGradient(
  ///                  colors: const <Color>[Color.fromRGBO(28, 114, 189, 1),
  ///                  Color.fromRGBO(28, 114, 189, 1),
  ///                    Color.fromRGBO(23, 173, 234, 1),
  ///                    Color.fromRGBO(23, 173, 234, 1)],
  ///                  stops: const <double>[0,0.5,0.5,1],
  ///
  ///             )
  ///                 )
  ///           )])]
  ///        ));
  ///}
  /// ```
  final LinearGradient? gradient;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TailStyle &&
        other.width == width &&
        other.borderWidth == borderWidth &&
        other.length == length &&
        other.gradient == gradient &&
        other.color == color &&
        other.lengthUnit == lengthUnit &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      width,
      color,
      borderWidth,
      length,
      gradient,
      lengthUnit,
      borderColor
    ];
    return Object.hashAll(values);
  }
}
