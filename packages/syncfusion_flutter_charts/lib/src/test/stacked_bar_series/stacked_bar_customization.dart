import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_bar_sample.dart';

/// Testing method for customization of the stacked bar series.
void stackedBarCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacked Bar - Fill, Point Color Mapping', () {
    // Column series
    testWidgets('Chart Widget - Testing stack bar series with default colors',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('customization_default')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 2);
    });

    // to test segment stroke paint
//     test('test segment stroke paint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final Color strokeColor =
//               cartesianSeriesRenderer._segments[j].getStrokePaint().color;
//           final double strokeWidth =
//               cartesianSeriesRenderer._segments[j].getStrokePaint().strokeWidth;
//           expect(strokeColor, const Color(0x00000000));
//           expect(strokeWidth, 0);
//         }
//       }
//     });

//     final List<_ChartColorDataValues> _chartColorDataValues =
//         _getColorValues(const Color(0xff4b87b9), const Color(0xffc06c84));
//     // to test segment fill paint
//     test('test segment fill paint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final Color strokeColor =
//               cartesianSeriesRenderer._segments[j].getFillPaint().color;
//           final double strokeWidth =
//               cartesianSeriesRenderer._segments[j].getFillPaint().strokeWidth;
//           expect(_chartColorDataValues[i].rectValues, strokeColor);
//           expect(strokeWidth, 0);
//         }
//       }
//     });

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
    //     'Chart Widget - Testing stacked bar series with Fill and PointColorMapping',
    //     (WidgetTester tester) async {
    //   final _StackedBarCustomization chartContainer =
    //       _stackedBarCustomization('customization_fill_pointcolor')
    //           as _StackedBarCustomization;
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
    // testWidgets('Chart Widget - Testing stacked bar with Fill',
    //     (WidgetTester tester) async {
    //   final _StackedBarCustomization chartContainer =
    //       _stackedBarCustomization('customization_fill')
    //           as _StackedBarCustomization;
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
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 3.0);
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
//     testWidgets('Chart Widget - Testing Stacked bar with Point Color Mapping ',
//         (WidgetTester tester) async {
//       final _StackedBarCustomization chartContainer =
//           _stackedBarCustomization('customization_pointColor')
//               as _StackedBarCustomization;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('test segment stroke paint', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final Color strokeColor =
//               cartesianSeriesRenderer._segments[j].getStrokePaint().color;
//           expect(strokeColor, const Color(0x00000000));
//         }
//       }
//     });

//     final List<Rect> trackerRegion = <Rect>[];
//     trackerRegion.add(const Rect.fromLTRB(46.0, 432.9, 780.0, 498.0));
//     trackerRegion.add(const Rect.fromLTRB(46.0, 359.8, 780.0, 424.0));
//     trackerRegion.add(const Rect.fromLTRB(46.0, 286.7, 780.0, 351.9));
//     trackerRegion.add(const Rect.fromLTRB(46.0, 172.8, 780.0, 237.9));
//     trackerRegion.add(const Rect.fromLTRB(46.0, 77.0, 780.0, 142.2));
//     final List<Rect> trackerRegion1 = <Rect>[];
//     trackerRegion1.add(const Rect.fromLTRB(46.0, 359.8, 780.0, 424.0));
//     trackerRegion1.add(const Rect.fromLTRB(46.0, 286.7, 780.0, 351.9));
//     trackerRegion1.add(const Rect.fromLTRB(46.0, 213.7, 780.0, 278.8));
//     trackerRegion1.add(const Rect.fromLTRB(46.0, 99.7, 780.0, 164.8));
//     trackerRegion1.add(const Rect.fromLTRB(46.0, 3.0, 780.0, 69.1));

//     final List<_ChartDataValues> _stackedColumnPoints =
//         _getPointsValues(trackerRegion, trackerRegion1);

//     // Column series
//     testWidgets('Chart Widget - Testing Stacked Bar with Tracker',
//         (WidgetTester tester) async {
//       final _StackedBarCustomization chartContainer =
//           _stackedBarCustomization('customization_tracker')
//               as _StackedBarCustomization;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

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

