part of charts;

/// This class holds the properties of the Accumulation Distribution Indicator.
///
/// Accumulation distribution indicator is a volume-based indicator designed to measure the accumulative flow of money into and out of a security.
/// It requires [volumeValueMapper] property additionally with the data source to calculate the signal line.
///
/// It provides options for series visible, axis name, series name, animation duration, legend visibility,
/// signal line width, and color.
///

class AccumulationDistributionIndicator<T, D>
    extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of AccumulationDistributionIndicator class.
  AccumulationDistributionIndicator(
      {bool isVisible,
      String xAxisName,
      String yAxisName,
      String seriesName,
      List<double> dashArray,
      double animationDuration,
      List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> highValueMapper,
      ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, num> closeValueMapper,
      ChartValueMapper<T, num> volumeValueMapper,
      String name,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      Color signalLineColor,
      double signalLineWidth})
      : volumeValueMapper = (volumeValueMapper != null)
            ? ((int index) => volumeValueMapper(dataSource[index], index))
            : null,
        super(
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
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth);

  /// Volume of series.
  ///
  /// This value is mapped to the series.
  ///
  /// Defaults to `null`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return Container(
  ///       child: SfCartesianChart(
  ///       indicators: <TechnicalIndicators<Sample, dynamic>>[
  ///            AccumulationDistributionIndicator<Sample, dynamic>(
  ///                seriesName: 'Balloon',
  ///                animationDuration: 2000),
  ///          ],
  ///       series: <ChartSeries<Sample, dynamic>>[
  ///       HiloOpenCloseSeries<Sample, dynamic>(
  ///               volumeValueMapper: (Sample sales, _) => sales.volume,
  ///               name: 'Balloon'
  ///         )],
  ///     ));
  /// }
  ///```
  ///
  final ChartIndexedValueMapper<num> volumeValueMapper;

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      TechnicalIndicators<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'AD',
        indicator.signalLineColor, indicator.signalLineWidth, chart);
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints;
    if (validData.isNotEmpty) {
      _calculateADPoints(indicator, validData, technicalIndicatorsRenderer);
    }
  }

  /// To calculate the rendering points of the accumulation distribution indicator
  void _calculateADPoints(
      AccumulationDistributionIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    final CartesianSeriesRenderer signalSeriesRenderer =
        technicalIndicatorsRenderer._targetSeriesRenderers[0];
    num sum = 0;
    num i = 0;
    num value = 0;
    num high = 0;
    num low = 0;
    num close = 0;
    for (i = 0; i < validData.length; i++) {
      high = validData[i].high ?? 0;
      low = validData[i].low ?? 0;
      close = validData[i].close ?? 0;
      value = ((close - low) - (high - close)) / (high - low);
      sum = sum + value * validData[i].volume;
      point = technicalIndicatorsRenderer._getDataPoint(validData[i].x, sum,
          validData[i], signalSeriesRenderer, points.length);
      points.add(point);
      xValues.add(point.x);
    }
    technicalIndicatorsRenderer._renderPoints = points;
    technicalIndicatorsRenderer._setSeriesRange(points, indicator, xValues);
  }
}
