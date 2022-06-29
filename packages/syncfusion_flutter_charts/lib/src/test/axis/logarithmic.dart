import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the logarithmic axis.
void logarithmicAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  // group('Logarithmic Axis - Default Rendering', () {
  //   testWidgets('Without Data', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_withoutData') as _AxisLogarithmic;
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
  //         '5');
  //   });
  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '10');
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
  // });

  // group('Logarithmic - Sorting ', () {
  //   testWidgets('Ascending', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_sortingY_ascending')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '100');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '1000');
  //   });

  //   testWidgets('Descending', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_sortingY_descending')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '100');
  //   });
  // });

  // group('Logarithmic Axis - Opposed', () {
  //   testWidgets('Logarithmic axis - Opposed', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_opposed') as _AxisLogarithmic;
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
  //         '10');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '100');
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
  //     expect(region.left.toInt(), 702);
  //     expect(region.top.toInt(), 22);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 724);
  //     expect(region.top.toInt(), 518);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 724);
  //     expect(region.top.toInt(), 36);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Logarithmic Axis - Transposed', () {
  //   testWidgets('Logarithmic axis - Transpose', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_transpose') as _AxisLogarithmic;
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
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '100');
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
  //     expect(region.left.toInt(), 34);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 762);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Logarithmic Axis - LabelIntersectAction', () {
  //   testWidgets('Logarithmic axis - Label Intersection - Hide',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_labelIntersect_hide')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis second last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis
  //         ._primaryXAxisRenderer
  //         ._visibleLabels[_chartState!
  //                 ._chartAxis._primaryXAxisRenderer._visibleLabels.length -
  //             2]
  //         ._labelRegion!;
  //     expect(region.left.toInt(), 643);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 108);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Logarithmic axis - Label Intersection - Multiple Rows',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_labelIntersect_multiple')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 28);
  //     expect(region.top.toInt(), 498);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 720);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 120);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Logarithmic axis - Label Intersection - None',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_labelIntersect_none')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
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
  //     expect(region.left.toInt(), 720);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 120);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Logarithmic axis - Label Intersection - Multiple Rows',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_labelIntersect_45') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 34);
  //     expect(region.top.toInt(), 437);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 780);
  //     expect(region.top.toInt(), 475);
  //     expect(region.width.toInt(), 120);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Logarithmic axis - Label Intersection - Multiple Rows',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_labelIntersect_90') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 34);
  //     expect(region.top.toInt(), 408);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 780);
  //     expect(region.top.toInt(), 462);
  //     expect(region.width.toInt(), 120);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Logarithmic Axis - EdgeLabelPlacement', () {
  //   testWidgets('Logarithmic axis - EdgeLabelPlacement Hide',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_edgelabelPlacement_hide')
  //             as _AxisLogarithmic;
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
  //         '10');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '100');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //     expect(region, const Rect.fromLTRB(40.0, 510.0, 52.0, 522.0));
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(768.0, 510.0, 792.0, 522.0));
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

  //   testWidgets('Logarithmic axis - EdgeLabelPlacement Shift',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_edgelabelPlacement_shift')
  //             as _AxisLogarithmic;
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
  //         '10');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '10');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '100');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 46);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 756);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 490);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 0);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  group('Logarithmic Axis - Grids, Ticks and Axis Elements', () {
    testWidgets('Logarithmic Axis - Axis Line and Title',
        (WidgetTester tester) async {
      final _AxisLogarithmic chartContainer =
          _axisLogarithmic('logarithmic_axisLine_title') as _AxisLogarithmic;
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
      expect(title.textStyle.fontSize, 15);
    });

    test('To test primaryYAxis title properties', () {
      final AxisTitle title = chart!.primaryYAxis.title;
      expect(title.text, 'Primary Y Axis');
      expect(title.alignment, ChartAlignment.center);
      expect(title.textStyle.fontSize, 15);
    });

    test('X axis name property with default value', () {
      expect(chart!.primaryXAxis.name, null);
    });

    test('Y axis name property with default value', () {
      expect(chart!.primaryYAxis.name, null);
    });

    testWidgets('Logarithmic Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisLogarithmic chartContainer =
          _axisLogarithmic('logarithmic_gridlines') as _AxisLogarithmic;
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

    // testWidgets('Logarithmic Axis - Label Style', (WidgetTester tester) async {
    //   final _AxisLogarithmic chartContainer =
    //       _axisLogarithmic('logarithmic_labelStyle') as _AxisLogarithmic;
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

    // testWidgets('Logarithmic Axis - Visibility', (WidgetTester tester) async {
    //   final _AxisLogarithmic chartContainer =
    //       _axisLogarithmic('logarithmic_axisVisible') as _AxisLogarithmic;
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

    // testWidgets('Logarithmic axis - Plotoffset', (WidgetTester tester) async {
    //   final _AxisLogarithmic chartContainer =
    //       _axisLogarithmic('logarithmic_plotoffset') as _AxisLogarithmic;
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
    //       '10');
    // });

    // test('to test primaryYAxis transposed', () {
    //   expect(chart!.primaryYAxis.plotOffset.toInt(), 50);
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '10');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '100');
    // });

    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 140);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 668);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 12);
    //   expect(region.top.toInt(), 446);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 0);
    //   expect(region.top.toInt(), 44);
    //   expect(region.width.toInt(), 36);
    //   expect(region.height.toInt(), 12);
    // });

    testWidgets('Logarithmic Axis - Minor Grid and Tick lines',
        (WidgetTester tester) async {
      final _AxisLogarithmic chartContainer =
          _axisLogarithmic('logarithmic_minorgridtick') as _AxisLogarithmic;
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

  // group('Logarithmic Axis - Range and Range Padding', () {
  //   testWidgets('Logarithmic axis - With Range', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_range') as _AxisLogarithmic;
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
  //         '1');
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
  //         '2');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '100');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //         '10000');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '1000000');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 88);
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
  //     expect(region.left.toInt(), 48);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 84);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Logarithmic Axis - Log Base', () {
  //   testWidgets('Logarithmic axis - With Log Base',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('logarithmic_logBase') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test log Base', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '1');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //         '25');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '625');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[7].text,
  //         '78125');
  //   });
  // });

  // group('Logarithmic Axis - Zoom Factor and Position', () {
  //   testWidgets('Logarithmic axis - Zoom Factor and Position',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('Logarithmic_ZoomFactorPosition')
  //             as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test zoom factor', () {
  //     expect(_chartState!._chartAxis._primaryYAxisRenderer._zoomFactor, 0.5);
  //   });
  //   test('to test zoom position', () {
  //     expect(_chartState!._chartAxis._primaryYAxisRenderer._zoomPosition, 0.5);
  //   });
  // });

  // group('Logarithmic Axis - Visible Range', () {
  //   testWidgets('Logarithmic axis - Zoom Factor and Position',
  //       (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('Logarithmic_VisibleMinMax') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test the Visible minimum', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '1000');
  //   });
  //   test('to test the Visible minimum', () {
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '10000');
  //   });
  // });

  // group('Logarithmic Axis - Label and Number Format', () {
  //   testWidgets('Logarithmic axis - Label Format', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('Logarithmic_LabelFormat') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test the number format', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //         '100M');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '10000M');
  //   });
  //   testWidgets('Logarithmic axis - ', (WidgetTester tester) async {
  //     final _AxisLogarithmic chartContainer =
  //         _axisLogarithmic('Logarithmic_NumberFormat') as _AxisLogarithmic;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });
  //   test('to test the number format', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[2].text,
  //         r'$100.00');
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         r'$10,000.00');
  //   });
  // });
}

StatelessWidget _axisLogarithmic(String sampleName) {
  return _AxisLogarithmic(sampleName);
}

// ignore: must_be_immutable
class _AxisLogarithmic extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AxisLogarithmic(String sampleName) {
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
