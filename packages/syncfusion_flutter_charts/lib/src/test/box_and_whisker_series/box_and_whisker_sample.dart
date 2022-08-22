import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../column_series/column_sample.dart';

dynamic _boxPlotData;

/// Methods to get the box plot chart
SfCartesianChart getBoxPlotChart(String sampleName) {
  SfCartesianChart chart;
  _boxPlotData = <_BoxPlotSample>[
    _BoxPlotSample(
        DateTime(2005, 0),
        'India',
        <int>[
          22,
          22,
          23,
          25,
          25,
          25,
          26,
          27,
          27,
          28,
          28,
          29,
          30,
          32,
          34,
          32,
          34,
          36,
          35,
          38
        ],
        1,
        32,
        28,
        680,
        760,
        1,
        Colors.deepOrange),
    _BoxPlotSample(
        DateTime(2006, 0),
        'China',
        <int>[22, 33, 23, 25, 26, 28, 29, 30, 34, 33, 32, 31, 50, 52],
        2,
        24,
        44,
        550,
        880,
        2,
        Colors.deepPurple),
    _BoxPlotSample(
        DateTime(2007, 0),
        'USA',
        <int>[22, 24, 25, 30, 32, 34, 36, 38, 39, 41, 35, 36, 40, 56],
        3,
        36,
        48,
        440,
        788,
        3,
        Colors.lightGreen),
  ];

  switch (sampleName) {
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BoxAndWhiskerSeries<_BoxPlotSample, String>>[
            BoxAndWhiskerSeries<_BoxPlotSample, String>(
              dataSource: _boxPlotData,
              animationDuration: 0,
              xValueMapper: (_BoxPlotSample sales, _) => sales.category,
              yValueMapper: (_BoxPlotSample sales, _) => sales.numArr,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ]);
      break;
    case 'dataLabel_x_axis_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          series: <BoxAndWhiskerSeries<_BoxPlotSample, String>>[
            BoxAndWhiskerSeries<_BoxPlotSample, String>(
                dataSource: _boxPlotData,
                animationDuration: 0,
                xValueMapper: (_BoxPlotSample sales, _) => sales.category,
                yValueMapper: (_BoxPlotSample sales, _) => sales.numArr,
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
          series: <BoxAndWhiskerSeries<_BoxPlotSample, String>>[
            BoxAndWhiskerSeries<_BoxPlotSample, String>(
                dataSource: _boxPlotData,
                animationDuration: 0,
                xValueMapper: (_BoxPlotSample sales, _) => sales.category,
                yValueMapper: (_BoxPlotSample sales, _) => sales.numArr,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                )),
          ]);
      break;
    case 'dataLabel_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: false),
          primaryYAxis: NumericAxis(isInversed: false),
          isTransposed: true,
          series: <BoxAndWhiskerSeries<_BoxPlotSample, String>>[
            BoxAndWhiskerSeries<_BoxPlotSample, String>(
                animationDuration: 0,
                dataSource: _boxPlotData,
                xValueMapper: (_BoxPlotSample sales, _) => sales.category,
                yValueMapper: (_BoxPlotSample sales, _) => sales.numArr,
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

class _BoxPlotSample {
  _BoxPlotSample(this.year, this.category, this.numArr, this.numeric,
      this.sales1, this.sales2, this.sales3, this.sales4,
      [this.xData, this.lineColor]);
  final DateTime year;
  final String category;
  final dynamic numArr;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int? xData;
  final Color? lineColor;
}
