import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'line_sample.dart';

/// Testing method of line series data source.
void lineDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Line - Default Properties', () {
    // Actual segmentValues value which needs to be compared with test cases
    final List<List<Offset>> segmentValues = <List<Offset>>[];
    final List<Offset> firstSegment = <Offset>[];
    final List<Offset> secondSegment = <Offset>[];
    final List<Offset> thirdSegment = <Offset>[];
    final List<Offset> fourthSegment = <Offset>[];
    firstSegment.add(const Offset(34.0, 234.93333333333334));
    firstSegment.add(const Offset(153.01601830663617, 301));
    secondSegment.add(const Offset(153.01601830663617, 301.0));
    secondSegment.add(const Offset(344.44164759725396, 200.2));
    thirdSegment.add(const Offset(344.44164759725396, 200.4));
    thirdSegment.add(const Offset(556.270022883295, 184.1333333333333));
    fourthSegment.add(const Offset(556.270022883295, 184.1333333333333));
    fourthSegment.add(const Offset(780.0, 50.0));
    segmentValues.add(firstSegment);
    segmentValues.add(secondSegment);
    segmentValues.add(thirdSegment);
    segmentValues.add(fourthSegment);

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegion = <Rect>[];
    pointRegion.add(const Rect.fromLTRB(26.0, 226, 42.0, 242));
    pointRegion.add(const Rect.fromLTRB(145.0, 293.0, 161.0, 309.0));
    pointRegion.add(const Rect.fromLTRB(336.4, 192.4, 352.4, 208.4));
    pointRegion.add(const Rect.fromLTRB(548.3, 176.0, 564.3, 192.1));
    pointRegion.add(const Rect.fromLTRB(772.0, 42.0, 788.0, 58.0));

    testWidgets('Chart Widget - Testing Line series Data Source',
        (WidgetTester tester) async {
      final _LineDateSource chartContainer =
          _lineDateSource('line_customization_pointColor') as _LineDateSource;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // to test segment value
    // test('test segement values', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final LineSegment lineSegment =
    //           cartesianSeriesRenderer._segments[j] as LineSegment;
    //       expect(segmentValues[j].elementAt(0).dx.toInt(),
    //           lineSegment._x1.toInt());
    //       expect(segmentValues[j].elementAt(0).dy.toInt(),
    //           lineSegment._y1.toInt());
    //       expect(segmentValues[j].elementAt(1).dx.toInt(),
    //           lineSegment._x2.toInt());
    //       expect(segmentValues[j].elementAt(1).dy.toInt(),
    //           lineSegment._y2.toInt());
    //     }
    //   }
    // });

    // to test series dataPoint count
    // test('test series dataPoint count', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 5);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
    //       final CartesianChartPoint<dynamic> dataPoints =
    //           cartesianSeriesRenderer._dataPoints[j];
    //       expect(dataPoints.region!.left.toInt(), pointRegion[j].left.toInt());
    //       expect(dataPoints.region!.top.toInt(), pointRegion[j].top.toInt());
    //       expect(
    //           dataPoints.region!.right.toInt(), pointRegion[j].right.toInt());
    //       expect(
    //           dataPoints.region!.bottom.toInt(), pointRegion[j].bottom.toInt());
    //     }
    //   }
    // });
  });

//   group('Line - Empty Point', () {
//     final List<List<Offset>> segmentGaps = <List<Offset>>[];
//     final List<Offset> firstSegmentGap = <Offset>[];
//     firstSegmentGap.add(const Offset(358.44622425629285, 132.33333333333334));
//     firstSegmentGap.add(const Offset(563.4645308924485, 26.0));
//     segmentGaps.add(firstSegmentGap);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(50.0, 335.0, 66.0, 351.0));
//     pointRegionGap.add(const Rect.fromLTRB(165.2, 335.0, 181.2, 351.0));
//     pointRegionGap.add(const Rect.fromLTRB(350.4, 124.3, 366.4, 140.3));
//     pointRegionGap.add(const Rect.fromLTRB(555.5, 18.0, 571.5, 34.0));
//     pointRegionGap.add(const Rect.fromLTRB(772.0, 18.0, 788.0, 34.0));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_dataSource_emptyPoint_gap') as _LineDateSource;
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
//           final LineSegment lineSegment =
//               cartesianSeriesRenderer._segments[j] as LineSegment;
//           expect(
//               segmentGaps[j].elementAt(0).dx.toInt(), lineSegment._x1.toInt());
//           expect(
//               segmentGaps[j].elementAt(0).dy.toInt(), lineSegment._y1.toInt());
//           expect(
//               segmentGaps[j].elementAt(1).dx.toInt(), lineSegment._x2.toInt());
//           expect(
//               segmentGaps[j].elementAt(1).dy.toInt(), lineSegment._y2.toInt());
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
//     firstSegmentZero.add(const Offset(34.0, 145.79999999999998));
//     firstSegmentZero.add(const Offset(153.01601830663617, 502.0));
//     secondSegmentZero.add(const Offset(153.01601830663617, 502.0));
//     secondSegmentZero.add(const Offset(344.44164759725396, 100.89999999999999));
//     thirdSegmentZero.add(const Offset(344.44164759725396, 100.89999999999999));
//     thirdSegmentZero.add(const Offset(556.270022883295, 78.95000000000002));
//     fourthSegmentZero.add(const Offset(556.270022883295, 78.95000000000002));
//     fourthSegmentZero.add(const Offset(780.0, 502.0));
//     segmentZeros.add(firstSegmentZero);
//     segmentZeros.add(secondSegmentZero);
//     segmentZeros.add(thirdSegmentZero);
//     segmentZeros.add(fourthSegmentZero);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionZero = <Rect>[];
//     pointRegionZero.add(const Rect.fromLTRB(26.0, 137.8, 42.0, 153.8));
//     pointRegionZero.add(const Rect.fromLTRB(145.5, 494.0, 161.5, 510.0));
//     pointRegionZero.add(const Rect.fromLTRB(336.7, 92.4, 352.7, 108.4));
//     pointRegionZero.add(const Rect.fromLTRB(548.4, 70.1, 564.4, 86.1));
//     pointRegionZero.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

