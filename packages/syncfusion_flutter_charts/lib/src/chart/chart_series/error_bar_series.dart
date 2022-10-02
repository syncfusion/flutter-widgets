import 'package:flutter/material.dart';
import '../../../charts.dart';

/// This class has the properties of the error bar series.
///
/// To render a error bar chart, create an instance of [ErrorBarSeries],
/// and add it to the series collection property of [SfCartesianChart].
///
class ErrorBarSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of ErrorBarSeries class.
  ErrorBarSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      EmptyPointSettings? emptyPointSettings,
      bool? isVisible,
      double? animationDuration,
      double? opacity,
      double animationDelay = 1500,
      List<double>? dashArray,
      SeriesRendererCreatedCallback? onRendererCreated,
      String? legendItemText,
      bool isVisibleInLegend = false,
      LegendIconType legendIconType = LegendIconType.verticalLine,
      this.type = ErrorBarType.fixed,
      this.direction = Direction.both,
      this.mode = RenderingMode.vertical,
      this.verticalErrorValue = 3,
      this.horizontalErrorValue = 1,
      this.verticalPositiveErrorValue = 3,
      this.horizontalPositiveErrorValue = 1,
      this.verticalNegativeErrorValue = 3,
      this.horizontalNegativeErrorValue = 1,
      this.capLength = 10,
      this.onRenderDetailsUpdate,
      CartesianShaderCallback? onCreateShader})
      : super(
          key: key,
          onCreateRenderer: onCreateRenderer,
          name: name,
          xValueMapper: xValueMapper,
          yValueMapper: yValueMapper,
          sortFieldValueMapper: sortFieldValueMapper,
          pointColorMapper: pointColorMapper,
          dataSource: dataSource,
          xAxisName: xAxisName,
          yAxisName: yAxisName,
          color: color,
          width: width ?? 2,
          isVisible: isVisible,
          emptyPointSettings: emptyPointSettings,
          animationDuration: animationDuration,
          legendItemText: legendItemText,
          isVisibleInLegend: isVisibleInLegend,
          legendIconType: legendIconType,
          sortingOrder: sortingOrder,
          opacity: opacity,
          animationDelay: animationDelay,
          dashArray: dashArray,
          onRendererCreated: onRendererCreated,
          onCreateShader: onCreateShader,
        );

  /// Type of the error bar.
  ///
  /// Defaults to `ErrorBarType.fixed`.
  ///
  /// Other values are `ErrorBarType.percentage`, `ErrorBarType.standardDeviation`,
  /// `ErrorBarType.custom`, `ErrorBarType.standardError`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.fixed,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ErrorBarType? type;

  /// Direction of error bar.
  ///
  /// Defaults to `Direction.both`.
  ///
  /// Also refer [Direction].
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         direction: Direction.plus,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Direction? direction;

  /// Mode of error bar.
  ///
  /// Defaults to `RenderingMode.vertical`.
  ///
  /// Other values are `RenderingMode.horizontal` and `RenderingMode.both`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         mode: RenderingMode.both,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final RenderingMode? mode;

  /// Vertical error value in Y direction.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         verticalErrorValue: 2,
  ///         mode: RenderingMode.vertical,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalErrorValue;

  /// Horizontal error value in X direction..
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         horizontalErrorValue:2,
  ///         mode: RenderingMode.horizontal,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalErrorValue;

  /// Vertical error value in positive Y direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         verticalPositiveErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalPositiveErrorValue;

  /// Horizontal error value in positive X direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         horizontalPositiveErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalPositiveErrorValue;

  /// Vertical error value in negative Y direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         verticalNegativeErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? verticalNegativeErrorValue;

  /// Horizontal error value in negative X direction.
  /// It's only applicable for 'ErrorBarType.custom'.
  ///
  /// Defaults to `1`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         type:ErrorBarType.custom,
  ///         horizontalNegativeErrorValue:2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? horizontalNegativeErrorValue;

  /// Length of the error bar's cap.
  ///
  /// Defaults to `10`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         capLength:20.0,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? capLength;

  /// Callback which gets called on error bar render.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <ErrorBarSeries<SalesData, String>>[
  ///       ErrorBarSeries<SalesData, String>(
  ///         onRenderDetailsUpdate: (ErrorBarRenderDetails errorBarRenderDetails){
  ///           print(args.pointIndex);
  ///           print(args.viewPortPointIndex);
  ///           print(args.calculatedErrorBarValues!.horizontalPositiveErrorValue);
  ///           print(args.calculatedErrorBarValues!.horizontalNegativeErrorValue);
  ///           print(args.calculatedErrorBarValues!.verticalPositiveErrorValue);
  ///           print(args.calculatedErrorBarValues!.verticalNegativeErrorValue);
  ///         }
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final ChartErrorBarRenderCallback? onRenderDetailsUpdate;

  /// Create the error bar series renderer.
  ErrorBarSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    ErrorBarSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as ErrorBarSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return ErrorBarSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is ErrorBarSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.yValueMapper == yValueMapper &&
        other.sortFieldValueMapper == sortFieldValueMapper &&
        other.pointColorMapper == pointColorMapper &&
        other.sortingOrder == sortingOrder &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.name == name &&
        other.color == color &&
        other.width == width &&
        other.emptyPointSettings == emptyPointSettings &&
        other.isVisible == isVisible &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.opacity == opacity &&
        other.animationDelay == animationDelay &&
        other.onRendererCreated == onRendererCreated &&
        other.type == type &&
        other.direction == direction &&
        other.mode == mode &&
        other.verticalErrorValue == verticalErrorValue &&
        other.horizontalErrorValue == horizontalErrorValue &&
        other.verticalPositiveErrorValue == verticalPositiveErrorValue &&
        other.horizontalPositiveErrorValue == horizontalPositiveErrorValue &&
        other.verticalNegativeErrorValue == verticalNegativeErrorValue &&
        other.horizontalNegativeErrorValue == horizontalNegativeErrorValue &&
        other.capLength == capLength &&
        other.onCreateShader == onCreateShader &&
        other.onRenderDetailsUpdate == onRenderDetailsUpdate;
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
      sortingOrder,
      xAxisName,
      yAxisName,
      name,
      color,
      width,
      emptyPointSettings,
      isVisible,
      dashArray,
      animationDuration,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      opacity,
      animationDelay,
      onRendererCreated,
      type,
      direction,
      mode,
      verticalErrorValue,
      horizontalErrorValue,
      verticalPositiveErrorValue,
      verticalNegativeErrorValue,
      horizontalPositiveErrorValue,
      horizontalNegativeErrorValue,
      capLength,
      onRenderDetailsUpdate
    ];
    return Object.hashAll(values);
  }
}

/// Represents the error values of error bar.
class ChartErrorValues {
  /// Creates an instance of chart error values.
  ChartErrorValues(
      {this.errorX, this.errorY, this.customNegativeX, this.customNegativeY});

  /// Specifies the value of x.
  num? errorX;

  /// Specifies the value of y.
  num? errorY;

  /// Specifies the value of x in custom type error bar.
  num? customNegativeX;

  /// Specifies the value of y in custom type error bar.
  num? customNegativeY;
}

/// Holds the values related to standard error and standard deviation error bars.
class ErrorBarMean {
  /// Creates an instance of ErrorBarMean.
  ErrorBarMean(
      {this.verticalSquareRoot,
      this.horizontalSquareRoot,
      this.verticalMean,
      this.horizontalMean});

  /// Mean's required square root value of all data points in y direction.
  final num? verticalSquareRoot;

  /// Mean's required square root value of all data points in x direction.
  final num? horizontalSquareRoot;

  /// Required mean value of all data points in y direction.
  final num? verticalMean;

  /// Required mean value of all data points in x direction.
  final num? horizontalMean;
}
