import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Renders the spline series.
///
/// The spline chart draws a curved line between the points in a data series.To render a spline chart, create an instance of
/// [SplineSeries], and add it to the series collection property of [SfCartesianChart].
///
/// Provides options to customize the color, opacity and width of the spline series segments.
@immutable
class SplineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of SplineSeries class.
  SplineSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      MarkerSettings? markerSettings,
      this.splineType,
      this.cardinalSplineTension = 0.5,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      List<Trendline>? trendlines,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      SortingOrder? sortingOrder,
      String? legendItemText,
      double? opacity,
      double? animationDelay,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            width: width ?? 2,
            trendlines: trendlines,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            isVisible: isVisible,
            dashArray: dashArray,
            animationDuration: animationDuration,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Type of the spline curve. Various type of curves such as clamped, cardinal,
  /// monotonic, and natural can be rendered between the data points.
  ///
  /// Defaults to `SplineType.natural`.
  ///
  /// Also refer [SplineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         splineType: SplineType.monotonic,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final SplineType? splineType;

  /// Line tension of the cardinal spline. The value ranges from 0 to 1.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineSeries<SalesData, num>>[
  ///       SplineSeries<SalesData, num>(
  ///         cardinalSplineTension: 0.4,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double cardinalSplineTension;

  /// Create the spline area series renderer.
  SplineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    SplineSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as SplineSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return SplineSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SplineSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.width == width &&
        other.markerSettings == markerSettings &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.gradient == gradient &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.animationDelay == animationDelay &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.onCreateShader == onCreateShader &&
        other.initialSelectedDataIndexes == initialSelectedDataIndexes &&
        other.cardinalSplineTension == cardinalSplineTension &&
        other.splineType == splineType;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      yValueMapper,
      sortFieldValueMapper,
      dataLabelMapper,
      pointColorMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      width,
      markerSettings,
      emptyPointSettings,
      dataLabelSettings,
      trendlines,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      gradient,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      animationDelay,
      onRendererCreated,
      initialSelectedDataIndexes,
      cardinalSplineTension,
      splineType,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
