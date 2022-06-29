import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the category axis.
void categoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;

  // group('Category Axis - Default Rendering', () {
  //   testWidgets('Without Data', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_withoutData') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
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
  // });

  // group('Category Axis - Visible Range', () {
  //   testWidgets('Visible Min and Max', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_visibleMinMax') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Japan');
  //   });

  //   testWidgets('Category axis - SideBySideSeriesPlacement',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_SideBySideSeriesPlacement') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test first point of first series', () {
  //     final CartesianSeriesRenderer seriesRenderer =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0];
  //     expect(seriesRenderer._dataPoints[0].region!.left.toInt(), 56);
  //     expect(seriesRenderer._dataPoints[0].region!.top.toInt(), 0);
  //   });

  //   test('to test first point of second series', () {
  //     final CartesianSeriesRenderer seriesRenderer =
  //         _chartState!._chartSeries.visibleSeriesRenderers[1];
  //     expect(seriesRenderer._dataPoints[0].region!.left.toInt(), 56);
  //     expect(seriesRenderer._dataPoints[0].region!.top.toInt(), 0);
  //   });
  // });

  // group('Category Axis - Inversed', () {
  //   testWidgets('Category axis - Inversed', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_inversed') as _AxisCategory;
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
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Russia');
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
  //     expect(region.left.toInt(), 675);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 73);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
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

  // group('Category Axis - opposed', () {
  //   testWidgets('Category axis - Opposed', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_opposed') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels and segment', () {
  //     final CartesianSeriesRenderer seriesRenderer =
  //         _chartState!._chartSeries.visibleSeriesRenderers[0];
  //     final LineSegment segment = seriesRenderer._segments[0] as LineSegment;
  //     expect(segment._x1.toInt(), 75);
  //     expect(segment._y1.toInt(), 253);
  //     expect(segment._x2.toInt(), 225);
  //     expect(segment._y2.toInt(), 321);
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

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 45);
  //     expect(region.top.toInt(), 2);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 640);
  //     expect(region.top.toInt(), 2);
  //     expect(region.width.toInt(), 72);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 756);
  //     expect(region.top.toInt(), 518);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 756);
  //     expect(region.top.toInt(), 11);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Category Axis - Transposed', () {
  //   testWidgets('Category axis - Transposed', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_transposed') as _AxisCategory;
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
  //         'India');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Russia');
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
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 445);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 44);
  //     expect(region.width.toInt(), 72);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 76);
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

  // group('Category Axis - Plotoffset', () {
  //   testWidgets('Category axis - Plotoffset', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_plotoffset') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis plotoffset', () {
  //     expect(_chartState!._chartAxis._primaryXAxisRenderer._orientation,
  //         AxisOrientation.horizontal);
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'India');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'Russia');
  //   });

  //   test('to test primaryYAxis plotoffset', () {
  //     expect(_chartState!._chartAxis._primaryYAxisRenderer._orientation,
  //         AxisOrientation.vertical);
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
  //     expect(region.left.toInt(), 119);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 629);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 396);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 94);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  group('Category Axis- Tick, Grid and Axis Elements', () {
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _AxisCategory chartContainer =
          _axisCategory('category_label_tickPosition') as _AxisCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'India');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //       'Russia');
    // });

    // test('to test primaryXAxis ticks position', () {
    //   expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    // });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    test('to test primaryYAxis ticks position', () {
      expect(chart!.primaryYAxis.tickPosition, TickPosition.inside);
    });

    testWidgets('Category axis - Ticks', (WidgetTester tester) async {
      final _AxisCategory chartContainer =
          _axisCategory('category_ticks') as _AxisCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test x axis major tick properties', () {
      final MajorTickLines majorTick = chart!.primaryXAxis.majorTickLines;
      expect(majorTick.color!.value, Colors.green.value);
      expect(majorTick.width, 10);
      expect(majorTick.size, 5);
    });

    test('to test x axis minor tick properties', () {
      final MinorTickLines minorTick = chart!.primaryXAxis.minorTickLines;
      expect(minorTick.color!.value, Colors.red.value);
      expect(minorTick.width, 5);
      expect(minorTick.size, 4);
    });

    test('to test y axis major tick properties', () {
      final MajorTickLines majorTick = chart!.primaryYAxis.majorTickLines;
      expect(majorTick.color!.value, Colors.red.value);
      expect(majorTick.size.toInt(), 4);
      expect(majorTick.width.toInt(), 5);
    });

    test('to test y axis minor tick properties', () {
      final MinorTickLines minorTick = chart!.primaryYAxis.minorTickLines;
      expect(minorTick.color!.value, Colors.green.value);
      expect(minorTick.width.toInt(), 10);
      expect(minorTick.size.toInt(), 5);
    });

    testWidgets('Category axis - Gridlines', (WidgetTester tester) async {
      final _AxisCategory chartContainer =
          _axisCategory('category_gridlines') as _AxisCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test x axis major gridline properties', () {
      final MajorGridLines majorGrid = chart!.primaryXAxis.majorGridLines;
      expect(majorGrid.color!.value, Colors.green.value);
      expect(majorGrid.width, 10);
      expect(majorGrid.dashArray, <double>[10, 20]);
    });

    test('to test x axis minor gridline properties', () {
      final MinorGridLines minorGrid = chart!.primaryXAxis.minorGridLines;
      expect(minorGrid.color!.value, Colors.red.value);
      expect(minorGrid.width, 5);
      expect(minorGrid.dashArray, <double>[10, 20]);
    });

    test('to test y axis major gridline properties', () {
      final MajorGridLines majorGrid = chart!.primaryYAxis.majorGridLines;
      expect(majorGrid.color!.value, Colors.red.value);
      expect(majorGrid.width.toInt(), 5);
      expect(majorGrid.dashArray, <double>[10, 20]);
    });

    test('to test y axis minor gridline properties', () {
      final MinorGridLines minorGrid = chart!.primaryYAxis.minorGridLines;
      expect(minorGrid.color!.value, Colors.green.value);
      expect(minorGrid.width.toInt(), 10);
      expect(minorGrid.dashArray, <double>[10, 20]);
    });

    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _AxisCategory chartContainer =
          _axisCategory('category_axisLine') as _AxisCategory;
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
  });

  // group('Category Axis- Label Placement', () {
  //   testWidgets('Category axis - LabelPlacement OnTicks',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelPlacement_onTicks') as _AxisCategory;
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
  //     expect(region.left.toInt(), 744);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
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

  //   testWidgets('Category axis - LabelPlacement BetweenTicks',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelPlacement_betweenTicks')
  //             as _AxisCategory;
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

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 79);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 669);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
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

  // group('Category Axis - EdgeLabelPlacement', () {
  //   testWidgets('Category axis - EdgeLabelPlacement Hide',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_EdgeLabelPlacement_hide') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
  //     expect(region, const Rect.fromLTRB(27.0, 510.0, 147.0, 522.0));
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(667.0, 510.0, 787.0, 522.0));
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

  //   testWidgets('Category axis - EdgeLabelPlacement Shift',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_EdgeLabelPlacement_shift') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 34);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 120);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 660);
  //     expect(region.top.toInt(), 510);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 12);
  //     expect(region.top.toInt(), 490);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 0);
  //   });

  //   testWidgets(
  //       'Category axis edgeLabelPlacement shift with maximum width for label',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_EdgeLabel_shift_large_value')
  //             as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 348);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 432);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Category Axis - LabelIntersectAction', () {
  //   testWidgets('Category axis - Label Intersection - Hide',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_hide') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   testWidgets('Category axis - Label Intersection - Multiple Rows',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_multiple') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });
  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), -22);
  //     expect(region.top.toInt(), 498);
  //     expect(region.width.toInt(), 240);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 578);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 484);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - None',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_none') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), -22);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 240);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 578);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 496);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - Rotate45',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_45') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 98);
  //     expect(region.top.toInt(), 407);
  //     expect(region.width.toInt(), 192);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 704);
  //     expect(region.top.toInt(), 428);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 321);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - Rotate90',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_90') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 98);
  //     expect(region.top.toInt(), 366);
  //     expect(region.width.toInt(), 192);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 704);
  //     expect(region.top.toInt(), 396);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 256);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });
  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - Wrap',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_wrap') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels[0].renderText,
  //         'USA');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.renderText,
  //         'India');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 80);
  //     expect(region.top.toInt(), 474);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 674);
  //     expect(region.top.toInt(), 474);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), 460);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //     expect(region.top.toInt(), -6);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - Hide for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_hide_inverse')
  //             as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 584);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect? region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion;
  //     expect(region, const Rect.fromLTRB(-28.0, 510.0, 224.0, 522.0));
  //   });

  //   test('to test primaryYAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //   });

  //   test('to test primaryYAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 0);
  //   });

  //   testWidgets(
  //       'Category axis - Label Intersection - Multiple Rows for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_multiple_inverse')
  //             as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 584);
  //     expect(region.top.toInt(), 498);
  //     expect(region.width.toInt(), 240);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), -28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - None for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_none_inverse')
  //             as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA got three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 584);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 240);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), -28);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets(
  //       'Category axis - Label Intersection - Rotat45 for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_45_inverse') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 704);
  //     expect(region.top.toInt(), 407);
  //     expect(region.width.toInt(), 192);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 98);
  //     expect(region.top.toInt(), 428);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });
  //   testWidgets(
  //       'Category axis - Label Intersection - Rotate90 for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_90_inverse') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA three medals');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India got four medals');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 704);
  //     expect(region.top.toInt(), 366);
  //     expect(region.width.toInt(), 192);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 98);
  //     expect(region.top.toInt(), 396);
  //     expect(region.width.toInt(), 252);
  //     expect(region.height.toInt(), 12);
  //   });

  //   testWidgets('Category axis - Label Intersection - Wrap for Inversed Axis',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_labelIntersect_wrap_inverse')
  //             as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels[0].renderText,
  //         'USA');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.renderText,
  //         'India');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '9');
  //   });

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 686);
  //     expect(region.top.toInt(), 474);
  //     expect(region.width.toInt(), 36);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 68);
  //     expect(region.top.toInt(), 474);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Category Axis - Multiple Axis', () {
  //   testWidgets('Category axis - Multiple Axis', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_multipleAxis') as _AxisCategory;
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

  //   test('to test primaryXAxis first label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 75);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test primaryXAxis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
  //     expect(region.left.toInt(), 639);
  //     expect(region.top.toInt(), 510);
  //     expect(region.width.toInt(), 72);
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
  //     expect(region.top.toInt(), 16);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test secondary X Axis first label location', () {
  //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[2]
  //         ._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 75);
  //     expect(region.top.toInt(), 2);
  //     expect(region.width.toInt(), 60);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test secondary X Axis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis
  //         ._axisRenderersCollection[2]
  //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[2]
  //                 ._visibleLabels.length -
  //             1]
  //         ._labelRegion!;
  //     expect(region.left.toInt(), 639);
  //     expect(region.top.toInt(), 2);
  //     expect(region.width.toInt(), 72);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test secondary Y Axis first label location', () {
  //     final Rect region = _chartState!._chartAxis._axisRenderersCollection[3]
  //         ._visibleLabels[0]._labelRegion!;
  //     expect(region.left.toInt(), 756);
  //     expect(region.top.toInt(), 316);
  //     expect(region.width.toInt(), 12);
  //     expect(region.height.toInt(), 12);
  //   });

  //   test('to test secondary Y Axis last label location', () {
  //     final Rect region = _chartState!
  //         ._chartAxis
  //         ._axisRenderersCollection[3]
  //         ._visibleLabels[_chartState!._chartAxis._axisRenderersCollection[3]
  //                 ._visibleLabels.length -
  //             1]
  //         ._labelRegion!;
  //     expect(region.left.toInt(), 756);
  //     expect(region.top.toInt(), 196);
  //     expect(region.width.toInt(), 24);
  //     expect(region.height.toInt(), 12);
  //   });
  // });

  // group('Category Axis - Indexed Axis', () {
  //   testWidgets('Category axis - Indexed Axis', (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('category_isIndexed') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test primaryXAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
  //         'USA, USSR');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
  //         'India, Asia');
  //   });

  //   test('to test primaryYAxis labels', () {
  //     expect(
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
  //         '0');
  //     expect(
  //         _chartState!
  //             ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
  //         '10');
  //   });
  //   testWidgets('category axis with inside labels',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('inside_label_center') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test labels alignment inside center', () {
  //     // ignore: unnecessary_null_comparison
  //     expect(chart!.primaryYAxis.labelAlignment == null, false);
  //   });
  //   testWidgets('category axis with inside labels',
  //       (WidgetTester tester) async {
  //     final _AxisCategory chartContainer =
  //         _axisCategory('inside_label_far') as _AxisCategory;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //   });

  //   test('to test labels alignment inside center', () {
  //     // ignore: unnecessary_null_comparison
  //     expect(chart!.primaryYAxis.labelAlignment == null, false);
  //   });
  // });
}

StatelessWidget _axisCategory(String sampleName) {
  return _AxisCategory(sampleName);
}

// ignore: must_be_immutable
class _AxisCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AxisCategory(String sampleName) {
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
