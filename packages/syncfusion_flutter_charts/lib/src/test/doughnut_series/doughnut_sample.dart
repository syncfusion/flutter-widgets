import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the doughnut chart
SfCircularChart? getDoughnutchart(String sampleName) {
  SfCircularChart? chart;
  final dynamic data = <_DoughnutSample>[
    _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
    _DoughnutSample('China', 2, 24, 44, Colors.deepPurple),
    _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
    _DoughnutSample('Japan', 4, 38, 50, Colors.red),
    _DoughnutSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'customization_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_pointcolor':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_centerXY':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_title':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(
              text: 'Doughnut Series',
              alignment: ChartAlignment.near,
              textStyle:
                  const TextStyle(fontSize: 12, color: Colors.deepPurple)),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_margin':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_start_end_angle':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                startAngle: 45,
                endAngle: 300)
          ]);
      break;
    case 'customization_explode':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                explode: true,
                explodeIndex: 0)
          ]);
      break;
    case 'customization_explodeAll':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                explode: true,
                explodeAll: true)
          ]);
      break;
    case 'customization_groupPoint':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                groupMode: CircularChartGroupMode.point,
                groupTo: 1)
          ]);
      break;
    case 'customization_groupValue':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                groupMode: CircularChartGroupMode.value,
                groupTo: 36)
          ]);
      break;
    case 'customization_stroke':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              dataSource: data,
              animationDuration: 0,
              //borderRadius: '10',
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
              strokeColor: Colors.red,
              strokeWidth: 2,
            )
          ]);
      break;
    case 'emptypoint_avg':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  _DoughnutSample('China', 2, null, 44, Colors.deepPurple),
                  _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.average,
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'emptypoint_gap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  _DoughnutSample('China', 2, null, 44, Colors.deepPurple),
                  _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings(
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'emptypoint_drop':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  _DoughnutSample('China', 2, null, 44, Colors.deepPurple),
                  _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.drop,
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'emptypoint_zero':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  _DoughnutSample('China', 2, null, 44, Colors.deepPurple),
                  _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero,
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'radiusMapping':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 2, Colors.deepOrange, '20%'),
                  _DoughnutSample('China', 2, 21, 4, Colors.deepPurple, '44%'),
                  _DoughnutSample('USA', 3, 36, 3, Colors.lightGreen, '30%'),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointRadiusMapper: (_DoughnutSample sales, _) => sales.radius,
                animationDuration: 0,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero,
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'sorting':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                animationDuration: 0,
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 2),
                  _DoughnutSample('China', 2, 21, 4),
                  _DoughnutSample('Spain', 3, 43, 3),
                  _DoughnutSample('Japan', 2, 11, 4),
                  _DoughnutSample('London', 3, 29, 3),
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                sortFieldValueMapper: (_DoughnutSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending)
          ]);
      break;
    case 'datalabel_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: <_DoughnutSample>[
                  _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  _DoughnutSample('China', 2, 24, 44, Colors.deepPurple),
                  _DoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                  _DoughnutSample('Japan', 4, 38, 50, Colors.red),
                  _DoughnutSample('Russia', 5, 54, 66, Colors.purple)
                ],
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelMapper: (_DoughnutSample sales, _) => sales.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.blue),
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                        color: Colors.black, length: '10')))
          ]);
      break;
    case 'selection_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: const <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.longPress,
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0,
                    selectedOpacity: 0.5,
                    unselectedOpacity: 1),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization_update':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0,
                    selectedOpacity: 0.5,
                    unselectedOpacity: 1),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_event':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.singleTap,
          onSelectionChanged: (SelectionArgs args) {
            args.selectedColor = Colors.red;
            args.unselectedColor = Colors.lightGreen;
            args.selectedBorderColor = Colors.blue;
            args.unselectedBorderColor = Colors.lightGreen;
            args.selectedBorderWidth = 2;
            args.unselectedBorderWidth = 0;
          },
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: const <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                    enable: true,
                    selectedColor: Colors.red,
                    unselectedColor: Colors.grey,
                    selectedBorderColor: Colors.blue,
                    unselectedBorderColor: Colors.lightGreen,
                    selectedBorderWidth: 2,
                    unselectedBorderWidth: 0,
                    selectedOpacity: 0.5,
                    unselectedOpacity: 1),
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'circular_annotation':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
                angle: 270,
                radius: '55%',
                widget: const SizedBox(
                    width: 30, height: 30, child: Text('annotation')))
          ],
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'circular_annotation_horizontal':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
                angle: 270,
                radius: '55%',
                horizontalAlignment: ChartAlignment.near,
                widget: const SizedBox(
                    width: 30, height: 30, child: Text('annotation')))
          ],
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'circular_annotation_vertical':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
                angle: 270,
                radius: '55%',
                verticalAlignment: ChartAlignment.far,
                widget: const SizedBox(
                    width: 30, height: 30, child: Text('annotation')))
          ],
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'doughnut_explode_single_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.singleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'doughnut_explode_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.doubleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'doughnut_explode_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (_DoughnutSample sales, _) => sales.category,
                yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (_DoughnutSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.longPress,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'doughnut_isVisibleForZero':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              dataSource: data,
              animationDuration: 0,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
              pointColorMapper: (_DoughnutSample sales, _) => sales.color,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                useSeriesColor: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
            )
          ]);
      break;
    case 'doughnut_renderMode':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
              pointColorMapper: (_DoughnutSample sales, _) => sales.color,
              pointRenderMode: PointRenderMode.gradient,
            )
          ]);
      break;
    case 'doughnut_shader':
      chart = SfCircularChart(
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          key: GlobalKey<State<SfCircularChart>>(),
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
              pointColorMapper: (_DoughnutSample sales, _) => sales.color,
            )
          ]);
      break;
    case 'doughnut_shaderwithborder':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          series: <DoughnutSeries<_DoughnutSample, String>>[
            DoughnutSeries<_DoughnutSample, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: <_DoughnutSample>[
                _DoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                _DoughnutSample('Chinal', 2, 24, 44, Colors.deepPurple),
                _DoughnutSample('USA', 3, 0, 0, Colors.lightGreen),
                _DoughnutSample('Japan', 4, 38, 50, Colors.red),
                _DoughnutSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (_DoughnutSample sales, _) => sales.category,
              yValueMapper: (_DoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'doughnut_pointshader':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <DoughnutSeries<_DoughnutShaderData, String>>[
            DoughnutSeries<_DoughnutShaderData, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: <_DoughnutShaderData>[
                _DoughnutShaderData(
                  'chrome',
                  20,
                  dart_ui.Gradient.sweep(const Offset(112.4, 140.0), <Color>[
                    Colors.red,
                    const Color.fromRGBO(248, 177, 149, 1),
                    const Color.fromRGBO(116, 180, 155, 1),
                    Colors.blue,
                  ], <double>[
                    0.25,
                    0.5,
                    0.75,
                    1,
                  ]),
                ),
                _DoughnutShaderData(
                  'Internet Explorer',
                  40,
                  dart_ui.Gradient.linear(const Offset(72.4, 100.0),
                      const Offset(152.4, 170.0), <Color>[
                    const Color.fromRGBO(75, 135, 185, 1),
                    const Color.fromRGBO(192, 108, 132, 1),
                    const Color.fromRGBO(246, 114, 128, 1),
                    const Color.fromRGBO(248, 177, 149, 1),
                    const Color.fromRGBO(116, 180, 155, 1),
                  ], <double>[
                    0.2,
                    0.4,
                    0.6,
                    0.8,
                    1,
                  ]),
                ),
              ],
              xValueMapper: (_DoughnutShaderData sales, _) =>
                  sales.year as String,
              yValueMapper: (_DoughnutShaderData sales, _) => sales.sales,
              pointShaderMapper:
                  (_DoughnutShaderData sales, int _, Color color, Rect rect) =>
                      sales.color,
            )
          ]);
      break;
  }
  return chart;
}

class _DoughnutSample {
  _DoughnutSample(this.category, this.numeric, this.sales1, this.sales2,
      [this.color, this.radius]);
  final String category;
  final double numeric;
  final int? sales1;
  final int sales2;
  final String? radius;
  final Color? color;
}

class _DoughnutShaderData {
  _DoughnutShaderData(this.year, this.sales, this.color);

  final dynamic year;
  final double sales;
  final Shader color;
}
