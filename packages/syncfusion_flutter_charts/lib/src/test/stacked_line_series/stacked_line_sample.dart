import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked line chart sample
SfCartesianChart getStackedLineChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_StackedLineSample>[
    _StackedLineSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _StackedLineSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _StackedLineSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _StackedLineSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _StackedLineSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic data1 = <_StackedLineSample>[
    _StackedLineSample(
        DateTime(2010, 0), 'Africa', 2, 42, 48, 780, 560, 3, Colors.orange),
    _StackedLineSample(
        DateTime(2011, 0), 'America', 3, 34, 40, 500, 780, 4, Colors.purple),
    _StackedLineSample(
        DateTime(2012, 0), 'Swiss', 4, 46, 58, 440, 408, 5, Colors.green),
    _StackedLineSample(
        DateTime(2013, 0), 'Aus', 5.56, 58, 30, 350, 360, 6, Colors.blue),
    _StackedLineSample(
        DateTime(2014, 0), 'Srilanka', 6.87, 34, 26, 744, 366, 7, Colors.yellow)
  ];

  switch (sampleName) {
    case 'line_customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
            ),
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
            )
          ]);
      break;

    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) =>
                    sales.lineColor),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                width: 3,
                color: Colors.blue,
                dashArray: const <double>[5, 3]),
            StackedLineSeries<_StackedLineSample, num>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                width: 3,
                color: Colors.blue,
                dashArray: const <double>[5, 3])
          ]);
      break;
    case 'customization_selection_initial_render':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: Colors.blue,
                unselectedColor: Colors.orange,
              ),
            ),
            StackedLineSeries<_StackedLineSample, num>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'sortingX_ascending_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1.5, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  _StackedLineSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending),
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending)
          ]);
      break;
    case 'sortingX_descending_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1.5, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  _StackedLineSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StackedLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings()),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, num>>[
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2005, 0), 'India', 1, null, 28,
                      680, 760, 1, Colors.deepOrange),
                  _StackedLineSample(DateTime(2006, 0), 'China', 2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StackedLineSample(DateTime(2007, 0), 'USA', 3, null, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StackedLineSample(DateTime(2008, 0), 'Japan', 4, null, 50,
                      350, 560, 4, Colors.red),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
            StackedLineSeries<_StackedLineSample, num>(
                dataSource: <_StackedLineSample>[
                  _StackedLineSample(DateTime(2010, 0), 'Africa', 2, null, 48,
                      780, 560, 3, Colors.orange),
                  _StackedLineSample(DateTime(2011, 0), 'America', 3, 34, 40,
                      500, 780, 4, Colors.purple),
                  _StackedLineSample(DateTime(2012, 0), 'Swiss', 4, null, 58,
                      440, 408, 5, Colors.green),
                  _StackedLineSample(DateTime(2013, 0), 'Aus', 5.56, 58, 30,
                      350, 360, 6, Colors.blue),
                ],
                xValueMapper: (_StackedLineSample sales, _) => sales.numeric,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StackedLineSample sales, _) =>
                  sales.lineColor,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, String>(
              enableTooltip: true,
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.category,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StackedLineSeries<_StackedLineSample, DateTime>>[
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, DateTime>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.year,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StackedLineSeries<_StackedLineSample, int?>>[
            StackedLineSeries<_StackedLineSample, int?>(
              dataSource: data,
              xValueMapper: (_StackedLineSample sales, _) => sales.xData,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            ),
            StackedLineSeries<_StackedLineSample, int?>(
              dataSource: data1,
              xValueMapper: (_StackedLineSample sales, _) => sales.xData,
              yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLineSeries<_StackedLineSample, String>(
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.blue,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
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
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data1,
                animationDuration: 0,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StackedLineSample sales, _) => Colors.red,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLineSeries<_StackedLineSample, String>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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
          series: <StackedLineSeries<_StackedLineSample, String>>[
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
            StackedLineSeries<_StackedLineSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data1,
                xValueMapper: (_StackedLineSample sales, _) => sales.category,
                yValueMapper: (_StackedLineSample sales, _) => sales.sales1,
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

class _StackedLineSample {
  _StackedLineSample(this.year, this.category, this.numeric, this.sales1,
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
