import 'package:flutter/material.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

/// Renders relative strength index (RSI) indicator.
///
/// The relative strength index (RSI) is a momentum indicator that measures the magnitude of recent price
/// changes to evaluate [overbought] or [oversold] conditions.
///
/// The RSI indicator has additional two lines other than the signal line.They indicate the [overbought] and [oversold] region.
///
/// The [upperLineColor] property is used to define the color for the line that indicates [overbought] region, and
/// the [lowerLineColor] property is used to define the color for the line that indicates [oversold] region.
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
      double? animationDelay,
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
            animationDelay: animationDelay,
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

  /// Show zones boolean value for RSI indicator.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
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

  /// Overbought value for RSI indicator.
  ///
  /// Defaults to `80`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        overbought : 50
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

  /// Oversold value for RSI indicator.
  ///
  /// Defaults to `20`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        oversold : 30
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

  /// Color of the upper line for RSI indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        upperLineColor : Colors.greenAccent
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

  /// Width of the upper line for RSI indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        upperLineWidth : 4.0
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

  /// Color of the lower line for RSI indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        lowerLineColor : Colors.blue
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

  /// Width of the lower line for RSI indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      RsiIndicator<Sample, num>(
  ///        seriesName: 'Series1'
  ///        lowerLineWidth : 4.0
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
        other.animationDelay == animationDelay &&
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
      animationDelay,
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
    return Object.hashAll(values);
  }
}
