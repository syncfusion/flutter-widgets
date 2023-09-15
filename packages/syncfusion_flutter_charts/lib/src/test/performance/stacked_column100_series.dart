import 'dart:math';
import 'package:flutter/material.dart';
import '../../../charts.dart';
import 'performance.dart';

/// Method to get the stacked column100 performance sample
SfCartesianChart getStackedcolumn100PerformanceChart(
    String sampleName, int noOfSamples) {
  SfCartesianChart chart;
  final List<PerformanceData> data = <PerformanceData>[];
  for (int i = 0; i < noOfSamples; i++) {
    data.add(PerformanceData(x: i.toDouble(), sales1: Random().nextInt(100)));
  }
  switch (sampleName) {
    case 'default_stackedcolumn100':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<PerformanceData, num?>>[
            StackedColumn100Series<PerformanceData, num?>(
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (PerformanceData dat, _) => dat.x,
              yValueMapper: (PerformanceData dat, _) => dat.sales1,
            )
          ]);
      break;
    case 'stackedcolumn100_with_marker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<PerformanceData, num?>>[
            StackedColumn100Series<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                yValueMapper: (PerformanceData dat, _) => dat.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'stackedcolumn100_with_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<PerformanceData, num?>>[
            StackedColumn100Series<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                yValueMapper: (PerformanceData dat, _) => dat.sales1,
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
