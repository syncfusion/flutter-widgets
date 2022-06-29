// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'column_sample.dart';

// /// Testing method of column series data source.
// void columnDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;

//   group('Column - Defualt Properties', () {
//     // Actual segmentValues value which needs to be compared with test cases
//     final List<List<Offset>> segmentValues = <List<Offset>>[];
//     final List<Offset> firstSegment = <Offset>[];
//     final List<Offset> secondSegment = <Offset>[];
//     final List<Offset> thirdSegment = <Offset>[];
//     final List<Offset> fourthSegment = <Offset>[];
//     final List<Offset> fifthSegment = <Offset>[];
//     firstSegment.add(const Offset(1, 32));
//     // firstSegment.add(Offset(null, null));
//     secondSegment.add(const Offset(2, 24));
//     // secondSegment.add(Offset(null, null));
//     thirdSegment.add(const Offset(3, 36));
//     // thirdSegment.add(Offset(null, null));
//     fourthSegment.add(const Offset(4, 38));
//     // fourthSegment.add(Offset(null, null));
//     fifthSegment.add(const Offset(5, 54));
//     // fifthSegment.add(Offset(null, null));
//     segmentValues.add(firstSegment);
//     segmentValues.add(secondSegment);
//     segmentValues.add(thirdSegment);
//     segmentValues.add(fourthSegment);
//     segmentValues.add(fifthSegment);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegion = <Rect>[];
//     pointRegion.add(const Rect.fromLTRB(53.1, 234.3, 142.0, 502.0));
//     pointRegion.add(const Rect.fromLTRB(180.1, 301.2, 269.1, 502.0));
//     pointRegion.add(const Rect.fromLTRB(307.2, 200.8, 396.2, 502.0));
//     pointRegion.add(const Rect.fromLTRB(505.5, 184.1, 594.5, 502.0));
//     pointRegion.add(const Rect.fromLTRB(671.9761499148212, 50.2, 760.9, 502.0));

//     // Column series
//     testWidgets('Chart Widget - Testing Column series with default colors',
//         (WidgetTester tester) async {
//       final _ColumnDataSource chartContainer =
//           _columnDataSource('customization_default') as _ColumnDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//     });

// // error through due to flutter upgrade to 1.17.0

// // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
//     //       final ColumnSegment segment = seriesRenderer.segments[j];
//     //       expect(segmentValues[j].elementAt(0).dx.toInt(), segment.x1.toInt());
//     //       expect(segmentValues[j].elementAt(0).dy.toInt(), segment.y1.toInt());
//     //       expect(segmentValues[j].elementAt(1).dx, segment.x2);
//     //       expect(segmentValues[j].elementAt(1).dy, segment.y2);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
//     // test('test series dataPoint count', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//     //       final int dataPoints = seriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 5);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           seriesRenderer._dataPoints[j];
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

//   // group('Column - with Null Values', () {
//   //   // Column series
//   //   testWidgets('Chart Widget - Testing Column series with X Value Null',
//   //       (WidgetTester tester) async {
//   //     final _ColumnDataSource chartContainer =
//   //         _columnDataSource('dataSource_x_null') as _ColumnDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //   });

//   //   // to test dataPoint regions
//   //   test('test datapoint regions', () {
//   //     final CartesianSeriesRenderer seriesRenderer =
//   //         _chartState!._chartSeries.visibleSeriesRenderers[0];
//   //     final CartesianChartPoint<dynamic> dataPoints =
//   //         seriesRenderer._dataPoints[0];
//   //     expect(dataPoints.region!.left.toInt(), 145);
//   //     expect(dataPoints.region!.top.toInt(), 50);
//   //     expect(dataPoints.region!.right.toInt(), 668);
//   //     expect(dataPoints.region!.bottom.toInt(), 502);
//   //   });
//   //   testWidgets(
//   //       'Chart Widget - Testing Column series Data Source with all data null',
//   //       (WidgetTester tester) async {
//   //     final _ColumnDataSource chartContainer =
//   //         _columnDataSource('null') as _ColumnDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //   });

//   //   // to test series dataPoint count
//   //   test('test series dataPoint and segment count', () {
//   //     for (int i = 0; i < chart!.series.length; i++) {
//   //       final CartesianSeriesRenderer seriesRenderer =
//   //           _chartState!._chartSeries.visibleSeriesRenderers[i];
//   //       expect(seriesRenderer._segments.length, 0);
//   //     }
//   //   });
//   // // });

