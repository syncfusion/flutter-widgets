import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import 'technical_indicator.dart';

///Renders relative strength index (RSI) indicator.
///
///The relative strength index (RSI) is a momentum indicator that measures the magnitude of recent price
/// changes to evaluate [overbought] or [oversold] conditions.
///
///The RSI indicator has additional two lines other than the signal line.They indicate the [overbought] and [oversold] region.
///
///The [upperLineColor] property is used to define the color for the line that indicates [overbought] region, and
///the [lowerLineColor] property is used to define the color for the line that indicates [oversold] region.
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

  ///ShowZones boolean value for RSI indicator
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                showZones : false,
  ///              ),
  ///        ));
  ///}
  ///```
  final bool showZones;

  ///Overbought value for RSI indicator.
  ///
  ///Defaults to `80`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                overbought : 50,
  ///              ),
  ///        ));
  ///}
  ///```
  final double overbought;

  ///Oversold value for RSI indicator.
  ///
  ///Defaults to `20`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                oversold : 30,
  ///              ),
  ///        ));
  ///}
  ///```
  final double oversold;

  ///Color of the upperLine for RSI indicator.
  ///
  ///Defaults to `red`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 upperLineColor : Colors.greenAccent,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color upperLineColor;

  ///Width of the upperLine for RSI indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 upperLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
  final double upperLineWidth;

  ///Color of the lowerLine for RSI indicator.
  ///
  ///Defaults to `green`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 lowerLineColor : Colors.blue,
  ///              ),
  ///        ));
  ///}
  ///```
  final Color lowerLineColor;

  ///Width of the upperLine for RSI indicator.
  ///
  ///Defaults to `2`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            RsiIndicator<dynamic, dynamic>(
  ///                 lowerLineWidth : 4.0,
  ///              ),
  ///        ));
  ///}
  ///```
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
    return hashList(values);
  }
}
