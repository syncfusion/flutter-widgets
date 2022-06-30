// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'step_line_sample.dart';

// /// Testing method of step line series data source.
// void stepLineDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Step Line - Defualt', () {
//     // Actual segmentValues value which needs to be compared with test cases
//     final List<List<Offset>> segmentValues = <List<Offset>>[];
//     final List<Offset> firstSegment = <Offset>[];
//     final List<Offset> secondSegment = <Offset>[];
//     final List<Offset> thirdSegment = <Offset>[];
//     final List<Offset> fourthSegment = <Offset>[];
//     firstSegment.add(const Offset(34.0, 234.26666666666668));
//     firstSegment.add(const Offset(153.49656750572086, 301.2));
//     secondSegment.add(const Offset(153.49656750572086, 301.2));
//     secondSegment.add(const Offset(344.6910755148741, 200.8));
//     thirdSegment.add(const Offset(344.6910755148741, 200.8));
//     thirdSegment.add(const Offset(556.370709382151, 184.0666666666667));
//     fourthSegment.add(const Offset(556.370709382151, 184.0666666666667));
//     fourthSegment.add(const Offset(780.0, 50.19999999999999));
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

//     testWidgets('Chart Widget - Testing Step Line series Data Source',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_customization_pointColor')
//               as _StepLineDataSource;
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
//     test('test segement values', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final StepLineSegment segment =
//               cartesianSeriesRenderer._segments[j] as StepLineSegment;
//           expect(segmentValues[j].elementAt(0).dx.toInt(), segment._x1.toInt());
//           expect(segmentValues[j].elementAt(0).dy.toInt(), segment._y1.toInt());
//           expect(segmentValues[j].elementAt(1).dx.toInt(), segment._x2.toInt());
//           expect(segmentValues[j].elementAt(1).dy.toInt(), segment._y2.toInt());
//         }
//       }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint count', () {
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
//           expect(pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
//           expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
//           expect(
//               pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
//           expect(
//               pointRegion[j].bottom.toInt(), dataPoints.region!.bottom.toInt());
//         }
//       }
//     });
//   });

//   group('Step Line - Empty Points', () {
//     final List<List<Offset>> segmentGaps = <List<Offset>>[];
//     final List<Offset> firstSegmentGap = <Offset>[];
//     firstSegmentGap.add(const Offset(358.695652173913, 132.10526315789477));
//     firstSegmentGap.add(const Offset(563.5652173913043, 26.421052631578974));
//     segmentGaps.add(firstSegmentGap);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
//     pointRegionGap.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
//     pointRegionGap.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
//     pointRegionGap.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
//     pointRegionGap.add(const Rect.fromLTRB(772.0, 18.4, 788.0, 34.4));

//     testWidgets(
//         'Chart Widget - Testing Step Line series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_dataSource_emptyPoint_gap')
//               as _StepLineDataSource;
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
//           final StepLineSegment segment =
//               cartesianSeriesRenderer._segments[j] as StepLineSegment;
//           expect(segmentGaps[j].elementAt(0).dx.toInt(), segment._x1.toInt());
//           expect(segmentGaps[j].elementAt(0).dy.toInt(), segment._y1.toInt());
//           expect(segmentGaps[j].elementAt(1).dx.toInt(), segment._x2.toInt());
//           expect(segmentGaps[j].elementAt(1).dy.toInt(), segment._y2.toInt());
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
//     firstSegmentZero.add(const Offset(34.0, 145.0222222222222));
//     firstSegmentZero.add(const Offset(153.49656750572086, 502.0));
//     secondSegmentZero.add(const Offset(153.49656750572086, 502.0));
//     secondSegmentZero.add(const Offset(344.6910755148741, 100.39999999999998));
//     thirdSegmentZero.add(const Offset(344.6910755148741, 100.39999999999998));
//     thirdSegmentZero.add(const Offset(556.370709382151, 78.08888888888889));
//     fourthSegmentZero.add(const Offset(556.370709382151, 78.08888888888889));
//     fourthSegmentZero.add(const Offset(780.0, 502.0));
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

