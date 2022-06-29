// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'stackedline100_sample.dart';

// /// Testing method of stacked line 100 series data source.
// void stackedLine100DataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Stacked Line100 - Empty Points', () {
//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionGap.add(const Rect.fromLTRB(208.33333333333334,
//         250.60606060606062, 224.33333333333334, 266.6060606060606));
//     pointRegionGap.add(const Rect.fromLTRB(366.6666666666667,
//         235.82857142857145, 382.6666666666667, 251.82857142857145));
//     pointRegionGap.add(const Rect.fromLTRB(
//         525.0, 301.7446808510638, 541.0, 317.7446808510638));
//     pointRegionGap.add(const Rect.fromLTRB(194.0, 494.0, 214.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line100 series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _StackedLine100DataSource chartContainer =
//           _stackedLine100DataSource('emptyPoint_gap')
//               as _StackedLine100DataSource;
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
//               pointRegionGap[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(pointRegionGap[j].right.toInt(),
//               dataPoints.region!.right.toInt());
//           expect(pointRegionGap[j].bottom.toInt(),
//               dataPoints.region!.bottom.toInt());
//         }
//       }
//     });

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionZero.add(const Rect.fromLTRB(208.3, 494.0, 224.3, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(366.7, -8.0, 382.7, 8.0));
//     pointRegionZero.add(const Rect.fromLTRB(525.0, 494.0, 541.0, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     testWidgets(
//         'Chart Widget - Testing Stacked Line100 series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _StackedLine100DataSource chartContainer =
//           _stackedLine100DataSource('emptyPoint_zero')
//               as _StackedLine100DataSource;
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
//     pointRegionAvg.add(const Rect.fromLTRB(50.0, 166.2, 66.0, 182.2));
//     pointRegionAvg.add(const Rect.fromLTRB(208.3, 243.0, 224.3, 259.0));
//     pointRegionAvg.add(const Rect.fromLTRB(366.7, 273.6, 382.7, 289.6));
//     pointRegionAvg.add(const Rect.fromLTRB(525.0, 375.1, 541.0, 391.1));
//     pointRegionAvg.add(const Rect.fromLTRB(50.0, 166.2, 66.0, 182.2));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line100 series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedLine100DataSource chartContainer =
//           _stackedLine100DataSource('emptyPoint_avg')
//               as _StackedLine100DataSource;
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
//     pointRegionDrop.add(const Rect.fromLTRB(50.0, -8.0, 66.0, 8.0));
//     pointRegionDrop.add(const Rect.fromLTRB(208.33333333333334,
//         250.60606060606062, 224.33333333333334, 266.6060606060606));
//     pointRegionDrop.add(const Rect.fromLTRB(366.6666666666667,
//         235.82857142857145, 382.6666666666667, 251.82857142857145));
//     pointRegionDrop.add(const Rect.fromLTRB(
//         525.0, 301.7446808510638, 541.0, 317.7446808510638));
//     pointRegionDrop.add(const Rect.fromLTRB(194.0, 494.0, 214.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line100 series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _StackedLine100DataSource chartContainer =
//           _stackedLine100DataSource('emptyPoint_drop')
//               as _StackedLine100DataSource;
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
//     pointRegionNull.add(const Rect.fromLTRB(50.0, 494.0, 66.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(208.3, 494.0, 224.3, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(366.7, 494.0, 382.7, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(525.0, 494.0, 541.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(525.0, 494.0, 541.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Stacked Line100 series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StackedLine100DataSource chartContainer =
//           _stackedLine100DataSource('null') as _StackedLine100DataSource;
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

// StatelessWidget _stackedLine100DataSource(String sampleName) {
//   return _StackedLine100DataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _StackedLine100DataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _StackedLine100DataSource(String sampleName) {
//     chart = _getStackedLine100Chart(sampleName);
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
