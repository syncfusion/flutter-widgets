import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_sample.dart';

/// Testing method for customization of the spline series.
void splineCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Spline - Fill, Point Color Mapping, MultiColored', () {
    // Spline series
    testWidgets(
        'Chart Widget - Testing Spline series with point color mapping and fill',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_default')
              as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];

    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       expect(strokeColor, const Color(0xfff44336));
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];

    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       expect(fillColor, const Color(0xff4caf50));
    //     }
    //   }
    // });

    testWidgets('Chart Widget - Testing Spline series with fill',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_fill')
              as _SplineCustomization;
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
    //       expect(strokeColor, const Color(0xff2196f3));
    //     }
    //   }
    // });

    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];

    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       expect(fillColor, const Color(0xff2196f3));
    //     }
    //   }
    // });

    testWidgets('Chart Widget - Spline series with multicolored line',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_pointColor')
              as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       expect(strokeColor.value, color[j].value);
    //     }
    //   }
    // });

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];

    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       expect(fillColor.value, 4283140025);
    //     }
    //   }
    // });
  });

  group('Spline Sorting', () {
    testWidgets('Chart Widget - Testing Spline Series Sorting Descending',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('sortingX') as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
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
    // });
  });

  group('Spline Types', () {
    testWidgets('Chart Widget - Testing Spline Series Monotonic',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_Monotonic')
              as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment monotonic', () {
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final SplineSegment segment =
    //       cartesianSeriesRenderer._segments[0] as SplineSegment;
    //   expect(segment._x1.toInt(), 34);
    //   expect(segment._y1.toInt(), 234);
    //   expect(segment._x2.toInt(), 153);
    //   expect(segment._y2.toInt(), 301);
    // });

    testWidgets('Chart Widget - Testing Spline Series Cardinal',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_cardinal')
              as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment cardinal', () {
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final SplineSegment segment =
    //       cartesianSeriesRenderer._segments[0] as SplineSegment;
    //   expect(segment._x1.toInt(), 34);
    //   expect(segment._y1.toInt(), 234);
    //   expect(segment._x2.toInt(), 153);
    //   expect(segment._y2.toInt(), 301);
    // });

    testWidgets('Chart Widget - Testing Spline Series Cardinal',
        (WidgetTester tester) async {
      final _SplineCustomization chartContainer =
          _splineCustomization('spline_customization_clamped')
              as _SplineCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test segment cardinal', () {
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final SplineSegment segment =
    //       cartesianSeriesRenderer._segments[0] as SplineSegment;
    //   expect(segment._x1.toInt(), 34);
    //   expect(segment._y1.toInt(), 234);
    //   expect(segment._x2.toInt(), 153);
    //   expect(segment._y2.toInt(), 301);
    // });
  });
}

StatelessWidget _splineCustomization(String sampleName) {
  return _SplineCustomization(sampleName);
}

// ignore: must_be_immutable
class _SplineCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineCustomization(String sampleName) {
    chart = getSplinechart(sampleName);
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
