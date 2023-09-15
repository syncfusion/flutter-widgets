import 'dart:math';
import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get fast line chart sample
SfCartesianChart getFastLinechart(String sampleName) {
  SfCartesianChart chart;
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

  final dynamic data = <_FastLineSample>[
    _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    _FastLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    _FastLineSample(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    _FastLineSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _FastLineSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic performanceData = <_Performace>[];
  double value = 0;
  for (int i = 0; i < 100000; i++) {
    final Random rand = Random();
    value += rand.nextDouble() * 10 - 5;
    performanceData.add(_Performace(i, value));
  }

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
          series: _getDefaultFastLine());
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.numeric,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
              color: Colors.blue,
            ),
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.numeric,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
            ),
          ]);
      break;
    case 'customization_largeData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_Performace, num>>[
            FastLineSeries<_Performace, num>(
                enableTooltip: true,
                dataSource: performanceData,
                xValueMapper: (_Performace sales, _) => sales.xData,
                yValueMapper: (_Performace sales, _) => sales.yData,
                width: 2,
                color: Colors.green),
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                dataSource: data,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                gradient: gradientColors)
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                dataSource: data,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_FastLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
                enableTooltip: true,
                dataSource: <_FastLineSample>[
                  _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _FastLineSample(DateTime(2006, 0), 'China', 2.2, 32, 44, 550,
                      880, 2, Colors.deepPurple),
                  _FastLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, 32, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_FastLineSample sales, _) => sales.numeric,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                width: 3,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
                enableTooltip: true,
                dataSource: <_FastLineSample>[
                  _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _FastLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _FastLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_FastLineSample sales, _) => sales.numeric,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                width: 3,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
                enableTooltip: true,
                dataSource: <_FastLineSample>[
                  _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _FastLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _FastLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_FastLineSample sales, _) => sales.numeric,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                width: 3,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
                enableTooltip: true,
                dataSource: <_FastLineSample>[
                  _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _FastLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _FastLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_FastLineSample sales, _) => sales.numeric,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                width: 3,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, num>>[
            FastLineSeries<_FastLineSample, num>(
              enableTooltip: true,
              dataSource: <_FastLineSample>[
                _FastLineSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680,
                    760, 1, Colors.deepOrange),
                _FastLineSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                    880, 2, Colors.deepPurple),
                _FastLineSample(DateTime(2007, 0), 'USA', 3.32, null, 48, 440,
                    788, 3, Colors.lightGreen),
                _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, null, 50, 350,
                    560, 4, Colors.red),
                _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                    444, 566, 5, Colors.purple)
              ],
              xValueMapper: (_FastLineSample sales, _) => sales.numeric,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
              width: 3,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <FastLineSeries<_FastLineSample, int>>[
            FastLineSeries<_FastLineSample, int>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.xData,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <FastLineSeries<_FastLineSample, DateTime>>[
            FastLineSeries<_FastLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.year,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                animationDuration: 0,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
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
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_FastLineSample sales, _) => sales.category,
                yValueMapper: (_FastLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'fast_line_tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fast_line_tooltip_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fast_line_tooltip_longpress':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.longPress),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'fast_line_tooltip_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              // Templating the tooltip
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'fast_line_trackball':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fast_line_crosshair':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fastline_default_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'fastline_selection_mode_point':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.point,
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;

    case 'fastline_selection_mode_series':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;

    case 'fastline_selection_mode_cluster':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.cluster,
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;

    case 'fastline_selection_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.cluster,
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fastline_selection_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'fastline_selection_long_press':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.longPress,
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'fastline_pinch_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables pinch zooming
              enablePinching: true),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;

    case 'fastline_selection_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              enableSelectionZooming: true,
              selectionRectBorderColor: Colors.red,
              selectionRectColor: Colors.grey),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;

    case 'fastline_double_tap_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(enableDoubleTapZooming: true),
          primaryXAxis: CategoryAxis(),
          series: <FastLineSeries<_FastLineSample, String>>[
            FastLineSeries<_FastLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_FastLineSample sales, _) => sales.category,
              yValueMapper: (_FastLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

List<FastLineSeries<_FastLineSample, num>> _getDefaultFastLine() {
  final dynamic chartData = <_FastLineSample>[
    _FastLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 7601, 1),
    _FastLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    _FastLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    _FastLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    _FastLineSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    _FastLineSample(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    _FastLineSample(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <FastLineSeries<_FastLineSample, num>>[
    FastLineSeries<_FastLineSample, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (_FastLineSample sales, _) => sales.numeric,
      yValueMapper: (_FastLineSample sales, _) => sales.sales1,
      width: 2,
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

// List<FastLineSeries<_FastLineSample, num>> getFillSeries() {
//   final dynamic chartData = <_FastLineSample>[
//     _FastLineSample(DateTime(2005, 0, 1), 'India', 1.5, 32, 28, 680, 760, 1),
//     _FastLineSample(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880, 2),
//     _FastLineSample(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788, 3),
//     _FastLineSample(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560, 4),
//     _FastLineSample(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566, 5),
//     _FastLineSample(DateTime(2010, 0, 1), 'France', 6.8, 57, 78, 780, 650, 6),
//     _FastLineSample(DateTime(2011, 0, 1), 'Germany', 8.5, 70, 84, 450, 800, 7)
//   ];
//   return <FastLineSeries<_FastLineSample, num>>[
//     FastLineSeries<_FastLineSample, num>(
//       enableTooltip: true,
//       dataSource: chartData,
//       xValueMapper: (_FastLineSample sales, _) => sales.numeric,
//       yValueMapper: (_FastLineSample sales, _) => sales.sales1,
//       width: 3,
//       color: Colors.blue,
//     ),
//   ];
// }

class _FastLineSample {
  _FastLineSample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4, this.xData,
      [this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int? sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int xData;
  final Color? lineColor;
}

class _Performace {
  _Performace(this.xData, this.yData);
  final num xData;
  final double yData;
}
