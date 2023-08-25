import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../radial_gauge/utils/enum.dart';

/// Create the style of axis major tick.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            majorTickStyle: MajorTickStyle(color: Colors.red,
///            thickness: 3,
///            length: 10),
///            )]
///        ));
///}
/// ```
@immutable
class MajorTickStyle {
  /// Creates a major tick style with default or required properties.
  ///
  /// The arguments [length], [thickness], must be non-negative.
  const MajorTickStyle(
      {this.length = 7,
      this.thickness = 1.5,
      this.lengthUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.dashArray})
      : assert(length >= 0, 'Tick length must be a non-negative value.'),
        assert(thickness >= 0, 'Tick thickness must be a non-negative value.');

  /// Specifies the length of the tick.
  ///
  /// You can specify tick length either in logical pixel or radius factor
  /// using the [lengthUnit] property. if [lengthUnit] is
  /// [GaugeSizeUnit.factor], value must be given from 0 to 1.
  /// Here tick length is calculated by [length] * axis radius value.
  ///
  /// Example: [length] value is 0.2 and axis radius is 100,
  /// tick length is 20(0.2 * 100) logical pixels. if [lengthUnit] is
  /// [GaugeSizeUnit.logicalPixel], defined value is set to the tick length.
  ///
  /// Defaults to `7` and [lengthUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ``` dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(length: 10),)]
  ///        ));
  ///}
  /// ```
  final double length;

  /// Calculates the tick length size either in logical pixel or radius factor.
  ///
  /// Using [GaugeSizeUnit], tick length size is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit]
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(lengthUnit: GaugeSizeUnit.factor,
  ///              length:0.05),)]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit lengthUnit;

  /// Specifies the thickness of tick in logical pixels.
  ///
  /// Defaults to `1.5`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(thickness: 2),)]
  ///        ));
  ///}
  /// ```
  final double thickness;

  /// Specifies the color of tick.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(color: Colors.lightBlue),)]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// Specifies the dash array to draw the dashed line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (majorTickStyle:
  ///              MajorTickStyle(dashArray: <double>[2.5, 2.5]),)]
  ///        ));
  ///}
  /// ```
  final List<double>? dashArray;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MajorTickStyle &&
        other.length == length &&
        other.thickness == thickness &&
        other.lengthUnit == lengthUnit &&
        other.color == color &&
        listEquals(other.dashArray, dashArray);
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      length,
      thickness,
      lengthUnit,
      color,
      dashArray
    ];
    return Object.hashAll(values);
  }
}

/// Create the style of axis minor tick.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///            minorTickStyle: MinorTickStyle(color: Colors.red,
///            thickness: 3,
///            length: 10),
///            )]
///        ));
///}
/// ```
@immutable
class MinorTickStyle extends MajorTickStyle {
  /// Creates a minor tick style with default or required properties.
  ///
  /// The arguments [length], [thickness], must be non-negative.
  const MinorTickStyle(
      {double length = 5,
      GaugeSizeUnit lengthUnit = GaugeSizeUnit.logicalPixel,
      Color? color,
      double thickness = 1.5,
      List<double>? dashArray})
      : assert(length >= 0, 'Tick length must be a non-negative value.'),
        assert(thickness >= 0, 'Tick thickness must be a non-negative value.'),
        super(
          length: length,
          lengthUnit: lengthUnit,
          thickness: thickness,
          dashArray: dashArray,
          color: color,
        );
}

/// Create the style of axis line.
///
/// ```dart
/// Widget build(BuildContext context) {
///    return Container(
///        child: SfRadialGauge(
///          axes:<RadialAxis>[RadialAxis(
///           axisLineStyle: AxisLineStyle(color: Colors.red,
///           thickness: 20),
///            )]
///        ));
///}
/// ```
@immutable
class AxisLineStyle {
  /// Creates a minor tick style with default or required properties.
  ///
  /// The arguments [thickness], must be non-negative.
  const AxisLineStyle(
      {this.thickness = 10,
      this.thicknessUnit = GaugeSizeUnit.logicalPixel,
      this.color,
      this.gradient,
      this.cornerStyle = CornerStyle.bothFlat,
      this.dashArray})
      : assert(thickness >= 0,
            'Axis line thickness must be a non-negative value.'),
        assert(
            (gradient != null && gradient is SweepGradient) || gradient == null,
            'The gradient must be null or else '
            'the gradient must be equal to sweep gradient.');

