// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'stackedarea100_sample.dart';

// /// Test method for markers in the stacked area 100 series.
// void stackedArea100DataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('StackedArea100 - Empty Point', () {
//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionGap.add(const Rect.fromLTRB(208.33333333333334,
//         250.60606060606062, 224.33333333333334, 266.6060606060606));
//     pointRegionGap.add(const Rect.fromLTRB(366.6666666666667,
//         235.82857142857145, 382.6666666666667, 251.82857142857145));
//     pointRegionGap.add(const Rect.fromLTRB(
//         525.0, 301.7446808510638, 541.0, 317.7446808510638));

//     final List<Rect> pointRegionGap1 = <Rect>[];
//     pointRegionGap1.add(const Rect.fromLTRB(208.3, -8.0, 224.3, 8.0));
//     pointRegionGap1.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionGap1.add(const Rect.fromLTRB(525.0, -8.0, 541.0, 8.0));
//     pointRegionGap1.add(const Rect.fromLTRB(772.0, -8.0, 788.0, 8.0));

//     // testWidgets(
//     //     'Chart Widget - Testing Stacked Area100 series Data Source with empty point as gap',
//     //     (WidgetTester tester) async {
//     //   final _StackedArea100DataSource chartContainer =
//     //       _stackedArea100DataSource('emptyPoint_gap')
//     //           as _StackedArea100DataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });

//     // // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(cartesianSeriesRenderer._segments.length, 1);
//     //     }
//     //   }
//     // });

//     // // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic>? dataPoints =
//     //           cartesianSeriesRenderer._dataPoints[j];
//     //       if (i == 0) {
//     //         expect(pointRegionGap[j].left.toInt(),
//     //             dataPoints!.region!.left.toInt());
//     //         expect(
//     //             pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
//     //         expect(pointRegionGap[j].right.toInt(),
//     //             dataPoints.region!.right.toInt());
//     //         expect(pointRegionGap[j].bottom.toInt(),
//     //             dataPoints.region!.bottom.toInt());
//     //       } else {
//     //         expect(pointRegionGap1[j].left.toInt(),
//     //             dataPoints!.region!.left.toInt());
//     //         expect(
//     //             pointRegionGap1[j].top.toInt(), dataPoints.region!.top.toInt());
//     //         expect(pointRegionGap1[j].right.toInt(),
//     //             dataPoints.region!.right.toInt());
//     //         expect(pointRegionGap1[j].bottom.toInt(),
//     //             dataPoints.region!.bottom.toInt());
//     //       }
//     //     }
//     //   }
//     // });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionZero.add(const Rect.fromLTRB(
//         208.33333333333334, 494.0, 224.33333333333334, 510.0));
//     pointRegionZero.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionZero.add(const Rect.fromLTRB(525.0, 494.0, 541.0, 510.0));

//     final List<Rect> pointRegionZero1 = <Rect>[];
//     pointRegionZero1.add(const Rect.fromLTRB(208.3, -8.0, 224.3, 8.0));
//     pointRegionZero1.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionZero1.add(const Rect.fromLTRB(525.0, -8.0, 541.0, 8.0));
//     pointRegionZero1.add(const Rect.fromLTRB(772.0, -8.0, 788.0, 8.0));

//     // Line series with
//     // testWidgets(
//     //     'Chart Widget - Testing Stacked Area100 series Data Source with empty point as zero',
//     //     (WidgetTester tester) async {
//     //   final _StackedArea100DataSource chartContainer =
//     //       _stackedArea100DataSource('emptyPoint_zero')
//     //           as _StackedArea100DataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });

//     // // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(cartesianSeriesRenderer._segments.length, 1);
//     //     }
//     //   }
//     // });

//     // // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic>? dataPoints =
//     //           cartesianSeriesRenderer._dataPoints[j];
//     //       if (i == 0) {
//     //         expect(pointRegionZero[j].left.toInt(),
//     //             dataPoints!.region!.left.toInt());
//     //         expect(
//     //             pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
//     //         expect(pointRegionZero[j].right.toInt(),
//     //             dataPoints.region!.right.toInt());
//     //         expect(pointRegionZero[j].bottom.toInt(),
//     //             dataPoints.region!.bottom.toInt());
//     //       } else {
//     //         expect(pointRegionZero1[j].left.toInt(),
//     //             dataPoints!.region!.left.toInt());
//     //         expect(pointRegionZero1[j].top.toInt(),
//     //             dataPoints.region!.top.toInt());
//     //         expect(pointRegionZero1[j].right.toInt(),
//     //             dataPoints.region!.right.toInt());
//     //         expect(pointRegionZero1[j].bottom.toInt(),
//     //             dataPoints.region!.bottom.toInt());
//     //       }
//     //     }
//     //   }
//     // });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionAvg = <Rect>[];
//     pointRegionAvg.add(
//         const Rect.fromLTRB(50.0, 166.1632653061224, 66.0, 182.1632653061224));
//     pointRegionAvg.add(const Rect.fromLTRB(
//         208.33333333333334, 243.0, 224.33333333333334, 259.0));
//     pointRegionAvg.add(const Rect.fromLTRB(366.6666666666667,
//         273.60975609756093, 382.6666666666667, 289.60975609756093));
//     pointRegionAvg.add(const Rect.fromLTRB(
//         525.0, 375.10526315789474, 541.0, 391.10526315789474));

