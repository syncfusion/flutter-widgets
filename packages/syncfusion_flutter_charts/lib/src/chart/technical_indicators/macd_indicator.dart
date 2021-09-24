import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../common/utils/enum.dart';
import '../../common/utils/typedef.dart';
import '../utils/enum.dart';
import 'technical_indicator.dart';

/// This class Holds the properties of the Macd Indicator.
///
/// The Macd indicator has [shortPeriod] and [longPeriod] for defining the motion of the indicator.
/// Also, you can draw Line, Histogram MACD or Both using the [macdType] property.
///
///  The [macdLineColor] property is used to define the color for the
/// MACD line and the [histogramNegativeColor] and [histogramPositiveColor] property is used to define the color for the MACD histogram.
///
/// Provides the options of macd type, name, short Period, long period and macd line color is used to customize the appearance.
///
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
  /// Defaults to `12`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             shortPeriod: 2,)]
  ///                  ));
  ///}
  /// ```
  ///
  final int shortPeriod;

  /// Long period value of the macd indicator.
  ///
  /// Defaults to `26`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             longPeriod: 31,)]
  ///                  ));
  ///}
  /// ```
  ///
  final int longPeriod;

  /// MacdLine color  of the macd indicator.
  ///
  /// Defaults to `Colors.orange`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdLineColor: Colors.orange,)]
  ///                  ));
  ///}
  /// ```
  ///
  final Color macdLineColor;

  /// MacdLine width  of the macd indicator.
  ///
  /// Defaults to `2`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdLineWidth: 2,)]
  ///                  ));
  ///}
  /// ```
  ///
  final double macdLineWidth;

  /// Macd type line of the macd indicator.
  ///
  /// Defaults to `MacdType.both`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             macdType: MacdType.both,)]
  ///                  ));
  ///}
  /// ```
  ///
  final MacdType macdType;

  /// Histogram Positive color  of the macd indicator.
  ///
  /// Defaults to `Colors.green`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             histogramPositiveColor: Colors.green,)]
  ///                  ));
  ///}
  /// ```
  ///
  final Color histogramPositiveColor;

  /// Histogram Negative color  of the macd indicator.
  ///
  /// Defaults to `Colors.red`
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///                       MacdIndicator<dynamic, dynamic>(
  ///                             histogramNegativeColor: Colors.red,)]
  ///                  ));
  ///}
  /// ```
  ///
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
    return hashList(values);
  }
}
