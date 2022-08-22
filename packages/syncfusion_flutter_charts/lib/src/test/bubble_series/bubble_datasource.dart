// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import '../../../charts.dart';
// import 'bubble_sample.dart';

/// Testing method of bubble series data source.
void bubbleDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called

  // group('Bubble - Defualt Properties', () {
  //   // Actual segmentValues value which needs to be compared with test cases
  //   final List<List<Offset>> segmentValues = <List<Offset>>[];
  //   final List<Offset> firstSegment = <Offset>[];
  //   final List<Offset> secondSegment = <Offset>[];
  //   final List<Offset> thirdSegment = <Offset>[];
  //   final List<Offset> fourthSegment = <Offset>[];
  //   firstSegment.add(const Offset(61.5, 366.03333333333336));
  //   firstSegment.add(const Offset(178.19336384439362, 495.5));
  //   secondSegment.add(const Offset(178.19336384439362, 495.5));
  //   secondSegment.add(const Offset(364.9027459954233, 301.3));
  //   thirdSegment.add(const Offset(364.9027459954233, 301.3));
  //   thirdSegment.add(const Offset(571.616704805492, 268.93333333333334));
  //   fourthSegment.add(const Offset(571.616704805492, 268.93333333333334));
  //   fourthSegment.add(const Offset(790.0, 10.0));
  //   segmentValues.add(firstSegment);
  //   segmentValues.add(secondSegment);
  //   segmentValues.add(thirdSegment);
  //   segmentValues.add(fourthSegment);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegion = <Rect>[];
  //   pointRegion.add(const Rect.fromLTRB(22.1, 222.3, 45.9, 245.2));
  //   pointRegion.add(const Rect.fromLTRB(144.5, 292.2, 162.5, 310.2));
  //   pointRegion.add(const Rect.fromLTRB(335.6, 191.7, 353.8, 209.9));
  //   pointRegion.add(const Rect.fromLTRB(546.7, 174.4, 566, 193.7));
  //   pointRegion.add(const Rect.fromLTRB(760.0, 30.2, 800.0, 70.2));

  //   testWidgets('Chart Widget - Testing Bubble series Data Source',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('customization_pointColor') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series count
  //   test('test series count', () {
  //     expect(chart!.series.length, 1);
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
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
  // });

  // group('Bubble - Empty Point', () {
  //   final List<List<Offset>> segmentGaps = <List<Offset>>[];
  //   final List<Offset> firstSegmentGap = <Offset>[];
  //   firstSegmentGap.add(const Offset(380.0743707093821, 171.83333333333334));
  //   firstSegmentGap.add(const Offset(579.4107551487414, 10.0));
  //   segmentGaps.add(firstSegmentGap);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionGap = <Rect>[];
  // pointRegionGap.add(const Rect.fromLTRB(46.6, 332.1, 69.4, 354.9));
  // pointRegionGap.add(const Rect.fromLTRB(164.6, 334.4, 182.7, 352.6));
  // pointRegionGap.add(const Rect.fromLTRB(349.6, 122.97, 367.8, 141.2));
  // pointRegionGap.add(const Rect.fromLTRB(553.9, 16.8, 573.2, 36.1));
  // pointRegionGap.add(const Rect.fromLTRB(760.0, 6.4, 800.0, 46.4));

  //   testWidgets(
  //       'Chart Widget - Testing Bubble series Data Source with empty point as gap',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('dataSource_emptyPoint_gap') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //         expect(seriesRenderer._segments.length, 3);
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
  //             pointRegionGap[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionGap[j].right.toInt(),
  //             dataPoints.region!.right.toInt());
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
  //   firstSegmentZero.add(const Offset(87.5, 495.5));
  //   firstSegmentZero.add(const Offset(200.02860411899314, 3084.833333333333));
  //   secondSegmentZero.add(const Offset(200.02860411899314, 3084.833333333333));
  //   secondSegmentZero.add(const Offset(380.0743707093821, 171.83333333333334));
  //   thirdSegmentZero.add(const Offset(380.0743707093821, 171.83333333333334));
  //   thirdSegmentZero.add(const Offset(579.4107551487414, 10.0));
  //   fourthSegmentZero.add(const Offset(579.4107551487414, 10.0));
  //   fourthSegmentZero.add(const Offset(790.0, 3084.833333333333));
  //   segmentZeros.add(firstSegmentZero);
  //   segmentZeros.add(secondSegmentZero);
  //   segmentZeros.add(thirdSegmentZero);
  //   segmentZeros.add(fourthSegmentZero);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionZero = <Rect>[];
