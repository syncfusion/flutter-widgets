import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'step_area_sample.dart';

/// Testing method for customization of the stacked area series.
void stepAreaCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('StepArea Series - Gradient, Fill and Point Color Mapping', () {
    testWidgets(
        'Chart Widget - Testing Area series with point color mapping and fill',
        (WidgetTester tester) async {
      final _StepAreaCutomizationChartContainerWidget chartContainer =
          _stepAreaCutomizationChartContainerWidget('customization_default')
              as _StepAreaCutomizationChartContainerWidget;
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

    //Testing StepArea series with fill
    // testWidgets('Chart Widget - Testing Area series with fill',
    //     (WidgetTester tester) async {
    //   final _StepAreaCutomizationChartContainerWidget chartContainer =
    //       _stepAreaCutomizationChartContainerWidget('customization_fill')
    //           as _StepAreaCutomizationChartContainerWidget;
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
      final _StepAreaCutomizationChartContainerWidget chartContainer =
          _stepAreaCutomizationChartContainerWidget(
                  'customization_gradientColor')
              as _StepAreaCutomizationChartContainerWidget;
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

    testWidgets('Testing Area series with borderMode_all',
        (WidgetTester tester) async {
      final _StepAreaCutomizationChartContainerWidget chartContainer =
          _stepAreaCutomizationChartContainerWidget('customization_border_all')
              as _StepAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test group mode', () {
      final StepAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StepAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.all);
    });

    testWidgets('Testing Area series with borderMode_top',
        (WidgetTester tester) async {
      final _StepAreaCutomizationChartContainerWidget chartContainer =
          _stepAreaCutomizationChartContainerWidget('customization_border_top')
              as _StepAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test group mode', () {
      final StepAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StepAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.top);
    });

    testWidgets('Testing StepArea series with borderMode_excludeBottom',
        (WidgetTester tester) async {
      final _StepAreaCutomizationChartContainerWidget chartContainer =
          _stepAreaCutomizationChartContainerWidget(
                  'customization_border_excludeBottom')
              as _StepAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test gradient colors', () {
      final StepAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StepAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.excludeBottom);
    });
  });

  // group('StepArea - Sorting', () {
  //   testWidgets('Chart Widget - Testing Sorting by Descending',
  //       (WidgetTester tester) async {
  //     final _StepAreaCutomizationChartContainerWidget chartContainer =
  //         _stepAreaCutomizationChartContainerWidget('sortingX')
  //             as _StepAreaCutomizationChartContainerWidget;
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

StatelessWidget _stepAreaCutomizationChartContainerWidget(String sampleName) {
  return _StepAreaCutomizationChartContainerWidget(sampleName);
}

// ignore: must_be_immutable
class _StepAreaCutomizationChartContainerWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StepAreaCutomizationChartContainerWidget(String sampleName) {
    chart = getStepAreachart(sampleName);
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