//   // group('Column- Empty Point', () {
//   //   final List<List<Offset>> segmentGaps = <List<Offset>>[];
//   //   final List<Offset> firstSegmentGap = <Offset>[];
//   //   final List<Offset> secondSegmentGap = <Offset>[];
//   //   firstSegmentGap.add(const Offset(1, 32));
//   //   // firstSegmentGap.add(Offset(null, null));
//   //   secondSegmentGap.add(const Offset(3, 36));
//   //   // secondSegmentGap.add(Offset(null, null));
//   //   segmentGaps.add(firstSegmentGap);
//   //   segmentGaps.add(secondSegmentGap);

//   //   // Actual pointRegion value which needs to be compared with test cases
//   //   final List<Rect> pointRegionGap = <Rect>[];
//   //   pointRegionGap.add(const Rect.fromLTRB(85.1, 347.5, 211.4, 502.0));
//   //   pointRegionGap.add(const Rect.fromLTRB(265.6, 347.5, 391.9, 502.0));
//   //   pointRegionGap.add(const Rect.fromLTRB(446.1, 38.6, 572.4, 502.0));
//   //   pointRegionGap.add(const Rect.fromLTRB(626.6, 38.6, 752.9, 502.0));

//   //   testWidgets('Chart Widget - Testing Column series with Empty Point as Gap',
//   //       (WidgetTester tester) async {
//   //     final _ColumnDataSource chartContainer =
//   //         _columnDataSource('emptyPoint_gap') as _ColumnDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //   });

//     // error through due to flutter upgrade to 1.17.0

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
//     //       final ColumnSegment segment = seriesRenderer.segments[j];
//     //       expect(segmentGaps[j].elementAt(0).dx.toInt(), segment.x1.toInt());
//     //       expect(segmentGaps[j].elementAt(0).dy.toInt(), segment.y1.toInt());
//     //       expect(segmentGaps[j].elementAt(1).dx, segment.x2);
//     //       expect(segmentGaps[j].elementAt(1).dy, segment.y2);
//     //     }
//     //   }
//     // });
//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           seriesRenderer._dataPoints[j];
//     //       expect(
//     //           pointRegionGap[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(pointRegionGap[j].bottom.toInt(),
//     //           dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });

//     // final List<List<Offset>> segmentZeros = <List<Offset>>[];
//     // final List<Offset> firstSegmentZero = <Offset>[];
//     // final List<Offset> secondSegmentZero = <Offset>[];
//     // final List<Offset> thirdSegmentZero = <Offset>[];
//     // final List<Offset> fourthSegmentZero = <Offset>[];
//     // firstSegmentZero.add(const Offset(1, 32));
//     // // firstSegmentZero.add(Offset(null, null));
//     // secondSegmentZero.add(const Offset(2, 0));
//     // // secondSegmentZero.add(Offset(null, null));
//     // thirdSegmentZero.add(const Offset(3, 36));
//     // // thirdSegmentZero.add(Offset(null, null));
//     // fourthSegmentZero.add(const Offset(4, 0));
//     // // fourthSegmentZero.add(Offset(null, null));
//     // segmentZeros.add(firstSegmentZero);
//     // segmentZeros.add(secondSegmentZero);
//     // segmentZeros.add(thirdSegmentZero);
//     // segmentZeros.add(fourthSegmentZero);

//     // // Actual pointRegion value which needs to be compared with test cases
//     // final List<Rect> pointRegionZero = <Rect>[];
//     // pointRegionZero
//     //     .add(const Rect.fromLTRB(61.97500000000001, 100.4, 192.5, 502.0));
//     // pointRegionZero.add(const Rect.fromLTRB(248.5, 502.0, 379.0, 502.0));
//     // pointRegionZero
//     //     .add(const Rect.fromLTRB(434.97499999999997, 50.2, 565.5, 502.0));
//     // pointRegionZero.add(const Rect.fromLTRB(621.5, 502.0, 752.0, 502.0));

// // Line series with
//     // testWidgets(
//     //     'Chart Widget - Testing Line series Data Source with empty point as zero',
//     //     (WidgetTester tester) async {
//     //   final _ColumnDataSource chartContainer =
//     //       _columnDataSource('emptyPoint_zero') as _ColumnDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });

