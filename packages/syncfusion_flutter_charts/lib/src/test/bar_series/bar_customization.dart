import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bar_sample.dart';

/// Test method of the bar series customization.
void barCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bar - Fill , Point Color Mapping and Gradient Colors', () {
    testWidgets('Chart Widget - Testing Bar series with default colors',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('customization_default') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // //to test the dash array
    // test('test the dash array', () {
    //   final BarSeriesRenderer seriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   expect(seriesRenderer._series.dashArray, <double>[10, 20]);
    // });

    // // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0x00000000));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       // final Color strokeColor =
    //       //     seriesRenderer.segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       // expect(strokeColor, const Color(0xff355c7d));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // to test tracker segment fill paint
//     test('test tracker segment fill paint', () {
//       for (int i = 0;
//           i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//           i++) {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < seriesRenderer._segments.length; j++) {
//           if (seriesRenderer._segments[j] is BarSegment) {
//             final BarSegment segment =
//                 seriesRenderer._segments[j] as BarSegment;
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
//       for (int i = 0;
//           i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//           i++) {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < seriesRenderer._segments.length; j++) {
//           if (seriesRenderer._segments[j] is BarSegment) {
//             final BarSegment segment =
//                 seriesRenderer._segments[j] as BarSegment;
//             final Color strokeColor = segment._getTrackerStrokePaint().color;
//             final double strokeWidth =
//                 segment._getTrackerStrokePaint().strokeWidth;
//             expect(strokeColor, const Color(0x00000000));
//             expect(strokeWidth.toInt(), 1);
//           }
//         }
//       }
//     });

    testWidgets('Testing bar series with track without border',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('customization_track_without_border')
              as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    // test('test bar series track withour border', () {
    //   final BarSeriesRenderer seriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   final BarSeries<dynamic, dynamic> series =
    //       seriesRenderer._series as BarSeries<dynamic, dynamic>;
    //   expect(series.trackBorderWidth, 0);
    // });
    // testWidgets('Default annotation sample', (WidgetTester tester) async {
    //   final _BarCustomization chartContainer =
    //       _barCustomization('cartesian_annotation_default')
    //           as _BarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   _chartState!._redraw();
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx + 100, value.dy + 70)));
    //   _chartState!._zoomPanBehaviorRenderer._isPinching = true;
    //   _chartState!._containerArea._performPointerUp(
    //       PointerUpEvent(position: Offset(value.dx, value.dy)));
    //   const double firstTouchXValue = 50;
    //   const double firstTouchYValue = 250;
    //   _chartState!._containerArea._performPanUpdate(DragUpdateDetails(
    //       globalPosition: const Offset(firstTouchXValue, firstTouchYValue)));
    //   _chartState!._containerArea._performPanEnd(DragEndDetails());
    //   await tester.pump(const Duration(seconds: 3));
    // });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
    // testWidgets('Default annotation sample', (WidgetTester tester) async {
    //   final _BarCustomization chartContainer =
    //       _barCustomization('panupdate') as _BarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   _chartState!._redraw();
    //   const double firstTouchXValue = 50;
    //   const double firstTouchYValue = 250;
    //   _chartState!._crosshairBehaviorRenderer._isLongPressActivated = true;
    //   _chartState!._trackballBehaviorRenderer._isLongPressActivated = true;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   final double firstTouchValue1 = value.dx;
    //   final double firstTouchValue2 = value.dy;
    //   final double secondTouchXValue = value.dx + 50;
    //   final double secondTouchYValue = value.dy + 50;
    //   _chartState!._containerArea._performPointerMove(PointerMoveEvent(
    //       position: Offset(firstTouchValue1, firstTouchValue2), pointer: 2));
    //   _chartState!._containerArea._performPointerMove(PointerMoveEvent(
    //       position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
    //   _chartState!._containerArea._performPanUpdate(DragUpdateDetails(
    //       globalPosition: const Offset(firstTouchXValue, firstTouchYValue)));
    //   _chartState!._containerArea._performPanEnd(DragEndDetails());
    //   await tester.pump(const Duration(seconds: 3));
    // });

    test('test panning update', () {
      expect(chart!.series.length, 1);
    });
    // Bar series
    testWidgets(
        'Chart Widget - Testing Bar series with Fill and PointColorMapping',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('customization_fill_pointcolor')
              as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0x00000000));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

