import 'package:flutter/material.dart';
import 'utils/enum.dart';

/// Adds and customizes the markers.
///
/// Markers are used to provide information about the exact point location.
/// You can add a shape to adorn each data point. Markers can be enabled by
/// using the [displayMode] property of [SparkChartMarker].
///
/// Provides the options of [color], [borderWidth], [borderColor] and [shape]
/// of the marker to customize the appearance.
///
@immutable
class SparkChartMarker {
  /// Creates an instance of spark chart marker to add and customizes the marker
  /// in spark chart widget. To make, the marker visible, set `displayeMode`
  /// property value as `SparkChartMarkerDisplayMode.all`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      marker: SparkChartMarker(
  ///          displayMode: SparkChartMarkerDisplayMode.all)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  const SparkChartMarker(
      {this.displayMode = SparkChartMarkerDisplayMode.none,
      this.borderColor,
      this.borderWidth = 2,
      this.color,
      this.size = 5,
      this.shape = SparkChartMarkerShape.circle});

  /// Enables the markers in different modes.
  ///
  /// * [SparkChartMarkerDisplayMode.none] does not allow to display a marker on
  /// any data points.
  /// * [SparkChartMarkerDisplayMode.all] allows to display a marker on all the
  /// data points.
  /// * [SparkChartMarkerDisplayMode.high] allows displaying marker only on the
  ///  highest data points in the spark chart widget.
  /// * [SparkChartMarkerDisplayMode.low] allows displaying marker only on the
  /// lowest data points.
  /// * [SparkChartMarkerDisplayMode.first] allows displaying marker only on the
  ///  first data points.
  /// * [SparkChartMarkerDisplayMode.last] allows displaying marker only on the
  /// last data points.
  ///
  /// Defaults to `SparkChartMarkerMode.none`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      marker: SparkChartMarker(
  ///          displayMode: SparkChartMarkerDisplayMode.all)
  ///         )
  ///       ),
  ///    );
  /// }
  /// ```
  final SparkChartMarkerDisplayMode displayMode;

  /// Customizes the border color of the marker. The color of the border gets
  /// applied based on the current theme of the application if the border color
  /// value is set to null.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///        child: SfSparkAreaChart(
  ///       marker: SparkChartMarker(
  ///          borderColor: Colors.red)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final Color? borderColor;

  /// Customizes the border width of the marker.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     body: Center(
  ///        child: SfSparkAreaChart(
  ///       marker: SparkChartMarker(
  ///          borderWidth: 3),
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final double borderWidth;

  /// Customizes the color of the marker. The color is set based on the current
  /// application theme, if its value is set to null.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      marker: SparkChartMarker(
  ///          color: Colors.red)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final Color? color;

  /// Customizes the marker size. This value is applied for both the width and
  /// height of the marker.
  ///
  /// Defaults to `5`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      marker: SparkChartMarker(
  ///          size: 20)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final double size;

  /// Customizes the marker shape. The [SparkChartMarkerShape] has pre-defined
  /// sets of marker shape.
  ///
  /// * [SparkChartMarkerShape.circle] displays the circular shape.
  /// * [SparkChartMarkerShape.diamond] displays the diamond shape as a marker.
  /// * [SparkChartMarkerShape.square] displays the square shape as a marker.
  /// * [SparkChartMarkerShape.triangle] displays the triangular shape as a marker.
  /// * [SparkChartMarkerShape.invertedTriangle] displays the inverted
  /// triangular shape as a marker.
  ///
  /// Also refer [SparkChartMarkerShape].
  ///
  /// Defaults to `SparkChartMarkerShape.circle`.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///  return Scaffold(
  ///    body: Center(
  ///        child: SfSparkAreaChart(
  ///      marker: SparkChartMarker(
  ///          shape: SparkChartMarkerShape.square)
  ///         )
  ///      ),
  ///   );
  /// }
  /// ```
  final SparkChartMarkerShape shape;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SparkChartMarker &&
        other.displayMode == displayMode &&
        other.shape == shape &&
        other.color == color &&
        other.size == size &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode {
    final List<Object> values = <Object>[
      displayMode,
      shape,
      color!,
      size,
      borderColor!,
      borderWidth,
    ];
    return Object.hashAll(values);
  }
}
