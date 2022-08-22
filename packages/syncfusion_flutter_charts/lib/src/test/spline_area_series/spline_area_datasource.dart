// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'spline_area_sample.dart';

// /// Testing method of spline area series data source.
// void splineAreaDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

// // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;
//   group('Area Series with DataSource', () {
//     // Actual segmentValues value which needs to be compared with test cases
//     final List<List<Offset>> segmentValues = <List<Offset>>[];
//     final List<Offset> firstSegment = <Offset>[];
//     final List<Offset> secondSegment = <Offset>[];
//     final List<Offset> thirdSegment = <Offset>[];
//     final List<Offset> fourthSegment = <Offset>[];
//     firstSegment.add(const Offset(61.5, 366.03333333333336));
//     firstSegment.add(const Offset(178.19336384439362, 495.5));
//     secondSegment.add(const Offset(178.19336384439362, 495.5));
//     secondSegment.add(const Offset(364.9027459954233, 301.3));
//     thirdSegment.add(const Offset(364.9027459954233, 301.3));
//     thirdSegment.add(const Offset(571.616704805492, 268.93333333333334));
//     fourthSegment.add(const Offset(571.616704805492, 268.93333333333334));
//     fourthSegment.add(const Offset(790.0, 10.0));
//     segmentValues.add(firstSegment);
//     segmentValues.add(secondSegment);
//     segmentValues.add(thirdSegment);
//     segmentValues.add(fourthSegment);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegion = <Rect>[];
//     pointRegion.add(const Rect.fromLTRB(26.0, 226.3, 42.0, 242.3));
//     pointRegion.add(const Rect.fromLTRB(145.5, 293.2, 161.5, 309.2));
//     pointRegion.add(const Rect.fromLTRB(336.7, 192.8, 352.7, 208.8));
//     pointRegion.add(const Rect.fromLTRB(548.4, 176.1, 564.4, 192.1));
//     pointRegion.add(const Rect.fromLTRB(772.0, 42.2, 788.0, 58.2));

//     testWidgets('Chart Widget - Testing Area series Data Source',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('customization_pointColor')
//               as _SplineAreaDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series count
//     test('test series count', () {
//       expect(chart!.series.length, 1);
//     });

//     // // to test series dataPoint count
//     // test('test series dataPoint count', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 5);
//     //     }
//     //   }
//     // });

//     // // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           cartesianSeriesRenderer._dataPoints[j];
//     //       expect(pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(
//     //           pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//     //       expect(
//     //           pointRegion[j].bottom.toInt(), dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });
//   });

//   group('Area Series - Empty points', () {
//     final List<List<Offset>> segmentGaps = <List<Offset>>[];
//     final List<Offset> firstSegmentGap = <Offset>[];
//     firstSegmentGap.add(const Offset(380.0743707093821, 171.83333333333334));
//     firstSegmentGap.add(const Offset(579.4107551487414, 10.0));
//     segmentGaps.add(firstSegmentGap);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
//     pointRegionGap.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
//     pointRegionGap.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
//     pointRegionGap.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
//     pointRegionGap.add(const Rect.fromLTRB(772.0, 18.4, 788.0, 34.4));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('dataSource_emptyPoint_gap')
//               as _SplineAreaDataSource;
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
//           expect(dataPoints, 5);
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

//     final List<List<Offset>> segmentZeros = <List<Offset>>[];
//     final List<Offset> firstSegmentZero = <Offset>[];
//     final List<Offset> secondSegmentZero = <Offset>[];
//     final List<Offset> thirdSegmentZero = <Offset>[];
//     final List<Offset> fourthSegmentZero = <Offset>[];
//     firstSegmentZero.add(const Offset(87.5, 495.5));
//     firstSegmentZero.add(const Offset(200.02860411899314, 3084.833333333333));
//     secondSegmentZero.add(const Offset(200.02860411899314, 3084.833333333333));
//     secondSegmentZero.add(const Offset(380.0743707093821, 171.83333333333334));
//     thirdSegmentZero.add(const Offset(380.0743707093821, 171.83333333333334));
//     thirdSegmentZero.add(const Offset(579.4107551487414, 10.0));
//     fourthSegmentZero.add(const Offset(579.4107551487414, 10.0));
//     fourthSegmentZero.add(const Offset(790.0, 3084.833333333333));
//     segmentZeros.add(firstSegmentZero);
//     segmentZeros.add(secondSegmentZero);
//     segmentZeros.add(thirdSegmentZero);
//     segmentZeros.add(fourthSegmentZero);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(26.0, 137.0, 42.0, 153.0));
//     pointRegionZero.add(const Rect.fromLTRB(145.5, 494.0, 161.5, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(336.7, 92.4, 352.7, 108.4));
//     pointRegionZero.add(const Rect.fromLTRB(548.4, 70.1, 564.4, 86.1));
//     pointRegionZero.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

