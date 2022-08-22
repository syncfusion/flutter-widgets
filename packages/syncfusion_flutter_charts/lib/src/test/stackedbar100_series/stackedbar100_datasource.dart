// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'stackedbar100_sample.dart';

// /// Testing method of stacked bar 100 series data source.
// void stackedBar100DataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;
//   group('StackedBar100 - Empty Point', () {
//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionGap.add(const Rect.fromLTRB(
//         46.0, 334.96762589928056, 46.0, 398.16906474820144));
//     pointRegionGap.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionGap.add(
//         const Rect.fromLTRB(46.0, 154.39208633093523, 46.0, 217.5935251798561));

//     final List<Rect> pointRegionGap1 = <Rect>[];
//     pointRegionGap1.add(const Rect.fromLTRB(
//         780.0, 334.96762589928056, 780.0, 398.16906474820144));
//     pointRegionGap1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionGap1.add(const Rect.fromLTRB(
//         780.0, 154.39208633093523, 780.0, 217.5935251798561));
//     pointRegionGap1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Bar100 series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _StackedBar100DataSource chartContainer =
//           _stackedBar100DataSource('emptyPoint_gap')
//               as _StackedBar100DataSource;
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
//           expect(cartesianSeriesRenderer._segments.length, 2);
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
//             expect(pointRegionGap[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionGap[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionGap[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           } else {
//             expect(pointRegionGap1[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionGap1[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionGap1[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionGap1[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionZero.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionZero.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionZero.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     final List<Rect> pointRegionZero1 = <Rect>[];
//     pointRegionZero1.add(const Rect.fromLTRB(780.0, 780.0, 780.0, 780.0));
//     pointRegionZero1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionZero1.add(const Rect.fromLTRB(780.0, 780.0, 780.0, 780.0));
//     pointRegionZero1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     // Line series with
//     testWidgets(
//         'Chart Widget - Testing Stacked Bar100 series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _StackedBar100DataSource chartContainer =
//           _stackedBar100DataSource('emptyPoint_zero')
//               as _StackedBar100DataSource;
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
//           expect(cartesianSeriesRenderer._segments.length, 4);
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
//             expect(pointRegionZero[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(
//                 pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
//             expect(pointRegionZero[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionZero[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           } else {
//             expect(pointRegionZero1[j].left.toInt(),
//                 dataPoints!.region!.left.toInt());
//             expect(pointRegionZero1[j].top.toInt(),
//                 dataPoints.region!.top.toInt());
//             expect(pointRegionZero1[j].right.toInt(),
//                 dataPoints.region!.right.toInt());
//             expect(pointRegionZero1[j].bottom.toInt(),
//                 dataPoints.region!.bottom.toInt());
//           }
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionAvg = <Rect>[];
//     pointRegionAvg.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     final List<Rect> pointRegionAvg1 = <Rect>[];
//     pointRegionAvg1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionAvg1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Bar100 series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedBar100DataSource chartContainer =
//           _stackedBar100DataSource('emptyPoint_avg')
//               as _StackedBar100DataSource;
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
//           expect(cartesianSeriesRenderer._segments.length, 4);
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
//     pointRegionDrop.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionDrop.add(const Rect.fromLTRB(
//         46.0, 334.96762469928056, 46.0, 398.16906474820144));
//     pointRegionDrop.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionDrop.add(
//         const Rect.fromLTRB(46.0, 154.39208633093523, 46.0, 217.5935251798561));

//     final List<Rect> pointRegionDrop1 = <Rect>[];
//     pointRegionDrop1.add(const Rect.fromLTRB(
//         780.0, 334.96762589928056, 780.0, 398.16906474820144));
//     pointRegionDrop1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionDrop1.add(const Rect.fromLTRB(
//         780.0, 154.39208633093523, 780.0, 217.5935251798561));
//     pointRegionDrop1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Bar100 series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _StackedBar100DataSource chartContainer =
//           _stackedBar100DataSource('emptyPoint_drop')
//               as _StackedBar100DataSource;
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
//           expect(cartesianSeriesRenderer._segments.length, 2);
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
//     pointRegionNull.add(const Rect.fromLTRB(
//         46.0, 425.25539568345323, 46.0, 488.45683453237405));
//     pointRegionNull.add(const Rect.fromLTRB(
//         46.0, 334.96762589928056, 46.0, 398.16906474820144));
//     pointRegionNull.add(
//         const Rect.fromLTRB(46.0, 244.6798561151079, 46.0, 307.88129496402877));
//     pointRegionNull.add(
//         const Rect.fromLTRB(46.0, 154.39208633093523, 46.0, 217.5935251798561));
//     final List<Rect> pointRegionNull1 = <Rect>[];
//     pointRegionNull1.add(const Rect.fromLTRB(
//         46.0, 334.96762589928056, 46.0, 398.16906474820144));
//     pointRegionNull1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));
//     pointRegionNull1.add(
//         const Rect.fromLTRB(46.0, 154.39208633093523, 46.0, 217.5935251798561));
//     pointRegionNull1.add(const Rect.fromLTRB(46.0, 46.0, 46.0, 46.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Bar100 series Data Source with empty point as null',
//         (WidgetTester tester) async {
//       final _StackedBar100DataSource chartContainer =
//           _stackedBar100DataSource('null') as _StackedBar100DataSource;
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
//         expect(cartesianSeriesRenderer._segments.length, i * 2);
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

// StatelessWidget _stackedBar100DataSource(String sampleName) {
//   return _StackedBar100DataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _StackedBar100DataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _StackedBar100DataSource(String sampleName) {
//     chart = _getStackedBar100Chart(sampleName);
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
