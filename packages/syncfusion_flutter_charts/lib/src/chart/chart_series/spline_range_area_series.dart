import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Renders the spline range area series.
///
/// To render a spline range area chart, create an instance of [SplineRangeAreaSeries], and add it to the series collection property of [SfCartesianChart].
/// Properties such as [color], [opacity], [width] are used to customize the appearance of spline area chart.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
@immutable
class SplineRangeAreaSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of SplineRangeAreaSeries class.
  SplineRangeAreaSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> highValueMapper,
      required ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      MarkerSettings? markerSettings,
      this.splineType,
      List<Trendline>? trendlines,
      this.cardinalSplineTension = 0.5,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      bool? enableTooltip,
      List<double>? dashArray,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      double? animationDelay,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader,
      this.borderDrawMode = RangeAreaBorderMode.all})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            trendlines: trendlines,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradient: gradient,
            borderGradient: borderGradient,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader);

  /// Border type of the spline range area series.
  ///
  /// It takes the following two values:
  ///
  /// * [RangeAreaBorderMode.all] renders border for all the sides of the series.
  /// * [RangeAreaBorderMode.excludeSides] renders border at the top and bottom of the series,
  /// and excludes both sides.
  ///
  /// Defaults to `RangeAreaBorderMode.all`.
  ///
  /// Also refer [RangeAreaBorderMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         borderColor: Colors.red,
  ///         borderWidth: 3,
  ///         borderDrawMode: RangeAreaBorderMode.excludeSides,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final RangeAreaBorderMode borderDrawMode;

  /// Type of the spline curve in spline range area series.
  ///
  /// Various type of curves such as `SplineType.clamped`, `SplineType.cardinal`, `SplineType.monotonic`
  /// and `SplineType.natural` can be rendered between the data points.
  ///
  /// Defaults to `SplineType.natural`.
  ///
  /// Also refer [SplineType].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         splineType: SplineType.monotonic
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final SplineType? splineType;

  /// Line tension of the cardinal spline curve.
  ///
  /// This is applicable only when `SplineType.cardinal` is set to [splineType] property.
  ///
  /// Defaults to `0.5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <SplineRangeAreaSeries<SalesData, num>>[
  ///       SplineRangeAreaSeries<SalesData, num>(
  ///         splineType: SplineType.cardinal,
  ///         cardinalSplineTension: 0.2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double cardinalSplineTension;

  /// Create the spline area series renderer.
  SplineRangeAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    SplineRangeAreaSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer =
          onCreateRenderer!(series) as SplineRangeAreaSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return SplineRangeAreaSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SplineRangeAreaSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.markerSettings == markerSettings &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.gradient == gradient &&
        other.borderGradient == borderGradient &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.animationDelay == animationDelay &&
        other.borderDrawMode == borderDrawMode &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.onCreateShader == onCreateShader &&
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
      lowValueMapper,
      highValueMapper,
      sortFieldValueMapper,
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      markerSettings,
      emptyPointSettings,
      dataLabelSettings,
      trendlines,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      borderColor,
      borderWidth,
      gradient,
      borderGradient,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      animationDelay,
      borderDrawMode,
      onRendererCreated,
      cardinalSplineTension,
      splineType,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
