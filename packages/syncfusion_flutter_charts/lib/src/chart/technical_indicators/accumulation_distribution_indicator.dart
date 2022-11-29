import 'package:flutter/material.dart';
import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

/// This class holds the properties of the accumulation distribution indicator.
///
/// Accumulation distribution indicator is a volume-based indicator designed to measure the accumulative flow of money into and out of a security.
/// It requires [volumeValueMapper] property additionally with the data source to calculate the signal line.
///
/// It provides options for series visible, axis name, series name, animation duration, legend visibility,
/// signal line width, and color.
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
      double? animationDelay,
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
            onRenderDetailsUpdate: onRenderDetailsUpdate);

  /// Volume of series.
  ///
  /// This value is mapped to the series.
  ///
  /// Defaults to `null`.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///  return SfCartesianChart(
  ///    indicators: <TechnicalIndicators<Sample, num>>[
  ///      AccumulationDistributionIndicator<Sample, num>(
  ///        seriesName: 'Series1',
  ///        volumeValueMapper: (dynamic data, _) => data.y,
  ///      ),
  ///    ],
  ///    series: <ChartSeries<Sample, num>>[
  ///      HiloOpenCloseSeries<Sample, num>(
  ///        volumeValueMapper: (Sample sales, _) => sales.volume,
  ///        name: 'Series1'
  ///      )
  ///    ]
  ///  );
  /// }
  /// ```
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
        other.animationDelay == animationDelay &&
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
      animationDelay,
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
    return Object.hashAll(values);
  }
}