  /// Calculates the axis line thickness either in logical pixel
  /// or radius factor.
  ///
  /// Using [GaugeSizeUnit], axis line thickness is calculated.
  ///
  /// Defaults to `GaugeSizeUnit.logicalPixel`.
  ///
  /// Also refer [GaugeSizeUnit].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(thickness: 0.2,
  ///           thicknessUnit: GaugeSizeUnit.factor),)]
  ///        ));
  ///}
  /// ```
  final GaugeSizeUnit thicknessUnit;

  /// Specifies the thickness of axis line.
  ///
  /// You can specify axis line thickness either in logical pixel or
  /// radius factor using the [thicknessUnit] property.
  /// if [thicknessUnit] is [GaugeSizeUnit.factor],
  /// value must be given from 0 to 1. Here thickness is calculated
  /// by [thickness] * axis radius value.
  ///
  /// Example: [thickness] value is 0.2 and axis radius is 100,
  /// thickness is 20(0.2 * 100) logical pixels.
  /// If [thicknessUnit] is [GaugeSizeUnit.logicalPixel], the defined value
  /// for axis line thickness is set.
  ///
  /// Defaults to `10` and [thicknessUnit] is `GaugeSizeUnit.logicalPixel`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(thickness: 20),)]
  ///        ));
  ///}
  /// ```
  final double thickness;

  /// Specifies the color of axis line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(color: Colors.grey),)]
  ///        ));
  ///}
  /// ```
  final Color? color;

  /// The style to use for the axis line corner edge.
  ///
  /// * [CornerStyle.bothFlat] does not render the rounded corner on both side.
  /// * [CornerStyle.bothCurve] renders the rounded corner on both side.
  /// * [CornerStyle.startCurve] renders the rounded corner on start side.
  /// * [CornerStyle.endCurve] renders the rounded corner on end side.
  ///
  /// Defaults to `CornerStyle.bothFlat`.
  ///
  /// Also refer [CornerStyle].
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(cornerStyle: CornerStyle.bothCurve),)]
  ///        ));
  ///}
  /// ```
  final CornerStyle cornerStyle;

  /// Specifies the dash array for axis line to draw the dashed line.
  ///
  /// Defaults to `null`.
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(dashArray: <double>[5, 5],)]
  ///        ));
  ///}
  /// ```
  final List<double>? dashArray;

  /// A gradient to use when filling the axis line.
  ///
  /// [gradient] of [AxisLineStyle] only support [SweepGradient] and
  /// specified [SweepGradient.stops] are applied within the axis range value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfRadialGauge(
  ///          axes:<RadialAxis>[RadialAxis
  ///           (axisLineStyle:
  ///           AxisLineStyle(dashArray: <double>[5, 5],
  ///           gradient: SweepGradient(
  ///                   colors: const <Color>[Colors.deepPurple,Colors.red,
  ///                     Color(0xFFFFDD00), Color(0xFFFFDD00),
  ///                     Color(0xFF30B32D), ],
  ///                   stops: const <double>[0,0.03, 0.5833333, 0.73, 1],
  ///                 ),)]
  ///        ));
  ///}
  /// ```
  final Gradient? gradient;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AxisLineStyle &&
        other.thickness == thickness &&
        other.thicknessUnit == thicknessUnit &&
        other.color == color &&
        other.gradient == gradient &&
        listEquals(other.dashArray, dashArray) &&
        other.cornerStyle == cornerStyle;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      thickness,
      thicknessUnit,
      color,
      gradient,
      cornerStyle,
      dashArray
    ];
    return Object.hashAll(values);
  }
}
