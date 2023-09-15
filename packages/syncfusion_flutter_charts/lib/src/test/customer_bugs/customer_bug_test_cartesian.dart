// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import 'package:intl/intl.dart';
// import '../../../charts.dart';
// import 'cartesian_sample.dart';

// /// Test method of the cartesian chart bugs.
// void customerBugsTestChart() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;

//   group('Customer bugs- Cartesian ', () {
//     group('RangePadding - Category Axis LabelPlacement onTicks - normal', () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(56.4, 234.3, 160.8, 502.0));
//       pointRegion.add(const Rect.fromLTRB(205.6, 301.2, 310.0, 502.0));
//       pointRegion.add(const Rect.fromLTRB(354.8, 200.8, 459.2, 502.0));
//       pointRegion.add(const Rect.fromLTRB(503.98, 184.1, 608.4, 502.0));
//       pointRegion.add(const Rect.fromLTRB(653.2, 50.2, 757.6, 502.0));

//       // Column series
//       testWidgets(
//           'Chart Widget - Testing Column series with rangepadding normal - ',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('category_onticks_rangepadding_normal')
//                 as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         // _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       // test('test series dataPoint count', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//       //       final int dataPoints = seriesRenderer._dataPoints.length;
//       //       expect(dataPoints, 5);
//       //     }
//       //   }
//       // });

//       // // to test dataPoint regions
//       // test('test datapoint regions', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//       //       final CartesianChartPoint<dynamic> dataPoints =
//       //           seriesRenderer._dataPoints[j];
//       //       expect(
//       //           pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//       //       expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//       //       expect(
//       //           pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//       //       expect(pointRegion[j].bottom.toInt(),
//       //           dataPoints.region!.bottom.toInt());
//       //     }
//       //   }
//       // });
//     });
//     group('RangePadding - Category Axis LabelPlacement onTicks - additional',
//         () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(114.8, 234.3, 201.8, 502.0));
//       pointRegion.add(const Rect.fromLTRB(239.1, 301.2, 326.2, 502.0));
//       pointRegion.add(const Rect.fromLTRB(363.5, 200.8, 450.5, 502.0));
//       pointRegion.add(const Rect.fromLTRB(487.8, 184.1, 574.9, 502.0));
//       pointRegion.add(const Rect.fromLTRB(612.1, 50.2, 699.2, 502.0));

//       // Column series
//       testWidgets(
//           'Chart Widget - Testing Column series with rangepadding additional - ',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('category_onticks_rangepadding_additional')
//                 as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         // _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       // test('test series dataPoint count', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//       //       final int dataPoints = seriesRenderer._dataPoints.length;
//       //       expect(dataPoints, 5);
//       //     }
//       //   }
//       // });

//       // // to test dataPoint regions
//       // test('test datapoint regions', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//       //       final CartesianChartPoint<dynamic> dataPoints =
//       //           seriesRenderer._dataPoints[j];
//       //       expect(
//       //           pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//       //       expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//       //       expect(
//       //           pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//       //       expect(pointRegion[j].bottom.toInt(),
//       //           dataPoints.region!.bottom.toInt());
//       //     }
//       //   }
//       // });
//     });

//     group('RangePadding - Category Axis LabelPlacement onTicks- auto', () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(-31.3, 234.3, 99.3, 502.0));
//       pointRegion.add(const Rect.fromLTRB(155.2, 301.2, 285.8, 502.0));
//       pointRegion.add(const Rect.fromLTRB(341.7, 200.8, 472.3, 502.0));
//       pointRegion.add(const Rect.fromLTRB(528.2, 184.1, 658.8, 502.0));
//       pointRegion.add(const Rect.fromLTRB(714.7, 50.2, 845.3, 502.0));

//       // Column series
//       testWidgets('Testing Column series with rangepadding auto - ',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('category_onticks_rangepadding_auto')
//                 as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         // _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       // test('test series dataPoint count', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//       //       final int dataPoints = seriesRenderer._dataPoints.length;
//       //       expect(dataPoints, 5);
//       //     }
//       //   }
//       // });