// // Line series with
//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('dataSource_emptyPoint_zero')
//               as _SplineAreaDataSource;
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
//           expect(dataPoints, 5);
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

//     final List<List<Offset>> segmentAvg = <List<Offset>>[];
//     final List<Offset> firstSegmentAvg = <Offset>[];
//     final List<Offset> secondSegmentAvg = <Offset>[];
//     final List<Offset> thirdSegmentAvg = <Offset>[];
//     final List<Offset> fourthSegmentAvg = <Offset>[];
//     firstSegmentAvg.add(const Offset(87.5, 495.5));
//     firstSegmentAvg.add(const Offset(200.02860411899314, 333.6666666666667));
//     secondSegmentAvg.add(const Offset(200.02860411899314, 333.6666666666667));
//     secondSegmentAvg.add(const Offset(380.0743707093821, 171.83333333333334));
//     thirdSegmentAvg.add(const Offset(380.0743707093821, 171.83333333333334));
//     thirdSegmentAvg.add(const Offset(579.4107551487414, 10.0));
//     fourthSegmentAvg.add(const Offset(579.4107551487414, 10.0));
//     fourthSegmentAvg.add(const Offset(790.0, 1547.4166666666665));
//     segmentAvg.add(firstSegmentAvg);
//     segmentAvg.add(secondSegmentAvg);
//     segmentAvg.add(thirdSegmentAvg);
//     segmentAvg.add(fourthSegmentAvg);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionAvg = <Rect>[];
//     pointRegionAvg.add(const Rect.fromLTRB(26.0, 92.4, 42.0, 108.4));
//     pointRegionAvg.add(const Rect.fromLTRB(145.5, 67.3, 161.5, 83.3));
//     pointRegionAvg.add(const Rect.fromLTRB(336.7, 42.2, 352.7, 58.2));
//     pointRegionAvg.add(const Rect.fromLTRB(548.4, 17.1, 564.4, 33.1));
//     pointRegionAvg.add(const Rect.fromLTRB(772.0, 255.6, 788.0, 271.6));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('dataSource_emptyPoint_avg')
//               as _SplineAreaDataSource;
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
//           expect(dataPoints, 5);
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

//     final List<List<Offset>> segmentDrop = <List<Offset>>[];
//     final List<Offset> firstSegmentDrop = <Offset>[];
//     final List<Offset> secondSegmentDrop = <Offset>[];
//     final List<Offset> thirdSegmentDrop = <Offset>[];
//     firstSegmentDrop.add(const Offset(87.5, 495.5));
//     firstSegmentDrop.add(const Offset(380.0743707093821, 171.83333333333334));
//     secondSegmentDrop.add(const Offset(380.0743707093821, 171.83333333333334));
//     secondSegmentDrop.add(const Offset(579.4107551487414, 10.0));
//     thirdSegmentDrop.add(const Offset(579.4107551487414, 10.0));
//     thirdSegmentDrop.add(const Offset(790.0, 3084.833333333333));
//     segmentDrop.add(firstSegmentDrop);
//     segmentDrop.add(secondSegmentDrop);
//     segmentDrop.add(thirdSegmentDrop);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(26.0, 137.5, 42.0, 153.5));
//     pointRegionDrop.add(const Rect.fromLTRB(145, 494, 161, 510));
//     pointRegionDrop.add(const Rect.fromLTRB(336.6, 92.3, 352.6, 108.3));
//     pointRegionDrop.add(const Rect.fromLTRB(548.6, 70.4, 564.6, 86.4));
//     pointRegionDrop.add(const Rect.fromLTRB(772.0, 494.4, 788.0, 510.4));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('dataSource_emptyPoint_drop')
//               as _SplineAreaDataSource;
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
//           expect(dataPoints, 5);
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
//     pointRegionNull.add(const Rect.fromLTRB(38.0, 494.0, 54.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(155.6, 494.0, 171.6, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(343.7, 494.0, 359.7, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(
//         551.9679633867275, 494.0, 567.9679633867275, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _SplineAreaDataSource chartContainer =
//           _splineAreaDataSource('dataSource_emptyPoint_null')
//               as _SplineAreaDataSource;
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
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
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
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
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

// StatelessWidget _splineAreaDataSource(String sampleName) {
//   return _SplineAreaDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _SplineAreaDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _SplineAreaDataSource(String sampleName) {
//     chart = _getSplineAreachart(sampleName);
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
