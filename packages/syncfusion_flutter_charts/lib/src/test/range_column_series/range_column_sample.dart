import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the range column sample
SfCartesianChart getRangeColumnchart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <RangeColumnSample>[
    RangeColumnSample(DateTime(2005, 0), 'Sun', 1, 3.1, 10.8, 2.5, 9.8),
    RangeColumnSample(DateTime(2006, 0), 'Mon', 2, 5.7, 14.4, 4.7, 11.4),
    RangeColumnSample(DateTime(2007, 0), 'Tue', 3, 8.4, 16.9, 6.4, 14.4),
    RangeColumnSample(DateTime(2008, 0), 'Wed', 4, 10.6, 19.2, 9.6, 17.2),
    RangeColumnSample(DateTime(2009, 0), 'Thu', 5, 8.5, 8.5, 7.5, 15.1),
    RangeColumnSample(DateTime(2010, 0), 'Fri', 6, 6.0, 12.5, 3.0, 10.5),
    RangeColumnSample(DateTime(2011, 0), 'Sat', 7, 1.5, 6.9, 1.2, 7.0),
  ];
  final dynamic rangeData = <RangeColumnSample>[
    RangeColumnSample(DateTime(2005, 0), 'Sun', 1, null, null, 2.5, 9.8),
    RangeColumnSample(DateTime(2006, 0), 'Mon', 2, 5.7, 14.4, 4.7, 11.4),
    RangeColumnSample(DateTime(2007, 0), 'Tue', 3, 8.4, 16.9, 6.4, 14.4),
    RangeColumnSample(DateTime(2008, 0), 'Wed', 4, null, 19.2, 9.6, 17.2),
    RangeColumnSample(DateTime(2009, 0), 'Thu', 5, 8.5, 8.5, 7.5, 15.1),
    RangeColumnSample(DateTime(2010, 0), 'Fri', 6, 6.0, 12.5, 3.0, 10.5),
    RangeColumnSample(DateTime(2011, 0), 'Sat', 7, 1.5, null, 1.2, 7.0),
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
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              name: 'India',
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              name: 'India',
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_tracker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              isTrackVisible: true,
              trackBorderColor: Colors.red,
              trackBorderWidth: 2,
              trackPadding: 5,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              isTrackVisible: true,
              trackBorderColor: Colors.red,
              trackBorderWidth: 2,
              trackPadding: 5,
            )
          ]);
      break;

    case 'customization_track_without_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              isTrackVisible: true,
              trackBorderColor: Colors.red,
              trackBorderWidth: 0,
              trackPadding: 5,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              isTrackVisible: true,
              trackBorderColor: Colors.red,
              trackBorderWidth: 0,
              trackPadding: 5,
            )
          ]);
      break;

    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                color: Colors.green,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                isTrackVisible: true,
                trackBorderColor: Colors.red,
                trackBorderWidth: 0,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                color: Colors.green,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                isTrackVisible: true,
                trackBorderColor: Colors.red,
                trackBorderWidth: 0,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;

    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 0,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 0,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.blue),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red)
          ]);
      break;

    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                gradient: gradientColors),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                gradient: gradientColors)
          ]);
      break;

    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
            )
          ]);
      break;
    case 'category_EdgeLabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'category_EdgeLabelPlacement_shift':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              width: 1,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
            )
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              enableTooltip: true,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              enableTooltip: true,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;

    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.blue,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
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
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
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
    case 'range_tooltip_format':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              format: 'point.y%',
              activationMode: ActivationMode.longPress),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red)
          ]);
      break;

    case 'marker_EmptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.average, color: Colors.green))
          ]);
      break;
    case 'marker_rect':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.rectangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_pentagon':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.pentagon,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_verticalLine':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.verticalLine,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_invertTriangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.invertedTriangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;
    case 'marker_triangle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.triangle,
                    borderColor: Colors.red,
                    borderWidth: 5))
          ]);
      break;

    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;

    case 'dataLabel_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  margin: EdgeInsets.zero,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  useSeriesColor: true,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  margin: EdgeInsets.zero,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic sales, dynamic series, dynamic point,
                        int pointIndex, int seriesIndex) {
                      return Text(sales.category);
                    })),
          ]);
      break;
    case 'dataLabel_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
              ),
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
              color: Colors.green,
              pointColorMapper: (RangeColumnSample sales, _) => Colors.red,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.middle,
              ),
            )
          ]);
      break;
    case 'dataLabel_series_color':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
              color: Colors.green,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.middle,
                  useSeriesColor: true),
            ),
            RangeColumnSeries<RangeColumnSample, dynamic>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.category,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_outer_near':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  alignment: ChartAlignment.near,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.outer,
                  alignment: ChartAlignment.near,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.top,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.top,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_top_far':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.far,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  labelAlignment: ChartDataLabelAlignment.top,
                  alignment: ChartAlignment.far,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'dataLabel_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            )
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <RangeColumnSeries<RangeColumnSample, DateTime>>[
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
              highValueMapper: (RangeColumnSample sales, _) => sales.high1,
            ),
            RangeColumnSeries<RangeColumnSample, DateTime>(
              dataSource: data,
              xValueMapper: (RangeColumnSample sales, _) => sales.year,
              lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
              highValueMapper: (RangeColumnSample sales, _) => sales.high2,
            )
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries<RangeColumnSample, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low2,
                highValueMapper: (RangeColumnSample sales, _) => sales.high2,
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
    case 'NumericAxis-PointIndex':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <CartesianSeries<dynamic, dynamic>>[
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: rangeData,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                emptyPointSettings: EmptyPointSettings(
                    // Mode of empty point
                    mode: EmptyPointMode.average)),
            RangeColumnSeries<RangeColumnSample, dynamic>(
                dataSource: rangeData,
                xValueMapper: (RangeColumnSample sales, _) => sales.category,
                lowValueMapper: (RangeColumnSample sales, _) => sales.low1,
                highValueMapper: (RangeColumnSample sales, _) => sales.high1,
                emptyPointSettings: EmptyPointSettings(
                    // Mode of empty point
                    mode: EmptyPointMode.average))
          ]);
      break;

    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }

  return chart;
}

/// Represents the range column sample
class RangeColumnSample {
  /// Creates an instance for range column sample
  RangeColumnSample(this.year, this.category, this.numeric, this.low1,
      this.high1, this.low2, this.high2);

  /// Holds the category value
  final String category;

  /// Holds the year value
  final DateTime year;

  /// Holds the numeric value
  final double numeric;

  /// Holds the low1 value
  final num? low1;

  /// Holds the high1 value
  final num? high1;

  /// Holds the low2 value
  final num low2;

  /// Holds the high2 value
  final num high2;
}