//       // // to test dataPoint regions
//       // test('test datapoint regions', () {
//       //   for (int i = 0; i < chart!.series.length; i++) {
//       //     final CartesianSeriesRenderer seriesRenderer =
//       //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//       //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//       //       final CartesianChartPoint<dynamic> dataPoints =
//       //           seriesRenderer._dataPoints[j];
//       //       expect(
//       //           pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//       //       expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//       //       expect(
//       //           pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//       //       expect(pointRegion[j].bottom.toInt(),
//       //           dataPoints.region!.bottom.toInt());
//       //     }
//       //   }
//       // });
//     });

//     group(
//         'RangePadding - Category Axis LabelPlacement onTicks - multipleseries',
//         () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(68.0, 480.6, 102.3, 502.0));
//       pointRegion.add(const Rect.fromLTRB(214.8, 485.9, 249.1, 502.0));
//       pointRegion.add(const Rect.fromLTRB(361.6, 477.9, 395.9, 502.0));
//       pointRegion.add(const Rect.fromLTRB(508.4, 476.6, 542.7, 502.0));
//       pointRegion.add(const Rect.fromLTRB(655.2, 465.9, 689.5, 502.0));
//       final List<Rect> pointRegion2 = <Rect>[];
//       pointRegion2.add(const Rect.fromLTRB(102.3, 483.3, 136.5, 502.0));
//       pointRegion2.add(const Rect.fromLTRB(249.1, 472.5, 283.3, 502.0));
//       pointRegion2.add(const Rect.fromLTRB(395.9, 469.9, 430.1, 502.0));
//       pointRegion2.add(const Rect.fromLTRB(542.7, 468.5, 576.9, 502.0));
//       pointRegion2.add(const Rect.fromLTRB(689.5, 457.8, 723.7, 502.0));
//       final List<Rect> pointRegion3 = <Rect>[];
//       pointRegion3.add(const Rect.fromLTRB(136.5, 46.9, 170.8, 502.0));
//       pointRegion3.add(const Rect.fromLTRB(283.3, 133.9, 317.6, 502.0));
//       pointRegion3.add(const Rect.fromLTRB(430.1, 207.5, 464.4, 502.0));
//       pointRegion3.add(const Rect.fromLTRB(576.9, 267.7, 611.2, 502.0));
//       pointRegion3.add(const Rect.fromLTRB(723.7, 204.8, 757.98, 502.0));

//       // Column series
//       testWidgets(
//           'Chart Widget - Testing Column series with rangepadding normal - multipleseries',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer = _customerBugsTest(
//                 'category_onticks_rangepadding_normal_multipleSeries')
//             as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test dataPoint regions
//       test('test first series regions', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               seriesRenderer._dataPoints[j];
//           expect(pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(
//               pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//           expect(
//               pointRegion[j].bottom.toInt(), dataPoints.region!.bottom.toInt());
//         }
//       });
//       test('test second series regions', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[1];
//         for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               seriesRenderer._dataPoints[j];
//           expect(pointRegion2[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegion2[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(
//               pointRegion2[j].right.toInt(), dataPoints.region!.right.toInt());
//           expect(pointRegion2[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       });
//       test('test third series regions', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[2];
//         for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               seriesRenderer._dataPoints[j];
//           expect(pointRegion3[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegion3[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(
//               pointRegion3[j].right.toInt(), dataPoints.region!.right.toInt());
//           expect(pointRegion3[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       });
//     });

//     group(
//         'RangePadding - Category Axis LabelPlacement onTicks - singlePoint - normal',
//         () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(89.0, 100.0, 351.0, 502.0));

//       // Column series
//       testWidgets(
//           'Testing Column series with rangepadding normal - singlepoint',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer = _customerBugsTest(
//                 'category_onticks_rangepadding_normal_singlePoint')
//             as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       test('test series dataPoint count', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._segments.length; j++) {
//             final int dataPoints = seriesRenderer._dataPoints.length;
//             expect(dataPoints, 1);
//           }
//         }
//       });

