import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_doughnut_sample.dart';

/// Testing method for customization of the stacked doughnut series.
void stackedDoughnutCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Stacked Doughnut - Fill, Point Fill Color Mapping', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Stacked Doughnut series with default properties',
        (WidgetTester tester) async {
      final _StackedDoughnutCustomization chartContainer =
          _stackedDoughnutCustomization('customization_default')
              as _StackedDoughnutCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // final List<Color> colors = <Color>[];
    // colors.add(const Color(0xff4b87b9));
    // colors.add(const Color(0xffc06c84));
    // colors.add(const Color(0xfff67280));
    // colors.add(const Color(0xfff8b195));
    // colors.add(const Color(0xff74b49b));

    // test('test slice fill color', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
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
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 114);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 173);
    //   expect(visiblePoint.outerRadius!.toInt(), 191);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Stacked Doughnut series with Point Color Mapping',
    //     (WidgetTester tester) async {
    //   final _StackedDoughnutCustomization chartContainer =
    //       _stackedDoughnutCustomization('customization_pointcolor')
    //           as _StackedDoughnutCustomization;
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
    //   for (int i = 0; i < chart!.series.length; i++) {
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
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 96);
    //   expect(visiblePoint.outerRadius!.toInt(), 114);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 173);
    //   expect(visiblePoint.outerRadius!.toInt(), 191);
    // });
  });

  // group('Stacked Doughnut - Center XY, Start and End Angle', () {
  //   testWidgets(
  //       'Accumulation Chart Widget - Stacked Doughnut series with Center X and Y',
  //       (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('customization_centerXY')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -90);
  //     expect(visiblePoint.midAngle, -90);
  //     expect(visiblePoint.center!.dy.toInt(), 178);
  //     expect(visiblePoint.center!.dx, 517.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 114);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -90);
  //     expect(visiblePoint.midAngle, -90);
  //     expect(visiblePoint.center!.dy.toInt(), 178);
  //     expect(visiblePoint.center!.dx, 517.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 173);
  //     expect(visiblePoint.outerRadius!.toInt(), 191);
  //   });
  //   testWidgets(
  //       'Accumulation Chart Widget - Stakced Doughnut series with Start and End Angle',
  //       (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('customization_start_end_angle')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -90);
  //     expect(visiblePoint.midAngle, -90);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.center!.dx, 400.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 114);
  //   });

  //   test('test the last visible point', () {
  //     final ChartPoint<dynamic> visiblePoint = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
  //         1];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -90);
  //     expect(visiblePoint.midAngle, -90);
  //     expect(visiblePoint.center!.dx, 400.0);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.innerRadius!.toInt(), 173);
  //     expect(visiblePoint.outerRadius!.toInt(), 191);
  //   });

  //   testWidgets(
  //       'Accumulation Chart Widget - Stacked Doughnut series with Stroke',
  //       (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('customization_stroke')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the last visible point', () {
  //     final Color color = _chartState!
  //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].strokeColor;
  //     final double? width = _chartState!._chartSeries.visibleSeriesRenderers[0]
  //         ._renderPoints![0].strokeWidth as double?;
  //     expect(const Color(0xfff44336).value, color.value);
  //     expect(2.0, width);
  //   });
  // });

  group('Stacked Doughnut - Title and Margin', () {
    testWidgets(
        'Accumulation Chart Widget - Stacked Doughnut series with Title',
        (WidgetTester tester) async {
      final _StackedDoughnutCustomization chartContainer =
          _stackedDoughnutCustomization('customization_title')
              as _StackedDoughnutCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test title properties', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'Stacked Doughnut Series');
      expect(title.textStyle.color, Colors.deepPurple);
      expect(title.textStyle.fontSize, 12);
      expect(title.alignment, ChartAlignment.near);
    });

    // testWidgets(
    //     'Accumulation Chart Widget - Stakced Doughnut series with Margin',
    //     (WidgetTester tester) async {
    //   final _StackedDoughnutCustomization chartContainer =
    //       _stackedDoughnutCustomization('customization_margin')
    //           as _StackedDoughnutCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 88);
    //   expect(visiblePoint.outerRadius!.toInt(), 104);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -90);
    //   expect(visiblePoint.midAngle, -90.0);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius!.toInt(), 158);
    //   expect(visiblePoint.outerRadius!.toInt(), 175);
    // });
  });

  // group('Stacked Doughnut - Rounded Corners', () {
  //   testWidgets(
  //       'Accumulation Chart Widget - Stacked Doughnut series with Rounded Corners',
  //       (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('customization_roundedCornder')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('test the first visible point', () {
  //     final ChartPoint<dynamic> visiblePoint =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
  //     expect(visiblePoint.startAngle, -90);
  //     expect(visiblePoint.endAngle, -90);
  //     expect(visiblePoint.midAngle, -90.0);
  //     expect(visiblePoint.center!.dy.toInt(), 250);
  //     expect(visiblePoint.center!.dx, 400.0);
  //     expect(visiblePoint.innerRadius!.toInt(), 96);
  //     expect(visiblePoint.outerRadius!.toInt(), 143);
  //   });
  // });

  // group('Stacked Doughnut - Radius Mapping', () {
  //   testWidgets(
  //       'Accumulation Chart Widget - Testing Stacked Doughnut series with Radius Mapping',
  //       (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('radiusMapping')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('to test point radius', () {
  //     final List<ChartPoint<dynamic>> points =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
  //     expect(points[0].outerRadius!.toInt(), 127);
  //     expect(points[1].outerRadius!.toInt(), 159);
  //     expect(points[2].outerRadius!.toInt(), 191);
  //   });
  // });
  // testWidgets('Stacked Doughnut -  SortField Mapping',
  //     (WidgetTester tester) async {
  //   final _StackedDoughnutCustomization chartContainer =
  //       _stackedDoughnutCustomization('sorting')
  //           as _StackedDoughnutCustomization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCircularChartState?;
  // });

  // test('test point order', () {
  //   final List<ChartPoint<dynamic>> points =
  //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
  //   expect(points[0].x.toString(), 'China');
  //   expect(points[1].x.toString(), 'India');
  //   expect(points[2].x.toString(), 'Japan');
  //   expect(points[3].x.toString(), 'London');
  //   expect(points[4].x.toString(), 'Spain');
  // });
  // group('Corner Style,', () {
  // testWidgets('Radial Bar with both ends curve', (WidgetTester tester) async {
  //   final _StackedDoughnutCustomization chartContainer =
  //       _stackedDoughnutCustomization('corner_bothEnds')
  //           as _StackedDoughnutCustomization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCircularChartState?;
  // });

  // test('to test point angle', () {
  //   final List<ChartPoint<dynamic>> points =
  //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
  //   final double angleDeviation = _findAngleDeviation(
  //       points[0].innerRadius!, points[0].outerRadius!, 360) as double;
  //   expect(angleDeviation + points[0].startAngle!, -82.02626884825109);
  //   expect(angleDeviation + points[0].endAngle!, -82.02626884825109);
  // });

  // testWidgets('Radial Bar with both ends curve', (WidgetTester tester) async {
  //   final _StackedDoughnutCustomization chartContainer =
  //       _stackedDoughnutCustomization('corner_endCurve')
  //           as _StackedDoughnutCustomization;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCircularChartState?;
  // });

  // test('to test point angle', () {
  //   final List<ChartPoint<dynamic>> points =
  //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
  //   final double angleDeviation = _findAngleDeviation(
  //       points[0].innerRadius!, points[0].outerRadius!, 360) as double;
  //   expect(angleDeviation + points[0].startAngle!, -82.02626884825109);
  //   expect(angleDeviation + points[0].endAngle!, -82.02626884825109);
  // });

  //   testWidgets('Radial Bar with both ends curve', (WidgetTester tester) async {
  //     final _StackedDoughnutCustomization chartContainer =
  //         _stackedDoughnutCustomization('corner_startCurve')
  //             as _StackedDoughnutCustomization;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCircularChartState?;
  //   });

  //   test('to test point angle', () {
  //     final List<ChartPoint<dynamic>> points =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
  //     final double angleDeviation = _findAngleDeviation(
  //         points[0].innerRadius!, points[0].outerRadius!, 360) as double;
  //     expect(angleDeviation + points[0].startAngle!, -82.02626884825109);
  //     expect(angleDeviation + points[0].endAngle!, -82.02626884825109);
  //   });
  // });
}

StatelessWidget _stackedDoughnutCustomization(String sampleName) {
  return _StackedDoughnutCustomization(sampleName);
}

// ignore: must_be_immutable
class _StackedDoughnutCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedDoughnutCustomization(String sampleName) {
    chart = getStackedDoughnut(sampleName);
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
