import 'package:flutter/material.dart';

import '../../linear_gauge/utils/enum.dart';

/// [LinearAxisTrackStyle] has properties for customizing the axis track.
@immutable
class LinearAxisTrackStyle {
  /// Creates a style for axis line.
  const LinearAxisTrackStyle(
      {this.thickness = 5.0,
      this.edgeStyle = LinearEdgeStyle.bothFlat,
      this.color,
      this.gradient,
      this.borderColor,
      this.borderWidth = 0});

  /// Specifies the thickness value of an axis track.
  ///
  /// Defaults to 5.0.
  ///
  /// This snippet shows how to set the thickness for an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// thickness: 20 )
  /// )
  /// ```
  ///
  final double thickness;

  /// Specifies the color to be applied for an axis track.
  ///
  /// Defaults to [Colors.black12] in LightTheme
  /// and [Colors.white24] in DarkTheme.
  ///
  /// This snippet shows how to set the color for an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// color: Colors.green )
  /// )
  /// ```
  ///
  final Color? color;

  /// Specifies the border color for an axis track.
  ///
  /// Defaults to [Colors.black26] in LightTheme
  /// and [Colors.white30] in DarkTheme.
  ///
  /// This snippet shows how to set border color of an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// borderColor: Colors.brown )
  /// )
  /// ```
  final Color? borderColor;

  /// Specifies the border width of an axis track.
  ///
  /// Defaults to 0.
  ///
  /// This snippet shows how to set border width for an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// borderWidth: 2 )
  /// )
  /// ```
  ///
  final double borderWidth;

  /// Specifies the edge styles for an axis track.
  ///
  /// Defaults to [LinearEdgeStyle.bothFlat].
  ///
  /// This snippet shows how to set edge style for an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// edgeStyle: LinearEdgeStyle.endCurve)
  /// )
  /// ```
  ///
  final LinearEdgeStyle edgeStyle;

  /// Specifies the gradient colors for an axis track.
  ///
  /// Defaults to null.
  ///
  /// This snippet shows how to set gradient colors for an axis track.
  ///
  /// ```dart
  ///
  /// SfLinearGauge(
  /// axisLineStyle: LinearAxisLineStyle(
  /// gradient: LinearGradient(colors: [
  /// Colors.red,
  /// Colors.orange,
  /// Colors.green,
  /// ], stops: <double>[
  /// 0.3,
  /// 0.5,
  /// 0.8 ]),))
  /// ```
  ///
  final LinearGradient? gradient;

  @override
  bool operator ==(Object other) {
    late LinearAxisTrackStyle otherStyle;

    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    if (other is LinearAxisTrackStyle) {
      otherStyle = other;
    }

    return otherStyle.thickness == thickness &&
        otherStyle.color == color &&
        otherStyle.borderColor == borderColor &&
        otherStyle.borderWidth == borderWidth &&
        otherStyle.edgeStyle == edgeStyle &&
        otherStyle.gradient == gradient;
  }

  @override
  int get hashCode {
    return Object.hash(
      thickness,
      color,
      borderColor,
      borderWidth,
      edgeStyle,
      gradient,
    );
  }
}
