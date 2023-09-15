import 'package:flutter/material.dart';
import '../../common/utils/enum.dart';
import '../utils/enum.dart';

/// Customizes the annotation of the circular chart.
///
/// Circular chart allows you to mark the specific area of interest in the chart area.
/// You can add the custom widgets using this annotation feature, It has the properties for customizing the appearance.
///
/// The angle, orientation, height, and width of the inserted annotation can all be customized.
///
/// It provides options for angle, height, width, vertical and horizontal alignment to customize the appearance.
///
class CircularChartAnnotation {
  /// Creating an argument constructor of CircularChartAnnotation class.
  CircularChartAnnotation(
      {int? angle,
      String? radius,
      this.widget,
      String? height,
      String? width,
      ChartAlignment? horizontalAlignment,
      ChartAlignment? verticalAlignment})
      : angle = angle ?? 0,
        radius = radius ?? '0%',
        height = height ?? '0%',
        width = width ?? '0%',
        verticalAlignment = verticalAlignment ?? ChartAlignment.center,
        horizontalAlignment = horizontalAlignment ?? ChartAlignment.center;

  /// Angle to rotate the annotation.
  ///
  /// Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    angle: 40,
  ///                    widget: const Text('Circular'),
  ///               ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  final int angle;

  /// Radius for placing the annotation. The value ranges from 0% to 100% and also if values are
  /// mentioned in pixel then the annotation will moved accordingly.
  ///
  /// For example, if set `50%` means the annotation starting text will be placed from the `50%`
  /// chart area or we set `50` means the annotation starting text will be placed from 50 pixels.
  ///
  /// Defaults to `0%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    radius: '10%'
  ///                    widget: const Text('Circular'),
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  final String radius;

  /// Considers any widget as annotation.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    widget: const Text('Circular'),
  ///              ),
  ///            ],
  ///         )
  ///    );
  ///}
  ///```
  final Widget? widget;

  /// Height of the annotation.
  ///
  /// Defaults to `0%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    height: '10%',
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  final String height;

  /// Width of the annotation.
  ///
  /// Defaults to `0%`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    width: '10%',
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final String width;

  /// Aligns the annotation horizontally.
  ///
  /// Alignment can be set to `ChartAlignment.center`, `ChartAlignment.far`, or `ChartAlignment.near`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    horizontalAlignment: ChartAlignment.near
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///    );
  ///}
  ///```
  final ChartAlignment horizontalAlignment;

  /// Aligns the annotation vertically.
  ///
  /// Alignment can be set to `ChartAlignment.center`, `ChartAlignment.far`, or `ChartAlignment.near`.
  ///
  /// Defaults to `ChartAlignment.center`.
  ///
  /// Also refer [ChartAlignment].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            annotations: <CircularChartAnnotation>[
  ///                CircularChartAnnotation(
  ///                    verticalAlignment: ChartAlignment.near
  ///                    widget: const Text('Circular'),
  ///                 ),
  ///              ),
  ///           ],
  ///        )
  ///   );
  ///}
  ///```
  final ChartAlignment verticalAlignment;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is CircularChartAnnotation &&
        other.angle == angle &&
        other.radius == radius &&
        other.height == height &&
        other.horizontalAlignment == horizontalAlignment &&
        other.verticalAlignment == verticalAlignment &&
        other.widget == widget &&
        other.width == width;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      angle,
      radius,
      height,
      horizontalAlignment,
      verticalAlignment,
      widget,
      width
    ];
    return Object.hashAll(values);
  }
}

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
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            length: '8%'
  ///           )
  ///         )
  ///       )
  ///    );
  ///}
  ///```
  final String? length;

  /// Width of the connector line.
  ///
  /// Defaults to `1.0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            width: 2
  ///           )
  ///         )
  ///       )
  ///    );
  ///}
  ///```
  final double width;

  /// Color of the connector line.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///            color: Colors.red,
  ///           )
  ///         )
  ///       )
  ///    );
  ///}
  ///```
  final Color? color;

  /// Type of the connector line.
  ///
  /// Defaults to `ConnectorType.line`.
  ///
  /// Also refer [ConnectorType].
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           dataLabelSettings: DataLabelSettings(
  ///            connectorLineSettings: ConnectorLineSettings(
  ///             type: ConnectorType.curve
  ///             )
  ///           )
  ///        )
  ///     );
  ///}
  ///```
  final ConnectorType type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ConnectorLineSettings &&
        other.length == length &&
        other.width == width &&
        other.color == color &&
        other.type == type;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[length, width, color, type];
    return Object.hashAll(values);
  }
}
