import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the pie chart sample
SfCircularChart? getPiechart(String sampleName) {
  SfCircularChart? chart;
  final dynamic data = <PieSample>[
    PieSample('India', 1, 32, 28, Colors.deepOrange),
    PieSample('China', 2, 24, 44, Colors.deepPurple),
    PieSample('USA', 3, 36, 48, Colors.lightGreen),
    PieSample('Japan', 4, 38, 50, Colors.red),
    PieSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'customization_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
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
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
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
                    width: 30,
                    height: 30,
                    child: Text('horizontal annotation')))
          ],
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
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
                    width: 30, height: 30, child: Text('Vertical annotation')))
          ],
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'selection_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_onpoint_tapped':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                onPointTap: (ChartPointDetails details) => _point1(details),
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_singletap_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          selectionGesture: ActivationMode.singleTap,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_double_tap_multiselection':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          enableMultiSelection: true,
          selectionGesture: ActivationMode.doubleTap,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.longPress,
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
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
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
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
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
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
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization_update':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
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
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'tooltip_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              borderColor: Colors.red,
              borderWidth: 5,
              color: Colors.lightBlue),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_label_format':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true, format: 'point.y%'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_mode_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              activationMode: ActivationMode.doubleTap,
              format: 'point.y%'),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Customized Text';
          },
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                enableTooltip: true,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_series_no_tooltip_format':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Customized Text';
          },
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                enableTooltip: true,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_series_disable_tooltip':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Customized Text';
          },
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'tooltip_mode_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            activationMode: ActivationMode.longPress,
          ),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'customization_tooltip_template':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;

    case 'single_point':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              startAngle: 0,
              endAngle: 360,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_pointcolor':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_centerXY':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_title':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(
              text: 'Pie Series',
              alignment: ChartAlignment.near,
              textStyle:
                  const TextStyle(fontSize: 12, color: Colors.deepPurple)),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_margin':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color)
          ]);
      break;
    case 'customization_start_end_angle':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: 45,
                endAngle: 300)
          ]);
      break;
    case 'customization_start_high':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: 245,
                endAngle: 200)
          ]);
      break;
    case 'customization_start_end_equal':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: 45,
                endAngle: 45)
          ]);
      break;
    case 'start_end_360':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: 380,
                endAngle: 560)
          ]);
      break;
    case 'start_end_-1_-360':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: -190,
                endAngle: -280)
          ]);
      break;
    case 'start_end_-360':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                startAngle: -380,
                endAngle: -560)
          ]);
      break;
    case 'pie_explode_single_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.singleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_single_tap_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.singleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.doubleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_double_tap_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.doubleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_index_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeIndex: 1,
                explodeGesture: ActivationMode.doubleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_all_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeAll: true,
                explodeGesture: ActivationMode.doubleTap,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'pie_explode_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeGesture: ActivationMode.longPress,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'customization_explode':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeIndex: 0)
          ]);
      break;
    case 'customization_explodeAll':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                explode: true,
                explodeAll: true)
          ]);
      break;
    case 'customization_groupPoint':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, num?>>[
            PieSeries<PieSample, num?>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.sales1,
                yValueMapper: (PieSample sales, _) => sales.sales2,
                pointColorMapper: (PieSample sales, _) => sales.color,
                groupMode: CircularChartGroupMode.point,
                groupTo: 2)
          ]);
      break;
    case 'customization_groupValue':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointColorMapper: (PieSample sales, _) => sales.color,
                groupMode: CircularChartGroupMode.value,
                groupTo: 36)
          ]);
      break;
    case 'customization_stroke':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
              strokeColor: Colors.red,
              strokeWidth: 2,
            )
          ]);
      break;
    case 'emptypoint_avg':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 28, Colors.deepOrange),
                  PieSample('China', 2, null, 44, Colors.deepPurple),
                  PieSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
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
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 28, Colors.deepOrange),
                  PieSample('China', 2, null, 44, Colors.deepPurple),
                  PieSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings(
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'emptypoint_drop':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 28, Colors.deepOrange),
                  PieSample('China', 2, null, 44, Colors.deepPurple),
                  PieSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
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
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 28, Colors.deepOrange),
                  PieSample('China', 2, null, 44, Colors.deepPurple),
                  PieSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
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
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 2, Colors.deepOrange, '20%'),
                  PieSample('China', 2, 21, 4, Colors.deepPurple, '44%'),
                  PieSample('USA', 3, 36, 3, Colors.lightGreen, '30%'),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                pointRadiusMapper: (PieSample sales, _) => sales.radius,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero,
                    color: Colors.cyan,
                    borderColor: Colors.red,
                    borderWidth: 2))
          ]);
      break;
    case 'sorting_ascending':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 2),
                  PieSample('China', 2, 21, 4),
                  PieSample('Spain', 3, 43, 3),
                  PieSample('Japan', 2, 11, 4),
                  PieSample('London', 3, 29, 3),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                sortFieldValueMapper: (PieSample sales, _) => sales.category,
                sortingOrder: SortingOrder.ascending)
          ]);
      break;
    case 'sorting_ascending_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 2, Colors.deepOrange, '20%'),
                  PieSample('China', 2, 21, 4, Colors.deepPurple, '34%', 'D'),
                  PieSample('Spain', 3, 43, 3, Colors.lightGreen, '40%', 'B'),
                  PieSample('Japan', 2, 11, 4, Colors.red, '25%', 'E'),
                  PieSample('London', 3, 29, 3, Colors.purple, '45%', 'C'),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                sortFieldValueMapper: (PieSample sales, _) => sales.sortValue,
                sortingOrder: SortingOrder.ascending)
          ]);
      break;
    case 'sorting_descending':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 2),
                  PieSample('China', 2, 21, 4),
                  PieSample('Spain', 3, 43, 3),
                  PieSample('Japan', 2, 11, 4),
                  PieSample('London', 3, 29, 3),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                sortFieldValueMapper: (PieSample sales, _) => sales.category,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'sorting_descending_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India', 1, 32, 2, Colors.deepOrange, '20%', 'A'),
                  PieSample('China', 2, 21, 4, Colors.deepPurple, '34%'),
                  PieSample('Spain', 3, 43, 3, Colors.lightGreen, '40%', 'B'),
                  PieSample('Japan', 2, 11, 4, Colors.red, '25%', 'E'),
                  PieSample('London', 3, 29, 3, Colors.purple, '45%', 'C'),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                sortFieldValueMapper: (PieSample sales, _) => sales.sortValue,
                sortingOrder: SortingOrder.descending)
          ]);
      break;
    case 'datalabel_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_pointColor':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, useSeriesColor: true))
          ]);
      break;
    case 'datalabel_template':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                //ignore: prefer_const_constructors
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return Text(point.x.toString());
                    }))
          ]);
      break;
    case 'datalabel_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample(
                      'India got gold medal', 1, 32, 28, Colors.deepOrange),
                  PieSample(
                      'China got silver medal', 2, 24, 44, Colors.deepPurple),
                  PieSample('USA got gola medal', 3, 36, 48, Colors.lightGreen),
                  PieSample('Japan got bronze medal', 4, 38, 50, Colors.red),
                  PieSample('Russia got gold medal', 5, 54, 66, Colors.purple)
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelMapper: (PieSample sales, _) => sales.category,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: const TextStyle(color: Colors.yellow),
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    labelPosition: ChartDataLabelPosition.outside,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return Text(point.x.toString());
                    },
                    connectorLineSettings: const ConnectorLineSettings(
                        color: Colors.black,
                        length: '10%',
                        width: 2,
                        type: ConnectorType.curve)))
          ]);
      break;
    case 'datalabel_customization_ondatalabelrender':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          onDataLabelRender: (DataLabelRenderArgs args) {
            args.text = 'label';
          },
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_saturation':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample(
                      'India got gold medal', 1, 32, 28, Colors.deepOrange),
                  PieSample(
                      'China got silver medal', 2, 24, 44, Colors.deepPurple),
                  PieSample('USA got gola medal', 3, 36, 48, Colors.lightGreen),
                  PieSample('Japan got bronze medal', 4, 38, 50, Colors.red),
                  PieSample('Russia got gold medal', 5, 54, 66, Colors.purple)
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelMapper: (PieSample sales, _) => sales.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside))
          ]);
      break;
    case 'datalabel_connector_line':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India got gold medal', 1, 32, 28),
                  PieSample('China got silver medal', 2, 24, 44),
                  PieSample('USA got gola medal', 3, 36, 48),
                  PieSample('Japan got bronze medal', 4, 38, 50),
                  PieSample('Russia got gold medal', 5, 54, 66),
                  PieSample('USSR got bronze medal', 6, 34, 23),
                  PieSample('Egypt got gold medal', 7, 54, 66),
                  PieSample('Australia got gold medal', 8, 34, 56),
                  PieSample('Singapore got silver medal', 9, 54, 36),
                  PieSample('GreenLand got gold medal', 10, 26, 66),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    connectorLineSettings: ConnectorLineSettings(
                        color: Colors.black,
                        length: '10',
                        width: 2,
                        type: ConnectorType.line)))
          ]);
      break;
    case 'datalabel_collide':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India got gold medal', 1, 32, 28),
                  PieSample('China got silver medal', 2, 24, 44),
                  PieSample('USA got gola medal', 3, 36, 48),
                  PieSample('Japan got bronze medal', 4, 38, 50),
                  PieSample('Russia got gold medal', 5, 54, 66),
                  PieSample('USSR got bronze medal', 6, 34, 23),
                  PieSample('Egypt got gold medal', 7, 54, 66),
                  PieSample('Australia got gold medal', 8, 34, 56),
                  PieSample('Singapore got silver medal', 9, 54, 36),
                  PieSample('GreenLand got gold medal', 10, 26, 66),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2))
          ]);
      break;
    case 'collide_hide':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India got gold medal', 1, 32, 28),
                  PieSample('China got silver medal', 2, 24, 44),
                  PieSample('USA got gola medal', 3, 36, 48),
                  PieSample('Japan got bronze medal', 4, 38, 50),
                  PieSample('Russia got gold medal', 5, 54, 66),
                  PieSample('USSR got bronze medal', 6, 34, 23),
                  PieSample('Egypt got gold medal', 7, 54, 66),
                  PieSample('Australia got gold medal', 8, 34, 56),
                  PieSample('Singapore got silver medal', 9, 54, 36),
                  PieSample('GreenLand got gold medal', 10, 26, 66),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelMapper: (PieSample sales, _) => sales.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    useSeriesColor: true,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    borderRadius: 0,
                    labelIntersectAction: LabelIntersectAction.hide))
          ]);
      break;
    case 'collide_hide_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India got gold medal', 1, 32, 28),
                  PieSample('China got silver medal', 2, 24, 44),
                  PieSample('USA got gola medal', 3, 36, 48),
                  PieSample('Japan got bronze medal', 4, 38, 50),
                  PieSample('Russia got gold medal', 5, 54, 66),
                  PieSample('USSR got bronze medal', 6, 34, 23),
                  PieSample('Egypt got gold medal', 7, 54, 66),
                  PieSample('Australia got gold medal', 8, 34, 56),
                  PieSample('Singapore got silver medal', 9, 54, 36),
                  PieSample('GreenLand got gold medal', 10, 26, 66),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelMapper: (PieSample sales, _) => sales.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    borderRadius: 0,
                    labelIntersectAction: LabelIntersectAction.hide))
          ]);
      break;
    case 'collide_none':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
                animationDuration: 0,
                dataSource: <PieSample>[
                  PieSample('India got gold medal', 1, 32, 28),
                  PieSample('China got silver medal', 2, 24, 44),
                  PieSample('USA got gola medal', 3, 36, 48),
                  PieSample('Japan got bronze medal', 4, 38, 50),
                  PieSample('Russia got gold medal', 5, 54, 66),
                  PieSample('USSR got bronze medal', 6, 34, 23),
                  PieSample('Egypt got gold medal', 7, 54, 66),
                  PieSample('Australia got gold medal', 8, 34, 56),
                  PieSample('Singapore got silver medal', 9, 54, 36),
                  PieSample('GreenLand got gold medal', 10, 26, 66),
                ],
                xValueMapper: (PieSample sales, _) => sales.category,
                yValueMapper: (PieSample sales, _) => sales.sales1,
                dataLabelMapper: (PieSample sales, _) => sales.category,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    borderRadius: 0,
                    labelIntersectAction: LabelIntersectAction.none))
          ]);
      break;
    case 'legend_bottom':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 36, 48, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'legend_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              backgroundColor: Colors.red,
              borderColor: Colors.black,
              borderWidth: 1,
              legendItemBuilder:
                  (String name, dynamic series, dynamic point, int index) {
                return const SizedBox(
                    height: 20, width: 10, child: Text('pie Legend'));
              }),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 36, 48, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'legend_top':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.top,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 36, 48, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'legend_left':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.left,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 36, 48, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'legend_right':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.right,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 36, 48, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'pie_isVisibleForZero':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 0, 0, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                useSeriesColor: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
            )
          ]);
      break;
    case 'pie_renderMode':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 0, 0, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              pointRenderMode: PointRenderMode.gradient,
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'pie_shader':
      chart = SfCircularChart(
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 0, 0, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'pie_shaderwithborder':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          series: <PieSeries<PieSample, String>>[
            PieSeries<PieSample, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: <PieSample>[
                PieSample('India', 1, 32, 28, Colors.deepOrange),
                PieSample('Chinal', 2, 24, 44, Colors.deepPurple),
                PieSample('USA', 3, 0, 0, Colors.lightGreen),
                PieSample('Japan', 4, 38, 50, Colors.red),
                PieSample('Russia', 5, 54, 66, Colors.purple)
              ],
              xValueMapper: (PieSample sales, _) => sales.category,
              yValueMapper: (PieSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'pie_pointshader':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <PieSeries<ShaderData, String>>[
            PieSeries<ShaderData, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: <ShaderData>[
                ShaderData(
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
                ShaderData(
                  'Internet Explorer',
                  40,
                  dart_ui.Gradient.linear(const Offset(72.4, 100.0),
                      const Offset(152.4, 170.0), const <Color>[
                    Color.fromRGBO(75, 135, 185, 1),
                    Color.fromRGBO(192, 108, 132, 1),
                    Color.fromRGBO(246, 114, 128, 1),
                    Color.fromRGBO(248, 177, 149, 1),
                    Color.fromRGBO(116, 180, 155, 1),
                  ], <double>[
                    0.2,
                    0.4,
                    0.6,
                    0.8,
                    1,
                  ]),
                ),
              ],
              xValueMapper: (ShaderData sales, _) => sales.year as String,
              yValueMapper: (ShaderData sales, _) => sales.sales,
              //ignore: always_specify_types
              pointShaderMapper: (sales, _, color, rect) => sales.color,
            )
          ]);
      break;
  }
  return chart;
}

/// Represents the pie sample
class PieSample {
  /// Creates an instance pie sample
  PieSample(this.category, this.numeric, this.sales1, this.sales2,
      [this.color, this.radius, this.sortValue]);

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the sales1 value
  final int? sales1;

  /// Holds the sales2 value
  final int sales2;

  /// Holds the radius value
  final String? radius;

  /// Holds the color value
  final Color? color;

  /// Holds the sort value
  final String? sortValue;
}

/// Represents the shader data
class ShaderData {
  /// Creates an instance of shader data
  ShaderData(this.year, this.sales, this.color);

  /// Holds the year value
  final dynamic year;

  /// Holds the sales value
  final double sales;

  /// Holds the color value
  final Shader color;
}

dynamic _point1(ChartPointDetails args) {
  debugPrint(args.seriesIndex.toString());
}
