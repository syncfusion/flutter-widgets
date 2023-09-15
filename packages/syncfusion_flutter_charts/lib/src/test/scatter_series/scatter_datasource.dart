// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'scatter_sample.dart';

// /// Testing method of scatter series data source.
// void scatterDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;
//   group('Scatter - Defualt DataSource', () {
//     // Actual segmentValues value which needs to be compared with test cases
//     final List<List<Offset>> segmentValues = <List<Offset>>[];
//     final List<Offset> firstSegment = <Offset>[];
//     final List<Offset> secondSegment = <Offset>[];
//     final List<Offset> thirdSegment = <Offset>[];
//     final List<Offset> fourthSegment = <Offset>[];
//     final List<Offset> fifthSegment = <Offset>[];
//     firstSegment.add(const Offset(34.0, 234.93333333333334));
//     secondSegment.add(const Offset(153.01601830663617, 301.0));
//     thirdSegment.add(const Offset(344.44164759725396, 200.4));
//     fourthSegment.add(const Offset(556.270022883295, 184.1333333333333));
//     fifthSegment.add(const Offset(780.0, 50.0));
//     segmentValues.add(firstSegment);
//     segmentValues.add(secondSegment);
//     segmentValues.add(thirdSegment);
//     segmentValues.add(fourthSegment);
//     segmentValues.add(fifthSegment);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegion = <Rect>[];
//     pointRegion.add(const Rect.fromLTRB(22.0, 222.3, 46.0, 246.3));
//     pointRegion.add(const Rect.fromLTRB(141.5, 289.2, 165.5, 313.2));
//     pointRegion.add(const Rect.fromLTRB(332.7, 188.8, 356.7, 212.8));
//     pointRegion.add(const Rect.fromLTRB(544.4, 172.1, 568.4, 196.1));
//     pointRegion.add(const Rect.fromLTRB(768.0, 38.2, 792.0, 62.2));

//     testWidgets('Chart Widget - Testing Scatter series Data Source',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('customization_pointColor') as _ScatterDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test series count
//     test('test series count', () {
//       expect(chart!.series.length, 1);
//     });

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final ScatterSegment segment =
//     //           cartesianSeriesRenderer._segments[j] as ScatterSegment;
//     //       expect(segmentValues[j].elementAt(0).dx.toInt(),
//     //           segment.points[0].dx.toInt());
//     //       expect(segmentValues[j].elementAt(0).dy.toInt(),
//     //           segment.points[0].dy.toInt());
//     //       // expect(radius, segment._radius);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
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

//     // to test dataPoint regions
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

//   group('Scatter- Empty Point', () {
//     final List<List<Offset>> segmentGaps = <List<Offset>>[];
//     final List<Offset> firstSegmentGap = <Offset>[];
//     final List<Offset> secondSegmentGap = <Offset>[];
//     final List<Offset> thirdSegmentGap = <Offset>[];
//     firstSegmentGap.add(const Offset(58, 343));
//     secondSegmentGap.add(const Offset(358.44622425629285, 132.33333333333334));
//     thirdSegmentGap.add(const Offset(563.4645308924485, 26.0));
//     segmentGaps.add(firstSegmentGap);
//     segmentGaps.add(secondSegmentGap);
//     segmentGaps.add(thirdSegmentGap);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(46.0, 331.5, 70.0, 355.5));
//     pointRegionGap.add(const Rect.fromLTRB(161.7, 331.5, 185.7, 355.5));
//     pointRegionGap.add(const Rect.fromLTRB(346.7, 120.1, 370.7, 144.1));
//     pointRegionGap.add(const Rect.fromLTRB(551.6, 14.4, 575.6, 38.4));
//     pointRegionGap.add(const Rect.fromLTRB(768.0, 14.4, 792.0, 38.4));

//     testWidgets(
//         'Chart Widget - Testing Scatter series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('dataSource_emptyPoint_gap') as _ScatterDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final ScatterSegment segment =
//     //           cartesianSeriesRenderer._segments[j] as ScatterSegment;
//     //       expect(segmentGaps[j].elementAt(0).dx.toInt(),
//     //           segment.points[0].dx.toInt());
//     //       expect(segmentGaps[j].elementAt(0).dy.toInt(),
//     //           segment.points[0].dy.toInt());
//     //       // expect(radius, segment.radius);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//     //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 5);
//     //       expect(cartesianSeriesRenderer._segments.length, 3);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer cartesianSeriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
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

//     final List<List<Offset>> segmentZeros = <List<Offset>>[];
//     final List<Offset> firstSegmentZero = <Offset>[];
//     final List<Offset> secondSegmentZero = <Offset>[];
//     final List<Offset> thirdSegmentZero = <Offset>[];
//     final List<Offset> fourthSegmentZero = <Offset>[];
//     final List<Offset> fifthSegmentZero = <Offset>[];
//     firstSegmentZero.add(const Offset(34.0, 145.79999999999998));
//     secondSegmentZero.add(const Offset(153.01601830663617, 502.0));
//     thirdSegmentZero.add(const Offset(344.44164759725396, 100.89999999999999));
//     fourthSegmentZero.add(const Offset(556.270022883295, 78.0));
//     fifthSegmentZero.add(const Offset(780.0, 502.0));
//     segmentZeros.add(firstSegmentZero);
//     segmentZeros.add(secondSegmentZero);
//     segmentZeros.add(thirdSegmentZero);
//     segmentZeros.add(fourthSegmentZero);
//     segmentZeros.add(fifthSegmentZero);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(22.0, 133.0, 46.0, 157.0));
//     pointRegionZero.add(const Rect.fromLTRB(141.5, 490.0, 165.5, 514.0));
//     pointRegionZero.add(const Rect.fromLTRB(332.7, 88.4, 356.7, 112.4));
//     pointRegionZero.add(const Rect.fromLTRB(544.4, 66.1, 568.4, 90.1));
//     pointRegionZero.add(const Rect.fromLTRB(768.0, 490.0, 792.0, 514.0));