//       // to test dataPoint regions
//       test('test datapoint regions', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//             final CartesianChartPoint<dynamic> dataPoints =
//                 seriesRenderer._dataPoints[j];
//             expect(
//                 pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//             expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(
//                 pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//             expect(pointRegion[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       });
//     });
//     group(
//         'RangePadding - Category Axis LabelPlacement onTicks - singlePoint - additional',
//         () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(195.0, 100.0, 369.0, 502.0));

//       // Column series
//       testWidgets(
//           'Testing Column series with rangepadding additional - singlePoint',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer = _customerBugsTest(
//                 'category_onticks_rangepadding_additional_singlePoint')
//             as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       test('test series dataPoint count', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._segments.length; j++) {
//             final int dataPoints = seriesRenderer._dataPoints.length;
//             expect(dataPoints, 1);
//           }
//         }
//       });

//       // to test dataPoint regions
//       test('test datapoint regions', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//             final CartesianChartPoint<dynamic> dataPoints =
//                 seriesRenderer._dataPoints[j];
//             expect(
//                 pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//             expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(
//                 pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//             expect(pointRegion[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       });
//     });
//     group(
//         'RangePadding - Category Axis LabelPlacement onTicks - singlePoint-auto',
//         () {
//       // Actual pointRegion value which needs to be compared with test cases
//       final List<Rect> pointRegion = <Rect>[];
//       pointRegion.add(const Rect.fromLTRB(-227.0, 100.0, 295.0, 502.0));

//       // Column series
//       testWidgets(
//           'Chart Widget - Testing Column series with rangepadding auto - singlePoint',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('category_onticks_rangepadding_auto_singlePoint')
//                 as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       // to test series dataPoint count
//       test('test series dataPoint count', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._segments.length; j++) {
//             final int dataPoints = seriesRenderer._dataPoints.length;
//             expect(dataPoints, 1);
//           }
//         }
//       });

//       // to test dataPoint regions
//       test('test datapoint regions', () {
//         for (int i = 0; i < chart!.series.length; i++) {
//           final CartesianSeriesRenderer seriesRenderer =
//               _chartState!._chartSeries.visibleSeriesRenderers[i];
//           for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//             final CartesianChartPoint<dynamic> dataPoints =
//                 seriesRenderer._dataPoints[j];
//             expect(
//                 pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//             expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(
//                 pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//             expect(pointRegion[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       });
//     });

//     group('2020 vol 2 - customer bugs', () {
//       dynamic exception;
//       testWidgets('Testing plot offset was called on null exception',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('plot_offset_exception') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         //this stores the type of exception thrown
//         exception = tester.takeException();
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the axes in series', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(seriesRenderer._xAxisRenderer != null, true);
//         expect(seriesRenderer._yAxisRenderer != null, true);
//       });

//       test('to test the exceptions thrown', () {
//         expect(exception, null);
//       });

//       exception = null;
//       testWidgets('Testing Range error', (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('axis_decimal_exception') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         //this stores the type of exception thrown
//         exception = tester.takeException();
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the axes in series', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(seriesRenderer._xAxisRenderer != null, true);
//         expect(seriesRenderer._yAxisRenderer != null, true);
//         expect(seriesRenderer._dataPoints.length, 5);
//       });

//       test('to test the exceptions thrown', () {
//         expect(exception, null);
//       });

//       testWidgets('Testing data label rendering with more than 2 digits',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('stacked_bar_datalabel') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the datapoints', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(seriesRenderer._dataPoints.length, 3);
//       });

//       testWidgets('Testing panning with visible min and max given',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('panning_min_max_given') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;

//         final Offset value = _chartState!._chartAxis._axisClipRect.centerLeft;
//         double firstTouchXValue = value.dx + 30;
//         final double firstTouchYValue = value.dy;
//         _chartState!._containerArea._performPanDown(DragDownDetails(
//             globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//         for (int i = 0; i < 30; i++) {
//           firstTouchXValue -= 5;
//           _chartState!._containerArea._performPanUpdate(DragUpdateDetails(
//               globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//         }
//         _chartState!._containerArea._performPanEnd(DragEndDetails(
//             velocity: const Velocity(pixelsPerSecond: Offset(0.0, 0.0))));
//         await tester.pump(const Duration(seconds: 3));
//       });

