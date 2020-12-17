import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Represents the plot band settings for spark chart
class SparkChartPlotBand {
  /// Creates the plot band for spark chart
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  SparkChartPlotBand(
      {this.color = const Color.fromRGBO(191, 212, 252, 0.5),
      this.start,
      this.end,
      this.borderColor,
      this.borderWidth = 0});

  /// Defines the plotband color
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25, color: Colors.red),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color color;

  /// Defines the start value of plot band
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double start;

  /// Defines the end value of plot band
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double end;

  /// Defines the border color of plot band
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25, borderColor: Colors.black,
  ///      borderWidth: 2),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final Color borderColor;

  /// Defines the border width of plot band
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25, borderColor: Colors.black,
  ///      borderWidth: 2),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///    )),
  ///  );
  /// }
  /// ```
  final double borderWidth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SparkChartPlotBand &&
        other.start == start &&
        other.end == end &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      start,
      end,
      color,
      borderColor,
      borderWidth,
    ];
    return hashList(values);
  }
}
