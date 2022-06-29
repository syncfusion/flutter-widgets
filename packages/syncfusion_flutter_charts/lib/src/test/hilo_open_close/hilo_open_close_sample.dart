import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the hilo open close chart
SfCartesianChart getHiloOpenCloseChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_HiloOpenCloseSample>[
    _HiloOpenCloseSample(DateTime(2005), 10, 30, 18, 25, 10),
    _HiloOpenCloseSample(DateTime(2006), 20, 40, 24, 37, 20),
    _HiloOpenCloseSample(DateTime(2007), 25, 50, 39, 26, 30),
    _HiloOpenCloseSample(DateTime(2008), 40, 60, 45, 49, 40),
    _HiloOpenCloseSample(DateTime(2009), 35, 50, 37, 45, 50),
    _HiloOpenCloseSample(DateTime(2010), 60, 80, 65, 75, 60),
    _HiloOpenCloseSample(DateTime(2011), 45, 60, 48, 54, 70),
  ];

  switch (sampleName) {
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              borderWidth: 2,
              enableTooltip: true,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'category_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'category_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: <_HiloOpenCloseSample>[
                _HiloOpenCloseSample(DateTime(2005), 10, 30, 18, 25),
                _HiloOpenCloseSample(DateTime(2006), null, 40, 24, 37),
                _HiloOpenCloseSample(DateTime(2007), 25, null, 39, 26),
                _HiloOpenCloseSample(DateTime(2008), 40, 60, 45, 49),
                _HiloOpenCloseSample(DateTime(2009), 35, 50, 37, 45),
                _HiloOpenCloseSample(DateTime(2010), 60, 80, 65, 75),
                _HiloOpenCloseSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_enablesolid':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: <_HiloOpenCloseSample>[
                _HiloOpenCloseSample(DateTime(2005), 10, 30, 18, 25, 10),
                _HiloOpenCloseSample(DateTime(2006), null, 40, 24, 37, 20),
                _HiloOpenCloseSample(DateTime(2007), 25, null, 39, 26, 30),
                _HiloOpenCloseSample(DateTime(2008), 40, 60, 45, 49, 40),
                _HiloOpenCloseSample(DateTime(2009), 35, 50, 37, 45, 50),
                _HiloOpenCloseSample(DateTime(2010), 60, 80, 65, 75, 60),
                _HiloOpenCloseSample(DateTime(2011), 45, 60, 48, 54, 70),
              ],
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year1,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: <_HiloOpenCloseSample>[
                _HiloOpenCloseSample(DateTime(2005), 10, 30, 18, 25),
                _HiloOpenCloseSample(DateTime(2006), null, 40, 24, 37),
                _HiloOpenCloseSample(DateTime(2007), 25, null, 39, 26),
                _HiloOpenCloseSample(DateTime(2008), 40, 60, 45, 49),
                _HiloOpenCloseSample(DateTime(2009), 35, 50, 37, 45),
                _HiloOpenCloseSample(DateTime(2010), 60, 80, 65, 75),
                _HiloOpenCloseSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_HiloOpenCloseSample, dynamic>>[
            HiloOpenCloseSeries<_HiloOpenCloseSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_HiloOpenCloseSample sales, _) => sales.year,
              lowValueMapper: (_HiloOpenCloseSample sales, _) => sales.low,
              highValueMapper: (_HiloOpenCloseSample sales, _) => sales.high,
              openValueMapper: (_HiloOpenCloseSample sales, _) => sales.open,
              closeValueMapper: (_HiloOpenCloseSample sales, _) => sales.close,
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

class _HiloOpenCloseSample {
  _HiloOpenCloseSample(this.year, this.low, this.high, this.open, this.close,
      [this.year1]);
  final DateTime year;
  final num? year1;
  final num? low;
  final num? high;
  final num open;
  final num close;
}
