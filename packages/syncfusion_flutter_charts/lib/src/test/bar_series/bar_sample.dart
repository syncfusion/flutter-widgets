// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../../charts.dart';

/// Method to get the bar chart
SfCartesianChart getBarChart(String sampleName) {
  SfCartesianChart chart;
  final dynamic data = <BarSample>[
    BarSample(
        DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1, Colors.deepOrange),
    BarSample(
        DateTime(2006, 0), 'China', 2, 24, 44, 550, 880, 2, Colors.deepPurple),
    BarSample(
        DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3, Colors.lightGreen),
    BarSample(
        DateTime(2008, 0), 'Japan', 4.56, 38, 50, 350, 560, 4, Colors.red),
    BarSample(
        DateTime(2009, 0), 'Russia', 5.87, 54, 66, 444, 566, 5, Colors.purple)
  ];

  final List<Color> color = <Color>[];
  color.add(Colors.pink[50]!);
  color.add(Colors.pink[200]!);
  color.add(Colors.pink);

  final List<double> stops = <double>[];
  stops.add(0.0);
  stops.add(0.5);
  stops.add(1.0);

  final LinearGradient gradientColors =
      LinearGradient(colors: color, stops: stops);

  switch (sampleName) {
    case 'customization_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_default_Selection':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_default_selection_mode_point':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          selectionType: SelectionType.point,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_default_selection_mode_series':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          selectionType: SelectionType.series,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_default_selection_mode_cluster':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          selectionType: SelectionType.cluster,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  // Enables the selection
                  enable: true),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_default_selection_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'cartesian_annotation_default':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          print(args.position.dx.toString());
          print(args.position.dy.toString());
        },
        zoomPanBehavior: ZoomPanBehavior(
          // Enables pinch zooming
          enablePinching: true,
        ),
        trackballBehavior: TrackballBehavior(
            enable: true, activationMode: ActivationMode.singleTap),
        onZoomStart: (ZoomPanArgs args) {
          print(args.toString());
        },
        onZoomEnd: (ZoomPanArgs args) {
          print(args.toString());
        },
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          lineColor: Colors.red,
          lineDashArray: const <double>[5, 5],
          lineWidth: 2,
          lineType: CrosshairLineType.vertical,
          activationMode: ActivationMode.singleTap,
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            // Templating the tooltip
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Text('PointIndex : ${pointIndex.toString()}');
            }),
        annotations: const <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Text('Annotation text'),
              coordinateUnit: CoordinateUnit.point,
              x: 2015,
              y: 27)
        ],
        series: <BarSeries<BarSample, num>>[
          BarSeries<BarSample, num>(
            animationDuration: 0,
            dataSource: data,
            xValueMapper: (BarSample sales, _) => sales.numeric,
            yValueMapper: (BarSample sales, _) => sales.sales1,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  return const SizedBox(
                    height: 30,
                    width: 30,
                    child: Text('point'),
                  );
                }),
          )
        ],
      );
      break;
    case 'panupdate':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) {
          print(args.position.dx.toString());
          print(args.position.dy.toString());
        },
        zoomPanBehavior: ZoomPanBehavior(
          // Enables pinch zooming
          enablePinching: true,
        ),
        trackballBehavior: TrackballBehavior(
          enable: true,
        ),
        onZoomStart: (ZoomPanArgs args) {
          print(args.toString());
        },
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          lineColor: Colors.red,
          lineDashArray: const <double>[5, 5],
          lineWidth: 2,
          lineType: CrosshairLineType.vertical,
        ),
        tooltipBehavior: TooltipBehavior(
            enable: true,
            // Templating the tooltip
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Text('PointIndex : ${pointIndex.toString()}');
            }),
        annotations: const <CartesianChartAnnotation>[
          CartesianChartAnnotation(
              widget: Text('Annotation text'),
              coordinateUnit: CoordinateUnit.point,
              x: 2015,
              y: 27)
        ],
        series: <BarSeries<BarSample, num>>[
          BarSeries<BarSample, num>(
            animationDuration: 0,
            dataSource: data,
            xValueMapper: (BarSample sales, _) => sales.numeric,
            yValueMapper: (BarSample sales, _) => sales.sales1,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  return const SizedBox(
                    height: 30,
                    width: 30,
                    child: Text('point'),
                  );
                }),
          )
        ],
      );
      break;
    case 'bar_selection_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.singleTap,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_selection_double_tap_event':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.doubleTap,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey,
                  selectedBorderColor: Colors.blue,
                  unselectedBorderColor: Colors.lightGreen,
                  selectedBorderWidth: 2,
                  unselectedBorderWidth: 0),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_selection_longpress_event':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          selectionGesture: ActivationMode.longPress,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              selectionBehavior: SelectionBehavior(
                enable: true,
              ),
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_pinch_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
          ),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_selection_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(
              enableSelectionZooming: true,
              selectionRectBorderColor: Colors.red,
              selectionRectColor: Colors.grey),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_double_tap_zoom':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          zoomPanBehavior: ZoomPanBehavior(enableDoubleTapZooming: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              dashArray: const <double>[10, 20],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'customization_fill_pointcolor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          legend: Legend(isVisible: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              color: Colors.green,
              pointColorMapper: (BarSample sales, _) => Colors.red,
            )
          ]);
      break;
    case 'customization_fill':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red,
              borderWidth: 3,
            )
          ]);
      break;
    case 'customization_pointColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => sales.lineColor)
          ]);
      break;
    case 'customization_tracker':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              isTrackVisible: true,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              pointColorMapper: (BarSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 2,
              trackPadding: 5,
            )
          ]);
      break;
    case 'customization_track_without_border':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              pointColorMapper: (BarSample sales, _) => Colors.blue,
              trackBorderColor: Colors.red,
              trackBorderWidth: 0,
              isTrackVisible: true,
            )
          ]);
      break;
    case 'customization_cornerradius':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => Colors.blue,
                trackBorderColor: Colors.red,
                trackBorderWidth: 2,
                isTrackVisible: true,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;
    case 'customization_track_transposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => Colors.blue,
                trackBorderColor: Colors.red,
                trackBorderWidth: 2,
                isTrackVisible: true,
                trackPadding: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)))
          ]);
      break;
    case 'customization_gradientColor':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                gradient: gradientColors,
                markerSettings: const MarkerSettings(isVisible: true))
          ]);
      break;
    case 'animation':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              isTrackVisible: true,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              isTrackVisible: true,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              isTrackVisible: true,
              animationDuration: 1400,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              animationDuration: 1200,
              isTrackVisible: true,
              dataSource: <BarSample>[
                BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                    Colors.deepOrange),
                BarSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880, 2,
                    Colors.deepPurple),
                BarSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788, 3,
                    Colors.lightGreen),
              ],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_transpose_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          isTransposed: true,
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              isTrackVisible: true,
              animationDuration: 1350,
              dataSource: <BarSample>[
                BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                    Colors.deepOrange),
                BarSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880, 2,
                    Colors.deepPurple),
                BarSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788, 3,
                    Colors.lightGreen),
              ],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              isTrackVisible: true,
              animationDuration: 1250,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'animation_inverse_negative':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              animationDuration: 1150,
              isTrackVisible: true,
              dataSource: <BarSample>[
                BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                    Colors.deepOrange),
                BarSample(DateTime(2006, 0), 'China', 2, -24, 44, 550, 880, 2,
                    Colors.deepPurple),
                BarSample(DateTime(2007, 0), 'USA', 3, -36, 48, 440, 788, 3,
                    Colors.lightGreen),
              ],
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'sortingX':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                sortFieldValueMapper: (BarSample sales, _) => sales.category,
                sortingOrder: SortingOrder.descending),
          ]);
      break;
    case 'emptyPoint_gap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: <BarSample>[
                  BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  BarSample(DateTime(2006, 0), 'China', 2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  BarSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  BarSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350, 560,
                      4, Colors.red),
                ],
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                emptyPointSettings: EmptyPointSettings())
          ]);
      break;
    case 'emptyPoint_zero':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: <BarSample>[
                  BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  BarSample(DateTime(2006, 0), 'China', 2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  BarSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  BarSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350, 560,
                      4, Colors.red),
                ],
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.zero))
          ]);
      break;
    case 'emptyPoint_avg':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: <BarSample>[
                  BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  BarSample(DateTime(2006, 0), 'China', 2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  BarSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  BarSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350, 560,
                      4, Colors.red),
                ],
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.average))
          ]);
      break;
    case 'emptyPoint_drop':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: <BarSample>[
                  BarSample(DateTime(2005, 0), 'India', 1, 32, 28, 680, 760, 1,
                      Colors.deepOrange),
                  BarSample(DateTime(2006, 0), 'China', 2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  BarSample(DateTime(2007, 0), 'USA', 3, 36, 48, 440, 788, 3,
                      Colors.lightGreen),
                  BarSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350, 560,
                      4, Colors.red),
                ],
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'null':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
                dataSource: <BarSample>[
                  BarSample(DateTime(2005, 0), 'India', 1, null, 28, 680, 760,
                      1, Colors.deepOrange),
                  BarSample(DateTime(2006, 0), 'China', 2, null, 44, 550, 880,
                      2, Colors.deepPurple),
                  BarSample(DateTime(2007, 0), 'USA', 3, null, 48, 440, 788, 3,
                      Colors.lightGreen),
                  BarSample(DateTime(2008, 0), 'Japan', 4, null, 50, 350, 560,
                      4, Colors.red),
                ],
                xValueMapper: (BarSample sales, _) => sales.numeric,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                emptyPointSettings:
                    EmptyPointSettings(mode: EmptyPointMode.drop))
          ]);
      break;
    case 'category_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'category_labelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.onTicks,
          ),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              pointColorMapper: (BarSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_EdgeLabelPlacement':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              CategoryAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isInversed: true),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (BarSample sales, _) => sales.lineColor,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ]);
      break;
    case 'category_label_tickPosition':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            labelPosition: ChartDataLabelPosition.inside,
            tickPosition: TickPosition.inside,
          ),
          primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.inside,
            tickPosition: TickPosition.inside,
          ),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (BarSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (BarSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              width: 1,
              pointColorMapper: (BarSample sales, _) => sales.lineColor,
            ),
          ]);
      break;
    case 'category_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'category_axisTitle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: true),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              minimum: DateTime(2005, 0), maximum: DateTime(2009, 0)),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_none':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_rangepadding_auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'datetime_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: DateTimeAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BarSeries<BarSample, DateTime>>[
            BarSeries<BarSample, DateTime>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.year,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_defaultData':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_range':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(minimum: 0, maximum: 6, interval: 1),
          primaryYAxis: NumericAxis(minimum: 1, maximum: 60, interval: 10),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Add':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.additional),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Normal':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.normal),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Round':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.round),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_Auto':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.auto),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_rangePadding_None':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          primaryYAxis: NumericAxis(rangePadding: ChartRangePadding.none),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_edgelabelPlacement_hide':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          primaryYAxis:
              NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.hide),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisLine_title':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary X Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          primaryYAxis: NumericAxis(
              axisLine: const AxisLine(
                  color: Colors.red, width: 3, dashArray: <double>[10, 20]),
              title: AxisTitle(
                  text: 'Primary Y Axis',
                  textStyle: const TextStyle(fontSize: 15))),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_inversed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isInversed: true),
          primaryYAxis: NumericAxis(isInversed: true),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(opposedPosition: true),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_gridlines':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 2,
                  color: Color.fromRGBO(244, 67, 54, 1.0),
                  dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(
                  width: 3, color: Colors.green, dashArray: <double>[10, 20]),
              majorTickLines: const MajorTickLines(
                  size: 15, width: 2, color: Color.fromRGBO(255, 87, 34, 1.0))),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_labelStyle':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontStyle: FontStyle.italic)),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'numeric_axisVisible':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: NumericAxis(isVisible: false),
          primaryYAxis: NumericAxis(isVisible: false),
          series: <BarSeries<BarSample, int?>>[
            BarSeries<BarSample, int?>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.xData,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            ),
          ]);
      break;
    case 'marker_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'marker_cutomization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => Colors.red,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.diamond,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_PointColormapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => Colors.blue,
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'marker_EmptyPoint':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                animationDuration: 0,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                pointColorMapper: (BarSample sales, _) => Colors.red,
                emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero, color: Colors.green),
                markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    color: Colors.deepOrange,
                    shape: DataMarkerType.horizontalLine,
                    borderColor: Colors.red,
                    borderWidth: 5)),
          ]);
      break;
    case 'dataLabel_default':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                animationDuration: 0,
                enableTooltip: true,
                isVisible: false,
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    builder: (dynamic data, dynamic point, dynamic series,
                        int pointIndex, int seriesIndex) {
                      return SizedBox(
                        height: 30,
                        width: 30,
                        child: Text(point.x.toString()),
                      );
                    }),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_customization':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                animationDuration: 0,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.black, fontSize: 12),
                  labelAlignment: ChartDataLabelAlignment.bottom,
                  borderRadius: 10,
                ),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'dataLabel_mapping':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                animationDuration: 0,
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    color: Colors.red,
                    textStyle: TextStyle(color: Colors.black, fontSize: 12),
                    labelAlignment: ChartDataLabelAlignment.bottom,
                    borderRadius: 10),
                markerSettings: const MarkerSettings(isVisible: true)),
          ]);
      break;
    case 'bar_series_tooltip':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              animationDuration: 0,
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_tooltip_renderer':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          onTooltipRender: (TooltipArgs args) {
            args.text = 'Custom Text';
          },
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_tooltip_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_tooltip_long_press':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true, activationMode: ActivationMode.longPress),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_tooltip_template':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          tooltipBehavior: TooltipBehavior(
              enable: true,
              // Templating the tooltip
              builder: (dynamic data, dynamic point, dynamic series,
                  int pointIndex, int seriesIndex) {
                return Text('PointIndex : ${pointIndex.toString()}');
              }),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_trackball':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;

    case 'trackball_dash_array_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_dash_array_isTransposed_vertical':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_dash_array':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineType: TrackballLineType.horizontal,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_dash_array_isTransposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          isTransposed: true,
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true,
              lineType: TrackballLineType.horizontal,
              activationMode: ActivationMode.singleTap,
              lineDashArray: const <double>[2, 3]));
      break;
    case 'trackball_opposed':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(
            opposedPosition: true,
          ),
          primaryYAxis: NumericAxis(opposedPosition: true),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ],
          trackballBehavior: TrackballBehavior(
              enable: true, activationMode: ActivationMode.singleTap));
      break;

    case 'trackball_display_mode':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints),
        series: <BarSeries<BarSample, dynamic>>[
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: data,
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          ),
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: <BarSample>[
              BarSample(DateTime(2005, 0), 'India1', 1, 42, 18, 280, 360, 1,
                  Colors.orange),
              BarSample(DateTime(2007, 0), 'USA1', 3, 36, 28, 940, 188, 3,
                  Colors.green),
              BarSample(DateTime(2009, 0), 'Russia1', 1.87, 24, 46, 244, 366, 5,
                  Colors.purple)
            ],
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'trackball_tooltip_align_near':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.near),
        series: <BarSeries<BarSample, dynamic>>[
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: data,
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          ),
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: <BarSample>[
              BarSample(DateTime(2005, 0), 'India1', 1, 42, 18, 280, 360, 1,
                  Colors.orange),
              BarSample(DateTime(2007, 0), 'USA1', 3, 36, 28, 940, 188, 3,
                  Colors.green),
              BarSample(DateTime(2009, 0), 'Russia1', 1.87, 24, 46, 244, 366, 5,
                  Colors.purple)
            ],
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'trackball_tooltip_align_far':
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
        primaryXAxis: CategoryAxis(),
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            tooltipAlignment: ChartAlignment.far),
        series: <BarSeries<BarSample, dynamic>>[
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: data,
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          ),
          BarSeries<BarSample, dynamic>(
            enableTooltip: true,
            dataSource: <BarSample>[
              BarSample(DateTime(2005, 0), 'India1', 1, 42, 18, 280, 360, 1,
                  Colors.orange),
              BarSample(DateTime(2007, 0), 'USA1', 3, 36, 28, 940, 188, 3,
                  Colors.green),
              BarSample(DateTime(2009, 0), 'Russia1', 1.87, 24, 46, 244, 366, 5,
                  Colors.purple)
            ],
            xValueMapper: (BarSample sales, _) => sales.category,
            yValueMapper: (BarSample sales, _) => sales.sales1,
          )
        ],
      );
      break;

    case 'bar_series_crosshair':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(
              enable: true, activationMode: ActivationMode.singleTap),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_crosshair_double_tap':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(
              enable: true, activationMode: ActivationMode.doubleTap),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
              enableTooltip: true,
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.category,
              yValueMapper: (BarSample sales, _) => sales.sales1,
            )
          ]);
      break;
    case 'bar_series_crosshair_long_press':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          primaryXAxis: CategoryAxis(),
          crosshairBehavior: CrosshairBehavior(enable: true),
          series: <BarSeries<BarSample, dynamic>>[
            BarSeries<BarSample, dynamic>(
                enableTooltip: true,
                dataSource: data,
                xValueMapper: (BarSample sales, _) => sales.category,
                yValueMapper: (BarSample sales, _) => sales.sales1,
                dataLabelSettings: const DataLabelSettings(isVisible: true))
          ]);
      break;
    case 'customization_fill_color_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              color: Colors.blue.withOpacity(0.5),
              borderColor: Colors.red,
              borderWidth: 3,
            )
          ]);
      break;
    case 'customization_border_color_opacity':
      chart = SfCartesianChart(
          key: GlobalKey<State<SfCartesianChart>>(),
          series: <BarSeries<BarSample, num>>[
            BarSeries<BarSample, num>(
              dataSource: data,
              xValueMapper: (BarSample sales, _) => sales.numeric,
              yValueMapper: (BarSample sales, _) => sales.sales1,
              color: Colors.blue,
              borderColor: Colors.red.withOpacity(0.5),
              borderWidth: 3,
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

/// Represents the bar sample
class BarSample {
  /// Creates an instance of bar sample
  BarSample(this.year, this.category, this.numeric, this.sales1, this.sales2,
      this.sales3, this.sales4,
      [this.xData, this.lineColor]);

  /// Holds the year value
  final DateTime year;

  /// Holds the category value
  final String category;

  /// Holds the numeric value
  final double numeric;

  /// Holds the sales1 value
  final int? sales1;

  /// Holds the sales2 value
  final int sales2;

  /// Holds the sales3 value
  final int sales3;

  /// Holds the sales4 value
  final int sales4;

  /// Holds the xData value
  final int? xData;

  /// Holds the lineColor value
  final Color? lineColor;
}
