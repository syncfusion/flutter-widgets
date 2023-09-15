import 'package:flutter/material.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../utils/enum.dart';
import 'technical_indicator.dart';

/// This class holds the properties of the Macd Indicator.
///
/// The macd indicator has [shortPeriod] and [longPeriod] for defining the motion of the indicator.
/// Also, you can draw line, histogram macd or both using the [macdType] property.
///
/// The [macdLineColor] property is used to define the color for the
/// macd line and the [histogramNegativeColor] and [histogramPositiveColor] property is used to define the color for the macd histogram.
///
/// Provides the options of macd type, name, short Period, long period and macd line color is used to customize the appearance.
@immutable
class MacdIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of MacdIndicator class.
  MacdIndicator(
      {bool? isVisible,
      String? xAxisName,
      String? yAxisName,
      String? seriesName,
      List<double>? dashArray,
      double? animationDuration,
      double? animationDelay,
      List<T>? dataSource,
      ChartValueMapper<T, D>? xValueMapper,
      ChartValueMapper<T, num>? closeValueMapper,
      String? name,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      Color? signalLineColor,
      double? signalLineWidth,
      int? period,
      this.shortPeriod = 12,
      this.longPeriod = 26,
      this.macdLineColor = Colors.orange,
      this.macdLineWidth = 2,
      this.macdType = MacdType.both,
      this.histogramPositiveColor = Colors.green,
      this.histogramNegativeColor = Colors.red,
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
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period,
            onRenderDetailsUpdate: onRenderDetailsUpdate);

  /// Short period value of the macd indicator.
  ///
  /// Defaults to `12`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        shortPeriod: 2
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
  final int shortPeriod;

  /// Long period value of the macd indicator.
  ///
  /// Defaults to `26`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        longPeriod: 31
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
  final int longPeriod;

  /// Macd line color  of the macd indicator.
  ///
  /// Defaults to `Colors.orange`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdLineColor: Colors.red
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
  final Color macdLineColor;

  /// Macd line width  of the macd indicator.
  ///
  /// Defaults to `2`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdLineWidth: 3
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
  final double macdLineWidth;

  /// Macd type line of the macd indicator.
  ///
  /// Defaults to `MacdType.both`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram
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
  final MacdType macdType;

  /// Histogram positive color of the macd indicator.
  ///
  /// Defaults to `Colors.green`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram,
  ///        histogramPositiveColor: Colors.red
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
  final Color histogramPositiveColor;

  /// Histogram negative color of the macd indicator.
  ///
  /// Defaults to `Colors.red`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      MacdIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        macdType: MacdType.histogram,
  ///        histogramNegativeColor: Colors.green
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
  final Color histogramNegativeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MacdIndicator &&
        other.isVisible == isVisible &&
        other.xAxisName == xAxisName &&
        other.yAxisName == yAxisName &&
        other.seriesName == seriesName &&
        other.dashArray == dashArray &&
        other.animationDuration == animationDuration &&
        other.animationDelay == animationDelay &&
        other.dataSource == dataSource &&
        other.xValueMapper == xValueMapper &&
        other.closeValueMapper == closeValueMapper &&
        other.period == period &&
        other.name == name &&
        other.isVisibleInLegend == isVisibleInLegend &&
        other.legendIconType == legendIconType &&
        other.legendItemText == legendItemText &&
        other.signalLineColor == signalLineColor &&
        other.signalLineWidth == signalLineWidth &&
        other.shortPeriod == shortPeriod &&
        other.longPeriod == longPeriod &&
        other.macdLineColor == macdLineColor &&
        other.macdLineWidth == macdLineWidth &&
        other.macdType == macdType &&
        other.histogramPositiveColor == histogramPositiveColor &&
        other.histogramNegativeColor == histogramNegativeColor;
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
      closeValueMapper,
      name,
      isVisibleInLegend,
      legendIconType,
      legendItemText,
      signalLineColor,
      signalLineWidth,
      period,
      shortPeriod,
      longPeriod,
      macdLineColor,
      macdLineWidth,
      macdType,
      histogramPositiveColor,
      histogramNegativeColor
    ];
    return Object.hashAll(values);
  }
}