// Bar series
    testWidgets('Chart Widget - Testing Bar series with Fill',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('customization_fill') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getStrokePaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 3);
    //     }
    //   }
    // });
    testWidgets('Chart Widget - Testing Bar series Fill Color with Opacity',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('customization_fill_color_opacity')
              as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeWidth, 3);
    //     }
    //   }
    // });
    // testWidgets('Chart Widget - Testing Bar series Border Color with Opacity',
    //     (WidgetTester tester) async {
    //   final _BarCustomization chartContainer =
    //       _barCustomization('customization_border_color_opacity')
    //           as _BarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeWidth, 3);
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(strokeColor, const Color(0xff2196f3));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // // Bar series
    // testWidgets('Chart Widget - Testing Bar Series with Point Color Mapping ',
    //     (WidgetTester tester) async {
    //   final _BarCustomization chartContainer =
    //       _barCustomization('customization_pointColor') as _BarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getStrokePaint().color;
    //       expect(strokeColor, const Color(0x00000000));
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(strokeColor, const Color(0xffff5722));
    //       } else if (j == 1) {
    //         expect(strokeColor, const Color(0xff673ab7));
    //       } else if (j == 2) {
    //         expect(strokeColor, const Color(0xff8bc34a));
    //       } else if (j == 3) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });

    // // Actual tracker pointRegion value which needs to be compared with test cases
    // final List<Rect> trackerRegion = <Rect>[];
    // trackerRegion.add(const Rect.fromLTRB(46.0, 422.3, 780.0, 496.2));
    // trackerRegion.add(const Rect.fromLTRB(46.0, 336.8, 780.0, 410.7));
    // trackerRegion.add(const Rect.fromLTRB(46.0, 251.3, 780.0, 325.1));
    // trackerRegion.add(const Rect.fromLTRB(46.0, 117.9, 780.0, 191.7));
    // trackerRegion.add(const Rect.fromLTRB(46.0, 5.8, 780.0, 79.7));

    // // Bar series
    // testWidgets('Chart Widget - Testing Bar Series with Tracker',
    //     (WidgetTester tester) async {
    //   final _BarCustomization chartContainer =
    //       _barCustomization('customization_tracker') as _BarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test tracker segment fill paint
    // test('test tracker segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       if (seriesRenderer._segments[j] is BarSegment) {
    //         final BarSegment segment =
    //             seriesRenderer._segments[j] as BarSegment;
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
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Rect trackPoint =
    //           seriesRenderer._dataPoints[j].trackerRectRegion!;
    //       expect(trackerRegion[j].left.toInt(), trackPoint.left.toInt());
    //       expect(trackerRegion[j].top.toInt(), trackPoint.top.toInt());
    //       expect(trackerRegion[j].right.toInt(), trackPoint.right.toInt());
    //       expect(trackerRegion[j].bottom.toInt(), trackPoint.bottom.toInt());
    //     }
    //   }
    // });

// // to test tracker segment stroke paint
//     test('test tracker segment stroke paint', () {
//       for (int i = 0;
//           i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//           i++) {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < seriesRenderer._segments.length; j++) {
//           if (seriesRenderer._segments[j] is BarSegment) {
//             final BarSegment segment =
//                 seriesRenderer._segments[j] as BarSegment;
//             final Color strokeColor = segment._getTrackerStrokePaint().color;
//             final double strokeWidth =
//                 segment._getTrackerStrokePaint().strokeWidth;
//             expect(strokeColor, const Color(0xfff44336));
//             expect(strokeWidth.toInt(), 2);
//           }
//         }
//       }
//     });

//     testWidgets('Chart Widget - Testing Bar Series with Gradient Colors',
//         (WidgetTester tester) async {
//       final _BarCustomization chartContainer =
//           _barCustomization('customization_gradientColor') as _BarCustomization;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('test segment fill paint', () {
//       for (int i = 0;
//           i < _chartState!._chartSeries.visibleSeriesRenderers.length;
//           i++) {
//         final CartesianSeriesRenderer seriesRenderer =
//             _chartState!._chartSeries.visibleSeriesRenderers[i];
//         for (int j = 0; j < seriesRenderer._segments.length; j++) {
//           final Color strokeColor =
//               seriesRenderer._segments[j].getFillPaint().color;
//           expect(strokeColor, const Color(0xff000000));
//         }
//       }
//     });

//     testWidgets('Chart Widget - Testing Bar Series Sorting Descending',
//         (WidgetTester tester) async {
//       final _BarCustomization chartContainer =
//           _barCustomization('sortingX') as _BarCustomization;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test primaryXAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
//           'USA');
//       expect(
//           _chartState!
//               ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
//           'China');
//     });