//     // error through due to flutter upgrade to 1.17.0

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
//     //       final ColumnSegment segment = seriesRenderer.segments[j];
//     //       expect(segmentZeros[j].elementAt(0).dx.toInt(), segment.x1.toInt());
//     //       expect(segmentZeros[j].elementAt(0).dy.toInt(), segment.y1.toInt());
//     //       expect(segmentZeros[j].elementAt(1).dx, segment.x2);
//     //       expect(segmentZeros[j].elementAt(1).dy, segment.y2);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//     //       final int dataPoints = seriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(seriesRenderer._segments.length, 4);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           seriesRenderer._dataPoints[j];
//     //       expect(
//     //           pointRegionZero[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(
//     //           pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(pointRegionZero[j].right.toInt(),
//     //           dataPoints.region!.right.toInt());
//     //       expect(pointRegionZero[j].bottom.toInt(),
//     //           dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });

//     // final List<List<Offset>> segmentAvg = <List<Offset>>[];
//     // final List<Offset> firstSegmentAvg = <Offset>[];
//     // final List<Offset> secondSegmentAvg = <Offset>[];
//     // final List<Offset> thirdSegmentAvg = <Offset>[];
//     // final List<Offset> fourthSegmentAvg = <Offset>[];
//     // firstSegmentAvg.add(const Offset(1, 32));
//     // // firstSegmentAvg.add(Offset(null, null));
//     // secondSegmentAvg.add(const Offset(2, 34));
//     // // secondSegmentAvg.add(Offset(null, null));
//     // thirdSegmentAvg.add(const Offset(3, 36));
//     // // thirdSegmentAvg.add(Offset(null, null));
//     // fourthSegmentAvg.add(const Offset(4, 18));
//     // // fourthSegmentAvg.add(Offset(null, null));
//     // segmentAvg.add(firstSegmentAvg);
//     // segmentAvg.add(secondSegmentAvg);
//     // segmentAvg.add(thirdSegmentAvg);
//     // segmentAvg.add(fourthSegmentAvg);

//     // // Actual pointRegion value which needs to be compared with test cases
//     // final List<Rect> pointRegionAvg = <Rect>[];
//     // pointRegionAvg
//     //     .add(const Rect.fromLTRB(61.97500000000001, 100.4, 192.5, 502.0));
//     // pointRegionAvg.add(const Rect.fromLTRB(248.5, 75.3, 379.0, 502.0));
//     // pointRegionAvg
//     //     .add(const Rect.fromLTRB(434.97499999999997, 50.2, 565.5, 502.0));
//     // pointRegionAvg.add(const Rect.fromLTRB(621.5, 276.1, 752.0, 502.0));

//     // testWidgets(
//     //     'Chart Widget - Testing Column series Data Source with empty point as average',
//     //     (WidgetTester tester) async {
//     //   final _ColumnDataSource chartContainer =
//     //       _columnDataSource('emptyPoint_avg') as _ColumnDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });

//     // error through due to flutter upgrade to 1.17.0

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
//     //       final ColumnSegment segment = seriesRenderer.segments[j];
//     //       expect(segmentAvg[j].elementAt(0).dx.toInt(), segment.x1.toInt());
//     //       expect(segmentAvg[j].elementAt(0).dy.toInt(), segment.y1.toInt());
//     //       expect(segmentAvg[j].elementAt(1).dx, segment.x2);
//     //       expect(segmentAvg[j].elementAt(1).dy, segment.y2);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//     //       final int dataPoints = seriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(seriesRenderer._segments.length, 4);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           seriesRenderer._dataPoints[j];
//     //       expect(
//     //           pointRegionAvg[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(pointRegionAvg[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(pointRegionAvg[j].right.toInt(),
//     //           dataPoints.region!.right.toInt());
//     //       expect(pointRegionAvg[j].bottom.toInt(),
//     //           dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });
//     // testWidgets(
//     //     'Testing Column series with empty point as average, first value null and single point',
//     //     (WidgetTester tester) async {
//     //   final _ColumnDataSource chartContainer =
//     //       _columnDataSource('emptyPoint_avg_first_null') as _ColumnDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });
//     // test('test datapoint regions', () {
//     //   final CartesianSeriesRenderer seriesRenderer =
//     //       _chartState!._chartSeries.visibleSeriesRenderers[0];
//     //   final CartesianChartPoint<dynamic> dataPoints =
//     //       seriesRenderer._dataPoints[0];
//     //   expect(dataPoints.region!.left.toInt(), 156);
//     //   expect(dataPoints.region!.top.toInt(), 502);
//     //   expect(dataPoints.region!.bottom.toInt(), 502);
//     //   expect(dataPoints.region!.right.toInt(), 669);
//     // });
//     // final List<List<Offset>> segmentDrop = <List<Offset>>[];
//     // final List<Offset> firstSegmentDrop = <Offset>[];
//     // final List<Offset> secondSegmentDrop = <Offset>[];
//     // firstSegmentDrop.add(const Offset(1, 32));
//     // // firstSegmentDrop.add(Offset(null, null));
//     // secondSegmentDrop.add(const Offset(3, 36));
//     // // secondSegmentDrop.add(Offset(null, null));
//     // segmentDrop.add(firstSegmentDrop);
//     // segmentDrop.add(secondSegmentDrop);

