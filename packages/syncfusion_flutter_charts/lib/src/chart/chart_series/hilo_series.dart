import 'package:flutter/material.dart';
import '../../../charts.dart';

import 'financial_series_base.dart';

/// Renders the hilo series.
///
/// [HiloSeries] illustrates the price movements in stock using the high and low values.
///
/// To render a hilo chart, create an instance of [HiloSeries], and add it to the series collection property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=uSsKhlRzC2Q}
class HiloSeries<T, D> extends FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of HiloSeries class.
  HiloSeries({
    ValueKey<String>? key,
    ChartSeriesRendererFactory<T, D>? onCreateRenderer,
    required List<T> dataSource,
    required ChartValueMapper<T, D> xValueMapper,
    required ChartValueMapper<T, num> lowValueMapper,
    required ChartValueMapper<T, num> highValueMapper,
    ChartValueMapper<T, dynamic>? sortFieldValueMapper,
    ChartValueMapper<T, Color>? pointColorMapper,
    ChartValueMapper<T, String>? dataLabelMapper,
    SortingOrder? sortingOrder,
    String? xAxisName,
    String? yAxisName,
    String? name,
    Color? color,
    MarkerSettings? markerSettings,
    EmptyPointSettings? emptyPointSettings,
    DataLabelSettings? dataLabelSettings,
    bool? isVisible,
    bool? enableTooltip,
    double? animationDuration,
    double? borderWidth,
    SelectionBehavior? selectionBehavior,
    bool? isVisibleInLegend,
    LegendIconType? legendIconType,
    String? legendItemText,
    List<double>? dashArray,
    double? opacity,
    double? animationDelay,
    double? spacing,
    List<int>? initialSelectedDataIndexes,
    bool? showIndicationForSameValues,
    List<Trendline>? trendlines,
    SeriesRendererCreatedCallback? onRendererCreated,
    ChartPointInteractionCallback? onPointTap,
    ChartPointInteractionCallback? onPointDoubleTap,
    ChartPointInteractionCallback? onPointLongPress,
    CartesianShaderCallback? onCreateShader,
  }) : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            spacing: spacing,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            color: color,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderWidth: borderWidth ?? 2,
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
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            trendlines: trendlines);

  /// Create the hilo series renderer.
  HiloSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HiloSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as HiloSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HiloSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is HiloSeries &&
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
        other.bearColor == bearColor &&
        other.bullColor == bullColor &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.borderWidth == borderWidth &&
        other.selectionBehavior == selectionBehavior &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.animationDelay == animationDelay &&
        other.spacing == spacing &&
        other.showIndicationForSameValues == showIndicationForSameValues &&
        other.initialSelectedDataIndexes == other.initialSelectedDataIndexes &&
        other.onRendererCreated == onRendererCreated &&
        other.onPointTap == onPointTap &&
        other.onPointDoubleTap == onPointDoubleTap &&
        other.onPointLongPress == onPointLongPress &&
        other.onCreateShader == onCreateShader;
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
      bearColor,
      bullColor,
      emptyPointSettings,
      dataLabelSettings,
      isVisible,
      enableTooltip,
      animationDuration,
      borderWidth,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      dashArray,
      opacity,
      animationDelay,
      spacing,
      onRendererCreated,
      initialSelectedDataIndexes,
      showIndicationForSameValues,
      trendlines,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
