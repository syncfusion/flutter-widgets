import 'package:flutter/material.dart';
import '../../../charts.dart';

/// This class has the properties of the histogram series.
///
/// To render a histogram chart, create an instance of [HistogramSeries], and add it to the series collection property of [SfCartesianChart].
/// The histogram series is a rectangular histogram with heights or lengths proportional to the values that they represent. It has the spacing
/// property to separate the histogram.
///
/// Provide the options of color, opacity, border color, and border width to customize the appearance.
///
class HistogramSeries<T, D> extends XyDataSeries<T, D> {
  /// Creating an argument constructor of HistogramSeries class.
  HistogramSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      this.isTrackVisible = false,
      String? xAxisName,
      String? yAxisName,
      String? name,
      Color? color,
      double? width,
      this.spacing = 0,
      MarkerSettings? markerSettings,
      List<Trendline>? trendlines,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      this.borderRadius = BorderRadius.zero,
      bool? enableTooltip,
      double? animationDuration,
      this.trackColor = Colors.grey,
      this.trackBorderColor = Colors.transparent,
      this.trackBorderWidth = 1,
      this.trackPadding = 0,
      Color? borderColor,
      double? borderWidth,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      double? opacity,
      double? animationDelay,
      List<double>? dashArray,
      this.binInterval,
      this.showNormalDistributionCurve = false,
      this.curveColor = Colors.blue,
      this.curveWidth = 2,
      this.curveDashArray,
      SeriesRendererCreatedCallback? onRendererCreated,
      ChartPointInteractionCallback? onPointTap,
      ChartPointInteractionCallback? onPointDoubleTap,
      ChartPointInteractionCallback? onPointLongPress,
      CartesianShaderCallback? onCreateShader})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 0.95,
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
            onCreateShader: onCreateShader,
            dashArray: dashArray);

  /// Interval value by which the data points are grouped and rendered as bars, in histogram series.
  ///
  /// For example, if the [binInterval] is set to 20, the x-axis will split with 20 as the interval.
  /// The first bar in the histogram represents the count of values lying between 0 to 20
  /// in the provided data and the second bar will represent 20 to 40.
  ///
  /// If no value is specified for this property, then the interval will be calculated
  /// automatically based on the data points count and value.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         binInterval: 4
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double? binInterval;

  /// Renders a spline curve for the normal distribution, calculated based on the series data points.
  ///
  /// This spline curve type can be changed using the `splineType` property.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         showNormalDistributionCurve: true
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final bool showNormalDistributionCurve;

  /// Color of the normal distribution spline curve.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveColor: Colors.red
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final Color curveColor;

  /// Width of the normal distribution spline curve.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveWidth: 4
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double curveWidth;

  /// Dash array of the normal distribution spline curve.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         curveDashArray: [2, 3]
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final List<double>? curveDashArray;

  /// Color of the track.
  ///
  /// Defaults to `Colors.grey`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
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
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
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
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackBorderColor: Colors.red,
  ///         trackBorderWidth: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackBorderWidth;

  /// Padding of the track.
  ///
  /// By default, track will be rendered based on the bar’s available width and spacing.
  /// If you wish to change the track width, you can use this property.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///         trackPadding: 2
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double trackPadding;

  /// Spacing between the bars in histogram series.
  ///
  /// The value ranges from 0 to 1. 1 represents 100% and 0 represents 0% of the available space.
  ///
  /// Spacing also affects the width of the bar. For example, setting 20% spacing
  /// and 100% width renders the bar with 80% of total width.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         spacing: 0.5,
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final double spacing;

  /// Renders the bar in histogram series with track.
  ///
  /// Track is a rectangular bar rendered from the start to the end of the axis.
  /// Bars in the histogram will be rendered above the track.
  ///
  /// Defaults to `false`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         isTrackVisible: true,
  ///       ),
  ///     ],
  ///    );
  /// }
  /// ```
  final bool isTrackVisible;

  /// Customizes the corners of the bars in histogram series.
  ///
  /// Each corner can be customized individually or can be customized together, by specifying a single value.
  ///
  /// Defaults to `Radius.zero`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return SfCartesianChart(
  ///     series: <HistogramSeries<SalesData, num>>[
  ///       HistogramSeries<SalesData, num>(
  ///         borderRadius: BorderRadius.circular(5),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final BorderRadius borderRadius;

  /// Create the histogram series renderer.
  HistogramSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HistogramSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer!(series) as HistogramSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HistogramSeriesRenderer();
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

    return other is HistogramSeries &&
        other.key == key &&
        other.onCreateRenderer == onCreateRenderer &&
        other.dataSource == dataSource &&
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
        other.trackColor == trackColor &&
        other.trackBorderColor == trackBorderColor &&
        other.trackBorderWidth == trackBorderWidth &&
        other.trackPadding == trackPadding &&
        other.spacing == spacing &&
        other.binInterval == binInterval &&
        other.showNormalDistributionCurve == showNormalDistributionCurve &&
        other.curveColor == curveColor &&
        other.curveWidth == curveWidth &&
        other.curveDashArray == curveDashArray &&
        other.borderRadius == borderRadius &&
        other.isTrackVisible == isTrackVisible &&
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
      trackColor,
      trackBorderColor,
      trackBorderWidth,
      trackPadding,
      spacing,
      borderRadius,
      binInterval,
      showNormalDistributionCurve,
      curveColor,
      curveWidth,
      curveDashArray,
      isTrackVisible,
      onRendererCreated,
      onPointTap,
      onPointDoubleTap,
      onPointLongPress
    ];
    return Object.hashAll(values);
  }
}

/// Represents the histogram values.
class HistogramValues {
  /// Creates an instance of histogram values.
  HistogramValues(
      {this.sDValue, this.mean, this.binWidth, this.yValues, this.minValue});

  /// Specifies the value of SD.
  num? sDValue;

  /// Specifies the value of mean.
  num? mean;

  /// Specifies the value of bin width.
  num? binWidth;

  /// Specifies the minimum value.
  num? minValue;

  /// Specifies the list of y values.
  List<num>? yValues = <num>[];
}
