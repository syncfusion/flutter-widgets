import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_area_sample.dart';

/// Testing method for customization of the spline area series.
void splineAreaCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Area - Gradient, Fill and Point Color Mapping', () {
    testWidgets(
        'Chart Widget - Testing Area series with point color mapping and fill',
        (WidgetTester tester) async {
      final _SplineAreaCutomizationChartContainerWidget chartContainer =
          _splineAreaCutomizationChartContainerWidget('customization_default')
              as _SplineAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // to test segment stroke paint
    // test('test segment stroke paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     if (chart!.series[i] is CartesianSeries) {
    //       final CartesianSeriesRenderer cartesianSeriesRenderer =
    //           _chartState!._chartSeries.visibleSeriesRenderers[i];
    //       for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //         final Color strokeColor =
    //             cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //         expect(strokeColor, const Color(0x00000000));
    //       }
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

    // //Testing Area series with fill
    // testWidgets('Chart Widget - Testing Area series with fill',
    //     (WidgetTester tester) async {
    //   final _SplineAreaCutomizationChartContainerWidget chartContainer =
    //       _splineAreaCutomizationChartContainerWidget('customization_fill')
    //           as _SplineAreaCutomizationChartContainerWidget;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test segment stroke paint
    // test('test segment stroke color', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().color;
    //       expect(strokeColor.value, const Color(0xfff44336).value);
    //     }
    //   }
    // });

    // test('test segment stroke width', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final double strokeWidth =
    //           cartesianSeriesRenderer._segments[j].getStrokePaint().strokeWidth;
    //       expect(strokeWidth, 2.0);
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

    testWidgets('Chart Widget - Testing Area series with gradient color',
        (WidgetTester tester) async {
      final _SplineAreaCutomizationChartContainerWidget chartContainer =
          _splineAreaCutomizationChartContainerWidget(
                  'customization_gradientColor')
              as _SplineAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test gradient colors', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;
        for (int j = 0; j < cartesianSeries.gradient!.colors.length; j++) {
          final Color strokeColor = cartesianSeries.gradient!.colors[j];
          if (j == 0) {
            expect(strokeColor.value, const Color(0xfffce4ec).value);
          } else if (j == 1) {
            expect(strokeColor.value, const Color(0xfff48fb1).value);
          } else {
            expect(strokeColor.value, const Color(0xffe91e63).value);
          }
        }
      }
    });
  });

  // group('Area - Sorting', () {
  //   testWidgets('Chart Widget - Testing Area Series Sorting Descending',
  //       (WidgetTester tester) async {
  //     final _SplineAreaCutomizationChartContainerWidget chartContainer =
  //         _splineAreaCutomizationChartContainerWidget('sortingX')
  //             as _SplineAreaCutomizationChartContainerWidget;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
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
  // });
}

StatelessWidget _splineAreaCutomizationChartContainerWidget(String sampleName) {
  return _SplineAreaCutomizationChartContainerWidget(sampleName);
}

// ignore: must_be_immutable
class _SplineAreaCutomizationChartContainerWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineAreaCutomizationChartContainerWidget(String sampleName) {
    chart = getSplineAreachart(sampleName);
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
