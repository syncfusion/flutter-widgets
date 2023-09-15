import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the area series chart
SfCartesianChart getAreachart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <AreaData>[
    AreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    AreaData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    AreaData(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    AreaData(
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
          title: ChartTitle(text: 'Line Series', backgroundColor: Colors.white),
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
          series: _getDefaultData());
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: const Legend(isVisible: true),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                color: Colors.blue,
                borderColor: Colors.red,
                borderWidth: 2),
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1),
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'customization_border_all':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.all,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'customization_border_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'customization_border_excludeBottom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                borderColor: Colors.red,
                borderWidth: 2,
                borderDrawMode: BorderDrawMode.excludeBottom,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                sortFieldValueMapper: (AreaData sales, _) => sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: <AreaData>[
                  AreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  AreaData(DateTime(2006, 0), 'China', 2.2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                      4, Colors.red),
                  AreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                      566, 5, Colors.purple)
                ],
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: <AreaData>[
                  AreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  AreaData(DateTime(2006, 0), 'China', 2.2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                      4, Colors.red),
                  AreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                      566, 5, Colors.purple)
                ],
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: <AreaData>[
                  AreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  AreaData(DateTime(2006, 0), 'China', 2.2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                      4, Colors.red),
                  AreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                      566, 5, Colors.purple)
                ],
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
                enableTooltip: true,
                dataSource: <AreaData>[
                  AreaData(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  AreaData(DateTime(2006, 0), 'China', 2.2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                      4, Colors.red),
                  AreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                      566, 5, Colors.purple)
                ],
                xValueMapper: (AreaData sales, _) => sales.numeric,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, num>>[
            AreaSeries<AreaData, num>(
              enableTooltip: true,
              dataSource: <AreaData>[
                AreaData(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 760, 1,
                    Colors.deepOrange),
                AreaData(DateTime(2006, 0), 'China', 2.2, null, 44, 550, 880, 2,
                    Colors.deepPurple),
                AreaData(DateTime(2007, 0), 'USA', 3.32, null, 48, 440, 788, 3,
                    Colors.lightGreen),
                AreaData(DateTime(2008, 0), 'Japan', 4.56, null, 50, 350, 560,
                    4, Colors.red),
                AreaData(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444, 566,
                    5, Colors.purple)
              ],
              xValueMapper: (AreaData sales, _) => sales.numeric,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.category,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <AreaSeries<AreaData, int>>[
            AreaSeries<AreaData, int>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.xData,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <AreaSeries<AreaData, DateTime>>[
            AreaSeries<AreaData, DateTime>(
              dataSource: data,
              xValueMapper: (AreaData sales, _) => sales.year,
              yValueMapper: (AreaData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
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
          series: <AreaSeries<AreaData, String>>[
            AreaSeries<AreaData, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (AreaData sales, _) => sales.category,
                yValueMapper: (AreaData sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

List<AreaSeries<AreaData, num>> _getDefaultData() {
  final dynamic chartData = <AreaData>[
    AreaData(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 7601, 1),
    AreaData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    AreaData(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    AreaData(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    AreaData(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <AreaSeries<AreaData, num>>[
    AreaSeries<AreaData, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (AreaData sales, _) => sales.numeric,
      yValueMapper: (AreaData sales, _) => sales.sales1,
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

/// ignore: unused_element
List<AreaSeries<AreaData, num>> _getFillSeries() {
  final dynamic chartData = <AreaData>[
    AreaData(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 760, 1),
    AreaData(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    AreaData(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    AreaData(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    AreaData(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    AreaData(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    AreaData(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <AreaSeries<AreaData, num>>[
    AreaSeries<AreaData, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (AreaData sales, _) => sales.numeric,
      yValueMapper: (AreaData sales, _) => sales.sales1,
      color: Colors.blue,
    ),
  ];
}

/// Represents the arae data
class AreaData {
  /// Creates an instance for area data
  AreaData(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4, this.xData,
      [this.lineColor]);

  /// Holds the value of year
  final DateTime year;

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the value of sales1
  final int? sales1;

  /// Holds the value of sales2
  final int sales2;

  /// Holds the value of sales3
  final int sales3;

  /// Holds the value of sales4
  final int sales4;

  /// Holds the value of xData
  final int xData;

  /// Holds the value of linecolor
  final Color? lineColor;
}
