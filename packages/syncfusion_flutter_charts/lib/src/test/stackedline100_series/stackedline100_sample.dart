import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked line100 chart
SfCartesianChart getStackedLine100Chart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_StackedLine100Sample>[
    _StackedLine100Sample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _StackedLine100Sample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _StackedLine100Sample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _StackedLine100Sample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _StackedLine100Sample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic data1 = <_StackedLine100Sample>[
    _StackedLine100Sample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    _StackedLine100Sample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    _StackedLine100Sample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    _StackedLine100Sample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    _StackedLine100Sample(
        DateTime(2014, 0), 'Srilanka', 6.87, 34, 26, 744, 366, 7, Colors.yellow)
  ];

  switch (sampleName) {
    case 'line_customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(isVisible: true),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedLine100Sample sales, _) => Colors.red,
            ),
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedLine100Sample sales, _) => Colors.red,
            )
          ]);
      break;

    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    sales.lineColor),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    sales.lineColor)
          ]);
      break;
    case 'line_customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          title: ChartTitle(
              text: 'Line Series',
              backgroundColor: Colors.white,
              borderColor: Colors.red,
              borderWidth: 1),
          primaryXAxis: NumericAxis(isInversed: true),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                width: 3,
                color: Colors.blue,
                dashArray: const <double>[5, 3]),
            StackedLine100Series<_StackedLine100Sample, num>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                width: 3,
                color: Colors.blue,
                dashArray: const <double>[5, 3])
          ]);
      break;
    case 'customization_selection_initial_render':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: Colors.blue,
                unselectedColor: Colors.orange,
              ),
            ),
            StackedLine100Series<_StackedLine100Sample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: Colors.blue,
                unselectedColor: Colors.orange,
              ),
            )
          ]);
      break;

    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'sortingX_ascending_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1.5, null,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2.2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4.56, 38,
                      50, 350, 560, 4, Colors.red),
                  _StackedLine100Sample(DateTime(2009, 0), 'Russia', 5.87, 54,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending),
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending)
          ]);
      break;
    case 'sortingX_descending_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1.5, null,
                      28, 680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2.2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4.56, 38,
                      50, 350, 560, 4, Colors.red),
                  _StackedLine100Sample(DateTime(2009, 0), 'Russia', 5.87, 54,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings()),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, num>>[
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2005, 0), 'India', 1, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLine100Sample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLine100Sample(DateTime(2007, 0), 'USA', 3, null, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLine100Sample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedLine100Series<_StackedLine100Sample, num>(
                dataSource: <_StackedLine100Sample>[
                  _StackedLine100Sample(DateTime(2010, 0), 'Africa', 2, null,
                      48, 780, 560, 3, Colors.orange),
                  _StackedLine100Sample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLine100Sample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLine100Sample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLine100Sample sales, _) => sales.numeric,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLine100Sample sales, _) =>
                  sales.lineColor,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.category,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedLine100Series<_StackedLine100Sample, DateTime>>[
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.year,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLine100Series<_StackedLine100Sample, int?>>[
            StackedLine100Series<_StackedLine100Sample, int?>(
              dataSource: data,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.xData,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            ),
            StackedLine100Series<_StackedLine100Sample, int?>(
              dataSource: data1,
              xValueMapper: (_StackedLine100Sample sales, _) => sales.xData,
              yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
            )
          ]);
      break;
    // case 'numeric_range':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(
    //          minimum: 0, maximum: 6, interval: 1),
    //       primaryYAxis: NumericAxis(
    //           minimum: 1, maximum: 60, interval: 10),
    //       series: <StackedLine100Series<_StackedLine100Sample, int>>[
    //         StackedLine100Series<_StackedLine100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedLine100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
    //         ),
    //         StackedLine100Series<_StackedLine100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedLine100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
    //         )
    //       ]);
    //   break;
    // case 'numeric_rangePadding_Add':
    //   chart = SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //       primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
    //       series: <StackedLine100Series<_StackedLine100Sample, int>>[
    //         StackedLine100Series<_StackedLine100Sample, int>(
    //           dataSource: data,
    //           xValueMapper: (_StackedLine100Sample sales, _) => sales.xData,
    //           yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
    //           majorGridLines: const  MajorGridLines(
    //               width: 2,
    //               color: Color.fromRGBO(244, 67, 54, 1.0),
    //               dashArray: <double>[10, 20]),
    //           majorTickLines: const  MajorTickLines(
    //               size: 15,
    //               width: 2,
    //               color: Color.fromRGBO(255, 87, 34, 1.0))),
    //       primaryYAxis: NumericAxis(
    //           majorGridLines:
    //               const  MajorGridLines(width: 3, color: Colors.green, dashArray: <double>[10, 20]),
    //           majorTickLines: const  MajorTickLines(
    //               size: 15,
    //               width: 2,
    //               color: Color.fromRGBO(255, 87, 34, 1.0))),
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLine100Series<_StackedLine100Sample, String>(
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    Colors.red,
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    Colors.red,
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
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLine100Sample sales, _) =>
                    Colors.red,
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLine100Series<_StackedLine100Sample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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
          series: <StackedLine100Series<_StackedLine100Sample, String>>[
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLine100Series<_StackedLine100Sample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data1,
                xValueMapper: (_StackedLine100Sample sales, _) =>
                    sales.category,
                yValueMapper: (_StackedLine100Sample sales, _) => sales.sales1,
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

class _StackedLine100Sample {
  _StackedLine100Sample(this.year, this.category, this.numeric, this.sales1,
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
