import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_area_sample.dart';

/// Testing method for customization of the stacked area series.
void stackedAreaCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacked Area - Gradient, Fill and Point Color Mapping', () {
    testWidgets(
        'Chart Widget - Testing Stacked Area series with point color mapping and fill',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget('customization_default')
              as _StackedAreaCutomizationChartContainerWidget;
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
    //   for (int i = 0; i < chart.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer.segments.length; j++) {
    //       final Color fillColor =
    //           cartesianSeriesRenderer.segments[j].getFillPaint().color;
    //       expect(fillColor, const Color(0xfff355c7d));
    //     }
    //   }
    // });

    //Testing Area series with fill
    // testWidgets('Chart Widget - Testing StackedArea series with fill',
    //     (WidgetTester tester) async {
    //   final _StackedAreaCutomizationChartContainerWidget chartContainer =
    //       _stackedAreaCutomizationChartContainerWidget('customization_fill')
    //           as _StackedAreaCutomizationChartContainerWidget;
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
    //       expect(strokeWidth, 3.0);
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

    //Testing Area series with fill point color
    // testWidgets(
    //     'Chart Widget - Testing StackedArea series with fill point color',
    //     (WidgetTester tester) async {
    //   final _StackedAreaCutomizationChartContainerWidget chartContainer =
    //       _stackedAreaCutomizationChartContainerWidget(
    //               'customization_fill_pointcolor')
    //           as _StackedAreaCutomizationChartContainerWidget;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // // to test segment fill point color
    // test('test segment fill point color ', () {
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

    //Testing Area series with point color
    testWidgets('Chart Widget - Testing StackedArea series with point color',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget(
                  'customization_pointColor')
              as _StackedAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    //// to test segment point color
    //test('test segment point color ', () {
    //  for (int i = 0; i < chart.series.length; i++) {
    //    final CartesianSeries<dynamic,dynamic> cartesianSeries = _chartState._chartSeries.visibleSeriesRenderers[i];
    //
    //    }
    //  }
    //});

    testWidgets('Chart Widget - Testing StackedArea series with gradient color',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget(
                  'customization_gradientColor')
              as _StackedAreaCutomizationChartContainerWidget;
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

    testWidgets('Testing StackedArea series with borderMode_all',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget(
                  'customization_border_all')
              as _StackedAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test group mode', () {
      final StackedAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StackedAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.all);
    });

    testWidgets('Testing Area series with borderMode_top',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget(
                  'customization_border_top')
              as _StackedAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test group mode', () {
      final StackedAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StackedAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.top);
    });

    testWidgets('Testing Area series with borderMode_excludeBottom',
        (WidgetTester tester) async {
      final _StackedAreaCutomizationChartContainerWidget chartContainer =
          _stackedAreaCutomizationChartContainerWidget(
                  'customization_border_excludeBottom')
              as _StackedAreaCutomizationChartContainerWidget;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test gradient colors', () {
      final StackedAreaSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as StackedAreaSeries<dynamic, dynamic>;
      expect(cartesianSeries.borderDrawMode, BorderDrawMode.excludeBottom);
    });
  });

  // group('Stacked Area - Sorting', () {
  //   testWidgets('Chart Widget - Testing Area Series Sorting Descending',
  //       (WidgetTester tester) async {
  //     final _StackedAreaCutomizationChartContainerWidget chartContainer =
  //         _stackedAreaCutomizationChartContainerWidget('sortingX')
  //             as _StackedAreaCutomizationChartContainerWidget;
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
  //         'Africa');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '40');
  //   });
  // });
}

StatelessWidget _stackedAreaCutomizationChartContainerWidget(
    String sampleName) {
  return _StackedAreaCutomizationChartContainerWidget(sampleName);
}

// ignore: must_be_immutable
class _StackedAreaCutomizationChartContainerWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedAreaCutomizationChartContainerWidget(String sampleName) {
    chart = getStackedAreaChart(sampleName);
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
