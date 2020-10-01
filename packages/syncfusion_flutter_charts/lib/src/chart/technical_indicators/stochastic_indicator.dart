part of charts;

///Renders stochastic indicator.
///
///The stochastic indicator  is used to measure the range and momentum of price movements. It contains kPeriod and dPeriod properties defining
///the ‘k’ percentage and ‘d’ percentage respectively.
///
/// In this indicator [upperLineColor], [lowerLineColor] and [periodLineColor] property are used to define the color for
/// the Stochastic indicator lines.
class StochasticIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of StochasticIndicator class.
  StochasticIndicator(
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
      ChartValueMapper<T, num> openValueMapper,
      ChartValueMapper<T, num> closeValueMapper,
      String name,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      Color signalLineColor,
      double signalLineWidth,
      int period,
      bool showZones,
      double overbought,
      double oversold,
      final Color upperLineColor,
      final double upperLineWidth,
      final Color lowerLineColor,
      final double lowerLineWidth,
      final Color periodLineColor,
      final double periodLineWidth,
      num kPeriod,
      num dPeriod})
      : showZones = showZones ?? true,
        overbought = overbought ?? 80,
        oversold = oversold ?? 20,
        kPeriod = kPeriod ?? 3,
        dPeriod = dPeriod ?? 5,
        upperLineColor = upperLineColor ?? Colors.red,
        upperLineWidth = upperLineWidth ?? 2,
        lowerLineColor = lowerLineColor ?? Colors.green,
        lowerLineWidth = lowerLineWidth ?? 2,
        periodLineColor = periodLineColor ?? Colors.yellow,
        periodLineWidth = periodLineWidth ?? 2,
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

  ///ShowZones boolean value for Stochastic indicator
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                showZones : false,
  ///              ),
  ///        ));
  ///}
  ///```
  final bool showZones;

  ///Overbought value for stochastic indicator
  ///
  ///Defaults to `80`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                overbought : 50,
  ///              ),
  ///        ));
  ///}
  ///```
  final double overbought;

  ///Oversold value for Stochastic Indicator.
  ///
  ///Defaults to `20`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                oversold : 30,
  ///              ),
  ///        ));
  ///}
  ///```
  final double oversold;

  ///Color of the upperLine for Stochastic Indicator.
  ///
  ///Defaults to `red`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 upperLineColor : Colors.greenAccent,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color upperLineColor;

  ///Width of the upperLine for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 upperLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double upperLineWidth;

  ///Color of the lowerLine for Stochastic Indicator.
  ///
  ///Defaults to `green`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 lowerLineColor : Colors.blue,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color lowerLineColor;

  ///Width of lowerline for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 lowerLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double lowerLineWidth;

  ///Color of the periodLine for Stochastic Indicator.
  ///
  ///Defaults to `yellow`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 periodLineColor :Colors.orange,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color periodLineColor;

  ///Width of the periodLIne for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 periodLineWidth :5.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double periodLineWidth;

  ///Value of Kperiod  in Stochastic Indicator.
  ///
  ///Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 kPeriod:4,
  ///              ),
  ///        ));
  ///}
  ///```
  final num kPeriod;

  ///Value of dperiod  in Stochastic Indicator.
  ///
  ///Defaults to `5`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 dPeriod:4,
  ///              ),
  ///        ));
  ///}
  ///```
  final num dPeriod;

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      StochasticIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'Stocastic',
        indicator.signalLineColor, indicator.signalLineWidth, chart);
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'PeriodLine',
        indicator.periodLineColor, indicator.periodLineWidth, chart);
    if (showZones) {
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'UpperLine',
          indicator.upperLineColor, indicator.upperLineWidth, chart);
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'LowerLine',
          indicator.lowerLineColor, indicator.lowerLineWidth, chart);
    }
  }

  /// To initialise data source of technical indicators
