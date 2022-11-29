import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../chart/common/data_label.dart';
import '../../chart/utils/enum.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../base/circular_base.dart';
import '../utils/enum.dart';
import 'circular_series.dart';
import 'renderer_base.dart';
import 'renderer_extension.dart';

/// Renders the radial bar series.
///
/// The radial bar chart is used for showing the comparisons among the categories using the circular shapes.
/// To render a radial bar chart, create an instance of RadialBarSeries, and add to the series collection property of [SfCircularChart].
///
/// Provides options to customize the [maximumValue], [trackColor], [trackBorderColor], [trackBorderWidth], [trackOpacity]
/// and [useSeriesColor] of the radial segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=VJxPp7-2nGk}
class RadialBarSeries<T, D> extends CircularSeries<T, D> {
  /// Creating an argument constructor of RadialBarSeries class.
  ///
  RadialBarSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      CircularSeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      List<T>? dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartShaderMapper<T>? pointShaderMapper,
      ChartValueMapper<T, String>? pointRadiusMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      ChartValueMapper<T, String>? sortFieldValueMapper,
      this.trackColor = const Color.fromRGBO(234, 236, 239, 1.0),
      this.trackBorderWidth = 0.0,
      this.trackOpacity = 1,
      this.useSeriesColor = false,
      this.trackBorderColor = Colors.transparent,
      this.maximumValue,
      DataLabelSettings? dataLabelSettings,
      String? radius,
      String? innerRadius,
      String? gap,
      double? strokeWidth,
      double? opacity,
      Color? strokeColor,
      bool? enableTooltip,
      String? name,
      double? animationDuration,
      double? animationDelay,
      SelectionBehavior? selectionBehavior,
      SortingOrder? sortingOrder,
      LegendIconType? legendIconType,
      CornerStyle? cornerStyle,
      List<int>? initialSelectedDataIndexes})
      : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          onRendererCreated: onRendererCreated,
          onPointTap: onPointTap,
          onPointDoubleTap: onPointDoubleTap,
          onPointLongPress: onPointLongPress,
          dataSource: dataSource,
          animationDuration: animationDuration,
          animationDelay: animationDelay,
          xValueMapper: (int index) => xValueMapper(dataSource![index], index),
          yValueMapper: (int index) => yValueMapper(dataSource![index], index),
          pointColorMapper: (int index) => pointColorMapper != null
              ? pointColorMapper(dataSource![index], index)
              : null,
          pointRadiusMapper: (int index) => pointRadiusMapper != null
              ? pointRadiusMapper(dataSource![index], index)
              : null,
          pointShaderMapper: pointShaderMapper != null
              ? (dynamic data, int index, Color color, Rect rect) =>
                  pointShaderMapper(dataSource![index], index, color, rect)
              : null,
          dataLabelMapper: (int index) => dataLabelMapper != null
              ? dataLabelMapper(dataSource![index], index)
              : null,
          sortFieldValueMapper: sortFieldValueMapper != null
              ? (int index) => sortFieldValueMapper(dataSource![index], index)
              : null,
          radius: radius,
          innerRadius: innerRadius,
          gap: gap,
          borderColor: strokeColor,
          borderWidth: strokeWidth,
          opacity: opacity,
          enableTooltip: enableTooltip,
          dataLabelSettings: dataLabelSettings,
          name: name,
          selectionBehavior: selectionBehavior,
          sortingOrder: sortingOrder,
          legendIconType: legendIconType,
          cornerStyle: cornerStyle,
          initialSelectedDataIndexes: initialSelectedDataIndexes,
        );

  /// Color of the track.
  ///
  /// Defaults to `const Color.fromRGBO(234, 236, 239, 1.0)`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackColor: Colors.red,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final Color trackColor;

  /// Specifies the maximum value of the radial bar.
  ///
  /// By default, the sum of the data points values will be considered as maximum value.
  ///
  /// Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  maximumValue: 100,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final double? maximumValue;

  /// Border color of the track.
  ///
  /// Defaults to `Colors.Transparent`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderColor: Colors.red,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final Color trackBorderColor;

  /// Border width of the track.
  ///
  /// Defaults to `0.0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackBorderWidth: 2,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final double trackBorderWidth;

  /// Opacity of the track.
  ///
  /// Defaults to `1`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  trackOpacity: 0.2,
  ///                ),
  ///            ],
  ///        )
  ///    );
  ///}
  ///```
  final double trackOpacity;

  /// Uses the point color for filling the track.
  ///
  /// Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCircularChart(
  ///            series: <RadialBarSeries<ChartData, String>>[
  ///                RadialBarSeries<ChartData, String>(
  ///                  useSeriesColor:true
  ///                ),
  ///            ],
  ///        )
  ///   );
  ///}
  ///```
  final bool useSeriesColor;

  /// Create the Radial bar series renderer.
  RadialBarSeriesRenderer createRenderer(CircularSeries<T, D> series) {
    RadialBarSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as RadialBarSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return RadialBarSeriesRendererExtension();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is RadialBarSeries &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.cornerStyle == cornerStyle &&
        other.dataLabelMapper == dataLabelMapper &&
        other.dataLabelSettings == dataLabelSettings &&
        other.dataSource == dataSource &&
        other.enableTooltip == enableTooltip &&
        other.gap == gap &&
        listEquals(
            other.initialSelectedDataIndexes, initialSelectedDataIndexes) &&
        other.innerRadius == innerRadius &&
        other.legendIconType == legendIconType &&
        other.maximumValue == maximumValue &&
        other.name == name &&
        other.onCreateRenderer == onCreateRenderer &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.opacity == opacity &&
        other.pointColorMapper == pointColorMapper &&
        other.pointRadiusMapper == pointRadiusMapper &&
        other.pointShaderMapper == pointShaderMapper &&
        other.radius == radius &&
        other.selectionBehavior == selectionBehavior &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.sortingOrder == sortingOrder &&
        other.trackBorderColor == trackBorderColor &&
        other.trackBorderWidth == trackBorderWidth &&
        other.trackColor == trackColor &&
        other.trackOpacity == trackOpacity &&
        other.useSeriesColor == useSeriesColor &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      animationDuration,
      animationDelay,
      borderColor,
      borderWidth,
      cornerStyle,
      dataLabelMapper,
      dataLabelSettings,
      dataSource,
      enableTooltip,
      gap,
      initialSelectedDataIndexes,
      innerRadius,
      legendIconType,
      maximumValue,
      name,
      onCreateRenderer,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress,
      opacity,
      pointColorMapper,
      pointRadiusMapper,
      pointShaderMapper,
      radius,
      selectionBehavior,
      sortFieldValueMapper,
      sortingOrder,
      trackBorderColor,
      trackBorderWidth,
      trackColor,
      trackOpacity,
      useSeriesColor,
      xValueMapper,
      yValueMapper
    ];
    return Object.hashAll(values);
  }
}