//       test('to test the x-axis visible lables', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         // expect(seriesRenderer._xAxisRenderer != null, true);//may 1 - 15
//         expect(seriesRenderer._xAxisRenderer!._visibleLabels[0].text, 'May 5');
//         expect(seriesRenderer._xAxisRenderer!._visibleLabels.length, 7);
//         expect(seriesRenderer._xAxisRenderer!._visibleLabels[6].text, 'May 17');
//       });

//       testWidgets('Testing Bubble size when size value mapper is given',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('bubble_size') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the bubble size', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         int size = 0;
//         for (final CartesianChartPoint<dynamic> point
//             in seriesRenderer._dataPoints) {
//           expect(point.bubbleSize, size++);
//         }
//       });

//       exception = null;
//       testWidgets('Testing Selecion with single point in line series',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('selection_singlePoint') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//         final _ChartLocation point =
//             _chartState!._seriesRenderers[0]._dataPoints[0].markerPoint!;
//         _chartState!._containerArea._performPointerDown(
//             PointerDownEvent(position: Offset(point.x, point.y)));
//         //this stores the type of exception thrown
//         exception = tester.takeException();
//       });

//       test('to test the point and segment length', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(seriesRenderer._dataPoints.length, 1);
//         expect(seriesRenderer._segments.isEmpty, true);
//       });

//       test('to test the exceptions thrown', () {
//         expect(exception, null);
//       });

//       testWidgets('Testing Y range calculation on zoom mode x',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('y_range_calculation_on_zoom')
//                 as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//         final Offset value = _chartState!._chartAxis._axisClipRect.center;
//         _chartState!._containerArea
//             ._performPointerDown(PointerDownEvent(position: value));
//         _chartState!._containerArea._performDoubleTap();
//         await tester.pump(const Duration(seconds: 3));
//       });

//       test('to test the axes visible minimum and maximum', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(
//             seriesRenderer._xAxisRenderer!._visibleRange!.minimum
//                 .toStringAsFixed(4),
//             '1.2196');
//         expect(
//             seriesRenderer._xAxisRenderer!._visibleRange!.maximum
//                 .toStringAsFixed(4),
//             '2.8196');
//         expect(
//             seriesRenderer._yAxisRenderer!._visibleRange!.minimum
//                 .toStringAsFixed(2),
//             '131.40');
//         expect(
//             seriesRenderer._yAxisRenderer!._visibleRange!.maximum
//                 .toStringAsFixed(2),
//             '133.10');
//       });
//     });

//     group('2020 vol 1 - customer bugs', () {
//       testWidgets('Testing multi line axis labels',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('axis_multi_line_label') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the axes labels', () {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (final AxisLabel label
//             in seriesRenderer._xAxisRenderer!._visibleLabels) {
//           expect(label.renderText, 'multi-line\n${label.value}');
//         }
//         for (final AxisLabel label
//             in seriesRenderer._yAxisRenderer!._visibleLabels) {
//           expect(label.renderText, 'multi-line\n${label.value}');
//         }
//       });

//       testWidgets('Testing bar negative value rendering',
//           (WidgetTester tester) async {
//         final _CustomerBugsTest chartContainer =
//             _customerBugsTest('bar_negative') as _CustomerBugsTest;
//         await tester.pumpWidget(chartContainer);
//         chart = chartContainer.chart;
//         final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//         _chartState = key.currentState as SfCartesianChartState?;
//       });

//       test('to test the region rects of bar segment', () {
//         const List<Rect> pointRegion = <Rect>[
//           Rect.fromLTRB(381.1, 294.7, 456.9, 442.0),
//           Rect.fromLTRB(525.5, 294.7, 601.3, 368.3),
//           Rect.fromLTRB(669.9, 294.7, 745.7, 331.5)
//         ];
//         Rect? region;
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];

//         region = seriesRenderer._dataPoints[2].region;
//         expect(pointRegion[0].left.toInt(), region!.left.toInt());
//         expect(pointRegion[0].top.toInt(), region.top.toInt());
//         expect(pointRegion[0].right.toInt(), region.right.toInt());
//         expect(pointRegion[0].bottom.toInt(), region.bottom.toInt());

