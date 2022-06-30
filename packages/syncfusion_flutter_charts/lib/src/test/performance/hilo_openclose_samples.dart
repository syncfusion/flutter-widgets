import 'dart:math';
import 'package:flutter/material.dart';
import '../../../charts.dart';
import 'performance.dart';

/// Method to get the hilo open close performance sample
SfCartesianChart getHiloOpenClosePerformanceChart(
    String sampleName, int noOfSamples) {
  SfCartesianChart chart;
  final List<PerformanceData> data = <PerformanceData>[];
  for (int i = 0; i < noOfSamples; i++) {
    data.add(PerformanceData(
      x: i.toDouble(),
      sales1: Random().nextInt(100),
    ));
  }
  switch (sampleName) {
    case 'default_hiloOpenClose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <HiloOpenCloseSeries<PerformanceData, num?>>[
            HiloOpenCloseSeries<PerformanceData, num?>(
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (PerformanceData dat, _) => dat.x,
              lowValueMapper: (PerformanceData dat, _) => dat.sales1,
              highValueMapper: (PerformanceData dat, _) => dat.sales1! + 20,
              openValueMapper: (PerformanceData dat, _) => dat.sales1! + 10,
              closeValueMapper: (PerformanceData dat, _) => dat.sales1! + 15,
            )
          ]);
      break;
    //   case 'hiloOpenClose_with_marker':
    //     chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       series: <HiloOpenCloseSeries<PerformanceData, num>>[
    //         HiloOpenCloseSeries<PerformanceData, num>(
    //           dataSource: data,
    // animationDuration: 0,
    //           xValueMapper: (PerformanceData dat, _) => dat.x,
    //           lowValueMapper: (PerformanceData dat, _) => dat.sales1,
    //           highValueMapper: (PerformanceData dat, _) => dat.sales1 + 20,
    //           openValueMapper: (PerformanceData dat, _) => dat.sales1 + 10,
    //           closeValueMapper: (PerformanceData dat, _) => dat.sales1 + 15,
    //           markerSettings: const MarkerSettings(isVisible: true))
    //     ]);
    //     break;
    case 'hiloOpenClose_with_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <HiloOpenCloseSeries<PerformanceData, num?>>[
            HiloOpenCloseSeries<PerformanceData, num?>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PerformanceData dat, _) => dat.x,
                lowValueMapper: (PerformanceData dat, _) => dat.sales1,
                highValueMapper: (PerformanceData dat, _) => dat.sales1! + 20,
                openValueMapper: (PerformanceData dat, _) => dat.sales1! + 10,
                closeValueMapper: (PerformanceData dat, _) => dat.sales1! + 15,
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
