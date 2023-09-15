import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'step_line_sample.dart';

/// Test method of category axis of the step line series.
void stepLineCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Step Line Category - Defualt', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_default') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'India');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
    //       'Japan');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //       'Russia');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //       '15');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });
  });

  // group(
  //     'Step Line Category - LabelPlacement, EdgeLabelPlacement, Inversed, Opposed',
  //     () {
  //   testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
  //     final _StepLineCategory chartContainer =
  //         _stepLineCategory('category_labelPlacement') as _StepLineCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'India');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
  //         'Japan');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         'Russia');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
  //         '15');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '20');
  //   });

  //   //Category Axis
  //   testWidgets('Category axis - EdgeLabelPlacement',
  //       (WidgetTester tester) async {
  //     final _StepLineCategory chartContainer =
  //         _stepLineCategory('category_EdgeLabelPlacement') as _StepLineCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'India');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
  //         'Japan');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         'Russia');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
  //         '15');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '20');
  //   });

  //   testWidgets('Category axis - Inversed', (WidgetTester tester) async {
  //     final _StepLineCategory chartContainer =
  //         _stepLineCategory('category_inversed') as _StepLineCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'India');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         'Russia');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '20');
  //   });

  //   testWidgets('Category axis - Opposed', (WidgetTester tester) async {
  //     final _StepLineCategory chartContainer =
  //         _stepLineCategory('category_opposed') as _StepLineCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels and segment', () {
  //     final CartesianSeriesRenderer cartesianSeriesRenderer =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0];
  //     final StepLineSegment segment =
  //         cartesianSeriesRenderer._segments[0] as StepLineSegment;
  //     expect(segment._x1.toInt(), 74);
  //     expect(segment._y1.toInt(), 256);
  //     expect(segment._x2.toInt(), 223);
  //     expect(segment._y2.toInt(), 323);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'India');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         'Russia');
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

  group('Step Line Category- Grids, Ticks, Axis Elements', () {
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_label_tickPosition') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'India');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //       'Russia');
    // });

    test('to test primaryXAxis ticks position', () {
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    test('to test primaryYAxis ticks position', () {
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_gridlines') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis major grid line properties', () {
      final MajorGridLines xGrid = chart!.primaryXAxis.majorGridLines;
      expect(xGrid.width, 2);
      expect(xGrid.color, const Color.fromRGBO(244, 67, 54, 1.0));
      expect(xGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryXAxis major tick line properties', () {
      final MajorTickLines xTick = chart!.primaryXAxis.majorTickLines;
      expect(xTick.width, 2);
      expect(xTick.color, const Color.fromRGBO(255, 87, 34, 1.0));
      expect(xTick.size, 15);
    });

    test('to test primaryYAxis major grid line properties', () {
      final MajorGridLines yGrid = chart!.primaryYAxis.majorGridLines;
      expect(yGrid.width, 3);
      expect(yGrid.color!.value, 4283215696);
      expect(yGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryYAxis major tick line properties', () {
      final MajorTickLines yTick = chart!.primaryXAxis.majorTickLines;
      expect(yTick.width, 2);
      expect(yTick.color!.value, 4294924066);
      expect(yTick.size, 15);
    });

    testWidgets('Category Axis - Label Style', (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_labelStyle') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis label style properties', () {
    //   final AxisLabel label =
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0];
    //   expect(label.labelStyle.fontSize, 12);
    //   expect(label.labelStyle.color!.value, 4294198070);
    //   expect(label.labelStyle.fontStyle, FontStyle.italic);
    // });

    // test('to test primaryYAxis label style properties', () {
    //   final AxisLabel label =
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0];
    //   expect(label.labelStyle.fontSize, 12);
    //   expect(label.labelStyle.color!.value, 4283215696);
    //   expect(label.labelStyle.fontStyle, FontStyle.italic);
    // });

    testWidgets('Category Axis - Visibility', (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_axisVisible') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test(
    //     'to test primaryXAxis visible labels count with axis visibility to false',
    //     () {
    //   final List<AxisLabel> label =
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels;
    //   expect(label.length, 0);
    // });

    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _StepLineCategory chartContainer =
          _stepLineCategory('category_axisLine_title') as _StepLineCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis line properties', () {
      final AxisLine line = chart!.primaryXAxis.axisLine;
      expect(line.color!.value, 4294198070);
      expect(line.dashArray, <double>[10, 20]);
      expect(line.width, 3);
    });

    test('to test primaryYAxis line properties', () {
      final AxisLine line = chart!.primaryYAxis.axisLine;
      expect(line.color!.value, 4294198070);
      expect(line.dashArray, <double>[10, 20]);
      expect(line.width, 3);
    });

    test('To test primaryXAxis title properties', () {
      final AxisTitle title = chart!.primaryXAxis.title;
      expect(title.text, 'Primary X Axis');
      expect(title.alignment, ChartAlignment.center);
      // expect(title.textStyle.fontSize, 15);
    });

    test('To test primaryYAxis title properties', () {
      final AxisTitle title = chart!.primaryYAxis.title;
      expect(title.text, 'Primary Y Axis');
      expect(title.alignment, ChartAlignment.center);
      // expect(title.textStyle.fontSize, 15);
    });

    // test('X axis name property with deualt value', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._name, 'primaryXAxis');
    //   expect(chart!.primaryXAxis.name, null);
    // });

    // test('Y axis name property with default value', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._name, 'primaryYAxis');
    //   expect(chart!.primaryYAxis.name, null);
    // });
  });
}

StatelessWidget _stepLineCategory(String sampleName) {
  return _StepLineCategory(sampleName);
}

// ignore: must_be_immutable
class _StepLineCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StepLineCategory(String sampleName) {
    chart = getStepLine(sampleName);
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
