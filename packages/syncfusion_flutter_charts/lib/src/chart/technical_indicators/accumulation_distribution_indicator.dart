part of charts;

/// This class holds the properties of the Accumulation Distribution Indicator.
///
/// Accumulation distribution indicator is a volume-based indicator designed to measure the accumulative flow of money into and out of a security.
/// It requires [volumeValueMapper] property additionally with the data source to calculate the signal line.
///
/// It provides options for series visible, axis name, series name, animation duration, legend visibility,
/// signal line width, and color.
///
@immutable
class AccumulationDistributionIndicator<T, D>
    extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of AccumulationDistributionIndicator class.
  AccumulationDistributionIndicator(
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
      ChartValueMapper<T, num>? volumeValueMapper,
      String? name,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      Color? signalLineColor,
      double? signalLineWidth,
      ChartIndicatorRenderCallback? onRenderDetailsUpdate})
      : volumeValueMapper = (volumeValueMapper != null)
            ? ((int index) => volumeValueMapper(dataSource![index], index))
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
            signalLineWidth: signalLineWidth,
            onRenderDetailsUpdate: onRenderDetailsUpdate);

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
  final ChartIndexedValueMapper<num>? volumeValueMapper;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is AccumulationDistributionIndicator &&
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
        other.volumeValueMapper == volumeValueMapper &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth;
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
      volumeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth
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
      SfCartesianChart chart) {
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints!;
    if (validData.isNotEmpty &&
        indicator is AccumulationDistributionIndicator) {
      _calculateADPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    }
  }

  /// To calculate the rendering points of the accumulation distribution indicator
  void _calculateADPoints(
      AccumulationDistributionIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
      SfCartesianChart chart) {
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    num sum = 0, value = 0, high = 0, low = 0, close = 0;
    for (int i = 0; i < validData.length; i++) {
      high = validData[i].high ?? 0;
      low = validData[i].low ?? 0;
      close = validData[i].close ?? 0;
      value = ((close - low) - (high - close)) / (high - low);
      sum = sum + value * validData[i].volume!;
      point = technicalIndicatorsRenderer._getDataPoint(
          validData[i].x, sum, validData[i], points.length);
      points.add(point);
      xValues.add(point.x);
    }
    technicalIndicatorsRenderer._renderPoints = points;
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'AD',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer._setSeriesRange(points, indicator, xValues);
  }
}
