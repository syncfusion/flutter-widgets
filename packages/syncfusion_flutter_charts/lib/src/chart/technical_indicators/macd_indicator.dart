part of charts;

/// This class Holds the properties of the Macd Indicator.
///
/// The Macd indicator has [shortPeriod] and [longPeriod] for defining the motion of the indicator.
/// Also, you can draw Line, Histogram MACD or Both using the [macdType] property.
///
///  The [macdLineColor] property is used to define the color for the
/// MACD line and the [histogramNegativeColor] and [histogramPositiveColor] property is used to define the color for the MACD histogram.
///
/// Provides the options of macd type, name, short Period, long period and macd line color is used to customize the appearance.
///
class MacdIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of MacdIndicator class.
  MacdIndicator(
      {bool isVisible,
      String xAxisName,
      String yAxisName,
      String seriesName,
      List<double> dashArray,
      double animationDuration,
      List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> closeValueMapper,
      String name,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      Color signalLineColor,
      double signalLineWidth,
      int period,
      int shortPeriod,
      int longPeriod,
      Color macdLineColor,
      double macdLineWidth,
      MacdType macdType,
      Color histogramPositiveColor,
      Color histogramNegativeColor})
      : shortPeriod = shortPeriod ?? 12,
        longPeriod = longPeriod ?? 26,
        macdLineColor = macdLineColor ?? Colors.orange,
        macdLineWidth = macdLineWidth ?? 2,
        macdType = macdType ?? MacdType.both,
        histogramPositiveColor = histogramPositiveColor ?? Colors.green,
        histogramNegativeColor = histogramNegativeColor ?? Colors.red,
        super(
            isVisible: isVisible,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            seriesName: seriesName,
            dashArray: dashArray,
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period);

  /// Short period value of the macd indicator.
  ///
  /// Defaults to `12`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             shortPeriod: 2,)]
  ///                  ));
  ///}
  /// ```
  ///
  final int shortPeriod;

  /// Long period value of the macd indicator.
  ///
  /// Defaults to `26`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             longPeriod: 31,)]
  ///                  ));
  ///}
  /// ```
  ///
  final int longPeriod;

  /// MacdLine color  of the macd indicator.
  ///
  /// Defaults to `Colors.orange`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdLineColor: Colors.orange,)]
  ///                  ));
  ///}
  /// ```
  ///
  final Color macdLineColor;

  /// MacdLine width  of the macd indicator.
  ///
  /// Defaults to `2`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdLineWidth: 2,)]
  ///                  ));
  ///}
  /// ```
  ///
  final double macdLineWidth;

  /// Macd type line of the macd indicator.
  ///
  /// Defaults to `MacdType.both`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdType: MacdType.both,)]
  ///                  ));
  ///}
  /// ```
  ///
  final MacdType macdType;

  /// Histogram Positive color  of the macd indicator.
  ///
  /// Defaults to `Colors.green`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             histogramPositiveColor: Colors.green,)]
  ///                  ));
  ///}
  /// ```
  ///
  final Color histogramPositiveColor;

  /// Histogram Negative color  of the macd indicator.
  ///
  /// Defaults to `Colors.red`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             histogramNegativeColor: Colors.red,)]
  ///                  ));
  ///}
  /// ```
  ///
  final Color histogramNegativeColor;

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      MacdIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'MACD',
        indicator.signalLineColor, indicator.signalLineWidth, chart);

    if (indicator.macdType == MacdType.line ||
        indicator.macdType == MacdType.both) {
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'MacdLine',
          indicator.macdLineColor, indicator.macdLineWidth, chart);
    }
    if (indicator.macdType == MacdType.histogram ||
        indicator.macdType == MacdType.both) {
      technicalIndicatorsRenderer._setSeriesProperties(
          indicator,
          'Histogram',
          indicator.histogramPositiveColor,
          indicator.signalLineWidth / 2,
          chart);
    }
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(MacdIndicator<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    final num fastPeriod = indicator.longPeriod;
    final num slowPeriod = indicator.shortPeriod;
    final num trigger = indicator.period;
    final num length = fastPeriod + trigger;
    List<CartesianChartPoint<dynamic>> macdCollection =
        <CartesianChartPoint<dynamic>>[];
    List<CartesianChartPoint<dynamic>> histogramCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints;
    final CartesianSeriesRenderer signalSeriesRenderer =
        technicalIndicatorsRenderer._targetSeriesRenderers[0];
    List<dynamic> signalX, histogramX, macdX, collection;
    CartesianSeriesRenderer histogramSeriesRenderer, macdLineSeriesRenderer;

    if (indicator.macdType == MacdType.histogram) {
      histogramSeriesRenderer =
          technicalIndicatorsRenderer._targetSeriesRenderers[1];
    } else {
      macdLineSeriesRenderer =
          technicalIndicatorsRenderer._targetSeriesRenderers[1];
      if (indicator.macdType == MacdType.both) {
        histogramSeriesRenderer =
            technicalIndicatorsRenderer._targetSeriesRenderers[2];
      }
    }

    if (validData.isNotEmpty &&
        length < validData.length &&
        slowPeriod <= fastPeriod &&
        slowPeriod > 0 &&
        indicator.period > 0 &&
        (length - 2) >= 0) {
      final List<num> shortEMA = _calculateEMAValues(
          slowPeriod, validData, 'close', technicalIndicatorsRenderer);
      final List<num> longEMA = _calculateEMAValues(
          fastPeriod, validData, 'close', technicalIndicatorsRenderer);
      final List<num> macdValues = _getMACDVales(indicator, shortEMA, longEMA);
      collection = _getMACDPoints(
          indicator,
          macdValues,
          validData,
          macdLineSeriesRenderer ?? signalSeriesRenderer,
          technicalIndicatorsRenderer);
      macdCollection = collection[0];
      macdX = collection[1];
      final List<num> signalEMA = _calculateEMAValues(
          trigger, macdCollection, 'y', technicalIndicatorsRenderer);
      collection = _getSignalPoints(indicator, signalEMA, validData,
          signalSeriesRenderer, technicalIndicatorsRenderer);
      signalCollection = collection[0];
      signalX = collection[1];
      if (histogramSeriesRenderer != null) {
        collection = _getHistogramPoints(indicator, macdValues, signalEMA,
            validData, histogramSeriesRenderer, technicalIndicatorsRenderer);
        histogramCollection = collection[0];
        histogramX = collection[1];
      }
    }
    technicalIndicatorsRenderer._renderPoints = signalCollection;
    technicalIndicatorsRenderer._setSeriesRange(signalCollection, indicator,
        signalX, technicalIndicatorsRenderer._targetSeriesRenderers[0]);
    if (histogramSeriesRenderer != null) {
      technicalIndicatorsRenderer._setSeriesRange(
          histogramCollection, indicator, histogramX, histogramSeriesRenderer);
    }
    if (macdLineSeriesRenderer != null) {
      technicalIndicatorsRenderer._setSeriesRange(
          macdCollection, indicator, macdX, macdLineSeriesRenderer);
    }
  }

  /// Calculates the EMA values for the given period
  List<num> _calculateEMAValues(
      num period,
      List<CartesianChartPoint<dynamic>> validData,
      String valueField,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    num sum = 0;
    num initialEMA = 0;
    final List<num> emaValues = <num>[];
    final num emaPercent = 2 / (period + 1);
    for (int i = 0; i < period; i++) {
      sum +=
          technicalIndicatorsRenderer._getFieldValue(validData, i, valueField);
    }
    initialEMA = sum / period;
    emaValues.add(initialEMA);
    num emaAvg = initialEMA;
    for (int j = period; j < validData.length; j++) {
      emaAvg = (technicalIndicatorsRenderer._getFieldValue(
                      validData, j, valueField) -
                  emaAvg) *
              emaPercent +
          emaAvg;
      emaValues.add(emaAvg);
    }
    return emaValues;
  }

  ///Defines the MACD Points
  List<dynamic> _getMACDPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> macdPoints,
      List<CartesianChartPoint<dynamic>> validData,
      CartesianSeriesRenderer seriesRenderer,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> macdCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    num dataMACDIndex = indicator.longPeriod - 1;
    num macdIndex = 0;
    while (dataMACDIndex < validData.length) {
      macdCollection.add(technicalIndicatorsRenderer._getDataPoint(
          validData[dataMACDIndex].x,
          macdPoints[macdIndex],
          validData[dataMACDIndex],
          seriesRenderer,
          macdCollection.length));
      xValues.add(validData[dataMACDIndex].x);
      dataMACDIndex++;
      macdIndex++;
    }
    return <dynamic>[macdCollection, xValues];
  }

  ///Calculates the signal points
  List<dynamic> _getSignalPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> signalEma,
      List<CartesianChartPoint<dynamic>> validData,
      CartesianSeriesRenderer seriesRenderer,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    num dataSignalIndex = indicator.longPeriod + indicator.period - 2;
    num signalIndex = 0;
    final List<dynamic> xValues = <dynamic>[];
    final List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    while (dataSignalIndex < validData.length) {
      signalCollection.add(technicalIndicatorsRenderer._getDataPoint(
          validData[dataSignalIndex].x,
          signalEma[signalIndex],
          validData[dataSignalIndex],
          seriesRenderer,
          signalCollection.length));
      xValues.add(validData[dataSignalIndex].x);
      dataSignalIndex++;
      signalIndex++;
    }
    return <dynamic>[signalCollection, xValues];
  }

  ///Calculates the MACD values
  List<num> _getMACDVales(MacdIndicator<dynamic, dynamic> indicator,
      List<num> shortEma, List<num> longEma) {
    final List<num> macdPoints = <num>[];
    final num diff = indicator.longPeriod - indicator.shortPeriod;
    for (int i = 0; i < longEma.length; i++) {
      macdPoints.add(shortEma[i + diff] - longEma[i]);
    }
    return macdPoints;
  }

  ///Calculates the Histogram Points
  List<dynamic> _getHistogramPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> macdPoints,
      List<num> signalEma,
      List<CartesianChartPoint<dynamic>> validData,
      CartesianSeriesRenderer seriesRenderer,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    num dataHistogramIndex = indicator.longPeriod + indicator.period - 2;
    num histogramIndex = 0;
    final List<CartesianChartPoint<dynamic>> histogramCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    while (dataHistogramIndex < validData.length) {
      histogramCollection.add(technicalIndicatorsRenderer._getDataPoint(
          validData[dataHistogramIndex].x,
          macdPoints[histogramIndex + (indicator.period - 1)] -
              signalEma[histogramIndex],
          validData[dataHistogramIndex],
          seriesRenderer,
          histogramCollection.length,
          indicator));
      xValues.add(validData[dataHistogramIndex].x);
      dataHistogramIndex++;
      histogramIndex++;
    }
    return <dynamic>[histogramCollection, xValues];
  }
}
