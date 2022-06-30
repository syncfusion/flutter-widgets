import 'package:flutter/material.dart';
import '../../../charts.dart';

/// To get the step line chart
SfCartesianChart getStepLine(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_StepLineSample>[
    _StepLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    _StepLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    _StepLineSample(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    _StepLineSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _StepLineSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];
  switch (sampleName) {
    case 'stepLine_customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          title: ChartTitle(text: 'Line Series', backgroundColor: Colors.white),
          legend: Legend(
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
          series: getStepLineData());
      break;
    case 'stepLine_customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(isVisible: true),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.numeric,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              color: Colors.blue,
            ),
          ]);
      break;
    case 'stepLine_customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StepLineSample sales, _) => sales.numeric,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                width: 3,
                pointColorMapper: (_StepLineSample sales, _) =>
                    sales.lineColor),
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                dataSource: data,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_StepLineSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'stepLine_dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
                enableTooltip: true,
                dataSource: <_StepLineSample>[
                  _StepLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StepLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StepLineSample sales, _) => sales.numeric,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                width: 3,
                pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'stepLine_dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
                enableTooltip: true,
                dataSource: <_StepLineSample>[
                  _StepLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StepLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StepLineSample sales, _) => sales.numeric,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                width: 3,
                pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'stepLine_dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
                enableTooltip: true,
                dataSource: <_StepLineSample>[
                  _StepLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StepLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StepLineSample sales, _) => sales.numeric,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                width: 3,
                pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'stepLine_dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
                enableTooltip: true,
                dataSource: <_StepLineSample>[
                  _StepLineSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  _StepLineSample(DateTime(2006, 0), 'China', 2.2, null, 44,
                      550, 880, 2, Colors.deepPurple),
                  _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (_StepLineSample sales, _) => sales.numeric,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                width: 3,
                pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'stepLine_dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, num>>[
            StepLineSeries<_StepLineSample, num>(
              enableTooltip: true,
              dataSource: <_StepLineSample>[
                _StepLineSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680,
                    760, 1, Colors.deepOrange),
                _StepLineSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                    880, 2, Colors.deepPurple),
                _StepLineSample(DateTime(2007, 0), 'USA', 3.32, null, 48, 440,
                    788, 3, Colors.lightGreen),
                _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, null, 50, 350,
                    560, 4, Colors.red),
                _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                    444, 566, 5, Colors.purple)
              ],
              xValueMapper: (_StepLineSample sales, _) => sales.numeric,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_StepLineSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.category,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StepLineSeries<_StepLineSample, int>>[
            StepLineSeries<_StepLineSample, int>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.xData,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <StepLineSeries<_StepLineSample, DateTime>>[
            StepLineSeries<_StepLineSample, DateTime>(
              dataSource: data,
              xValueMapper: (_StepLineSample sales, _) => sales.year,
              yValueMapper: (_StepLineSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StepLineSample sales, _) => Colors.red,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StepLineSample sales, _) => Colors.blue,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                pointColorMapper: (_StepLineSample sales, _) => Colors.red,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
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
          series: <StepLineSeries<_StepLineSample, String>>[
            StepLineSeries<_StepLineSample, String>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_StepLineSample sales, _) => sales.category,
                yValueMapper: (_StepLineSample sales, _) => sales.sales1,
                animationDuration: 0,
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

/// Method to get the step line series data
// ignore: library_private_types_in_public_api
List<StepLineSeries<_StepLineSample, num>> getStepLineData() {
  final dynamic chartData = <_StepLineSample>[
    _StepLineSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 7601, 1),
    _StepLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    _StepLineSample(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    _StepLineSample(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <StepLineSeries<_StepLineSample, num>>[
    StepLineSeries<_StepLineSample, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (_StepLineSample sales, _) => sales.numeric,
      yValueMapper: (_StepLineSample sales, _) => sales.sales1,
      width: 2,
      color: Colors.green,
      pointColorMapper: (_StepLineSample sales, _) => Colors.red,
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

/// ignore: unused_element, library_private_types_in_public_api
List<StepLineSeries<_StepLineSample, num>> getStepLineFillSeries() {
  final dynamic chartData = <_StepLineSample>[
    _StepLineSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 760, 1),
    _StepLineSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    _StepLineSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    _StepLineSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    _StepLineSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    _StepLineSample(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    _StepLineSample(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <StepLineSeries<_StepLineSample, num>>[
    StepLineSeries<_StepLineSample, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (_StepLineSample sales, _) => sales.numeric,
      yValueMapper: (_StepLineSample sales, _) => sales.sales1,
      width: 3,
      color: Colors.blue,
    ),
  ];
}

class _StepLineSample {
  _StepLineSample(this.year, this.category, this.numeric, this.sales1,
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
