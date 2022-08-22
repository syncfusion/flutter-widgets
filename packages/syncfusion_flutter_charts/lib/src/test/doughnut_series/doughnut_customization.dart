import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'doughnut_sample.dart';

/// Testing method for customization of the doughnut series.
void doughnutCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Doughnut - Fill, Point Color Mapping, Stroke', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with default properties',
        (WidgetTester tester) async {
      final _DoughnutCustomization chartContainer =
          _doughnutCustomization('customization_default')
              as _DoughnutCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    final List<Color> colors = <Color>[];
    colors.add(const Color(0xff4b87b9));
    colors.add(const Color(0xffc06c84));
    colors.add(const Color(0xfff67280));
    colors.add(const Color(0xfff8b195));
    colors.add(const Color(0xff74b49b));

    // test('test slice fill color', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     for (int j = 0;
    //         j <
    //             _chartState!._chartSeries.visibleSeriesRenderers[i]
    //                 ._renderPoints!.length;
    //         j++) {
    //       final Color? fillColor = _chartState!
    //           ._chartSeries.visibleSeriesRenderers[i]._renderPoints![j].fill;
    //       expect(fillColor, colors[j]);
    //     }
    //   }
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle!.toInt(), -27);
    //   expect(visiblePoint.midAngle!.toInt(), -58);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets('Accumulation Chart Widget - Doughnut series with Stroke',
    //     (WidgetTester tester) async {
    //   final _DoughnutCustomization chartContainer =
    //       _doughnutCustomization('customization_stroke')
    //           as _DoughnutCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the last visible point', () {
    //   final Color color = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].strokeColor;
    //   final double? width = _chartState!._chartSeries.visibleSeriesRenderers[0]
    //       ._renderPoints![0].strokeWidth as double?;
    //   expect(const Color(0xfff44336).value, color.value);
    //   expect(width, 2.0);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Doughnut series with Point Color Mapping',
    //     (WidgetTester tester) async {
    //   final _DoughnutCustomization chartContainer =
    //       _doughnutCustomization('customization_pointcolor')
    //           as _DoughnutCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // final List<int> pointColors = <int>[];
    // pointColors.add(const Color(0xffff5722).value);
    // pointColors.add(const Color(0xff673ab7).value);
    // pointColors.add(const Color(0xff8bc34a).value);
    // pointColors.add(const Color(0xfff44336).value);
    // pointColors.add(const Color(0xff9c27b0).value);

    // test('test slice fill color', () {
    //   for (int i = 0;
    //       i < _chartState!._chartSeries.visibleSeriesRenderers.length;
    //       i++) {
    //     for (int j = 0;
    //         j <
    //             _chartState!._chartSeries.visibleSeriesRenderers[i]
    //                 ._renderPoints!.length;
    //         j++) {
    //       final Color fillColor = _chartState!
    //           ._chartSeries.visibleSeriesRenderers[i]._renderPoints![j].fill;
    //       expect(fillColor.value, pointColors[j]);
    //     }
    //   }
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });
  });

  // group('Doughnut - Center XY, Start and End Angle', () {
  //   testWidgets(
  //       'Accumulation Chart Widget - Doughnut series with Start and End Angle',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_start_end_angle')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -45);
  //     expect(visiblePoint.endAngle, -0.6521739130434767);
  //     expect(visiblePoint.midAngle, -22.82608695652174);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.center!.dx, 400);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, 135.16304347826087);
  //     expect(visiblePoint.endAngle, 210.0);
  //     expect(visiblePoint.midAngle, 172.58152173913044);
  //     expect(visiblePoint.center!.dx, 400);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   testWidgets(
  //       'Accumulation Chart Widget - Doughnut series with Center X and Y',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_centerXY')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -27.391304347826086);
  //     expect(visiblePoint.midAngle, -58.69565217391305);
  //     expect(visiblePoint.center!.dy.toInt(), 178);
  //     expect(visiblePoint.center!.dx, 517.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, 164.3478260869565);
  //     expect(visiblePoint.endAngle, 270.0);
  //     expect(visiblePoint.midAngle, 217.17391304347825);
  //     expect(visiblePoint.center!.dy.toInt(), 178);
  //     expect(visiblePoint.center!.dx, 517.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });
  // });

  group('Doughnut - Title and Margin', () {
    testWidgets('Accumulation Chart Widget - Doughnut series with Title',
        (WidgetTester tester) async {
      final _DoughnutCustomization chartContainer =
          _doughnutCustomization('customization_title')
              as _DoughnutCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test title properties', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'Doughnut Series');
      expect(title.textStyle.color, Colors.deepPurple);
      expect(title.textStyle.fontSize, 12);
      expect(title.alignment, ChartAlignment.near);
    });

    testWidgets('Accumulation Chart Widget - Doughnut series with Margin',
        (WidgetTester tester) async {
      final _DoughnutCustomization chartContainer =
          _doughnutCustomization('customization_margin')
              as _DoughnutCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx.toInt(), 514);
    //   expect(visiblePoint.innerRadius!.toInt(), 88);
    //   expect(visiblePoint.outerRadius!.toInt(), 176);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 88);
    //   expect(visiblePoint.outerRadius!.toInt(), 176);
    // });
  });

  // group('Doughnut Explode', () {
  //   testWidgets('Accumulation Chart Widget - Doughnut series with Explode',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_explode')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -27.391304347826086);
  //     expect(visiblePoint.midAngle, -58.69565217391305);
  //     expect(visiblePoint.center!.dx.toInt(), 409);
  //     expect(visiblePoint.center!.dy.toInt(), 234);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, 164.3478260869565);
  //     expect(visiblePoint.endAngle, 270.0);
  //     expect(visiblePoint.midAngle, 217.17391304347825);
  //     expect(visiblePoint.center!.dx, 400.0);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   testWidgets('Accumulation Chart Widget - Doughnut series with Explode All',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_explodeAll')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -27.391304347826086);
  //     expect(visiblePoint.midAngle, -58.69565217391305);
  //     expect(visiblePoint.center!.dx.toInt(), 409);
  //     expect(visiblePoint.center!.dy.toInt(), 234);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, 164.3478260869565);
  //     expect(visiblePoint.endAngle, 270.0);
  //     expect(visiblePoint.midAngle, 217.17391304347825);
  //     expect(visiblePoint.center!.dx.toInt(), 384);
  //     expect(visiblePoint.center!.dy.toInt(), 238);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 192);
  //   });
  // });

  // group('Doughnut - Grouping', () {
  //   testWidgets(
  //       'Accumulation Chart Widget - Doughnut series with Grouping Mode Point',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_groupPoint')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test group mode - point', () {
  //     final int pointlength = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
  //     expect(pointlength, 2);
  //   });

  //   testWidgets(
  //       'Accumulation Chart Widget - Doughnut series with Grouping Mode Value',
  //       (WidgetTester tester) async {
  //     final _DoughnutCustomization chartContainer =
  //         _doughnutCustomization('customization_groupValue')
  //             as _DoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test group mode - value', () {
  //     final int pointlength = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
  //     expect(pointlength, 3);
  //   });
  // });
}

StatelessWidget _doughnutCustomization(String sampleName) {
  return _DoughnutCustomization(sampleName);
}

// ignore: must_be_immutable
class _DoughnutCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DoughnutCustomization(String sampleName) {
    chart = getDoughnutchart(sampleName);
  }
  SfCircularChart? chart;

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
