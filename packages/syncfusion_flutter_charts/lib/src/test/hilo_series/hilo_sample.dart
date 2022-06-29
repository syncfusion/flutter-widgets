import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the hilo chart
SfCartesianChart getHiloChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_HiloSample>[
    _HiloSample(DateTime(2005), 10, 30, 18, 25, 10),
    _HiloSample(DateTime(2006), 20, 40, 24, 37, 20),
    _HiloSample(DateTime(2007), 25, 50, 39, 26, 30),
    _HiloSample(DateTime(2008), 40, 60, 45, 49, 40),
    _HiloSample(DateTime(2009), 35, 50, 37, 45, 50),
    _HiloSample(DateTime(2010), 60, 80, 65, 75, 60),
    _HiloSample(DateTime(2011), 45, 60, 48, 54, 70),
  ];

  switch (sampleName) {
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              borderWidth: 2,
              enableTooltip: true,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              color: Colors.red,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'category_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'category_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'category_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: <_HiloSample>[
                _HiloSample(DateTime(2005), 10, 30, 18, 25),
                _HiloSample(DateTime(2006), null, 40, 24, 37),
                _HiloSample(DateTime(2007), 25, null, 39, 26),
                _HiloSample(DateTime(2008), 40, 60, 45, 49),
                _HiloSample(DateTime(2009), 35, 50, 37, 45),
                _HiloSample(DateTime(2010), 60, 80, 65, 75),
                _HiloSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'numeric_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'numeric_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              color: Colors.yellow,
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'numeric_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'numeric_axis_enablesolid':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'numeric_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'numeric_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: <_HiloSample>[
                _HiloSample(DateTime(2005), 10, 30, 18, 25, 10),
                _HiloSample(DateTime(2006), null, 40, 24, 37, 20),
                _HiloSample(DateTime(2007), 25, null, 39, 26, 30),
                _HiloSample(DateTime(2008), 40, 60, 45, 49, 40),
                _HiloSample(DateTime(2009), 35, 50, 37, 45, 50),
                _HiloSample(DateTime(2010), 60, 80, 65, 75, 60),
                _HiloSample(DateTime(2011), 45, 60, 48, 54, 70),
              ],
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'numeric_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year1,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'datetime_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'datetime_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              color: Colors.red,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'datetime_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'datetime_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'datetime_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;
    case 'datetime_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: <_HiloSample>[
                _HiloSample(DateTime(2005), 10, 30, 18, 25),
                _HiloSample(DateTime(2006), null, 40, 24, 37),
                _HiloSample(DateTime(2007), 25, null, 39, 26),
                _HiloSample(DateTime(2008), 40, 60, 45, 49),
                _HiloSample(DateTime(2009), 35, 50, 37, 45),
                _HiloSample(DateTime(2010), 60, 80, 65, 75),
                _HiloSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'datetime_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
            ),
          ]);
      break;

    case 'datetime_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloSample, dynamic>>[
            HiloSeries<_HiloSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloSample sales, _) => sales.year,
              lowValueMapper: (_HiloSample sales, _) => sales.low,
              highValueMapper: (_HiloSample sales, _) => sales.high,
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

class _HiloSample {
  _HiloSample(this.year, this.low, this.high, this.open, this.close,
      [this.year1]);
  final DateTime year;
  final num? year1;
  final num? low;
  final num? high;
  final num open;
  final num close;
}
