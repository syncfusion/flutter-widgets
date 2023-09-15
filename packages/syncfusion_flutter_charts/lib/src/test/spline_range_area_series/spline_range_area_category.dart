import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_range_area_sample.dart';

/// Test method of category axis of the spline range area series.
void splineRangeAreaCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('RangeSeries - Category Axis', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _SplineRangeAreaCategory chartContainer =
          _splinerangeAreaCategory('category_default')
              as _SplineRangeAreaCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
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

  // group('Category Axis - Range Area Label Placement', () {
  //   testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
  //     final _SplineRangeAreaCategory chartContainer =
  //         _splinerangeAreaCategory('category_labelPlacement')
  //             as _SplineRangeAreaCategory;
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
  // });

  // group('Category Axis - Range Area EdgeLabelPlacement', () {
  //   testWidgets('Category axis - EdgeLabelPlacement',
  //       (WidgetTester tester) async {
  //     final _SplineRangeAreaCategory chartContainer =
  //         _splinerangeAreaCategory('category_EdgeLabelPlacement')
  //             as _SplineRangeAreaCategory;
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
  // });

  // group('Category - Range Area Inversed Axis', () {
  //   testWidgets('Category axis - Inversed', (WidgetTester tester) async {
  //     final _SplineRangeAreaCategory chartContainer =
  //         _splinerangeAreaCategory('category_inversed')
  //             as _SplineRangeAreaCategory;
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
  // });

  // group('Category - Range Area Opposed Axis', () {
  //   testWidgets('Category axis - Opposed', (WidgetTester tester) async {
  //     final _SplineRangeAreaCategory chartContainer =
  //         _splinerangeAreaCategory('category_opposed')
  //             as _SplineRangeAreaCategory;
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
  //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
  //         '20');
  //   });
  // });

  group('Category- Range Area Axis Elements', () {
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _SplineRangeAreaCategory chartContainer =
          _splinerangeAreaCategory('category_label_tickPosition')
              as _SplineRangeAreaCategory;
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

    // testWidgets('Category Axis - Label Style', (WidgetTester tester) async {
    //   final _SplineRangeAreaCategory chartContainer =
    //       _splinerangeAreaCategory('category_labelStyle')
    //           as _SplineRangeAreaCategory;
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

    // testWidgets('Category Axis - Visibility', (WidgetTester tester) async {
    //   final _SplineRangeAreaCategory chartContainer =
    //       _splinerangeAreaCategory('category_axisVisible')
    //           as _SplineRangeAreaCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test(
    //     'to test primaryXAxis visible labels count with axis visibility to false',
    //     () {
    //   //Commented the below line since when axis visibility is false, thenthere should not be aby visible labels,
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

    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _SplineRangeAreaCategory chartContainer =
          _splinerangeAreaCategory('category_axisLine_title')
              as _SplineRangeAreaCategory;
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
  });

  group('Category - Range Area Grid and Ticks', () {
    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _SplineRangeAreaCategory chartContainer =
          _splinerangeAreaCategory('category_gridlines')
              as _SplineRangeAreaCategory;
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
  });
}

StatelessWidget _splinerangeAreaCategory(String sampleName) {
  return _SplineRangeAreaCategory(sampleName);
}

// ignore: must_be_immutable
class _SplineRangeAreaCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineRangeAreaCategory(String sampleName) {
    chart = getSplineRangeAreachart(sampleName);
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
