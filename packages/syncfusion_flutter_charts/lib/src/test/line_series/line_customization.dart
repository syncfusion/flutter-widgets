import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'line_sample.dart';

/// Testing method for customization of the line series.
void lineCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Line - Fill, Point Color Mapping', () {
    // Line series
    testWidgets(
        'Chart Widget - Testing Line series with point color mapping and fill',
        (WidgetTester tester) async {
      final _LineCustomization chartContainer =
          _lineCustomization('line_customization_default')
              as _LineCustomization;
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

    // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       expect(fillColor, const Color(0xfff44336));
    //     }
    //   }
    // });

    //Testing Line series with fill
    // testWidgets('Chart Widget - Testing Line series with fill',
    //     (WidgetTester tester) async {
    //   final _LineCustomization chartContainer =
    //       _lineCustomization('line_customization_fill') as _LineCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfCartesianChartState?;
    // });

    // to test segment stroke paint
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

    // // to test segment point color mapping paint
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

    // testWidgets('Line series with selction in intial rendering',
    //     (WidgetTester tester) async {
    //   final _LineCustomization chartContainer =
    //       _lineCustomization('customization_selection_initial_render')
    //           as _LineCustomization;
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

    //Testing Line series with point color mapping
    //  testWidgets('Chart Widget - Line series with multicolored line',
    //     (WidgetTester tester) async {
    //   final _LineCustomization chartContainer =
    //       _lineCustomization('line_customization_pointColor')
    //           as _LineCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
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

    // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(fillColor, const Color(0xffff5722));
    //       } else if (j == 1) {
    //         expect(fillColor, const Color(0xff673ab7));
    //       } else if (j == 2) {
    //         expect(fillColor, const Color(0xff8bc34a));
    //       } else if (j == 3) {
    //         expect(fillColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });
  });

  // group('Line - Sorting', () {
  //   testWidgets('Chart Widget - Testing Line Series Sorting Descending',
  //       (WidgetTester tester) async {
  //     final _LineCustomization chartContainer =
  //         _lineCustomization('sortingX') as _LineCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'China');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '20');
  //   });

  //   testWidgets(
  //       'Testing line series sorting with first point null in ascending order',
  //       (WidgetTester tester) async {
  //     final _LineCustomization chartContainer =
  //         _lineCustomization('sortingX_ascending_null') as _LineCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'China');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'USA');
  //   });
  //   // testWidgets(
  //   //     'Testing line series sorting with first point null in descending order',
  //   //     (WidgetTester tester) async {
  //   //   final _LineCustomization chartContainer =
  //   //       _lineCustomization('sortingX_descending_null');
  //   //   await tester.pumpWidget(chartContainer);
  //   //   chart = chartContainer.chart;
  //   // final GlobalKey key = chart.key;
  //   // _chartState = key.currentState;
  //   // });

  //   // test('to test primaryXAxis labels', () {
  //   //   expect(_chartState._chartAxis._primaryXAxisRenderer._visibleLabels[0].text, 'USA');
  //   //   expect(
  //   //       chart
  //   //           .primaryXAxis
  //   //           ._visibleLabels.last
  //   //           .text,
  //   //       'China');
  //   // });
  // });
}

StatelessWidget _lineCustomization(String sampleName) {
  return _LineCustomization(sampleName);
}

// ignore: must_be_immutable
class _LineCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _LineCustomization(String sampleName) {
    chart = getLineChart(sampleName);
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
