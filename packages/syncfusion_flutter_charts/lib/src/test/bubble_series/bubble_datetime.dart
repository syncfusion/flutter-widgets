import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bubble_sample.dart';

/// Testing method for date time axis of the bubble series.
void bubbleDateTimeAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bubble Date Time - Range and Range Padding', () {
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_default') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // // to test series count
    // test('test series count', () {
    //   expect(chart!.series.length, 1);
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('Datetime axis - With Range', (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_range') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('Datetime axis - RangePadding Additional',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_rangepadding_add') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jul 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Feb 1');
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

    testWidgets('Datetime axis - RangePadding Normal',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_rangepadding_normal') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('Datetime axis - RangePadding Round',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_rangepadding_round') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Nov 30');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 2');
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

    testWidgets('Datetime axis - RangePadding Round',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_rangepadding_none') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('Datetime axis - RangePadding Auto',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_rangepadding_auto') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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
  });

  group('Bubble Date Time - LabelPlacement and EdgeLabelPlacment', () {
    testWidgets('DateTime axis - EdgeLabelPlacement',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_edgelabelPlacement_hide')
              as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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
  });

  group('Bubble Data Time - Grids, Ticks and Axis Elements', () {
    testWidgets('DateTime Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_axisLine_title') as _BubbleDateTime;
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

    testWidgets('DateTime axis - Inversed', (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_inversed') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('DateTime axis - Opposed', (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_opposed') as _BubbleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Sep 1');
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

    testWidgets('DateTime Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_gridlines') as _BubbleDateTime;
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

    testWidgets('DateTime Axis - Label Style', (WidgetTester tester) async {
      final _BubbleDateTime chartContainer =
          _bubbleDateTime('datetime_labelStyle') as _BubbleDateTime;
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

    // testWidgets('DateTime Axis - Visibility', (WidgetTester tester) async {
    //   final _BubbleDateTime chartContainer =
    //       _bubbleDateTime('datetime_axisVisible') as _BubbleDateTime;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test(
    //     'to test primaryXAxis visible labels count with axis visibility to false',
    //     () {
    //   //Commented the below line since when axis visibility is false, thenthere should not be any visible labels,
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

StatelessWidget _bubbleDateTime(String sampleName) {
  return _BubbleDateTime(sampleName);
}

// ignore: must_be_immutable
class _BubbleDateTime extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BubbleDateTime(String sampleName) {
    chart = getBubblechart(sampleName);
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
