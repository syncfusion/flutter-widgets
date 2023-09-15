import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Renders the waterfall series.
///
/// To render a waterfall chart, create an instance of [WaterfallSeries] and add to the series collection property of [SfCartesianChart].
///
/// [WaterfallSeries] is similar to range column series,
/// in range column high and low value should be there, but in waterfall
/// we have find the endValue and originValue of each data point.
@immutable
class WaterfallSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of WaterfallSeries class.
  WaterfallSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, bool>? intermediateSumPredicate,
      ChartValueMapper<T, bool>? totalSumPredicate,
      this.negativePointsColor,
      this.intermediateSumColor,
      this.totalSumColor,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      this.connectorLineSettings = const WaterfallConnectorLineSettings(),
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      this.spacing = 0,
      MarkerSettings? markerSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      this.borderRadius = BorderRadius.zero,
      bool? enableTooltip,
      double? animationDuration,
      Color? borderColor,
      List<Trendline>? trendlines,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      double? animationDelay,
      List<double>? dashArray,
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
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            intermediateSumPredicate: intermediateSumPredicate,
            totalSumPredicate: totalSumPredicate,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            animationDelay: animationDelay,
            onCreateShader: onCreateShader,
            dashArray: dashArray,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Color of the negative data points in the series.
  ///
  /// If no color is specified, then the negative data points will be rendered with the
  /// series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         negativePointsColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? negativePointsColor;

  /// Color of the intermediate sum points in the series.
  ///
  /// If no color is specified, then the intermediate sum points will be rendered with the
  /// series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         intermediateSumColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? intermediateSumColor;

  /// Color of the total sum points in the series.
  ///
  /// If no color is specified, then the total sum points will be rendered with the
  /// series default color.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         totalSumColor: Colors.red,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color? totalSumColor;

  /// Options to customize the waterfall chart connector line.
  ///
  /// Data points in waterfall chart are connected using the connector line. Provides the options to
  /// change the width, color and dash array of the connector line to customize the appearance.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         connectorLineSettings: WaterfallConnectorLineSettings(
  ///           width: 2,
  ///           color: Colors.black,
  ///           dashArray: [2,3]
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final WaterfallConnectorLineSettings connectorLineSettings;

  /// Spacing between the data points in waterfall chart.
  ///
  /// The value ranges from 0 to 1, where 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing affects the width of the bars in waterfall. For example, setting 20% spacing and 100% width
  /// renders the bars with 80% of total width.
  ///
  /// Also refer [CartesianSeries.width].
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Customizes the corners of the waterfall.
  ///
  /// Each corner can be customized with a desired value or with a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is WaterfallSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.intermediateSumPredicate == intermediateSumPredicate &&
        other.totalSumPredicate == totalSumPredicate &&
        other.negativePointsColor == negativePointsColor &&
        other.intermediateSumColor == intermediateSumColor &&
        other.totalSumColor == totalSumColor &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.dataLabelMapper == dataLabelMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.sortingOrder == sortingOrder &&
        other.connectorLineSettings == connectorLineSettings &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.spacing == spacing &&
        other.color == color &&
        other.width == width &&
        other.markerSettings == markerSettings &&
        other.emptyPointSettings == emptyPointSettings &&
        other.dataLabelSettings == dataLabelSettings &&
        other.trendlines == trendlines &&
        other.gradient == gradient &&
        other.borderGradient == borderGradient &&
        other.borderRadius == borderRadius &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.isVisible == isVisible &&
        other.enableTooltip == enableTooltip &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
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
      intermediateSumPredicate,
      totalSumPredicate,
      negativePointsColor,
      intermediateSumColor,
      totalSumColor,
      sortFieldValueMapper,
      dataLabelMapper,
      pointColorMapper,
      sortingOrder,
      connectorLineSettings,
      xAxisName,
      yAxisName,
      name,
      spacing,
      color,
      width,
      markerSettings,
      emptyPointSettings,
      dataLabelSettings,
      trendlines,
      gradient,
      borderGradient,
      borderWidth,
      borderRadius,
      borderColor,
      isVisible,
      enableTooltip,
      dashArray,
      animationDuration,
      selectionBehavior,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      animationDelay,
      onRendererCreated,
      initialSelectedDataIndexes,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }

  /// Create the waterfall series renderer.
  WaterfallSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    WaterfallSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as WaterfallSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return WaterfallSeriesRenderer();
  }
}

/// Options to customize the waterfall chart connector line.
///
/// Data points in waterfall chart are connected using the connector line and this class hold the
/// properties to customize it.
///
/// It provides the options to change the width, color and dash array of the connector line to
/// customize the appearance.
///
class WaterfallConnectorLineSettings extends ConnectorLineSettings {
  /// Creating an argument constructor of WaterfallConnectorLineSettings class.
  const WaterfallConnectorLineSettings(
      {double? width, Color? color, this.dashArray = const <double>[0, 0]})
      : super(color: color, width: width ?? 1);

  /// Dashes of the waterfall chart connector line.
  ///
  /// Any number of values can be provided in the list. Odd values are considered as rendering
  /// size and even values are considered as gap.
  ///
  /// Defaults to `null.`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <WaterfallSeries<SalesData, num>>[
  ///       WaterfallSeries<SalesData, num>(
  ///         connectorLineSettings: WaterfallConnectorLineSettings(
  ///           dashArray: [2,3]
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final List<double>? dashArray;
}
