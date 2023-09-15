import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the numeric axis.
void numericAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  // group('Numeric Axis - Range and Range Padding', () {
  //   testWidgets('Visible Min and Max', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_visibleMinMax') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   testWidgets('Numeric axis - Zoom Factor and Position',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_ZoomFactorPosition') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '3');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '4.8');
  //   });

  //   testWidgets('Numeric axis - With Range', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_range') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[2].text,
  //         '2');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         '4');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //         '21');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '41');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 70);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 70);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Numeric axis - With Equal Range', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_equalrange') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '1.9');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   testWidgets('Numeric axis - With Equal Range', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_min_greater') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '10');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '70');
  //   });

  //   testWidgets('Numeric axis - RangePadding with Additional',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_Add') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0.5');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5.5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '22');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '56');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 16);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 762);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Numeric axis - RangePadding Normal',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_Normal') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5.5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 762);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Numeric axis - RangePadding Round',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_Round') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '24');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '54');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Numeric axis - With RangePadding Auto',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_Auto') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Numeric axis - RangePadding None',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_None') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '24');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '54');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // group('Numeric Axis - title Alignment ', () {
  //   testWidgets('Axis title alignment far', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_axisTitle_align_far') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test alignment', () {
  //     expect(chart!.primaryXAxis.title.alignment, ChartAlignment.far);
  //     expect(chart!.primaryYAxis.title.alignment, ChartAlignment.far);
  //   });
  //   testWidgets('Axis title alignment near', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_axisTitle_align_near') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test alignment', () {
  //     expect(chart!.primaryXAxis.title.alignment, ChartAlignment.near);
  //     expect(chart!.primaryYAxis.title.alignment, ChartAlignment.near);
  //   });
  // });

  //   testWidgets('Numeric axis - RangePadding Normal with Negative Values',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_rangePadding_Normal_Negative') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Dec 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Sep 1');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '-30');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 16);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 704);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('NUmeric Axis - EdgeLabelPlacement', () {
  //   testWidgets('Numeric axis - EdgeLabelPlacement Hide',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_edgelabelPlacement_hide') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //     expect(region, const Rect.fromLTRB(28.0, 510.0, 40.0, 522.0));
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(774.0, 510.0, 786.0, 522.0));
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion;
  //     expect(region, null);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, null);
  //   });

  //   testWidgets('Numeric axis - EdgeLabelPlacement Shift',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_edgelabelPlacement_shift') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 34);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 768);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 490);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 0);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  group('Numeric Axis - Grids, Ticks and Axis Elements', () {
    testWidgets('Numeric Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_axisLine_title') as _AxisNumeric;
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

    test('X axis name property with default value', () {
      expect(chart!.primaryXAxis.name, null);
    });

    test('Y axis name property with default value', () {
      expect(chart!.primaryYAxis.name, null);
    });

    testWidgets('Numeric Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_gridlines') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis major grid line properties', () {
      final MajorGridLines xGrid = chart!.primaryXAxis.majorGridLines;
      expect(xGrid.width, 2);
      expect(xGrid.color!.value, const Color.fromRGBO(244, 67, 54, 1.0).value);
      expect(xGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryXAxis major tick line properties', () {
      final MajorTickLines xTick = chart!.primaryXAxis.majorTickLines;
      expect(xTick.width, 2);
      expect(xTick.color!.value, const Color.fromRGBO(255, 87, 34, 1.0).value);
      expect(xTick.size, 15);
    });

    test('to test primaryYAxis major grid line properties', () {
      final MajorGridLines yGrid = chart!.primaryYAxis.majorGridLines;
      expect(yGrid.width, 3);
      expect(yGrid.color!.value, const Color.fromRGBO(76, 175, 80, 1.0).value);
      expect(yGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryYAxis major tick line properties', () {
      final MajorTickLines yTick = chart!.primaryXAxis.majorTickLines;
      expect(yTick.width, 2);
      expect(yTick.color!.value, const Color.fromRGBO(255, 87, 34, 1.0).value);
      expect(yTick.size, 15);
    });

    // testWidgets('Numeric Axis - Label Style', (WidgetTester tester) async {
    //   final _AxisNumeric chartContainer =
    //       _axisNumeric('numeric_labelStyle') as _AxisNumeric;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis label style properties', () {
    //   final AxisLabel label =
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0];
    //   expect(label.labelStyle.fontSize, 12);
    //   expect(label.labelStyle.color!.value, const Color(0xfff44336).value);
    //   expect(label.labelStyle.fontStyle, FontStyle.italic);
    // });

    // test('to test primaryYAxis label style properties', () {
    //   final AxisLabel label =
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0];
    //   expect(label.labelStyle.fontSize, 12);
    //   expect(label.labelStyle.color!.value, const Color(0xff4caf50).value);
    //   expect(label.labelStyle.fontStyle, FontStyle.italic);
    // });

    // testWidgets('Numeric Axis - Visibility', (WidgetTester tester) async {
    //   final _AxisNumeric chartContainer =
    //       _axisNumeric('numeric_axisVisible') as _AxisNumeric;
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

    // testWidgets('Numeric axis - Plotoffset', (WidgetTester tester) async {
    //   final _AxisNumeric chartContainer =
    //       _axisNumeric('numeric_plotoffset') as _AxisNumeric;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis transposed', () {
    //   expect(chart!.primaryXAxis.plotOffset.toInt(), 100);
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5');
    // });

    // test('to test primaryYAxis transposed', () {
    //   expect(chart!.primaryYAxis.plotOffset.toInt(), 50);
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '60');
    // });

    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 128);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 674);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), 446);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), 44);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    testWidgets('Numeric Axis - Minor Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_minorgridtick') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis minor grid line properties', () {
      final MinorGridLines xGrid = chart!.primaryXAxis.minorGridLines;
      expect(xGrid.width, 2);
      expect(xGrid.color, const Color.fromRGBO(244, 67, 54, 1.0));
      expect(xGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryXAxis minor tick line properties', () {
      final MinorTickLines xTick = chart!.primaryXAxis.minorTickLines;
      expect(xTick.width, 2);
      expect(xTick.color!.value, const Color.fromRGBO(255, 87, 34, 1.0).value);
      expect(xTick.size, 15);
    });

    test('to test primaryYAxis minor grid line properties', () {
      final MinorGridLines yGrid = chart!.primaryYAxis.minorGridLines;
      expect(yGrid.width, 3);
      expect(yGrid.color!.value, const Color.fromRGBO(76, 175, 80, 1.0).value);
      expect(yGrid.dashArray, <double>[10, 20]);
    });

    test('to test primaryYAxis minor tick line properties', () {
      final MinorTickLines yTick = chart!.primaryXAxis.minorTickLines;
      expect(yTick.width, 2);
      expect(yTick.color!.value, const Color.fromRGBO(255, 87, 34, 1.0).value);
      expect(yTick.size, 15);
    });
  });

  // group('Numeric Axis - Inversed', () {
  //   testWidgets('Numeric axis - Inversed', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_inversed') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 774);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Numeric Axis - Opposed', () {
  //   testWidgets('Numeric axis - Opposed', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_opposed') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), -6);
  //     expect(region.top.toInt(), 22);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 720);
  //     expect(region.top.toInt(), 22);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 736);
  //     expect(region.top.toInt(), 518);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 736);
  //     expect(region.top.toInt(), 36);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Numeric Axis - Transposed', () {
  //   testWidgets('Numeric axis - Transpose', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_transpose') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis transposed', () {
  //     expect(_chartState!._chartAxis._primaryXAxisRenderer._orientation,
  //         AxisOrientation.vertical);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '5');
  //   });

  //   test('to test primaryYAxis transposed', () {
  //     expect(_chartState!._chartAxis._primaryYAxisRenderer._orientation,
  //         AxisOrientation.horizontal);
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 24);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 24);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 40);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 768);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Numeric Axis Label Rotation Positive -', () {
  //   testWidgets('Label rotation greater than 90', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_greater_90') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, 110);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });
  //   testWidgets('Label rotation greater than 180', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_greater_180') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, 200);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });
  //   testWidgets('Label rotation greater than 360', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_greater_360') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, 400);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });
  // });

  // group('Numeric Axis Label Rotation Negative -', () {
  //   testWidgets('Label rotation with negative 45', (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_negative_45') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, -45);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });

  //   testWidgets('Label rotation with negative 120',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_negative_120') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, -120);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });

  //   testWidgets('Label rotation with negative 230',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_negative_230') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, -230);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });

  //   testWidgets('Label rotation with negative 320',
  //       (WidgetTester tester) async {
  //     final _AxisNumeric chartContainer =
  //         _axisNumeric('numeric_labelrotation_negative_320') as _AxisNumeric;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis labels', () {
  //     expect(chart!.primaryXAxis.labelRotation, -320);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '1');
  //   });
  // });
  group('Numeric Axis- LabelIntersectAction', () {
    //   testWidgets('Numeric axis - Label Intersection - Hide',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_labelIntersect_hide') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         '1');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //         '5');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });

    //   testWidgets('Numeric axis - Label Intersection - Multiple Rows',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_labelIntersect_multiple') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         '1');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //         '5');
    //   });

    //   test('to test primaryXAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 28);
    //     expect(region.top.toInt(), 510);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 774);
    //     expect(region.top.toInt(), 510);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 12);
    //     expect(region.top.toInt(), 496);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 0);
    //     expect(region.top.toInt(), -6);
    //     expect(region.width.toInt(), 24);
    //     expect(region.height.toInt(), 12);
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });

    //   testWidgets('Numeric axis - Label Intersection - None',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_labelIntersect_none') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         '1');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //         '5');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });

    //   testWidgets('Numeric axis - Label Intersection - Multiple Rows',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_labelIntersect_45') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         '1');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //         '5');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });

    //   testWidgets('Numeric axis - Label Intersection - Multiple Rows',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_labelIntersect_90') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         '1');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //         '5');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });
    // });

    // group('Numeric Axis - Multiple Axis', () {
    //   testWidgets('Numeric axis - Multiple Axis', (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('numeric_multipleAxis') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test secondary axes', () {
    //     expect(_chartState!._chartAxis._axisRenderersCollection.length, 4);
    //     expect(_chartState!._chartAxis._axisRenderersCollection[2]._axis.name,
    //         'xAxis');
    //     expect(_chartState!._chartAxis._axisRenderersCollection[3]._axis.name,
    //         'yAxis');
    //     expect(_chartState!._chartAxis._axisRenderersCollection[2]._orientation,
    //         AxisOrientation.horizontal);
    //     expect(_chartState!._chartAxis._axisRenderersCollection[3]._orientation,
    //         AxisOrientation.vertical);
    //     expect(
    //         _chartState!
    //             ._chartAxis._axisRenderersCollection[2]._axis.opposedPosition,
    //         true);
    //     expect(
    //         _chartState!
    //             ._chartAxis._axisRenderersCollection[3]._axis.opposedPosition,
    //         true);
    //   });

    //   testWidgets('Numeric axis - Multiple Axis', (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('multipleAxis') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test axis rect', () {
    //     final Rect rect = _chartState!._chartAxis._axisClipRect;
    //     expect(rect.left.toInt(), 68);
    //     expect(rect.top.toInt(), 0);
    //     expect(rect.right.toInt(), 780);
    //     expect(rect.bottom.toInt(), 480);
    //   });

    //   test('to test primaryXAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 62);
    //     expect(region.top.toInt(), 488);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 691);
    //     expect(region.top.toInt(), 488);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 46);
    //     expect(region.top.toInt(), 474);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 46);
    //     expect(region.top.toInt(), -6);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryXAxis first label location', () {
    //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[2]
    //         ._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 62);
    //     expect(region.top.toInt(), 515);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis
    //         ._axisRenderersCollection[2]
    //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[2]
    //                 ._visibleLabels.length -
    //             1]
    //         ._labelRegion!;
    //     expect(region.left.toInt(), 691);
    //     expect(region.top.toInt(), 515);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryYAxis first label location', () {
    //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[3]
    //         ._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 19);
    //     expect(region.top.toInt(), 474);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryYAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis
    //         ._axisRenderersCollection[3]
    //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[3]
    //                 ._visibleLabels.length -
    //             1]
    //         ._labelRegion!;
    //     expect(region.left.toInt(), -5);
    //     expect(region.top.toInt(), -6);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });

    //   testWidgets('Numeric axis - Multiple with Inversed Axis',
    //       (WidgetTester tester) async {
    //     final _AxisNumeric chartContainer =
    //         _axisNumeric('multipleAxis_inversed') as _AxisNumeric;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test axis rect', () {
    //     final Rect rect = _chartState!._chartAxis._axisClipRect;
    //     expect(rect.left.toInt(), 0);
    //     expect(rect.top.toInt(), 44);
    //     expect(rect.right.toInt(), 712);
    //     expect(rect.bottom.toInt(), 524);
    //   });

    //   test('to test primaryXAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), -6);
    //     expect(region.top.toInt(), 24);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 623);
    //     expect(region.top.toInt(), 24);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis first label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 722);
    //     expect(region.top.toInt(), 518);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryYAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 722);
    //     expect(region.top.toInt(), 38);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryXAxis first label location', () {
    //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[2]
    //         ._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), -6);
    //     expect(region.top.toInt(), -3);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis
    //         ._axisRenderersCollection[2]
    //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[2]
    //                 ._visibleLabels.length -
    //             1]
    //         ._labelRegion!;
    //     expect(region.left.toInt(), 623);
    //     expect(region.top.toInt(), -3);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryYAxis first label location', () {
    //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[3]
    //         ._visibleLabels[0]._labelRegion!;
    //     expect(region.left.toInt(), 749);
    //     expect(region.top.toInt(), 518);
    //     expect(region.width.toInt(), 12);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test secondaryYAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis
    //         ._axisRenderersCollection[3]
    //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[3]
    //                 ._visibleLabels.length -
    //             1]
    //         ._labelRegion!;
    //     expect(region.left.toInt(), 749);
    //     expect(region.top.toInt(), 38);
    //     expect(region.width.toInt(), 36);
    //     expect(region.height.toInt(), 12);
    //   });
  });

  group('Numeric Axis - Number Format and Label Format', () {
    testWidgets('Numeric axis - Number Format', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_numberFormat') as _AxisNumeric;
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
    //       'USD0.00');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       'USD60.00');
    // });

    // testWidgets('Numeric axis - Label Format', (WidgetTester tester) async {
    //   final _AxisNumeric chartContainer =
    //       _axisNumeric('numeric_labelFormat') as _AxisNumeric;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '1X');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '5X');
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0*C');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '60*C');
    // });
    testWidgets('Numeric axis with axis name', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_axis_name') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels', () {
      expect(chart!.primaryXAxis.name, 'majorAxis');
    });
    testWidgets('Numeric axis with inside labels', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('inside_label_center') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test labels alignment inside center', () {
      // ignore: unnecessary_null_comparison
      expect(chart!.primaryYAxis.labelAlignment == null, false);
    });
    testWidgets('Numeric axis with inside labels', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('inside_label_far') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test labels alignment inside far', () {
      // ignore: unnecessary_null_comparison
      expect(chart!.primaryYAxis.labelAlignment == null, false);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_near') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment near', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.start);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_far') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment far', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.end);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_center') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment center', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.center);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_near') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment near', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.start);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_far') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryYAxis labels alignment far', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.end);
    });
    testWidgets('Numeric axis - With Range', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_center') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryYAxis labels alignment center', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.hide);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.center);
    });

    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_near_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment near  edgelabel shift', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.start);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_far_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment far  edgelabel shift', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.end);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_x_labelalignment_center_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment center  edgelabel shift', () {
      expect(chart!.primaryXAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryXAxis.labelAlignment, LabelAlignment.center);
    });
    testWidgets('Numeric axis ', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_near_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryXAxis labels alignment near  edgelabel shift', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.start);
    });
    testWidgets('Numeric axis', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_far_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryYAxis labels alignment far  edgelabel shift', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.end);
    });
    testWidgets('Numeric axis', (WidgetTester tester) async {
      final _AxisNumeric chartContainer =
          _axisNumeric('numeric_y_labelalignment_center_shift') as _AxisNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test primaryYAxis labels alignment center edgelabel shift', () {
      expect(chart!.primaryYAxis.edgeLabelPlacement, EdgeLabelPlacement.shift);
      expect(chart!.primaryYAxis.labelAlignment, LabelAlignment.center);
    });
  });
}

StatelessWidget _axisNumeric(String sampleName) {
  return _AxisNumeric(sampleName);
}

// ignore: must_be_immutable
class _AxisNumeric extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AxisNumeric(String sampleName) {
    chart = getAxisSample(sampleName);
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
