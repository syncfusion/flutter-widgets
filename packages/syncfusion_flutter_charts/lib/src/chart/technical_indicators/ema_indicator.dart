part of charts;

///Renders EMA indicator
///
///An EMA indicator is a simple, arithmetic moving average that is calculated by adding the closing price for the number of time periods and dividing the total value by the number of periods.
///
/// It also has the [valueField] property. Based on this property Indicator will be rendered
///
class EmaIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of EmaIndicator class.
  EmaIndicator({
    bool isVisible,
    String xAxisName,
    String yAxisName,
    String seriesName,
    List<double> dashArray,
    double animationDuration,
    List<T> dataSource,
    ChartValueMapper<T, D> xValueMapper,
    ChartValueMapper<T, num> highValueMapper,
    ChartValueMapper<T, num> lowValueMapper,
    ChartValueMapper<T, num> openValueMapper,
    ChartValueMapper<T, num> closeValueMapper,
    String name,
    bool isVisibleInLegend,
    LegendIconType legendIconType,
    String legendItemText,
    Color signalLineColor,
    double signalLineWidth,
    int period,
    String valueField,
  })  : valueField = (valueField ?? 'close').toLowerCase(),
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
            openValueMapper: openValueMapper,
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period);

  ///ValueField property for ema indicator.
  ///
  ///Based on the valueField property, the moving average is calculated and the indicator is rendered.
  ///
  ///Defaults to `close`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            EmaIndicator<dynamic, dynamic>(
  ///                valueField : 'high',
  ///              ),
  ///        ));
  ///}
  ///```
  final String valueField;

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      TechnicalIndicators<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'EMA',
        indicator.signalLineColor, indicator.signalLineWidth, chart);
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints;
    if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator.period > 0) {
      _calculateEMAPoints(indicator, validData, technicalIndicatorsRenderer);
    }
  }

  /// To calculate the rendering points of the EMA indicator
  void _calculateEMAPoints(
      EmaIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final CartesianSeriesRenderer signalSeriesRenderer =
        technicalIndicatorsRenderer._targetSeriesRenderers[0];
    final num period = indicator.period;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    if (validData.length >= period && period > 0) {
      num sum = 0;
      num average = 0;
      final num k = 2 / (period + 1);
      for (int i = 0; i < period; i++) {
        sum += technicalIndicatorsRenderer._getFieldValue(
            validData, i, valueField);
      }
      average = sum / period;
      point = technicalIndicatorsRenderer._getDataPoint(validData[period - 1].x,
          average, validData[period - 1], signalSeriesRenderer, points.length);
      points.add(point);
      xValues.add(point.x);
      num index = period;
      while (index < validData.length) {
        if (validData[index].isVisible ||
            validData[index].isGap == true ||
            validData[index].isDrop == true) {
          final num prevAverage = points[index - period].y;
          final num yValue = (technicalIndicatorsRenderer._getFieldValue(
                          validData, index, valueField) -
                      prevAverage) *
                  k +
              prevAverage;
          point = technicalIndicatorsRenderer._getDataPoint(validData[index].x,
              yValue, validData[index], signalSeriesRenderer, points.length);
          points.add(point);
          xValues.add(point.x);
        }
        index++;
      }
    }
    technicalIndicatorsRenderer._renderPoints = points;
    technicalIndicatorsRenderer._setSeriesRange(points, indicator, xValues);
  }
}
