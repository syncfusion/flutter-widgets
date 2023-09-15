import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked column example
SfCartesianChart getStackedColumnSeries(String sampleName) {
  SfCartesianChart chart;
  final dynamic chartData1 = <StackedColumnSample>[
    StackedColumnSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    StackedColumnSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    StackedColumnSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    StackedColumnSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    StackedColumnSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic chartData2 = <StackedColumnSample>[
    StackedColumnSample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    StackedColumnSample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    StackedColumnSample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    StackedColumnSample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    StackedColumnSample(
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.red,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.red,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              enableTooltip: true,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, String>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              animationDuration: 1350,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              animationDuration: 1400,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              animationDuration: 1400,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              animationDuration: 1300,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1200,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far)),
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1300,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1350,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near)),
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1250,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              animationDuration: 1250,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              animationDuration: 1350,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1150,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1250,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'animation_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1150,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedColumnSeries<StackedColumnSample, num>(
                animationDuration: 1250,
                dataSource: <StackedColumnSample>[
                  StackedColumnSample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedColumnSample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedColumnSeries<StackedColumnSample, DateTime>>[
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            ),
            StackedColumnSeries<StackedColumnSample, DateTime>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.year,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'datalabel_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        series: <StackedColumnSeries<StackedColumnSample, String>>[
          StackedColumnSeries<StackedColumnSample, String>(
              animationDuration: 0,
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              dataLabelSettings: const DataLabelSettings(isVisible: true)),
          StackedColumnSeries<StackedColumnSample, String>(
              animationDuration: 0,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.category,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ],
      );
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                enableTooltip: true,
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumnSeries<StackedColumnSample, String>(
                enableTooltip: true,
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumnSeries<StackedColumnSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.red,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              animationDuration: 0,
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              color: Colors.blue,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.red),
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.red)
          ]);
      break;
    case 'customization_selection_initial_render':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.red),
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.red)
          ]);
      break;
    case 'customization_tracker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              isTrackVisible: true,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 2,
              trackColor: Colors.grey,
              trackPadding: 5,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              isTrackVisible: true,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.blue,
              trackBorderWidth: 2,
              trackColor: Colors.yellow,
              trackPadding: 5,
            )
          ]);
      break;
    case 'customization_track_without_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData1,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 0,
              trackColor: Colors.grey,
              trackPadding: 5,
            ),
            StackedColumnSeries<StackedColumnSample, num>(
              dataSource: chartData2,
              xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
              yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
              pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.blue,
              trackBorderWidth: 0,
              trackColor: Colors.yellow,
              trackPadding: 5,
            )
          ]);
      break;
    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                isTrackVisible: true,
                trackBorderColor: Colors.red,
                trackBorderWidth: 2,
                trackColor: Colors.grey,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.red,
                isTrackVisible: true,
                trackBorderColor: Colors.blue,
                trackBorderWidth: 2,
                trackColor: Colors.yellow,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedColumnSeries<StackedColumnSample, num>>[
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedColumnSeries<StackedColumnSample, num>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.numeric,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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
          series: <StackedColumnSeries<StackedColumnSample, String>>[
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData1,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedColumnSeries<StackedColumnSample, String>(
                dataSource: chartData2,
                xValueMapper: (StackedColumnSample sales, _) => sales.category,
                yValueMapper: (StackedColumnSample sales, _) => sales.sales1,
                pointColorMapper: (StackedColumnSample sales, _) => Colors.blue,
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

/// Represents the stacked column sample
class StackedColumnSample {
  /// Creates an instance of stacked column sample
  StackedColumnSample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4,
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

  /// Holds the line color value
  final Color? lineColor;
}