//         region = seriesRenderer._dataPoints[3].region;
//         expect(pointRegion[1].left.toInt(), region!.left.toInt());
//         expect(pointRegion[1].top.toInt(), region.top.toInt());
//         expect(pointRegion[1].right.toInt(), region.right.toInt());
//         expect(pointRegion[1].bottom.toInt(), region.bottom.toInt());

//         region = seriesRenderer._dataPoints[4].region;
//         expect(pointRegion[2].left.toInt(), region!.left.toInt());
//         expect(pointRegion[2].top.toInt(), region.top.toInt());
//         expect(pointRegion[2].right.toInt(), region.right.toInt());
//         expect(pointRegion[2].bottom.toInt(), region.bottom.toInt());
//       });
//     });
//     testWidgets('Testing last marker position', (WidgetTester tester) async {
//       final _CustomerBugsTest chartContainer =
//           _customerBugsTest('last_marker_position') as _CustomerBugsTest;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test last marker rendering', () {
//       final dynamic seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final MarkerSettings marker = seriesRenderer._series.markerSettings;
//       expect(marker.isVisible, true);
//     });
//   });

//   group('2020 vol 3 - customer bugs', () {
//     testWidgets('Category axis panning with x min and max',
//         (WidgetTester tester) async {
//       final _CustomerBugsTest chartContainer =
//           _customerBugsTest('category_panning') as _CustomerBugsTest;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;

//       final Offset value = _chartState!._chartAxis._axisClipRect.centerLeft;
//       double firstTouchXValue = value.dx + 30;
//       final double firstTouchYValue = value.dy;
//       _chartState!._containerArea._performPanDown(DragDownDetails(
//           globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       for (int i = 0; i < 50; i++) {
//         firstTouchXValue -= 5;
//         _chartState!._containerArea._performPanUpdate(DragUpdateDetails(
//             globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       }
//       _chartState!._containerArea._performPanEnd(DragEndDetails(
//           velocity: const Velocity(pixelsPerSecond: Offset(0.0, 0.0))));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test the axes visible minimum and maximum', () {
//       final CartesianSeriesRenderer seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       expect(
//           seriesRenderer._xAxisRenderer!._visibleRange!.minimum
//               .toStringAsFixed(4),
//           '10.1703');
//       expect(
//           seriesRenderer._xAxisRenderer!._visibleRange!.maximum
//               .toStringAsFixed(4),
//           '18.1703');
//       expect(seriesRenderer._yAxisRenderer!._visibleRange!.minimum, 0);
//       expect(seriesRenderer._yAxisRenderer!._visibleRange!.maximum, 2600);
//     });

//     testWidgets('Annotation with X-Axis plotOffset',
//         (WidgetTester tester) async {
//       final _CustomerBugsTest chartContainer =
//           _customerBugsTest('annotation_with_xAxis_plotOffset')
//               as _CustomerBugsTest;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test the offset position of annotation', () {
//       final Offset annotationLocation =
//           _chartState!._renderingDetails.templates[0].location;
//       expect(annotationLocation.dx, 344.83162217659134);
//       expect(annotationLocation.dy, 200.8);
//     });

//     testWidgets('Annotation with Y-Axis plotOffset',
//         (WidgetTester tester) async {
//       final _CustomerBugsTest chartContainer =
//           _customerBugsTest('annotation_with_yAxis_plotOffset')
//               as _CustomerBugsTest;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test the offset position of annotation', () {
//       final Offset annotationLocation =
//           _chartState!._renderingDetails.templates[0].location;
//       expect(annotationLocation.dx, 340.36550308008214);
//       expect(annotationLocation.dy, 205.8);
//     });
//   });
// }

// StatelessWidget _customerBugsTest(String sampleName) {
//   return _CustomerBugsTest(sampleName);
// }

// // ignore: must_be_immutable
// class _CustomerBugsTest extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _CustomerBugsTest(String sampleName) {
//     chart = _getCustomerBugChart(sampleName);
//   }

//   SfCartesianChart? chart;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Test Chart Widget'),
//           ),
//           body: Center(
//               child: Container(
//             margin: EdgeInsets.zero,
//             child: chart,
//           ))),
//     );
//   }
// }
