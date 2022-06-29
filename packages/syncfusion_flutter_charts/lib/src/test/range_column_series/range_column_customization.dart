import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_column_sample.dart';

/// Testing method for customization of the range column series.
void rangeColumnCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Range Column - Fill, Point Color Mapping', () {
    testWidgets(
        'Chart Widget - Testing Range Column series with default colors',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_default')
              as _RangeColumnCustomization;
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

    // to test segment fill paint
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

    // to test tracker segment fill paint
    // test('test tracker segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       if (cartesianSeriesRenderer._segments[j] is RangeColumnSegment) {
    //         final RangeColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as RangeColumnSegment;
    //         final Color strokeColor = segment._getTrackerFillPaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerFillPaint().strokeWidth;
    //         expect(_chartColorDataValues1[i].rectValues, strokeColor);
    //         expect(strokeWidth, 0);
    //       }
    //     }
    //   }
    // });

// to test tracker segment stroke paint
    // test('test tracker segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       if (cartesianSeriesRenderer._segments[j] is RangeColumnSegment) {
    //         final RangeColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as RangeColumnSegment;
    //         final Color strokeColor = segment._getTrackerStrokePaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerStrokePaint().strokeWidth;
    //         expect(strokeColor, const Color(0x00000000));
    //         expect(strokeWidth.toInt(), 1);
    //       }
    //     }
    //   }
    // });

    // Range Column series
    testWidgets(
        'Chart Widget - Testing Range Column series with Fill and PointColorMapping',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_fill_pointcolor')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

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

    // to test segment fill paint
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

// Range Column series
    testWidgets('Chart Widget - Testing Range Column series with Fill',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_fill')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

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

    // to test segment fill paint
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

    // Range Column series
    testWidgets(
        'Chart Widget - Testing Range Column Series with Point Color Mapping ',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_pointColor')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

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

    testWidgets('Chart Widget - Testing Range Column series with tooltip',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('range_tooltip_format')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.format, 'point.y%');
    });

    // Range Column series
    testWidgets('Chart Widget - Testing Range Column Series with Tracker',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_tracker')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test tracker segment fill paint
    // test('test tracker segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       if (cartesianSeriesRenderer._segments[j] is RangeColumnSegment) {
    //         final RangeColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as RangeColumnSegment;
    //         final Color strokeColor = segment._getTrackerFillPaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerFillPaint().strokeWidth;
    //         expect(strokeColor, const Color(0xff9e9e9e));
    //         expect(strokeWidth, 0);
    //       }
    //     }
    //   }
    // });

    // Actual tracker pointRegion value which needs to be compared with test cases
    final List<Rect> trackerRegion = <Rect>[];
    trackerRegion.add(const Rect.fromLTRB(42.0, 0.0, 94.3, 502.0));
    trackerRegion.add(const Rect.fromLTRB(149.6, 0.0, 200.9, 502.0));
    trackerRegion.add(const Rect.fromLTRB(256.1, 0.0, 307.4, 502.0));
    trackerRegion.add(const Rect.fromLTRB(362.7, 0.0, 414.0, 502.0));
    trackerRegion.add(const Rect.fromLTRB(469.3, 0.0, 520.6, 502.0));
    trackerRegion.add(const Rect.fromLTRB(575.8, 0.0, 627.1, 502.0));
    trackerRegion.add(const Rect.fromLTRB(682.4, 0.0, 733.7, 502.0));

    final List<Rect> trackerRegion1 = <Rect>[];
    trackerRegion1.add(const Rect.fromLTRB(80.3, 0.0, 131.6, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(186.9, 0.0, 238.2, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(293.4, 0.0, 344.7, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(400.0, 0.0, 451.3, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(506.6, 0.0, 557.9, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(613.1, 0.0, 664.4, 502.0));
    trackerRegion1.add(const Rect.fromLTRB(719.7, 0.0, 771.0, 502.0));
    // final List<ChartDataValues> _rangeColumnPoints =
    //     getPointsValues(trackerRegion, trackerRegion1);

    // test('test tracker segement region', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Rect trackPoint =
    //           cartesianSeriesRenderer._dataPoints[j].trackerRectRegion!;
    //       expect(_rangeColumnPoints[i].rectValues[j].left.toInt(),
    //           trackPoint.left.toInt());
    //       expect(_rangeColumnPoints[i].rectValues[j].top.toInt(),
    //           trackPoint.top.toInt());
    //       expect(_rangeColumnPoints[i].rectValues[j].right.toInt(),
    //           trackPoint.right.toInt());
    //       expect(_rangeColumnPoints[i].rectValues[j].bottom.toInt(),
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
    //       if (cartesianSeriesRenderer._segments[j] is RangeColumnSegment) {
    //         final RangeColumnSegment segment =
    //             cartesianSeriesRenderer._segments[j] as RangeColumnSegment;
    //         final Color strokeColor = segment._getTrackerStrokePaint().color;
    //         final double strokeWidth =
    //             segment._getTrackerStrokePaint().strokeWidth;
    //         expect(strokeColor, const Color(0xfff44336));
    //         expect(strokeWidth.toInt(), 2);
    //       }
    //     }
    //   }
    // });

    testWidgets('Testing Rangecolumn series with track without border',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_track_without_border')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test bar series track withour border', () {
      final RangeColumnSeries<dynamic, dynamic> series =
          chart!.series[0] as RangeColumnSeries<dynamic, dynamic>;
      expect(series.trackBorderWidth, 0);
    });
  });

  group('Range Column - Corner Radius', () {
    // Range Column series
    testWidgets('Chart Widget - Testing Range Column Series with Corner Radius',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_cornerradius')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    final List<RRect> trackerRect = <RRect>[];
    final List<RRect> trackerRect1 = <RRect>[];
    trackerRect
        .add(RRect.fromLTRBR(44.0, 0.0, 92.3, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(151.6, 0.0, 198.9, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(258.1, 0.0, 305.4, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(364.7, 0.0, 412.0, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(577.8, 0.0, 625.1, 502.0, const Radius.circular(5)));
    trackerRect.add(
        RRect.fromLTRBR(684.4, 0.0, 731.7, 502.0, const Radius.circular(5)));

    trackerRect1.add(
        RRect.fromLTRBR(82.3, 0.0, 129.6, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(188.9, 0.0, 236.2, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(295.4, 0.0, 342.7, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(402.0, 0.0, 449.3, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(508.6, 0.0, 555.9, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(615.1, 0.0, 662.4, 502.0, const Radius.circular(5)));
    trackerRect1.add(
        RRect.fromLTRBR(721.7, 0.0, 769.0, 502.0, const Radius.circular(5)));
    // final List<_ChartDataValues> _rangeColumnPoints1 =
    //     _getPointsValues(trackerRect, trackerRect1);
    // test('test tracker rounded corners', () {
    //   for (int i = 0; i < chart.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer.segments.length; j++) {
    //       final RangeColumnSegment segment = cartesianSeriesRenderer.segments[j];
    //       final RRect trackPoint = segment._trackRect;
    //       expect(_rangeColumnPoints1[i].rectValues[j].left.toInt(),
    //           trackPoint.left.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].top.toInt(),
    //           trackPoint.top.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].right.toInt(),
    //           trackPoint.right.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].bottom.toInt(),
    //           trackPoint.bottom.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].blRadius.x.toInt(),
    //           trackPoint.blRadius.x.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].blRadius.y.toInt(),
    //           trackPoint.blRadius.y.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].brRadius.x.toInt(),
    //           trackPoint.brRadius.x.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].brRadius.y.toInt(),
    //           trackPoint.brRadius.y.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].tlRadius.x.toInt(),
    //           trackPoint.tlRadius.x.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].tlRadius.y.toInt(),
    //           trackPoint.tlRadius.y.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].trRadius.x.toInt(),
    //           trackPoint.trRadius.x.toInt());
    //       expect(_rangeColumnPoints1[i].rectValues[j].trRadius.y.toInt(),
    //           trackPoint.trRadius.y.toInt());
    //     }
    //   }
    // });

    final List<RRect> pointRect = <RRect>[];
    final List<RRect> pointRect1 = <RRect>[];
    pointRect.add(
        RRect.fromLTRBR(49.0, 255.6, 87.3, 431.3, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(156.6, 173.4, 193.9, 371.9, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(263.1, 116.4, 300.4, 310.3, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(369.7, 63.9, 407.0, 260.1, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(582.8, 216.8, 620.1, 365.1, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(689.4, 344.6, 726.7, 467.8, const Radius.circular(5)));

    pointRect1.add(
        RRect.fromLTRBR(87.3, 278.4, 124.6, 444.0, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(193.9, 241.9, 231.2, 394.8, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(300.4, 173.4, 337.7, 355.0, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(407.0, 109.5, 444.3, 282.9, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(513.6, 157.4, 550.9, 330.9, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(620.1, 262.4, 657.4, 433.5, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(726.7, 342.3, 764.0, 474.6, const Radius.circular(5)));

    // final List<_ChartDataValues> _rangeColumnPoints2 =
    //     _getPointsValues(pointRect, pointRect1);

    // test('test Range column rounded corners', () {
    //   for (int i = 0; i < chart.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer.segments.length; j++) {
    //       final RangeColumnSegment segment = cartesianSeriesRenderer.segments[j];
    //       final RRect columnRect = segment.segmentRect;
    //       expect(_rangeColumnPoints2[i].rectValues[j].left.toInt(),
    //           columnRect.left.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].top.toInt(),
    //           columnRect.top.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].right.toInt(),
    //           columnRect.right.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].bottom.toInt(),
    //           columnRect.bottom.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].blRadius.x.toInt(),
    //           columnRect.blRadius.x.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].blRadius.y.toInt(),
    //           columnRect.blRadius.y.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].brRadius.x.toInt(),
    //           columnRect.brRadius.x.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].brRadius.y.toInt(),
    //           columnRect.brRadius.y.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].tlRadius.x.toInt(),
    //           columnRect.tlRadius.x.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].tlRadius.y.toInt(),
    //           columnRect.tlRadius.y.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].trRadius.x.toInt(),
    //           columnRect.trRadius.x.toInt());
    //       expect(_rangeColumnPoints2[i].rectValues[j].trRadius.y.toInt(),
    //           columnRect.trRadius.y.toInt());
    //     }
    //   }
    // });
  });

  group('Range Column - Gradient Colors', () {
    // Range Column series
    testWidgets(
        'Chart Widget - Testing Range Column Series with Gradient Colors',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('customization_gradientColor')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       expect(strokeColor, const Color(0xff000000));
    //     }
    //   }
    // });
    testWidgets('Chart Widget - Testing the PointerIndex ',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('NumericAxis-PointIndex')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;
        expect(cartesianSeries.emptyPointSettings.mode, EmptyPointMode.average);
      }
    });
  });
  group('Range Column - Sorting', () {
    testWidgets(
        'Chart Widget - Testing Range Column Series - Sorting X Axis Descending',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('sortingX') as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '2');
    // });

    testWidgets(
        'Chart Widget - Testing Range Column Series Sorting - X Axis Ascending',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('sortingX_Ascending')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '2');
    // });

    testWidgets(
        'Chart Widget - Testing Range Column Series Sorting Y Axis Ascending',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('sortingY_Ascending')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '2');
    // });

    testWidgets(
        'Chart Widget - Testing Range Column Series Sorting Y Axis Descendins',
        (WidgetTester tester) async {
      final _RangeColumnCustomization chartContainer =
          _rangeColumnCustomization('sortingY_Descending')
              as _RangeColumnCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '2');
    // });
  });
}

StatelessWidget _rangeColumnCustomization(String sampleName) {
  return _RangeColumnCustomization(sampleName);
}

// ignore: must_be_immutable
class _RangeColumnCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeColumnCustomization(String sampleName) {
    chart = getRangeColumnchart(sampleName);
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
