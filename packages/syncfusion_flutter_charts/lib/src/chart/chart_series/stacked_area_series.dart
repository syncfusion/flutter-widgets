import 'package:flutter/material.dart';
import '../../../charts.dart';

import 'stacked_series_base.dart';

/// Renders the stacked area series.
///
/// A stacked area chart is the extension of a basic area chart to display
/// the evolution of the value of several groups on the same graphic.
///
/// The values of each group are displayed on top of each other.
///
/// To render a stacked area chart, create an instance of [StackedAreaSeries], and add it to the series collection property of [SfCartesianChart].
///
/// Provides options to customize the [color], [opacity], [borderWidth], [borderColor] of the stacked area segments.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=NCUDBD_ClHo}
@immutable
class StackedAreaSeries<T, D> extends StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedAreaSeries class.
  StackedAreaSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      String? groupName,
      List<Trendline>? trendlines,
      Color? color,
      MarkerSettings? markerSettings,
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
      this.borderDrawMode = BorderDrawMode.top})
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
            groupName: groupName,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader);

  /// Border type of stacked area series.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedAreaSeries<SalesData, num>>[
  ///       StackedAreaSeries<SalesData, num>(
  ///         borderDrawMode: BorderDrawMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderDrawMode borderDrawMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is StackedAreaSeries &&
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
        other.groupName == groupName &&
        other.color == color &&
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
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderGradient == borderGradient &&
        other.borderDrawMode == borderDrawMode;
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
      groupName,
      color,
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
      borderColor,
      borderWidth,
      borderGradient,
      borderDrawMode,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }

  /// Create the stacked area series renderer.
  StackedAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedAreaSeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(series) as StackedAreaSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedAreaSeriesRenderer();
  }
}
