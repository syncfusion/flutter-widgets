import 'dart:math';
import 'package:flutter/material.dart';
import '../../../charts.dart';
import 'performance.dart';

/// Method to get the range area performance sample
SfCartesianChart getRangeAreaPerformanceChart(
    String sampleName, int noOfSamples) {
  SfCartesianChart chart;
  final List<PerformanceData> data = <PerformanceData>[];
  for (int i = 0; i < noOfSamples; i++) {
    data.add(PerformanceData(x: i.toDouble(), sales1: Random().nextInt(100)));
  }
  switch (sampleName) {
    case 'default_rangeArea':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeAreaSeries<PerformanceData, num?>>[
            RangeAreaSeries<PerformanceData, num?>(
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (PerformanceData dat, _) => dat.x,
              lowValueMapper: (PerformanceData dat, _) => dat.sales1,
              highValueMapper: (PerformanceData dat, _) => dat.sales1! + 15,
            )
          ]);
      break;
    case 'rangeArea_with_marker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeAreaSeries<PerformanceData, num?>>[
            RangeAreaSeries<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                lowValueMapper: (PerformanceData dat, _) => dat.sales1,
                highValueMapper: (PerformanceData dat, _) => dat.sales1! + 15,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'rangeArea_with_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeAreaSeries<PerformanceData, num?>>[
            RangeAreaSeries<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                lowValueMapper: (PerformanceData dat, _) => dat.sales1,
                highValueMapper: (PerformanceData dat, _) => dat.sales1! + 15,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}
