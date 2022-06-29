import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the candle chart
SfCartesianChart getCandlechart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_CandleSample>[
    _CandleSample(DateTime(2005), 10, 30, 18, 25, 2005),
    _CandleSample(DateTime(2006), 20, 40, 24, 37, 2006),
    _CandleSample(DateTime(2007), 25, 50, 39, 26, 2007),
    _CandleSample(DateTime(2008), 40, 60, 45, 49, 2008),
    _CandleSample(DateTime(2009), 35, 50, 37, 45, 2009),
    _CandleSample(DateTime(2010), 60, 80, 65, 75, 2010),
    _CandleSample(DateTime(2011), 45, 60, 48, 54, 2011),
  ];

  switch (sampleName) {
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              borderWidth: 2,
              enableTooltip: true,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'category_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'category_axis_enablesolid':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              enableSolidCandles: true,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'category_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'category_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: <_CandleSample>[
                _CandleSample(DateTime(2005), 10, 30, 18, 25),
                _CandleSample(DateTime(2006), null, 40, 24, 37),
                _CandleSample(DateTime(2007), 25, null, 39, 26),
                _CandleSample(DateTime(2008), 40, 60, 45, 49),
                _CandleSample(DateTime(2009), 35, 50, 37, 45),
                _CandleSample(DateTime(2010), 60, 80, 65, 75),
                _CandleSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_enablesolid':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              enableSolidCandles: true,
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'numeric_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: <_CandleSample>[
                _CandleSample(DateTime(2005), 10, 30, 18, 25, 2005),
                _CandleSample(DateTime(2006), null, 40, 24, 37, 2006),
                _CandleSample(DateTime(2007), 25, null, 39, 26, 2007),
                _CandleSample(DateTime(2008), 40, 60, 45, 49, 2008),
                _CandleSample(DateTime(2009), 35, 50, 37, 45, 2009),
                _CandleSample(DateTime(2010), 60, 80, 65, 75, 2010),
                _CandleSample(DateTime(2011), 45, 60, 48, 54, 2011),
              ],
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'numeric_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year1,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_fillcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              bearColor: Colors.yellow,
              bullColor: Colors.purple,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              borderWidth: 5,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_enablesolid':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              enableSolidCandles: true,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_negative_animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;
    case 'datetime_axis_high_and_close_null_value':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: <_CandleSample>[
                _CandleSample(DateTime(2005), 10, 30, 18, 25),
                _CandleSample(DateTime(2006), null, 40, 24, 37),
                _CandleSample(DateTime(2007), 25, null, 39, 26),
                _CandleSample(DateTime(2008), 40, 60, 45, 49),
                _CandleSample(DateTime(2009), 35, 50, 37, 45),
                _CandleSample(DateTime(2010), 60, 80, 65, 75),
                _CandleSample(DateTime(2011), 45, 60, 48, 54),
              ],
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
            ),
          ]);
      break;

    case 'datetime_axis_negative_animation_with_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<_CandleSample, dynamic>>[
            CandleSeries<_CandleSample, dynamic>(
              dataSource: data,
              animationDuration: 0,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              xValueMapper: (_CandleSample sales, _) => sales.year,
              lowValueMapper: (_CandleSample sales, _) => sales.low,
              highValueMapper: (_CandleSample sales, _) => sales.high,
              openValueMapper: (_CandleSample sales, _) => sales.open,
              closeValueMapper: (_CandleSample sales, _) => sales.close,
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

class _CandleSample {
  _CandleSample(this.year, this.low, this.high, this.open, this.close,
      [this.year1]);
  final DateTime year;
  final num? year1;
  final num? low;
  final num? high;
  final num open;
  final num close;
}
