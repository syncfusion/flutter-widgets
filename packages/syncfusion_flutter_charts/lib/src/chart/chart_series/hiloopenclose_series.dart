import 'package:flutter/material.dart';
import '../../../charts.dart';

import 'financial_series_base.dart';

/// Renders the hilo open close series.
///
/// Hilo open close series is used to represent the low, high, open and closing values over time.
///
/// To render a hilo open close chart, create an instance of [HiloOpenCloseSeries],
/// and add it to the series collection property of [SfCartesianChart].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=g5cniDExpRw}
class HiloOpenCloseSeries<T, D> extends FinancialSeriesBase<T, D> {
  /// Creating an argument constructor of HiloOpenCloseSeries class.
  HiloOpenCloseSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> lowValueMapper,
      required ChartValueMapper<T, num> highValueMapper,
      required ChartValueMapper<T, num> openValueMapper,
      required ChartValueMapper<T, num> closeValueMapper,
      ChartValueMapper<T, num>? volumeValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? bearColor,
      Color? bullColor,
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
      CartesianShaderCallback? onCreateShader})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            spacing: spacing,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            // ignore: unnecessary_null_comparison
            openValueMapper: openValueMapper != null
                ? (int index) => openValueMapper(dataSource[index], index)
                : null,
            // ignore: unnecessary_null_comparison
            closeValueMapper: closeValueMapper != null
                ? (int index) => closeValueMapper(dataSource[index], index)
                : null,
            // ignore: unnecessary_null_comparison
            volumeValueMapper: volumeValueMapper != null
                ? (int index) => volumeValueMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
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
            bearColor: bearColor ?? Colors.red,
            bullColor: bullColor ?? Colors.green,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            trendlines: trendlines);

  /// Create the hilo open close series renderer.
  HiloOpenCloseSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HiloOpenCloseSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as HiloOpenCloseSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HiloOpenCloseSeriesRenderer();
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is HiloOpenCloseSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.openValueMapper == openValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.volumeValueMapper == volumeValueMapper &&
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
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    final List<Object?> values = <Object?>[
      key,
      onCreateRenderer,
      dataSource,
      xValueMapper,
      lowValueMapper,
      highValueMapper,
      openValueMapper,
      closeValueMapper,
      volumeValueMapper,
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
