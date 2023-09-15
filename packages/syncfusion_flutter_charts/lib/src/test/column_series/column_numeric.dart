import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'column_sample.dart';

/// Test method for numeric axis of the column series.
void columnNumericAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Numeric - Range and Range Padding', () {
    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_default') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 0);
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
    //       '1.5');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //       '2');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //       '1.5');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '2');
  });

  // Line series with data
  testWidgets('Numeric axis - With Data', (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_defaultData') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '1');
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //       '3');
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

  testWidgets('Numeric axis - With Range', (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_range') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '0');
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[2].text,
  //       '2');
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //       '4');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '1');
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //       '21');
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //       '41');
  // });

  testWidgets('Numeric axis - RangePadding with Additional',
      (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_rangePadding_Add') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '0.5');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '5.5');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '22');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '56');
  // });

  testWidgets('Numeric axis - RangePadding Normal',
      (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_rangePadding_Normal') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '0');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '5.5');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '0');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '60');
  // });

  testWidgets('Numeric axis - RangePadding Round', (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_rangePadding_Round') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '5');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '24');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '54');
  // });

  testWidgets('Numeric axis - With RangePadding Auto',
      (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_rangePadding_Auto') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '1');
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
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '60');
  // });

  testWidgets('Numeric axis - RangePadding None', (WidgetTester tester) async {
    final _ColumnNumeric chartContainer =
        _columnNumeric('numeric_rangePadding_None') as _ColumnNumeric;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
  });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '5');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '24');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '54');
  // });
  // });

  group('Column - Grids, Lines and Axis Elements', () {
    testWidgets('Numeric axis - EdgeLabelPlacement',
        (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_edgelabelPlacement_hide') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '1');
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
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '60');
    // });

    testWidgets('Numeric Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_axisLine_title') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

    testWidgets('Numeric axis - Inversed', (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_inversed') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '1');
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
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '60');
    // });

    testWidgets('Numeric axis - Opposed', (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_opposed') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '1');
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
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '60');
    // });

    testWidgets('Numeric Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_gridlines') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

    testWidgets('Numeric Axis - Label Style', (WidgetTester tester) async {
      final _ColumnNumeric chartContainer =
          _columnNumeric('numeric_labelStyle') as _ColumnNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

    // testWidgets('Numeric Axis - Visibility', (WidgetTester tester) async {
    //   final _ColumnNumeric chartContainer =
    //       _columnNumeric('numeric_axisVisible') as _ColumnNumeric;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test(
    //     'to test primaryXAxis visible labels count with axis visibility to false',
    //     () {
    //   final List<AxisLabel> label =
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels;
    //   final Rect axisClipRect = _chartState!._chartAxis._axisClipRect;
    //   expect(label.length, 0);
    //   expect(chart!.primaryXAxis.isVisible, false);
    //   expect(axisClipRect.left.toInt(), 0);
    //   expect(axisClipRect.top.toInt(), 0);
    //   expect(axisClipRect.right.toInt(), 780);
    //   expect(axisClipRect.bottom.toInt(), 524);
    // });
  });
}

StatelessWidget _columnNumeric(String sampleName) {
  return _ColumnNumeric(sampleName);
}

// ignore: must_be_immutable
class _ColumnNumeric extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ColumnNumeric(String sampleName) {
    chart = getColumnchart(sampleName);
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
