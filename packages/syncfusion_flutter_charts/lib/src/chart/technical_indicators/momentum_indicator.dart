part of charts;

/// Renders the momentum indicator.
///
/// This class renders the momentum indicator, it also has a centerline. The [centerLineColor] and [centerLineWidth]
/// property is used to define centerline.
///
/// Provides the options for visibility, centerline color, centerline width, and period values to customize the appearance.
///
@immutable
class MomentumIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of MomentumIndicator class.
  MomentumIndicator(
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
      this.centerLineColor = Colors.red,
      this.centerLineWidth = 2,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MomentumIndicator &&
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
        other.centerLineColor == centerLineColor &&
        other.centerLineWidth == centerLineWidth;
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
      centerLineColor,
      centerLineWidth
    ];
    return hashList(values);
  }

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      MomentumIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(
    MomentumIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        centerLineCollection = <CartesianChartPoint<dynamic>>[],
        validData = technicalIndicatorsRenderer._dataPoints!;
    final List<dynamic> centerXValues = <dynamic>[], xValues = <dynamic>[];
    num value;

    if (validData.isNotEmpty) {
      final int length = indicator.period;
      if (validData.length >= indicator.period && indicator.period > 0) {
        for (int i = 0; i < validData.length; i++) {
          centerLineCollection.add(technicalIndicatorsRenderer._getDataPoint(
              validData[i].x, 100, validData[i], centerLineCollection.length));
          centerXValues.add(validData[i].x);
          if (!(i < length)) {
            value = (validData[i].close ?? 0) /
                (validData[i - length].close ?? 1) *
                100;
            signalCollection.add(technicalIndicatorsRenderer._getDataPoint(
                validData[i].x, value, validData[i], signalCollection.length));
            xValues.add(validData[i].x);
          }
        }
      }
      technicalIndicatorsRenderer._renderPoints = signalCollection;
      technicalIndicatorsRenderer._momentumCenterLineValue =
          centerLineCollection.first.y.toDouble();
      // Decides the type of renderer class to be used
      const bool isLine = true;
      technicalIndicatorsRenderer._setSeriesProperties(
          indicator,
          indicator.name ?? 'Momentum',
          indicator.signalLineColor,
          indicator.signalLineWidth,
          chart);
      technicalIndicatorsRenderer._setSeriesProperties(indicator, 'CenterLine',
          indicator.centerLineColor, indicator.centerLineWidth, chart, isLine);
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
