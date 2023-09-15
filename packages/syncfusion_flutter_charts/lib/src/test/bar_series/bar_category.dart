import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bar_sample.dart';

/// Test method for category axis in the bar series.
void barCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bar Category - Defualt Properties', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _BarCategory chartContainer =
          _barCategory('category_default') as _BarCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
//     test('test series count', () {
//       expect(chart!.series.length, 1);
//     });

//     test('to test primaryXAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
//           'India');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
//           'Japan');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
//           'Russia');
//     });

//     test('to test primaryYAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
//           '0');
//       expect(
//           _chartState!
//               ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
//           '60');
//     });

// //Category Axis
//     testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
//       final _BarCategory chartContainer =
//           _barCategory('category_labelPlacement') as _BarCategory;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test primaryXAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
//           'India');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
//           'Japan');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
//           'Russia');
//     });

//     test('to test primaryYAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
//           '0');
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
//           '15');
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
//           '20');
//     });
  });

  group('Bar Category - Axis Elements', () {
    // testWidgets('Category axis - EdgeLabelPlacement',
    //     (WidgetTester tester) async {
    //   final _BarCategory chartContainer =
    //       _barCategory('category_EdgeLabelPlacement') as _BarCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;

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
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //       '15');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    //Category Axis
    testWidgets('Category axis - Inversed', (WidgetTester tester) async {
      final _BarCategory chartContainer =
          _barCategory('category_inversed') as _BarCategory;
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

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    //Category Axis
    // testWidgets('Category axis - Opposed', (WidgetTester tester) async {
    //   final _BarCategory chartContainer =
    //       _barCategory('category_opposed') as _BarCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels and segment', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final Rect rect = seriesRenderer._dataPoints[0].region!;
    //   expect(rect.left.toInt(), 0);
    //   expect(rect.top.toInt(), 423);
    //   expect(rect.right.toInt(), 372);
    //   expect(rect.bottom.toInt(), 524);
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
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //       '20');
    // });

    //Category Axis
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _BarCategory chartContainer =
          _barCategory('category_label_tickPosition') as _BarCategory;
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
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    //Category Axis
    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _BarCategory chartContainer =
          _barCategory('category_gridlines') as _BarCategory;
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
    // testWidgets('Category Axis - Label Style', (WidgetTester tester) async {
    //   final _BarCategory chartContainer =
    //       _barCategory('category_labelStyle') as _BarCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;

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

    // //Category Axis
    // testWidgets('Category Axis - Visibility', (WidgetTester tester) async {
    //   final _BarCategory chartContainer =
    //       _barCategory('category_axisVisible') as _BarCategory;
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
      final _BarCategory chartContainer =
          _barCategory('category_axisLine_title') as _BarCategory;
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

StatelessWidget _barCategory(String sampleName) {
  return _BarCategory(sampleName);
}

// ignore: must_be_immutable
class _BarCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BarCategory(String sampleName) {
    chart = getBarChart(sampleName);
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
