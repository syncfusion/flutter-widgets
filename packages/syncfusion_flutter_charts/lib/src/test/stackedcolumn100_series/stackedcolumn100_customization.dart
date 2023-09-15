import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stackedcolumn100_sample.dart';

/// Testing method for customization of the stacked column 100 series.
void stackedColumn100Customization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  // List<_ChartDataValues> _getPointsValues(
  //     List<dynamic> trackerRegion, List<dynamic> trackerRegion1) {
  //   final List<_ChartDataValues> _stackedColumnPoints = <_ChartDataValues>[];
  //   _stackedColumnPoints.add(_ChartDataValues(trackerRegion));
  //   _stackedColumnPoints.add(_ChartDataValues(trackerRegion1));

  //   return _stackedColumnPoints;
  // }

  group('Stacked Column - Fill, Point Color Mapping', () {
    // Column series
    testWidgets('Chart Widget - Testing Column series with default colors',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('customization_default')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 2);
    });

    // // to test segment stroke paint
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

    // final List<_ChartColorDataValues> _chartColorDataValues =
    //     _getColorValues(const Color(0xff4b87b9), const Color(0xffc06c84));

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
    //       expect(_chartColorDataValues[i].rectValues, strokeColor);
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

    // Column series
    // testWidgets(
    //     'Chart Widget - Testing Column series with Fill and PointColorMapping',
    //     (WidgetTester tester) async {
    //   final _StackedColumn100Customization chartContainer =
    //       _stackedColumn100Customization('customization_fill_pointcolor')
    //           as _StackedColumn100Customization;
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
    // testWidgets('Chart Widget - Testing Column series with Fill',
    //     (WidgetTester tester) async {
    //   final _StackedColumn100Customization chartContainer =
    //       _stackedColumn100Customization('customization_fill')
    //           as _StackedColumn100Customization;
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

    // Column series
    testWidgets(
        'Chart Widget - Testing Column Series with Point Color Mapping ',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('customization_pointColor')
              as _StackedColumn100Customization;
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

    // // to test segment fill paint
    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 1) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 2) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 3) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });

    // testWidgets('Testing Column Series with selction in intial rendering',
    //     (WidgetTester tester) async {
    //   final _StackedColumn100Customization chartContainer =
    //       _stackedColumn100Customization(
    //               'customization_selection_initial_render')
    //           as _StackedColumn100Customization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test segment fill paint', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final Color strokeColor =
    //           cartesianSeriesRenderer._segments[j].getFillPaint().color;
    //       if (j == 0) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 1) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 2) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       } else if (j == 3) {
    //         expect(strokeColor, const Color(0xfff44336));
    //       }
    //     }
    //   }
    // });
  });

  group('Column - Corner Radius', () {
    // Column series
    testWidgets('Chart Widget - Testing Column Series with Corner Radius',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('customization_cornerradius')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    final List<RRect> pointRect = <RRect>[];
    final List<RRect> pointRect1 = <RRect>[];

    pointRect.add(
        RRect.fromLTRBR(73.7, 284.9, 147, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(178.9, 294.5, 252.4, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(283.7, 281.6, 357.5, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(447.4, 303.6, 521.2, 502.0, const Radius.circular(5)));
    pointRect.add(
        RRect.fromLTRBR(585.3, 193.9, 659.1, 502.0, const Radius.circular(5)));

    pointRect1.add(
        RRect.fromLTRBR(178.9, 0.0, 252.4, 284.4, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(283.9, 0.0, 357.5, 294.2, const Radius.circular(5)));
    pointRect1
        .add(RRect.fromLTRBR(389, 0.0, 462.6, 281.6, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(552.9, 0.0, 626.5, 303.2, const Radius.circular(5)));
    pointRect1.add(
        RRect.fromLTRBR(690.6, 0.0, 764.2, 193.9, const Radius.circular(5)));

    // final List<_ChartDataValues> _stackedColumnPoints2 =
    //     _getPointsValues(pointRect, pointRect1);

    // test('test column rounded corners', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
    //       final StackedColumn100Segment segment =
    //           cartesianSeriesRenderer._segments[j] as StackedColumn100Segment;
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

  // group('Column - Gradient Colors', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Column Series with Gradient Colors',
  //       (WidgetTester tester) async {
  //     final _StackedColumn100Customization chartContainer =
  //         _stackedColumn100Customization('customization_gradientColor')
  //             as _StackedColumn100Customization;
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
  // group('Column - Sorting', () {
  // testWidgets(
  //     'Chart Widget - Testing Column Series - Sorting X Axis Descending',
  //     (WidgetTester tester) async {
  //   final _StackedColumn100Customization chartContainer =
  //       _stackedColumn100Customization('sortingX')
  //           as _StackedColumn100Customization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

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

  // testWidgets(
  //     'Chart Widget - Testing Column Series Sorting - X Axis Ascending',
  //     (WidgetTester tester) async {
  //   final _StackedColumn100Customization chartContainer =
  //       _stackedColumn100Customization('sortingX_Ascending')
  //           as _StackedColumn100Customization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

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

  // testWidgets('Chart Widget - Testing Column Series Sorting Y Axis Ascending',
  //     (WidgetTester tester) async {
  //   final _StackedColumn100Customization chartContainer =
  //       _stackedColumn100Customization('sortingY_Ascending')
  //           as _StackedColumn100Customization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

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

  // testWidgets(
  //     'Chart Widget - Testing Column Series Sorting Y Axis Descendins',
  //     (WidgetTester tester) async {
  //   final _StackedColumn100Customization chartContainer =
  //       _stackedColumn100Customization('sortingY_Descending')
  //           as _StackedColumn100Customization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

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
  // });

  group('Column Series Animation -', () {
    testWidgets('Column series animation with normal position',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Column series animation with transpose',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_transpose')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1400);
    });

    testWidgets('Column series animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_transpose_inverse')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // ignore: unused_local_variable
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets(
        'Column series animation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_transpose_inverse_negative')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets('Column series animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_inverse_negative')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Column series animation with y inversed',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_inverse')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
      expect(chart!.series[1].animationDuration, 1350);
    });

    testWidgets('Column series animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_transpose_negative')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Column series animation with negative y values',
        (WidgetTester tester) async {
      final _StackedColumn100Customization chartContainer =
          _stackedColumn100Customization('animation_negative')
              as _StackedColumn100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });
  });
}

StatelessWidget _stackedColumn100Customization(String sampleName) {
  return _StackedColumn100Customization(sampleName);
}

// class _StackedColumnPoints {
//   _StackedColumnPoints(this.rectValues);
//    List<dynamic> rectValues ;
// }

// ignore: must_be_immutable
class _StackedColumn100Customization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedColumn100Customization(String sampleName) {
    chart = getStackedColumn100Series(sampleName);
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
