import 'package:flutter/material.dart';
import '../../../charts.dart';

/// method to get the tooltip painter sample
SfCartesianChart getTooltipPainter(String sampleName) {
  SfCartesianChart chart;

  final dynamic chartData = <ColumnColors>[
    ColumnColors(1, 1.3, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
    ColumnColors(2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
    ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
    ColumnColors(4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
    ColumnColors(5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
    ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
    ColumnColors(7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
    ColumnColors(8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
    ColumnColors(9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
    ColumnColors(10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
    ColumnColors(11, 4.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
  ];
  final List<Color> color = <Color>[];
  color.add(Colors.blue[50]!);
  color.add(Colors.blue[200]!);
  color.add(Colors.blue);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradients = LinearGradient(colors: color, stops: stops);

  switch (sampleName) {
    case 'tooltip start':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              gradient: gradients,
              dataSource: chartData,
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
            ),
          ]);
      break;
    case 'tooltip end':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 3,
              gradient: gradients,
              dataSource: chartData,
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
            ),
          ]);
      break;
    case 'tooltip top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              gradient: gradients,
              dataSource: chartData,
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(
                isVisible: true,
                // Marker shape is set to diamond
                shape: DataMarkerType.image,
              ),
            ),
          ]);
      break;
    case 'tooltip start_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              dataSource: <ColumnColors>[
                ColumnColors(
                    1, 7.5, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
                ColumnColors(
                    2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
                ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
                ColumnColors(
                    4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
                ColumnColors(
                    5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
                ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
                ColumnColors(
                    7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
                ColumnColors(
                    8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
                ColumnColors(
                    9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
                ColumnColors(
                    10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
                ColumnColors(
                    11, 7.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
              ],
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ]);
      break;
    case 'tooltip end_top':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              dataSource: <ColumnColors>[
                ColumnColors(
                    1, 7.5, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
                ColumnColors(
                    2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
                ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
                ColumnColors(
                    4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
                ColumnColors(
                    5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
                ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
                ColumnColors(
                    7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
                ColumnColors(
                    8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
                ColumnColors(
                    9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
                ColumnColors(
                    10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
                ColumnColors(
                    11, 7.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
              ],
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ]);
      break;
    case 'tooltip last':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              dataSource: <ColumnColors>[
                ColumnColors(
                    1, 7.5, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
                ColumnColors(
                    2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
                ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
                ColumnColors(
                    4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
                ColumnColors(
                    5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
                ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
                ColumnColors(
                    7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
                ColumnColors(
                    8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
                ColumnColors(
                    9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
                ColumnColors(
                    10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
                ColumnColors(
                    11, 7.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
              ],
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ]);
      break;
    case 'tooltip start_bottom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              dataSource: <ColumnColors>[
                ColumnColors(
                    1, 3.5, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
                ColumnColors(
                    2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
                ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
                ColumnColors(
                    4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
                ColumnColors(
                    5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
                ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
                ColumnColors(
                    7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
                ColumnColors(
                    8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
                ColumnColors(
                    9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
                ColumnColors(
                    10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
                ColumnColors(
                    11, 3.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
              ],
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ]);
      break;
    case 'tooltip end_bottom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
            tooltipPosition: TooltipPosition.pointer,
          ),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              dataSource: <ColumnColors>[
                ColumnColors(
                    1, 3.5, 0.143, const Color.fromRGBO(5, 255, 102, 1)),
                ColumnColors(
                    2, 0.7, 0.0818, const Color.fromRGBO(0, 255, 255, 1)),
                ColumnColors(3, 2.0, 0.0826, const Color.fromRGBO(0, 0, 0, 1)),
                ColumnColors(
                    4, 3.4, 0.143, const Color.fromRGBO(255, 340, 102, 1)),
                ColumnColors(
                    5, 0.6, 0.128, const Color.fromRGBO(255, 200, 102, 1)),
                ColumnColors(6, 4.0, 0.115, const Color.fromRGBO(0, 0, 255, 1)),
                ColumnColors(
                    7, 7.5, 0.096, const Color.fromRGBO(200, 0, 102, 1)),
                ColumnColors(
                    8, 1.45, 0.162, const Color.fromRGBO(200, 100, 200, 1)),
                ColumnColors(
                    9, 6.097, 0.37, const Color.fromRGBO(100, 340, 100, 1)),
                ColumnColors(
                    10, 3.9, 0.162, const Color.fromRGBO(255, 0, 102, 1)),
                ColumnColors(
                    11, 3.5, 0.27, const Color.fromRGBO(233, 132, 30, 1)),
              ],
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ]);
      break;
    case 'tooltip header null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(
            visibleMaximum: 7.5,
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            // Formatting the tooltip text
            tooltipPosition: TooltipPosition.pointer,
            format: 'point.y%',
            shouldAlwaysShow: true,
            textAlignment: ChartAlignment.far,
          ),
          legend: const Legend(isVisible: false),
          series: <ColumnSeries<ColumnColors, num>>[
            ColumnSeries<ColumnColors, num>(
              animationDuration: 0,
              gradient: gradients,
              dataSource: chartData,
              enableTooltip: true,
              color: const Color.fromRGBO(255, 0, 102, 1),
              xValueMapper: (ColumnColors sales, _) => sales.year,
              yValueMapper: (ColumnColors sales, _) => sales.growth,
              pointColorMapper: (ColumnColors sales, _) =>
                  sales.pointColorMapper,
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

/// This class holds the property of ColumnColors
///
/// Public class used for  initiate the structure of data source.
class ColumnColors {
  /// Creates an instance of column colors
  ColumnColors(this.year, this.growth,
      [this.bubbleSize, this.pointColorMapper]);

  /// Holds the year value
  final num year;

  /// Holds the growth
  final num growth;

  /// Holds the bubble size
  final num? bubbleSize;

  /// Holds the point color mapper value
  final Color? pointColorMapper;
}
