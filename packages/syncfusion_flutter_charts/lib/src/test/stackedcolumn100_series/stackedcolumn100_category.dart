import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stackedcolumn100_sample.dart';

/// Test method of category axis of the stacked column 100 series.
void stackedColumn100CategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacked Line Category - Defualt Properties', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_default')
              as _StackedColumn100Category;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
    test('test series count', () {
      expect(chart!.series.length, 2);
    });

    //test('to tesst primaryXAxis labels', () {
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
    //       '0%');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '100%');
    // });

    testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_labelPlacement')
              as _StackedColumn100Category;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
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
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[6].text,
    //       'America');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[8].text,
    //       'Aus');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //       '30%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '40%');
    // });
  });

  group('Bar Category - Axis Elements', () {
    // testWidgets('Category axis - EdgeLabelPlacement',
    //     (WidgetTester tester) async {
    //   final _StackedColumn100Category chartContainer =
    //       _stackedColumn100Category('category_EdgeLabelPlacement')
    //           as _StackedColumn100Category;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

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
    //       '0%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //       '30%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '40%');
    // });

    //Category Axis
    // testWidgets('Category axis - Inversed', (WidgetTester tester) async {
    //   final _StackedColumn100Category chartContainer =
    //       _stackedColumn100Category('category_inversed')
    //           as _StackedColumn100Category;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'India');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //       'Russia');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '40%');
    // });

    //Category Axis
    // testWidgets('Category axis - Opposed', (WidgetTester tester) async {
    //   final _StackedColumn100Category chartContainer =
    //       _stackedColumn100Category('category_opposed')
    //           as _StackedColumn100Category;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels and segment', () {
    //   final CartesianSeries<dynamic,dynamic> cartesianSeries = chart.series[0];
    //   final Rect rect = cartesianSeriesRenderer._dataPoints[0].region;
    //   expect(rect.left.toInt(), 0);
    //   expect(rect.top.toInt(), 323);
    //   expect(rect.right.toInt(), 372);
    //   expect(rect.bottom.toInt(), 624);
    //   expect(_chartState._chartAxis._primaryXAxisRenderer._visibleLabels[0].text, 'India');
    //   expect(_chartState._chartAxis._primaryXAxisRenderer._visibleLabels[4].text, 'Russia');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '40%');
    // });

    //Category Axis
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_label_tickPosition')
              as _StackedColumn100Category;
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
    //       '0%');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '40%');
    // });

    test('to test primaryYAxis ticks position', () {
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    //Category Axis
    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_gridlines')
              as _StackedColumn100Category;
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
      expect(yTick.color, const Color.fromRGBO(255, 87, 34, 1.0));
      expect(yTick.size, 15);
    });

    //Category Axis
    testWidgets('Category Axis - Label Style', (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_labelStyle')
              as _StackedColumn100Category;
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

    //Category Axis
    testWidgets('Category Axis - Visibility', (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_axisVisible')
              as _StackedColumn100Category;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _StackedColumn100Category chartContainer =
          _stackedColumn100Category('category_axisLine_title')
              as _StackedColumn100Category;
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

    test('X axis name property with deualt value', () {
      expect(chart!.primaryXAxis.name, null);
    });

    test('Y axis name property with default value', () {
      expect(chart!.primaryYAxis.name, null);
    });
  });
}

StatelessWidget _stackedColumn100Category(String sampleName) {
  return _StackedColumn100Category(sampleName);
}

// ignore: must_be_immutable
class _StackedColumn100Category extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedColumn100Category(String sampleName) {
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
