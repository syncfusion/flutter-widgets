import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../common/event_args.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../base/chart_base.dart';
import '../chart_series/column_series.dart';
import '../chart_series/line_series.dart';
import '../chart_series/range_area_series.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/cartesian_state_properties.dart';
import '../series_painter/column_painter.dart';
import '../series_painter/line_painter.dart';
import '../series_painter/range_area_painter.dart';
import '../utils/enum.dart';
import 'accumulation_distribution_indicator.dart';
import 'atr_indicator.dart';
import 'bollinger_bands_indicator.dart';
import 'ema_indicator.dart';
import 'macd_indicator.dart';
import 'momentum_indicator.dart';
import 'rsi_indicator.dart';
import 'sma_indicator.dart';
import 'stochastic_indicator.dart';
import 'tma_indicator.dart';

/// Customize the technical indicators.
///
/// The technical indicator is a mathematical calculation based on historical price, volume or (in the case of futures contracts) open interest information,
/// which is intended to predict the direction of the financial market.
///
/// Indicators generally overlay the  chart data to show the data flow over a period of time.
///
/// _Note:_ This property is applicable only for financial chart series types.
abstract class TechnicalIndicators<T, D> {
  /// Creating an argument constructor of TechnicalIndicators class.
  TechnicalIndicators(
      {bool? isVisible,
      this.xAxisName,
      this.yAxisName,
      this.seriesName,
      List<double>? dashArray,
      double? animationDuration,
      double? animationDelay,
      this.dataSource,
      ChartValueMapper<T, D>? xValueMapper,
      ChartValueMapper<T, num>? lowValueMapper,
      ChartValueMapper<T, num>? highValueMapper,
      ChartValueMapper<T, num>? openValueMapper,
      ChartValueMapper<T, num>? closeValueMapper,
      this.name,
      this.onRenderDetailsUpdate,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      this.legendItemText,
      Color? signalLineColor,
      double? signalLineWidth,
      int? period})
      : isVisible = isVisible ?? true,
        dashArray = dashArray ?? <double>[0, 0],
        animationDuration = animationDuration ?? 1500,
        animationDelay = animationDelay ?? 0,
        isVisibleInLegend = isVisibleInLegend ?? true,
        legendIconType = legendIconType ?? LegendIconType.seriesType,
        signalLineColor = signalLineColor ?? Colors.blue,
        signalLineWidth = signalLineWidth ?? 2,
        period = period ?? 14,
        xValueMapper = (xValueMapper != null)
            ? ((int index) => xValueMapper(dataSource![index], index))
            : null,
        lowValueMapper = (lowValueMapper != null)
            ? ((int index) => lowValueMapper(dataSource![index], index))
            : null,
        highValueMapper = (highValueMapper != null)
            ? ((int index) => highValueMapper(dataSource![index], index))
            : null,
        openValueMapper = (openValueMapper != null)
            ? ((int index) => openValueMapper(dataSource![index], index))
            : null,
        closeValueMapper = (closeValueMapper != null)
            ? ((int index) => closeValueMapper(dataSource![index], index))
            : null;

  /// Boolean property to change  the visibility of the technical indicators.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        isVisible: false
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final bool isVisible;

  /// Property to map the technical indicators with the axes.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    primaryXAxis: NumericAxis(name: 'xAxis')
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        xAxisName: 'xAxis',
  ///        showZones : false
  ///      ),
  ///    ],
  ///    series: <ChartSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? xAxisName;

  /// Property to map the technical indicators with the axes.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    primaryYAxis: NumericAxis(name: 'yAxis')
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        xAxisName: 'yAxis',
  ///        showZones : false
  ///      ),
  ///    ],
  ///    series: <ChartSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? yAxisName;

  /// Property to link indicators to a series based on names.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///      ),
  ///    ],
  ///    series: <ChartSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
  final String? seriesName;

  /// Property to provide dash array for the technical indicators.
  ///
  /// Defaults to `<double>[0, 0]`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        dashArray: <double>[2, 3]
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final List<double> dashArray;

  /// Animation duration for the technical indicators.
  ///
  /// Defaults to `1500`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        animationDuration: 1000
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double animationDuration;

  /// Delay duration of the technical indicator's animation.
  /// It takes a millisecond value as input.
  /// By default, the technical indicator will get animated for the specified duration.
  /// If animationDelay is specified, then the technical indicator will begin to animate
  /// after the specified duration.
  ///
  /// Defaults to `0`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        animationDelay: 500
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double? animationDelay;

  /// Property to provide data for the technical indicators without any series.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final List<T>? dataSource;

  /// Value mapper to map the x values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<D>? xValueMapper;

  /// Value mapper to map the low values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? lowValueMapper;

  /// Value mapper to map the high values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? highValueMapper;

  /// Value mapper to map the open values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? openValueMapper;

  /// Value mapper to map the close values with technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<ChartData, num>>[
  ///      StochasticIndicator<ChartData, num>(
  ///        dataSource: chartData,
  ///        xValueMapper: (chartData data, _) => data.x,
  ///        lowValueMapper: (chartData data, _) => data.low,
  ///        highValueMapper: (chartData data, _) => data.high,
  ///        openValueMapper: (chartData data, _) => data.open,
  ///        closeValueMapper: (chartData data, _) => data.close,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// final List<ChartData> chartData = <ChartData>[
  ///   ChartData(1, 23, 50, 28, 38),
  ///   ChartData(2, 35, 80, 58, 78),
  ///   ChartData(3, 19, 90, 38, 58)
  /// ];
  ///
  /// class ChartData {
  ///   ChartData(this.x, this.low, this.high, this.open, this.close);
  ///     final double x;
  ///     final double low;
  ///     final double high;
  ///     final double open;
  ///     final double close;
  /// }
  /// ```
  final ChartIndexedValueMapper<num>? closeValueMapper;

