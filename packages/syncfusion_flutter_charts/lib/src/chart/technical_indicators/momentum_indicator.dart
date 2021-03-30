part of charts;

/// Renders the momentum indicator.
///
/// This class renders the momentum indicator, it also has a centerline. The [centerLineColor] and [centerLineWidth]
/// property is used to define centerline.
///
/// Provides the options for visibility, centerline color, centerline width, and period values to customize the appearance.
///
class MomentumIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of MomentumIndicator class.
  MomentumIndicator({
    bool? isVisible,
    String? xAxisName,
    String? yAxisName,
    String? seriesName,
    List<double>? dashArray,
    double? animationDuration,
    List<T>? dataSource,
    ChartValueMapper<T, D>? xValueMapper,
    ChartValueMapper<T, num>? highValueMapper,
    ChartValueMapper<T, num>? lowValueMapper,
    ChartValueMapper<T, num>? openValueMapper,
    ChartValueMapper<T, num>? closeValueMapper,
    String? name,
    bool? isVisibleInLegend,
    LegendIconType? legendIconType,
    String? legendItemText,
    Color? signalLineColor,
    double? signalLineWidth,
    int? period,
    this.centerLineColor = Colors.red,
    this.centerLineWidth = 2,
  }) : super(
            isVisible: isVisible,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            seriesName: seriesName,
            dashArray: dashArray,
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            highValueMapper: highValueMapper,
            lowValueMapper: lowValueMapper,
            openValueMapper: openValueMapper,
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period);

  /// Center line color of the momentum indicator
  ///
  /// Defaults to `Colors.red`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                        MomentumIndicator<dynamic, dynamic>(
  ///                        centerLineColor: Color.red,
  ///                         ),]
  ///         ));
  /// }
  /// ```
  final Color centerLineColor;

  /// Center line width of the momentum indicator
  ///
  /// Defaults to `2`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                        MomentumIndicator<dynamic, dynamic>(
  ///                        centerLineWidth: 3,
  ///                         ),]
  ///         ));
  /// }
  /// ```
  final double centerLineWidth;

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      MomentumIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    // Decides the type of renderer class to be used
    final bool isLine = true;
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'Momentum',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'CenterLine',
        indicator.centerLineColor, indicator.centerLineWidth, chart, isLine);
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(MomentumIndicator<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> centerLineCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints!;
    final List<dynamic> centerXValues = <dynamic>[];
    final List<dynamic> xValues = <dynamic>[];
    num value;

    if (validData.isNotEmpty) {
      final CartesianSeriesRenderer signalSeriesRenderer =
          technicalIndicatorsRenderer._targetSeriesRenderers[0];
      final CartesianSeriesRenderer upperSeriesRenderer =
          technicalIndicatorsRenderer._targetSeriesRenderers[1];
      final int length = indicator.period;
      if (validData.length >= indicator.period && indicator.period > 0) {
        for (int i = 0; i < validData.length; i++) {
          centerLineCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x,
              100,
              validData[i],
              upperSeriesRenderer,
              centerLineCollection.length));
          centerXValues.add(validData[i].x);
          if (!(i < length)) {
            value = (validData[i].close ?? 0) /
                (validData[i - length].close ?? 1) *
                100;
            signalCollection.add(technicalIndicatorsRenderer._getDataPoint(
                validData[i].x,
                value,
                validData[i],
                signalSeriesRenderer,
                signalCollection.length));
            xValues.add(validData[i].x);
          }
        }
      }
      technicalIndicatorsRenderer._renderPoints = signalCollection;
      technicalIndicatorsRenderer._setSeriesRange(signalCollection, indicator,
          xValues, technicalIndicatorsRenderer._targetSeriesRenderers[0]);
      technicalIndicatorsRenderer._setSeriesRange(
          centerLineCollection,
          indicator,
          centerXValues,
          technicalIndicatorsRenderer._targetSeriesRenderers[1]);
    }
  }
}
