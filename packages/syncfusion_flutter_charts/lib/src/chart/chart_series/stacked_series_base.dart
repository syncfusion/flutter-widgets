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

/// Represents the stacked series base class.
abstract class StackedSeriesBase<T, D> extends XyDataSeries<T, D> {
  /// Creates an instance of stacked series renderer.
  StackedSeriesBase(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
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
      LinearGradient? borderGradient,
      BorderRadius? borderRadius,
      String? groupName,
      bool? isTrackVisible,
      List<Trendline>? trendlines,
      bool? enableTooltip,
      double? animationDuration,
      Color? trackColor,
      Color? trackBorderColor,
      double? trackBorderWidth,
      double? trackPadding,
      Color? borderColor,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      List<int>? initialSelectedDataIndexes,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader,
      double? animationDelay,
      double? opacity})
      : borderRadius = borderRadius ?? BorderRadius.zero,
        trackColor = trackColor ?? Colors.grey,
        trackBorderColor = trackBorderColor ?? Colors.transparent,
        trackBorderWidth = trackBorderWidth ?? 1,
        trackPadding = trackPadding ?? 0,
        groupName = groupName ?? '',
        isTrackVisible = isTrackVisible ?? false,
        dashArray = dashArray ?? <double>[0, 0],
        spacing = spacing ?? 0,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            trendlines: trendlines,
            dataSource: dataSource,
            xAxisName: xAxisName,
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
            selectionBehavior: selectionBehavior,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
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

  /// Customizes the corners of the column. Each corner can be customized with a desired
  /// value or with a single value.
  ///
  /// Defaults to `BorderRadius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

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
  ///    return SfCartesianChart(
  ///      series: <StackedColumnSeries<SalesData, num>>[
  ///        StackedColumnSeries<SalesData, num>(
  ///          spacing: 0.5,
  ///        ),
  ///      ],
  ///    );
  /// }
  /// ```
  final double spacing;

  /// Renders column with track. Track is a rectangular bar rendered from the start
  /// to the end of the axis. Column series will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool isTrackVisible;

  /// Color of the track.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackColor;

  /// Color of the track border.
  ///
  /// Defaults to `Colors.transparent`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color trackBorderColor;

  /// Width of the track border.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red ,
  ///         trackBorderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackBorderWidth;

  /// Padding of the track.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <StackedColumnSeries<SalesData, num>>[
  ///       StackedColumnSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  /// Specifies the dash array.
  @override
  final List<double> dashArray;

  /// Specifies the group name.
  final String groupName;
}

/// Represents the stacked series renderer class.
abstract class StackedSeriesRenderer extends XyDataSeriesRenderer {}
