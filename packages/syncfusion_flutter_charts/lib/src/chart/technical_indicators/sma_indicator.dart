part of charts;

///Renders simple moving average (SMA) indicator.
///
/// A simple moving average (SMA) is an arithmetic moving average calculated by adding recent closing prices and
/// then dividing the total by the number of time periods in the calculation average.
///
///  It also has a [valueField] property. Based on this property, the indicator will be rendered.
@immutable
class SmaIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of SmaIndicator class.
  SmaIndicator(
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
      String? valueField,
      ChartIndicatorRenderCallback? onRenderDetailsUpdate})
      : valueField = (valueField ?? 'close').toLowerCase(),
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
            period: period,
            onRenderDetailsUpdate: onRenderDetailsUpdate);

  ///ValueField value for sma indicator.
  ///
  ///Valuefield detemines the field for the rendering of sma indicator.
  ///
  ///Defaults to `close`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            SmaIndicator<dynamic, dynamic>(
  ///                valueField : 'high',
  ///              ),
  ///        ));
  ///}
  ///```
  final String valueField;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SmaIndicator &&
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
        other.valueField == valueField;
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
      valueField,
      period
    ];
    return hashList(values);
  }

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      TechnicalIndicators<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(
    SmaIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> smaPoints =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> points =
        technicalIndicatorsRenderer._dataPoints!;
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    if (points.isNotEmpty) {
      final List<CartesianChartPoint<dynamic>> validData = points;

      if (validData.length >= indicator.period && indicator.period > 0) {
        num average = 0, sum = 0;

        for (int i = 0; i < indicator.period; i++) {
          sum += technicalIndicatorsRenderer._getFieldValue(
              validData, i, valueField);
        }

        average = sum / indicator.period;
        point = technicalIndicatorsRenderer._getDataPoint(
            validData[indicator.period - 1].x,
            average,
            validData[indicator.period - 1],
            smaPoints.length);
        smaPoints.add(point);
        xValues.add(point.x);

        int index = indicator.period;
        while (index < validData.length) {
          sum -= technicalIndicatorsRenderer._getFieldValue(
              validData, index - indicator.period, valueField);
          sum += technicalIndicatorsRenderer._getFieldValue(
              validData, index, valueField);
          average = sum / indicator.period;
          point = technicalIndicatorsRenderer._getDataPoint(
              validData[index].x, average, validData[index], smaPoints.length);
          smaPoints.add(point);
          xValues.add(point.x);
          index++;
        }
      }
      technicalIndicatorsRenderer._renderPoints = smaPoints;
      technicalIndicatorsRenderer._setSeriesProperties(
          indicator,
          indicator.name ?? 'SMA',
          indicator.signalLineColor,
          indicator.signalLineWidth,
          chart);
      // final CartesianSeriesRenderer signalSeriesRenderer =
      // technicalIndicatorsRenderer._targetSeriesRenderers[0];
      technicalIndicatorsRenderer._setSeriesRange(
          smaPoints, indicator, xValues);
    }
  }
}
