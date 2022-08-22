import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_column_sample.dart';

/// Test method of category axis of the range column series.
void rangeColumnCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

//   group('RangeColumn Category - Defualt Properties', () {
//     testWidgets('Category axis - Default', (WidgetTester tester) async {
//       final _RangeColumnCategory chartContainer =
//           _rangeColumnCategory('category_default') as _RangeColumnCategory;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

// // to test series count
//     test('test series count', () {
//       expect(chart!.series.length, 2);
//     });

//     // test('to test primaryXAxis labels', () {
//     //   expect(
//     //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
//     //       'Sun');
//     //   expect(
//     //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
//     //       'Wed');
//     //   expect(
//     //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
//     //       'Thu');
//     // });

//     // test('to test primaryYAxis labels', () {
//     //   expect(
//     //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
//     //       '0');
//     //   expect(
//     //       _chartState!
//     //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
//     //       '22');
//     // });

//     testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
//       final _RangeColumnCategory chartContainer =
//           _rangeColumnCategory('category_labelPlacement')
//               as _RangeColumnCategory;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test primaryXAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
//           'Sun');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
//           'Wed');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
//           'Thu');
//       expect(
//           _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[6].text,
//           'Sat');
//     });

//     test('to test primaryYAxis labels', () {
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
//           '0');
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
//           '6');
//       expect(
//           _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
//           '8');
//     });
//   });

  group('RangeColumn Category - Axis Elements', () {
    //   testWidgets('Category axis - EdgeLabelPlacement',
    //       (WidgetTester tester) async {
    //     final _RangeColumnCategory chartContainer =
    //         _rangeColumnCategory('category_EdgeLabelPlacement')
    //             as _RangeColumnCategory;
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
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[3].text,
    //         '1.5');
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //         '2');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[3].text,
    //         '1.5');
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //         '2');
    //   });

    //   //EdgeLabelPlacement_hide
    //   testWidgets('Category axis - EdgeLabelPlacement - hide',
    //       (WidgetTester tester) async {
    //     final _RangeColumnCategory chartContainer =
    //         _rangeColumnCategory('category_EdgeLabelPlacement_hide')
    //             as _RangeColumnCategory;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[1].text,
    //         'Mon');
    //     expect(
    //         _chartState!
    //             ._chartAxis
    //             ._primaryXAxisRenderer
    //             ._visibleLabels[_chartState!
    //                     ._chartAxis._primaryXAxisRenderer._visibleLabels.length -
    //                 2]
    //             .text,
    //         'Fri');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[1].text,
    //         '2');
    //     expect(
    //         _chartState!
    //             ._chartAxis
    //             ._primaryYAxisRenderer
    //             ._visibleLabels[_chartState!
    //                     ._chartAxis._primaryXAxisRenderer._visibleLabels.length -
    //                 2]
    //             .text,
    //         '10');
    //   });

    //   //EdgeLabelPlacement_shift
    //   testWidgets('Category axis - EdgeLabelPlacement - shift',
    //       (WidgetTester tester) async {
    //     final _RangeColumnCategory chartContainer =
    //         _rangeColumnCategory('category_EdgeLabelPlacement_shift')
    //             as _RangeColumnCategory;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0]
    //             ._labelRegion!.left
    //             .toInt(),
    //         69.0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0]
    //             ._labelRegion!.right
    //             .toInt(),
    //         105.0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels.last
    //             ._labelRegion!.left
    //             .toInt(),
    //         709.0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels.last
    //             ._labelRegion!.right
    //             .toInt(),
    //         745.0.toInt());
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0]
    //             ._labelRegion!.top
    //             .toInt(),
    //         490.0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0]
    //             ._labelRegion!.bottom
    //             .toInt(),
    //         502.0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels.last
    //             ._labelRegion!.top
    //             .toInt(),
    //         0.toInt());
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels.last
    //             ._labelRegion!.bottom
    //             .toInt(),
    //         12.toInt());
    //   });

    //   //Category Axis
    //   testWidgets('Category axis - Inversed', (WidgetTester tester) async {
    //     final _RangeColumnCategory chartContainer =
    //         _rangeColumnCategory('category_inversed') as _RangeColumnCategory;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         'Sun');
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[4].text,
    //         'Thu');
    //   });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[4].text,
    //         '8');
    //   });

    //   //Category Axis
    //   testWidgets('Category axis - Opposed', (WidgetTester tester) async {
    //     final _RangeColumnCategory chartContainer =
    //         _rangeColumnCategory('category_opposed') as _RangeColumnCategory;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   // test('to test primaryXAxis labels and segment', () {
    //   //   final CartesianSeries<dynamic,dynamic> cartesianSeries = chart.series[0];
    //   //   final Rect rect = cartesianSeriesRenderer._dataPoints[0].region;
    //   //   expect(rect.left.toInt(), 0);
    //   //   expect(rect.top.toInt(), 323);
    //   //   expect(rect.right.toInt(), 372);
    //   //   expect(rect.bottom.toInt(), 624);
    //   //   expect(_chartState._chartAxis._primaryXAxisRenderer._visibleLabels[0].text, 'India');
    //   //   expect(_chartState._chartAxis._primaryXAxisRenderer._visibleLabels[4].text, 'Russia');
    //   // });

    //   test('to test primaryYAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //         '0');
    //     expect(
    //         _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[8].text,
    //         '16');
    //   });

    //Category Axis
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_label_tickPosition')
              as _RangeColumnCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    //   test('to test primaryXAxis labels', () {
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //         'Sun');
    //     expect(
    //         _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[5].text,
    //         'Fri');
    //   });

    test('to test primaryXAxis ticks position', () {
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '0');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[7].text,
    //       '14');
    // });

    test('to test primaryYAxis ticks position', () {
      expect(chart!.primaryXAxis.tickPosition, TickPosition.inside);
    });

    //Category Axis
    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_gridlines') as _RangeColumnCategory;
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
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_labelStyle') as _RangeColumnCategory;
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
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_axisVisible') as _RangeColumnCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_axisLine_title')
              as _RangeColumnCategory;
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

    test('X axis name property with deualt value', () {
      expect(chart!.primaryXAxis.name, null);
    });

    test('Y axis name property with default value', () {
      expect(chart!.primaryYAxis.name, null);
    });

    testWidgets('Category Axis - Axis Title', (WidgetTester tester) async {
      final _RangeColumnCategory chartContainer =
          _rangeColumnCategory('category_axisTitle') as _RangeColumnCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
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
  });
}

StatelessWidget _rangeColumnCategory(String sampleName) {
  return _RangeColumnCategory(sampleName);
}

// ignore: must_be_immutable
class _RangeColumnCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeColumnCategory(String sampleName) {
    chart = getRangeColumnchart(sampleName);
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
