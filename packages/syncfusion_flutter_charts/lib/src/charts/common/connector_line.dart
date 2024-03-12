import 'package:flutter/material.dart';

import '../common/data_label.dart';
import '../utils/enum.dart';

/// This class holds the properties of the connector line.
///
/// ConnectorLineSetting is the Argument type of [DataLabelSettings], It is used to customize the data label connected lines while the data label
/// position is outside the chart. It is enabled by setting the data label visibility.
///
/// It provides the options for length, width, color, and enum type [ConnectorType] to customize the appearance.
///
class ConnectorLineSettings {
  /// Creating an argument constructor of ConnectorLineSettings class.
  const ConnectorLineSettings(
      {this.length, double? width, ConnectorType? type, this.color})
      : width = width ?? 1.0,
        type = type ?? ConnectorType.line;

  /// Length of the connector line. The value range from 0% to 100%.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <LineSeries<SalesData,num>>[
  ///            LineSeries<SalesData, num>(
  ///              dataLabelSettings: DataLabelSettings(
  ///                connectorLineSettings: ConnectorLineSettings(
  ///                  length: '8%'
  ///              )
  ///            )
  ///          )
  ///        ]
  ///      )
  ///    );
  /// }
  /// ```
  final String? length;

  /// Width of the connector line.
  ///
  /// Defaults to `1.0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <LineSeries<SalesData,num>>[
  ///            LineSeries<SalesData, num>(
  ///              dataLabelSettings: DataLabelSettings(
  ///                connectorLineSettings: ConnectorLineSettings(
  ///                  width: 2
  ///              )
  ///            )
  ///          )
  ///        ]
  ///      )
  ///    );
  /// }
  /// ```
  final double width;

  /// Color of the connector line.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <LineSeries<SalesData,num>>[
  ///            LineSeries<SalesData, num>(
  ///              dataLabelSettings: DataLabelSettings(
  ///                connectorLineSettings: ConnectorLineSettings(
  ///                  color: Colors.red,
  ///               )
  ///             )
  ///           )
  ///         ]
  ///       )
  ///    );
  /// }
  /// ```
  final Color? color;

  /// Type of the connector line.
  ///
  /// Defaults to `ConnectorType.line`.
  ///
  /// Also refer [ConnectorType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <LineSeries<SalesData,num>>[
  ///            LineSeries<SalesData, num>(
  ///              dataLabelSettings: DataLabelSettings(
  ///                connectorLineSettings: ConnectorLineSettings(
  ///                  type: ConnectorType.curve
  ///               )
  ///             )
  ///           )
  ///         ]
  ///       )
  ///    );
  /// }
  /// ```
  final ConnectorType type;
}