  /// Property to provide name for the technical indicators.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        name: 'indicators'
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String? name;

  /// Boolean property to determine the rendering of legends for the technical indicators.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        isVisibleInLegend : false
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final bool isVisibleInLegend;

  /// Property to provide icon type for the technical indicators legend.
  ///
  /// Defaults to `LegendIconType.seriesType`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        legendIconType:  LegendIconType.diamond
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final LegendIconType legendIconType;

  /// Property to provide the text for the technical indicators legend.
  ///
  /// Defaults to 'null'.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        legendItemText : 'SMA',
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final String? legendItemText;

  /// Property to provide the color of the signal line in the technical indicators.
  ///
  /// Defaults to `Colors.blue`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        signalLineColor : Colors.red,
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final Color signalLineColor;

  /// Property to provide the width of the signal line in the technical indicators.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        signalLineWidth : 4.0
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final double signalLineWidth;

  /// Period determines the start point for the rendering of technical indicators.
  ///
  /// Defaults to `14`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        period : 4
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final int period;

  /// Callback which gets called while rendering the indicators.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        onRenderDetailsUpdate: (IndicatorRenderParams params) {
  ///          return TechnicalIndicatorRenderDetails(Colors.cyan, 3.0, <double>[5,5]);
  ///        },
  ///      ),
  ///    ],
  ///  );
  /// }
  /// ```
  final ChartIndicatorRenderCallback? onRenderDetailsUpdate;
}

/// Technical indicator renderer class for mutable fields and methods.
class TechnicalIndicatorsRenderer {
  /// Creates an argument constructor for TechnicalIndicator renderer class.
  TechnicalIndicatorsRenderer(
      this.technicalIndicatorRenderer, this.stateProperties);

  /// Specifies the technical indicator renderer.
  final TechnicalIndicators<dynamic, dynamic> technicalIndicatorRenderer;

  /// Holds the state properties.
  final CartesianStateProperties stateProperties;

  /// Specifies the name value.
  late String name;

  /// Specifies whether the indicator is visible.
  bool? visible;

  /// Specifies whether it is indicator.
  bool isIndicator = true;

  /// Represents the series type.
  final String seriesType = 'indicator';

  /// Represents the indicator type.
  late String indicatorType;

  /// Specifies the value of index.
  late int index;

  /// Specifies the list of target series renderer.
  List<CartesianSeriesRenderer> targetSeriesRenderers =
      <CartesianSeriesRenderer>[];

  /// Specifies the list of data points.
  List<CartesianChartPoint<dynamic>>? dataPoints =
      <CartesianChartPoint<dynamic>>[];

  /// Used for test case.
  List<CartesianChartPoint<dynamic>> renderPoints =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  List<CartesianChartPoint<dynamic>>? bollingerUpper =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  List<CartesianChartPoint<dynamic>>? bollingerLower =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  List<CartesianChartPoint<dynamic>>? macdLine =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  List<CartesianChartPoint<dynamic>>? macdHistogram =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  List<CartesianChartPoint<dynamic>>? stochasticperiod =
      <CartesianChartPoint<dynamic>>[];

  /// Used for events.
  double? momentumCenterLineValue;

  /// To get and return CartesianChartPoint.
  CartesianChartPoint<dynamic> getDataPoint(
      dynamic x, num y, CartesianChartPoint<dynamic> sourcePoint, int index,
      [TechnicalIndicators<dynamic, dynamic>? indicator]) {
    final CartesianChartPoint<dynamic> point =
        CartesianChartPoint<dynamic>(x, y);
    point.xValue = sourcePoint.xValue;
    point.index = index;
    point.yValue = y;
    point.isVisible = true;
    if (indicator is MacdIndicator &&
        (indicator.macdType == MacdType.histogram ||
            indicator.macdType == MacdType.both)) {
      final MacdIndicator<dynamic, dynamic> macdIndicator = indicator;
      point.pointColorMapper = point.yValue >= 0 == true
          ? macdIndicator.histogramPositiveColor
          : macdIndicator.histogramNegativeColor;
    }
    return point;
  }

  /// To get chart point of range type series.
  CartesianChartPoint<dynamic> getRangePoint(dynamic x, num high, num low,
      CartesianChartPoint<dynamic> sourcePoint, int index,
      //ignore: unused_element
      [TechnicalIndicators<dynamic, dynamic>? indicator]) {
    final CartesianChartPoint<dynamic> point = CartesianChartPoint<dynamic>(x);
    point.high = high;
    point.low = low;
    point.xValue = sourcePoint.xValue;
    point.index = index;
    point.isVisible = true;
    return point;
  }