//     testWidgets(
//         'Chart Widget - Testing Scatter series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('dataSource_emptyPoint_zero')
//               as _ScatterDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     test('test segement values', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final ScatterSegment segment =
//               cartesianSeriesRenderer._segments[j] as ScatterSegment;
//           expect(segmentZeros[j].elementAt(0).dx.toInt(),
//               segment.points[0].dx.toInt());
//           expect(segmentZeros[j].elementAt(0).dy.toInt(),
//               segment.points[0].dy.toInt());
//           // expect(radius, segment.radius);
//         }
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 5);
//           expect(cartesianSeriesRenderer._segments.length, 5);
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
//     final List<Offset> fifthSegmentAvg = <Offset>[];
//     firstSegmentAvg.add(const Offset(34.0, 100.70000000000002));
//     secondSegmentAvg.add(const Offset(153.01601830663617, 75.79999999999998));
//     thirdSegmentAvg.add(const Offset(344.44164759725396, 50.89999999999999));
//     fourthSegmentAvg.add(const Offset(556.270022883295, 25.0));
//     fifthSegmentAvg.add(const Offset(780.0, 263.04999999999995));
//     segmentAvg.add(firstSegmentAvg);
//     segmentAvg.add(secondSegmentAvg);
//     segmentAvg.add(thirdSegmentAvg);
//     segmentAvg.add(fourthSegmentAvg);
//     segmentAvg.add(fifthSegmentAvg);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionAvg = <Rect>[];
//     pointRegionAvg.add(const Rect.fromLTRB(22.0, 88.4, 46.0, 112.4));
//     pointRegionAvg.add(const Rect.fromLTRB(141.5, 63.3, 165.5, 87.3));
//     pointRegionAvg.add(const Rect.fromLTRB(332.7, 38.2, 356.7, 62.2));
//     pointRegionAvg.add(const Rect.fromLTRB(544.4, 13.1, 568.4, 37.1));
//     pointRegionAvg.add(const Rect.fromLTRB(768.0, 251.6, 792.0, 275.5));

//     testWidgets(
//         'Chart Widget - Testing Scatter series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('dataSource_emptyPoint_avg') as _ScatterDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     test('test segement values', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final ScatterSegment segment =
//               cartesianSeriesRenderer._segments[j] as ScatterSegment;
//           expect(segmentAvg[j].elementAt(0).dx.toInt(),
//               segment.points[0].dx.toInt());
//           expect(segmentAvg[j].elementAt(0).dy.toInt(),
//               segment.points[0].dy.toInt());
//           // expect(radius, segment.radius);
//         }
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 5);
//           expect(cartesianSeriesRenderer._segments.length, 5);
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
//     firstSegmentDrop.add(const Offset(58.0, 343.0));
//     secondSegmentDrop.add(const Offset(358.44622425629285, 132.33333333333334));
//     thirdSegmentDrop.add(const Offset(563.4645308924485, 26.0));
//     segmentDrop.add(firstSegmentDrop);
//     segmentDrop.add(secondSegmentDrop);
//     segmentDrop.add(thirdSegmentDrop);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(46.0, 331.5, 70.0, 355.5));
//     pointRegionDrop.add(const Rect.fromLTRB(161.7, 331.5, 185.7, 355.5));
//     pointRegionDrop.add(const Rect.fromLTRB(346.7, 120.1, 370.7, 144.1));
//     pointRegionDrop.add(const Rect.fromLTRB(551.6, 14.4, 575.6, 38.4));
//     pointRegionDrop.add(const Rect.fromLTRB(768.0, 14.4, 792.0, 38.4));

//     testWidgets(
//         'Chart Widget - Testing Scatter series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('dataSource_emptyPoint_drop')
//               as _ScatterDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     test('test segement values', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final ScatterSegment segment =
//               cartesianSeriesRenderer._segments[j] as ScatterSegment;
//           expect(segmentDrop[j].elementAt(0).dx.toInt(),
//               segment.points[0].dx.toInt());
//           expect(segmentDrop[j].elementAt(0).dy.toInt(),
//               segment.points[0].dy.toInt());
//         }
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 5);
//           expect(cartesianSeriesRenderer._segments.length, 3);
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
//     pointRegionNull.add(const Rect.fromLTRB(34.0, 490.0, 58.0, 514.0));
//     pointRegionNull.add(const Rect.fromLTRB(151.6, 490.0, 175.6, 514.0));
//     pointRegionNull.add(const Rect.fromLTRB(339.7, 490.0, 363.7, 514.0));
//     pointRegionNull.add(const Rect.fromLTRB(547.0, 490.0, 571.0, 514.0));
//     pointRegionNull.add(const Rect.fromLTRB(768.0, 490.0, 792.0, 514.0));

//     testWidgets(
//         'Chart Widget - Testing Scatter series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _ScatterDataSource chartContainer =
//           _scatterDataSource('dataSource_emptyPoint_null')
//               as _ScatterDataSource;
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
//         expect(cartesianSeriesRenderer._segments.length, 0);
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

// StatelessWidget _scatterDataSource(String sampleName) {
//   return _ScatterDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _ScatterDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ScatterDataSource(String sampleName) {
//     chart = _getScatterchart(sampleName);
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
