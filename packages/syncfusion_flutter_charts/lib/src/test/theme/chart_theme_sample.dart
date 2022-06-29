import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the theme chart data
SfCartesianChart getThemechart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_ThemeSample>[
    _ThemeSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _ThemeSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _ThemeSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _ThemeSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _ThemeSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  switch (sampleName) {
    case 'sample':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          title: ChartTitle(
            text: 'Chart Title',
            borderWidth: 1.0,
            // borderColor: null,
          ),
          primaryXAxis: NumericAxis(
            title: AxisTitle(text: 'X Axis'),
            axisLine: const AxisLine(width: 2),
            majorGridLines: const MajorGridLines(width: 2),
            majorTickLines: const MajorTickLines(width: 2, size: 10),
            minorGridLines: const MinorGridLines(width: 2),
            minorTickLines: const MinorTickLines(width: 2, size: 10),
            minorTicksPerInterval: 2,
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Y Axis'),
            axisLine: const AxisLine(width: 2),
            majorGridLines: const MajorGridLines(width: 2),
            majorTickLines: const MajorTickLines(width: 2, size: 10),
            minorGridLines: const MinorGridLines(width: 2),
            minorTickLines: const MinorTickLines(width: 2, size: 10),
            minorTicksPerInterval: 2,
          ),
          legend:
              Legend(isVisible: true, title: LegendTitle(text: 'Legend Title')),
          crosshairBehavior: CrosshairBehavior(enable: true),
          tooltipBehavior:
              TooltipBehavior(enable: true, header: 'Tooltip Header'),
          series: <ColumnSeries<_ThemeSample, int?>>[
            ColumnSeries<_ThemeSample, int?>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_ThemeSample sales, _) => sales.xData,
                yValueMapper: (_ThemeSample sales, _) => sales.sales1,
                selectionBehavior: SelectionBehavior(enable: true)),
          ]);
      break;
    default:
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          backgroundColor: Colors.grey,
          plotAreaBackgroundColor: Colors.grey,
          title: ChartTitle(
              text: 'Chart Title',
              textStyle: const TextStyle(color: Colors.red),
              backgroundColor: Colors.deepOrange),
          primaryXAxis: NumericAxis(
            labelStyle: const TextStyle(color: Colors.green),
            title: AxisTitle(
              text: 'X Axis',
              textStyle: const TextStyle(color: Colors.blue),
            ),
            axisLine: const AxisLine(width: 2, color: Colors.indigo),
            majorGridLines:
                const MajorGridLines(width: 2, color: Colors.deepOrange),
            majorTickLines: const MajorTickLines(
                width: 2, size: 10, color: Colors.deepPurple),
            minorGridLines:
                const MinorGridLines(width: 2, color: Colors.deepPurple),
            minorTickLines: const MinorTickLines(
                width: 2, size: 10, color: Colors.deepPurple),
            minorTicksPerInterval: 2,
          ),
          primaryYAxis: NumericAxis(
            labelStyle: const TextStyle(color: Colors.green),
            title: AxisTitle(
              text: 'Y Axis',
              textStyle: const TextStyle(color: Colors.blue),
            ),
            axisLine: const AxisLine(width: 2, color: Colors.indigo),
            majorGridLines:
                const MajorGridLines(width: 2, color: Colors.deepOrange),
            majorTickLines: const MajorTickLines(
                width: 2, size: 10, color: Colors.deepPurple),
            minorGridLines:
                const MinorGridLines(width: 2, color: Colors.deepPurple),
            minorTickLines: const MinorTickLines(
                width: 2, size: 10, color: Colors.deepPurple),
            minorTicksPerInterval: 2,
          ),
          legend: Legend(
              isVisible: true,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              iconBorderColor: Colors.blue,
              title: LegendTitle(text: 'Legend Title')),
          crosshairBehavior:
              CrosshairBehavior(enable: true, lineColor: Colors.green),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              header: 'Tooltip Header',
              color: Colors.red,
              borderColor: Colors.black),
          series: <ColumnSeries<_ThemeSample, int?>>[
            ColumnSeries<_ThemeSample, int?>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_ThemeSample sales, _) => sales.xData,
                yValueMapper: (_ThemeSample sales, _) => sales.sales1,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.orange,
                    unselectedColor: Colors.black.withOpacity(0.4))),
          ]);
  }

  return chart;
}

class _ThemeSample {
  _ThemeSample(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4,
      [this.xData, this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int? xData;
  final Color? lineColor;
}