  /// To set properties of technical indicators.
  void setSeriesProperties(TechnicalIndicators<dynamic, dynamic> indicator,
      String name, Color color, double width, SfCartesianChart chart,
      [bool isLine = false,
      bool isRangeArea = false,
      bool isHistogram = false]) {
    List<double>? dashArray;
    if (indicator.onRenderDetailsUpdate != null &&
        isRangeArea == false &&
        isHistogram == false &&
        isLine == false) {
      TechnicalIndicatorRenderDetails indicators;
      if (indicator is BollingerBandIndicator) {
        final BollingerBandIndicatorRenderParams indicatorRenderParams =
            BollingerBandIndicatorRenderParams(bollingerUpper, bollingerLower,
                renderPoints, name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is MomentumIndicator) {
        final MomentumIndicatorRenderParams indicatorRenderParams =
            MomentumIndicatorRenderParams(momentumCenterLineValue, renderPoints,
                name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is StochasticIndicator) {
        final StochasticIndicatorRenderParams indicatorRenderParams =
            StochasticIndicatorRenderParams(stochasticperiod, renderPoints,
                name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else if (indicator is MacdIndicator) {
        final MacdIndicatorRenderParams indicatorRenderParams =
            MacdIndicatorRenderParams(macdLine, macdHistogram, renderPoints,
                name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      } else {
        final IndicatorRenderParams indicatorRenderParams =
            IndicatorRenderParams(
                renderPoints, name, width, color, indicator.dashArray);
        indicators = indicator.onRenderDetailsUpdate!(indicatorRenderParams);
      }

      color = indicators.signalLineColor ?? color;
      width = indicators.signalLineWidth ?? width;
      dashArray = indicators.signalLineDashArray ?? indicator.dashArray;
    }
    final CartesianSeries<dynamic, dynamic> series = isRangeArea == true
        ? RangeAreaSeries<dynamic, dynamic>(
            name: name,
            color: color,
            dashArray: indicator.dashArray,
            borderWidth: width,
            xAxisName: indicator.xAxisName,
            animationDuration: indicator.animationDuration,
            animationDelay: indicator.animationDelay,
            yAxisName: indicator.yAxisName,
            enableTooltip: false,
            //ignore: always_specify_types
            xValueMapper: (dynamic, _) => null,
            //ignore: always_specify_types
            highValueMapper: (dynamic, _) => null,
            //ignore: always_specify_types
            lowValueMapper: (dynamic, _) => null,
            dataSource: <dynamic>[])
        : (isHistogram == true
            ? ColumnSeries<dynamic, dynamic>(
                name: name,
                color: color,
                xAxisName: indicator.xAxisName,
                animationDuration: indicator.animationDuration,
                animationDelay: indicator.animationDelay,
                yAxisName: indicator.yAxisName,
                //ignore: always_specify_types
                xValueMapper: (dynamic, _) => null,
                //ignore: always_specify_types
                yValueMapper: (dynamic, _) => null,
                dataSource: <dynamic>[])
            : LineSeries<dynamic, dynamic>(
                name: name,
                color: color,
                dashArray: dashArray ?? indicator.dashArray,
                width: width,
                xAxisName: indicator.xAxisName,
                animationDuration: indicator.animationDuration,
                animationDelay: indicator.animationDelay,
                yAxisName: indicator.yAxisName,
                //ignore: always_specify_types
                xValueMapper: (dynamic, _) => null,
                //ignore: always_specify_types
                yValueMapper: (dynamic, _) => null,
                dataSource: <dynamic>[]));
    final CartesianSeriesRenderer seriesRenderer = isRangeArea == true
        ? RangeAreaSeriesRenderer()
        : (isHistogram == true ? ColumnSeriesRenderer() : LineSeriesRenderer());
    final SeriesRendererDetails seriesRendererDetails =
        SeriesRendererDetails(seriesRenderer);
    SeriesHelper.setSeriesRendererDetails(
        seriesRenderer, seriesRendererDetails);
    seriesRendererDetails.stateProperties = stateProperties;
    seriesRendererDetails.series = series;
    seriesRendererDetails.visible = visible;
    seriesRendererDetails.chart = chart;
    seriesRendererDetails.seriesType =
        isRangeArea ? 'rangearea' : (isHistogram ? 'column' : 'line');
    seriesRendererDetails.isIndicator = true;
    seriesRendererDetails.seriesName = name;
    // ignore: unnecessary_null_comparison
    if (series.dashArray != null) {
      seriesRendererDetails.dashArray = series.dashArray;
      if (seriesRendererDetails.dashArray!.length == 1) {
        seriesRendererDetails.dashArray!.add(series.dashArray[0]);
      }
    }
    targetSeriesRenderers.add(seriesRenderer);
  }

  /// Set series range of technical indicators.
  void setSeriesRange(List<CartesianChartPoint<dynamic>> points,
      TechnicalIndicators<dynamic, dynamic> indicator, List<dynamic> xValues,
      [CartesianSeriesRenderer? seriesRenderer]) {
    if (seriesRenderer == null) {
      SeriesHelper.getSeriesRendererDetails(targetSeriesRenderers[0])
          .dataPoints = points;
      SeriesHelper.getSeriesRendererDetails(targetSeriesRenderers[0]).xValues =
          xValues;
    } else {
      final SeriesRendererDetails seriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(seriesRenderer);
      seriesRendererDetails.dataPoints = points;
      seriesRendererDetails.xValues = xValues;
    }
  }

  /// To get the value field value of technical indicators.
  num getFieldValue(List<CartesianChartPoint<dynamic>?> dataPoints, int index,
      String valueField) {
    num? val;
    if (valueField == 'low') {
      val = dataPoints[index]?.low;
    } else if (valueField == 'high') {
      val = dataPoints[index]?.high;
    } else if (valueField == 'open') {
      val = dataPoints[index]?.open;
    } else if (valueField == 'y') {
      val = dataPoints[index]?.y;
    } else {
      val = dataPoints[index]?.close;
    }

    ///ignore: unnecessary_statements
    val = val ?? 0;
    return val;
  }

  /// To initialize data source of technical indicators.
  void initDataSource(
      TechnicalIndicators<dynamic, dynamic> indicator,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
      SfCartesianChart chart) {
    technicalIndicatorsRenderer.targetSeriesRenderers =
        <CartesianSeriesRenderer>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer.dataPoints!;
    if (validData.isNotEmpty &&
        indicator is AccumulationDistributionIndicator) {
      _calculateADPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    } else if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator is AtrIndicator &&
        indicator.period > 0) {
      _calculateATRPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    } else if (indicator is BollingerBandIndicator && indicator.period > 0) {
      _calculateBollingerBandPoints(
          indicator, technicalIndicatorsRenderer, chart);
    } else if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator is EmaIndicator &&
        indicator.period > 0) {
      _calculateEMAPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    } else if (indicator is MacdIndicator && indicator.period > 0) {
      _calculateMacdPoints(indicator, technicalIndicatorsRenderer, chart);
    } else if (indicator is MomentumIndicator && indicator.period > 0) {
      _calculateMomentumIndicatorPoints(
          indicator, technicalIndicatorsRenderer, chart);
    } else if (indicator is RsiIndicator && indicator.period > 0) {
      _calculateRSIPoints(indicator, technicalIndicatorsRenderer, chart);
    } else if (indicator is SmaIndicator && indicator.period > 0) {
      _calculateSMAPoints(indicator, technicalIndicatorsRenderer, chart);
    } else if (indicator is StochasticIndicator && indicator.period > 0) {
      _calculateStochasticIndicatorPoints(
          indicator, technicalIndicatorsRenderer, chart);
    } else if (validData.isNotEmpty &&
        validData.length > indicator.period &&
        indicator is TmaIndicator &&
        indicator.period > 0) {
      _calculateTMAPoints(
          indicator, validData, technicalIndicatorsRenderer, chart);
    }
  }

  /// To calculate the rendering points of the accumulation distribution indicator.
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
      point = technicalIndicatorsRenderer.getDataPoint(
          validData[i].x, sum, validData[i], points.length);
      points.add(point);
      xValues.add(point.x);
    }
    technicalIndicatorsRenderer.renderPoints = points;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'AD',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer.setSeriesRange(points, indicator, xValues);
  }

  /// To calculate the rendering points of the ATR indicator.
  void _calculateATRPoints(
    AtrIndicator<dynamic, dynamic> indicator,
    List<CartesianChartPoint<dynamic>> validData,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    num average = 0;
    num highLow = 0, highClose = 0, lowClose = 0, trueRange = 0, tempRange = 0;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    final List<_TempData> temp = <_TempData>[];
    final num period = indicator.period;
    num sum = 0;
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
          point = technicalIndicatorsRenderer.getDataPoint(
              validData[i].x, average, validData[i], points.length);
          points.add(point);
          xValues.add(point.x);
        } else {
          average = sum / period;
          if (i == period - 1) {
            point = technicalIndicatorsRenderer.getDataPoint(
                validData[i].x, average, validData[i], points.length);
            points.add(point);
            xValues.add(point.x);
          }
        }
        temp.add(_TempData(validData[i].x, average));
      }
    }
    technicalIndicatorsRenderer.renderPoints = points;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'ATR',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer.setSeriesRange(points, indicator, xValues);
  }

  void _calculateBollingerBandPoints(
    BollingerBandIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final bool enableBand = indicator.bandColor != Colors.transparent &&
        // ignore: unnecessary_null_comparison
        indicator.bandColor != null;
    final int start = enableBand ? 1 : 0;
    final List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        upperCollection = <CartesianChartPoint<dynamic>>[],
        lowerCollection = <CartesianChartPoint<dynamic>>[],
        bandCollection = <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];

    //prepare data
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer.dataPoints!;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      num sum = 0, deviationSum = 0;
      final num multiplier = indicator.standardDeviation;
      final int limit = validData.length, length = indicator.period.round();
      // This has been null before
      final List<num> smaPoints = List<num>.filled(limit, -1),
          deviations = List<num>.filled(limit, -1);
      final List<_BollingerData> bollingerPoints = List<_BollingerData>.filled(
          limit,
          _BollingerData(
              x: -1, midBand: -1, lowBand: -1, upBand: -1, visible: false));

      for (int i = 0; i < length; i++) {
        sum += validData[i].close ?? 0;
      }
      num sma = sum / indicator.period;
      for (int i = 0; i < limit; i++) {
        final num y = validData[i].close ?? 0;
        if (i >= length - 1 && i < limit) {
          if (i - indicator.period >= 0) {
            final num diff = y - validData[i - length].close;
            sum = sum + diff;
            sma = sum / (indicator.period);
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i] - deviations[i - length];
          } else {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
          final num range = math.sqrt(deviationSum / (indicator.period));
          final num lowerBand = smaPoints[i] - (multiplier * range);
          final num upperBand = smaPoints[i] + (multiplier * range);
          if (i + 1 == length) {
            for (int j = 0; j < length - 1; j++) {
              bollingerPoints[j] = _BollingerData(
                  x: validData[j].xValue,
                  midBand: smaPoints[i],
                  lowBand: lowerBand.isNaN || lowerBand.isInfinite
                      ? smaPoints[i]
                      : lowerBand,
                  upBand: upperBand.isNaN || upperBand.isInfinite
                      ? smaPoints[i]
                      : upperBand,
                  visible: true);
            }
          }
          bollingerPoints[i] = _BollingerData(
              x: validData[i].xValue,
              midBand: smaPoints[i],
              lowBand: lowerBand.isNaN || lowerBand.isInfinite
                  ? smaPoints[i]
                  : lowerBand,
              upBand: upperBand.isNaN || upperBand.isInfinite
                  ? smaPoints[i]
                  : upperBand,
              visible: true);
        } else {
          if (i < indicator.period - 1) {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
        }
      }
      int i = -1, j = -1;
      for (int k = 0; k < limit; k++) {
        if (k >= (length - 1)) {
          xValues.add(validData[k].x);
          upperCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[k].x,
              bollingerPoints[k].upBand,
              validData[k],
              upperCollection.length));
          lowerCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[k].x,
              bollingerPoints[k].lowBand,
              validData[k],
              lowerCollection.length));
          signalCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[k].x,
              bollingerPoints[k].midBand,
              validData[k],
              signalCollection.length));
          if (enableBand) {
            bandCollection.add(technicalIndicatorsRenderer.getRangePoint(
                validData[k].x,
                upperCollection[++i].y,
                lowerCollection[++j].y,
                validData[k],
                bandCollection.length));
          }
        }
      }
    }
    technicalIndicatorsRenderer.renderPoints = signalCollection;
    technicalIndicatorsRenderer.bollingerUpper = upperCollection;
    technicalIndicatorsRenderer.bollingerLower = lowerCollection;
    // Decides the type of renderer class to be used
    bool isLine, isRangeArea;
    if (indicator.bandColor != Colors.transparent &&
        // ignore: unnecessary_null_comparison
        indicator.bandColor != null) {
      isLine = false;
      isRangeArea = true;
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'rangearea',
          indicator.bandColor, 0, chart, isLine, isRangeArea);
    }
    isLine = true;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'BollingerBand',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer.setSeriesProperties(indicator, 'UpperLine',
        indicator.upperLineColor, indicator.upperLineWidth, chart, isLine);
    technicalIndicatorsRenderer.setSeriesProperties(indicator, 'LowerLine',
        indicator.lowerLineColor, indicator.lowerLineWidth, chart, isLine);
    if (enableBand) {
      technicalIndicatorsRenderer.setSeriesRange(bandCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[0]);
    }
    technicalIndicatorsRenderer.setSeriesRange(signalCollection, indicator,
        xValues, technicalIndicatorsRenderer.targetSeriesRenderers[start]);
    technicalIndicatorsRenderer.setSeriesRange(upperCollection, indicator,
        xValues, technicalIndicatorsRenderer.targetSeriesRenderers[start + 1]);
    technicalIndicatorsRenderer.setSeriesRange(lowerCollection, indicator,
        xValues, technicalIndicatorsRenderer.targetSeriesRenderers[start + 2]);
  }

  /// To calculate the rendering points of the EMA indicator.
  void _calculateEMAPoints(
      EmaIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
      SfCartesianChart chart) {
    final int period = indicator.period;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    if (validData.length >= period && period > 0) {
      num sum = 0, average = 0;
      final num k = 2 / (period + 1);
      for (int i = 0; i < period; i++) {
        sum += technicalIndicatorsRenderer.getFieldValue(
            validData, i, indicator.valueField);
      }
      average = sum / period;
      point = technicalIndicatorsRenderer.getDataPoint(validData[period - 1].x,
          average, validData[period - 1], points.length);
      points.add(point);
      xValues.add(point.x);
      int index = period;
      while (index < validData.length) {
        if (validData[index].isVisible ||
            validData[index].isGap == true ||
            validData[index].isDrop == true) {
          final num prevAverage = points[index - period].y;
          final num yValue = (technicalIndicatorsRenderer.getFieldValue(
                          validData, index, indicator.valueField) -
                      prevAverage) *
                  k +
              prevAverage;
          point = technicalIndicatorsRenderer.getDataPoint(
              validData[index].x, yValue, validData[index], points.length);
          points.add(point);
          xValues.add(point.x);
        }
        index++;
      }
    }
    technicalIndicatorsRenderer.renderPoints = points;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'EMA',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer.setSeriesRange(points, indicator, xValues);
  }

  void _calculateMacdPoints(
    MacdIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    final num fastPeriod = indicator.longPeriod;
    final num slowPeriod = indicator.shortPeriod;
    final num trigger = indicator.period;
    final num length = fastPeriod + trigger;
    List<CartesianChartPoint<dynamic>> macdCollection =
            <CartesianChartPoint<dynamic>>[],
        histogramCollection = <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> validData =
        technicalIndicatorsRenderer.dataPoints!;
    List<dynamic> signalX = <dynamic>[],
        histogramX = <dynamic>[],
        macdX = <dynamic>[],
        collection;
    CartesianSeriesRenderer? histogramSeriesRenderer, macdLineSeriesRenderer;

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
          indicator, macdValues, validData, technicalIndicatorsRenderer);
      macdCollection = collection[0];
      macdX = collection[1];
      final List<num> signalEMA = _calculateEMAValues(
          trigger, macdCollection, 'y', technicalIndicatorsRenderer);
      collection = _getSignalPoints(
          indicator, signalEMA, validData, technicalIndicatorsRenderer);
      signalCollection = collection[0];
      signalX = collection[1];
      if (indicator.macdType == MacdType.histogram ||
          indicator.macdType == MacdType.both) {
        collection = _getHistogramPoints(indicator, macdValues, signalEMA,
            validData, technicalIndicatorsRenderer);
        histogramCollection = collection[0];
        histogramX = collection[1];
      }
    }
    technicalIndicatorsRenderer.renderPoints = signalCollection;
    technicalIndicatorsRenderer.macdHistogram = histogramCollection;
    technicalIndicatorsRenderer.macdLine = macdCollection;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'MACD',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    // To describe the type of series renderer to be assigned.
    bool isLine, isRangeArea, isHistogram;
    if (indicator.macdType == MacdType.line ||
        indicator.macdType == MacdType.both) {
      // Decides the type of renderer class to be used.
      isLine = true;
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'MacdLine',
          indicator.macdLineColor, indicator.macdLineWidth, chart, isLine);
    }
    if (indicator.macdType == MacdType.histogram ||
        indicator.macdType == MacdType.both) {
      isLine = false;
      isRangeArea = false;
      isHistogram = true;
      technicalIndicatorsRenderer.setSeriesProperties(
          indicator,
          'Histogram',
          indicator.histogramPositiveColor,
          indicator.signalLineWidth / 2,
          chart,
          isLine,
          isRangeArea,
          isHistogram);
    }
    if (indicator.macdType == MacdType.histogram) {
      histogramSeriesRenderer =
          technicalIndicatorsRenderer.targetSeriesRenderers[1];
    } else {
      macdLineSeriesRenderer =
          technicalIndicatorsRenderer.targetSeriesRenderers[1];
      if (indicator.macdType == MacdType.both) {
        histogramSeriesRenderer =
            technicalIndicatorsRenderer.targetSeriesRenderers[2];
      }
    }
    technicalIndicatorsRenderer.setSeriesRange(signalCollection, indicator,
        signalX, technicalIndicatorsRenderer.targetSeriesRenderers[0]);
    if (histogramSeriesRenderer != null) {
      technicalIndicatorsRenderer.setSeriesRange(
          histogramCollection, indicator, histogramX, histogramSeriesRenderer);
    }
    if (macdLineSeriesRenderer != null) {
      technicalIndicatorsRenderer.setSeriesRange(
          macdCollection, indicator, macdX, macdLineSeriesRenderer);
    }
  }

  /// Calculates the EMA values for the given period.
  List<num> _calculateEMAValues(
      num period,
      List<CartesianChartPoint<dynamic>> validData,
      String valueField,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    num sum = 0, initialEMA = 0;
    final List<num> emaValues = <num>[];
    final num emaPercent = 2 / (period + 1);
    for (int i = 0; i < period; i++) {
      sum +=
          technicalIndicatorsRenderer.getFieldValue(validData, i, valueField);
    }
    initialEMA = sum / period;
    emaValues.add(initialEMA);
    num emaAvg = initialEMA;
    for (int j = period.toInt(); j < validData.length; j++) {
      emaAvg =
          (technicalIndicatorsRenderer.getFieldValue(validData, j, valueField) -
                      emaAvg) *
                  emaPercent +
              emaAvg;
      emaValues.add(emaAvg);
    }
    return emaValues;
  }

  /// Defines the MACD Points.
  List<dynamic> _getMACDPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> macdPoints,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    final List<CartesianChartPoint<dynamic>> macdCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    int dataMACDIndex = indicator.longPeriod - 1, macdIndex = 0;
    while (dataMACDIndex < validData.length) {
      macdCollection.add(technicalIndicatorsRenderer.getDataPoint(
          validData[dataMACDIndex].x,
          macdPoints[macdIndex],
          validData[dataMACDIndex],
          macdCollection.length));
      xValues.add(validData[dataMACDIndex].x);
      dataMACDIndex++;
      macdIndex++;
    }
    return <dynamic>[macdCollection, xValues];
  }

  /// Calculates the signal points.
  List<dynamic> _getSignalPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> signalEma,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    int dataSignalIndex = indicator.longPeriod + indicator.period - 2;
    int signalIndex = 0;
    final List<dynamic> xValues = <dynamic>[];
    final List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    while (dataSignalIndex < validData.length) {
      signalCollection.add(technicalIndicatorsRenderer.getDataPoint(
          validData[dataSignalIndex].x,
          signalEma[signalIndex],
          validData[dataSignalIndex],
          signalCollection.length));
      xValues.add(validData[dataSignalIndex].x);
      dataSignalIndex++;
      signalIndex++;
    }
    return <dynamic>[signalCollection, xValues];
  }

  /// Calculates the MACD values.
  List<num> _getMACDVales(MacdIndicator<dynamic, dynamic> indicator,
      List<num> shortEma, List<num> longEma) {
    final List<num> macdPoints = <num>[];
    final int diff = indicator.longPeriod - indicator.shortPeriod;
    for (int i = 0; i < longEma.length; i++) {
      macdPoints.add(shortEma[i + diff] - longEma[i]);
    }
    return macdPoints;
  }

  /// Calculates the Histogram Points.
  List<dynamic> _getHistogramPoints(
      MacdIndicator<dynamic, dynamic> indicator,
      List<num> macdPoints,
      List<num> signalEma,
      List<CartesianChartPoint<dynamic>> validData,
      TechnicalIndicatorsRenderer technicalIndicatorsRenderer) {
    int dataHistogramIndex = indicator.longPeriod + indicator.period - 2;
    int histogramIndex = 0;
    final List<CartesianChartPoint<dynamic>> histogramCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    while (dataHistogramIndex < validData.length) {
      histogramCollection.add(technicalIndicatorsRenderer.getDataPoint(
          validData[dataHistogramIndex].x,
          macdPoints[histogramIndex + (indicator.period - 1)] -
              signalEma[histogramIndex],
          validData[dataHistogramIndex],
          histogramCollection.length,
          indicator));
      xValues.add(validData[dataHistogramIndex].x);
      dataHistogramIndex++;
      histogramIndex++;
    }
    return <dynamic>[histogramCollection, xValues];
  }

  void _calculateMomentumIndicatorPoints(
    MomentumIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        centerLineCollection = <CartesianChartPoint<dynamic>>[],
        validData = technicalIndicatorsRenderer.dataPoints!;
    final List<dynamic> centerXValues = <dynamic>[], xValues = <dynamic>[];
    num value;

    if (validData.isNotEmpty) {
      final int length = indicator.period;
      if (validData.length >= indicator.period && indicator.period > 0) {
        for (int i = 0; i < validData.length; i++) {
          centerLineCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[i].x, 100, validData[i], centerLineCollection.length));
          centerXValues.add(validData[i].x);
          if (!(i < length)) {
            value = (validData[i].close ?? 0) /
                (validData[i - length].close ?? 1) *
                100;
            signalCollection.add(technicalIndicatorsRenderer.getDataPoint(
                validData[i].x, value, validData[i], signalCollection.length));
            xValues.add(validData[i].x);
          }
        }
      }
      technicalIndicatorsRenderer.renderPoints = signalCollection;
      technicalIndicatorsRenderer.momentumCenterLineValue =
          centerLineCollection.first.y.toDouble();
      // Decides the type of renderer class to be used
      const bool isLine = true;
      technicalIndicatorsRenderer.setSeriesProperties(
          indicator,
          indicator.name ?? 'Momentum',
          indicator.signalLineColor,
          indicator.signalLineWidth,
          chart);
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'CenterLine',
          indicator.centerLineColor, indicator.centerLineWidth, chart, isLine);
      technicalIndicatorsRenderer.setSeriesRange(signalCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[0]);
      technicalIndicatorsRenderer.setSeriesRange(
          centerLineCollection,
          indicator,
          centerXValues,
          technicalIndicatorsRenderer.targetSeriesRenderers[1]);
    }
  }

  void _calculateRSIPoints(
    RsiIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> signalCollection =
            <CartesianChartPoint<dynamic>>[],
        lowerCollection = <CartesianChartPoint<dynamic>>[],
        upperCollection = <CartesianChartPoint<dynamic>>[],
        validData = technicalIndicatorsRenderer.dataPoints!;

    final List<dynamic> xValues = <dynamic>[], signalXValues = <dynamic>[];

    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      if (indicator.showZones) {
        for (int i = 0; i < validData.length; i++) {
          upperCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[i].x,
              indicator.overbought,
              validData[i],
              upperCollection.length));
          lowerCollection.add(technicalIndicatorsRenderer.getDataPoint(
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

      signalCollection.add(technicalIndicatorsRenderer.getDataPoint(
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
          signalCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[j].x,
              100 - (100 / (1 + (gain / loss))),
              validData[j],
              signalCollection.length));
          signalXValues.add(validData[j].x);
        }
      }
    }
    technicalIndicatorsRenderer.renderPoints = signalCollection;
    // Decides the type of renderer class to be used.
    const bool isLine = true;
    // final CartesianSeriesRenderer signalSeriesRenderer =
    //     technicalIndicatorsRenderer.targetSeriesRenderers[0];
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'RSI',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    if (indicator.showZones == true) {
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'UpperLine',
          indicator.upperLineColor, indicator.upperLineWidth, chart, isLine);
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'LowerLine',
          indicator.lowerLineColor, indicator.lowerLineWidth, chart, isLine);
    }

    technicalIndicatorsRenderer.setSeriesRange(signalCollection, indicator,
        signalXValues, technicalIndicatorsRenderer.targetSeriesRenderers[0]);
    if (indicator.showZones) {
      technicalIndicatorsRenderer.setSeriesRange(upperCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[1]);
      technicalIndicatorsRenderer.setSeriesRange(lowerCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[2]);
    }
  }

  void _calculateSMAPoints(
    SmaIndicator<dynamic, dynamic> indicator,
    TechnicalIndicatorsRenderer technicalIndicatorsRenderer,
    SfCartesianChart chart,
  ) {
    final List<CartesianChartPoint<dynamic>> smaPoints =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> points =
        technicalIndicatorsRenderer.dataPoints!;
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> point;
    if (points.isNotEmpty) {
      final List<CartesianChartPoint<dynamic>> validData = points;

      if (validData.length >= indicator.period && indicator.period > 0) {
        num average = 0, sum = 0;

        for (int i = 0; i < indicator.period; i++) {
          sum += technicalIndicatorsRenderer.getFieldValue(
              validData, i, indicator.valueField);
        }

        average = sum / indicator.period;
        point = technicalIndicatorsRenderer.getDataPoint(
            validData[indicator.period - 1].x,
            average,
            validData[indicator.period - 1],
            smaPoints.length);
        smaPoints.add(point);
        xValues.add(point.x);

        int index = indicator.period;
        while (index < validData.length) {
          sum -= technicalIndicatorsRenderer.getFieldValue(
              validData, index - indicator.period, indicator.valueField);
          sum += technicalIndicatorsRenderer.getFieldValue(
              validData, index, indicator.valueField);
          average = sum / indicator.period;
          point = technicalIndicatorsRenderer.getDataPoint(
              validData[index].x, average, validData[index], smaPoints.length);
          smaPoints.add(point);
          xValues.add(point.x);
          index++;
        }
      }
      technicalIndicatorsRenderer.renderPoints = smaPoints;
      technicalIndicatorsRenderer.setSeriesProperties(
          indicator,
          indicator.name ?? 'SMA',
          indicator.signalLineColor,
          indicator.signalLineWidth,
          chart);
      // final CartesianSeriesRenderer signalSeriesRenderer =
      // technicalIndicatorsRenderer.targetSeriesRenderers[0];
      technicalIndicatorsRenderer.setSeriesRange(smaPoints, indicator, xValues);
    }
  }

  /// To calculate the stochastic indicator points.
  void _calculateStochasticIndicatorPoints(
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
        technicalIndicatorsRenderer.dataPoints!;
    final List<dynamic> xValues = <dynamic>[];
    late List<dynamic> collection, signalX, periodX;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      if (indicator.showZones) {
        for (int i = 0; i < validData.length; i++) {
          upperCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[i].x,
              indicator.overbought,
              validData[i],
              upperCollection.length));
          lowerCollection.add(technicalIndicatorsRenderer.getDataPoint(
              validData[i].x,
              indicator.oversold,
              validData[i],
              lowerCollection.length));
          xValues.add(validData[i].x);
        }
      }
      source = calculatePeriod(indicator.period, indicator.kPeriod.toInt(),
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
    technicalIndicatorsRenderer.renderPoints = signalCollection;
    technicalIndicatorsRenderer.stochasticperiod = periodCollection;
    // Decides the type of renderer class to be used.
    const bool isLine = true;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'Stocastic',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    technicalIndicatorsRenderer.setSeriesProperties(indicator, 'PeriodLine',
        indicator.periodLineColor, indicator.periodLineWidth, chart, isLine);
    if (indicator.showZones) {
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'UpperLine',
          indicator.upperLineColor, indicator.upperLineWidth, chart, isLine);
      technicalIndicatorsRenderer.setSeriesProperties(indicator, 'LowerLine',
          indicator.lowerLineColor, indicator.lowerLineWidth, chart, isLine);
    }
    technicalIndicatorsRenderer.setSeriesRange(signalCollection, indicator,
        signalX, technicalIndicatorsRenderer.targetSeriesRenderers[0]);
    technicalIndicatorsRenderer.setSeriesRange(periodCollection, indicator,
        periodX, technicalIndicatorsRenderer.targetSeriesRenderers[1]);
    if (indicator.showZones) {
      technicalIndicatorsRenderer.setSeriesRange(upperCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[2]);
      technicalIndicatorsRenderer.setSeriesRange(lowerCollection, indicator,
          xValues, technicalIndicatorsRenderer.targetSeriesRenderers[3]);
    }
  }

  /// To calculate the values of the stochastic indicator.
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
        final String stochasticSum = sum.toStringAsFixed(2);
        values.add(double.parse(stochasticSum));
        temp.removeRange(0, 1);
        length = temp.length;
      }
      final int len = count - 1;
      for (int i = 0; i < data.length; i++) {
        if (!(i < len)) {
          pointCollection.add(technicalIndicatorsRenderer.getDataPoint(
              data[i].x, values[i - len], data[i], pointCollection.length));
          xValues.add(data[i].x);
          data[i].y = values[i - len];
        }
      }
    }

    return <dynamic>[pointCollection, xValues];
  }

  /// To return list of stochastic indicator points.
  List<CartesianChartPoint<dynamic>> calculatePeriod(
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
        modifiedSource.add(technicalIndicatorsRenderer.getDataPoint(
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
        modifiedSource.add(technicalIndicatorsRenderer.getDataPoint(
            data[i].x, (top / bottom) * 100, data[i], modifiedSource.length));
      }
    }
    return modifiedSource;
  }

  /// To calculate the values of the TMA indicator.
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
            sum += technicalIndicatorsRenderer.getFieldValue(
                validData, j, indicator.valueField);
          }
          sum = sum / period;
          smaValues.add(sum);
          length--;
        }
        //initial values
        for (int k = 0; k < period - 1; k++) {
          sum = 0;
          for (int j = 0; j < k + 1; j++) {
            sum += technicalIndicatorsRenderer.getFieldValue(
                validData, j, indicator.valueField);
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
          point = technicalIndicatorsRenderer.getDataPoint(
              validData[index - 1].x, sum, validData[index - 1], points.length);
          points.add(point);
          xValues.add(point.x);
          index++;
        }
      }
    }
    technicalIndicatorsRenderer.renderPoints = points;
    technicalIndicatorsRenderer.setSeriesProperties(
        indicator,
        indicator.name ?? 'TMA',
        indicator.signalLineColor,
        indicator.signalLineWidth,
        chart);
    // final CartesianSeriesRenderer signalSeriesRenderer =
    //     technicalIndicatorsRenderer.targetSeriesRenderers[0];
    technicalIndicatorsRenderer.setSeriesRange(points, indicator, xValues);
  }

  /// To return list of spliced values
  List<num> _splice<num>(List<num> list, int index, num? elements) {
    if (elements != null) {
      list.insertAll(index, <num>[elements]);
    }
    return list;
  }
}

class _TempData {
  _TempData(this.x, this.y);
  final dynamic x;
  final num y;
}

class _BollingerData {
  _BollingerData(
      {this.x,
      required this.midBand,
      required this.lowBand,
      required this.upBand,
      required this.visible});
  num? x;
  num midBand;
  num lowBand;
  num upBand;
  bool visible;
}
