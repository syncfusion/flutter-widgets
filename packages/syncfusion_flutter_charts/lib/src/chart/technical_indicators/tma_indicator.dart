part of charts;

///Renders Triangular Moving Average (TMA) indicator.
///
///The Triangular Moving Average (TMA) is a technical indicator similar to other moving averages.
///The TMA shows the average (or average) price of an asset over a specified number of data points over a period of time.
///
///The technical indicator is rendered on the basis of the [valueField] property.
@immutable
class TmaIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of TmaIndicator class.
  TmaIndicator(
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

  ///ValueField value for tma indicator.
  ///
  /// Value field determines the field for rendering the indicators.
  ///
  ///Defaults to `close`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            TmaIndicator<dynamic, dynamic>(
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

    return other is TmaIndicator &&
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
    TechnicalIndicators<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints!;
    if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator is TmaIndicator) {
      _calculateTMAPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    }
  }

  /// To calculate the values of the TMA indicator
  void _calculateTMAPoints(
      TmaIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
      SfCartesianChart chart) {
    final num period = indicator.period;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        period > 0) {
      //prepare data
      if (validData.isNotEmpty && validData.length >= period) {
        num sum = 0;
        int index = 0;
        List<num> smaValues = <num>[];
        int length = validData.length;

        while (length >= period) {
          sum = 0;
          index = validData.length - length;
          for (int j = index; j < index + period; j++) {
            sum += technicalIndicatorsRenderer._getFieldValue(
                validData, j, valueField);
          }
          sum = sum / period;
          smaValues.add(sum);
          length--;
        }
        //initial values
        for (int k = 0; k < period - 1; k++) {
          sum = 0;
          for (int j = 0; j < k + 1; j++) {
            sum += technicalIndicatorsRenderer._getFieldValue(
                validData, j, valueField);
          }
          sum = sum / (k + 1);
          smaValues = _splice(smaValues, k, sum);
        }

        index = indicator.period;
        while (index <= smaValues.length) {
          sum = 0;
          for (int j = index - indicator.period; j < index; j++) {
            sum = sum + smaValues[j];
          }
          sum = sum / indicator.period;
          point = technicalIndicatorsRenderer._getDataPoint(
              validData[index - 1].x, sum, validData[index - 1], points.length);
          points.add(point);
          xValues.add(point.x);
          index++;
        }
      }
    }
    technicalIndicatorsRenderer._renderPoints = points;
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'TMA',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    // final CartesianSeriesRenderer signalSeriesRenderer =
    //     technicalIndicatorsRenderer._targetSeriesRenderers[0];
    technicalIndicatorsRenderer._setSeriesRange(points, indicator, xValues);
  }

  /// To return list of spliced values
  List<num> _splice<num>(List<num> list, int index, num? elements) {
    if (elements != null) {
      list.insertAll(index, <num>[elements]);
    }
    return list;
  }
}
