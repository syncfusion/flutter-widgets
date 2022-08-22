import 'package:flutter/material.dart';
import '../../../charts.dart';

dynamic _waterfallData;

/// To get the waterfall chart
SfCartesianChart getWaterfallChart(String sampleName) {
  SfCartesianChart chart;
  _waterfallData = <_WaterfallData>[
    _WaterfallData(2, 10, Colors.red),
    _WaterfallData(3, -3, Colors.green),
    _WaterfallData(4, 5, Colors.red, true),
    _WaterfallData(5, 4, Colors.blue),
    _WaterfallData(6, -2, Colors.red),
    _WaterfallData(7, -5, Colors.red, true),
    _WaterfallData(8, -10, Colors.red),
    _WaterfallData(9, 8, Colors.red),
    _WaterfallData(10, 8, Colors.red),
    _WaterfallData(11, 5, Colors.red),
    _WaterfallData(12, 8, Colors.red, false),
    _WaterfallData(13, -5, Colors.red, false, true),
  ];

  switch (sampleName) {
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
                dataSource: _waterfallData,
                animationDuration: 0,
                xValueMapper: (_WaterfallData sales, _) => sales.x,
                yValueMapper: (_WaterfallData sales, _) => sales.y,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
              dataSource: _waterfallData,
              animationDuration: 0,
              xValueMapper: (_WaterfallData sales, _) => sales.x,
              yValueMapper: (_WaterfallData sales, _) => sales.y,
              markerSettings: const MarkerSettings(
                  isVisible: true,
                  color: Colors.deepOrange,
                  width: 10,
                  height: 10),
            )
          ]);
      break;
    case 'marker_intermediate_sum':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
              dataSource: _waterfallData,
              animationDuration: 0,
              xValueMapper: (_WaterfallData sales, _) => sales.x,
              yValueMapper: (_WaterfallData sales, _) => sales.y,
              intermediateSumPredicate: (_WaterfallData sales, _) =>
                  sales.isIntermediateSum,
              markerSettings: const MarkerSettings(isVisible: true),
            )
          ]);
      break;
    case 'marker_total_sum':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
              dataSource: _waterfallData,
              animationDuration: 0,
              xValueMapper: (_WaterfallData sales, _) => sales.x,
              yValueMapper: (_WaterfallData sales, _) => sales.y,
              totalSumPredicate: (_WaterfallData sales, _) => sales.isTotalSum,
              markerSettings: const MarkerSettings(isVisible: true),
            )
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
              dataSource: _waterfallData,
              animationDuration: 0,
              xValueMapper: (_WaterfallData sales, _) => sales.x,
              yValueMapper: (_WaterfallData sales, _) => sales.y,
              intermediateSumPredicate: (_WaterfallData sales, _) =>
                  sales.isIntermediateSum,
              totalSumPredicate: (_WaterfallData sales, _) => sales.isTotalSum,
              connectorLineSettings:
                  const WaterfallConnectorLineSettings(width: 1.5),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ]);
      break;
    case 'dataLabel_x_axis_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
                dataSource: _waterfallData,
                animationDuration: 0,
                xValueMapper: (_WaterfallData sales, _) => sales.x,
                yValueMapper: (_WaterfallData sales, _) => sales.y,
                intermediateSumPredicate: (_WaterfallData sales, _) =>
                    sales.isIntermediateSum,
                totalSumPredicate: (_WaterfallData sales, _) =>
                    sales.isTotalSum,
                connectorLineSettings:
                    const WaterfallConnectorLineSettings(width: 1.5),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ))
          ]);
      break;
    case 'dataLabel_y_axis_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
                dataSource: _waterfallData,
                animationDuration: 0,
                xValueMapper: (_WaterfallData sales, _) => sales.x,
                yValueMapper: (_WaterfallData sales, _) => sales.y,
                intermediateSumPredicate: (_WaterfallData sales, _) =>
                    sales.isIntermediateSum,
                totalSumPredicate: (_WaterfallData sales, _) =>
                    sales.isTotalSum,
                connectorLineSettings:
                    const WaterfallConnectorLineSettings(width: 1.5),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                )),
          ]);
      break;
    case 'dataLabel_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <WaterfallSeries<_WaterfallData, num>>[
            WaterfallSeries<_WaterfallData, num>(
                animationDuration: 0,
                dataSource: _waterfallData,
                xValueMapper: (_WaterfallData sales, _) => sales.x,
                yValueMapper: (_WaterfallData sales, _) => sales.y,
                intermediateSumPredicate: (_WaterfallData sales, _) =>
                    sales.isIntermediateSum,
                totalSumPredicate: (_WaterfallData sales, _) =>
                    sales.isTotalSum,
                connectorLineSettings:
                    const WaterfallConnectorLineSettings(width: 1.5),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                )),
          ]);
      break;
    default:
      chart = SfCartesianChart();
  }

  return chart;
}

class _WaterfallData {
  _WaterfallData(this.x, this.y, this.color,
      [this.isIntermediateSum, this.isTotalSum]);
  final num x;
  final num y;
  final Color color;
  final bool? isIntermediateSum;
  final bool? isTotalSum;
}
