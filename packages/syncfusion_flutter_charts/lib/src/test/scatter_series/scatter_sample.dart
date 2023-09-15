import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to return the scatter chart sample
SfCartesianChart getScatterchart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <ScatterSample>[
    ScatterSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680, 760, 1,
        Colors.deepOrange),
    ScatterSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2,
        Colors.deepPurple),
    ScatterSample(
        DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3, Colors.lightGreen),
    ScatterSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    ScatterSample(
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
          series: getScatterData());
      break;
    case 'customization_fill with tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                animationDuration: 0,
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                color: Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12)),
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                pointColorMapper: (ScatterSample sales, _) => sales.lineColor),
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                gradient: gradientColors),
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                sortFieldValueMapper: (ScatterSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: <ScatterSample>[
                  ScatterSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  ScatterSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ScatterSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  ScatterSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  ScatterSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
                emptyPointSettings: EmptyPointSettings()),
          ]);
      break;
    case 'dataSource_emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: <ScatterSample>[
                  ScatterSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  ScatterSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ScatterSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  ScatterSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  ScatterSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero)),
          ]);
      break;
    case 'dataSource_emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: <ScatterSample>[
                  ScatterSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  ScatterSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ScatterSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  ScatterSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  ScatterSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average)),
          ]);
      break;
    case 'dataSource_emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
                enableTooltip: true,
                dataSource: <ScatterSample>[
                  ScatterSample(DateTime(2005, 0), 'India', 1.5, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  ScatterSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ScatterSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440,
                      788, 3, Colors.lightGreen),
                  ScatterSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350,
                      560, 4, Colors.red),
                  ScatterSample(DateTime(2009, 0), 'Russia', 5.87, null, 66,
                      444, 566, 5, Colors.purple)
                ],
                xValueMapper: (ScatterSample sales, _) => sales.numeric,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                    isVisible: false, width: 12, height: 12),
                pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop)),
          ]);
      break;
    case 'dataSource_emptyPoint_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
              enableTooltip: true,
              dataSource: <ScatterSample>[
                ScatterSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680,
                    760, 1, Colors.deepOrange),
                ScatterSample(DateTime(2006, 0), 'China', 2.2, null, 44, 550,
                    880, 2, Colors.deepPurple),
                ScatterSample(DateTime(2007, 0), 'USA', 3.32, null, 48, 440,
                    788, 3, Colors.lightGreen),
                ScatterSample(DateTime(2008, 0), 'Japan', 4.56, null, 50, 350,
                    560, 4, Colors.red),
                ScatterSample(DateTime(2009, 0), 'Russia', 5.87, null, 66, 444,
                    566, 5, Colors.purple)
              ],
              xValueMapper: (ScatterSample sales, _) => sales.numeric,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 0),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              pointColorMapper: (ScatterSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              enableTooltip: true,
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.category,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <ScatterSeries<ScatterSample, int>>[
            ScatterSeries<ScatterSample, int>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.xData,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <ScatterSeries<ScatterSample, DateTime>>[
            ScatterSeries<ScatterSample, DateTime>(
              dataSource: data,
              markerSettings:
                  const MarkerSettings(isVisible: false, width: 12, height: 12),
              xValueMapper: (ScatterSample sales, _) => sales.year,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.blue,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
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
    case 'shape_rectangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.rectangle)),
          ]);
      break;
    case 'shape_pentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.pentagon)),
          ]);
      break;
    case 'shape_verticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.verticalLine)),
          ]);
      break;
    case 'shape_horizontalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.horizontalLine)),
          ]);
      break;
    case 'shape_diamond':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.diamond)),
          ]);
      break;
    case 'shape_triangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.triangle)),
          ]);
      break;
    case 'shape_invertedTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                pointColorMapper: (ScatterSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: false,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.invertedTriangle)),
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
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
          series: <ScatterSeries<ScatterSample, String>>[
            ScatterSeries<ScatterSample, String>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (ScatterSample sales, _) => sales.category,
                yValueMapper: (ScatterSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'customization_fill_color_with_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
              borderColor: Colors.red,
              borderWidth: 2,
              color: Colors.blue.withOpacity(0.5),
              animationDuration: 0,
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.numeric,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_border_color_with_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ScatterSeries<ScatterSample, num>>[
            ScatterSeries<ScatterSample, num>(
              borderColor: Colors.red.withOpacity(0.5),
              borderWidth: 2,
              color: Colors.blue,
              animationDuration: 0,
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (ScatterSample sales, _) => sales.numeric,
              yValueMapper: (ScatterSample sales, _) => sales.sales1,
            )
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }
  return chart;
}

/// Method to get the scatter chart data
List<ScatterSeries<ScatterSample, num>> getScatterData() {
  final dynamic chartData = <ScatterSample>[
    ScatterSample(DateTime(2005, 0), 'India', 1.5, null, 28, 680, 7601, 1),
    ScatterSample(DateTime(2006, 0), 'China', 2.2, 24, 44, 550, 880, 2),
    ScatterSample(DateTime(2007, 0), 'USA', 3.32, 36, 48, 440, 788, 3),
    ScatterSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4),
    ScatterSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5),
    ScatterSample(DateTime(2010, 0), 'France', 6.8, 57, 78, 780, 650, 6),
    ScatterSample(DateTime(2011, 0), 'Germany', 8.5, 70, 84, 450, 800, 7)
  ];
  return <ScatterSeries<ScatterSample, num>>[
    ScatterSeries<ScatterSample, num>(
      enableTooltip: true,
      dataSource: chartData,
      xValueMapper: (ScatterSample sales, _) => sales.numeric,
      yValueMapper: (ScatterSample sales, _) => sales.sales1,
      color: Colors.green,
      pointColorMapper: (ScatterSample sales, _) => Colors.red,
      dataLabelSettings: const DataLabelSettings(isVisible: true),
      emptyPointSettings:
          EmptyPointSettings(color: Colors.black, mode: EmptyPointMode.drop),
    ),
  ];
}

/// Represents the scatter sample
class ScatterSample {
  /// Holds the scatter sample
  ScatterSample(this.year, this.category, this.numeric, this.sales1,
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

  /// Holds the sales4 value
  final int sales4;

  /// Holds the xData
  final int xData;

  /// Holds the line color
  final Color? lineColor;
}
