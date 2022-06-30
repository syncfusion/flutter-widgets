import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'fast_line_sample.dart';

/// Testing method of fast line series data source.
void fastLineDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

// chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('Fast Line - Default Properties', () {
    // Actual segmentValues value which needs to be compared with test cases
    final List<List<Offset>> segmentValues = <List<Offset>>[];
    final List<Offset> firstSegment = <Offset>[];
    final List<Offset> secondSegment = <Offset>[];
    final List<Offset> thirdSegment = <Offset>[];
    final List<Offset> fourthSegment = <Offset>[];
    firstSegment.add(const Offset(59.5, 366.7666666666667));
    firstSegment.add(const Offset(176.51372997711672, 496.5));
    secondSegment.add(const Offset(176.51372997711672, 496.5));
    secondSegment.add(const Offset(363.73569794050337, 301.9));
    thirdSegment.add(const Offset(363.73569794050337, 301.9));
    thirdSegment.add(const Offset(571.0171624713957, 269.46666666666664));
    fourthSegment.add(const Offset(571.0171624713957, 269.46666666666664));
    fourthSegment.add(const Offset(790.0, 10.0));
    segmentValues.add(firstSegment);
    segmentValues.add(secondSegment);
    segmentValues.add(thirdSegment);
    segmentValues.add(fourthSegment);

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegion = <Rect>[];
    pointRegion.add(const Rect.fromLTRB(48.0, 368.3, 56.0, 376.3));
    pointRegion.add(const Rect.fromLTRB(166.2, 500.0, 174.2, 508.0));
    pointRegion.add(const Rect.fromLTRB(358.7, 296.9, 368.7, 306.9));
    pointRegion.add(const Rect.fromLTRB(566.0, 264.5, 576.0, 274.5));
    pointRegion.add(const Rect.fromLTRB(785.0, 5.0, 795.0, 15.0));

    testWidgets('Chart Widget - Testing Fast Line series Data Source',
        (WidgetTester tester) async {
      final _FastLineDataSource chartContainer =
          _fastLineDataSource('customization_pointColor')
              as _FastLineDataSource;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // to test series dataPoint count
    // test('test series dataPoint count', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final int dataPoints = seriesRenderer._dataPoints.length;
    //       expect(dataPoints, 5);
    //     }
    //   }
    // });

    // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart.chartSeries.length; i++) {
    //     for (int j = 0; j < chart.chartSeries[i]._dataPoints.length; j++) {
    //       final _CartesianChartPoint<dynamic> dataPoints =
    //           chart.chartSeries[i]._dataPoints[j];
    //       expect(dataPoints.region.left.toInt(), pointRegion[j].left.toInt());
    //       expect(dataPoints.region.bottom.toInt(), pointRegion[j].bottom.toInt());
    //       expect(dataPoints.region.right.toInt(), pointRegion[j].right.toInt());
    //       expect(dataPoints.region.top.toInt(), pointRegion[j].top.toInt());
    //     }
    //   }
    // });
  });

  // group('Fast Line - Empty Point', () {
  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionGap = <Rect>[];
  //   pointRegionGap.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
  //   pointRegionGap.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
  //   pointRegionGap.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
  //   pointRegionGap.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
  //   pointRegionGap.add(const Rect.fromLTRB(772.0, 335.5, 788.0, 351.5));

  //   testWidgets(
  //       'Chart Widget - Testing Fast Line series Data Source with empty point as gap',
  //       (WidgetTester tester) async {
  //     final _FastLineDataSource chartContainer =
  //         _fastLineDataSource('dataSource_emptyPoint_gap')
  //             as _FastLineDataSource;
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
  //         expect(seriesRenderer._segments.length, 1);
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

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionZero = <Rect>[];
  //   pointRegionZero.add(const Rect.fromLTRB(26.0, 137.0, 42.0, 153.0));
  //   pointRegionZero.add(const Rect.fromLTRB(145.5, 494.0, 161.5, 510.0));
  //   pointRegionZero.add(const Rect.fromLTRB(336.7, 92.4, 352.7, 108.4));
  //   pointRegionZero.add(const Rect.fromLTRB(548.4, 70.1, 564.4, 86.1));
  //   pointRegionZero.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

  //   testWidgets(
  //       'Chart Widget - Testing Fast Line series Data Source with empty point as zero',
  //       (WidgetTester tester) async {
  //     final _FastLineDataSource chartContainer =
  //         _fastLineDataSource('dataSource_emptyPoint_zero')
  //             as _FastLineDataSource;
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
  //         expect(seriesRenderer._segments.length, 1);
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

  //   // Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionAvg = <Rect>[];
  //   pointRegionAvg.add(const Rect.fromLTRB(26.0, 92.4, 42.0, 108.4));
  //   pointRegionAvg.add(const Rect.fromLTRB(145.5, 67.3, 161.5, 83.3));
  //   pointRegionAvg.add(const Rect.fromLTRB(336.7, 42.2, 352.7, 58.2));
  //   pointRegionAvg.add(const Rect.fromLTRB(548.4, 17.1, 564.4, 33.1));
  //   pointRegionAvg.add(const Rect.fromLTRB(772.0, 255.6, 788.0, 271.6));

  //   testWidgets(
  //       'Chart Widget - Testing Fast Line series Data Source with empty point as average',
  //       (WidgetTester tester) async {
  //     final _FastLineDataSource chartContainer =
  //         _fastLineDataSource('dataSource_emptyPoint_avg')
  //             as _FastLineDataSource;
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
  //         expect(seriesRenderer._segments.length, 1);
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

  //   //Actual pointRegion value which needs to be compared with test cases
  //   final List<Rect> pointRegionDrop = <Rect>[];
  //   pointRegionDrop.add(const Rect.fromLTRB(50.0, 335.5, 66.0, 351.5));
  //   pointRegionDrop.add(const Rect.fromLTRB(165.7, 335.5, 181.7, 351.5));
  //   pointRegionDrop.add(const Rect.fromLTRB(350.7, 124.1, 366.7, 140.1));
  //   pointRegionDrop.add(const Rect.fromLTRB(555.6, 18.4, 571.6, 34.4));
  //   pointRegionDrop.add(const Rect.fromLTRB(772.0, 18.4, 788.0, 34.4));

  //   testWidgets(
  //       'Chart Widget - Testing Fast Line series Data Source with empty point as drop',
  //       (WidgetTester tester) async {
  //     final _FastLineDataSource chartContainer =
  //         _fastLineDataSource('dataSource_emptyPoint_drop')
  //             as _FastLineDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   //to test series dataPoint count
  //   test('test series dataPoint and segment count', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final int dataPoints = seriesRenderer._dataPoints.length;
  //         expect(dataPoints, 5);
  //         expect(seriesRenderer._segments.length, 1);
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
  //   pointRegionNull.add(const Rect.fromLTRB(38.0, 494.0, 54.0, 510.0));
  //   pointRegionNull.add(const Rect.fromLTRB(155.6, 494.0, 171.6, 510.0));
  //   pointRegionNull.add(const Rect.fromLTRB(343.7, 494.0, 359.7, 510.0));
  //   pointRegionNull.add(const Rect.fromLTRB(551.0, 494.0, 567.0, 510.0));
  //   pointRegionNull.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 510.0));

  //   testWidgets(
  //       'Chart Widget - Testing Fast Line series Data Source with empty point as average',
  //       (WidgetTester tester) async {
  //     final _FastLineDataSource chartContainer =
  //         _fastLineDataSource('dataSource_emptyPoint_null')
  //             as _FastLineDataSource;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
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

StatelessWidget _fastLineDataSource(String sampleName) {
  return _FastLineDataSource(sampleName);
}

// ignore: must_be_immutable
class _FastLineDataSource extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _FastLineDataSource(String sampleName) {
    chart = getFastLinechart(sampleName);
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
