import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// Handling empty points in charts
///
/// Data points with a null value are considered empty points. Empty data points
/// are ignored and are not plotted in the chart.
/// By using the emptyPointSettings property in series, you can decide on the
/// action taken for empty points.
///
/// Defaults to `EmptyPointMode.gap`.
///
/// _Note:_ This is common for Cartesian, circular, pyramid and funnel charts.
class EmptyPointSettings {
  /// Creating an argument constructor of EmptyPointSettings class.
  const EmptyPointSettings({
    this.color = Colors.grey,
    this.mode = EmptyPointMode.gap,
    this.borderColor = Colors.transparent,
    this.borderWidth = 2.0,
  });

  /// Color of the empty data point.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         emptyPointSettings: EmptyPointSettings(
  ///           color: Colors.black,
  ///           mode: EmptyPointMode.average
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color color;

  /// Border color of the empty data point.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         emptyPointSettings: EmptyPointSettings(
  ///           borderColor: Colors.black,
  ///           borderWidth: 2,
  ///           mode:EmptyPointMode.average
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the empty data point.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         emptyPointSettings: EmptyPointSettings(
  ///           borderColor: Colors.black,
  ///           borderWidth: 2,
  ///           mode:EmptyPointMode.average
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// By default, gap will be generated for empty points, i.e. data points
  /// with null value.
  ///
  /// The empty points display the values that can be considered as zero,
  /// average, or gap.
  ///
  /// Defaults to `EmptyPointMode.gap`.
  ///
  /// Also refer [EmptyPointMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         emptyPointSettings: EmptyPointSettings(
  ///           mode:EmptyPointMode.average
  ///         )
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final EmptyPointMode mode;
}
