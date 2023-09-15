import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the chart sample
SfCartesianChart getChartSample(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <ChartSample>[
    ChartSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    ChartSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    ChartSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    ChartSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    ChartSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  switch (sampleName) {
    case 'size':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          backgroundColor: Colors.blueGrey,
          title: ChartTitle(text: 'Chart Title'),
          legend: const Legend(isVisible: true),
          primaryXAxis: NumericAxis(title: AxisTitle(text: 'X Axis')),
          primaryYAxis: NumericAxis(title: AxisTitle(text: 'Y Axis')),
          series: <LineSeries<ChartSample, int?>>[
            LineSeries<ChartSample, int?>(
              dataSource: data,
              xValueMapper: (ChartSample sales, _) => sales.xData,
              yValueMapper: (ChartSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    default:
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend:
              const Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<ChartSample, int?>>[
            LineSeries<ChartSample, int?>(
              dataSource: data,
              xValueMapper: (ChartSample sales, _) => sales.xData,
              yValueMapper: (ChartSample sales, _) => sales.sales1,
            ),
          ]);
  }

  return chart;
}

/// Represents the chart sample
class ChartSample {
  /// Creates an instance of chart sample
  ChartSample(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4,
      [this.xData, this.lineColor]);

  /// Holds the year value
  final DateTime year;

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the sales1 value
  final int sales1;

  /// Holds the sales2 value
  final int sales2;

  /// Holds the sales3 value
  final int sales3;

  /// Holds the sales4 value
  final int sales4;

  /// Holds the xData value
  final int? xData;

  /// Holds the line color
  final Color? lineColor;
}
