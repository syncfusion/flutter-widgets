part of charts;

///Renders relative strength index (RSI) indicator.
///
///The relative strength index (RSI) is a momentum indicator that measures the magnitude of recent price
/// changes to evaluate [overbought] or [oversold] conditions.
///
///The RSI indicator has additional two lines other than the signal line.They indicate the [overbought] and [oversold] region.
///
///The [upperLineColor] property is used to define the color for the line that indicates [overbought] region, and
///the [lowerLineColor] property is used to define the color for the line that indicates [oversold] region.
@immutable
class RsiIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of RsiIndicator class.
  RsiIndicator(
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
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period,
            onRenderDetailsUpdate: onRenderDetailsUpdate);

  ///ShowZones boolean value for RSI indicator
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                showZones : false,
  ///              ),
  ///        ));
  ///}
  ///```
  final bool showZones;

  ///Overbought value for RSI indicator.
  ///
  ///Defaults to `80`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                overbought : 50,
  ///              ),
  ///        ));
  ///}
  ///```
  final double overbought;

  ///Oversold value for RSI indicator.
  ///
  ///Defaults to `20`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                oversold : 30,
  ///              ),
  ///        ));
  ///}
  ///```
  final double oversold;

  ///Color of the upperLine for RSI indicator.
  ///
  ///Defaults to `red`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 upperLineColor : Colors.greenAccent,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color upperLineColor;

  ///Width of the upperLine for RSI indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 upperLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double upperLineWidth;

  ///Color of the lowerLine for RSI indicator.
  ///
  ///Defaults to `green`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 lowerLineColor : Colors.blue,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color lowerLineColor;

  ///Width of the upperLine for RSI indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 lowerLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double lowerLineWidth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is RsiIndicator &&
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
        other.lowerLineWidth == lowerLineWidth;
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
      lowerLineWidth
    ];
    return hashList(values);
  }

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      RsiIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(
    RsiIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        lowerCollection = <CartesianChartPoint<dynamic>>[],
        upperCollection = <CartesianChartPoint<dynamic>>[],
        validData = technicalIndicatorsRenderer._dataPoints!;

    final List<dynamic> xValues = <dynamic>[], signalXValues = <dynamic>[];

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
      num prevClose = validData[0].close ?? 0, gain = 0, loss = 0;
      for (int i = 1; i <= indicator.period; i++) {
        final num close = validData[i].close ?? 0.0;
        if (close > prevClose) {
          gain += close - prevClose;
        } else {
          loss += prevClose - close;
        }
        prevClose = close;
      }
      gain = gain / indicator.period;
      loss = loss / indicator.period;

      signalCollection.add(technicalIndicatorsRenderer._getDataPoint(
          validData[indicator.period].x,
          100 - (100 / (1 + (gain / loss))),
          validData[indicator.period],
          signalCollection.length));
      signalXValues.add(validData[indicator.period].x);

      for (int j = indicator.period + 1; j < validData.length; j++) {
        if (!validData[j].isGap && !validData[j].isDrop) {
          final num close = validData[j].close;
          if (close > prevClose) {
            gain = (gain * (indicator.period - 1) + (close - prevClose)) /
                indicator.period;
            loss = (loss * (indicator.period - 1)) / indicator.period;
          } else if (close < prevClose) {
            loss = (loss * (indicator.period - 1) + (prevClose - close)) /
                indicator.period;
            gain = (gain * (indicator.period - 1)) / indicator.period;
          }
          prevClose = close;
          signalCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[j].x,
              100 - (100 / (1 + (gain / loss))),
              validData[j],
              signalCollection.length));
          signalXValues.add(validData[j].x);
        }
      }
    }
    technicalIndicatorsRenderer._renderPoints = signalCollection;
    // Decides the type of renderer class to be used
    const bool isLine = true;
    // final CartesianSeriesRenderer signalSeriesRenderer =
    //     technicalIndicatorsRenderer._targetSeriesRenderers[0];
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'RSI',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    if (indicator.showZones == true) {
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'UpperLine',
          indicator.upperLineColor, indicator.upperLineWidth, chart, isLine);
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'LowerLine',
          indicator.lowerLineColor, indicator.lowerLineWidth, chart, isLine);
    }

    technicalIndicatorsRenderer._setSeriesRange(signalCollection, indicator,
        signalXValues, technicalIndicatorsRenderer._targetSeriesRenderers[0]);
    if (indicator.showZones) {
      technicalIndicatorsRenderer._setSeriesRange(upperCollection, indicator,
          xValues, technicalIndicatorsRenderer._targetSeriesRenderers[1]);
      technicalIndicatorsRenderer._setSeriesRange(lowerCollection, indicator,
          xValues, technicalIndicatorsRenderer._targetSeriesRenderers[2]);
    }
  }
}
