import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the date time axis.
void dateTimeCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  // group('DateTimeCategory Axis - Default Rendering', () {
  //   testWidgets('Without Data', (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_withoutData')
  //             as _AxisDateTimeCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels.isEmpty,
  //         true);
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '5.5');
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 24);
  //     expect(region.top.toInt(), 508);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('DateTimeCategory - Sorting ', () {
  //   testWidgets('Ascending', (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_sortingX_ascending')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
  //   });

  //   testWidgets('Descending', (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_sortingX_descending')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
  //   });
  // });

  // group('DateTimeCategory Axis - Visible Range', () {
  //   testWidgets('Visible Min and Max', (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_visibleMinMax')
  //             as _AxisDateTimeCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Jan 2005');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Jan 2008');
  //   });

  //   testWidgets('meteTiem axis - Zoom Factor and Position',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_ZoomFactorPosition')
  //             as _AxisDateTimeCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         '2008');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         '2010');
  //   });
  // });

  // group('Date Time - Range and Range Padding', () {
  //   testWidgets('Datetime axis - With Range', (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_range')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
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
  //     expect(region.left.toInt(), 66);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 688);
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
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_range_minmax')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
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
  //     expect(region.left.toInt(), 377);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(377.0, 510.0, 437.0, 522.0));
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

  // testWidgets(
  //     'Datetime axis rangePadding as round with interval type as years',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_round_years')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 2011');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Feb 2015');
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

  // testWidgets(
  //     'Datetime axis rangePadding as additional with interval type as years',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_years')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 2011');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Feb 2015');
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

  // testWidgets(
  //     'Datetime axis rangePadding as additional with interval type as minutes',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_minutes')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '02:21');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '26:40');
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

  // testWidgets(
  //     'Datetime axis rangePadding as round with interval type as minutes',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_round_minutes')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '02:21');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '26:40');
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

  // testWidgets(
  //     'Datetime axis rangePadding as additional with interval type as seconds',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_seconds')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '02:21');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '26:40');
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

  // testWidgets(
  //     'Datetime axis rangePadding as round with interval type as seconds',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangePadding_round_seconds')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       '02:21');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       '26:40');
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

  // testWidgets('Datetime axis rangePadding as additional',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangepadding_add')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jan 1');
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

  // test('to test primaryXAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 170);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 584);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), 496);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), -6);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });

  // testWidgets('Datetime axis - RangePadding Normal',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangepadding_normal')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jan 1');
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
  //   expect(region.left.toInt(), 97);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 564);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 12);
  //   expect(region.top.toInt(), 496);
  //   expect(region.width.toInt(), 12);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), -6);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });

  // testWidgets('Datetime axis - RangePadding Round',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangepadding_round')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jan 1');
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
  // test('to test primaryXAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 111);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 643);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), 496);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), -6);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });

  // testWidgets('Datetime axis - RangePadding Round',
  //     (WidgetTester tester) async {
  //   final _AxisDateTimeCategory chartContainer =
  //       _axisDateTimeCategory('datetime_category_rangepadding_none')
  //           as _AxisDateTimeCategory;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  // });

  // test('to test primaryXAxis labels', () {
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jan 1');
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
  // test('to test primaryXAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 66);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 688);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), 496);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), -6);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });

  //   testWidgets('Datetime axis - RangePadding Auto',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_rangepadding_auto')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
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
  //     expect(region.left.toInt(), 66);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 688);
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
  //   testWidgets('DateTimeCategory axis - EdgeLabelPlacement Hide',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_edgelabelPlacement_hide')
  //             as _AxisDateTimeCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'Jan 1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Jan 1');
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
  //     expect(region, const Rect.fromLTRB(66.0, 510.0, 126.0, 522.0));
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(688.0, 510.0, 748.0, 522.0));
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

  //   testWidgets('DateTimeCategory axis - EdgeLabelPlacement Shift',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_edgelabelPlacement_shift')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
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
  //     expect(region.left.toInt(), 66);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 688);
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
    testWidgets('DateTimeCategory Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _AxisDateTimeCategory chartContainer =
          _axisDateTimeCategory('datetime_category_axisLine_title')
              as _AxisDateTimeCategory;
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

    // testWidgets('DateTimeCategory axis - Inversed',
    //     (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_inversed')
    //           as _AxisDateTimeCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Jan 1');
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
    //   expect(region.left.toInt(), 688);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 66);
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

    testWidgets('DateTimeCategory Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisDateTimeCategory chartContainer =
          _axisDateTimeCategory('datetime_category_gridlines')
              as _AxisDateTimeCategory;
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

    testWidgets('DateTimeCategory Axis - Minor Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisDateTimeCategory chartContainer =
          _axisDateTimeCategory('datetime_category_minorgridlines')
              as _AxisDateTimeCategory;
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

    // testWidgets('DateTimeCategory Axis - Label Style',
    //     (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_labelStyle')
    //           as _AxisDateTimeCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

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

    // testWidgets('DateTimeCategory Axis - Visibility',
    //     (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_axisVisible')
    //           as _AxisDateTimeCategory;
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

  group('Date Time Axis - Opposed', () {
    // testWidgets('DateTimeCategory axis - Opposed', (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_opposed')
    //           as _AxisDateTimeCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Jan 1');
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
    //   expect(region.left.toInt(), 34);
    //   expect(region.top.toInt(), 10);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 676);
    //   expect(region.top.toInt(), 10);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 741);
    //   expect(region.top.toInt(), 518);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 741);
    //   expect(region.top.toInt(), 4);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });
  });

  // group('Date Time Axis - Transposed', () {
  //   testWidgets('DateTimeCategory axis - Transposed',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_transpose')
  //             as _AxisDateTimeCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfCartesianChartState?;
  //   });

  // test('to test primaryXAxis labels', () {
  //   expect(_chartState!._chartAxis._primaryXAxisRenderer._orientation,
  //       AxisOrientation.vertical);
  //   expect(
  //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //       'Jan 1');
  //   expect(
  //       _chartState!
  //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //       'Jan 1');
  // });

  // test('to test primaryYAxis labels', () {
  //   expect(_chartState!._chartAxis._primaryYAxisRenderer._orientation,
  //       AxisOrientation.horizontal);
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
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), 454);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryXAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 0);
  //   expect(region.top.toInt(), 35);
  //   expect(region.width.toInt(), 60);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis first label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //   expect(region.left.toInt(), 64);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 12);
  //   expect(region.height.toInt(), 12);
  // });
  // test('to test primaryYAxis last label location', () {
  //   final Rect region = _chartState!
  //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //   expect(region.left.toInt(), 768);
  //   expect(region.top.toInt(), 510);
  //   expect(region.width.toInt(), 24);
  //   expect(region.height.toInt(), 12);
  // });

  //   testWidgets('DateTimeCategory axis with bar series',
  //       (WidgetTester tester) async {
  //     final _AxisDateTimeCategory chartContainer =
  //         _axisDateTimeCategory('datetime_category_bar')
  //             as _AxisDateTimeCategory;
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
  //         'Jan 1');
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

  group('Date Time Axis- LabelIntersectAction', () {
    testWidgets('DateTimeCategory axis - Label Intersect Hide',
        (WidgetTester tester) async {
      final _AxisDateTimeCategory chartContainer =
          _axisDateTimeCategory('datetime_category_labelIntersect_hide')
              as _AxisDateTimeCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Jan 1');
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
    //   expect(region.left.toInt(), 66);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 688);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), 496);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), -6);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    // testWidgets('DateTimeCategory axis - Label Intersect Multiple Rows',
    //     (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_labelIntersect_multiplerows')
    //           as _AxisDateTimeCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Jan 1');
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
    //   expect(region.left.toInt(), 66);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 688);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), 496);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), -6);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    // testWidgets('DateTimeCategory axis - Label Intersect None',
    //     (WidgetTester tester) async {
    //   final _AxisDateTimeCategory chartContainer =
    //       _axisDateTimeCategory('datetime_category_labelIntersect_none')
    //           as _AxisDateTimeCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Jan 1');
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
    //   expect(region.left.toInt(), 66);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 688);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), 496);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), -6);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    //   testWidgets('DateTimeCategory axis - Label Intersect Rotate 45',
    //       (WidgetTester tester) async {
    //     final _AxisDateTimeCategory chartContainer =
    //         _axisDateTimeCategory('datetime_category_labelIntersect_45')
    //             as _AxisDateTimeCategory;
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
    //         'Jan 1');
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
    //     expect(region.left.toInt(), 66);
    //     expect(region.top.toInt(), 510);
    //     expect(region.width.toInt(), 60);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 688);
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

    //   testWidgets('DateTimeCategory axis - Label Intersect Rotate 90',
    //       (WidgetTester tester) async {
    //     final _AxisDateTimeCategory chartContainer =
    //         _axisDateTimeCategory('datetime_category_labelIntersect_90')
    //             as _AxisDateTimeCategory;
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
    //         'Jan 1');
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
    //     expect(region.left.toInt(), 66);
    //     expect(region.top.toInt(), 510);
    //     expect(region.width.toInt(), 60);
    //     expect(region.height.toInt(), 12);
    //   });
    //   test('to test primaryXAxis last label location', () {
    //     final Rect region = _chartState!
    //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //     expect(region.left.toInt(), 688);
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
    //   testWidgets('DateTimeCategory axis - Date Format',
    //       (WidgetTester tester) async {
    //     final _AxisDateTimeCategory chartContainer =
    //         _axisDateTimeCategory('datetime_category_dateFormat')
    //             as _AxisDateTimeCategory;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
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

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!
    //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //         '60');
    //   });
  });
}

StatelessWidget _axisDateTimeCategory(String sampleName) {
  return _AxisDateTimeCategory(sampleName);
}

// ignore: must_be_immutable
class _AxisDateTimeCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AxisDateTimeCategory(String sampleName) {
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
