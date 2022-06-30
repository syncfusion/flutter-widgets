// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import '../../../charts.dart';
// import 'bar_sample.dart';

/// Test method for bar series data source.
void barDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called

  // group('Bar - DataSource with Default Properties', () {
  //   // Actual segmentValues value which needs to be compared with test cases
  //   final List<List<Offset>> segmentValues = <List<Offset>>[];
  //   final List<Offset> firstSegment = <Offset>[];
  //   final List<Offset> secondSegment = <Offset>[];
  //   final List<Offset> thirdSegment = <Offset>[];
  //   final List<Offset> fourthSegment = <Offset>[];
  //   final List<Offset> fifthSegment = <Offset>[];
  //   firstSegment.add(const Offset(1, 32));
  //   // firstSegment.add(Offset(null, null));
  //   secondSegment.add(const Offset(2, 24));
  //   // secondSegment.add(Offset(null, null));
  //   thirdSegment.add(const Offset(3, 36));
  //   // thirdSegment.add(Offset(null, null));
  //   fourthSegment.add(const Offset(4, 38));
  //   // fourthSegment.add(Offset(null, null));
  //   fifthSegment.add(const Offset(5, 54));
  //   // fifthSegment.add(Offset(null, null));
  //   segmentValues.add(firstSegment);
  //   segmentValues.add(secondSegment);
  //   segmentValues.add(thirdSegment);
  //   segmentValues.add(fourthSegment);
  //   segmentValues.add(fifthSegment);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegion = <Rect>[];
  //   pointRegion.add(const Rect.fromLTRB(46.0, 429.3, 437.5, 489.2));
  //   pointRegion.add(const Rect.fromLTRB(46.0, 343.8, 339.6, 403.7));
  //   pointRegion.add(const Rect.fromLTRB(46.0, 258.3, 486.4, 318.1));
  //   pointRegion.add(const Rect.fromLTRB(46.0, 124.9, 510.9, 184.7));
  //   pointRegion.add(const Rect.fromLTRB(46.0, 12.8, 706.6, 72.7));

  //   // Bar series
  //   testWidgets('Chart Widget - Testing Bar series with default colors',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('customization_default') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // error through due to flutter upgrade to 1.17.0

  //   // test('test segement values', () {
  //   //   for (int i = 0; i < chart.series.length; i++) {
  //   //     final CartesianSeriesRenderer seriesRenderer =
  //   //         _chartState._chartSeries.visibleSeriesRenderers[i];
  //   //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
  //   //       final BarSegment segment = seriesRenderer.segments[j];
  //   //       expect(segmentValues[j].elementAt(0).dx.toInt(), segment.x1.toInt());
  //   //       expect(segmentValues[j].elementAt(0).dy.toInt(), segment.y1.toInt());
  //   //       expect(segmentValues[j].elementAt(1).dx, segment.x2);
  //   //       expect(segmentValues[j].elementAt(1).dy, segment.y2);
  //   //     }
  //   //   }
  //   // });

  //   // to test series dataPoint count
  //   test('test series dataPoint count', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //       }
  //     }
  //   });

  //   // to test dataPoint regions
  //   test('test datapoint regions', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
  //         final CartesianChartPoint<dynamic> dataPoints =
  //             seriesRenderer._dataPoints[j];
  //         expect(pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(
  //             pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
  //         expect(
  //             pointRegion[j].bottom.toInt(), dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });

  //   testWidgets(
  //       'Chart Widget - Testing Bar series Data Source with all data null',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('null') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       expect(seriesRenderer._segments.length, 0);
  //     }
  //   });
  // });

  // group('Bar - Empty Point', () {
  //   final List<List<Offset>> segmentGaps = <List<Offset>>[];
  //   final List<Offset> firstSegmentGap = <Offset>[];
  //   final List<Offset> secondSegmentGap = <Offset>[];
  //   firstSegmentGap.add(const Offset(1, 32));
  //   // firstSegmentGap.add(Offset(null, null));
  //   secondSegmentGap.add(const Offset(3, 36));
  //   // secondSegmentGap.add(Offset(null, null));
  //   segmentGaps.add(firstSegmentGap);
  //   segmentGaps.add(secondSegmentGap);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionGap = <Rect>[];
  //   pointRegionGap.add(const Rect.fromLTRB(46.0, 395.3, 271.8, 483.2));
  //   pointRegionGap.add(const Rect.fromLTRB(46.0, 269.8, 271.8, 357.7));
  //   pointRegionGap.add(const Rect.fromLTRB(46.0, 144.3, 723.5, 232.2));
  //   pointRegionGap.add(const Rect.fromLTRB(46.0, 18.8, 723.5, 106.7));

  //   testWidgets('Chart Widget - Testing Bar series with Empty Point as Gap',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('emptyPoint_gap') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // error through due to flutter upgrade to 1.17.0

  //   // to test segment value
  //   // test('test segement values', () {
  //   //   for (int i = 0; i < chart.series.length; i++) {
  //   //     final CartesianSeriesRenderer seriesRenderer =
  //   //         _chartState._chartSeries.visibleSeriesRenderers[i];
  //   //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
  //   //       final BarSegment segment = seriesRenderer.segments[j];
  //   //       expect(segmentGaps[j].elementAt(0).dx.toInt(), segment.x1.toInt());
  //   //       expect(segmentGaps[j].elementAt(0).dy.toInt(), segment.y1.toInt());
  //   //       expect(segmentGaps[j].elementAt(1).dx, segment.x2);
  //   //       expect(segmentGaps[j].elementAt(1).dy, segment.y2);
  //   //     }
  //   //   }
  //   // });
  //   // to test dataPoint regions
  //   test('test datapoint regions', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
  //         final CartesianChartPoint<dynamic> dataPoints =
  //             seriesRenderer._dataPoints[j];
  //         expect(
  //             pointRegionGap[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionGap[j].bottom.toInt(),
  //             dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });

  //   final List<List<Offset>> segmentZeros = <List<Offset>>[];
  //   final List<Offset> firstSegmentZero = <Offset>[];
  //   final List<Offset> secondSegmentZero = <Offset>[];
  //   final List<Offset> thirdSegmentZero = <Offset>[];
  //   final List<Offset> fourthSegmentZero = <Offset>[];
  //   firstSegmentZero.add(const Offset(1, 32));
  //   // firstSegmentZero.add(Offset(null, null));
  //   secondSegmentZero.add(const Offset(2, 0));
  //   // secondSegmentZero.add(Offset(null, null));
  //   thirdSegmentZero.add(const Offset(3, 36));
  //   // thirdSegmentZero.add(Offset(null, null));
  //   fourthSegmentZero.add(const Offset(4, 0));
  //   // fourthSegmentZero.add(Offset(null, null));
  //   segmentZeros.add(firstSegmentZero);
  //   segmentZeros.add(secondSegmentZero);
  //   segmentZeros.add(thirdSegmentZero);
  //   segmentZeros.add(fourthSegmentZero);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionZero = <Rect>[];
  //   pointRegionZero.add(const Rect.fromLTRB(46.0, 395.3, 633.2, 483.2));
  //   pointRegionZero.add(const Rect.fromLTRB(46.0, 269.8, 46.0, 357.7));
  //   pointRegionZero.add(const Rect.fromLTRB(46.0, 144.3, 706.6, 232.2));
  //   pointRegionZero.add(const Rect.fromLTRB(46.0, 18.8, 46.0, 106.7));

  //   testWidgets(
  //       'Chart Widget - Testing Line series Data Source with empty point as zero',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('emptyPoint_zero') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // error through due to flutter upgrade to 1.17.0

  //   // to test segment value
  //   // test('test segement values', () {
  //   //   for (int i = 0; i < chart.series.length; i++) {
  //   //     final CartesianSeriesRenderer seriesRenderer =
  //   //         _chartState._chartSeries.visibleSeriesRenderers[i];
  //   //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
  //   //       final BarSegment segment = seriesRenderer.segments[j];
  //   //       expect(segmentZeros[j].elementAt(0).dx.toInt(), segment.x1.toInt());
  //   //       expect(segmentZeros[j].elementAt(0).dy.toInt(), segment.y1.toInt());
  //   //       expect(segmentZeros[j].elementAt(1).dx, segment.x2);
  //   //       expect(segmentZeros[j].elementAt(1).dy, segment.y2);
  //   //     }
  //   //   }
  //   // });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 4);
  //         expect(seriesRenderer._segments.length, 4);
  //       }
  //     }
  //   });

  //   // to test dataPoint regions
  //   test('test datapoint regions', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
  //         final CartesianChartPoint<dynamic> dataPoints =
  //             seriesRenderer._dataPoints[j];
  //         expect(
  //             pointRegionZero[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(
  //             pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionZero[j].right.toInt(),
  //             dataPoints.region!.right.toInt());
  //         expect(pointRegionZero[j].bottom.toInt(),
  //             dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });

  //   final List<List<Offset>> segmentAvg = <List<Offset>>[];
  //   final List<Offset> firstSegmentAvg = <Offset>[];
  //   final List<Offset> secondSegmentAvg = <Offset>[];
  //   final List<Offset> thirdSegmentAvg = <Offset>[];
  //   final List<Offset> fourthSegmentAvg = <Offset>[];
  //   firstSegmentAvg.add(const Offset(1, 32));
  //   // firstSegmentAvg.add(Offset(null, null));
  //   secondSegmentAvg.add(const Offset(2, 34));
  //   // secondSegmentAvg.add(Offset(null, null));
  //   thirdSegmentAvg.add(const Offset(3, 36));
  //   // thirdSegmentAvg.add(Offset(null, null));
  //   fourthSegmentAvg.add(const Offset(4, 18));
  //   // fourthSegmentAvg.add(Offset(null, null));
  //   segmentAvg.add(firstSegmentAvg);
  //   segmentAvg.add(secondSegmentAvg);
  //   segmentAvg.add(thirdSegmentAvg);
  //   segmentAvg.add(fourthSegmentAvg);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionAvg = <Rect>[];
  //   pointRegionAvg.add(const Rect.fromLTRB(46.0, 395.3, 633.2, 483.2));
  //   pointRegionAvg.add(const Rect.fromLTRB(46.0, 269.8, 669.9, 357.7));
  //   pointRegionAvg.add(const Rect.fromLTRB(46.0, 144.3, 706.6, 232.2));
  //   pointRegionAvg.add(const Rect.fromLTRB(46.0, 18.8, 376.3, 106.7));

  //   testWidgets(
  //       'Chart Widget - Testing Bar series Data Source with empty point as average',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('emptyPoint_avg') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // error through due to flutter upgrade to 1.17.0

  //   // to test segment value
  //   // test('test segement values', () {
  //   //   for (int i = 0; i < chart.series.length; i++) {
  //   //     final CartesianSeriesRenderer seriesRenderer =
  //   //         _chartState._chartSeries.visibleSeriesRenderers[i];
  //   //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
  //   //       final BarSegment segment = seriesRenderer.segments[j];
  //   //       expect(segmentAvg[j].elementAt(0).dx.toInt(), segment.x1.toInt());
  //   //       expect(segmentAvg[j].elementAt(0).dy.toInt(), segment.y1.toInt());
  //   //       expect(segmentAvg[j].elementAt(1).dx, segment.x2);
  //   //       expect(segmentAvg[j].elementAt(1).dy, segment.y2);
  //   //     }
  //   //   }
  //   // });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 4);
  //         expect(seriesRenderer._segments.length, 4);
  //       }
  //     }
  //   });

  //   // to test dataPoint regions
  //   test('test datapoint regions', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
  //         final CartesianChartPoint<dynamic> dataPoints =
  //             seriesRenderer._dataPoints[j];
  //         expect(
  //             pointRegionAvg[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(pointRegionAvg[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionAvg[j].right.toInt(),
  //             dataPoints.region!.right.toInt());
  //         expect(pointRegionAvg[j].bottom.toInt(),
  //             dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });

  //   final List<List<Offset>> segmentDrop = <List<Offset>>[];
  //   final List<Offset> firstSegmentDrop = <Offset>[];
  //   final List<Offset> secondSegmentDrop = <Offset>[];
  //   firstSegmentDrop.add(const Offset(1, 32));
  //   // firstSegmentDrop.add(Offset(null, null));
  //   secondSegmentDrop.add(const Offset(3, 36));
  //   // secondSegmentDrop.add(Offset(null, null));
  //   segmentDrop.add(firstSegmentDrop);
  //   segmentDrop.add(secondSegmentDrop);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionDrop = <Rect>[];
  //   pointRegionDrop.add(const Rect.fromLTRB(46.0, 395.3, 271.8, 483.2));
  //   pointRegionDrop.add(const Rect.fromLTRB(46.0, 269.8, 271.8, 357.7));
  //   pointRegionDrop.add(const Rect.fromLTRB(46.0, 144.3, 723.5, 232.2));
  //   pointRegionDrop.add(const Rect.fromLTRB(46.0, 18.8, 723.5, 106.7));

  //   testWidgets(
  //       'Chart Widget - Testing Bar series Data Source with empty point as drop',
  //       (WidgetTester tester) async {
  //     final _BarDataSource chartContainer =
  //         _barDataSource('emptyPoint_drop') as _BarDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // error through due to flutter upgrade to 1.17.0

  //   // to test segment value
  //   // test('test segement values', () {
  //   //   for (int i = 0; i < chart.series.length; i++) {
  //   //     final CartesianSeriesRenderer seriesRenderer =
  //   //         _chartState._chartSeries.visibleSeriesRenderers[i];
  //   //     for (int j = 0; j < seriesRenderer.segments.length; j++) {
  //   //       final BarSegment segment = seriesRenderer.segments[j];
  //   //       expect(segmentDrop[j].elementAt(0).dx.toInt(), segment.x1.toInt());
  //   //       expect(segmentDrop[j].elementAt(0).dy.toInt(), segment.y1.toInt());
  //   //       expect(segmentDrop[j].elementAt(1).dx, segment.x2);
  //   //       expect(segmentDrop[j].elementAt(1).dy, segment.y2);
  //   //     }
  //   //   }
  //   // });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 4);
  //         expect(seriesRenderer._segments.length, 2);
  //       }
  //     }
  //   });

  //   // to test dataPoint regions
  //   test('test datapoint regions', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
  //         final CartesianChartPoint<dynamic> dataPoints =
  //             seriesRenderer._dataPoints[j];
  //         expect(
  //             pointRegionDrop[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(
  //             pointRegionDrop[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionDrop[j].right.toInt(),
  //             dataPoints.region!.right.toInt());
  //         expect(pointRegionDrop[j].bottom.toInt(),
  //             dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });
  // });
}

// StatelessWidget _barDataSource(String sampleName) {
//   return _BarDataSource(sampleName);
// }

// ignore: must_be_immutable
// class _BarDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _BarDataSource(String sampleName) {
//     chart = getBarChart(sampleName);
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
