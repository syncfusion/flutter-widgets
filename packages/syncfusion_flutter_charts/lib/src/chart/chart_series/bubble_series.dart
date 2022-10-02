import 'package:flutter/material.dart';
import '../../../charts.dart';

/// This class holds the properties of the bubble series.
///
/// To render a bubble chart, create an instance of [BubbleSeries], and add it to the series collection property of [SfCartesianChart].
/// A bubble chart requires three fields (X, Y, and Size) to plot a point. Here, [sizeValueMapper] is used to map the size of each bubble segment from the data source.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
///
@immutable
class BubbleSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BubbleSeries class.
  BubbleSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, num>? sizeValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      String? xAxisName,
      String? yAxisName,
      Color? color,
      MarkerSettings? markerSettings,
      List<Trendline>? trendlines,
      this.minimumRadius = 3,
      this.maximumRadius = 10,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      String? name,
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
            name: name,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            sizeValueMapper: sizeValueMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
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
            onCreateShader: onCreateShader,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Maximum radius value of the bubble in the series.
  ///
  /// Defaults to `10`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         maximumRadius: 9
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final num maximumRadius;

  /// Minimum radius value of the bubble in the series.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BubbleSeries<BubbleColors, num>>[
  ///       BubbleSeries<BubbleColors, num>(
  ///         minimumRadius: 9
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final num minimumRadius;

  /// Create the bubble series renderer.
  BubbleSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BubbleSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as BubbleSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BubbleSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BubbleSeries &&
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
        other.maximumRadius == maximumRadius &&
        other.minimumRadius == minimumRadius &&
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
      maximumRadius,
      minimumRadius,
      initialSelectedDataIndexes,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}
