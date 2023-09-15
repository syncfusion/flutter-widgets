import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked column100 chart sample
SfCartesianChart getStackedColumn100Series(String sampleName) {
  SfCartesianChart chart;
  final dynamic chartData1 = <_StackedColumn100Sample>[
    _StackedColumn100Sample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _StackedColumn100Sample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _StackedColumn100Sample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _StackedColumn100Sample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _StackedColumn100Sample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic chartData2 = <_StackedColumn100Sample>[
    _StackedColumn100Sample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    _StackedColumn100Sample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    _StackedColumn100Sample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    _StackedColumn100Sample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    _StackedColumn100Sample(
        DateTime(2014, 0), 'Srilanka', 6.87, 34, 26, 744, 366, 7, Colors.yellow)
  ];
  final List<Color> color = <Color>[];
  color.add(Colors.pink[50]!);
  color.add(Colors.pink[200]!);
  color.add(Colors.pink);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
      LinearGradient(colors: color, stops: stops);
  switch (sampleName) {
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.red,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.red,
            )
          ]);
      break;
    case 'category_EdgeLabelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            )
          ]);
      break;
    case 'category_label_tickPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPosition: ChartDataLabelPosition.inside,
            tickPosition: TickPosition.inside,
          ),
          primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.inside,
            tickPosition: TickPosition.inside,
          ),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            )
          ]);
      break;
    case 'category_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            )
          ]);
      break;
    case 'category_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_axisTitle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, String>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              animationDuration: 1350,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData2,
              animationDuration: 1400,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              animationDuration: 1400,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData2,
              animationDuration: 1300,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1200,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, -24,
                      44, 550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far)),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1300,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, -32,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far))
          ]);
      break;
    case 'animation_transpose_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1350,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, -24,
                      44, 550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near)),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, -32,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near))
          ]);
      break;
    case 'animation_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              animationDuration: 1250,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData2,
              animationDuration: 1350,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1150,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, -24,
                      44, 550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, -32,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'animation_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1150,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, -24,
                      44, 550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedColumn100Sample>[
                  _StackedColumn100Sample(DateTime(2005, 0), 'India', 1, -32,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedColumn100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedColumn100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedColumn100Series<_StackedColumn100Sample, DateTime>>[
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            ),
            StackedColumn100Series<_StackedColumn100Sample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.year,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'datalabel_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
          StackedColumn100Series<_StackedColumn100Sample, String>(
              animationDuration: 0,
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              dataLabelSettings: const DataLabelSettings(isVisible: true)),
          StackedColumn100Series<_StackedColumn100Sample, String>(
              animationDuration: 0,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) =>
                  sales.category,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ],
      );
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                enableTooltip: true,
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                enableTooltip: true,
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_mapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.red,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
              animationDuration: 0,
              dataSource: chartData2,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              color: Colors.blue,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.red,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.red),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.red)
          ]);
      break;
    case 'customization_selection_initial_render':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.red),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.red)
          ]);
      break;
    case 'customization_tracker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
              dataSource: chartData1,
              xValueMapper: (_StackedColumn100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedColumn100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedColumn100Sample sales, _) =>
                  Colors.blue,
            ),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue)
          ]);
      break;
    case 'customization_track_without_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue)
          ]);
      break;
    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.red,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumn100Series<_StackedColumn100Sample, num>>[
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                gradient: gradientColors),
            StackedColumn100Series<_StackedColumn100Sample, num>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.numeric,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_PointColormapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_EmptyPoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero, color: Colors.green),
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero, color: Colors.green),
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_rect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_pentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_verticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_invertTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_triangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumn100Series<_StackedColumn100Sample, String>>[
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData1,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumn100Series<_StackedColumn100Sample, String>(
                dataSource: chartData2,
                xValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedColumn100Sample sales, _) =>
                    sales.sales1,
                pointColorMapper: (_StackedColumn100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
      break;
  }
  return chart;
}

class _StackedColumn100Sample {
  _StackedColumn100Sample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4,
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
