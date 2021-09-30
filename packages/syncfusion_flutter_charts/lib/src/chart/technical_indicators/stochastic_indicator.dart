import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

///Renders stochastic indicator.
///
///The stochastic indicator  is used to measure the range and momentum of price movements. It contains kPeriod and dPeriod properties defining
///the ‘k’ percentage and ‘d’ percentage respectively.
///
/// In this indicator [upperLineColor], [lowerLineColor] and [periodLineColor] property are used to define the color for
/// the Stochastic indicator lines.
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

  ///ShowZones boolean value for Stochastic indicator
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                showZones : false,
  ///              ),
  ///        ));
  ///}
  ///```
  final bool showZones;

  ///Overbought value for stochastic indicator
  ///
  ///Defaults to `80`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                overbought : 50,
  ///              ),
  ///        ));
  ///}
  ///```
  final double overbought;

  ///Oversold value for Stochastic Indicator.
  ///
  ///Defaults to `20`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                oversold : 30,
  ///              ),
  ///        ));
  ///}
  ///```
  final double oversold;

  ///Color of the upperLine for Stochastic Indicator.
  ///
  ///Defaults to `red`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 upperLineColor : Colors.greenAccent,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color upperLineColor;

  ///Width of the upperLine for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 upperLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double upperLineWidth;

  ///Color of the lowerLine for Stochastic Indicator.
  ///
  ///Defaults to `green`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 lowerLineColor : Colors.blue,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color lowerLineColor;

  ///Width of lowerline for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 lowerLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double lowerLineWidth;

  ///Color of the periodLine for Stochastic Indicator.
  ///
  ///Defaults to `yellow`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 periodLineColor :Colors.orange,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color periodLineColor;

  ///Width of the periodLIne for Stochastic Indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 periodLineWidth :5.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double periodLineWidth;

  ///Value of Kperiod  in Stochastic Indicator.
  ///
  ///Defaults to `3`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 kPeriod:4,
  ///              ),
  ///        ));
  ///}
  ///```
  final num kPeriod;

  ///Value of dperiod  in Stochastic Indicator.
  ///
  ///Defaults to `5`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            StochasticIndicator<dynamic, dynamic>(
  ///                 dPeriod:4,
  ///              ),
  ///        ));
  ///}
  ///```
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
    return hashList(values);
  }
}