//     testWidgets(
//         'Chart Widget - Testing Step Line series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_dataSource_emptyPoint_zero')
//               as _StepLineDataSource;
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
//           final StepLineSegment segment =
//               cartesianSeriesRenderer._segments[j] as StepLineSegment;
//           expect(segmentZeros[j].elementAt(0).dx.toInt(), segment._x1.toInt());
//           expect(segmentZeros[j].elementAt(0).dy.toInt(), segment._y1.toInt());
//           expect(segmentZeros[j].elementAt(1).dx.toInt(), segment._x2.toInt());
//           expect(segmentZeros[j].elementAt(1).dy.toInt(), segment._y2.toInt());
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
//     firstSegmentAvg.add(const Offset(34.0, 100.39999999999998));
//     firstSegmentAvg.add(const Offset(153.49656750572086, 75.30000000000001));
//     secondSegmentAvg.add(const Offset(153.49656750572086, 75.30000000000001));
//     secondSegmentAvg.add(const Offset(344.6910755148741, 50.19999999999999));
//     thirdSegmentAvg.add(const Offset(344.6910755148741, 50.19999999999999));
//     thirdSegmentAvg.add(const Offset(556.370709382151, 25.100000000000023));
//     fourthSegmentAvg.add(const Offset(556.370709382151, 25.100000000000023));
//     fourthSegmentAvg.add(const Offset(780.0, 263));
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
//     pointRegionAvg.add(const Rect.fromLTRB(772.0, 255.6, 788.0, 271.5));

//     testWidgets(
//         'Chart Widget - Testing Step Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_dataSource_emptyPoint_avg')
//               as _StepLineDataSource;
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
//           final StepLineSegment segment =
//               cartesianSeriesRenderer._segments[j] as StepLineSegment;
//           expect(segmentAvg[j].elementAt(0).dx.toInt(), segment._x1.toInt());
//           expect(segmentAvg[j].elementAt(0).dy.toInt(), segment._y1.toInt());
//           expect(segmentAvg[j].elementAt(1).dx.toInt(), segment._x2.toInt());
//           expect(segmentAvg[j].elementAt(1).dy.toInt(), segment._y2.toInt());
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
//     firstSegmentDrop.add(const Offset(58.0, 343.4736842105263));
//     firstSegmentDrop.add(const Offset(358.695652173913, 132.10526315789477));
//     secondSegmentDrop.add(const Offset(358.695652173913, 132.10526315789477));
//     secondSegmentDrop.add(const Offset(563.5652173913043, 26.421052631578974));
//     segmentDrop.add(firstSegmentDrop);
//     segmentDrop.add(secondSegmentDrop);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
//     pointRegionDrop.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
//     pointRegionDrop.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
//     pointRegionDrop.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
//     pointRegionDrop.add(const Rect.fromLTRB(772.0, 18.4, 788.0, 34.4));

//     testWidgets(
//         'Chart Widget - Testing Step Line series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_dataSource_emptyPoint_drop')
//               as _StepLineDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
//     test('test segement values', () {
//       // for (int i = 0; i < chart.series.length; i++) {
//       //   final CartesianSeriesRenderer cartesianSeriesRenderer =
//       //       _chartState._chartSeries.visibleSeriesRenderers[i];
//       //   for (int j = 0; j < cartesianSeriesRenderer.segments.length; j++) {
//       // final StepLineSegment segment = cartesianSeriesRenderer.segments[j];
//       // expect(segmentDrop[j].elementAt(0).dx.toInt(), segment._x1.toInt());
//       // expect(segmentDrop[j].elementAt(0).dy.toInt(), segment._y1.toInt());
//       // expect(segmentDrop[j].elementAt(1).dx.toInt(), segment._x2.toInt());
//       // expect(segmentDrop[j].elementAt(1).dy.toInt(), segment._y2.toInt());
//       //   }
//       // }
//     });

//     // to test series dataPoint count
//     test('test series dataPoint and segment count', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
//           expect(dataPoints, 5);
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
//     pointRegionNull.add(const Rect.fromLTRB(551, 494.0, 567, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Step Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _StepLineDataSource chartContainer =
//           _stepLineDataSource('stepLine_dataSource_emptyPoint_null')
//               as _StepLineDataSource;
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

// StatelessWidget _stepLineDataSource(String sampleName) {
//   return _StepLineDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _StepLineDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _StepLineDataSource(String sampleName) {
//     chart = _getStepLine(sampleName);
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
