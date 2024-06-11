import 'package:flutter/material.dart';

import '../utils/enum.dart';

/// It has the properties of the chart title.
///
/// ChartTitle  can define and customize the Chart title using title property
/// of SfCartesianChart. The text property of ChartTitle is used to set the
/// text for the title.
///
/// It provides an option of text, text style, alignment border color and width
/// to customize the appearance.
@immutable
class ChartTitle {
  /// Creating an argument constructor of ChartTitle class.
  const ChartTitle({
    this.text = '',
    this.textStyle,
    this.alignment = ChartAlignment.center,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.backgroundColor,
  });

  /// Text to be displayed as chart title. Any desired text can be set as chart
  /// title. If the width of the chart title exceeds the width of the chart,
  /// then the title will be wrapped to multiple rows.
  ///
  /// Defaults to `''`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title'
  ///     )
  ///   );
  /// }
  /// ```
  final String text;

  /// Customizes the appearance of the chart title text.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title',
  ///       textStyle: TextStyle(
  ///         color: Colors.red,
  ///         fontSize: 12,
  ///         fontStyle: FontStyle.normal,
  ///         fontWeight: FontWeight.w400,
  ///         fontFamily: 'Roboto'
  ///       )
  ///     )
  ///   );
  /// }
  /// ```
  final TextStyle? textStyle;

  /// Aligns the chart title.
  ///
  /// The alignment change is applicable only when the width of the
  /// chart title is less than the width of the chart.
  ///
  /// * `ChartAlignment.near` places the chart title at the beginning
  /// of the chart
  ///
  /// * `ChartAlignment.far` moves the chart title to end of the chart
  ///
  /// * `ChartAlignment.center` places the title at the center position
  /// of the chart’s width.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title',
  ///       alignment: ChartAlignment.near
  ///     )
  ///   );
  /// }
  /// ```
  final ChartAlignment alignment;

  /// Background color of the chart title.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title',
  ///       backgroundColor: Colors.white
  ///     )
  ///   );
  /// }
  /// ```
  final Color? backgroundColor;

  /// Border color of the chart title.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title',
  ///       borderColor: Colors.red,
  ///       borderWidth: 4
  ///     )
  ///   );
  /// }
  /// ```
  final Color borderColor;

  /// Border width of the chart title.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     title: ChartTitle(
  ///       text: 'Chart Title',
  ///       borderColor: Colors.red,
  ///       borderWidth: 4
  ///     )
  ///   );
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

    return other is ChartTitle &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      text,
      textStyle,
      alignment,
      backgroundColor,
      borderColor,
      borderWidth,
    ];
    return Object.hashAll(values);
  }
}
