import 'dart:math';
import 'package:flutter/material.dart';
import '../../../charts.dart';
import 'performance.dart';

/// Method to get the hilo performance sample
SfCartesianChart getHiloPerformanceChart(String sampleName, int noOfSamples) {
  SfCartesianChart chart;
  final List<PerformanceData> data = <PerformanceData>[];
  for (int i = 0; i < noOfSamples; i++) {
    data.add(PerformanceData(
      x: i.toDouble(),
      sales1: Random().nextInt(100),
    ));
  }
  switch (sampleName) {
    case 'default_hilo':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <HiloSeries<PerformanceData, num?>>[
            HiloSeries<PerformanceData, num?>(
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (PerformanceData dat, _) => dat.x,
              lowValueMapper: (PerformanceData dat, _) => dat.sales1,
              highValueMapper: (PerformanceData dat, _) => dat.sales1! + 20,
            )
          ]);
      break;
    case 'hilo_with_marker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <HiloSeries<PerformanceData, num?>>[
            HiloSeries<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                lowValueMapper: (PerformanceData dat, _) => dat.sales1,
                highValueMapper: (PerformanceData dat, _) => dat.sales1! + 20,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'hilo_with_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <HiloSeries<PerformanceData, num?>>[
            HiloSeries<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                lowValueMapper: (PerformanceData dat, _) => dat.sales1,
                highValueMapper: (PerformanceData dat, _) => dat.sales1! + 20,
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
