import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_column_sample.dart';

/// Testing method for customization of the stacked column series.
void stackedColumnCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  // List<ChartDataValues> _getPointsValues(
  //     List<dynamic> trackerRegion, List<dynamic> trackerRegion1) {
  //   final List<ChartDataValues> _stackedColumnPoints = <ChartDataValues>[];
  //   _stackedColumnPoints.add(ChartDataValues(trackerRegion));
  //   _stackedColumnPoints.add(ChartDataValues(trackerRegion1));

  //   return _stackedColumnPoints;
  // }

  group('Stacked Column - Fill, Point Color Mapping', () {
    // Column series
    testWidgets('Chart Widget - Testing Column series with default colors',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('customization_default')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 2);
    });

    // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0x00000000));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // final List<_ChartColorDataValues> _chartColorDataValues =
    //     _getColorValues(const Color(0xff4b87b9), const Color(0xffc06c84));

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(_chartColorDataValues[i].rectValues, strokeColor);
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

//     // to test tracker segment fill paint
//     test('test tracker segment fill paint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           if (cartesianSeriesRenderer._segments[j] is ColumnSegment) {
//             final ColumnSegment segment =
//                 cartesianSeriesRenderer._segments[j] as ColumnSegment;
//             final Color strokeColor = segment._getTrackerFillPaint().color;
//             final double strokeWidth =
//                 segment._getTrackerFillPaint().strokeWidth;
//             expect(strokeColor, const Color(0xff9e9e9e));
//             expect(strokeWidth, 0);
//           }
//         }
//       }
//     });

// // to test tracker segment stroke paint
//     test('test tracker segment stroke paint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           if (cartesianSeriesRenderer._segments[j] is ColumnSegment) {
//             final ColumnSegment segment =
//                 cartesianSeriesRenderer._segments[j] as ColumnSegment;
//             final Color strokeColor = segment._getTrackerStrokePaint().color;
//             final double strokeWidth =
//                 segment._getTrackerStrokePaint().strokeWidth;
//             expect(strokeColor, const Color(0x00000000));
//             expect(strokeWidth.toInt(), 1);
//           }
//         }
//       }
//     });

    // Column series
    // testWidgets(
    //     'Chart Widget - Testing Column series with Fill and PointColorMapping',
    //     (WidgetTester tester) async {
    //   final _StackedColumnCustomization chartContainer =
    //       _stackedColumnCustomization('customization_fill_pointcolor')
    //           as _StackedColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0x00000000));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

// Column series
    // testWidgets('Chart Widget - Testing Column series with Fill',
    //     (WidgetTester tester) async {
    //   final _StackedColumnCustomization chartContainer =
    //       _stackedColumnCustomization('customization_fill')
    //           as _StackedColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0x00000000));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(strokeColor, const Color(0xff2196f3));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // Column series
    // testWidgets(
    //     'Chart Widget - Testing Column Series with Point Color Mapping ',
    //     (WidgetTester tester) async {
    //   final _StackedColumnCustomization chartContainer =
    //       _stackedColumnCustomization('customization_pointColor')
    //           as _StackedColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       expect(strokeColor, const Color(0x00000000));
    //     }
    //   }
    // });

    // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 1) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 2) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 3) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });

    // testWidgets('Testing Column Series with selction in intial rendering',
    //     (WidgetTester tester) async {
    //   final _StackedColumnCustomization chartContainer =
    //       _stackedColumnCustomization('customization_selection_initial_render')
    //           as _StackedColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 1) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 2) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 3) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });

    // final List<Rect> trackerRegion = <Rect>[];
    // trackerRegion.add(const Rect.fromLTRB(55.8, 0.0, 143.8, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(161.9, 0.0, 250.7, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(268.7, 0.0, 357.5, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(435.4, 0.0, 524.2, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(575.3, 0.0, 664.1, 502.0));
    // final List<Rect> trackerRegion1 = <Rect>[];
    // trackerRegion1.add(const Rect.fromLTRB(161.9, 0.0, 250.7, 502.0));
    // trackerRegion1.add(const Rect.fromLTRB(268.7, 0.0, 357.5, 502.0));
    // trackerRegion1.add(const Rect.fromLTRB(375.6, 0.0, 464.3, 502.0));
    // trackerRegion1.add(const Rect.fromLTRB(542.2, 0.0, 631.0, 502.0));
    // trackerRegion1.add(const Rect.fromLTRB(682.2, 0.0, 770.0, 502.0));

    // final List<ChartDataValues> _stackedColumnPoints =
    //     _getPointsValues(trackerRegion, trackerRegion1);

    // // Column series
    // testWidgets('Chart Widget - Testing Column Series with Tracker',
    //     (WidgetTester tester) async {
    //   final _StackedColumnCustomization chartContainer =
    //       _stackedColumnCustomization('customization_tracker')
    //           as _StackedColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test tracker segment fill paint
    // test('test tracker segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       if (cartesianSeriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as ColumnSegment;
    //         final Color strokeColor = segment._getTrackerFillPaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerFillPaint().strokeWidth;
    //         expect(strokeColor, const Color(0xff9e9e9e));
    //         expect(strokeWidth, 0);
    //       }
    //     }
    //   }
    // });

    // test('test tracker segement region', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Rect trackPoint =
    //           cartesianSeriesRenderer._dataPoints[j].trackerRectRegion!;
    //       expect(_stackedColumnPoints[i].rectValues[j].left.toInt(),
    //           trackPoint.left.toInt());
    //       expect(_stackedColumnPoints[i].rectValues[j].top.toInt(),
    //           trackPoint.top.toInt());
    //       expect(_stackedColumnPoints[i].rectValues[j].right.toInt(),
    //           trackPoint.right.toInt());
    //       expect(_stackedColumnPoints[i].rectValues[j].bottom.toInt(),
    //           trackPoint.bottom.toInt());
    //     }
    //   }
    // });

