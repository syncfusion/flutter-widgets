import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_area_sample.dart';

/// Testing method of stacked area series data source.
void stackedAreaDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called

  group('StackedArea - Empty Point', () {
    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegionGap = <Rect>[];
    pointRegionGap.add(const Rect.fromLTRB(38.0, 347.0, 54.0, 363.0));
    pointRegionGap.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
    pointRegionGap.add(const Rect.fromLTRB(359.9, 329.7, 375.9, 345.7));
    pointRegionGap.add(const Rect.fromLTRB(520.9, 329.7, 536.9, 345.7));

    final List<Rect> pointRegionGap1 = <Rect>[];
    pointRegionGap1.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
    pointRegionGap1.add(const Rect.fromLTRB(359.9, 192.8, 375.9, 208.8));
    pointRegionGap1.add(const Rect.fromLTRB(520.9, 174.5, 536.9, 190.5));
    pointRegionGap1.add(const Rect.fromLTRB(772.0, 65.0, 788.0, 81.0));

    testWidgets(
        'Chart Widget - Testing Stacked Area series Data Source with empty point as gap',
        (WidgetTester tester) async {
      final _StackedAreaDataSource chartContainer =
          _stackedAreaDataSource('emptyPoint_gap') as _StackedAreaDataSource;
      await tester.pumpWidget(chartContainer);
    });

    // // to test series dataPoint count
    // test('test series dataPoint and segment count', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 4);
    //       expect(cartesianSeriesRenderer._segments.length, 1);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
    //       final CartesianChartPoint<dynamic>? dataPoints =
    //           cartesianSeriesRenderer._dataPoints[j];
    //       if (i == 0) {
    //         expect(pointRegionGap[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionGap[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionGap[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionGap[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       } else {
    //         expect(pointRegionGap1[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionGap1[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionGap1[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionGap1[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       }
    //     }
    //   }
    // });

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegionZero = <Rect>[];
    pointRegionZero.add(const Rect.fromLTRB(26.0, 246.9, 42.0, 262.9));
    pointRegionZero.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
    pointRegionZero.add(const Rect.fromLTRB(353.2, 215.0, 369.2, 231.0));
    pointRegionZero.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));

    final List<Rect> pointRegionZero1 = <Rect>[];
    pointRegionZero1.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
    pointRegionZero1.add(const Rect.fromLTRB(353.2, 231.4, 369.2, 247.4));
    pointRegionZero1.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));
    pointRegionZero1.add(const Rect.fromLTRB(772.0, 46.1, 788.0, 62.1));

    // Line series with
    testWidgets(
        'Chart Widget - Testing Stacked Area series Data Source with empty point as zero',
        (WidgetTester tester) async {
      final _StackedAreaDataSource chartContainer =
          _stackedAreaDataSource('emptyPoint_zero') as _StackedAreaDataSource;
      await tester.pumpWidget(chartContainer);
    });

    // // to test series dataPoint count
    // test('test series dataPoint and segment count', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 4);
    //       expect(cartesianSeriesRenderer._segments.length, 1);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer? cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 3;
    //         j < 4 /*cartesianSeriesRenderer._dataPoints.length*/;
    //         j++) {
    //       final CartesianChartPoint<dynamic>? dataPoints =
    //           cartesianSeriesRenderer!._dataPoints[j];
    //       if (i == 0) {
    //         expect(pointRegionZero[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionZero[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionZero[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionZero[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       } else {
    //         expect(pointRegionZero1[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(pointRegionZero1[j].top.toInt(),
    //             dataPoints.region!.top.toInt());
    //         expect(pointRegionZero1[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionZero1[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       }
    //     }
    //   }
    // });

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegionAvg = <Rect>[];
    pointRegionAvg.add(const Rect.fromLTRB(26.0, 315.5, 42.0, 331.5));
    pointRegionAvg.add(const Rect.fromLTRB(189.6, 304.4, 205.6, 320.4));
    pointRegionAvg.add(const Rect.fromLTRB(353.2, 293.2, 369.2, 309.2));
    pointRegionAvg.add(const Rect.fromLTRB(516.8, 393.6, 532.8, 409.6));

    final List<Rect> pointRegionAvg1 = <Rect>[];
    pointRegionAvg1.add(const Rect.fromLTRB(189.6, 220.0, 205.6, 236.0));
    pointRegionAvg1.add(const Rect.fromLTRB(353.2, 114.7, 369.2, 130.7));
    pointRegionAvg1.add(const Rect.fromLTRB(516.8, 36.6, 532.8, 52.6));
    pointRegionAvg1.add(const Rect.fromLTRB(772.0, 70.1, 788.0, 86.1));

    testWidgets(
        'Chart Widget - Testing Stacked Area series Data Source with empty point as average',
        (WidgetTester tester) async {
      final _StackedAreaDataSource chartContainer =
          _stackedAreaDataSource('emptyPoint_avg') as _StackedAreaDataSource;
      await tester.pumpWidget(chartContainer);
    });

    // to test series dataPoint count
    // test('test series dataPoint and segment count', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 4);
    //       expect(cartesianSeriesRenderer._segments.length, 1);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
    //       final CartesianChartPoint<dynamic>? dataPoints =
    //           cartesianSeriesRenderer._dataPoints[j];
    //       if (i == 0) {
    //         expect(pointRegionAvg[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionAvg[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionAvg[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionAvg[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       } else {
    //         expect(pointRegionAvg1[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionAvg1[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionAvg1[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionAvg1[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       }
    //     }
    //   }
    // });

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegionDrop = <Rect>[];
    pointRegionDrop.add(const Rect.fromLTRB(38.0, 347.0, 54.0, 363.0));
    pointRegionDrop.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
    pointRegionDrop.add(const Rect.fromLTRB(359.9, 329.7, 375.9, 345.7));
    pointRegionDrop.add(const Rect.fromLTRB(520.9, 329.7, 536.9, 345.7));

    final List<Rect> pointRegionDrop1 = <Rect>[];
    pointRegionDrop1.add(const Rect.fromLTRB(198.0, 347.0, 214.0, 363.0));
    pointRegionDrop1.add(const Rect.fromLTRB(359.9, 192.8, 375.9, 208.8));
    pointRegionDrop1.add(const Rect.fromLTRB(520.9, 174.5, 536.9, 190.5));
    pointRegionDrop1.add(const Rect.fromLTRB(772.0, 65.0, 788.0, 81.0));

    // testWidgets(
    //     'Chart Widget - Testing Stacked Area series Data Source with empty point as drop',
    //     (WidgetTester tester) async {
    //   final _StackedAreaDataSource chartContainer =
    //       _stackedAreaDataSource('emptyPoint_drop') as _StackedAreaDataSource;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test series dataPoint count
    // test('test series dataPoint and segment count', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 4);
    //       expect(cartesianSeriesRenderer._segments.length, 1);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._dataPoints.length; j++) {
    //       final CartesianChartPoint<dynamic>? dataPoints =
    //           cartesianSeriesRenderer._dataPoints[j];
    //       if (i == 0) {
    //         expect(pointRegionDrop[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionDrop[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionDrop[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionDrop[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       } else {
    //         expect(pointRegionDrop1[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(pointRegionDrop1[j].top.toInt(),
    //             dataPoints.region!.top.toInt());
    //         expect(pointRegionDrop1[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionDrop1[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       }
    //     }
    //   }
    //  });

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegionNull = <Rect>[];
    pointRegionNull.add(const Rect.fromLTRB(26.0, 494.0, 42.0, 510.0));
    pointRegionNull.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
    pointRegionNull.add(const Rect.fromLTRB(353.2, 494.0, 369.2, 510.0));
    pointRegionNull.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));

    final List<Rect> pointRegionNull1 = <Rect>[];
    pointRegionNull1.add(const Rect.fromLTRB(189.6, 494.0, 205.6, 510.0));
    pointRegionNull1.add(const Rect.fromLTRB(353.2, 231.4, 369.2, 247.4));
    pointRegionNull1.add(const Rect.fromLTRB(353.2, 494.0, 369.2, 510.0));
    pointRegionNull1.add(const Rect.fromLTRB(516.8, 494.0, 532.8, 510.0));

    testWidgets(
        'Chart Widget - Testing Stacked Area series Data Source with empty point as null',
        (WidgetTester tester) async {
      final _StackedAreaDataSource chartContainer =
          _stackedAreaDataSource('null') as _StackedAreaDataSource;
      await tester.pumpWidget(chartContainer);
    });

    // // to test segment value
    // test('test segement counts', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     expect(cartesianSeriesRenderer._segments.length, 1);
    //   }
    // });

    // // to test series dataPoint count
    // test('test series dataPoint', () {
    //   for (int i = 1; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final int dataPoints = cartesianSeriesRenderer._dataPoints.length;
    //       expect(dataPoints, 4);
    //     }
    //   }
    // });

    // // to test dataPoint regions
    // test('test datapoint regions', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer? cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 1;
    //         j < 2 /*cartesianSeriesRenderer._dataPoints.length*/;
    //         j++) {
    //       final CartesianChartPoint<dynamic>? dataPoints =
    //           cartesianSeriesRenderer!._dataPoints[j];
    //       if (i == 0) {
    //         expect(pointRegionNull[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(
    //             pointRegionNull[j].top.toInt(), dataPoints.region!.top.toInt());
    //         expect(pointRegionNull[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionNull[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       } else {
    //         expect(pointRegionNull1[j].left.toInt(),
    //             dataPoints!.region!.left.toInt());
    //         expect(pointRegionNull1[j].top.toInt(),
    //             dataPoints.region!.top.toInt());
    //         expect(pointRegionNull1[j].right.toInt(),
    //             dataPoints.region!.right.toInt());
    //         expect(pointRegionNull1[j].bottom.toInt(),
    //             dataPoints.region!.bottom.toInt());
    //       }
    //     }
    //   }
    // });
  });
}

StatelessWidget _stackedAreaDataSource(String sampleName) {
  return _StackedAreaDataSource(sampleName);
}

// ignore: must_be_immutable
class _StackedAreaDataSource extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedAreaDataSource(String sampleName) {
    chart = getStackedAreaChart(sampleName);
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