//  pointRegionZero.add(const Rect.fromLTRB(22.6, 133.6, 45.4, 156.4));
//     pointRegionZero.add(const Rect.fromLTRB(144.4, 492.9, 162.6, 511.1));
//     pointRegionZero.add(const Rect.fromLTRB(335.6, 91.3, 353.8, 109.5));
//     pointRegionZero.add(const Rect.fromLTRB(546.7, 68.5, 566.0, 87.7));
//     pointRegionZero.add(const Rect.fromLTRB(760.0, 482.0, 800.0, 522.0));

  //   testWidgets(
  //       'Chart Widget - Testing Bubble series Data Source with empty point as zero',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('dataSource_emptyPoint_zero') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //         expect(seriesRenderer._segments.length, 5);
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
  //   firstSegmentAvg.add(const Offset(87.5, 495.5));
  //   firstSegmentAvg.add(const Offset(200.02860411899314, 333.6666666666667));
  //   secondSegmentAvg.add(const Offset(200.02860411899314, 333.6666666666667));
  //   secondSegmentAvg.add(const Offset(380.0743707093821, 171.83333333333334));
  //   thirdSegmentAvg.add(const Offset(380.0743707093821, 171.83333333333334));
  //   thirdSegmentAvg.add(const Offset(579.4107551487414, 10.0));
  //   fourthSegmentAvg.add(const Offset(579.4107551487414, 10.0));
  //   fourthSegmentAvg.add(const Offset(790.0, 1547.4166666666665));
  //   segmentAvg.add(firstSegmentAvg);
  //   segmentAvg.add(secondSegmentAvg);
  //   segmentAvg.add(thirdSegmentAvg);
  //   segmentAvg.add(fourthSegmentAvg);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionAvg = <Rect>[];
  // pointRegionAvg.add(const Rect.fromLTRB(22.6, 88.5, 45.4, 111.8));
  // pointRegionAvg.add(const Rect.fromLTRB(144.4, 66.2, 162.6, 84.4));
  // pointRegionAvg.add(const Rect.fromLTRB(335.6, 41.1, 353.8, 59.3));
  // pointRegionAvg.add(const Rect.fromLTRB(546.7, 15.5, 566.0, 34.7));
  // pointRegionAvg.add(const Rect.fromLTRB(760.0, 243.6, 800.0, 283.6));

  //   testWidgets(
  //       'Chart Widget - Testing Bubble series Data Source with empty point as average',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('dataSource_emptyPoint_avg') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //         expect(seriesRenderer._segments.length, 5);
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
  //   final List<Offset> thirdSegmentDrop = <Offset>[];
  //   firstSegmentDrop.add(const Offset(87.5, 495.5));
  //   firstSegmentDrop.add(const Offset(380.0743707093821, 171.83333333333334));
  //   secondSegmentDrop.add(const Offset(380.0743707093821, 171.83333333333334));
  //   secondSegmentDrop.add(const Offset(579.4107551487414, 10.0));
  //   thirdSegmentDrop.add(const Offset(579.4107551487414, 10.0));
  //   thirdSegmentDrop.add(const Offset(790.0, 3084.833333333333));
  //   segmentDrop.add(firstSegmentDrop);
  //   segmentDrop.add(secondSegmentDrop);
  //   segmentDrop.add(thirdSegmentDrop);

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionDrop = <Rect>[];
  //   pointRegionDrop.add(const Rect.fromLTRB(46.6, 332.1, 69.4, 354.9));
  // pointRegionDrop.add(const Rect.fromLTRB(164.6, 334.4, 182.7, 352.6));
  // pointRegionDrop.add(const Rect.fromLTRB(349.6, 122.0, 367.8, 141.2));
  // pointRegionDrop.add(const Rect.fromLTRB(553.9, 16.8, 573.2, 36.1));
  // pointRegionDrop.add(const Rect.fromLTRB(760.8, 6.4, 800.0, 46.4));

  //   testWidgets(
  //       'Chart Widget - Testing Bubble series Data Source with empty point as drop',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('dataSource_emptyPoint_drop') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //         expect(seriesRenderer._segments.length, 3);
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

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionNull = <Rect>[];
  //  pointRegionNull.add(const Rect.fromLTRB(34.6, 490.6, 57.4, 513.4));
  // pointRegionNull.add(const Rect.fromLTRB(154.5, 492.9, 172.7, 511.1));
  // pointRegionNull.add(const Rect.fromLTRB(342.6, 492.9, 360.8, 511.1));
  // pointRegionNull.add(const Rect.fromLTRB(550.3, 492.4, 569.6, 511.6));
  // pointRegionNull.add(const Rect.fromLTRB(760.0, 482.0, 800.0, 522.0));

  //   testWidgets(
  //       'Chart Widget - Testing Bubble series Data Source with empty point as average',
  //       (WidgetTester tester) async {
  //     final _BubbleDataSource chartContainer =
  //         _bubbleDataSource('dataSource_emptyPoint_null') as _BubbleDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   // to test segment value
  //   test('test segement counts', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       expect(seriesRenderer._segments.length, 0);
  //     }
  //   });

  //   // to test series dataPoint count
  //   test('test series dataPoint', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
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
  //         expect(
  //             pointRegionNull[j].left.toInt(), dataPoints.region!.left.toInt());
  //         expect(
  //             pointRegionNull[j].top.toInt(), dataPoints.region!.top.toInt());
  //         expect(pointRegionNull[j].right.toInt(),
  //             dataPoints.region!.right.toInt());
  //         expect(pointRegionNull[j].bottom.toInt(),
  //             dataPoints.region!.bottom.toInt());
  //       }
  //     }
  //   });
  // });
}
