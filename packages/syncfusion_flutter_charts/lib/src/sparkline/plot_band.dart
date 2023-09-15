import 'package:flutter/material.dart';

/// Renders plot band.
///
/// Plot band is also known as stripline, which is used to shade the different
/// ranges in plot area with different colors to improve the readability of the
/// chart.
///
/// Plot bands are drawn based on the axis.
///
/// Provides the property of [start], [end], [color], [borderColor], and
/// [borderWidth] to customize the appearance.
///
@immutable
class SparkChartPlotBand {
  /// Creates an instance of spark chart plot band to add and customizes the
  /// plot band in spark chart widget. To make, the plot band visible, define
  /// the value to its [start] and [end] property.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  const SparkChartPlotBand(
      {this.color = const Color.fromRGBO(191, 212, 252, 0.5),
      this.start,
      this.end,
      this.borderColor,
      this.borderWidth = 0});

  /// Customizes the color of the plot band. Since the plot band is rendered
  /// above the axis line, you can customize the color of the plot band for a
  /// transparent view of the axis line.
  ///
  /// Defaults to `Color.fromRGBO(191, 212, 252, 0.5)`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25, color: Colors.red),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///           )
  ///       ),
  ///   );
  /// }
  /// ```
  final Color color;

  /// Customizes the start position. Define any value between the provided data
  /// range as the start value. To make the plot band visible, need to set both
  /// the [start] and [end] property.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///           )
  ///        ),
  ///     );
  /// }
  /// ```
  final double? start;

  /// Customizes the end position. Define any value between the provided data
  /// range as the end value. To make the plot band visible, need to set both
  /// the [start] and [end] property.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///           )
  ///        ),
  ///    );
  /// }
  /// ```
  final double? end;

  /// Customizes the border color of the plot band. To make border visible for
  /// plot band, need to set both the border color and border width.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25, borderColor: Colors.black),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///           )
  ///       ),
  ///    );
  /// }
  /// ```
  final Color? borderColor;

  /// Customizes the border width of the plot band. To make border visible for
  /// plot band, need to set both the border color and border width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      plotBand: SparkChartPlotBand(start: 15, end: 25,
  ///      borderWidth: 2),
  ///      data: <double>[18, 24, 30, 14, 28],
  ///           )
  ///        ),
  ///    );
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
      start!,
      end!,
      color,
      borderColor!,
      borderWidth,
    ];
    return Object.hashAll(values);
  }
}
