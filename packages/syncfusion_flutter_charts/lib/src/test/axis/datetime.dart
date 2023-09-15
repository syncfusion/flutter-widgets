import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the date time axis.
void dateTimeAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  // group('DateTime Axis - Default Rendering', () {
  //   testWidgets('Without Data', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_withoutData') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Feb 11');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jun 1');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //       '0');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //       '5.5');
  // });
  // test('to test primaryXAxis first label location', () {
  //   final Rect region = _chartState
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //   expect(region.left.toInt(), 67);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 72);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = chart
  //       .primaryXAxis
  //       ._visibleLabels.last
  //       ._labelRegion;
  //   expect(region.left.toInt(), 760);
  //   expect(region.top.toInt(), 515);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 24);
  //   expect(region.top.toInt(), 496);
  //   expect(region.width.toInt(), 12);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), -6);
  //   expect(region.width.toInt(), 36);
  //   expect(region.height.toInt(), 12);
  // });
  // });

  // group('DateTime - Sorting ', () {
  //   testWidgets('Ascending', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_sortingX_ascending') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Nov 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jun 1');
  // });

  // testWidgets('Descending', (WidgetTester tester) async {
  //   final _AxisDateTime chartContainer =
  //       _axisDateTime('datetime_sortingX_descending') as _AxisDateTime;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Nov 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jun 1');
  // });
  // });

  // group('DateTime Axis - Visible Range', () {
  //   testWidgets('Visible Min and Max', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_visibleMinMax') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2005');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '2010');
  //   });

  //   testWidgets('meteTiem axis - Zoom Factor and Position',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_ZoomFactorPosition') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2007');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '2008');
  //   });
  // });

  // group('Date Time - Range and Range Padding', () {
  //   testWidgets('Datetime axis - With Range', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_range') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('Datetime axis - With Range - Min and Max Equal',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_range_minmax') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Nov 1');
  //   expect(
  //       _chartState._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Dec 31');
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

  // test('to test primaryXAxis first label location', () {
  //   final Rect region = _chartState
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //   expect(region.left.toInt(), 4);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(744.0, 510.0, 816.0, 522.0));
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

  //   testWidgets(
  //       'Datetime axis rangePadding as additional with interval type as hours',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_hours') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '16:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '22:00');
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
  //   testWidgets(
  //       'Datetime axis rangePadding as round with interval type as hours',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_round_days') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Feb 11');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Feb 15');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as round with interval type as hours',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_round_hours') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '17:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '17:00');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as round with interval type as years',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_round_years') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Nov 2009');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Nov 2015');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as additional with interval type as years',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_years') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Jan 2009');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Jan 2016');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as additional with interval type as days',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_days') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Feb 10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Feb 16');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as additional with interval type as minutes',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_minutes') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '50:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '50:00');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as round with interval type as minutes',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_round_minutes') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '50:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '10:00');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as additional with interval type as seconds',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_seconds') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '02:20sec');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '29:00sec');
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

  //   testWidgets(
  //       'Datetime axis rangePadding as round with interval type as seconds',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangePadding_round_seconds') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '35:20sec');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '55:20sec');
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

  //   testWidgets('Datetime axis rangePadding as additional',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangepadding_add') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Jul 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Feb 1');
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
  //     expect(region.left.toInt(), 4);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 701);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
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

  //   testWidgets('Datetime axis - RangePadding Normal',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangepadding_normal') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('Datetime axis - RangePadding Round',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangepadding_round') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Nov 30');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Sep 2');
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
  //     expect(region.left.toInt(), -2);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 690);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
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

  //   testWidgets('Datetime axis - RangePadding Round',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangepadding_none') as _AxisDateTime;
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
  //         '24');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '54');
  //   });
  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('Datetime axis - RangePadding Auto',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_rangepadding_auto') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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
  // });

  // group('Date Time - EdgeLabelPlacement', () {
  //   testWidgets('DateTime axis - EdgeLabelPlacement Hide',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_edgelabelPlacement_hide') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //     expect(region, const Rect.fromLTRB(4.0, 510.0, 64.0, 522.0));
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(704.0, 510.0, 764.0, 522.0));
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

  //   testWidgets('DateTime axis - EdgeLabelPlacement Shift',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_edgelabelPlacement_shift') as _AxisDateTime;
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

  group('Date Time Axis - Grid, Ticks and Axis Elements ', () {
    testWidgets('DateTime Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _AxisDateTime chartContainer =
          _axisDateTime('datetime_axisLine_title') as _AxisDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test primaryXAxis line properties', () {
      final AxisLine line = chart!.primaryXAxis.axisLine;
      expect(line.color!.value, const Color(0xfff44336).value);
      expect(line.dashArray, <double>[10, 20]);
      expect(line.width, 3);
    });

    test('to test primaryYAxis line properties', () {
      final AxisLine line = chart!.primaryYAxis.axisLine;
      expect(line.color!.value, const Color(0xfff44336).value);
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

    // testWidgets('DateTime axis - Inversed', (WidgetTester tester) async {
    //   final _AxisDateTime chartContainer =
    //       _axisDateTime('datetime_inversed') as _AxisDateTime;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfCartesianChartState?;
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

    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 750);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 50);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), -6);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), 496);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    testWidgets('DateTime Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisDateTime chartContainer =
          _axisDateTime('datetime_gridlines') as _AxisDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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

    testWidgets('DateTime Axis - Minor Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisDateTime chartContainer =
          _axisDateTime('datetime_minorgridlines') as _AxisDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test primaryXAxis minor grid line properties', () {
      final MinorGridLines xGrid = chart!.primaryXAxis.minorGridLines;
      expect(xGrid.width, 2);
      expect(xGrid.color!.value, const Color.fromRGBO(244, 67, 54, 1.0).value);
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

    // testWidgets('DateTime Axis - Label Style', (WidgetTester tester) async {
    //   final _AxisDateTime chartContainer =
    //       _axisDateTime('datetime_labelStyle') as _AxisDateTime;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // //   _chartState = key.currentState as SfCartesianChartState?;
    //  });

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
    //   final _AxisDateTime chartContainer =
    //       _axisDateTime('datetime_axisVisible') as _AxisDateTime;
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

  // group('Date Time Axis - Opposed', () {
  //   testWidgets('DateTime axis - Opposed', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_opposed') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), -30);
  //     expect(region.top.toInt(), 10);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 692);
  //     expect(region.top.toInt(), 10);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 741);
  //     expect(region.top.toInt(), 518);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 741);
  //     expect(region.top.toInt(), 4);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Date Time Axis - Transposed', () {
  //   testWidgets('DateTime axis - Transposed', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_transpose') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(_chartState!._chartAxis._primaryXAxisRenderer._orientation,
  //         AxisOrientation.vertical);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Dec 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Sep 1');
  //   });

  //   test('to test primaryYAxis labels', () {
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
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 25);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 64);
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

  //   testWidgets('DateTime axis with bar series', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_bar') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Nov 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Jun 1');
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

  // group('Date Time Axis- LabelIntersectAction', () {
  //   testWidgets('DateTime axis - Label Intersect Hide',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_labelIntersect_hide') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('DateTime axis - Label Intersect Multiple Rows',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_labelIntersect_multiplerows')
  //             as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('DateTime axis - Label Intersect None',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_labelIntersect_none') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('DateTime axis - Label Intersect Rotate 45',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_labelIntersect_45') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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

  //   testWidgets('DateTime axis - Label Intersect Rotate 90',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_labelIntersect_90') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 4);
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
  // });

  // group('Date Time Axis - Date Format and Interval Type', () {
  //   testWidgets('DateTime axis - Date Format', (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_dateFormat') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2004');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '2008');
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

  //   testWidgets('DateTime axis - Interval Type Years',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_year') as _AxisDateTime;
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
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '60');
  //   });

  //   testWidgets('DateTime axis - Interval Type Months',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_months') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Jan 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Nov 1');
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

  //   testWidgets('DateTime axis - Interval Type Days',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_days') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Feb 11');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Feb 15');
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

  //   testWidgets('DateTime axis - Interval Type Hours',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_hours') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '18:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '21:00');
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

  //   testWidgets('DateTime axis interval type auto with hours',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_auto_hours') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '00:00');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '24:00');
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

  //   testWidgets('DateTime axis - Interval Type Seconds',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_intervalType_seconds') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '35:20');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '55:20');
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
  //   testWidgets('datetime axis with inside labels',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_inside_label_center') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test labels alignment inside center', () {
  //     // ignore: unnecessary_null_comparison
  //     expect(chart!.primaryYAxis.labelAlignment == null, false);
  //   });
  //   testWidgets('datetime axis with inside labels',
  //       (WidgetTester tester) async {
  //     final _AxisDateTime chartContainer =
  //         _axisDateTime('datetime_inside_label_far') as _AxisDateTime;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test labels alignment inside far', () {
  //     // ignore: unnecessary_null_comparison
  //     expect(chart!.primaryYAxis.labelAlignment == null, false);
  //   });
  // });
}

StatelessWidget _axisDateTime(String sampleName) {
  return _AxisDateTime(sampleName);
}

// ignore: must_be_immutable
class _AxisDateTime extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AxisDateTime(String sampleName) {
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
