import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the bubble chart
SfCartesianChart getBubblechart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_BubbleSample>[
    _BubbleSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1, 0.143,
        Colors.deepOrange),
    _BubbleSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2, 0.0818,
        Colors.deepPurple),
    _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, 0.0826,
        Colors.lightGreen),
    _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, 0.096,
        Colors.red),
    _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, 0.37,
        Colors.purple)
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
          series: _getBubbleDefaultData());
      break;
    case 'customization_fill with tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                color: Colors.blue,
                borderWidth: 2,
                borderColor: Colors.red),
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => sales.lineColor),
          ]);
      break;
    case 'customization_gradient':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                gradient: gradientColors,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_BubbleSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: <_BubbleSample>[
                  _BubbleSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, 0.143, Colors.deepOrange),
                  _BubbleSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, 0.0818, Colors.deepPurple),
                  _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, 0.0826, Colors.lightGreen),
                  _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, 0.096, Colors.red),
                  _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, 0.37, Colors.purple)
                ],
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: <_BubbleSample>[
                  _BubbleSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, 0.143, Colors.deepOrange),
                  _BubbleSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, 0.0818, Colors.deepPurple),
                  _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, 0.0826, Colors.lightGreen),
                  _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, 0.096, Colors.red),
                  _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, 0.37, Colors.purple)
                ],
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: <_BubbleSample>[
                  _BubbleSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, 0.143, Colors.deepOrange),
                  _BubbleSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, 0.0818, Colors.deepPurple),
                  _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, 0.0826, Colors.lightGreen),
                  _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, 0.096, Colors.red),
                  _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, 0.37, Colors.purple)
                ],
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: <_BubbleSample>[
                  _BubbleSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, 0.143, Colors.deepOrange),
                  _BubbleSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, 0.0818, Colors.deepPurple),
                  _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, 0.0826, Colors.lightGreen),
                  _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, 0.096, Colors.red),
                  _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, 0.37, Colors.purple)
                ],
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: <_BubbleSample>[
                _BubbleSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680,
                    760, 1, 0.143, Colors.deepOrange),
                _BubbleSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                    880, 2, 0.0818, Colors.deepPurple),
                _BubbleSample(DateTime(2007, 0), 'USA', 3.32, null, 48, 440,
                    788, 3, 0.0826, Colors.lightGreen),
                _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, null, 50, 350,
                    560, 4, 0.096, Colors.red),
                _BubbleSample(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                    566, 5, 0.37, Colors.purple)
              ],
              xValueMapper: (_BubbleSample sales, _) => sales.numeric,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
              pointColorMapper: (_BubbleSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
              enableTooltip: true,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              dataSource: data,
              xValueMapper: (_BubbleSample sales, _) => sales.category,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BubbleSeries<_BubbleSample, int>>[
            BubbleSeries<_BubbleSample, int>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.xData,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BubbleSeries<_BubbleSample, DateTime>>[
            BubbleSeries<_BubbleSample, DateTime>(
              dataSource: data,
              sizeValueMapper: (_BubbleSample sales, _) => sales.size,
              xValueMapper: (_BubbleSample sales, _) => sales.year,
              yValueMapper: (_BubbleSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                dataSource: data,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => Colors.red,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => Colors.blue,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                pointColorMapper: (_BubbleSample sales, _) => Colors.red,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    alignment: ChartAlignment.near),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
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
    case 'dataLabel_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_outer':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_outer_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.outer,
                  alignment: ChartAlignment.near,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.top,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_top_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.near,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_bottom_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  alignment: ChartAlignment.far,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_middle_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_BubbleSample, String>>[
            BubbleSeries<_BubbleSample, String>(
                enableTooltip: true,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.category,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'customization_fill_color with opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                color: Colors.blue.withOpacity(0.5),
                borderWidth: 2,
                borderColor: Colors.red),
          ]);
      break;
    case 'customization_border_color with opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_BubbleSample, num>>[
            BubbleSeries<_BubbleSample, num>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_BubbleSample sales, _) => sales.numeric,
                yValueMapper: (_BubbleSample sales, _) => sales.sales1,
                sizeValueMapper: (_BubbleSample sales, _) => sales.size,
                color: Colors.blue,
                borderWidth: 2,
                borderColor: Colors.red.withOpacity(0.5)),
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

List<BubbleSeries<_BubbleSample, num>> _getBubbleDefaultData() {
  final dynamic chartData = <_BubbleSample>[
    _BubbleSample(
        DateTime(2005, 0), 'India', 1.5, null, 28, 680, 7601, 1, 0.143),
    _BubbleSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2, 0.0818),
    _BubbleSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, 0.0826),
    _BubbleSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, 0.143),
    _BubbleSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, 0.128),
    _BubbleSample(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6, 0.13),
    _BubbleSample(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7, 0.37)
  ];
  return <BubbleSeries<_BubbleSample, num>>[
    BubbleSeries<_BubbleSample, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (_BubbleSample sales, _) => sales.numeric,
      yValueMapper: (_BubbleSample sales, _) => sales.sales1,
      color: Colors.green,
      sizeValueMapper: (_BubbleSample sales, _) => sales.size,
      pointColorMapper: (_BubbleSample sales, _) => Colors.red,
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

class _BubbleSample {
  _BubbleSample(this.year, this.category, this.numeric, this.sales1,
      this.sales2, this.sales3, this.sales4, this.xData,
      [this.size, this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int? sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int xData;
  final double? size;
  final Color? lineColor;
}
