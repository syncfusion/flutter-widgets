import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the cartesian trendline sample
SfCartesianChart getCartesianTrendlineSample(String sampleName) {
  final List<_SalesData> data = <_SalesData>[
    _SalesData(DateTime(2005, 0), 'India', 1, 20, 28, 680, 760),
    _SalesData(DateTime(2006, 0), 'China', 2, 24, 44, 550, 880),
    _SalesData(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788),
    _SalesData(DateTime(2008, 0), 'Japan', 4, 38, 50, 350, 560),
    _SalesData(DateTime(2009, 0), 'Russia', 5, 54, 66, 444, 566),
    _SalesData(DateTime(2010, 0), 'France', 6, 57, 78, 780, 650),
    _SalesData(DateTime(2011, 0), 'Germany', 8, 70, 84, 450, 800)
  ];
  SfCartesianChart chart;
  switch (sampleName) {
    case 'customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(),
          series: <LineSeries<_SalesData, DateTime>>[
            LineSeries<_SalesData, DateTime>(
              trendlines: <Trendline>[
                Trendline(
                    legendIconType: LegendIconType.seriesType,
                    animationDuration: 3000,
                    width: 4,
                    opacity: 0.5,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.year,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'linear_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'exponential_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.exponential,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'power_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.power,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'logarithmic_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.logarithmic,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'polynomial_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.polynomial,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'movingAverage':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.movingAverage,
                    period: 4,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-linear_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-exponential_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.exponential,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-power_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.power,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-logarithmic_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.logarithmic,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-polynomial_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.polynomial,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Column-movingAverage':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.movingAverage,
                    period: 4,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-linear_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-exponential_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.exponential,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-power_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.power,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-logarithmic_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.logarithmic,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-polynomial_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.polynomial,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Bubble-movingAverage':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BubbleSeries<_SalesData, num>>[
            BubbleSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.movingAverage,
                    period: 4,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'RangeColumn-linear_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
                trendlines: <Trendline>[
                  Trendline(
                      backwardForecast: 2,
                      forwardForecast: 1,
                      markerSettings: const MarkerSettings(
                          isVisible: true,
                          color: Colors.green,
                          shape: DataMarkerType.pentagon))
                ],
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.numeric,
                highValueMapper: (_SalesData sales, _) => sales.sales3,
                lowValueMapper: (_SalesData sales, _) => sales.sales4),
          ]);
      break;
    case 'RangeColumn-exponential_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
                trendlines: <Trendline>[
                  Trendline(
                      type: TrendlineType.exponential,
                      backwardForecast: 2,
                      forwardForecast: 1,
                      markerSettings: const MarkerSettings(
                          isVisible: true,
                          color: Colors.green,
                          shape: DataMarkerType.pentagon))
                ],
                dataSource: data,
                xValueMapper: (_SalesData sales, _) => sales.numeric,
                highValueMapper: (_SalesData sales, _) => sales.sales3,
                lowValueMapper: (_SalesData sales, _) => sales.sales4),
          ]);
      break;
    case 'RangeColumn-power_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.power,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              highValueMapper: (_SalesData sales, _) => sales.sales3,
              lowValueMapper: (_SalesData sales, _) => sales.sales4,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
            ),
          ]);
      break;
    case 'RangeColumn-logarithmic_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.logarithmic,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              highValueMapper: (_SalesData sales, _) => sales.sales3,
              lowValueMapper: (_SalesData sales, _) => sales.sales4,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
            ),
          ]);
      break;
    case 'RangeColumn-polynomial_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.polynomial,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              highValueMapper: (_SalesData sales, _) => sales.sales3,
              lowValueMapper: (_SalesData sales, _) => sales.sales4,
            ),
          ]);
      break;
    case 'RangeColumn-movingAverage':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <RangeColumnSeries<_SalesData, num>>[
            RangeColumnSeries<_SalesData, num>(
                trendlines: <Trendline>[
                  Trendline(
                      type: TrendlineType.movingAverage,
                      period: 4,
                      markerSettings: const MarkerSettings(
                          isVisible: true,
                          color: Colors.green,
                          shape: DataMarkerType.pentagon))
                ],
                dataSource: data,
                highValueMapper: (_SalesData sales, _) => sales.sales3,
                lowValueMapper: (_SalesData sales, _) => sales.sales4,
                xValueMapper: (_SalesData sales, _) => sales.numeric),
          ]);
      break;
    case 'Area-linear_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Area-exponential_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.exponential,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Area-power_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.power,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Area-logarithmic_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.logarithmic,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Area-polynomial_with_forecast':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.polynomial,
                    backwardForecast: 2,
                    forwardForecast: 1,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'Area-movingAverage':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <AreaSeries<_SalesData, num>>[
            AreaSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.movingAverage,
                    period: 4,
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: Colors.green,
                        shape: DataMarkerType.pentagon))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'linear_with_intercept':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.pentagon),
                    intercept: 20.0)
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'exponential_with_intercept':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <ColumnSeries<_SalesData, num>>[
            ColumnSeries<_SalesData, num>(
              trendlines: <Trendline>[
                Trendline(
                    type: TrendlineType.exponential,
                    markerSettings: const MarkerSettings(
                        isVisible: true, shape: DataMarkerType.pentagon),
                    intercept: 25.0)
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'trendline_event':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <LineSeries<_SalesData, num>>[
            LineSeries<_SalesData, num>(
              color: Colors.blueAccent,
              trendlines: <Trendline>[
                Trendline(
                    color: Colors.greenAccent,
                    opacity: 0.18,
                    dashArray: <double>[5, 3],
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                      color: Colors.red,
                    ))
              ],
              dataSource: data,
              xValueMapper: (_SalesData sales, _) => sales.numeric,
              yValueMapper: (_SalesData sales, _) => sales.sales1,
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

class _SalesData {
  _SalesData(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4);
  final DateTime year;
  final String category;
  final double numeric;
  final int sales1;
  final int sales2;
  final int sales3;
  final int sales4;
}