//     test('test tracker segement region', () {
//       for (int i = 0; i < chart!.series.length; i++) {
//         final CartesianSeriesRenderer cartesianSeriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
//           final Rect trackPoint =
//               cartesianSeriesRenderer._dataPoints[j].trackerRectRegion!;
//           expect(_stackedColumnPoints[i].rectValues[j].left.toInt(),
//               trackPoint.left.toInt());
//           expect(_stackedColumnPoints[i].rectValues[j].top.toInt(),
//               trackPoint.top.toInt());
//           expect(_stackedColumnPoints[i].rectValues[j].right.toInt(),
//               trackPoint.right.toInt());
//           expect(_stackedColumnPoints[i].rectValues[j].bottom.toInt(),
//               trackPoint.bottom.toInt());
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
//             expect(strokeColor, const Color(0xfff44336));
//             expect(strokeWidth.toInt(), 2);
//           }
//         }
//       }
//     });

    testWidgets('Testing stacked bar with track without border',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('customization_track_without_border')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test bar series track withour border', () {
      final StackedBarSeries<dynamic, dynamic> series =
          chart!.series[0] as StackedBarSeries<dynamic, dynamic>;
      expect(series.trackBorderWidth, 0);
    });

    // test('test by clearing the segments', () {
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   expect(cartesianSeriesRenderer._segments.length, 5);
    // });
  });

  // testWidgets(
  //     'Chart Widget - Testing stacked bar series with point color mapping',
  //     (WidgetTester tester) async {
  //   final _StackedBarMarker chartContainer =
  //       _stackedBarMarker('marker_PointColormapping') as _StackedBarMarker;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test point color mapping properties', () {
  //   final List<CartesianSeriesRenderer?> cartesianSeriesRenderers =
  //       _chartState!._chartSeries.visibleSeriesRenderers;
  //   cartesianSeriesRenderers[0]!
  //       ._regionalData!
  //       .forEach((dynamic k, dynamic v) => expect(k[2], Colors.blue));
  //   cartesianSeriesRenderers[1]!
  //       ._regionalData!
  //       .forEach((dynamic k, dynamic v) => expect(k[2], Colors.red));
  // });

  group('Stacked Bar - Corner Radius', () {
    // Column series
    testWidgets('Chart Widget - Testing Column Series with Corner Radius',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('customization_cornerradius')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    final List<RRect> trackerRect = <RRect>[];
    final List<RRect> trackerRect1 = <RRect>[];

    trackerRect.add(
        RRect.fromLTRBR(46.0, 359.8, 780.0, 424.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(46.0, 286.7, 780.0, 351.9, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(46.0, 213.7, 780.0, 278.8, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(46.0, 99.7, 780.0, 164.8, const Radius.circular(5)));
    trackerRect
        .add(RRect.fromLTRBR(46.0, 3.0, 780.0, 69.1, const Radius.circular(5)));

    trackerRect1.add(
        RRect.fromLTRBR(46.0, 432.9, 780.0, 498.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(46.0, 359.8, 780.0, 424.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(46.0, 286.7, 780.0, 351.9, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(46.0, 172.8, 780.0, 237.9, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(46.0, 77.0, 780.0, 142.2, const Radius.circular(5)));

    // final List<ChartDataValues> _stackedColumnPoints1 =
    //     getPointsValues(trackerRect1, trackerRect);

    // test('test tracker rounded corners', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final StackedBarSegment segment =
    //           cartesianSeriesRenderer._segments[j] as StackedBarSegment;
    //       final RRect trackPoint = segment._trackRect;
    //       expect(_stackedColumnPoints1[i].rectValues[j].left.toInt(),
    //           trackPoint.left.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].top.toInt(),
    //           trackPoint.top.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].right.toInt(),
    //           trackPoint.right.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].bottom.toInt(),
    //           trackPoint.bottom.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].blRadius.x.toInt(),
    //           trackPoint.blRadius.x.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].blRadius.y.toInt(),
    //           trackPoint.blRadius.y.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].brRadius.x.toInt(),
    //           trackPoint.brRadius.x.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].brRadius.y.toInt(),
    //           trackPoint.brRadius.y.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].tlRadius.x.toInt(),
    //           trackPoint.tlRadius.x.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].tlRadius.y.toInt(),
    //           trackPoint.tlRadius.y.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].trRadius.x.toInt(),
    //           trackPoint.trRadius.x.toInt());
    //       expect(_stackedColumnPoints1[i].rectValues[j].trRadius.y.toInt(),
    //           trackPoint.trRadius.y.toInt());
    //     }
    //   }
    // });

    final List<RRect> pointRect = <RRect>[];
    final List<RRect> pointRect1 = <RRect>[];

    pointRect.add(
        RRect.fromLTRBR(46.0, 439.9, 259.5, 491.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(46.0, 366.8, 206.1, 417.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(46.0, 293.7, 286.2, 344.9, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(46.0, 179.8, 299.6, 230.9, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(46.0, 84.0, 406.3, 135.2, const Radius.circular(5)));

    pointRect1.add(
        RRect.fromLTRBR(259.5, 366.8, 539.8, 417.0, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(206.1, 293.7, 433.0, 344.9, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(286.2, 220.7, 593.2, 271.8, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(299.6, 106.7, 686.6, 157.8, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(406.3, 10.0, 633.2, 62.1, const Radius.circular(5)));

    // final List<_ChartDataValues> _stackedColumnPoints2 =
    //     _getPointsValues(pointRect, pointRect1);

    // test('test column rounded corners', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final StackedBarSegment segment =
    //           cartesianSeriesRenderer._segments[j] as StackedBarSegment;
    //       final RRect columnRect = segment.segmentRect;
    //       expect(_stackedColumnPoints2[i].rectValues[j].left.toInt(),
    //           columnRect.left.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].top.toInt(),
    //           columnRect.top.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].right.toInt(),
    //           columnRect.right.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].bottom.toInt(),
    //           columnRect.bottom.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].blRadius.x.toInt(),
    //           columnRect.blRadius.x.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].blRadius.y.toInt(),
    //           columnRect.blRadius.y.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].brRadius.x.toInt(),
    //           columnRect.brRadius.x.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].brRadius.y.toInt(),
    //           columnRect.brRadius.y.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.x.toInt(),
    //           columnRect.tlRadius.x.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.y.toInt(),
    //           columnRect.tlRadius.y.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].trRadius.x.toInt(),
    //           columnRect.trRadius.x.toInt());
    //       expect(_stackedColumnPoints2[i].rectValues[j].trRadius.y.toInt(),
    //           columnRect.trRadius.y.toInt());
    //     }
    //   }
    // });
  });

  // group('Stacked Bar - Gradient Colors', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Stacked Bar with Gradient Colors',
  //       (WidgetTester tester) async {
  //     final _StackedBarCustomization chartContainer =
  //         _stackedBarCustomization('customization_gradientColor')
  //             as _StackedBarCustomization;
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

  group('Stacked Bar Animation -', () {
    testWidgets('Stacked Bar animation with normal position',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation') as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Stacked Bar animation with transpose',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_transpose')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
      expect(chart!.series[1].animationDuration, 1500);
    });

    testWidgets('Stacked Bar animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_transpose_inverse')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets(
        'Stacked Baranimation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_transpose_inverse_negative')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets('Stacked Bar animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_inverse_negative')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Stacked bar animation with y inversed',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_inverse')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
      expect(chart!.series[1].animationDuration, 1350);
    });

    testWidgets('Stacked bar animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _stackedBarCustomization('animation_transpose_negative')
              as _StackedBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Stacked bar animation with negative y values',
        (WidgetTester tester) async {
      final _StackedBarCustomization chartContainer =
          _StackedBarCustomization('animation_negative');
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });
  });

  // testWidgets('Transposed Stacked bar with track ',
  //     (WidgetTester tester) async {
  //   final _StackedBarCustomization chartContainer =
  //       _StackedBarCustomization('customization_track_transposed');
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });
  // test('to test track region while chart is transposed', () {
  //   final CartesianSeriesRenderer? barSeriesRenderer =
  //       _chartState!._chartSeries.visibleSeriesRenderers[0];
  //   final List<RRect> trackRect = <RRect>[];
  //   trackRect.add(RRect.fromLTRBR(55.02620087336245, 0.0, 143.81513828238718,
  //       502.0, const Radius.circular(5)));
  //   trackRect.add(RRect.fromLTRBR(161.86754002911206, 0.0, 250.65647743813685,
  //       502.0, const Radius.circular(5)));
  //   trackRect.add(RRect.fromLTRBR(268.7088791848617, 0.0, 357.49781659388645,
  //       502.0, const Radius.circular(5)));
  //   trackRect.add(RRect.fromLTRBR(435.38136826783114, 0.0, 524.1703056768558,
  //       502.0, const Radius.circular(5)));
  //   trackRect.add(RRect.fromLTRBR(575.3435225618632, 0.0, 664.1324599708878,
  //       502.0, const Radius.circular(5)));
  //   for (int i = 0; i < trackRect.length; i++) {
  //     final StackedBarSegment barSegment =
  //         barSeriesRenderer!._segments[i] as StackedBarSegment;
  //     expect(barSegment._trackRect, trackRect[i]);
  //   }
  // });
}

StatelessWidget _stackedBarCustomization(String sampleName) {
  return _StackedBarCustomization(sampleName);
}

// ignore: must_be_immutable
class _StackedBarCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedBarCustomization(String sampleName) {
    chart = getStackedBarChart(sampleName);
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
