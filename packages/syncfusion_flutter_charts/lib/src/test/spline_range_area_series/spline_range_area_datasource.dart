import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_range_area_sample.dart';

/// Testing method of spline range area series data source.
void splinerangeAreaDataSource() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

// chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('Spline Range Area Series with DataSource', () {
    // Actual segmentValues value which needs to be compared with test cases
    final List<List<Offset>> segmentValues = <List<Offset>>[];
    final List<Offset> firstSegment = <Offset>[];
    final List<Offset> secondSegment = <Offset>[];
    final List<Offset> thirdSegment = <Offset>[];
    final List<Offset> fourthSegment = <Offset>[];
    firstSegment.add(const Offset(61.5, 366.03333333333336));
    firstSegment.add(const Offset(178.19336384439362, 495.5));
    secondSegment.add(const Offset(178.19336384439362, 495.5));
    secondSegment.add(const Offset(364.9027459954233, 301.3));
    thirdSegment.add(const Offset(364.9027459954233, 301.3));
    thirdSegment.add(const Offset(571.616704805492, 268.93333333333334));
    fourthSegment.add(const Offset(571.616704805492, 268.93333333333334));
    fourthSegment.add(const Offset(790.0, 10.0));
    segmentValues.add(firstSegment);
    segmentValues.add(secondSegment);
    segmentValues.add(thirdSegment);
    segmentValues.add(fourthSegment);

    // Actual pointRegion value which needs to be compared with test cases
    final List<Rect> pointRegion = <Rect>[];
    pointRegion.add(const Rect.fromLTRB(26.0, 264.5, 42.0, 301.2));
    pointRegion.add(const Rect.fromLTRB(145.5, 178.5, 161.5, 329.9));
    pointRegion.add(const Rect.fromLTRB(336.7, 149.8, 352.7, 243.8));
    pointRegion.add(const Rect.fromLTRB(548.4, 135.4, 564.4, 229.5));
    pointRegion.add(const Rect.fromLTRB(772.0, 20.7, 788.0, 114.7));

    testWidgets('Chart Widget - Testing Spline series Data Source',
        (WidgetTester tester) async {
      final _SplineRangeAreaDataSource chartContainer =
          _splineRangeAreaDataSource('customization_pointColor')
              as _SplineRangeAreaDataSource;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // // to test series dataPoint count
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
    //       expect(pointRegion[j].left.toInt(), dataPoints.region!.left.toInt());
    //       expect(pointRegion[j].top.toInt(), dataPoints.region!.top.toInt());
    //       expect(
    //           pointRegion[j].right.toInt(), dataPoints.region!.right.toInt());
    //       expect(
    //           pointRegion[j].bottom.toInt(), dataPoints.region!.bottom.toInt());
    //     }
    //   }
    // });
  });

//   group('SplineRangeArea Series - Empty points', () {
//     final List<List<Offset>> segmentGaps = <List<Offset>>[];
//     final List<Offset> firstSegmentGap = <Offset>[];
//     firstSegmentGap.add(const Offset(380.0743707093821, 171.83333333333334));
//     firstSegmentGap.add(const Offset(579.4107551487414, 10.0));
//     segmentGaps.add(firstSegmentGap);

