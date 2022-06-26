import 'package:flutter/material.dart';
import '../../chart/utils/enum.dart';
import '../../common/common.dart';
import '../../common/user_interaction/selection_behavior.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../common/data_label.dart';
import '../common/marker.dart';
import '../trendlines/trendlines.dart';
import 'xy_data_series.dart';

/// Represents the financial series base.
abstract class FinancialSeriesBase<T, D> extends XyDataSeries<T, D> {
  /// Creates an instance of financial series base.
  FinancialSeriesBase(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num>? lowValueMapper,
      ChartValueMapper<T, num>? highValueMapper,
      this.openValueMapper,
      this.closeValueMapper,
      this.volumeValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      List<double>? dashArray,
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
      bool? enableTooltip,
      double? animationDuration,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      List<int>? initialSelectedDataIndexes,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      this.enableSolidCandles,
      this.bearColor,
      this.bullColor,
      double? opacity,
      double? animationDelay,
      this.showIndicationForSameValues = false,
      List<Trendline>? trendlines,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader})
      : dashArray = dashArray ?? <double>[0, 0],
        spacing = spacing ?? 0,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderWidth: borderWidth,
            selectionBehavior: selectionBehavior,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
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
            trendlines: trendlines);

  /// Specifies the volume value mapper.
  final ChartIndexedValueMapper<num>? volumeValueMapper;

  /// Specifies the open value mapper.
  final ChartIndexedValueMapper<num?>? openValueMapper;

  /// Specifies the close value mapper.
  final ChartIndexedValueMapper<num?>? closeValueMapper;

  /// Specifies the bear color.
  final Color? bearColor;

  /// Specifies the bull color.
  final Color? bullColor;

  /// Specifies whether the solid candles.
  final bool? enableSolidCandles;

  /// Specifies the dash array.
  @override
  final List<double> dashArray;

  /// Spacing between the columns. The value ranges from 0 to 1.
  /// 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing also affects the width of the column. For example, setting 20% spacing
  /// and 100% width renders the column with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HiloSeries<SalesData, num>>[
  ///       HiloSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// If it is set to true, a small vertical line will be rendered. Else nothing will
  /// be rendered for that specific data point and left as a blank area.
  ///
  /// This is applicable for the following series types:
  /// * HiLo (High low)
  /// * OHLC (Open high low close)
  /// * Candle
  ///
  /// Defaults to `false`.
  final bool showIndicationForSameValues;
}
