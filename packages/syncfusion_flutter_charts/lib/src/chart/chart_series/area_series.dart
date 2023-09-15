import 'package:flutter/material.dart';
import '../../../charts.dart';

/// This class renders the area series.
///
/// To render an area chart, create an instance of [AreaSeries], and add it to the series collection property of [SfCartesianChart].
/// The area chart shows the filled area to represent the data, but when there are more than a series, this may hide the other series.
/// To get rid of this, increase or decrease the transparency of the series.
///
/// It provides options for color, opacity, border color, and border width to customize the appearance.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=E_odUnOsBtQ}
@immutable
class AreaSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of AreaSeries class.
  AreaSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D>? xValueMapper,
      required ChartValueMapper<T, num>? yValueMapper,
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
      List<Trendline>? trendlines,
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
      this.borderDrawMode = BorderDrawMode.top,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader})
      : super(
            key: key,
            onRendererCreated: onRendererCreated,
            onCreateRenderer: onCreateRenderer,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
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
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader);

  /// Border type of area series.
  ///
  /// It has three types of [BorderDrawMode],
  ///
  /// * [BorderDrawMode.all] renders border for all the sides of area.
  ///
  /// * [BorderDrawMode.top] renders border only for top side.
  ///
  /// * [BorderDrawMode.excludeBottom] renders border except bottom side.
  ///
  /// Defaults to `BorderDrawMode.top`.
  ///
  /// Also refer [BorderDrawMode].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <AreaSeries<SalesData, num>>[
  ///       AreaSeries<SalesData, num>(
  ///         borderWidth: 3,
  ///         borderColor: Colors.red,
  ///         borderDrawMode: BorderDrawMode.all,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderDrawMode borderDrawMode;

  /// Create the area series renderer.
  AreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    AreaSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as AreaSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return AreaSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AreaSeries &&
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
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
