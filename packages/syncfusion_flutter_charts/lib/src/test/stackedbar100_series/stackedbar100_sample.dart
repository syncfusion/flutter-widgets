import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked bar 100 chart sample
SfCartesianChart getStackedBar100Chart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_StackedBar100Sample>[
    _StackedBar100Sample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _StackedBar100Sample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _StackedBar100Sample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _StackedBar100Sample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _StackedBar100Sample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic data1 = <_StackedBar100Sample>[
    _StackedBar100Sample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    _StackedBar100Sample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    _StackedBar100Sample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    _StackedBar100Sample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    _StackedBar100Sample(
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
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 3,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 3,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) =>
                    sales.lineColor),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) =>
                    sales.lineColor)
          ]);
      break;
    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) =>
                    Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) =>
                    Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              animationDuration: 1400,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              animationDuration: 1300,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'animation_transpose_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1200,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far)),
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1300,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1350,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near)),
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data,
              animationDuration: 1250,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, num>(
              dataSource: data1,
              animationDuration: 1350,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1150,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'animation_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1150,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, -24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, num>(
                animationDuration: 1250,
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, -32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, -36, 48,
                      440, 788, 3, Colors.lightGreen),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedBar100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings()),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedBar100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedBar100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedBar100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedBar100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedBar100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedBar100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedBar100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedBar100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedBar100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedBar100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedBar100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedBar100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedBar100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedBar100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedBar100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, num>>[
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2005, 0), 'India', 1, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedBar100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedBar100Sample(DateTime(2007, 0), 'USA', 3, null, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedBar100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedBar100Series<_StackedBar100Sample, num>(
                dataSource: <_StackedBar100Sample>[
                  _StackedBar100Sample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedBar100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedBar100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedBar100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedBar100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedBar100Sample sales, _) =>
                  sales.lineColor,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedBar100Series<_StackedBar100Sample, DateTime>>[
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.year,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedBar100Series<_StackedBar100Sample, int?>>[
            StackedBar100Series<_StackedBar100Sample, int?>(
              dataSource: data,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.xData,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            ),
            StackedBar100Series<_StackedBar100Sample, int?>(
              dataSource: data1,
              xValueMapper: (_StackedBar100Sample sales, _) => sales.xData,
              yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    // case 'numeric_range':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //          minimum: 0, maximum: 6, interval: 1),
    //       primaryYAxis: NumericAxis(
    //           minimum: 1, maximum: 60, interval: 10),
    //       series: <StackedBar100Series<_StackedBar100Sample, int>>[
    //         StackedBar100Series<_StackedBar100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedBar100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
    //         ),
    //         StackedBar100Series<_StackedBar100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedBar100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
    //         )
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Add':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       series: <StackedBar100Series<_StackedBar100Sample, int>>[
    //         StackedBar100Series<_StackedBar100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedBar100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Normal':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Round':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Auto':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_rangePadding_None':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_edgelabelPlacement_hide':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis:
    //           NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
    //       primaryYAxis:
    //           NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_axisLine_title':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //           axisLine: const AxisLine(color: Colors.red, width: 3, dashArray: <double>[10, 20]),
    //           title: AxisTitle(
    //               text: 'Primary X Axis',
    //               textStyle: const TextStyle(fontSize: 15),
    //               alignment: ChartAlignment.center)),
    //       primaryYAxis: NumericAxis(
    //           axisLine: const AxisLine(color: Colors.red, width: 3, dashArray: <double>[10 ,20]),
    //           title: AxisTitle(
    //               text: 'Primary Y Axis',
    //               textStyle: const TextStyle(fontSize: 15),
    //               alignment: ChartAlignment.center)),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_inversed':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(isInversed: true),
    //       primaryYAxis: NumericAxis(isInversed: true),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_opposed':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(opposedPosition: true),
    //       primaryYAxis: NumericAxis(opposedPosition: true),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_gridlines':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //           majorGridLines: const MajorGridLines(
    //               width: 2,
    //               color: const Color.fromRGBO(244, 67, 54, 1.0),
    //               dashArray: <double>[10, 20]),
    //           majorTickLines: const MajorTickLines(
    //               size: 15,
    //               width: 2,
    //               color: const Color.fromRGBO(255, 87, 34, 1.0))),
    //       primaryYAxis: NumericAxis(
    //           majorGridLines:
    //               const MajorGridLines(width: 3, color: Colors.green, dashArray: <double>[10, 20]),
    //           majorTickLines: const MajorTickLines(
    //               size: 15,
    //               width: 2,
    //               color: const Color.fromRGBO(255, 87, 34, 1.0))),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_labelStyle':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //           labelStyle: const TextStyle(
    //               color: Colors.red,
    //               fontSize: 12,
    //               fontStyle: FontStyle.italic)),
    //       primaryYAxis: NumericAxis(
    //           labelStyle: const TextStyle(
    //               color: Colors.green,
    //               fontSize: 12,
    //               fontStyle: FontStyle.italic)),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    // case 'numeric_axisVisible':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(isVisible: false),
    //       primaryYAxis: NumericAxis(isVisible: false),
    //       series: <BarSeries<_BarSample, int>>[
    //         BarSeries<_BarSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_BarSample sales, _) => sales.xData,
    //           yValueMapper: (_BarSample sales, _) => sales.sales1,
    //         ),
    //       ]);
    //   break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, String>(
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
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
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedBar100Sample sales, _) => Colors.red,
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
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
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
          series: <StackedBar100Series<_StackedBar100Sample, String>>[
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedBar100Series<_StackedBar100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data1,
                xValueMapper: (_StackedBar100Sample sales, _) => sales.category,
                yValueMapper: (_StackedBar100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }

  return chart;
}

class _StackedBar100Sample {
  _StackedBar100Sample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4,
      [this.xData, this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int? sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int? xData;
  final Color? lineColor;
}
