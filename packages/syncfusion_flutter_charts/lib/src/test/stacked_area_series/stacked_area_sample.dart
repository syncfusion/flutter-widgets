import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked area chart sample
SfCartesianChart getStackedAreaChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <StackedAreaSample>[
    StackedAreaSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    StackedAreaSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    StackedAreaSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    StackedAreaSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    StackedAreaSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic data1 = <StackedAreaSample>[
    StackedAreaSample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    StackedAreaSample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    StackedAreaSample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    StackedAreaSample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    StackedAreaSample(
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
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(isVisible: true),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
            ),
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 3,
            ),
            StackedAreaSeries<StackedAreaSample, num>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 3,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor)
          ]);
      break;

    case 'customization_border_all':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.all,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.all,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'customization_border_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'customization_border_excludeBottom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.excludeBottom,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedAreaSeries<StackedAreaSample, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.excludeBottom,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;

    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;

    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                sortFieldValueMapper: (StackedAreaSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
            StackedAreaSeries<StackedAreaSample, String>(
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                sortFieldValueMapper: (StackedAreaSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  StackedAreaSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedAreaSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  StackedAreaSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings()),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  StackedAreaSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  StackedAreaSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  StackedAreaSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350,
                      360, 6, Colors.blue),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  StackedAreaSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedAreaSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  StackedAreaSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  StackedAreaSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  StackedAreaSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  StackedAreaSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350,
                      360, 6, Colors.blue),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  StackedAreaSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedAreaSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  StackedAreaSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  StackedAreaSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  StackedAreaSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  StackedAreaSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350,
                      360, 6, Colors.blue),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  StackedAreaSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedAreaSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  StackedAreaSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  StackedAreaSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  StackedAreaSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  StackedAreaSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350,
                      360, 6, Colors.blue),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, num>>[
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2005, 0), 'India', 1, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  StackedAreaSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  StackedAreaSample(DateTime(2007, 0), 'USA', 3, null, 48, 440,
                      788, 3, Colors.lightGreen),
                  StackedAreaSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
            StackedAreaSeries<StackedAreaSample, num>(
                dataSource: <StackedAreaSample>[
                  StackedAreaSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  StackedAreaSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  StackedAreaSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  StackedAreaSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350,
                      360, 6, Colors.blue),
                ],
                xValueMapper: (StackedAreaSample sales, _) => sales.numeric,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              pointColorMapper: (StackedAreaSample sales, _) => sales.lineColor,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
              pointColorMapper: (StackedAreaSample sales, _) => sales.lineColor,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor)
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor)
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor)
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) =>
                    sales.lineColor)
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, String>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.category,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedAreaSeries<StackedAreaSample, DateTime>>[
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, DateTime>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.year,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedAreaSeries<StackedAreaSample, int?>>[
            StackedAreaSeries<StackedAreaSample, int?>(
              dataSource: data,
              xValueMapper: (StackedAreaSample sales, _) => sales.xData,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            ),
            StackedAreaSeries<StackedAreaSample, int?>(
              dataSource: data1,
              xValueMapper: (StackedAreaSample sales, _) => sales.xData,
              yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
            )
          ]);
      break;
    // case 'numeric_range':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //          minimum: 0, maximum: 6, interval: 1),
    //       primaryYAxis: NumericAxis(
    //           minimum: 1, maximum: 60, interval: 10),
    //       series: <StackedAreaSeries<_StackedAreaSample, int>>[
    //         StackedAreaSeries<_StackedAreaSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedAreaSample sales, _) => sales.xData,
    //           yValueMapper: (_StackedAreaSample sales, _) => sales.sales1,
    //         ),
    //         StackedAreaSeries<_StackedAreaSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedAreaSample sales, _) => sales.xData,
    //           yValueMapper: (_StackedAreaSample sales, _) => sales.sales1,
    //         )
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Add':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       series: <StackedAreaSeries<_StackedAreaSample, int>>[
    //         StackedAreaSeries<_StackedAreaSample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedAreaSample sales, _) => sales.xData,
    //           yValueMapper: (_StackedAreaSample sales, _) => sales.sales1,
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
    //           majorGridLines: const  const MajorGridLines(
    //               width: 2,
    //               color: const Color.fromRGBO(244, 67, 54, 1.0),
    //               dashArray: <double>[10, 20]),
    //           majorTickLines: const MajorTickLines(
    //               size: 15,
    //               width: 2,
    //               color: const Color.fromRGBO(255, 87, 34, 1.0))),
    //       primaryYAxis: NumericAxis(
    //           majorGridLines:
    //               const  const MajorGridLines(width: 3, color: Colors.green, dashArray: <double>[10, 20]),
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedAreaSeries<StackedAreaSample, String>(
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.blue,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
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
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                pointColorMapper: (StackedAreaSample sales, _) => Colors.red,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedAreaSeries<StackedAreaSample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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
          series: <StackedAreaSeries<StackedAreaSample, String>>[
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedAreaSeries<StackedAreaSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data1,
                xValueMapper: (StackedAreaSample sales, _) => sales.category,
                yValueMapper: (StackedAreaSample sales, _) => sales.sales1,
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

/// Represents the stacked area sample
class StackedAreaSample {
  /// Creates an instance of stacked area sample
  StackedAreaSample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4,
      [this.xData, this.lineColor]);

  /// Holds the year value
  final DateTime year;

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the sales1 value
  final int? sales1;

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
