import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Holds the radial bar chart
SfCircularChart? getRadialbarchart(String sampleName) {
  SfCircularChart? chart;
  final dynamic data = <RadialbarSample>[
    RadialbarSample('Labour', 75, Colors.deepOrange),
    RadialbarSample('Legal', 80, Colors.deepPurple),
    RadialbarSample('Production', 60, Colors.lightGreen),
    RadialbarSample('License', 85, Colors.red),
    RadialbarSample('Facilities', 91, Colors.purple)
  ];
  switch (sampleName) {
    case 'datalabel_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Radialbar Series'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_pointColor':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Radialbar Series'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true, useSeriesColor: true))
          ]);
      break;
    case 'datalabel_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Radialbar Series'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  borderColor: Colors.black,
                  borderWidth: 2,
                ))
          ]);
      break;
    case 'tooltip_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'tooltip_label_format':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(enable: true, format: 'point.y%'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'tooltip_mode_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.longPress),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'single_point':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: <RadialbarSample>[
                RadialbarSample('Labour', 75, Colors.deepOrange),
              ],
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'customization_title':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(
              text: 'RadialBar Series',
              alignment: ChartAlignment.near,
              textStyle:
                  const TextStyle(fontSize: 12, color: Colors.deepPurple)),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                pointColorMapper: (RadialbarSample data, _) => data.color)
          ]);
      break;
    case 'customization_margin':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                pointColorMapper: (RadialbarSample data, _) => data.color)
          ]);
      break;
    case 'legend_bottom':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'legend_top':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'legend_left':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.left,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'legend_right':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.right,
            backgroundColor: Colors.red,
            borderColor: Colors.black,
            borderWidth: 1,
          ),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'radiusMapping':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'RadialBar Series'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: <RadialbarSample>[
                  RadialbarSample('Labour', 75, Colors.deepOrange, '20%'),
                  RadialbarSample('Legal', 80, Colors.deepPurple, '44%'),
                  RadialbarSample('Production', 60, Colors.lightGreen, '30%'),
                ],
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                pointRadiusMapper: (RadialbarSample data, _) => data.radius)
          ]);
      break;
    case 'sorting':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Radialbar Series'),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                animationDuration: 0,
                dataSource: <RadialbarSample>[
                  RadialbarSample('Labour', 75),
                  RadialbarSample('Legal', 80),
                  RadialbarSample('Production', 60),
                  RadialbarSample('License', 85),
                  RadialbarSample('Facilities', 91),
                ],
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                sortFieldValueMapper: (RadialbarSample data, _) => data.xVal,
                sortingOrder: SortingOrder.ascending)
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
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
                  width: 30,
                  height: 30,
                  child: Text('Annotation'),
                ))
          ],
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'selection_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
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
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
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
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_double_tap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_long_press':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          selectionGesture: ActivationMode.longPress,
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
                dataSource: data,
                animationDuration: 0,
                initialSelectedDataIndexes: <int>[1, 0],
                selectionBehavior: SelectionBehavior(
                  enable: true,
                ),
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
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
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'selection_customization_update':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
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
                xValueMapper: (RadialbarSample data, _) => data.xVal,
                yValueMapper: (RadialbarSample data, _) => data.yVal,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'radial_isVisibleForZero':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                showZeroValue: false,
                useSeriesColor: true,
                labelPosition: ChartDataLabelPosition.outside,
              ),
            )
          ]);
      break;
    case 'radialbar_shader':
      chart = SfCircularChart(
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'radialbar_shaderwithborder':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          onCreateShader: (ChartShaderDetails chartShaderDetails) {
            return dart_ui.Gradient.linear(
                chartShaderDetails.outerRect.topRight,
                chartShaderDetails.outerRect.centerLeft,
                <Color>[Colors.red, Colors.green],
                <double>[0.5, 1]);
          },
          series: <RadialBarSeries<RadialbarSample, String>>[
            RadialBarSeries<RadialbarSample, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: data,
              xValueMapper: (RadialbarSample data, _) => data.xVal,
              yValueMapper: (RadialbarSample data, _) => data.yVal,
            )
          ]);
      break;
    case 'radialbar_pointshader':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<RadialShaderData, String>>[
            RadialBarSeries<RadialShaderData, String>(
              animationDuration: 0,
              strokeColor: Colors.red,
              strokeWidth: 6,
              dataSource: <RadialShaderData>[
                RadialShaderData(
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
                RadialShaderData(
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
              xValueMapper: (RadialShaderData sales, _) => sales.year as String,
              yValueMapper: (RadialShaderData sales, _) => sales.sales,
              //ignore: always_specify_types
              pointShaderMapper: (sales, _, color, rect) => sales.color,
            )
          ]);
      break;
  }
  return chart;
}

/// Creates the radial shader data
class RadialShaderData {
  /// Creates an instance of radial shader data
  RadialShaderData(this.year, this.sales, this.color);

  /// Holds the year value
  final dynamic year;

  /// Holds the sales value
  final double sales;

  /// Holds the color value
  final Shader color;
}

/// Represents the radial bar sample
class RadialbarSample {
  /// creates an instance of radial bar sample
  RadialbarSample(this.xVal, this.yVal, [this.color, this.radius]);

  /// Holds the xval
  final String xVal;

  /// Holds the yVal
  final int yVal;

  /// Holds the color value
  final Color? color;

  /// Holds the radius value
  final String? radius;
}
