import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'column_sample.dart';

/// Testing method for customization of the column series.
void columnCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Column - Fill, Point Color Mapping', () {
    // Column series
    testWidgets('Chart Widget - Testing Column series with default colors',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('customization_default') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // to test segment stroke paint
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
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getFillPaint().color;
    //       final double strokeWidth =
    //           seriesRenderer._segments[j].getFillPaint().strokeWidth;
    //       expect(strokeColor, const Color(0xff4b87b9));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // // to test tracker segment fill paint
    // test('test tracker segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       if (seriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             seriesRenderer._segments[j] as ColumnSegment;
    //         final Color strokeColor = segment._getTrackerFillPaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerFillPaint().strokeWidth;
    //         expect(strokeColor, const Color(0xff9e9e9e));
    //         expect(strokeWidth, 0);
    //       }
    //     }
    //   }
    // });

// to test tracker segment stroke paint
    // test('test tracker segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       if (seriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             seriesRenderer._segments[j] as ColumnSegment;
    //         final Color strokeColor = segment._getTrackerStrokePaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerStrokePaint().strokeWidth;
    //         expect(strokeColor, const Color(0x00000000));
    //         expect(strokeWidth.toInt(), 1);
    //       }
    //     }
    //   }
    // });

    // Column series
    testWidgets(
        'Chart Widget - Testing Column series with Fill and PointColorMapping',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('customization_fill_pointcolor')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

// Column series
    testWidgets('Chart Widget - Testing Column series with Fill',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('customization_fill') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

    // testWidgets('Chart Widget - Testing Column series with Fill',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_fill_color_with_opacity')
    //           as _ColumnCustomization;
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
    //       expect(strokeWidth, 2);
    //     }
    //   }
    // });

    // testWidgets('Chart Widget - Testing Column series with Fill',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_border_color_with_opacity')
    //           as _ColumnCustomization;
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
    //       expect(strokeWidth, 2);
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

    // Column series
    // testWidgets(
    //     'Chart Widget - Testing Column Series with Point Color Mapping ',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_pointColor')
    //           as _ColumnCustomization;
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

    // testWidgets('Testing Column Series with selction in intial rendering',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_selection_initial_render')
    //           as _ColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

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

    // Actual tracker pointRegion value which needs to be compared with test cases
    // final List<Rect> trackerRegion = <Rect>[];
    // trackerRegion.add(const Rect.fromLTRB(46.1, 0.0, 149.0, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(173.1, 0.0, 276.1, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(300.2, 0.0, 403.2, 502.0));
    // trackerRegion.add(const Rect.fromLTRB(498.5, 0.0, 601.5, 502.0));
    // trackerRegion
    //     .add(const Rect.fromLTRB(664.9761499148212, 0.0, 767.9, 502.0));

    // // Column series
    // testWidgets('Chart Widget - Testing Column Series with Tracker',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_tracker') as _ColumnCustomization;
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
    //       if (seriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             seriesRenderer._segments[j] as ColumnSegment;
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

// to test tracker segment stroke paint
    // test('test tracker segment stroke paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       if (seriesRenderer._segments[j] is ColumnSegment) {
    //         final ColumnSegment segment =
    //             seriesRenderer._segments[j] as ColumnSegment;
    //         final Color strokeColor = segment._getTrackerStrokePaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerStrokePaint().strokeWidth;
    //         expect(strokeColor, const Color(0xfff44336));
    //         expect(strokeWidth.toInt(), 2);
    //       }
    //     }
    //   }
    // });

    // testWidgets('Testing column series with track without border',
    // (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('customization_track_without_border')
    //           as _ColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test series count
    // test('test bar series track withour border', () {
    //   final ColumnSeriesRenderer seriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
    //   final ColumnSeries<dynamic, dynamic> series =
    //       seriesRenderer._series as ColumnSeries<dynamic, dynamic>;
    //   expect(series.trackBorderWidth, 0);
    // });

    //   test('test by clearing the segments', () {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     expect(seriesRenderer._segments.length, 5);
    // });
  });

  group('Column - Corner Radius', () {
    // Column series
    testWidgets('Chart Widget - Testing Column Series with Corner Radius',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('customization_cornerradius')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    final List<RRect> trackerRect = <RRect>[];
    final List<RRect> pointRect = <RRect>[];
    trackerRect.add(
        RRect.fromLTRBR(46.1, 0.0, 149.0, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(173.1, 0.0, 276.1, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(300.2, 0.0, 403.2, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(498.5, 0.0, 601.5, 502.0, const Radius.circular(5)));
    trackerRect.add(RRect.fromLTRBR(664.9761499148212, 0.0, 767.9369676320273,
        502.0, const Radius.circular(5)));

    pointRect.add(
        RRect.fromLTRBR(53.1, 234.3, 142.0, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(180.1, 301.2, 269.1, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(307.2, 200.8, 396.2, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(505.5, 184.1, 594.5, 502.0, const Radius.circular(5)));
    pointRect.add(RRect.fromLTRBR(
        671.9761499148212, 50.2, 760.9, 502.0, const Radius.circular(5)));

    // test('test tracker rounded corners', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final ColumnSegment segment =
    //           seriesRenderer._segments[j] as ColumnSegment;
    //       final RRect trackPoint = segment._trackRect;
    //       expect(trackerRect[j].left.toInt(), trackPoint.left.toInt());
    //       expect(trackerRect[j].top.toInt(), trackPoint.top.toInt());
    //       expect(trackerRect[j].right.toInt(), trackPoint.right.toInt());
    //       expect(trackerRect[j].bottom.toInt(), trackPoint.bottom.toInt());
    //       expect(
    //           trackerRect[j].blRadius.x.toInt(), trackPoint.blRadius.x.toInt());
    //       expect(
    //           trackerRect[j].blRadius.y.toInt(), trackPoint.blRadius.y.toInt());
    //       expect(
    //           trackerRect[j].brRadius.x.toInt(), trackPoint.brRadius.x.toInt());
    //       expect(
    //           trackerRect[j].brRadius.y.toInt(), trackPoint.brRadius.y.toInt());
    //       expect(
    //           trackerRect[j].tlRadius.x.toInt(), trackPoint.tlRadius.x.toInt());
    //       expect(
    //           trackerRect[j].tlRadius.y.toInt(), trackPoint.tlRadius.y.toInt());
    //       expect(
    //           trackerRect[j].trRadius.x.toInt(), trackPoint.trRadius.x.toInt());
    //       expect(
    //           trackerRect[j].trRadius.y.toInt(), trackPoint.trRadius.y.toInt());
    //     }
    //   }
    // });

    // test('test column rounded corners', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final ColumnSegment segment =
    //           seriesRenderer._segments[j] as ColumnSegment;
    //       final RRect columnRect = segment.segmentRect;
    //       expect(pointRect[j].left.toInt(), columnRect.left.toInt());
    //       expect(pointRect[j].top.toInt(), columnRect.top.toInt());
    //       expect(pointRect[j].right.toInt(), columnRect.right.toInt());
    //       expect(pointRect[j].bottom.toInt(), columnRect.bottom.toInt());
    //       expect(
    //           pointRect[j].blRadius.x.toInt(), columnRect.blRadius.x.toInt());
    //       expect(
    //           pointRect[j].blRadius.y.toInt(), columnRect.blRadius.y.toInt());
    //       expect(
    //           pointRect[j].brRadius.x.toInt(), columnRect.brRadius.x.toInt());
    //       expect(
    //           pointRect[j].brRadius.y.toInt(), columnRect.brRadius.y.toInt());
    //       expect(
    //           pointRect[j].tlRadius.x.toInt(), columnRect.tlRadius.x.toInt());
    //       expect(
    //           pointRect[j].tlRadius.y.toInt(), columnRect.tlRadius.y.toInt());
    //       expect(
    //           pointRect[j].trRadius.x.toInt(), columnRect.trRadius.x.toInt());
    //       expect(
    //           pointRect[j].trRadius.y.toInt(), columnRect.trRadius.y.toInt());
    //     }
    //   }
    // });
  });

  group('Column - Gradient Colors', () {
    // Column series
    testWidgets('Chart Widget - Testing Column Series with Gradient Colors',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('customization_gradientColor')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('test segment fill paint', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < seriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           seriesRenderer._segments[j].getFillPaint().color;
    //       expect(strokeColor, const Color(0xff000000));
    //     }
    //   }
    // });
  });
  group('Column - Sorting', () {
    // testWidgets(
    //     'Chart Widget - Testing Column Series - Sorting X Axis Descending',
    //     (WidgetTester tester) async {
    //   final _ColumnCustomization chartContainer =
    //       _columnCustomization('sortingX') as _ColumnCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    test('to test primaryXAxis labels', () {
      //   expect(
      //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
      //       'USA');
      //   expect(
      //       _chartState!
      //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
      //       'China');
      // });

      // test('to test primaryYAxis labels', () {
      //   expect(
      //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
      //       '0');
      //   expect(
      //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
      //       '20');
    });

    testWidgets(
        'Chart Widget - Testing Column Series Sorting - X Axis Ascending',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('sortingX_Ascending') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'China');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'USA');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    testWidgets('Chart Widget - Testing Column Series Sorting Y Axis Ascending',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('sortingY_Ascending') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'China');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Russia');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    testWidgets(
        'Chart Widget - Testing Column Series Sorting Y Axis Descendins',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('sortingY_Descending') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Russia');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'China');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });
  });

  group('Column Series Animation -', () {
    testWidgets('Column series animation with normal position',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Column series animation with transpose',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_transpose') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Column series animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_transpose_inverse')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
    });

    testWidgets(
        'Column series animation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_transpose_inverse_negative')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
    });

    testWidgets('Column series animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_inverse_negative')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
    });

    testWidgets('Column series animation with y inversed',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_inverse') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
    });

    testWidgets('Column series animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_transpose_negative')
              as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
    });

    testWidgets('Column series animation with negative y values',
        (WidgetTester tester) async {
      final _ColumnCustomization chartContainer =
          _columnCustomization('animation_negative') as _ColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
    });
  });
}

StatelessWidget _columnCustomization(String sampleName) {
  return _ColumnCustomization(sampleName);
}

// ignore: must_be_immutable
class _ColumnCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ColumnCustomization(String sampleName) {
    chart = getColumnchart(sampleName);
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
