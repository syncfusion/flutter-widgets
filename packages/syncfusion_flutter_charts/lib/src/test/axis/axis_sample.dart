import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../charts.dart';

/// Method to get the axis sample
SfCartesianChart getAxisSample(String sampleName) {
  SfCartesianChart chart;
  final List<Color> color = <Color>[];
  color.add(Colors.pink);
  color.add(Colors.pink);
  color.add(Colors.pink);
  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);
  final LinearGradient gradients = LinearGradient(colors: color, stops: stops);
  final dynamic data = <_AxisSample>[
    _AxisSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _AxisSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _AxisSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _AxisSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _AxisSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final dynamic dateCategorydata = <_AxisSample>[
    _AxisSample(
        DateTime(2005), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _AxisSample(
        DateTime(2006), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _AxisSample(
        DateTime(2007), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _AxisSample(DateTime(2008), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _AxisSample(
        DateTime(2009), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple),
    _AxisSample(
        DateTime(2010), 'Germany', 5.71, 45, 56, 404, 536, 6, Colors.blue)
  ];

  switch (sampleName) {
    case 'category_withoutData':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(interval: 1),
        primaryYAxis: NumericAxis(),
      );
      break;
    case 'category_visibleMinMax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(visibleMinimum: 2, visibleMaximum: 3),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_SideBySideSeriesPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          enableSideBySideSeriesPlacement: false,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<_AxisSample, String>>[
            ColumnSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
            ColumnSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales2,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              opposedPosition: true, tickPosition: TickPosition.inside),
          primaryYAxis: NumericAxis(
              opposedPosition: true, tickPosition: TickPosition.inside),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_AxisSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_plotoffset':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotOffset: 50),
          primaryYAxis: NumericAxis(plotOffset: 100),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_ticks':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              majorTickLines:
                  const MajorTickLines(color: Colors.green, width: 10),
              minorTickLines:
                  const MinorTickLines(color: Colors.red, size: 4, width: 5)),
          primaryYAxis: NumericAxis(
              minorTickLines:
                  const MinorTickLines(color: Colors.green, width: 10, size: 5),
              majorTickLines:
                  const MajorTickLines(color: Colors.red, size: 4, width: 5)),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(width: 0),
              majorGridLines: const MajorGridLines(
                  color: Colors.green, width: 10, dashArray: <double>[10, 20]),
              minorGridLines: const MinorGridLines(
                  color: Colors.red, width: 5, dashArray: <double>[10, 20])),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(width: 0),
              minorGridLines: const MinorGridLines(
                  color: Colors.green, width: 10, dashArray: <double>[10, 20]),
              majorGridLines: const MajorGridLines(
                  color: Colors.red, width: 5, dashArray: <double>[10, 20])),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_axisLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            tickPosition: TickPosition.inside,
            axisLine: const AxisLine(
                color: Colors.red, width: 3, dashArray: <double>[10, 20]),
          ),
          primaryYAxis: NumericAxis(
            tickPosition: TickPosition.inside,
            axisLine: const AxisLine(
                color: Colors.red, width: 3, dashArray: <double>[10, 20]),
          ),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_labelPlacement_onTicks':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
              pointColorMapper: (_AxisSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelPlacement_betweenTicks':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
              pointColorMapper: (_AxisSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_EdgeLabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: <_AxisSample>[
                _AxisSample(
                    DateTime(2005, 0), 'StrawBerry', 1, 32, 28, 680, 760),
                _AxisSample(
                    DateTime(2006, 0), 'Pomegranate', 2, 24, 44, 550, 880),
                _AxisSample(
                    DateTime(2007, 0), 'Blackberry', 3, 36, 48, 440, 788),
                _AxisSample(
                    DateTime(2008, 0), 'RasBerry', 4.56, 38, 50, 350, 560),
                _AxisSample(
                    DateTime(2009, 0), 'BlueBerry', 5.87, 54, 66, 444, 566),
                _AxisSample(
                    DateTime(2009, 0), 'Avocado', 5.87, 54, 66, 444, 566),
                _AxisSample(
                    DateTime(2009, 0), 'GreenApple', 5.87, 54, 66, 444, 566)
              ],
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_EdgeLabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: <_AxisSample>[
                _AxisSample(
                    DateTime(2005, 0), 'StrawBerry', 1, 32, 28, 680, 760),
                _AxisSample(
                    DateTime(2006, 0), 'Pomegranate', 2, 24, 44, 550, 880),
                _AxisSample(
                    DateTime(2007, 0), 'Blackberry', 3, 36, 48, 440, 788),
                _AxisSample(
                    DateTime(2008, 0), 'RasBerry', 4.56, 38, 50, 350, 560),
                _AxisSample(
                    DateTime(2009, 0), 'BlueBerry', 5.87, 54, 66, 444, 566),
                _AxisSample(
                    DateTime(2009, 0), 'Avocado', 5.87, 54, 66, 444, 566),
                _AxisSample(
                    DateTime(2009, 0), 'GreenApple', 5.87, 54, 66, 444, 566)
              ],
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_EdgeLabel_shift_large_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift, isInversed: true),
          primaryYAxis: NumericAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              labelStyle: const TextStyle(fontSize: 25)),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: <_AxisSample>[
                _AxisSample(
                    DateTime(2005, 0),
                    'China is the largets country in fo0d',
                    1,
                    32,
                    28,
                    680,
                    760,
                    1,
                    Colors.deepOrange),
                _AxisSample(DateTime(2006, 0), 'India', 2, 24, 44, 550, 880, 2,
                    Colors.deepPurple),
                _AxisSample(DateTime(2007, 0), 'United Kingdom', 3, 36, 48, 440,
                    788, 3, Colors.lightGreen),
                _AxisSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                    4, Colors.red),
                _AxisSample(
                    DateTime(2009, 0),
                    'USA is largest country in various aspects',
                    5.87,
                    54,
                    66,
                    444,
                    566,
                    5,
                    Colors.purple)
              ],
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_AxisSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelIntersect_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_multiple':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_wrap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.wrap),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.wrap),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_hide_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide,
              isInversed: true),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_multiple_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows,
              isInversed: true),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_wrap_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              isInversed: true),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.wrap),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_none_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.none,
              isInversed: true),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA got three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_45_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45,
              isInversed: true),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_labelIntersect_90_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90,
              isInversed: true),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA three medals', 3),
                _CategoryData('Russia got one medals', 1),
                _CategoryData('China ', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India got four medals', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'category_multipleAxis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          axes: <ChartAxis>[
            CategoryAxis(
                name: 'xAxis',
                opposedPosition: true,
                axisLine: const AxisLine(width: 0)),
            NumericAxis(
                name: 'yAxis',
                opposedPosition: true,
                plotOffset: 180,
                axisLine: const AxisLine(width: 0))
          ],
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
            LineSeries<_AxisSample, String>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.category,
                yValueMapper: (_AxisSample sales, _) => sales.sales2,
                xAxisName: 'xAxis',
                yAxisName: 'yAxis')
          ]);
      break;
    case 'category_isIndexed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(arrangeByIndex: true),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_CategoryData, String>>[
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USA', 3),
                _CategoryData('Russia', 1),
                _CategoryData('China', 8),
                _CategoryData('Japan', 5),
                _CategoryData('India', 4),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
            LineSeries<_CategoryData, String>(
              dataSource: <_CategoryData>[
                _CategoryData('USSR', 2),
                _CategoryData('Poland', 6),
                _CategoryData('GreenLand', 4),
                _CategoryData('Egypt', 3),
                _CategoryData('Asia', 9),
              ],
              xValueMapper: (_CategoryData sales, _) => sales.x,
              yValueMapper: (_CategoryData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_ZoomFactorPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(zoomFactor: 0.5, zoomPosition: 0.5),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_visibleMinMax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              minimum: 0,
              maximum: 6,
              interval: 1,
              visibleMinimum: 2,
              visibleMaximum: 5),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <ColumnSeries<_AxisSample, int?>>[
            ColumnSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_equalrange':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 1),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_min_greater':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 10, maximum: 2),
          primaryYAxis: NumericAxis(minimum: 70, maximum: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_edgelabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisTitle_align_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15),
                  alignment: ChartAlignment.near)),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15),
                  alignment: ChartAlignment.near)),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisTitle_align_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis', alignment: ChartAlignment.far)),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis', alignment: ChartAlignment.far)),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              opposedPosition: true,
              title: AxisTitle(
                  text: 'Primary X Axis', alignment: ChartAlignment.far)),
          primaryYAxis: NumericAxis(
              opposedPosition: true,
              title: AxisTitle(
                  text: 'Primary Y Axis', alignment: ChartAlignment.far)),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_plotoffset':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(plotOffset: 100),
          primaryYAxis: NumericAxis(plotOffset: 50),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_minorgridtick':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_greater_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: 110),
          primaryYAxis: NumericAxis(labelRotation: 110),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_greater_180':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: 200),
          primaryYAxis: NumericAxis(labelRotation: 200),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_greater_360':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: 400),
          primaryYAxis: NumericAxis(labelRotation: 400),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_negative_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: -45),
          primaryYAxis: NumericAxis(labelRotation: -45),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_negative_120':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: -120),
          primaryYAxis: NumericAxis(labelRotation: -120),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_negative_230':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: -230),
          primaryYAxis: NumericAxis(labelRotation: -230),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelrotation_negative_320':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelRotation: -320),
          primaryYAxis: NumericAxis(labelRotation: -320),
          series: <ChartSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelIntersect_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelIntersect_multiple':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelIntersect_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelIntersect_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelIntersect_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_multipleAxis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          axes: <ChartAxis>[
            NumericAxis(
                name: 'xAxis',
                opposedPosition: true,
                title: AxisTitle(
                    text: 'Secondary X Axis', alignment: ChartAlignment.near),
                minorGridLines: const MinorGridLines(
                    color: Color.fromRGBO(244, 67, 54, 1.0)),
                minorTicksPerInterval: 4,
                minorTickLines: const MinorTickLines(
                    size: 5,
                    width: 0.5,
                    color: Color.fromRGBO(255, 87, 34, 1.0))),
            NumericAxis(
                name: 'yAxis',
                opposedPosition: true,
                title: AxisTitle(
                    text: 'Secondary Y Axis', alignment: ChartAlignment.near),
                minorGridLines: const MinorGridLines(
                    color: Color.fromRGBO(244, 67, 54, 1.0)),
                minorTicksPerInterval: 4,
                minorTickLines: const MinorTickLines(
                    size: 5,
                    width: 0.5,
                    color: Color.fromRGBO(255, 87, 34, 1.0)),
                plotOffset: 100)
          ],
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
            LineSeries<_AxisSample, int?>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.xData,
                yValueMapper: (_AxisSample sales, _) => sales.sales2,
                xAxisName: 'xAxis',
                yAxisName: 'yAxis')
          ]);
      break;
    case 'numeric_numberFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(numberFormat: NumberFormat.decimalPattern()),
          primaryYAxis: NumericAxis(numberFormat: NumberFormat.currency()),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(labelFormat: '{value}X'),
          primaryYAxis: NumericAxis(labelFormat: '{value}*C'),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axis_name':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(name: 'majorAxis'),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'inside_label_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(name: 'majorAxis'),
          primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.inside,
            labelAlignment: LabelAlignment.center,
            minimum: 10,
            maximum: 200,
            interval: 10,
          ),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'inside_label_far':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(name: 'majorAxis'),
        primaryYAxis: NumericAxis(
          labelPosition: ChartDataLabelPosition.inside,
          labelAlignment: LabelAlignment.end,
          minimum: 10,
          maximum: 200,
          interval: 10,
        ),
      );
      break;
    case 'datetime_inside_label_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(name: 'majorAxis'),
          primaryYAxis: DateTimeAxis(
            labelPosition: ChartDataLabelPosition.inside,
            labelAlignment: LabelAlignment.center,
            visibleMinimum: DateTime(2006, 0),
            visibleMaximum: DateTime(2011, 0),
          ));
      break;
    case 'datetime_inside_label_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(name: 'majorAxis'),
          primaryYAxis: DateTimeAxis(
            labelPosition: ChartDataLabelPosition.inside,
            labelAlignment: LabelAlignment.end,
            visibleMinimum: DateTime(2006, 0),
            visibleMaximum: DateTime(2011, 0),
          ));
      break;
    case 'category_inside_label_center':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(name: 'majorAxis'),
        primaryYAxis: CategoryAxis(
          labelPosition: ChartDataLabelPosition.inside,
          labelAlignment: LabelAlignment.center,
        ),
      );
      break;
    case 'category_inside_label_far':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: NumericAxis(name: 'majorAxis'),
        primaryYAxis: CategoryAxis(
          labelPosition: ChartDataLabelPosition.inside,
          labelAlignment: LabelAlignment.end,
        ),
      );
      break;
    case 'datetime_withoutData':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeAxis(),
      );
      break;
    case 'datetime_sortingX_ascending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          series: <ColumnSeries<_AxisSample, DateTime>>[
            ColumnSeries<_AxisSample, DateTime>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.year,
                yValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_AxisSample sales, _) => sales.year,
                sortingOrder: SortingOrder.ascending),
          ]);
      break;
    case 'datetime_sortingX_descending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          series: <ColumnSeries<_AxisSample, DateTime>>[
            ColumnSeries<_AxisSample, DateTime>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.year,
                yValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_AxisSample sales, _) => sales.year,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'datetime_visibleMinMax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.y(),
              intervalType: DateTimeIntervalType.years,
              visibleMinimum: DateTime(2006, 0),
              visibleMaximum: DateTime(2011, 0)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_ZoomFactorPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.y(), zoomFactor: 0.5, zoomPosition: 0.6),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range_minmax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2005, 0)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal_Negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: <_AxisSample>[
                _AxisSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                    Colors.deepOrange),
                _AxisSample(DateTime(2006, 0), 'China', -2, -24, 44, 550, 880,
                    2, Colors.deepPurple),
                _AxisSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                    Colors.lightGreen),
                _AxisSample(DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560,
                    4, Colors.red),
                _AxisSample(DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566,
                    5, Colors.purple)
              ],
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_edgelabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              opposedPosition: true,
              labelPosition: ChartDataLabelPosition.inside),
          primaryYAxis: NumericAxis(
              opposedPosition: true,
              labelPosition: ChartDataLabelPosition.inside),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          isTransposed: true,
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_bar':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          isTransposed: true,
          series: <ChartSeries<_AxisSample, DateTime>>[
            BarSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_minorgridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelIntersect_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelIntersect_multiplerows':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelIntersect_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelIntersect_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelIntersect_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            labelIntersectAction: AxisLabelIntersectAction.rotate90,
          ),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_dateFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(dateFormat: DateFormat.y()),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_intervalType_year':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.months),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011, 0), 32),
                _DateTimeData(DateTime(2012), 24),
                _DateTimeData(DateTime(2013), 36),
                _DateTimeData(DateTime(2014), 38),
                _DateTimeData(
                  DateTime(2015),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_minutes':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_round_minutes':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_round_seconds':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.seconds,
              rangePadding: ChartRangePadding.round,
              labelFormat: '{value}sec'),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_seconds':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.seconds,
              rangePadding: ChartRangePadding.additional,
              labelFormat: '{value}sec'),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_round_years':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.years,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011, 0), 32),
                _DateTimeData(DateTime(2012), 24),
                _DateTimeData(DateTime(2013), 36),
                _DateTimeData(DateTime(2014), 38),
                _DateTimeData(
                  DateTime(2015),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_years':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.years,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011, 0), 32),
                _DateTimeData(DateTime(2012), 24),
                _DateTimeData(DateTime(2013), 36),
                _DateTimeData(DateTime(2014), 38),
                _DateTimeData(
                  DateTime(2015),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_months':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.months),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2019, 11), 32),
                _DateTimeData(DateTime(2018), 24),
                _DateTimeData(DateTime(2018, 2), 36),
                _DateTimeData(DateTime(2018, 3), 38),
                _DateTimeData(
                  DateTime(2018, 4),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_days':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.days),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 11), 32),
                _DateTimeData(DateTime(2018, 2, 12), 24),
                _DateTimeData(DateTime(2018, 2, 13), 36),
                _DateTimeData(DateTime(2018, 2, 14), 38),
                _DateTimeData(
                  DateTime(2018, 2, 15),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_days':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.days,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 11), 32),
                _DateTimeData(DateTime(2018, 2, 12), 24),
                _DateTimeData(DateTime(2018, 2, 13), 36),
                _DateTimeData(DateTime(2018, 2, 14), 38),
                _DateTimeData(
                  DateTime(2018, 2, 15),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_round_days':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.days,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 11), 32),
                _DateTimeData(DateTime(2018, 2, 12), 24),
                _DateTimeData(DateTime(2018, 2, 13), 36),
                _DateTimeData(DateTime(2018, 2, 14), 38),
                _DateTimeData(
                  DateTime(2018, 2, 15),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_hours':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.hours,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_rangePadding_round_hours':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.hours,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_auto_hours':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(interval: 4),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_hours':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.hours),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_minutes':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(intervalType: DateTimeIntervalType.minutes),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_intervalType_seconds':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(intervalType: DateTimeIntervalType.seconds),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
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
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
              width: 3,
              pointColorMapper: (_AxisSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
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
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'multipleAxis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          axes: <ChartAxis>[
            NumericAxis(name: 'x1'),
            NumericAxis(name: 'y1'),
          ],
          series: <LineSeries<_AxisData, double>>[
            LineSeries<_AxisData, double>(
              dataSource: <_AxisData>[
                _AxisData(1, 3),
                _AxisData(2, 1),
                _AxisData(3, 8),
              ],
              xValueMapper: (_AxisData sales, _) => sales.x,
              yValueMapper: (_AxisData sales, _) => sales.y,
            ),
            LineSeries<_AxisData, double>(
                dataSource: <_AxisData>[
                  _AxisData(1, 4),
                  _AxisData(2, 5),
                  _AxisData(3, 3)
                ],
                xValueMapper: (_AxisData sales, _) => sales.x,
                yValueMapper: (_AxisData sales, _) => sales.y,
                xAxisName: 'x1',
                yAxisName: 'y1'),
          ]);
      break;
    case 'multipleAxis_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          axes: <ChartAxis>[
            NumericAxis(name: 'x1', opposedPosition: true),
            NumericAxis(name: 'y1', opposedPosition: true),
          ],
          series: <LineSeries<_AxisData, double>>[
            LineSeries<_AxisData, double>(
              dataSource: <_AxisData>[
                _AxisData(1, 3),
                _AxisData(2, 1),
                _AxisData(3, 8),
              ],
              xValueMapper: (_AxisData sales, _) => sales.x,
              yValueMapper: (_AxisData sales, _) => sales.y,
            ),
            LineSeries<_AxisData, double>(
                dataSource: <_AxisData>[
                  _AxisData(1, 4),
                  _AxisData(2, 5),
                  _AxisData(3, 3)
                ],
                xValueMapper: (_AxisData sales, _) => sales.x,
                yValueMapper: (_AxisData sales, _) => sales.y,
                xAxisName: 'x1',
                yAxisName: 'y1'),
          ]);
      break;
    case 'Numeric plotband_visible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            plotBands: <PlotBand>[
              PlotBand(
                  start: -0.5,
                  end: 1.5,
                  text: 'Winter',
                  textAngle: 90,
                  color: Colors.red,
                  textStyle: const TextStyle(color: Colors.black),
                  associatedAxisStart: 2,
                  opacity: 0.1,
                  repeatUntil: 600,
                  borderColor: Colors.black,
                  borderWidth: 2),
              PlotBand(
                  start: 5.5,
                  end: 6.5,
                  color: Colors.pink,
                  textAngle: 90,
                  textStyle: const TextStyle(color: Colors.black),
                  associatedAxisStart: 6,
                  opacity: 0.1,
                  text: 'Winter',
                  repeatUntil: 600,
                  borderColor: Colors.black,
                  borderWidth: 2),
            ],
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: -0.5,
                end: 1.5,
                color: Colors.yellow,
                dashArray: const <double>[10.0, 10.0],
                repeatUntil: 600,
                borderColor: Colors.black,
                borderWidth: 2,
                text: 'Winter'),
            PlotBand(
                start: 5.5,
                end: 6.5,
                color: Colors.yellow,
                dashArray: const <double>[10.0, 20.0],
                repeatUntil: 600,
                borderColor: Colors.black,
                borderWidth: 2,
                text: 'Winter'),
          ]),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_withoutData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis());
      break;
    case 'logarithmic_sortingY_ascending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(),
          series: <ColumnSeries<_AxisSample, double>>[
            ColumnSeries<_AxisSample, double>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.numeric,
                yValueMapper: (_AxisSample sales, _) => sales.sales1 * 10,
                sortFieldValueMapper: (_AxisSample sales, _) =>
                    sales.sales1 * 10,
                sortingOrder: SortingOrder.ascending),
          ]);
      break;
    case 'logarithmic_sortingY_descending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(),
          series: <ColumnSeries<_AxisSample, double>>[
            ColumnSeries<_AxisSample, double>(
                dataSource: data,
                xValueMapper: (_AxisSample sales, _) => sales.numeric,
                yValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'logarithmic_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis:
              LogarithmicAxis(minimum: 300, maximum: 1000000, interval: 1));
      break;
    case 'logarithmic_logBase':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(
            maximum: 15625,
            logBase: 5,
          ));
      break;
    case 'Logarithmic_ZoomFactorPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_AxisSample, num>>[
            LineSeries<_AxisSample, num>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.numeric,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ],
          primaryYAxis: LogarithmicAxis(
              enableAutoIntervalOnZooming: false,
              zoomFactor: 0.5,
              zoomPosition: 0.5),
          primaryXAxis: LogarithmicAxis(zoomFactor: 0.5, zoomPosition: 0.5));
      break;
    case 'Logarithmic_VisibleMinMax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(
            minimum: 100,
            maximum: 100,
            visibleMinimum: 1000,
            visibleMaximum: 10000,
          ));
      break;
    case 'Logarithmic_LabelFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(
            minimum: 1,
            maximum: 10000,
            labelFormat: '{value}M',
          ));
      break;
    case 'Logarithmic_NumberFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: LogarithmicAxis(
            minimum: 1,
            maximum: 10000,
            numberFormat: NumberFormat.simpleCurrency(),
          ));
      break;
    case 'logarithmic_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(
              opposedPosition: true,
              title: AxisTitle(
                  text: 'Primary X Axis', alignment: ChartAlignment.far)),
          primaryYAxis: LogarithmicAxis(
              opposedPosition: true,
              title: AxisTitle(
                  text: 'Primary Y Axis', alignment: ChartAlignment.far)),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: LogarithmicAxis(),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelIntersect_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          primaryXAxis: LogarithmicAxis(
              maximum: 1000000000,
              interval: 1,
              labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelIntersect_multiple':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          primaryXAxis: LogarithmicAxis(
              maximum: 1000000000,
              interval: 1,
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelIntersect_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          primaryXAxis: LogarithmicAxis(
              maximum: 1000000000,
              interval: 1,
              labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelIntersect_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          primaryXAxis: LogarithmicAxis(
              maximum: 1000000000,
              interval: 1,
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelIntersect_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          primaryXAxis: LogarithmicAxis(
              maximum: 1000000000,
              interval: 1,
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: LogarithmicAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: LogarithmicAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Datetime plotband visibility':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                start: DateTime(2005),
                end: DateTime(2009),
                size: 20,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.red),
                dashArray: const <double>[10.0, 20.0],
                text: 'Winter',
                textAngle: 90,
                verticalTextAlignment: TextAnchor.start,
                isRepeatable: true,
                repeatUntil: DateTime(2009),
              ),
              PlotBand(
                  start: DateTime(2005),
                  end: DateTime(2009),
                  size: 20,
                  associatedAxisStart: 2,
                  associatedAxisEnd: 6,
                  verticalTextAlignment: TextAnchor.start,
                  textAngle: 90,
                  textStyle: const TextStyle(color: Colors.black),
                  dashArray: const <double>[10.0, 10.0],
                  text: 'Summer',
                  isRepeatable: true,
                  repeatUntil: DateTime(2009))
            ],
            intervalType: DateTimeIntervalType.years,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(isVisible: false),
          primaryYAxis: LogarithmicAxis(isVisible: false),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Category plotband XAxis visible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 'USA',
                end: 'India',
                opacity: 0.1,
                repeatUntil: 'India',
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                text: 'Winter',
                sizeType: DateTimeIntervalType.days),
            PlotBand(
                start: 'India',
                end: 'Japan',
                opacity: 0.5,
                repeatUntil: 'Japan',
                associatedAxisStart: 3,
                associatedAxisEnd: 7,
                text: 'Winter',
                sizeType: DateTimeIntervalType.days),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
              start: 1,
              end: 4,
              opacity: 0.1,
              repeatUntil: 600,
              associatedAxisStart: 1,
              associatedAxisEnd: 4,
            ),
            PlotBand(
                start: 1,
                end: 6,
                opacity: 0.1,
                repeatUntil: 600,
                associatedAxisStart: 0,
                associatedAxisEnd: 3)
          ], minimum: 1, maximum: 10),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_plotoffset':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(plotOffset: 100),
          primaryYAxis: LogarithmicAxis(plotOffset: 50),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'NumericAxis_gradient':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 2,
                opacity: 0.1,
                repeatUntil: 600,
                associatedAxisStart: 2,
                associatedAxisEnd: 6),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
              start: 1,
              end: 2,
              gradient: gradients,
            ),
          ]),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_minorgridtick':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: LogarithmicAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'CategoryAxis gradient':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotBands: <PlotBand>[
            PlotBand(
              start: 'USA',
              end: 'India',
              gradient: gradients,
            ),
            PlotBand(
              start: 'India',
              end: 'Japan',
              gradient: gradients,
            ),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
              start: 1,
              end: 4,
            ),
            PlotBand(
              start: 1,
              end: 6,
            )
          ], minimum: 1, maximum: 10),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: LogarithmicAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTimeAxis gradient':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(plotBands: <PlotBand>[
            PlotBand(
              start: DateTime(2018, 2),
              end: DateTime(2018, 6),
              gradient: gradients,
              isRepeatable: true,
              opacity: 0.1,
            ),
            PlotBand(
              start: DateTime(2018, 2),
              end: DateTime(2018, 6),
              gradient: gradients,
              isRepeatable: true,
              opacity: 0.1,
            ),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
              start: 1,
              end: 4,
              isRepeatable: true,
            ),
            PlotBand(
              start: 1,
              end: 6,
              isRepeatable: true,
            )
          ], minimum: 1, maximum: 10),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              LogarithmicAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              LogarithmicAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTimeAxis Repeatation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(plotBands: <PlotBand>[
            PlotBand(
                start: DateTime(2005, 0),
                end: DateTime(2009, 0),
                isRepeatable: true,
                repeatUntil: DateTime(2009, 0),
                repeatEvery: 2,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: DateTime(2005, 0),
                end: DateTime(2009, 0),
                isRepeatable: true,
                repeatUntil: DateTime(2009, 0),
                repeatEvery: 2,
                shouldRenderAboveSeries: true),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 4,
                isRepeatable: true,
                repeatUntil: 600,
                repeatEvery: 2,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: 1,
                end: 6,
                isRepeatable: true,
                repeatUntil: 600,
                repeatEvery: 2,
                shouldRenderAboveSeries: true)
          ], minimum: 1, maximum: 10),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_edgelabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              LogarithmicAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              LogarithmicAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'CategoryAxis Repeatation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 'USA',
                end: 'India',
                isRepeatable: true,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: 'India',
                end: 'Japan',
                isRepeatable: true,
                shouldRenderAboveSeries: true),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 4,
                isRepeatable: true,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: 1,
                end: 6,
                isRepeatable: true,
                shouldRenderAboveSeries: true)
          ], minimum: 1, maximum: 10),
          series: <LineSeries<_AxisSample, String>>[
            LineSeries<_AxisSample, String>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.category,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_equalrange':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(minimum: 1, maximum: 1),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'NumericAxis Repeatation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 2,
                isRepeatable: true,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: 1,
                end: 2,
                isRepeatable: true,
                shouldRenderAboveSeries: true),
          ]),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 2,
                gradient: gradients,
                isRepeatable: true,
                shouldRenderAboveSeries: true),
            PlotBand(
                start: 1,
                end: 2,
                gradient: gradients,
                isRepeatable: true,
                shouldRenderAboveSeries: true),
          ]),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_min_greater':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: LogarithmicAxis(minimum: 10, maximum: 2),
          primaryYAxis: LogarithmicAxis(minimum: 70, maximum: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type1':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                  start: DateTime(2005),
                  end: DateTime(2009),
                  size: 20,
                  sizeType: DateTimeIntervalType.years,
                  associatedAxisStart: 2,
                  associatedAxisEnd: 6,
                  textStyle: const TextStyle(color: Colors.red),
                  dashArray: const <double>[10.0, 20.0],
                  text: 'Winter',
                  isRepeatable: true,
                  repeatUntil: DateTime(2009)),
              PlotBand(
                  start: DateTime(2005),
                  end: DateTime(2009),
                  size: 20,
                  sizeType: DateTimeIntervalType.years,
                  associatedAxisStart: 2,
                  associatedAxisEnd: 6,
                  textStyle: const TextStyle(color: Colors.red),
                  dashArray: const <double>[10.0, 20.0],
                  text: 'Winter',
                  isRepeatable: true,
                  repeatUntil: DateTime(2009)),
            ],
            intervalType: DateTimeIntervalType.years,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type2':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                  start: DateTime(2005),
                  end: DateTime(2009),
                  size: 20,
                  sizeType: DateTimeIntervalType.months,
                  associatedAxisStart: 2,
                  associatedAxisEnd: 6,
                  textStyle: const TextStyle(color: Colors.red),
                  dashArray: const <double>[10.0, 20.0],
                  text: 'Winter',
                  isRepeatable: true,
                  repeatUntil: DateTime(2009)),
              PlotBand(
                  start: DateTime(2005),
                  end: DateTime(2009),
                  sizeType: DateTimeIntervalType.months,
                  size: 20,
                  associatedAxisStart: 2,
                  associatedAxisEnd: 6,
                  textStyle: const TextStyle(color: Colors.black),
                  dashArray: const <double>[10.0, 10.0],
                  text: 'Summer',
                  isRepeatable: true,
                  repeatUntil: DateTime(2009)),
            ],
            intervalType: DateTimeIntervalType.months,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type3':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(plotBands: <PlotBand>[
            PlotBand(
              start: DateTime(2005, 1, 1, 2, 30, 10),
              end: DateTime(2006, 1, 1, 8, 50, 60),
              size: 20,
              sizeType: DateTimeIntervalType.hours,
              associatedAxisStart: 2,
              associatedAxisEnd: 6,
              textStyle: const TextStyle(color: Colors.red),
              dashArray: const <double>[10.0, 20.0],
              text: 'Winter',
              isRepeatable: true,
              repeatUntil: DateTime(2006, 1, 1, 8, 50, 60),
            ),
            PlotBand(
              start: DateTime(2005, 1, 1, 2, 30, 10),
              end: DateTime(2006, 1, 1, 8, 50, 60),
              sizeType: DateTimeIntervalType.hours,
              size: 20,
              associatedAxisStart: 2,
              associatedAxisEnd: 6,
              textStyle: const TextStyle(color: Colors.black),
              dashArray: const <double>[10.0, 10.0],
              text: 'Summer',
              isRepeatable: true,
              repeatUntil: DateTime(2006, 1, 1, 8, 50, 60),
            ),
          ], intervalType: DateTimeIntervalType.hours),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type4':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                start: DateTime(2005, 1, 1, 2, 30, 10),
                end: DateTime(2006, 1, 1, 7, 50, 50),
                size: 20,
                sizeType: DateTimeIntervalType.days,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.red),
                dashArray: const <double>[10.0, 20.0],
                text: 'Winter',
                isRepeatable: true,
                repeatUntil: DateTime(2006, 1, 1, 7, 50, 50),
              ),
              PlotBand(
                start: DateTime(2005, 1, 1, 2, 30, 10),
                end: DateTime(2006, 1, 1, 7, 50, 50),
                sizeType: DateTimeIntervalType.days,
                size: 20,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.black),
                dashArray: const <double>[10.0, 10.0],
                text: 'Summer',
                isRepeatable: true,
                repeatUntil: DateTime(2006, 1, 1, 7, 50, 50),
              ),
            ],
            intervalType: DateTimeIntervalType.days,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type5':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                start: DateTime(2005, 1, 1, 2, 30, 10),
                end: DateTime(2005, 1, 1, 8, 50, 60),
                sizeType: DateTimeIntervalType.minutes,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.red),
                dashArray: const <double>[10.0, 20.0],
                text: 'Winter',
                isRepeatable: true,
                repeatUntil: DateTime(2005, 1, 1, 8, 50, 60),
              ),
              PlotBand(
                start: DateTime(2005, 1, 1, 2, 30, 10),
                end: DateTime(2006, 1, 1, 8, 50, 60),
                sizeType: DateTimeIntervalType.minutes,
                size: 20,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.black),
                dashArray: const <double>[10.0, 10.0],
                text: 'Summer',
                isRepeatable: true,
                repeatUntil: DateTime(2005, 1, 1, 8, 50, 60),
              ),
            ],
            intervalType: DateTimeIntervalType.minutes,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'DateTime Interval Type6':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            plotBands: <PlotBand>[
              PlotBand(
                start: DateTime(2005, 1, 1, 1, 30, 5),
                end: DateTime(2005, 1, 1, 7, 50, 50),
                size: 20,
                sizeType: DateTimeIntervalType.seconds,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.red),
                dashArray: const <double>[10.0, 20.0],
                text: 'Winter',
                isRepeatable: true,
                repeatUntil: DateTime(2005, 1, 1, 7, 50, 50),
              ),
              PlotBand(
                start: DateTime(2005, 1, 1, 0, 0, 5),
                end: DateTime(2005, 1, 1, 7, 50, 50),
                sizeType: DateTimeIntervalType.seconds,
                size: 20,
                associatedAxisStart: 2,
                associatedAxisEnd: 6,
                textStyle: const TextStyle(color: Colors.black),
                dashArray: const <double>[10.0, 10.0],
                text: 'Summer',
                isRepeatable: true,
                repeatUntil: DateTime(2005, 1, 1, 7, 50, 50),
              ),
            ],
            intervalType: DateTimeIntervalType.seconds,
          ),
          primaryYAxis: NumericAxis(plotBands: <PlotBand>[
            PlotBand(
                start: 1,
                end: 5,
                associatedAxisStart: 20,
                associatedAxisEnd: 100),
            PlotBand(
                start: 2,
                end: 7,
                repeatEvery: 2,
                associatedAxisStart: 40,
                associatedAxisEnd: 270),
          ], minimum: 10, maximum: 1000),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.start,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.end,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.center,
            labelPosition: ChartDataLabelPosition.outside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.start,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.end,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_center':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.center,
            labelPosition: ChartDataLabelPosition.outside,
            edgeLabelPlacement: EdgeLabelPlacement.hide,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_near_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.start,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_far_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.end,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_x_labelalignment_center_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.center,
            labelPosition: ChartDataLabelPosition.outside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_near_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.start,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_far_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.end,
            labelPosition: ChartDataLabelPosition.inside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_y_labelalignment_center_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 6,
            interval: 1,
            labelAlignment: LabelAlignment.center,
            labelPosition: ChartDataLabelPosition.outside,
            edgeLabelPlacement: EdgeLabelPlacement.shift,
          ),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<_AxisSample, int?>>[
            LineSeries<_AxisSample, int?>(
              dataSource: data,
              xValueMapper: (_AxisSample sales, _) => sales.xData,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_withoutData':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: DateTimeCategoryAxis(),
      );
      break;
    case 'datetime_category_sortingX_ascending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(),
          series: <ColumnSeries<_AxisSample, DateTime>>[
            ColumnSeries<_AxisSample, DateTime>(
                dataSource: dateCategorydata,
                xValueMapper: (_AxisSample sales, _) => sales.year,
                yValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_AxisSample sales, _) => sales.year,
                sortingOrder: SortingOrder.ascending),
          ]);
      break;
    case 'datetime_category_sortingX_descending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(),
          series: <ColumnSeries<_AxisSample, DateTime>>[
            ColumnSeries<_AxisSample, DateTime>(
                dataSource: dateCategorydata,
                xValueMapper: (_AxisSample sales, _) => sales.year,
                yValueMapper: (_AxisSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_AxisSample sales, _) => sales.year,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'datetime_category_visibleMinMax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.years,
              visibleMinimum: DateTime(2005),
              visibleMaximum: DateTime(2008)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              minimum: DateTime(2005), maximum: DateTime(2019)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_ZoomFactorPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat.y(), zoomFactor: 0.5, zoomPosition: 0.6),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_range_minmax':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              minimum: DateTime(2005), maximum: DateTime(2005)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_edgelabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              opposedPosition: true,
              labelPosition: ChartDataLabelPosition.inside),
          primaryYAxis: NumericAxis(
              opposedPosition: true,
              labelPosition: ChartDataLabelPosition.inside),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(),
          primaryYAxis: NumericAxis(),
          isTransposed: true,
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_bar':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(),
          primaryYAxis: NumericAxis(),
          isTransposed: true,
          series: <ChartSeries<_AxisSample, DateTime>>[
            BarSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
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
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_minorgridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(color: Colors.red),
              majorTickLines: const MajorTickLines(color: Colors.green),
              minorGridLines: const MinorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              minorTickLines: const MinorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelIntersect_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.hide),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.hide),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelIntersect_multiplerows':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.multipleRows),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelIntersect_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.none),
          primaryYAxis:
              NumericAxis(labelIntersectAction: AxisLabelIntersectAction.none),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelIntersect_45':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate45),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_labelIntersect_90':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.rotate90,
          ),
          primaryYAxis: NumericAxis(
              labelIntersectAction: AxisLabelIntersectAction.rotate90),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_dateFormat':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(dateFormat: DateFormat.y()),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_AxisSample, DateTime>>[
            LineSeries<_AxisSample, DateTime>(
              dataSource: dateCategorydata,
              xValueMapper: (_AxisSample sales, _) => sales.year,
              yValueMapper: (_AxisSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_category_intervalType_year':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(intervalType: DateTimeIntervalType.months),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011), 32),
                _DateTimeData(DateTime(2012, 2), 24),
                _DateTimeData(DateTime(2013, 2), 36),
                _DateTimeData(DateTime(2014, 2), 38),
                _DateTimeData(
                  DateTime(2015, 2),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_minutes':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.minutes,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_round_minutes':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.minutes,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_round_seconds':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
            intervalType: DateTimeIntervalType.seconds,
            rangePadding: ChartRangePadding.round,
          ),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_seconds':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.seconds,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2018, 2, 1, 17, 2, 21), 32),
                _DateTimeData(DateTime(2018, 2, 1, 18, 34, 2), 24),
                _DateTimeData(DateTime(2018, 2, 1, 19, 23, 7), 36),
                _DateTimeData(DateTime(2018, 2, 1, 20, 31, 41), 38),
                _DateTimeData(
                  DateTime(2018, 2, 1, 21, 26, 40),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_round_years':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.years,
              rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011), 32),
                _DateTimeData(DateTime(2012, 2), 24),
                _DateTimeData(DateTime(2013, 2), 36),
                _DateTimeData(DateTime(2014, 2), 38),
                _DateTimeData(
                  DateTime(2015, 2),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_rangePadding_years':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeCategoryAxis(
              intervalType: DateTimeIntervalType.years,
              rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2011), 32),
                _DateTimeData(DateTime(2012, 2), 24),
                _DateTimeData(DateTime(2013, 2), 36),
                _DateTimeData(DateTime(2014, 2), 38),
                _DateTimeData(
                  DateTime(2015, 2),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
            ),
          ]);
      break;
    case 'datetime_category_intervalType_months':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeCategoryAxis(intervalType: DateTimeIntervalType.months),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<_DateTimeData, DateTime>>[
            LineSeries<_DateTimeData, DateTime>(
              dataSource: <_DateTimeData>[
                _DateTimeData(DateTime(2019, 11), 32),
                _DateTimeData(DateTime(2018), 24),
                _DateTimeData(DateTime(2018, 2), 36),
                _DateTimeData(DateTime(2018, 3), 38),
                _DateTimeData(
                  DateTime(2018, 4),
                  54,
                )
              ],
              xValueMapper: (_DateTimeData sales, _) => sales.x,
              yValueMapper: (_DateTimeData sales, _) => sales.y,
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

class _AxisData {
  _AxisData(this.x, this.y);
  final double x;
  final double y;
}

class _AxisSample {
  _AxisSample(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4,
      [this.xData, this.lineColor]);
  final DateTime year;
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
  final int? xData;
  final Color? lineColor;
}

class _CategoryData {
  _CategoryData(this.x, this.y);
  final String x;
  final double y;
}

class _DateTimeData {
  _DateTimeData(this.x, this.y);
  final DateTime x;
  final double y;
}
