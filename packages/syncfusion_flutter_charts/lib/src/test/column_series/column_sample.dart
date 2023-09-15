import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../charts.dart';

/// Represents the column data
dynamic columnData;

/// method to get the column chart
SfCartesianChart getColumnchart(String sampleName) {
  SfCartesianChart chart;
  columnData = <ColumnSample>[
    ColumnSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    ColumnSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    ColumnSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    ColumnSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    ColumnSample(
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
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (ColumnSample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 0,
            )
          ]);
      break;
    case 'column_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              selectionBehavior: SelectionBehavior(enable: true),
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => sales.lineColor)
          ]);
      break;
    case 'customization_selection_initial_render':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => sales.lineColor)
          ]);
      break;
    case 'customization_tracker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              pointColorMapper: (ColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 2,
              trackPadding: 5,
            )
          ]);
      break;
    case 'customization_track_without_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              pointColorMapper: (ColumnSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 0,
              trackPadding: 5,
            )
          ]);
      break;
    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.blue,
                isTrackVisible: true,
                trackBorderColor: Colors.red,
                trackBorderWidth: 2,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true),
                gradient: gradientColors)
          ]);
      break;
    case 'animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              isTrackVisible: true,
            )
          ]);
      break;
    case 'animation_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              isTrackVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              animationDuration: 1400,
              isTrackVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                animationDuration: 1200,
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880,
                      2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788,
                      3, Colors.lightGreen),
                ],
                isTrackVisible: true,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far))
          ]);
      break;
    case 'animation_transpose_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                animationDuration: 1350,
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880,
                      2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788,
                      3, Colors.lightGreen),
                ],
                isTrackVisible: true,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near))
          ]);
      break;
    case 'animation_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              animationDuration: 1250,
              isTrackVisible: true,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                animationDuration: 1150,
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880,
                      2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788,
                      3, Colors.lightGreen),
                ],
                isTrackVisible: true,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'animation_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                animationDuration: 1150,
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880,
                      2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788,
                      3, Colors.lightGreen),
                ],
                isTrackVisible: true,
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortFieldValueMapper: (ColumnSample sales, _) => sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'sortingX_Ascending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortFieldValueMapper: (ColumnSample sales, _) => sales.category,
                sortingOrder: SortingOrder.ascending),
          ]);
      break;
    case 'sortingY_Ascending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortFieldValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortingOrder: SortingOrder.ascending),
          ]);
      break;
    case 'sortingY_Descending':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortFieldValueMapper: (ColumnSample sales, _) => sales.sales1,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'dataSource_x_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', null, 32, 28, 680,
                      760, 1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, 45, 44, 550, 880,
                      2, Colors.deepPurple),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 4, Colors.red),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 4, Colors.red),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 4, Colors.red),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_avg_first_null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ChartSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, null, 28, 680,
                      760, 1, Colors.deepOrange),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760,
                      1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 4, Colors.red),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, null, 28, 680,
                      760, 1, Colors.deepOrange),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 2, Colors.deepPurple),
                  ColumnSample(DateTime(2007, 0), 'USA', 3, null, 48, 440, 788,
                      3, Colors.lightGreen),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 4, Colors.red),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.numeric,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, String>>[
            LineSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<ColumnSample, DateTime>>[
            LineSeries<ColumnSample, DateTime>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.year,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <LineSeries<ColumnSample, int?>>[
            LineSeries<ColumnSample, int?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.xData,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
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
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.blue,
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
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
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
    case 'marker_rect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_pentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_verticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_invertTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_triangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                pointColorMapper: (ColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 0,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_bottom_with_center_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_bottom_with_near_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.near,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_bottom_with_far_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    alignment: ChartAlignment.far,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_top_with_center_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_top_with_near_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    alignment: ChartAlignment.near,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_top_with_far_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    alignment: ChartAlignment.far,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_middle_with_center_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_middle_with_near_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.near,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_middle_with_far_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    alignment: ChartAlignment.far,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_outer_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.outer,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_template_auto_alignment':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'series_visibility_dataLabel_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                animationDuration: 2000,
                isVisible: false,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    })),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
              labelFormat: '{value}%', numberFormat: NumberFormat.currency()),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: <ColumnSample>[
                  ColumnSample(DateTime(2005, 0), 'India', 1, null, 28, 680,
                      760, 1, Colors.red),
                  ColumnSample(DateTime(2006, 0), 'China', 2, null, 44, 550,
                      880, 1, Colors.green),
                  ColumnSample(DateTime(2007, 0), 'USA', -3, null, 48, 440, 788,
                      1, Colors.yellow),
                  ColumnSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350,
                      560, 1, Colors.orange),
                ],
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.numeric,
                dataLabelMapper: (ColumnSample sales, _) => sales.category,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelIntersectAction: LabelIntersectAction.none,
                    useSeriesColor: true,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.top,
                    borderWidth: 2,
                    borderColor: Colors.grey,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ],
          isTransposed: true);
      break;
    case 'dataLabel_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  margin: EdgeInsets.zero,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              animationDuration: 0,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              pointColorMapper: (ColumnSample sales, _) => sales.lineColor,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                useSeriesColor: true,
                labelAlignment: ChartDataLabelAlignment.middle,
              ),
            )
          ]);
      break;
    case 'dataLabel_series_color':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 1, maximum: 5),
          primaryYAxis: NumericAxis(minimum: 25, maximum: 55),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              animationDuration: 0,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              color: Colors.green,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  useSeriesColor: true),
            )
          ]);
      break;
    case 'dataLabel_outer':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
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
    case 'dataLabel_top_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.far,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
                enableTooltip: true,
                dataSource: columnData,
                xValueMapper: (ColumnSample sales, _) => sales.category,
                yValueMapper: (ColumnSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'column_series_tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Customized Text';
            args.header = 'Tooltip sample';
          },
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'tooltip_opposed_position':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
          ),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Customized Text';
            args.header = 'Tooltip sample';
          },
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_tooltip_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.doubleTap,
              format: 'point.y%'),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              animationDuration: 0,
            )
          ]);
      break;

    case 'column_series_tooltip_long_press':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.longPress),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_tooltip_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              animationDuration: 2000,
              activationMode: ActivationMode.doubleTap,
              // Templating the tooltip
              builder: (dynamic columnData, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_trackball':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap));
      break;
    case 'column_series_trackball_dash_array_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_dash_array_isTransposed_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'column_series_trackball_dash_array':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_dash_array_isTransposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'column_series_trackball_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap));
      break;

    case 'trackball_display_mode':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'trackball_tooltip_align_near':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.near),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'trackball_tooltip_align_far':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.far),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'column_series_trackball_double_tap':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
        trackballBehavior: TrackballBehavior(
            enable: true, activationMode: ActivationMode.doubleTap),
      );
      break;

    case 'column_series_trackball_long_press':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
        trackballBehavior: TrackballBehavior(enable: true),
      );
      break;
    case 'column_series_crosshair':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        crosshairBehavior: CrosshairBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;
    case 'column_series_crosshair_renderer':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(
          opposedPosition: true,
        ),
        primaryYAxis: NumericAxis(opposedPosition: true),
        onCrosshairPositionChanging: (CrosshairRenderArgs args) {
          args.text = 'crosshair';
        },
        crosshairBehavior: CrosshairBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;
    case 'column_series_crosshair_double_tap':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        crosshairBehavior: CrosshairBehavior(
            enable: true, activationMode: ActivationMode.doubleTap),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'column_series_crosshair_long_press':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        crosshairBehavior: CrosshairBehavior(enable: true),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            enableTooltip: true,
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'column_series_crosshair_dash_array':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis:
            CategoryAxis(interactiveTooltip: const InteractiveTooltip()),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            dashArray: <double>[5, 5],
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
        crosshairBehavior: CrosshairBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
      );
      break;

    case 'column_series_crosshair_track_line_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineColor: Colors.red,
              lineDashArray: const <double>[2, 3],
              lineWidth: 2,
              lineType: CrosshairLineType.vertical),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              animationDuration: 0,
            )
          ]);
      break;

    case 'column_series_crosshair_track_line_horizontal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineColor: Colors.red,
              lineDashArray: const <double>[5, 5],
              lineWidth: 2,
              lineType: CrosshairLineType.horizontal),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_default_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(enable: true),
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_initial_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              initialSelectedDataIndexes: <int>[0, 1],
              selectionBehavior: SelectionBehavior(enable: true),
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_multi_selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          enableMultiSelection: true,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              initialSelectedDataIndexes: <int>[0, 2],
              selectionBehavior: SelectionBehavior(enable: true),
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_selection_mode_point':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          //    onSelectionChanged: (SelectionArgs args){
          //   // args.selectedColor = Colors.red;
          //   args.unselectedColor = Colors.lightGreen;
          // },
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.point,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  selectedColor: Colors.red,
                  enable: true),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_selection_mode_series':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.series,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_selection_mode_cluster':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          selectionType: SelectionType.cluster,
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_selection_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
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
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_selection_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_selection_long_press':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.longPress,
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_pinch_Zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables pinch zooming
              enablePinching: true),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              enableTooltip: true,
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'column_series_selection_Zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables selection zooming
              enableSelectionZooming: true,
              maximumZoomLevel: 10),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'selection_zoom_axis_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
            // Enables selection zooming
            enableSelectionZooming: true,
          ),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'column_series_double_tap_Zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables double tap zooming
              enableDoubleTapZooming: true),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'double_tap_Zoom_with_pan':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables double tap zooming
              enableDoubleTapZooming: true,
              enablePanning: true),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'selectionZoom_mode_x':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables selection zooming
              enableSelectionZooming: true,
              zoomMode: ZoomMode.x),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'selectionZoom_mode_y':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables selection zooming
              enableSelectionZooming: true,
              zoomMode: ZoomMode.y),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'doubleTapZoom_maxZoomLevel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              maximumZoomLevel: 5, enableDoubleTapZooming: true),
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'double_tap_withPan_invertedAxis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              // Enables double tap zooming
              enableDoubleTapZooming: true,
              enablePanning: true),
          primaryXAxis: CategoryAxis(isInversed: true),
          series: <ColumnSeries<ColumnSample, String>>[
            ColumnSeries<ColumnSample, String>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.category,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'crosshair_onPositionChange':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(
            interactiveTooltip: const InteractiveTooltip(color: Colors.red)),
        primaryYAxis: NumericAxis(
            interactiveTooltip: const InteractiveTooltip(color: Colors.red)),
        onCrosshairPositionChanging: (CrosshairRenderArgs args) {
          args.text = 'myText';
          args.lineColor = Colors.deepPurpleAccent;
        },
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            shouldAlwaysShow: true,
            activationMode: ActivationMode.singleTap),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;
    case 'crosshair_onPositionChange_opposedAxis':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(
            opposedPosition: true,
            interactiveTooltip: const InteractiveTooltip(color: Colors.red)),
        primaryYAxis: NumericAxis(
            interactiveTooltip: const InteractiveTooltip(color: Colors.red)),
        onCrosshairPositionChanging: (CrosshairRenderArgs args) {
          args.text = 'myText';
          args.lineColor = Colors.deepPurpleAccent;
        },
        crosshairBehavior: CrosshairBehavior(
            enable: true,
            shouldAlwaysShow: true,
            activationMode: ActivationMode.singleTap),
        series: <ColumnSeries<ColumnSample, String>>[
          ColumnSeries<ColumnSample, String>(
            dataSource: columnData,
            xValueMapper: (ColumnSample sales, _) => sales.category,
            yValueMapper: (ColumnSample sales, _) => sales.sales1,
          )
        ],
      );
      break;
    case 'customization_fill_color_with_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              color: Colors.blue.withOpacity(0.5),
              borderColor: Colors.red,
              borderWidth: 2,
            )
          ]);
      break;
    case 'customization_border_color_with_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<ColumnSample, num?>>[
            ColumnSeries<ColumnSample, num?>(
              dataSource: columnData,
              xValueMapper: (ColumnSample sales, _) => sales.numeric,
              yValueMapper: (ColumnSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red.withOpacity(0.5),
              borderWidth: 2,
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

/// Represents the column sample
class ColumnSample {
  /// Holds the value of column sample
  ColumnSample(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4,
      [this.xData, this.lineColor]);

  /// Holds the year value
  final DateTime year;

  /// Holds the caetogry value
  final String category;

  /// Holds the numeric value
  final double? numeric;

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

  /// Holds the value of line colors
  final Color? lineColor;
}