//     test('to test primaryYAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
//           '0');
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
//           '20');
//     });
  });

  // group('Bar - Corner Radius', () {
  //   testWidgets('Chart Widget - Testing Bar Series with Corner Radius',
  //       (WidgetTester tester) async {
  //     final _BarCustomization chartContainer =
  //         _barCustomization('customization_cornerradius') as _BarCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //   });

  //   final List<RRect> trackerRect = <RRect>[];
  //   final List<RRect> pointRect = <RRect>[];
  //   trackerRect.add(
  //       RRect.fromLTRBR(46.0, 422.3, 780.0, 496.2, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(46.0, 336.8, 780.0, 410.7, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(46.0, 251.3, 780.0, 325.1, const Radius.circular(5)));
  //   trackerRect.add(
  //       RRect.fromLTRBR(46.0, 117.9, 780.0, 191.7, const Radius.circular(5)));
  //   trackerRect
  //       .add(RRect.fromLTRBR(46.0, 5.8, 780.0, 79.7, const Radius.circular(5)));

  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 429.3, 437.5, 489.2, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 343.8, 339.6, 403.7, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 258.3, 486.4, 318.1, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 124.9, 510.9, 184.7, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 12.8, 706.6, 72.7, const Radius.circular(5)));

  //   test('test tracker rounded corners', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final BarSegment segment = seriesRenderer._segments[j] as BarSegment;
  //         final RRect trackPoint = segment._trackBarRect;
  //         expect(trackerRect[j].left.toInt(), trackPoint.left.toInt());
  //         expect(trackerRect[j].top.toInt(), trackPoint.top.toInt());
  //         expect(trackerRect[j].right.toInt(), trackPoint.right.toInt());
  //         expect(trackerRect[j].bottom.toInt(), trackPoint.bottom.toInt());
  //         expect(
  //             trackerRect[j].blRadius.x.toInt(), trackPoint.blRadius.x.toInt());
  //         expect(
  //             trackerRect[j].blRadius.y.toInt(), trackPoint.blRadius.y.toInt());
  //         expect(
  //             trackerRect[j].brRadius.x.toInt(), trackPoint.brRadius.x.toInt());
  //         expect(
  //             trackerRect[j].brRadius.y.toInt(), trackPoint.brRadius.y.toInt());
  //         expect(
  //             trackerRect[j].tlRadius.x.toInt(), trackPoint.tlRadius.x.toInt());
  //         expect(
  //             trackerRect[j].tlRadius.y.toInt(), trackPoint.tlRadius.y.toInt());
  //         expect(
  //             trackerRect[j].trRadius.x.toInt(), trackPoint.trRadius.x.toInt());
  //         expect(
  //             trackerRect[j].trRadius.y.toInt(), trackPoint.trRadius.y.toInt());
  //       }
  //     }
  //   });

  //   test('test Bar rounded corners', () {
  //     for (int i = 0;
  //         i < _chartState!._chartSeries.visibleSeriesRenderers.length;
  //         i++) {
  //       final CartesianSeriesRenderer seriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < seriesRenderer._segments.length; j++) {
  //         final BarSegment segment = seriesRenderer._segments[j] as BarSegment;
  //         final RRect columnRect = segment.segmentRect;
  //         expect(pointRect[j].left.toInt(), columnRect.left.toInt());
  //         expect(pointRect[j].top.toInt(), columnRect.top.toInt());
  //         expect(pointRect[j].right.toInt(), columnRect.right.toInt());
  //         expect(pointRect[j].bottom.toInt(), columnRect.bottom.toInt());
  //         expect(
  //             pointRect[j].blRadius.x.toInt(), columnRect.blRadius.x.toInt());
  //         expect(
  //             pointRect[j].blRadius.y.toInt(), columnRect.blRadius.y.toInt());
  //         expect(
  //             pointRect[j].brRadius.x.toInt(), columnRect.brRadius.x.toInt());
  //         expect(
  //             pointRect[j].brRadius.y.toInt(), columnRect.brRadius.y.toInt());
  //         expect(
  //             pointRect[j].tlRadius.x.toInt(), columnRect.tlRadius.x.toInt());
  //         expect(
  //             pointRect[j].tlRadius.y.toInt(), columnRect.tlRadius.y.toInt());
  //         expect(
  //             pointRect[j].trRadius.x.toInt(), columnRect.trRadius.x.toInt());
  //         expect(
  //             pointRect[j].trRadius.y.toInt(), columnRect.trRadius.y.toInt());
  //       }
  //     }
  //   });

  //   testWidgets('Transposed bar series with track',
  //       (WidgetTester tester) async {
  //     final _BarCustomization chartContainer =
  //         _barCustomization('customization_track_transposed')
  //             as _BarCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('test Bar rounded corners', () {
  //     final CartesianSeriesRenderer seriesRenderer =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0];
  //     final BarSegment segment = seriesRenderer._segments[0] as BarSegment;
  //     final RRect columnRect = segment.segmentRect;
  //     expect(columnRect.left.toInt(), 53);
  //     expect(columnRect.top.toInt(), 234);
  //     expect(columnRect.right.toInt(), 142);
  //     expect(columnRect.bottom.toInt(), 502);
  //   });
  // });

  group('Bar Series Animation -', () {
    testWidgets('Bar series animation with normal position',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Bar series animation with transpose',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_transpose') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Bar series animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_transpose_inverse') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
    });

    testWidgets(
        'Bar series animation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_transpose_inverse_negative')
              as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
    });

    testWidgets('Bar series animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_inverse_negative') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
    });

    testWidgets('Bar series animation with y inversed',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_inverse') as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
    });

    testWidgets('Bar series animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _BarCustomization chartContainer =
          _barCustomization('animation_transpose_negative')
              as _BarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
    });
  });
}

StatelessWidget _barCustomization(String sampleName) {
  return _BarCustomization(sampleName);
}

// ignore: must_be_immutable
class _BarCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BarCustomization(String sampleName) {
    chart = getBarChart(sampleName);
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
