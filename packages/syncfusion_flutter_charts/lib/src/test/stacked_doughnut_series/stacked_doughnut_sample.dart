import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the stacked doughnut sample
SfCircularChart? getStackedDoughnut(String sampleName) {
  SfCircularChart? chart;
  final dynamic data = <StackedDoughnutSample>[
    StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
    StackedDoughnutSample('China', 2, 24, 44, Colors.deepPurple),
    StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
    StackedDoughnutSample('Japan', 4, 38, 50, Colors.red),
    StackedDoughnutSample('Russia', 5, 54, 66, Colors.purple)
  ];
  switch (sampleName) {
    case 'customization_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: data,
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_pointcolor':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (StackedDoughnutSample sales, _) =>
                    sales.color)
          ]);
      break;
    case 'customization_centerXY':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (StackedDoughnutSample sales, _) =>
                    sales.color)
          ]);
      break;
    case 'customization_title':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(
              text: 'Stacked Doughnut Series',
              alignment: ChartAlignment.near,
              textStyle:
                  const TextStyle(fontSize: 12, color: Colors.deepPurple)),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (StackedDoughnutSample sales, _) =>
                    sales.color)
          ]);
      break;
    case 'customization_margin':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          centerX: '65%',
          centerY: '35%',
          margin: const EdgeInsets.all(20),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (StackedDoughnutSample sales, _) =>
                    sales.color)
          ]);
      break;
    case 'customization_start_end_angle':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Default Rendering'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                pointColorMapper: (StackedDoughnutSample sales, _) =>
                    sales.color)
          ]);
      break;
    case 'customization_stroke':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: data,
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
              strokeColor: Colors.red,
              strokeWidth: 2,
            )
          ]);
      break;

    case 'customization_gap':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: <StackedDoughnutSample>[
                StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                StackedDoughnutSample('China', 2, null, 44, Colors.deepPurple),
                StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
              ],
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
              gap: '2%',
            )
          ]);
      break;
    case 'customization_roundedCornder':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: <StackedDoughnutSample>[
                  StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  StackedDoughnutSample(
                      'China', 2, null, 44, Colors.deepPurple),
                  StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                ],
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1)
          ]);
      break;
    case 'radiusMapping':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Doughnut Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: <StackedDoughnutSample>[
                StackedDoughnutSample(
                    'India', 1, 32, 2, Colors.deepOrange, '20%'),
                StackedDoughnutSample(
                    'China', 2, 21, 4, Colors.deepPurple, '44%'),
                StackedDoughnutSample(
                    'USA', 3, 36, 3, Colors.lightGreen, '30%'),
              ],
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
              pointRadiusMapper: (StackedDoughnutSample sales, _) =>
                  sales.radius,
            )
          ]);
      break;
    case 'sorting':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                animationDuration: 0,
                dataSource: <StackedDoughnutSample>[
                  StackedDoughnutSample('India', 1, 32, 2),
                  StackedDoughnutSample('China', 2, 21, 4),
                  StackedDoughnutSample('Spain', 3, 43, 3),
                  StackedDoughnutSample('Japan', 2, 11, 4),
                  StackedDoughnutSample('London', 3, 29, 3),
                ],
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                sortFieldValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                sortingOrder: SortingOrder.ascending,
                cornerStyle: CornerStyle.bothCurve)
          ]);
      break;
    case 'corner_bothEnds':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: <StackedDoughnutSample>[
                StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                StackedDoughnutSample('China', 2, 24, 44, Colors.deepPurple),
                StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
              ],
              cornerStyle: CornerStyle.bothCurve,
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'corner_endCurve':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: <StackedDoughnutSample>[
                StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                StackedDoughnutSample('China', 2, 24, 44, Colors.deepPurple),
                StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
              ],
              cornerStyle: CornerStyle.endCurve,
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'corner_startCurve':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
              dataSource: <StackedDoughnutSample>[
                StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                StackedDoughnutSample('China', 2, 24, 44, Colors.deepPurple),
                StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
              ],
              cornerStyle: CornerStyle.startCurve,
              xValueMapper: (StackedDoughnutSample sales, _) => sales.category,
              yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'datalabel_default':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: data,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_mapper':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Pie Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                animationDuration: 0,
                dataSource: <StackedDoughnutSample>[
                  StackedDoughnutSample('India', 1, 32, 28, Colors.deepOrange),
                  StackedDoughnutSample('China', 2, 24, 44, Colors.deepPurple),
                  StackedDoughnutSample('USA', 3, 36, 48, Colors.lightGreen),
                  StackedDoughnutSample('Japan', 4, 38, 50, Colors.red),
                  StackedDoughnutSample('Russia', 5, 54, 66, Colors.purple)
                ],
                opacity: 0.5,
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                dataLabelMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'datalabel_customization':
      chart = SfCircularChart(
          key: GlobalKey<State<SfCircularChart>>(),
          title: ChartTitle(text: 'Radial bar Series'),
          series: <RadialBarSeries<StackedDoughnutSample, String>>[
            RadialBarSeries<StackedDoughnutSample, String>(
                dataSource: <StackedDoughnutSample>[
                  StackedDoughnutSample(
                      'India got gold medal', 1, 32, 28, Colors.deepOrange),
                  StackedDoughnutSample(
                      'China got silver medal', 2, 24, 44, Colors.deepPurple),
                  StackedDoughnutSample(
                      'USA got gola medal', 3, 36, 48, Colors.lightGreen),
                  StackedDoughnutSample(
                      'Japan got bronze medal', 4, 38, 50, Colors.red),
                  StackedDoughnutSample(
                      'Russia got gold medal', 5, 54, 66, Colors.purple)
                ],
                xValueMapper: (StackedDoughnutSample sales, _) =>
                    sales.category,
                yValueMapper: (StackedDoughnutSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    borderColor: Colors.black,
                    borderWidth: 2,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings:
                        ConnectorLineSettings(color: Colors.black)))
          ]);
      break;
  }
  return chart;
}

/// Represents the stacked doughnut sample
class StackedDoughnutSample {
  /// Creates an instance of stacked doughnut sample
  StackedDoughnutSample(this.category, this.numeric, this.sales1, this.sales2,
      [this.color, this.radius]);

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
}
