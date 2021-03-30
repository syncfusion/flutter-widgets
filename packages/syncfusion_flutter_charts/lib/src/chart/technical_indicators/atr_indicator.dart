part of charts;

/// This class holds the properties of the Average True Range Indicator.
///
///
/// ATR indicator is a technical analysis volatility indicator. This indicator does not indicate the price trend.
/// simply the degree of price volatility. The average true range is an N-day smoothed moving average (SMMA) of the true range values.
///
///
/// Provides options for series visible, axis name, series name, animation duration, legend visibility,
/// signal line width, and color to customize the appearance of indicator.

class AtrIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of AtrIndicator class.
  AtrIndicator(
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
      int? period})
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
            period: period);

  /// To initialise indicators collections
  // ignore:unused_element
  void _initSeriesCollection(
      TechnicalIndicators<dynamic, dynamic> indicator,
      SfCartesianChart chart,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    technicalIndicatorsRenderer._targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    technicalIndicatorsRenderer._setSeriesProperties(
        indicator,
        indicator.name ?? 'ATR',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
  }

  /// To initialise data source of technical indicators
  // ignore:unused_element
  void _initDataSource(TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer._dataPoints!;
    if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator is AtrIndicator) {
      _calculateATRPoints(indicator, validData, technicalIndicatorsRenderer);
    }
  }

  /// To calculate the rendering points of the ATR indicator
  void _calculateATRPoints(
      AtrIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    num average = 0;
    num highLow = 0;
    num highClose = 0;
    num lowClose = 0;
    num trueRange = 0;
    num tempRange = 0;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    final List<_TempData> temp = <_TempData>[];
    final num period = indicator.period;
    num sum = 0;
    final CartesianSeriesRenderer signalSeriesRenderer =
        technicalIndicatorsRenderer._targetSeriesRenderers[0];
    for (int i = 0; i < validData.length; i++) {
      if (!validData[i].isDrop && !validData[i].isGap) {
        highLow = validData[i].high - validData[i].low;
        if (i > 0) {
          highClose = (validData[i].high - (validData[i - 1].close ?? 0)).abs();
          lowClose = (validData[i].low - (validData[i - 1].close ?? 0)).abs();
        }
        tempRange = math.max(highLow, highClose);
        trueRange = math.max(tempRange, lowClose);
        sum = sum + trueRange;
        if (i >= period && period > 0) {
          average =
              (temp[temp.length - 1].y * (period - 1) + trueRange) / period;
          point = technicalIndicatorsRenderer._getDataPoint(validData[i].x,
              average, validData[i], signalSeriesRenderer, points.length);
          points.add(point);
          xValues.add(point.x);
        } else {
          average = sum / period;
          if (i == period - 1) {
            point = technicalIndicatorsRenderer._getDataPoint(validData[i].x,
                average, validData[i], signalSeriesRenderer, points.length);
            points.add(point);
            xValues.add(point.x);
          }
        }
        temp.add(_TempData(validData[i].x, average));
      }
    }
    technicalIndicatorsRenderer._renderPoints = points;
    technicalIndicatorsRenderer._setSeriesRange(points, indicator, xValues);
  }
}

class _TempData {
  _TempData(this.x, this.y);
  final dynamic x;
  final dynamic y;
}
