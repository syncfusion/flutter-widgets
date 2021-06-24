part of charts;

///Renders stochastic indicator.
///
///The stochastic indicator  is used to measure the range and momentum of price movements. It contains kPeriod and dPeriod properties defining
///the ‘k’ percentage and ‘d’ percentage respectively.
///
/// In this indicator [upperLineColor], [lowerLineColor] and [periodLineColor] property are used to define the color for
/// the Stochastic indicator lines.
@immutable
class StochasticIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of StochasticIndicator class.
  StochasticIndicator(
      {bool? isVisible,
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
      this.showZones = true,
      this.overbought = 80,
      this.oversold = 20,
      this.upperLineColor = Colors.red,
      this.upperLineWidth = 2,
      this.lowerLineColor = Colors.green,
      this.lowerLineWidth = 2,
      this.periodLineColor = Colors.yellow,
      this.periodLineWidth = 2,
      this.kPeriod = 3,
      this.dPeriod = 5,
      ChartIndicatorRenderCallback? onRenderDetailsUpdate})
      : super(
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
            period: period,
            onRenderDetailsUpdate: onRenderDetailsUpdate);

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is StochasticIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.highValueMapper == highValueMapper &&
        other.lowValueMapper == lowValueMapper &&
        other.openValueMapper == openValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth &&
        other.showZones == showZones &&
        other.overbought == overbought &&
        other.oversold == oversold &&
        other.upperLineColor == upperLineColor &&
        other.upperLineWidth == upperLineWidth &&
        other.lowerLineColor == lowerLineColor &&
        other.lowerLineWidth == lowerLineWidth &&
        other.periodLineColor == periodLineColor &&
        other.periodLineWidth == periodLineWidth &&
        other.kPeriod == kPeriod &&
        other.dPeriod == dPeriod;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      isVisible,
      xAxisName,
      yAxisName,
      seriesName,
      dashArray,
      animationDuration,
      dataSource,
      xValueMapper,
      highValueMapper,
      lowValueMapper,
      openValueMapper,
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      period,
      showZones,
      overbought,
      oversold,
      upperLineColor,
      upperLineWidth,
      lowerLineColor,
      lowerLineWidth,
      periodLineColor,
      periodLineWidth,
      kPeriod,
      dPeriod
    ];
    return hashList(values);
  }

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      StochasticIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
  }

  /// To initialise data source of technical indicators
// ignore:unused_element
  void _initDataSource(
    StochasticIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        source = <CartesianChartPoint<dynamic>>[],
        periodCollection = <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> lowerCollection =
            <CartesianChartPoint<dynamic>>[],
        upperCollection = <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints!;
    final List<dynamic> xValues = <dynamic>[];
    late List<dynamic> collection, signalX, periodX;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      if (indicator.showZones) {
        for (int i = 0; i < validData.length; i++) {
          upperCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x,
              indicator.overbought,
              validData[i],
              upperCollection.length));
          lowerCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x,
              indicator.oversold,
              validData[i],
              lowerCollection.length));
          xValues.add(validData[i].x);
        }
      }
      source = _calculatePeriod(indicator.period, indicator.kPeriod.toInt(),
          validData, technicalIndicatorsRenderer);
      collection = _stochasticCalculation(indicator.period,
          indicator.kPeriod.toInt(), source, technicalIndicatorsRenderer);
      periodCollection = collection[0];
      periodX = collection[1];
      collection = _stochasticCalculation(
          (indicator.period + indicator.kPeriod - 1).toInt(),
          indicator.dPeriod.toInt(),
          source,
          technicalIndicatorsRenderer);
      signalCollection = collection[0];
      signalX = collection[1];
    }
    technicalIndicatorsRenderer._renderPoints = signalCollection;
    technicalIndicatorsRenderer._stochasticperiod = periodCollection;
    // Decides the type of renderer class to be used
    const bool isLine = true;
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'Stocastic',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer._setSeriesProperties(indicator, 'PeriodLine',
        indicator.periodLineColor, indicator.periodLineWidth, chart, isLine);
    if (showZones) {
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'UpperLine',
          indicator.upperLineColor, indicator.upperLineWidth, chart, isLine);
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'LowerLine',
          indicator.lowerLineColor, indicator.lowerLineWidth, chart, isLine);
    }
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
      int period,
      int kPeriod,
      List<CartesianChartPoint<dynamic>> data,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> pointCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    if (data.length >= period + kPeriod && kPeriod > 0) {
      final int count = period + (kPeriod - 1);
      final List<num> temp = <num>[], values = <num>[];
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
      final int len = count - 1;
      for (int i = 0; i < data.length; i++) {
        if (!(i < len)) {
          pointCollection.add(technicalIndicatorsRenderer._getDataPoint(
              data[i].x, values[i - len], data[i], pointCollection.length));
          xValues.add(data[i].x);
          data[i].y = values[i - len];
        }
      }
    }

    return <dynamic>[pointCollection, xValues];
  }

  /// To return list of stochastic indicator points
  List<CartesianChartPoint<dynamic>> _calculatePeriod(
      int period,
      int kPeriod,
      List<CartesianChartPoint<dynamic>> data,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    // This has been null before
    final List<num> lowValue = List<num>.filled(data.length, -1);
    final List<num> highValue = List<num>.filled(data.length, -1);
    final List<num> closeValue = List<num>.filled(data.length, -1);
    final List<CartesianChartPoint<dynamic>> modifiedSource =
        <CartesianChartPoint<dynamic>>[];

    for (int j = 0; j < data.length; j++) {
      lowValue[j] = data[j].low ?? 0;
      highValue[j] = data[j].high ?? 0;
      closeValue[j] = data[j].close ?? 0;
    }
    if (data.length > period) {
      final List<num> mins = <num>[], maxs = <num>[];
      for (int i = 0; i < period - 1; ++i) {
        maxs.add(0);
        mins.add(0);
        modifiedSource.add(technicalIndicatorsRenderer._getDataPoint(
            data[i].x, data[i].close, data[i], modifiedSource.length));
      }
      num? min, max;
      for (int i = period - 1; i < data.length; ++i) {
        for (int j = 0; j < period; ++j) {
          min ??= lowValue[i - j];
          max ??= highValue[i - j];
          min = math.min(min, lowValue[i - j]);
          max = math.max(max, highValue[i - j]);
        }
        maxs.add(max!);
        mins.add(min!);
        min = null;
        max = null;
      }

      for (int i = period - 1; i < data.length; ++i) {
        num top = 0, bottom = 0;
        top += closeValue[i] - mins[i];
        bottom += maxs[i] - mins[i];
        modifiedSource.add(technicalIndicatorsRenderer._getDataPoint(
            data[i].x, (top / bottom) * 100, data[i], modifiedSource.length));
      }
    }
    return modifiedSource;
  }
}
