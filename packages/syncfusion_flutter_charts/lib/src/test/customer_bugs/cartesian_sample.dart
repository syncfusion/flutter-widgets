import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../charts.dart';

/// Method to get the customer bug samples
SfCartesianChart getCustomerBugChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <_CustomerBugSample>[
    _CustomerBugSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    _CustomerBugSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    _CustomerBugSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    _CustomerBugSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    _CustomerBugSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  switch (sampleName) {
    case 'category_onticks_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.normal,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_additional':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.additional,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.auto,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_normal_multipleSeries':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.normal,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            ),
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales2,
            ),
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales3,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_normal_singlePoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.normal,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                    760, 1, Colors.deepOrange)
              ],
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_additional_singlePoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.additional,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                    760, 1, Colors.deepOrange)
              ],
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_onticks_rangepadding_auto_singlePoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              rangePadding: ChartRangePadding.auto,
              labelPlacement: LabelPlacement.onTicks),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                    760, 1, Colors.deepOrange)
              ],
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'individual_datalabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          onDataLabelRender: (DataLabelRenderArgs args) {
            Color color = Colors.green;
            Color? rectColor = Colors.green;
            double? size;
            String text = '';
            switch (args.pointIndex) {
              case 0:
                color = Colors.orange;
                rectColor = Colors.orange[100];
                size = 8;
                text = 'first';
                break;
              case 1:
                color = Colors.blue;
                rectColor = Colors.blue[100];
                size = 12;
                text = 'second';
                break;
              case 2:
                color = Colors.purple;
                rectColor = Colors.purple[100];
                size = 15;
                text = 'third';
                break;
              case 3:
                color = Colors.yellow;
                rectColor = Colors.yellow[100];
                size = 18;
                text = 'fourth';
                break;
              case 4:
                color = Colors.white;
                rectColor = Colors.green[100];
                size = 24;
                text = 'fifth';
                break;
            }
            args.color = rectColor;
            args.textStyle = TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: size);
            args.text = text;
          },
          primaryXAxis: CategoryAxis(),
          series: <ColumnSeries<_CustomerBugSample, String>>[
            ColumnSeries<_CustomerBugSample, String>(
                dataSource: data,
                xValueMapper: (_CustomerBugSample sales, _) => sales.category,
                yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'plot_offset_exception':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat.Hm(),
            intervalType: DateTimeIntervalType.minutes,
            maximumLabels: 12,
            axisLine: const AxisLine(color: Colors.white),
            majorTickLines: const MajorTickLines(color: Colors.white),
            labelIntersectAction: AxisLabelIntersectAction.hide,
          ),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(color: Colors.white),
              labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
              majorTickLines: const MajorTickLines(color: Colors.white),
              majorGridLines: const MajorGridLines(color: Colors.white)),
          plotAreaBorderWidth: 1,
          series: <ChartSeries<dynamic, dynamic>>[
            SplineSeries<_CustomerBugSample, DateTime?>(
                enableTooltip: true,
                dataLabelSettings: const DataLabelSettings(),
                xAxisName: 'Dia',
                yAxisName: 'Temperatura',
                emptyPointSettings: EmptyPointSettings(color: Colors.white),
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  color: Color(0xff50b9ff),
                  width: 3.0,
                  height: 3.0,
                ),
                dataSource: data,
                xValueMapper: (_CustomerBugSample datum, _) => datum.year,
                yValueMapper: (_CustomerBugSample datum, _) => datum.numeric)
          ]);
      break;
    case 'axis_decimal_exception':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          // Initialize category axis
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<dynamic, dynamic>>[
            // Initialize line series
            LineSeries<_CustomerBugSample, DateTime?>(
                dataSource: <_CustomerBugSample>[
                  _CustomerBugSample(
                      DateTime.parse('2020-05-21 00:00:00'), ' ', 0.00001468),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-20 00:00:00'), ' ', 0.00001550),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-19 00:00:00'), ' ', 0.00001508),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-23 00:00:00'), ' ', 0.00001921),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-22 00:00:00'), ' ', 0.00002010),
                ],
                xValueMapper: (_CustomerBugSample sales, _) => sales.year,
                yValueMapper: (_CustomerBugSample sales, _) => sales.numeric)
          ]);
      break;
    case 'stacked_bar_datalabel':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <ChartSeries<dynamic, dynamic>>[
            StackedBarSeries<_CustomerBugSample, String>(
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(null, 'IND', 92),
                _CustomerBugSample(null, 'USA', 132),
                _CustomerBugSample(null, 'JAP', 82)
              ],
              xValueMapper: (_CustomerBugSample data, _) => data.category,
              yValueMapper: (_CustomerBugSample data, _) => data.numeric,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
              ),
            )
          ]);
      break;
    case 'panning_min_max_given':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          // Initialize category axis
          primaryXAxis: DateTimeAxis(
              visibleMaximum: DateTime.parse('2020-05-15 00:00:00'),
              visibleMinimum: DateTime.parse('2020-05-01 00:00:00')),
          primaryYAxis: NumericAxis(),
          zoomPanBehavior: ZoomPanBehavior(enablePanning: true),
          series: <ChartSeries<dynamic, dynamic>>[
            // Initialize line series
            LineSeries<_CustomerBugSample, DateTime?>(
                dataSource: <_CustomerBugSample>[
                  // Bind data source
                  _CustomerBugSample(
                      DateTime.parse('2020-05-21 00:00:00'), ' ', 0.00001468),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-20 00:00:00'), ' ', 0.00001550),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-19 00:00:00'), ' ', 0.00001508),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-18 00:00:00'), ' ', 0.00001494),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-17 00:00:00'), ' ', 0.00001499),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-16 00:00:00'), ' ', 0.00001545),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-15 00:00:00'), ' ', 0.00001555),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-14 00:00:00'), ' ', 0.00001474),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-13 00:00:00'), ' ', 0.00001541),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-12 00:00:00'), ' ', 0.00001623),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-11 00:00:00'), ' ', 0.00001653),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-10 00:00:00'), ' ', 0.00001616),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-09 00:00:00'), ' ', 0.00001479),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-08 00:00:00'), ' ', 0.00001439),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-07 00:00:00'), ' ', 0.00001411),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-06 00:00:00'), ' ', 0.00001519),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-05 00:00:00'), ' ', 0.00001564),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-04 00:00:00'), ' ', 0.00001599),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-03 00:00:00'), ' ', 0.00001601),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-02 00:00:00'), ' ', 0.00001590),
                  _CustomerBugSample(
                      DateTime.parse('2020-05-01 00:00:00'), ' ', 0.00001616),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-30 00:00:00'), ' ', 0.00001660),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-29 00:00:00'), ' ', 0.00001639),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-28 00:00:00'), ' ', 0.00001849),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-27 00:00:00'), ' ', 0.00001841),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-26 00:00:00'), ' ', 0.00001866),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-25 00:00:00'), ' ', 0.00001902),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-24 00:00:00'), ' ', 0.00001910),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-23 00:00:00'), ' ', 0.00001921),
                  _CustomerBugSample(
                      DateTime.parse('2020-04-22 00:00:00'), ' ', 0.00002010),
                ],
                xValueMapper: (_CustomerBugSample sales, _) => sales.year,
                yValueMapper: (_CustomerBugSample sales, _) => sales.numeric)
          ]);
      break;
    case 'selection_singlePoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<_CustomerBugSample, String>>[
            LineSeries<_CustomerBugSample, String>(
              selectionBehavior: SelectionBehavior(enable: true),
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(DateTime(2005, 0), 'India', 1, 32, 28, 680,
                    760, 1, Colors.deepOrange)
              ],
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bubble_size':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BubbleSeries<_CustomerBugSample, String>>[
            BubbleSeries<_CustomerBugSample, String>(
                minimumRadius: 0,
                maximumRadius: 8,
                dataSource: data,
                xValueMapper: (_CustomerBugSample checkIn, _) =>
                    DateFormat(DateFormat.ABBR_WEEKDAY).format(checkIn.year!),
                yValueMapper: (_CustomerBugSample checkIn, _) {
                  return 5;
                },
                sizeValueMapper: (_CustomerBugSample checkIn, _) {
                  return data.indexOf(checkIn) as num;
                })
          ]);
      break;
    case 'y_range_calculation_on_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              zoomMode: ZoomMode.x, enableDoubleTapZooming: true),
          series: <ChartSeries<dynamic, dynamic>>[
            BubbleSeries<_CustomerBugSample, num?>(
              animationDuration: 0,
              dataSource: <_CustomerBugSample>[
                _CustomerBugSample(null, 'IND', 1, 92),
                _CustomerBugSample(null, 'USA', 2, 132),
                _CustomerBugSample(null, 'JAP', 3, 82)
              ],
              xValueMapper: (_CustomerBugSample data, _) => data.numeric,
              yValueMapper: (_CustomerBugSample data, _) => data.sales1,
            )
          ]);
      break;
    case 'axis_multi_line_label':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            axisLabelFormatter: (AxisLabelRenderDetails args) {
              return ChartAxisLabel(
                  'multi-line\n${args.value}', args.textStyle);
            },
          ),
          primaryYAxis: NumericAxis(
            axisLabelFormatter: (AxisLabelRenderDetails args) {
              return ChartAxisLabel(
                  'multi-line\n${args.value}', args.textStyle);
            },
          ),
          series: <LineSeries<_CustomerBugSample, String>>[
            LineSeries<_CustomerBugSample, String>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.category,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_negative':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        // Plot Area
        plotAreaBorderWidth: 0,
        isTransposed: true,
        // Legend
        primaryXAxis: CategoryAxis(
          isVisible: true,
          labelIntersectAction: AxisLabelIntersectAction.none,
          labelRotation: -90,
          majorGridLines: const MajorGridLines(
            width: 0,
          ),
        ),
        // Y Axis
        primaryYAxis: NumericAxis(
          rangePadding: ChartRangePadding.none,
          isVisible: true,
          labelFormat: '',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(width: 0),
        ),
        series: <BarSeries<_BarChartData, String>>[
          BarSeries<_BarChartData, String>(
            name: 'Title here',
            borderWidth: 0.75,
            enableTooltip: true,
            borderColor: Colors.black87,
            spacing: 0.25,
            animationDuration: 0,
            dataSource: <_BarChartData>[
              _BarChartData('Data A', 1, Colors.red),
              _BarChartData('Data B', 2, Colors.blue),
              _BarChartData('Data C', -1, Colors.green),
              _BarChartData('Data D', -0.5, Colors.pink),
              _BarChartData('Data E', -0.25, Colors.amber),
            ],
            xValueMapper: (_BarChartData data, _) => data.name,
            yValueMapper: (_BarChartData data, _) => data.value,
            pointColorMapper: (_BarChartData data, _) => data.color,
            dataLabelMapper: (_BarChartData data, _) =>
                '\$${data.value.toStringAsFixed(2)}',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              // position: CartesianLabelPosition.outer,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
      break;
    case 'category_panning':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(visibleMinimum: 8, visibleMaximum: 15),
          primaryYAxis: NumericAxis(isVisible: true),
          zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true, enablePanning: true, zoomMode: ZoomMode.x),
          series: <ChartSeries<_BarChartData, String>>[
            ColumnSeries<_BarChartData, String>(
              dataSource: <_BarChartData>[
                _BarChartData('10th Jun', 3000),
                _BarChartData('11th Jun', 800),
                _BarChartData('12th Jun', 300),
                _BarChartData('13th Jun', 500),
                _BarChartData('14th Jun', 500),
                _BarChartData('15th Jun', 400),
                _BarChartData('16th Jun', 800),
                _BarChartData('17th Jun', 200),
                _BarChartData('18th Jun', 800),
                _BarChartData('19th Jun', 500),
                _BarChartData('20th Jun', 300),
                _BarChartData('21st Jun', 100),
                _BarChartData('22nd Jun', 200),
                _BarChartData('23rd Jun', 500),
                _BarChartData('24th Jun', 800),
                _BarChartData('25th Jun', 700),
                _BarChartData('26th Jun', 2300),
                _BarChartData('27th Jun', 100),
                _BarChartData('28th Jun', 600),
                _BarChartData('29th Jun', 3500),
                _BarChartData('30th Jun', 700),
                _BarChartData('1st Jul', 500),
                _BarChartData('2nd Jul', 300),
                _BarChartData('3rd Jul', 800),
                _BarChartData('4th Jul', 300),
                _BarChartData('5th Jul', 200),
              ],
              xValueMapper: (_BarChartData sales, _) => sales.name,
              yValueMapper: (_BarChartData sales, _) => sales.value,
            )
          ]);
      break;
    case 'last_marker_position':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
            zoomFactor: 0.05339805825242721,
            zoomPosition: 0.9466019417475728,
          ),
          series: <LineSeries<_CustomerBugSample, dynamic>>[
            LineSeries<_CustomerBugSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (_CustomerBugSample sales, _) => sales.numeric,
                yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                )),
          ]);
      break;
    case 'annotation_with_xAxis_plotOffset':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(plotOffset: 25),
          annotations: <CartesianChartAnnotation>[
            CartesianChartAnnotation(
                widget: const Text('Annotation'),
                coordinateUnit: CoordinateUnit.point,
                x: data[2].numeric,
                y: data[2].sales1)
          ],
          series: <LineSeries<_CustomerBugSample, dynamic>>[
            LineSeries<_CustomerBugSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.numeric,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'annotation_with_yAxis_plotOffset':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(plotOffset: 25),
          annotations: <CartesianChartAnnotation>[
            CartesianChartAnnotation(
                widget: const Text('Annotation'),
                coordinateUnit: CoordinateUnit.point,
                x: data[2].numeric,
                y: data[2].sales1)
          ],
          series: <LineSeries<_CustomerBugSample, dynamic>>[
            LineSeries<_CustomerBugSample, dynamic>(
              dataSource: data,
              xValueMapper: (_CustomerBugSample sales, _) => sales.numeric,
              yValueMapper: (_CustomerBugSample sales, _) => sales.sales1,
            )
          ]);
      break;
    default:
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
  }

  return chart;
}

class _CustomerBugSample {
  _CustomerBugSample(this.year, this.category,
      [this.numeric,
      this.sales1,
      this.sales2,
      this.sales3,
      this.sales4,
      this.xData,
      this.lineColor]);
  final DateTime? year;
  final String category;
  final double? numeric;
  final int? sales1;
  final int? sales2;
  final int? sales3;
  final int? sales4;
  final int? xData;
  final Color? lineColor;
}

class _BarChartData {
  _BarChartData(this.name, this.value, [this.color]);
  final double value;
  final String name;
  final Color? color;
}
