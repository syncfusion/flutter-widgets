import 'package:flutter/material.dart';
import '../../../charts.dart';

import 'stacked_series_base.dart';

/// Renders the stacked bar series.
///
/// Stacked bar chart consists of multiple bar series stacked horizontally one after another.
/// The length of each series is determined by the value in each data point.
///
/// To render a stacked bar chart, create an instance of [StackedBarSeries], and add it to
/// the series collection property of [SfCartesianChart].
///
/// Provides options to customize properties such as [color], [opacity],
/// [borderWidth], [borderColor], [borderRadius] of the Stackedbar segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}

@immutable
class StackedBarSeries<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedBarSeries class.
  StackedBarSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      bool? isTrackVisible,
      String? groupName,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      double? spacing,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      BorderRadius? borderRadius,
      bool? enableTooltip,
      double? animationDuration,
      Color? trackColor,
      Color? trackBorderColor,
      double? trackBorderWidth,
      double? trackPadding,
      List<Trendline>? trendlines,
      Color? borderColor,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      List<double>? dashArray,
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
            name: name,
            dashArray: dashArray,
            groupName: groupName,
            spacing: spacing,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            isTrackVisible: isTrackVisible,
            trackColor: trackColor,
            trackBorderColor: trackBorderColor,
            trackBorderWidth: trackBorderWidth,
            trackPadding: trackPadding,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is StackedBarSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.groupName == groupName &&
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
        other.trackColor == trackColor &&
        other.trackBorderColor == trackBorderColor &&
        other.trackBorderWidth == trackBorderWidth &&
        other.trackPadding == trackPadding &&
        other.spacing == spacing &&
        other.borderRadius == borderRadius &&
        other.isTrackVisible == isTrackVisible &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.onCreateShader == onCreateShader &&
        other.initialSelectedDataIndexes == initialSelectedDataIndexes;
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
      pointColorMapper,
      dataLabelMapper,
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      groupName,
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
      trackColor,
      trackBorderColor,
      trackBorderWidth,
      trackPadding,
      spacing,
      borderRadius,
      isTrackVisible,
      onRendererCreated,
      initialSelectedDataIndexes,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }

  /// Create the stacked bar series renderer.
  StackedBarSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedBarSeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(series) as StackedBarSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedBarSeriesRenderer();
  }
}
