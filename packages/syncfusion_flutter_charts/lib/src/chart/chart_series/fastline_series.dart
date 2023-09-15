import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Renders the [FastLineSeries].
///
/// [FastLineSeries] is a line chart, but it loads faster than [LineSeries].
///
/// You can use this when there are large number of points to be loaded in a chart. To render a fast line chart,
/// create an instance of [FastLineSeries], and add it to the series collection property of [SfCartesianChart].
///
/// The following properties are used to customize the appearance of fast line segment:
///
/// * color - Changes the color of the line.
/// * opacity - Controls the transparency of the chart series.
/// * width - Changes the stroke width of the line.
class FastLineSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of FastLineSeries class.
  FastLineSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      Color? color,
      double? width,
      List<double>? dashArray,
      LinearGradient? gradient,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      List<Trendline>? trendlines,
      DataLabelSettings? dataLabelSettings,
      SortingOrder? sortingOrder,
      bool? isVisible,
      String? name,
      bool? enableTooltip,
      double? animationDuration,
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
      CartesianShaderCallback? onCreateShader})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 2,
            gradient: gradient,
            dashArray: dashArray,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
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

  /// Create the fastline series renderer.
  FastLineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    FastLineSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as FastLineSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return FastLineSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is FastLineSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.dataLabelMapper == dataLabelMapper &&
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
        other.onCreateShader == onCreateShader;
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
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
