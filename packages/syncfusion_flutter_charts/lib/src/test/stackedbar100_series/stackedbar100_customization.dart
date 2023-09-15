import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stackedbar100_sample.dart';

/// Testing method for customization of the stacked bar 100 series.
void stackedBar100Customization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacked Bar - Fill, Point Color Mapping', () {
    // Column series
    testWidgets('Chart Widget - Testing stack bar series with default colors',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('customization_default')
              as _StackedBar100Customization;
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
    //     'Chart Widget - Testing stacked bar series with Fill and PointColorMapping',
    //     (WidgetTester tester) async {
    //   final _StackedBar100Customization chartContainer =
    //       _stackedBar100Customization('customization_fill_pointcolor')
    //           as _StackedBar100Customization;
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
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 0);
    //     }
    //   }
    // });

// Column series
    // testWidgets('Chart Widget - Testing stacked bar with Fill',
    //     (WidgetTester tester) async {
    //   final _StackedBar100Customization chartContainer =
    //       _stackedBar100Customization('customization_fill')
    //           as _StackedBar100Customization;
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
    //       expect(strokeColor, const Color(0xfff44336));
    //       expect(strokeWidth, 3.0);
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
    // testWidgets('Chart Widget - Testing Stacked bar with Point Color Mapping ',
    //     (WidgetTester tester) async {
    //   final _StackedBar100Customization chartContainer =
    //       _stackedBar100Customization('customization_pointColor')
    //           as _StackedBar100Customization;
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
    //       expect(strokeColor, const Color(0x00000000));
    //     }
    //   }
    // });
  });

  // testWidgets(
  //     'Chart Widget - Testing stacked bar100 series with point color mapping',
  //     (WidgetTester tester) async {
  //   final _StackedBar100Marker chartContainer =
  //       _stackedBar100Marker('marker_PointColormapping')
  //           as _StackedBar100Marker;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test point color mapping properties', () {
  //   final List<CartesianSeriesRenderer?> cartesianSeries =
  //       _chartState!._chartSeries.visibleSeriesRenderers;
  //   cartesianSeries[0]!
  //       ._regionalData!
  //       .forEach((dynamic k, dynamic v) => expect(k[2], Colors.blue));
  //   cartesianSeries[1]!
  //       ._regionalData!
  //       .forEach((dynamic k, dynamic v) => expect(k[2], Colors.red));
  // });

  // group('Stacked Bar - Corner Radius', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Column Series with Corner Radius',
  //       (WidgetTester tester) async {
  //     final _StackedBar100Customization chartContainer =
  //         _stackedBar100Customization('customization_cornerradius')
  //             as _StackedBar100Customization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   final List<RRect> pointRect = <RRect>[];
  //   final List<RRect> pointRect1 = <RRect>[];

  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 439.8, 363.2, 491.0, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 366, 349.7, 417.9, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 293, 368.9, 344.8, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 179.8, 336.7, 230.9, const Radius.circular(5)));
  //   pointRect.add(
  //       RRect.fromLTRBR(46.0, 84.0, 496.0, 135.2, const Radius.circular(5)));

  //   pointRect1
  //       .add(RRect.fromLTRBR(363, 366.8, 780, 417.9, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(349.8, 293.7, 780.0, 344.8, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(368.9, 220.6, 780.0, 271.8, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(336.8, 106.8, 780.0, 157.8, const Radius.circular(5)));
  //   pointRect1.add(
  //       RRect.fromLTRBR(496.0, 10.96, 780.0, 62.1, const Radius.circular(5)));

  //   final List<_ChartDataValues> _stackedColumnPoints2 =
  //       _getPointsValues(pointRect, pointRect1);

  //   test('test column rounded corners', () {
  //     for (int i = 0; i < chart!.series.length; i++) {
  //       final CartesianSeriesRenderer cartesianSeriesRenderer =
  //           _chartState!._chartSeries.visibleSeriesRenderers[i];
  //       for (int j = 0; j < cartesianSeriesRenderer._segments.length; j++) {
  //         final StackedBar100Segment segment =
  //             cartesianSeriesRenderer._segments[j] as StackedBar100Segment;
  //         final RRect columnRect = segment.segmentRect;
  //         expect(_stackedColumnPoints2[i].rectValues[j].left.toInt(),
  //             columnRect.left.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].top.toInt(),
  //             columnRect.top.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].right.toInt(),
  //             columnRect.right.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].bottom.toInt(),
  //             columnRect.bottom.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].blRadius.x.toInt(),
  //             columnRect.blRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].blRadius.y.toInt(),
  //             columnRect.blRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].brRadius.x.toInt(),
  //             columnRect.brRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].brRadius.y.toInt(),
  //             columnRect.brRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.x.toInt(),
  //             columnRect.tlRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].tlRadius.y.toInt(),
  //             columnRect.tlRadius.y.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].trRadius.x.toInt(),
  //             columnRect.trRadius.x.toInt());
  //         expect(_stackedColumnPoints2[i].rectValues[j].trRadius.y.toInt(),
  //             columnRect.trRadius.y.toInt());
  //       }
  //     }
  //   });
  // });

  // group('Stacked Bar - Gradient Colors', () {
  //   // Column series
  //   testWidgets('Chart Widget - Testing Stacked Bar with Gradient Colors',
  //       (WidgetTester tester) async {
  //     final _StackedBar100Customization chartContainer =
  //         _stackedBar100Customization('customization_gradientColor')
  //             as _StackedBar100Customization;
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

  group('Stacked Bar Animation -', () {
    testWidgets('Stacked Bar animation with normal position',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
    });

    testWidgets('Stacked Bar animation with transpose',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_transpose')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1500);
      expect(chart!.series[1].animationDuration, 1500);
    });

    testWidgets('Stacked Bar animation with transpose and y inversed',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_transpose_inverse')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1400);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets(
        'Stacked Baranimation with transpose, y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_transpose_inverse_negative')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1200);
      expect(chart!.series[1].animationDuration, 1300);
    });

    testWidgets('Stacked Bar animation with y inversed and negative values',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_inverse_negative')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Stacked bar animation with y inversed',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_inverse')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1250);
      expect(chart!.series[1].animationDuration, 1350);
    });

    testWidgets('Stacked bar animation with transpose and negative y values',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _stackedBar100Customization('animation_transpose_negative')
              as _StackedBar100Customization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1350);
      expect(chart!.series[1].animationDuration, 1250);
    });

    testWidgets('Stacked bar animation with negative y values',
        (WidgetTester tester) async {
      final _StackedBar100Customization chartContainer =
          _StackedBar100Customization('animation_negative');
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test animation duration', () {
      expect(chart!.series[0].animationDuration, 1150);
      expect(chart!.series[1].animationDuration, 1250);
    });
  });
}

StatelessWidget _stackedBar100Customization(String sampleName) {
  return _StackedBar100Customization(sampleName);
}

// ignore: must_be_immutable
class _StackedBar100Customization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedBar100Customization(String sampleName) {
    chart = getStackedBar100Chart(sampleName);
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
