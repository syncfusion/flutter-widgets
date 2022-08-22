import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Cartesian annotation sample
SfCartesianChart getCartesianAnnotationSample(String sampleName) {
  SfCartesianChart chart;
  switch (sampleName) {
    case 'cartesian_annotation_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        annotations: const <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Text('Annotation text'),
              coordinateUnit: CoordinateUnit.point,
              x: 2015,
              y: 27)
        ],
        series: <ChartSeries<ChartData, num>>[
          ColumnSeries<ChartData, num>(
            animationDuration: 0,
            dataSource: <ChartData>[
              ChartData(2014, 40),
              ChartData(2015, 24),
              ChartData(2016, 15),
              ChartData(2017, 25),
              ChartData(2018, 30),
            ],
            xValueMapper: (ChartData sales, _) => sales.x,
            yValueMapper: (ChartData sales, _) => sales.y,
          )
        ],
      );
      break;

    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

/// Represents chart data
class ChartData {
  /// Creates an instance for chart data
  ChartData(this.x, this.y);

  /// Holds the x value
  final double x;

  /// Holds the y value
  final double y;
}
