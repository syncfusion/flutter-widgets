// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'stacked_line_sample.dart';

// /// Testing method of stacked line series data source.
// void stackedLineDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Stacked Line - Empty Points', () {
//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(38.0, 347.0, 54.0, 363.0));
//     pointRegionGap.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
//     pointRegionGap.add(const Rect.fromLTRB(359.9, 329.7, 375.9, 345.7));
//     pointRegionGap.add(const Rect.fromLTRB(520.9, 329.7, 536.9, 345.7));
//     pointRegionGap.add(const Rect.fromLTRB(194.0, 494.0, 214.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _StackedLineDataSource chartContainer =
//           _stackedLineDataSource('emptyPoint_gap') as _StackedLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[0];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(cartesianSeriesRenderer._segments.length, 1);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[0];
//     //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           cartesianSeriesRenderer._dataPoints[j];
//     //       expect(
//     //           pointRegionGap[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(pointRegionGap[j].right.toInt(),
//     //           dataPoints.region!.right.toInt());
//     //       expect(pointRegionGap[j].bottom.toInt(),
//     //           dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(26.0, 246.9, 42.0, 262.9));
//     pointRegionZero.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(353.2, 215.0, 369.2, 231.0));
//     pointRegionZero.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(26.0, 246.9, 42.0, 262.9));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _StackedLineDataSource chartContainer =
//           _stackedLineDataSource('emptyPoint_zero') as _StackedLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 4);
//           expect(cartesianSeriesRenderer._segments.length, 3);
//         }
//       }
//     });

//     // to test dataPoint regions
//     test('test datapoint regions', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           expect(
//               pointRegionZero[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(
//               pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(pointRegionZero[j].right.toInt(),
//               dataPoints.region!.right.toInt());
//           expect(pointRegionZero[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionAvg = <Rect>[];
//     pointRegionAvg.add(const Rect.fromLTRB(26.0, 315.5, 42.0, 331.5));
//     pointRegionAvg.add(const Rect.fromLTRB(189.6, 304.4, 205.6, 320.4));
//     pointRegionAvg.add(const Rect.fromLTRB(353.2, 293.2, 369.2, 309.2));
//     pointRegionAvg.add(const Rect.fromLTRB(516.8, 393.6, 532.8, 409.6));
//     pointRegionAvg.add(const Rect.fromLTRB(26.0, 315.5, 42.0, 331.5));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedLineDataSource chartContainer =
//           _stackedLineDataSource('emptyPoint_avg') as _StackedLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 4);
//           expect(cartesianSeriesRenderer._segments.length, 3);
//         }
//       }
//     });

//     // to test dataPoint regions
//     test('test datapoint regions', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           expect(
//               pointRegionAvg[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegionAvg[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(pointRegionAvg[j].right.toInt(),
//               dataPoints.region!.right.toInt());
//           expect(pointRegionAvg[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(38.0, 347.0, 54.0, 363.0));
//     pointRegionDrop.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
//     pointRegionDrop.add(const Rect.fromLTRB(359.9, 329.7, 375.9, 345.7));
//     pointRegionDrop.add(const Rect.fromLTRB(520.9, 329.7, 536.9, 345.7));
//     pointRegionDrop.add(const Rect.fromLTRB(194.0, 494.0, 214.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _StackedLineDataSource chartContainer =
//           _stackedLineDataSource('emptyPoint_drop') as _StackedLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 4);
//           expect(cartesianSeriesRenderer._segments.length, 1);
//         }
//       }
//     });

//     // to test dataPoint regions
//     test('test datapoint regions', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           expect(
//               pointRegionDrop[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(
//               pointRegionDrop[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(pointRegionDrop[j].right.toInt(),
//               dataPoints.region!.right.toInt());
//           expect(pointRegionDrop[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionNull = <Rect>[];
//     pointRegionNull.add(const Rect.fromLTRB(26.0, 494.0, 42.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(353.2, 494.0, 369.2, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedLineDataSource chartContainer =
//           _stackedLineDataSource('null') as _StackedLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment count
//     test('test segement counts', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         expect(cartesianSeriesRenderer._segments.length, 0);
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 5);
//         }
//       }
//     });

//     // to test dataPoint regions
//     test('test datapoint regions', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[0];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic> dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           expect(
//               pointRegionNull[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(
//               pointRegionNull[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(pointRegionNull[j].right.toInt(),
//               dataPoints.region!.right.toInt());
//           expect(pointRegionNull[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       }
//     });
//   });
// }

// StatelessWidget _stackedLineDataSource(String sampleName) {
//   return _StackedLineDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _StackedLineDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _StackedLineDataSource(String sampleName) {
//     chart = _getStackedLineChart(sampleName);
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
