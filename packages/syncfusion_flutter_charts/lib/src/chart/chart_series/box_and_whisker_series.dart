import 'package:flutter/material.dart';
import '../../../charts.dart';

/// This class holds the properties of the box and whisker series.
///
/// To render a box and whisker chart, create an instance of [BoxAndWhiskerSeries], and add it to the `series` collection property of [SfCartesianChart].
/// The box and whisker chart represents the hollow rectangle with the lower quartile, upper quartile, maximum and minimum value in the given data.
///
/// Provides options for color, opacity, border color, and border width
/// to customize the appearance.
///
@immutable
class BoxAndWhiskerSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of BoxAndWhiskerSeries class.
  BoxAndWhiskerSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, dynamic> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      this.spacing = 0,
      MarkerSettings? markerSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      bool? enableTooltip,
      double? animationDuration,
      Color? borderColor,
      double? borderWidth,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      List<double>? dashArray,
      double? opacity,
      double? animationDelay,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader,
      List<Trendline>? trendlines,
      this.boxPlotMode = BoxPlotMode.normal,
      this.showMean = true})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            onPointTap: onPointTap,
            onPointDoubleTap: onPointDoubleTap,
            onPointLongPress: onPointLongPress,
            dashArray: dashArray,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
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
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor ?? Colors.black,
            borderWidth: borderWidth ?? 1,
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
            trendlines: trendlines);

  /// To change the box plot rendering mode.
  ///
  /// The box plot series rendering mode can be changed by
  /// using [BoxPlotMode] property. The below values are applicable for this,
  ///
  /// * `BoxPlotMode.normal` - The quartile values are calculated by splitting the list and
  /// by getting the median values.
  /// * `BoxPlotMode.exclusive` - The quartile values are calculated by using the formula
  /// (N+1) * P (N count, P percentile), and their index value starts
  /// from 1 in the list.
  /// * `BoxPlotMode.inclusive` - The quartile values are calculated by using the formula
  /// (N−1) * P (N count, P percentile), and their index value starts
  /// from 0 in the list.
  ///
  /// Also refer [BoxPlotMode].
  ///
  /// Defaults to `BoxPlotMode.normal`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         boxPlotMode: BoxPlotMode.normal
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BoxPlotMode boxPlotMode;

  /// Indication for mean value in box plot.
  ///
  /// If [showMean] property value is set to true, a cross symbol will be
  /// displayed at the mean value, for each data point in box plot. Else,
  /// it will not be displayed.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         showMean: false
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showMean;

  /// Spacing between the box plots.
  ///
  /// The value ranges from 0 to 1, where 1 represents 100% and 0 represents 0%
  /// of the available space.
  ///
  /// Spacing affects the width of the box plots. For example, setting 20%
  /// spacing and 100% width renders the box plots with 80% of total width.
  ///
  /// Also refer [CartesianSeries.width].
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <BoxAndWhiskerSeries<SalesData, num>>[
  ///       BoxAndWhiskerSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Create the Box and Whisker series renderer.
  BoxAndWhiskerSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BoxAndWhiskerSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as BoxAndWhiskerSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BoxAndWhiskerSeriesRenderer();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BoxAndWhiskerSeries &&
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
        other.width == width &&
        other.markerSettings == markerSettings &&
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
        other.boxPlotMode == boxPlotMode &&
        other.showMean == showMean &&
        other.spacing == spacing &&
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
      width,
      markerSettings,
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
      boxPlotMode,
      showMean,
      spacing,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}

/// Represents the class for box plot quartile values.
class BoxPlotQuartileValues {
  /// Creates an instance of box plot quartile values.
  BoxPlotQuartileValues(
      {this.minimum,
      this.maximum,
      //ignore: unused_element, avoid_unused_constructor_parameters
      List<num>? outliers,
      this.upperQuartile,
      this.lowerQuartile,
      this.average,
      this.median,
      this.mean});

  /// Specifies the value of minimum.
  num? minimum;

  /// Specifies the value of maximum.
  num? maximum;

  /// Specifies the list of outliers.
  List<num>? outliers = <num>[];

  /// Specifies the value of the upper quartiles.
  double? upperQuartile;

  /// Specifies the value of lower quartiles.
  double? lowerQuartile;

  /// Specifies the value of average.
  num? average;

  /// Specifies the value of median.
  num? median;

  /// Specifies the mean value.
  num? mean;
}