//     // Actual pointRegion value which needs to be compared with test cases
//     final List<Rect> pointRegionGap = <Rect>[];
//     pointRegionGap.add(const Rect.fromLTRB(26.0, 264.5, 42.0, 301.2));
//     pointRegionGap.add(const Rect.fromLTRB(145.5, 178.5, 161.5, 301.2));
//     pointRegionGap.add(const Rect.fromLTRB(336.7, 149.8, 352.7, 243.8));
//     pointRegionGap.add(const Rect.fromLTRB(548.4, 135.4, 564.4, 229.5));
//     pointRegionGap.add(const Rect.fromLTRB(772.0, 20.7, 788.0, 229.5));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as gap',
//         (WidgetTester tester) async {
//       final _SplineRangeAreaDataSource chartContainer =
//           _splineRangeAreaDataSource('dataSource_emptyPoint_gap')
//               as _SplineRangeAreaDataSource;
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
//     pointRegionZero.add(const Rect.fromLTRB(26.0, 201.9, 42.0, 246.4));
//     pointRegionZero.add(const Rect.fromLTRB(145.5, 494.0, 161.5, 502.0));
//     pointRegionZero.add(const Rect.fromLTRB(336.7, 55.9, 352.7, 173.4));
//     pointRegionZero.add(const Rect.fromLTRB(548.4, 37.6, 564.4, 155.2));
//     pointRegionZero.add(const Rect.fromLTRB(772.0, 494.0, 788.0, 502.0));

// // Line series with
//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as zero',
//         (WidgetTester tester) async {
//       final _SplineRangeAreaDataSource chartContainer =
//           _splineRangeAreaDataSource('dataSource_emptyPoint_zero')
//               as _SplineRangeAreaDataSource;
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
//     pointRegionAvg.add(const Rect.fromLTRB(26.0, 279.8, 42.0, 314.6));
//     pointRegionAvg.add(const Rect.fromLTRB(145.5, 199.5, 161.5, 287));
//     pointRegionAvg.add(const Rect.fromLTRB(336.7, 172.7, 352.7, 261.0));
//     pointRegionAvg.add(const Rect.fromLTRB(548.4, 159.3, 564.4, 247.7));
//     pointRegionAvg.add(const Rect.fromLTRB(772.0, 52.2, 788.0, 374.8));

//     testWidgets(
//         'Chart Widget - Testing SplineRange area series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _SplineRangeAreaDataSource chartContainer =
//           _splineRangeAreaDataSource('dataSource_emptyPoint_avg')
//               as _SplineRangeAreaDataSource;
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
//     pointRegionDrop.add(const Rect.fromLTRB(26.0, 264.5, 42.0, 301.2));
//     pointRegionDrop.add(const Rect.fromLTRB(145.5, 178.0, 161.5, 301.2));
//     pointRegionDrop.add(const Rect.fromLTRB(336.7, 149.8, 352.7, 243.8));
//     pointRegionDrop.add(const Rect.fromLTRB(548.4, 135.4, 564.4, 229.5));
//     pointRegionDrop.add(const Rect.fromLTRB(772.0, 20.7, 788.0, 229.5));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as drop',
//         (WidgetTester tester) async {
//       final _SplineRangeAreaDataSource chartContainer =
//           _splineRangeAreaDataSource('dataSource_emptyPoint_drop')
//               as _SplineRangeAreaDataSource;
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
//     pointRegionNull.add(const Rect.fromLTRB(26.0, 306.6, 42.0, 502.0));
//     pointRegionNull.add(const Rect.fromLTRB(145.5, 199.5, 161.5, 502.0));
//     pointRegionNull.add(const Rect.fromLTRB(336.7, 172.72, 352.7, 502.0));
//     pointRegionNull.add(const Rect.fromLTRB(548.4, 159.3, 564.4, 502.0));
//     pointRegionNull.add(const Rect.fromLTRB(772.0, 52.3, 788.0, 502.0));

//     testWidgets(
//         'Chart Widget - Testing Line series Data Source with empty point as average',
//         (WidgetTester tester) async {
//       final _SplineRangeAreaDataSource chartContainer =
//           _splineRangeAreaDataSource('dataSource_emptyPoint_null')
//               as _SplineRangeAreaDataSource;
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
}

StatelessWidget _splineRangeAreaDataSource(String sampleName) {
  return _SplineRangeAreaDataSource(sampleName);
}

// ignore: must_be_immutable
class _SplineRangeAreaDataSource extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineRangeAreaDataSource(String sampleName) {
    chart = getSplineRangeAreachart(sampleName);
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
