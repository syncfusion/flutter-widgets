import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/enum.dart';

/// Represents the track ball behavior of spark chart widget
class SparkChartTrackball {
  /// Creates the track ball behavior of spark chart widget
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(borderWidth: 2,
  ///      borderColor: Colors.black, activationMode: SparkChartActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  SparkChartTrackball(
      {this.width = 2,
      this.color,
      this.dashArray,
      this.activationMode = SparkChartActivationMode.tap,
      this.labelStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 12),
      this.tooltipFormatter,
      this.backgroundColor,
      this.shouldAlwaysShow = false,
      this.hideDelay = 0,
      this.borderColor,
      this.borderWidth = 0,
      this.borderRadius = const BorderRadius.all(Radius.circular(5))});

  /// Represents the width of track ball line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(width: 5,
  ///      ),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double width;

  /// Represents the color of track ball line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(
  ///      color: Colors.black,),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Represents the dash array for track ball line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(dashArray: <double>[2,2],
  ///      ),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final List<double> dashArray;

  /// Represents the activation mode of track ball line.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(SparkChartActivationMode: ActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartActivationMode activationMode;

  /// Represents the label style of the track ball.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(labelStyle: TextStyle(fontSize: 15)),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final TextStyle labelStyle;

  /// Represents the background color for track ball tooltip.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(
  ///      backgroundColor: Colors.black),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color backgroundColor;

  /// Represents the background color for track ball tooltip.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(borderWidth: 2,
  ///      borderColor: Colors.black,),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color borderColor;

  /// Repreents the border width of trackball tooltip.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(boderWidth: 2,
  ///      borderColor: Colors.black, activationMode: SparkChartActivationMode.doubleTap),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double borderWidth;

  /// Repreents the border radius of trackball tooltip.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(BorderRadius.all(Radius.circular(3)),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final BorderRadius borderRadius;

  /// Shows or hides the trackball.
  ///
  /// By default, the trackball will be hidden on touch. To avoid this, set this property to true.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(shouldAlwaysShow: true,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final bool shouldAlwaysShow;

  /// The trackball disappears after this time interval.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(shouldAlwaysShow: true,
  ///      hideDelay: 200,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double hideDelay;

  /// Callback for formatting tooltip text.
  ///
  /// String handleTooltipFormatter(TooltipFormatterDetails details) {
  ///  return details.y.toStringAsFixed(0) + 'cm';
  /// }
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      trackball:(
  ///      tooltipFormatter: handleTooltipFormatter,
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final SparkChartTooltipCallback<String> tooltipFormatter;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SparkChartTrackball &&
        other.width == width &&
        other.color == color &&
        other.activationMode == activationMode &&
        other.labelStyle == labelStyle &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.shouldAlwaysShow == shouldAlwaysShow &&
        other.hideDelay == hideDelay &&
        other.borderRadius == borderRadius &&
        other.tooltipFormatter == tooltipFormatter &&
        listEquals(other.dashArray, dashArray);
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      width,
      color,
      activationMode,
      labelStyle,
      backgroundColor,
      borderColor,
      borderWidth,
      dashArray,
      shouldAlwaysShow,
      hideDelay,
      borderRadius,
      tooltipFormatter
    ];
    return hashList(values);
  }
}