// // Line series with
//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_dataSource_emptyPoint_zero') as _LineDateSource;
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
//           final LineSegment lineSegment =
//               cartesianSeriesRenderer._segments[j] as LineSegment;
//           expect(
//               segmentZeros[j].elementAt(0).dx.toInt(), lineSegment._x1.toInt());
//           expect(
//               segmentZeros[j].elementAt(0).dy.toInt(), lineSegment._y1.toInt());
//           expect(
//               segmentZeros[j].elementAt(1).dx.toInt(), lineSegment._x2.toInt());
//           expect(
//               segmentZeros[j].elementAt(1).dy.toInt(), lineSegment._y2.toInt());
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
//     firstSegmentAvg.add(const Offset(34.0, 100.70000000000002));
//     firstSegmentAvg.add(const Offset(153.01601830663617, 75.79999999999998));
//     secondSegmentAvg.add(const Offset(153.01601830663617, 75.79999999999998));
//     secondSegmentAvg.add(const Offset(344.44164759725396, 50.89999999999999));
//     thirdSegmentAvg.add(const Offset(344.44164759725396, 50.8999999999999));
//     thirdSegmentAvg.add(const Offset(556.270022883295, 25.0));
//     fourthSegmentAvg.add(const Offset(556.270022883295, 25.0));
//     fourthSegmentAvg.add(const Offset(780.0, 263.04999999999995));
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
//         'Chart Widget - Testing Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_dataSource_emptyPoint_avg') as _LineDateSource;
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
//           final LineSegment lineSegment =
//               cartesianSeriesRenderer._segments[j] as LineSegment;
//           expect(
//               segmentAvg[j].elementAt(0).dx.toInt(), lineSegment._x1.toInt());
//           expect(
//               segmentAvg[j].elementAt(0).dy.toInt(), lineSegment._y1.toInt());
//           expect(
//               segmentAvg[j].elementAt(1).dx.toInt(), lineSegment._x2.toInt());
//           expect(
//               segmentAvg[j].elementAt(1).dy.toInt(), lineSegment._y2.toInt());
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

//     testWidgets(
//         'Testing Line series with empty point as average and first value null',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_emptyPoint_avg_first_null') as _LineDateSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     test('test datapoint regions', () {
//       final CartesianSeriesRenderer cartesianSeriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final CartesianChartPoint<dynamic> dataPoints =
//           cartesianSeriesRenderer._dataPoints[0];
//       expect(dataPoints.region!.left.toInt(), 26);
//       expect(dataPoints.region!.top.toInt(), 293);
//       expect(dataPoints.region!.bottom.toInt(), 309);
//       expect(dataPoints.region!.right.toInt(), 42);
//     });

//     final List<List<Offset>> segmentDrop = <List<Offset>>[];
//     final List<Offset> firstSegmentDrop = <Offset>[];
//     final List<Offset> secondSegmentDrop = <Offset>[];
//     final List<Offset> thirdSegmentDrop = <Offset>[];
//     firstSegmentDrop.add(const Offset(58.0, 343.0));
//     firstSegmentDrop.add(const Offset(358.0, 132.0));
//     secondSegmentDrop.add(const Offset(358.0, 132.0));
//     secondSegmentDrop.add(const Offset(563.4645308924485, 26.0));
//     thirdSegmentDrop.add(const Offset(563.9633867276887, 26.0));
//     thirdSegmentDrop.add(const Offset(790.0, 3138.6666666666665));
//     segmentDrop.add(firstSegmentDrop);
//     segmentDrop.add(secondSegmentDrop);
//     segmentDrop.add(thirdSegmentDrop);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionDrop = <Rect>[];
//     pointRegionDrop.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
//     pointRegionDrop.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
//     pointRegionDrop.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
//     pointRegionDrop.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
//     pointRegionDrop.add(const Rect.fromLTRB(772.0, 18.4, 788.0, 34.4));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_dataSource_emptyPoint_drop') as _LineDateSource;
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
//           final LineSegment lineSegment =
//               cartesianSeriesRenderer._segments[j] as LineSegment;
//           expect(
//               segmentDrop[j].elementAt(0).dx.toInt(), lineSegment._x1.toInt());
//           expect(
//               segmentDrop[j].elementAt(0).dy.toInt(), lineSegment._y1.toInt());
//           expect(
//               segmentDrop[j].elementAt(1).dx.toInt(), lineSegment._x2.toInt());
//           expect(
//               segmentDrop[j].elementAt(1).dy.toInt(), lineSegment._y2.toInt());
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
//     pointRegionNull.add(const Rect.fromLTRB(551.0, 494.0, 567.0, 510.0));
//     pointRegionNull.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _LineDateSource chartContainer =
//           _lineDateSource('line_dataSource_emptyPoint_null') as _LineDateSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     // to test segment value
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
}

StatelessWidget _lineDateSource(String sampleName) {
  return _LineDateSource(sampleName);
}

// ignore: must_be_immutable
class _LineDateSource extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _LineDateSource(String sampleName) {
    chart = getLineChart(sampleName);
  }
  SfCartesianChart? chart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Test Chart Widget'),
          ),
          body: Center(
              child: Container(
            margin: EdgeInsets.zero,
            child: chart,
          ))),
    );
  }
}
