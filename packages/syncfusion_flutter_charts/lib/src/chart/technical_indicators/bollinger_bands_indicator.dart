import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

/// This class has the property of BollingerBand Indicator.
///
/// This indicator also has [upperLineColor], [lowerLineColor] property for defining the brushes for the indicator lines.
/// Also, we can specify standard deviation values for the BollingerBand indicator using [standardDeviation] property.
///
/// Provides options for series visible, axis name, series name, animation duration, legend visibility,
/// band color to customize the appearance.
///
@immutable
class BollingerBandIndicator<T, D> extends TechnicalIndicators<T, D> {
  /// Creating an argument constructor of BollingerBandIndicator class.
  BollingerBandIndicator(
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
      this.standardDeviation = 2,
      this.upperLineColor = Colors.red,
      this.upperLineWidth = 2,
      this.lowerLineColor = Colors.green,
      this.lowerLineWidth = 2,
      this.bandColor = const Color(0x409e9e9e),
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

  /// Standard Deviation value of the bollinger bands
  ///
  /// Defaults to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                standardDeviation: 3,)},
  ///        ));
  ///}
  ///```
  ///
  final int standardDeviation;

  /// UpperLine Color of the bollinger bands.
  ///
  /// Defaults to `Colors.red`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                upperLineColor: Colors.red,)},
  ///        ));
  ///}
  ///```
  ///
  final Color upperLineColor;

  /// UpperLine width value of the bollinger bands.
  ///
  /// Defaults to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                upperLineWidth: 2,)},
  ///        ));
  ///}
  ///```
  ///
  final double upperLineWidth;

  /// LowerLine Color value of the bollinger bands
  ///
  /// Defaults to `Colors.green`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                lowerLineColor: Colors.green,)},
  ///        ));
  ///}
  ///```
  ///
  final Color lowerLineColor;

  /// LowerLine Width value of the bollinger bands
  ///
  /// Defaults to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                lowerLineWidth: 2,)},
  ///        ));
  ///}
  ///```
  ///
  final double lowerLineWidth;

  /// Band Color  of the Bollinger Band
  ///
  /// Defaults to `Colors.grey.withOpacity(0.25)`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                bandColor: Colors.transparent,)},
  ///        ));
  ///}
  ///```
  ///
  final Color bandColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is BollingerBandIndicator &&
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
        other.standardDeviation == standardDeviation &&
        other.upperLineColor == upperLineColor &&
        other.upperLineWidth == upperLineWidth &&
        other.lowerLineColor == lowerLineColor &&
        other.lowerLineWidth == lowerLineWidth &&
        other.bandColor == bandColor;
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
      standardDeviation,
      upperLineColor,
      upperLineWidth,
      lowerLineColor,
      lowerLineWidth,
      bandColor
    ];
    return hashList(values);
  }
}