//     // // Actual pointRegion value which needs to be compared with test cases
//     // final List<Rect> pointRegionDrop = <Rect>[];
//     // pointRegionDrop.add(const Rect.fromLTRB(85.1, 347.5, 211.4, 502.0));
//     // pointRegionDrop.add(const Rect.fromLTRB(265.6, 347.5, 391.9, 502.0));
//     // pointRegionDrop.add(const Rect.fromLTRB(446.1, 38.6, 572.4, 502.0));
//     // pointRegionDrop.add(const Rect.fromLTRB(626.6, 38.6, 752.9, 502.0));

//     // testWidgets(
//     //     'Chart Widget - Testing Column series Data Source with empty point as drop',
//     //     (WidgetTester tester) async {
//     //   final _ColumnDataSource chartContainer =
//     //       _columnDataSource('emptyPoint_drop') as _ColumnDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     // });

//     // error through due to flutter upgrade to 1.17.0

//     // to test segment value
//     // test('test segement values', () {
//     //   for (int i = 0; i < chart.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
//     //       final ColumnSegment segment = seriesRenderer.segments[j];
//     //       expect(segmentDrop[j].elementAt(0).dx.toInt(), segment.x1.toInt());
//     //       expect(segmentDrop[j].elementAt(0).dy.toInt(), segment.y1.toInt());
//     //       expect(segmentDrop[j].elementAt(1).dx, segment.x2);
//     //       expect(segmentDrop[j].elementAt(1).dy, segment.y2);
//     //     }
//     //   }
//     // });

//     // to test series dataPoint count
//     // test('test series dataPoint and segment count', () {
//     //   for (int i = 0;
//     //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//     //       i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
//     //       final int dataPoints = seriesRenderer._dataPoints.length;
//     //       expect(dataPoints, 4);
//     //       expect(seriesRenderer._segments.length, 2);
//     //     }
//     //   }
//     // });

//     // to test dataPoint regions
//     // test('test datapoint regions', () {
//     //   for (int i = 0; i < chart!.series.length; i++) {
//     //     final CartesianSeriesRenderer seriesRenderer =
//     //         _chartState!._chartSeries.visibleSeriesRenderers[i];
//     //     for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
//     //       final CartesianChartPoint<dynamic> dataPoints =
//     //           seriesRenderer._dataPoints[j];
//     //       expect(
//     //           pointRegionDrop[j].left.toInt(), dataPoints.region!.left.toInt());
//     //       expect(
//     //           pointRegionDrop[j].top.toInt(), dataPoints.region!.top.toInt());
//     //       expect(pointRegionDrop[j].right.toInt(),
//     //           dataPoints.region!.right.toInt());
//     //       expect(pointRegionDrop[j].bottom.toInt(),
//     //           dataPoints.region!.bottom.toInt());
//     //     }
//     //   }
//     // });
// //   });
// // }

// // StatelessWidget _columnDataSource(String sampleName) {
// //   return _ColumnDataSource(sampleName);
// // }

// // // ignore: must_be_immutable
// // class _ColumnDataSource extends StatelessWidget {
// //   // ignore: prefer_const_constructors_in_immutables
// //   _ColumnDataSource(String sampleName) {
// //     chart = _getColumnchart(sampleName);
// //   }
// //   SfCartesianChart? chart;
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       home: Scaffold(
// //           appBar: AppBar(
// //             title: const Text('Test Chart Widget'),
// //           ),
// //           body: Center(
// //               child: Container(
// //             margin: EdgeInsets.zero,
// //             child: chart,
// //           ))),
// //     );
// //   }
// // }