// ignore:unused_element
  void _initDataSource(StochasticIndicator<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> lowerCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> upperCollection =
        <CartesianChartPoint<dynamic>>[];
    List<CartesianChartPoint<dynamic>> source =
        <CartesianChartPoint<dynamic>>[];
    List<CartesianChartPoint<dynamic>> periodCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints;
    final List<dynamic> xValues = <dynamic>[];
    List<dynamic> collection, signalX, periodX;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      if (indicator.showZones) {
        for (int i = 0; i < validData.length; i++) {
          upperCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x,
              indicator.overbought,
              validData[i],
              technicalIndicatorsRenderer._targetSeriesRenderers[2],
              upperCollection.length));
          lowerCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x,
              indicator.oversold,
              validData[i],
              technicalIndicatorsRenderer._targetSeriesRenderers[3],
              lowerCollection.length));
          xValues.add(validData[i].x);
        }
      }
      source = _calculatePeriod(
          indicator.period,
          indicator.kPeriod,
          validData,
          technicalIndicatorsRenderer._targetSeriesRenderers[1],
          technicalIndicatorsRenderer);
      collection = _stochasticCalculation(
          indicator.period,
          indicator.kPeriod,
          source,
          technicalIndicatorsRenderer._targetSeriesRenderers[1],
          technicalIndicatorsRenderer);
      periodCollection = collection[0];
      periodX = collection[1];
      collection = _stochasticCalculation(
          indicator.period + indicator.kPeriod - 1,
          indicator.dPeriod,
          source,
          technicalIndicatorsRenderer._targetSeriesRenderers[0],
          technicalIndicatorsRenderer);
      signalCollection = collection[0];
      signalX = collection[1];
    }
    technicalIndicatorsRenderer._renderPoints = signalCollection;
    technicalIndicatorsRenderer._setSeriesRange(signalCollection, indicator,
        signalX, technicalIndicatorsRenderer._targetSeriesRenderers[0]);
    technicalIndicatorsRenderer._setSeriesRange(periodCollection, indicator,
        periodX, technicalIndicatorsRenderer._targetSeriesRenderers[1]);
    if (indicator.showZones) {
      technicalIndicatorsRenderer._setSeriesRange(upperCollection, indicator,
          xValues, technicalIndicatorsRenderer._targetSeriesRenderers[2]);
      technicalIndicatorsRenderer._setSeriesRange(lowerCollection, indicator,
          xValues, technicalIndicatorsRenderer._targetSeriesRenderers[3]);
    }
  }

  /// To calculate the values of the stochastic indicator
  List<dynamic> _stochasticCalculation(
      num period,
      num kPeriod,
      List<CartesianChartPoint<dynamic>> data,
      CartesianSeriesRenderer sourceSeriesRenderer,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> pointCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    if (data.length >= period + kPeriod && kPeriod > 0) {
      final num count = period + (kPeriod - 1);
      final List<num> temp = <num>[];
      final List<num> values = <num>[];
      for (int i = 0; i < data.length; i++) {
        final num value = data[i].y;
        temp.add(value);
      }
      num length = temp.length;
      while (length >= count) {
        num sum = 0;
        for (int i = period - 1; i < (period + kPeriod - 1); i++) {
          sum = sum + temp[i];
        }
        sum = sum / kPeriod;
        final String _sum = sum.toStringAsFixed(2);
        values.add(double.parse(_sum));
        temp.removeRange(0, 1);
        length = temp.length;
      }
      final num len = count - 1;
      for (int i = 0; i < data.length; i++) {
        if (!(i < len)) {
          pointCollection.add(technicalIndicatorsRenderer._getDataPoint(
              data[i].x,
              values[i - len],
              data[i],
              sourceSeriesRenderer,
              pointCollection.length));
          xValues.add(data[i].x);
          data[i].y = values[i - len];
        }
      }
    }

    return <dynamic>[pointCollection, xValues];
  }

  /// To return list of stochastic indicator points
  List<CartesianChartPoint<dynamic>> _calculatePeriod(
      num period,
      num kPeriod,
      List<CartesianChartPoint<dynamic>> data,
      CartesianSeriesRenderer seriesRenderer,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<num> lowValue = List<num>(data.length);
    final List<num> highValue = List<num>(data.length);
    final List<num> closeValue = List<num>(data.length);
    final List<CartesianChartPoint<dynamic>> modifiedSource =
        <CartesianChartPoint<dynamic>>[];

    for (int j = 0; j < data.length; j++) {
      lowValue[j] = data[j].low ?? 0;
      highValue[j] = data[j].high ?? 0;
      closeValue[j] = data[j].close ?? 0;
    }
    if (data.length > period) {
      final List<num> mins = <num>[];
      final List<num> maxs = <num>[];
      for (int i = 0; i < period - 1; ++i) {
        maxs.add(0);
        mins.add(0);
        modifiedSource.add(technicalIndicatorsRenderer._getDataPoint(data[i].x,
            data[i].close, data[i], seriesRenderer, modifiedSource.length));
      }
      num min, max;
      for (int i = period - 1; i < data.length; ++i) {
        for (int j = 0; j < period; ++j) {
          min ??= lowValue[i - j];
          max ??= highValue[i - j];
          min = math.min(min, lowValue[i - j]);
          max = math.max(max, highValue[i - j]);
        }
        maxs.add(max);
        mins.add(min);
        min = null;
        max = null;
      }

      for (int i = period - 1; i < data.length; ++i) {
        num top = 0;
        num bottom = 0;
        top += closeValue[i] - mins[i];
        bottom += maxs[i] - mins[i];
        modifiedSource.add(technicalIndicatorsRenderer._getDataPoint(
            data[i].x,
            (top / bottom) * 100,
            data[i],
            seriesRenderer,
            modifiedSource.length));
      }
    }
    return modifiedSource;
  }
}
