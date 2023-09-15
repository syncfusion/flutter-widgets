import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Methods to get the spline range area chart smaple
SfCartesianChart getSplineRangeAreachart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <SplineRangeAreaData>[
    SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    SplineRangeAreaData(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    SplineRangeAreaData(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    SplineRangeAreaData(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
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
          title: ChartTitle(
              text: 'SplineRange Area Series', backgroundColor: Colors.white),
          legend: const Legend(
              position: LegendPosition.bottom,
              backgroundColor: Colors.white,
              borderColor: Colors.white,
              borderWidth: 0),
          primaryXAxis: NumericAxis(
              isInversed: false,
              labelStyle: const TextStyle(color: Colors.black),
              title: AxisTitle(
                  text: 'Year',
                  textStyle: const TextStyle(color: Colors.black))),
          primaryYAxis: NumericAxis(
            isInversed: false,
            labelStyle: const TextStyle(color: Colors.black),
            title: AxisTitle(
                text: 'Sales', textStyle: const TextStyle(color: Colors.black)),
          ),
          series: getSplineRangeAreaData());
      break;
    case 'customization_fill with tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true, format: 'point.y%'),
          legend: const Legend(isVisible: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                color: Colors.blue,
                borderColor: Colors.red,
                borderWidth: 2),
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                gradient: gradientColors)
          ]);
      break;

    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                sortFieldValueMapper: (SplineRangeAreaData sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                enableTooltip: true,
                dataSource: <SplineRangeAreaData>[
                  SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, null,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                enableTooltip: true,
                dataSource: <SplineRangeAreaData>[
                  SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, null,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                enableTooltip: true,
                dataSource: <SplineRangeAreaData>[
                  SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, null,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
                enableTooltip: true,
                dataSource: <SplineRangeAreaData>[
                  SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, 32, 28,
                      680, 760, 1, Colors.deepOrange),
                  SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48,
                      440, 788, 3, Colors.lightGreen),
                  SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50,
                      350, 560, 4, Colors.red),
                  SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, null,
                      66, 444, 566, 5, Colors.purple)
                ],
                xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
            SplineRangeAreaSeries<SplineRangeAreaData, num>(
              enableTooltip: true,
              dataSource: <SplineRangeAreaData>[
                SplineRangeAreaData(DateTime(2005, 0), 'India', 1.5, null, 28,
                    680, 760, 1, Colors.deepOrange),
                SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, null, 44,
                    550, 880, 2, Colors.deepPurple),
                SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, null, 48,
                    440, 788, 3, Colors.lightGreen),
                SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, null, 50,
                    350, 560, 4, Colors.red),
                SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                    444, 566, 5, Colors.purple)
              ],
              xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_EdgeLabelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_title':
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_SplineRange':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_rangepadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_RangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_RangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_RangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, int>>[
            SplineRangeAreaSeries<SplineRangeAreaData, int>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.xData,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_SplineRange':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_rangePadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_RangePadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
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
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, DateTime>>[
            SplineRangeAreaSeries<SplineRangeAreaData, DateTime>(
              dataSource: data,
              xValueMapper: (SplineRangeAreaData sales, _) => sales.year,
              lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
              highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                animationDuration: 0,
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
    case 'marker_PointColormapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_EmptyPoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
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
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_mapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <SplineRangeAreaSeries<SplineRangeAreaData, String>>[
            SplineRangeAreaSeries<SplineRangeAreaData, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'borderMode_all':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<SplineRangeAreaData, dynamic>>[
            SplineRangeAreaSeries<SplineRangeAreaData, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                borderColor: Colors.red,
                borderWidth: 3)
          ]);
      break;
    case 'borderMode_excludeSide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<SplineRangeAreaData, dynamic>>[
            SplineRangeAreaSeries<SplineRangeAreaData, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (SplineRangeAreaData sales, _) => sales.category,
                lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
                highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
                borderColor: Colors.red,
                borderWidth: 3,
                borderDrawMode: RangeAreaBorderMode.excludeSides)
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

/// Method to get the spline range area data
List<SplineRangeAreaSeries<SplineRangeAreaData, num>> getSplineRangeAreaData() {
  final dynamic chartData = <SplineRangeAreaData>[
    SplineRangeAreaData(
        DateTime(2005, 0), 'India', 1.5, null, 28, 680, 7601, 1),
    SplineRangeAreaData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    SplineRangeAreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    SplineRangeAreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    SplineRangeAreaData(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    SplineRangeAreaData(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    SplineRangeAreaData(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <SplineRangeAreaSeries<SplineRangeAreaData, num>>[
    SplineRangeAreaSeries<SplineRangeAreaData, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (SplineRangeAreaData sales, _) => sales.numeric,
      lowValueMapper: (SplineRangeAreaData sales, _) => sales.sales1,
      highValueMapper: (SplineRangeAreaData sales, _) => sales.sales2,
      color: Colors.green,
      markerSettings: const MarkerSettings(
          isVisible: true,
          height: 4,
          width: 4,
          shape: DataMarkerType.circle,
          borderWidth: 3,
          borderColor: Colors.red),
      dataLabelSettings: const DataLabelSettings(isVisible: true),
      emptyPointSettings:
          EmptyPointSettings(color: Colors.black, mode: EmptyPointMode.drop),
    ),
  ];
}

/// Represents the spline range area data
class SplineRangeAreaData {
  /// Creates an instance of spline range area data
  SplineRangeAreaData(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4, this.xData,
      [this.lineColor]);

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

  ///Holds the sales4 value
  final int sales4;

  /// Holds the xData value
  final int xData;

  /// Holds the line color value
  final Color? lineColor;
}
