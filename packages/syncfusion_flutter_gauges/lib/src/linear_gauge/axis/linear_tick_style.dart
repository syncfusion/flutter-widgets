import 'package:flutter/material.dart';

/// Ticks style for the linear axis.
@immutable
class LinearTickStyle {
  /// Creates linear tick style with default or required properties.
  ///
  /// The arguments [length], [thickness], must be non-negative.
  const LinearTickStyle({this.length = 4, this.thickness = 1, this.color});

  /// Specifies the length of major and minor ticks.
  ///
  /// Defaults to 8.0 for `majorTicks `and 4.0 for `minorTicks`.
  ///
  /// This snippet shows how to set tick length.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(majorTickStyle: LinearTickStyle(
  /// length: 20,),
  /// minotTickStyle: LinearTickStyle(
  /// length: 10,)
  /// )
  /// ```
  ///
  final double length;

  /// Specifies the thickness of major and minor ticks.
  ///
  /// Defaults to 1.
  ///
  /// This snippet shows how to set tick thickness.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(majorTickStyle: LinearTickStyle(
  /// thickness: 3),
  /// minorTickStyle: LinearTickStyle(
  /// thickness: 1,)
  /// )
  /// ```
  ///
  final double thickness;

  /// Specifies the color of ticks.
  ///
  /// Defaults to [Colors.black26] in Light theme and [Colors.white30] in Dark theme for major ticks.
  /// Defaults to [Colors.black26] in Light theme and [Colors.white30] in Dark theme for major ticks.
  ///
  /// This snippet shows how to set color of ticks.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(majorTickStyle: LinearTickStyle(
  /// color: Colors.blue),
  /// minorTickStyle: LinearTickStyle(
  /// color: Colors.green),
  /// )
  /// ```
  ///
  final Color? color;

  @override
  bool operator ==(Object other) {
    late LinearTickStyle otherStyle;

    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is LinearTickStyle) {
      otherStyle = other;
    }

    return otherStyle.length == length &&
        otherStyle.color == color &&
        otherStyle.thickness == thickness;
  }

  @override
  int get hashCode {
    return Object.hash(
      length,
      color,
      thickness,
    );
  }
}
