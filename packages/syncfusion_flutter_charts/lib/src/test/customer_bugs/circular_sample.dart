import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Methods to get the circular customer
SfCircularChart getCustomerBugCircular(String sampleName) {
  SfCircularChart chart;
  final dynamic data = <_CustomerBugCircularSample>[
    _CustomerBugCircularSample('India', 1, 32, 28, Colors.deepOrange),
    _CustomerBugCircularSample('China', 2, 24, 44, Colors.deepPurple),
    _CustomerBugCircularSample('USA', 3, 36, 48, Colors.lightGreen),
    _CustomerBugCircularSample('Japan', 4, 38, 50, Colors.red),
    _CustomerBugCircularSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'bottom_legend':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          series: <PieSeries<_CustomerBugCircularSample, String>>[
            PieSeries<_CustomerBugCircularSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.category,
              yValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.sales1,
            )
          ]);
      break;
    case 'top_legend':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(isVisible: true, position: LegendPosition.top),
          series: <PieSeries<_CustomerBugCircularSample, String>>[
            PieSeries<_CustomerBugCircularSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.category,
              yValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.sales1,
            )
          ]);
      break;
    case 'right_legend':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(isVisible: true, position: LegendPosition.right),
          series: <PieSeries<_CustomerBugCircularSample, String>>[
            PieSeries<_CustomerBugCircularSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.category,
              yValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.sales1,
            )
          ]);
      break;
    case 'left_legend':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(isVisible: true, position: LegendPosition.left),
          series: <PieSeries<_CustomerBugCircularSample, String>>[
            PieSeries<_CustomerBugCircularSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.category,
              yValueMapper: (_CustomerBugCircularSample sales, _) =>
                  sales.sales1,
            )
          ]);
      break;
    default:
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
      );
      break;
  }
  return chart;
}

class _CustomerBugCircularSample {
  _CustomerBugCircularSample(
      this.category, this.numeric, this.sales1, this.sales2,
      [this.color,
      // ignore: unused_element
      this.radius]);
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final String? radius;
  final Color? color;
}