// to test tracker segment stroke paint
    // test('test tracker segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       if (cartesianSeriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as ColumnSegment;
    //         final Color strokeColor = segment._getTrackerStrokePaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerStrokePaint().strokeWidth;
    //         expect(strokeColor, const Color(0xfff44336));
    //         expect(strokeWidth.toInt(), 2);
    //       }
    //     }
    //   }
    // });

    testWidgets('Testing column series with track without border',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('customization_track_without_border')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test bar series track withour border', () {
      final StackedColumnSeries<dynamic, dynamic> series =
          chart!.series[0] as StackedColumnSeries<dynamic, dynamic>;
      expect(series.trackBorderWidth, 0);
    });

    // test('test by clearing the segments', () {
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   expect(cartesianSeriesRenderer._segments.length, 5);
    // });
  });

  // group('Column - Corner Radius', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Column Series with Corner Radius',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('customization_cornerradius')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   final List<RRect> trackerRect = <RRect>[];
  //   final List<RRect> trackerRect1 = <RRect>[];

  //   trackerRect.add(
  //       RRect.fromLTRBR(161.9, 0.0, 250.7, 502.0, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(268.7, 0.0, 357.5, 502.0, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(375.6, 0.0, 464.3, 502.0, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(542.2, 0.0, 631.0, 502.0, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(682.2, 0.0, 770.0, 502.0, const Radius.circular(5)));

  //   trackerRect1.add(
  //       RRect.fromLTRBR(55.0, 0.0, 143.8, 502.0, const Radius.circular(5)));
  //   trackerRect1.add(
  //       RRect.fromLTRBR(161.9, 0.0, 250.7, 502.0, const Radius.circular(5)));
  //   trackerRect1.add(
  //       RRect.fromLTRBR(268.7, 0.0, 357.5, 502.0, const Radius.circular(5)));
  //   trackerRect1.add(
  //       RRect.fromLTRBR(435.4, 0.0, 524.2, 502.0, const Radius.circular(5)));
  //   trackerRect1.add(
  //       RRect.fromLTRBR(575.3, 0.0, 664.1, 502.0, const Radius.circular(5)));

  //   final List<ChartDataValues> _stackedColumnPoints1 =
  //       _getPointsValues(trackerRect1, trackerRect);

  //   test('test tracker rounded corners', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer cartesianSeriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
  //         final StackedColumnSegment segment =
  //             cartesianSeriesRenderer._segments[j] as StackedColumnSegment;
  //         final RRect trackPoint = segment._trackRect;
  //         expect(_stackedColumnPoints1[i].rectValues[j].left.toInt(),
  //             trackPoint.left.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].top.toInt(),
  //             trackPoint.top.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].right.toInt(),
  //             trackPoint.right.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].bottom.toInt(),
  //             trackPoint.bottom.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].blRadius.x.toInt(),
  //             trackPoint.blRadius.x.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].blRadius.y.toInt(),
  //             trackPoint.blRadius.y.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].brRadius.x.toInt(),
  //             trackPoint.brRadius.x.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].brRadius.y.toInt(),
  //             trackPoint.brRadius.y.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].tlRadius.x.toInt(),
  //             trackPoint.tlRadius.x.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].tlRadius.y.toInt(),
  //             trackPoint.tlRadius.y.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].trRadius.x.toInt(),
  //             trackPoint.trRadius.x.toInt());
  //         expect(_stackedColumnPoints1[i].rectValues[j].trRadius.y.toInt(),
  //             trackPoint.trRadius.y.toInt());
  //       }
  //     }
  //   });

  //   final List<RRect> pointRect = <RRect>[];
  //   final List<RRect> pointRect1 = <RRect>[];

  //   pointRect.add(
  //       RRect.fromLTRBR(62.0, 355.0, 136.8, 502.0, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(168.9, 392.5, 243.7, 502.0, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(275.7, 337.7, 350.5, 502.0, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(442.4, 328.6, 517.2, 502.0, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(582.3, 255.6, 657.1, 502.0, const Radius.circular(5)));

  //   pointRect1.add(
  //       RRect.fromLTRBR(168.9, 164.3, 243.7, 355.0, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(275.7, 237.3, 350.5, 392.5, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(382.6, 127.8, 457.3, 337.7, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(549.2, 63.9, 624.0, 328.6, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(689.2, 100.4, 763.0, 255.6, const Radius.circular(5)));

  //   final List<ChartDataValues> _stackedColumnPoints2 =
  //       _getPointsValues(pointRect, pointRect1);

  //   test('test column rounded corners', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer cartesianSeriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
  //         final StackedColumnSegment segment =
  //             cartesianSeriesRenderer._segments[j] as StackedColumnSegment;
  //         final RRect columnRect = segment.segmentRect;
  //         expect(_stackedColumnPoints2[i].rectValues[j].left.toInt(),
  //             columnRect.left.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].top.toInt(),
  //             columnRect.top.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].right.toInt(),
  //             columnRect.right.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].bottom.toInt(),
  //             columnRect.bottom.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].blRadius.x.toInt(),
  //             columnRect.blRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].blRadius.y.toInt(),
  //             columnRect.blRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].brRadius.x.toInt(),
  //             columnRect.brRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].brRadius.y.toInt(),
  //             columnRect.brRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.x.toInt(),
  //             columnRect.tlRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.y.toInt(),
  //             columnRect.tlRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].trRadius.x.toInt(),
  //             columnRect.trRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].trRadius.y.toInt(),
  //             columnRect.trRadius.y.toInt());
  //       }
  //     }
  //   });
  // });

  // group('Column - Gradient Colors', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Column Series with Gradient Colors',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('customization_gradientColor')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('test segment fill paint', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer cartesianSeriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
  //         final Color strokeColor =
  //             cartesianSeriesRenderer._segments[j].getFillPaint().color;
  //         expect(strokeColor, const Color(0xff000000));
  //       }
  //     }
  //   });
  // });
  // group('Column - Sorting', () {
  //   testWidgets(
  //       'Chart Widget - Testing Column Series - Sorting X Axis Descending',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('sortingX')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '2');
  //   });

  //   testWidgets(
  //       'Chart Widget - Testing Column Series Sorting - X Axis Ascending',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('sortingX_Ascending')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '2');
  //   });

  //   testWidgets('Chart Widget - Testing Column Series Sorting Y Axis Ascending',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('sortingY_Ascending')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '2');
  //   });

  //   testWidgets(
  //       'Chart Widget - Testing Column Series Sorting Y Axis Descendins',
  //       (WidgetTester tester) async {
  //     final _StackedColumnCustomization chartContainer =
  //         _stackedColumnCustomization('sortingY_Descending')
  //             as _StackedColumnCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '2');
  //   });
  // });

  group('Column Series Animation -', () {
    testWidgets('Column series animation with normal position',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Column series animation with transpose',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_transpose')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1400);
    });

    testWidgets('Column series animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_transpose_inverse')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets(
        'Column series animation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_transpose_inverse_negative')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets('Column series animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_inverse_negative')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Column series animation with y inversed',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_inverse')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
      expect(chart!.series[1].animationDuration, 1350);
    });

    testWidgets('Column series animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_transpose_negative')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Column series animation with negative y values',
        (WidgetTester tester) async {
      final _StackedColumnCustomization chartContainer =
          _stackedColumnCustomization('animation_negative')
              as _StackedColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });
  });
}

StatelessWidget _stackedColumnCustomization(String sampleName) {
  return _StackedColumnCustomization(sampleName);
}

// class _StackedColumnPoints {
//   _StackedColumnPoints(this.rectValues);
//    List<dynamic> rectValues ;
// }

// ignore: must_be_immutable
class _StackedColumnCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedColumnCustomization(String sampleName) {
    chart = getStackedColumnSeries(sampleName);
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
