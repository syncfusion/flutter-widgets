import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the cartesian tile sample
SfCartesianChart getCartesianTitleSample(String sampleName) {
  SfCartesianChart chart;
  final List<_ChartTitleData> chartData = <_ChartTitleData>[
    _ChartTitleData(2014, 40),
    _ChartTitleData(2015, 24),
    _ChartTitleData(2016, 15),
    _ChartTitleData(2017, 25),
    _ChartTitleData(2018, 30),
  ];
  switch (sampleName) {
    case 'cartesian_title_default_style':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <ChartSeries<_ChartTitleData, num>>[
          ColumnSeries<_ChartTitleData, num>(
            animationDuration: 0,
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
          )
        ],
      );
      break;
    case 'title_near_Alignment':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            alignment: ChartAlignment.near,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <ChartSeries<_ChartTitleData, num>>[
          ColumnSeries<_ChartTitleData, num>(
            animationDuration: 0,
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
          )
        ],
      );
      break;
    case 'title_far_Alignment':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            alignment: ChartAlignment.far,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <ChartSeries<_ChartTitleData, num>>[
          ColumnSeries<_ChartTitleData, num>(
            animationDuration: 0,
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
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

/// Method to get the circular title chart
SfCircularChart getCircularTitleChart(String sampleName) {
  SfCircularChart chart;
  final List<_ChartTitleData> chartData = <_ChartTitleData>[
    _ChartTitleData(2014, 40),
    _ChartTitleData(2015, 24),
    _ChartTitleData(2016, 15),
    _ChartTitleData(2017, 25),
    _ChartTitleData(2018, 30),
  ];
  switch (sampleName) {
    case 'circular_title_default_style':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <PieSeries<_ChartTitleData, num>>[
          PieSeries<_ChartTitleData, num>(
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
          )
        ],
      );
      break;
    case 'circular_title_near_Alignment':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            alignment: ChartAlignment.near,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <PieSeries<_ChartTitleData, num>>[
          PieSeries<_ChartTitleData, num>(
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
          )
        ],
      );
      break;
    case 'circular_title_far_Alignment':
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
        title: ChartTitle(
            text: 'Half yearly sales analysis',
            backgroundColor: Colors.lightGreen,
            borderColor: Colors.blue,
            borderWidth: 2,
            alignment: ChartAlignment.far,
            textStyle: const TextStyle(
              color: Colors.red,
              fontFamily: 'Roboto',
              fontStyle: FontStyle.italic,
              fontSize: 14,
            )),
        series: <PieSeries<_ChartTitleData, num>>[
          PieSeries<_ChartTitleData, num>(
            dataSource: chartData,
            xValueMapper: (_ChartTitleData sales, _) => sales.x,
            yValueMapper: (_ChartTitleData sales, _) => sales.y,
          )
        ],
      );
      break;
    default:
      chart = SfCircularChart(
        key: GlobalKey<State<SfCircularChart>>(),
      );
  }
  return chart;
}

class _ChartTitleData {
  _ChartTitleData(this.x, this.y);
  final double x;
  final double y;
}
