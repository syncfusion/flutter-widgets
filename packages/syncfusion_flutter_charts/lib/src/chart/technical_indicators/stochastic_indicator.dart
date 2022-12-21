import 'package:flutter/material.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

/// Renders stochastic indicator.
///
/// The stochastic indicator  is used to measure the range and momentum of price movements. It contains kPeriod and dPeriod properties defining
/// the ‘k’ percentage and ‘d’ percentage respectively.
///
/// In this indicator [upperLineColor], [lowerLineColor] and [periodLineColor] property are used to define the color for
/// the stochastic indicator lines.
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
      double? animationDelay,
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
            animationDelay: animationDelay,
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

  /// Show zones boolean value for stochastic indicator.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
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
  final bool showZones;

  /// Overbought value for stochastic indicator
  ///
  /// Defaults to `80`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        overbought: 50
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
  final double overbought;

  /// Oversold value for stochastic Indicator.
  ///
  /// Defaults to `20`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        oversold: 30
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
  final double oversold;

  /// Color of the upper line for stochastic Indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        upperLineColor: Colors.greenAccent
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
  final Color upperLineColor;

  /// Width of the upper line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        upperLineWidth: 4.0
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
  final double upperLineWidth;

  /// Color of the lower line for stochastic Indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        lowerLineColor: Colors.blue
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
  final Color lowerLineColor;

  /// Width of lower line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        lowerLineWidth: 4.0
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
  final double lowerLineWidth;

  /// Color of the period line for stochastic Indicator.
  ///
  /// Defaults to `Colors.yellow`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        periodLineColor: Colors.orange
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
  final Color periodLineColor;

  /// Width of the period line for stochastic Indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        periodLineWidth: 5.0
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
  final double periodLineWidth;

  /// Value of kPeriod  in stochastic Indicator.
  ///
  /// Defaults to `3`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        kPeriod: 4
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
  final num kPeriod;

  /// Value of dPeriod  in stochastic Indicator.
  ///
  /// Defaults to `5`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      StochasticIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        dPeriod: 4
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
        other.animationDelay == animationDelay &&
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
      animationDelay,
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
    return Object.hashAll(values);
  }
}