//     final List<Rect> pointRegionAvg1 = <Rect>[];
//     pointRegionAvg1.add(
//         const Rect.fromLTRB(208.33333333333334, -8.0, 224.33333333333334, 8.0));
//     pointRegionAvg1.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionAvg1.add(const Rect.fromLTRB(525.0, -8.0, 541.0, 8.0));
//     pointRegionAvg1.add(const Rect.fromLTRB(772.0, -8.0, 788.0, 8.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Area100 series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedArea100DataSource chartContainer =
//           _stackedArea100DataSource('emptyPoint_avg')
//               as _StackedArea100DataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
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
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic>? dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           if (i == 0) {
//             expect(pointRegionAvg[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionAvg[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionAvg[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionAvg[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           } else {
//             expect(pointRegionAvg1[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionAvg1[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionAvg1[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionAvg1[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionDrop.add(const Rect.fromLTRB(208.33333333333334,
//         250.60606060606062, 224.33333333333334, 266.6060606060606));
//     pointRegionDrop.add(const Rect.fromLTRB(366.6666666666667,
//         235.82857142857145, 382.6666666666667, 251.82857142857145));
//     pointRegionDrop.add(const Rect.fromLTRB(
//         525.0, 301.7446808510638, 541.0, 317.7446808510638));

//     final List<Rect> pointRegionDrop1 = <Rect>[];
//     pointRegionDrop1.add(const Rect.fromLTRB(208.3, -8.0, 224.3, 8.0));
//     pointRegionDrop1.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionDrop1.add(const Rect.fromLTRB(525.0, -8.0, 541.0, 8.0));
//     pointRegionDrop1.add(const Rect.fromLTRB(772.0, -8.0, 788.0, 8.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Area100 series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _StackedArea100DataSource chartContainer =
//           _stackedArea100DataSource('emptyPoint_drop')
//               as _StackedArea100DataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
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
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic>? dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           if (i == 0) {
//             expect(pointRegionDrop[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionDrop[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionDrop[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionDrop[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           } else {
//             expect(pointRegionDrop1[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(pointRegionDrop1[j].top.toInt(),
//                 dataPoints.region!.top.toInt());
//             expect(pointRegionDrop1[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionDrop1[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionNull = <Rect>[];
//     pointRegionNull.add(const Rect.fromLTRB(50.0, 494.0, 66.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(
//         208.33333333333334, 494.0, 224.33333333333334, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(
//         366.6666666666667, 494.0, 382.6666666666667, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(525.0, 494.0, 541.0, 510.0));

//     final List<Rect> pointRegionNull1 = <Rect>[];
//     pointRegionNull1.add(const Rect.fromLTRB(
//         208.33333333333334, 494.0, 224.33333333333334, 510.0));
//     pointRegionNull1.add(
//         const Rect.fromLTRB(366.6666666666667, -8.0, 382.6666666666667, 8.0));
//     pointRegionNull1.add(const Rect.fromLTRB(525.0, -8.0, 541.0, 8.0));
//     pointRegionNull1.add(const Rect.fromLTRB(772.0, -8.0, 788.0, 8.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Area100 series Data Source with empty point as null',
//         (WidgetTester tester) async {
//       final _StackedArea100DataSource chartContainer =
//           _stackedArea100DataSource('null') as _StackedArea100DataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     test('test segement counts', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         expect(cartesianSeriesRenderer._segments.length, 1);
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint', () {
//       for (int i = 1; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 4);
//         }
//       }
//     });

//     // to test dataPoint regions
//     test('test datapoint regions', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//           final CartesianChartPoint<dynamic>? dataPoints =
//               cartesianSeriesRenderer._dataPoints[j];
//           if (i == 0) {
//             expect(pointRegionNull[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionNull[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionNull[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionNull[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           } else {
//             expect(pointRegionNull1[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(pointRegionNull1[j].top.toInt(),
//                 dataPoints.region!.top.toInt());
//             expect(pointRegionNull1[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionNull1[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       }
//     });
//   });
// }

// StatelessWidget _stackedArea100DataSource(String sampleName) {
//   return _StackedArea100DataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _StackedArea100DataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _StackedArea100DataSource(String sampleName) {
//     chart = _getStackedArea100Chart(sampleName);
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
