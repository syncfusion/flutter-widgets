import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_range_area_sample.dart';

/// Testing method for customization of the spline range area series.
void splineRangeAreaCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Range Area - Gradient, Fill and Point Color Mapping', () {
    testWidgets(
        'Chart Widget - Testing Range Area series with point color mapping and fill',
        (WidgetTester tester) async {
      final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
          _splineRangeAreaCutomizationChartContainerWidget(
                  'customization_default')
              as _SplineRangeAreaCutomizationChartContainerWidget;
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

    // to test segment fill paint
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

    //Testing Range Area series with fill
    // testWidgets('Chart Widget - Testing Range Area series with fill',
    //     (WidgetTester tester) async {
    //   final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
    //       _splineRangeAreaCutomizationChartContainerWidget(
    //               'customization_fill with tooltip')
    //           as _SplineRangeAreaCutomizationChartContainerWidget;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final RenderBox renderBox =
    //       _chartState!.context.findRenderObject() as RenderBox;
    //   // ignore: prefer_const_constructors_in_immutables
    //   _chartState!._containerArea._performPointerUp(PointerUpEvent(
    //       position: renderBox.localToGlobal(const Offset(144.4, 242.4))));
    //   await tester.pump(const Duration(seconds: 3));
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

    testWidgets('Chart Widget - Testing Range Area series with gradient color',
        (WidgetTester tester) async {
      final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
          _splineRangeAreaCutomizationChartContainerWidget(
                  'customization_gradientColor')
              as _SplineRangeAreaCutomizationChartContainerWidget;
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

  //group('RangeArea - Sorting', () {
  //   testWidgets('Chart Widget - Testing RangeArea Series Sorting Descending',
  //       (WidgetTester tester) async {
  //     final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
  //         _splineRangeAreaCutomizationChartContainerWidget('sortingX')
  //             as _SplineRangeAreaCutomizationChartContainerWidget;
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
  testWidgets('Testing range Area series with borderMode_all',
      (WidgetTester tester) async {
    final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
        _splineRangeAreaCutomizationChartContainerWidget('borderMode_all')
            as _SplineRangeAreaCutomizationChartContainerWidget;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
  });

  test('test group mode', () {
    final SplineRangeAreaSeries<dynamic, dynamic> cartesianSeries =
        chart!.series[0] as SplineRangeAreaSeries<dynamic, dynamic>;
    expect(cartesianSeries.borderDrawMode, RangeAreaBorderMode.all);
  });
  testWidgets('Testing range Area series with borderMode_excludeSides',
      (WidgetTester tester) async {
    final _SplineRangeAreaCutomizationChartContainerWidget chartContainer =
        _splineRangeAreaCutomizationChartContainerWidget(
                'borderMode_excludeSide')
            as _SplineRangeAreaCutomizationChartContainerWidget;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
  });

  test('test group mode', () {
    final SplineRangeAreaSeries<dynamic, dynamic> cartesianSeries =
        chart!.series[0] as SplineRangeAreaSeries<dynamic, dynamic>;
    expect(cartesianSeries.borderDrawMode, RangeAreaBorderMode.excludeSides);
  });
}

StatelessWidget _splineRangeAreaCutomizationChartContainerWidget(
    String sampleName) {
  return _SplineRangeAreaCutomizationChartContainerWidget(sampleName);
}

// ignore: must_be_immutable
class _SplineRangeAreaCutomizationChartContainerWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineRangeAreaCutomizationChartContainerWidget(String sampleName) {
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
