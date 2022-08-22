import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'column_sample.dart';

/// Test method of category axis of the column series.
void columnCategoryAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Column Category', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _ColumnCategory chartContainer =
          _columnCategory('category_default') as _ColumnCategory;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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
    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 79);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 669);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 72);
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
  });

  group('Column Category - Axis Element', () {
    //Category Axis
    testWidgets('Category axis - LabelPlacement', (WidgetTester tester) async {
      final _ColumnCategory chartContainer =
          _columnCategory('category_labelPlacement') as _ColumnCategory;
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

//     test('to test primaryXAxis first label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
//       expect(region.left.toInt(), 4);
//       expect(region.top.toInt(), 510);
//       expect(region.width.toInt(), 60);
//       expect(region.height.toInt(), 12);
//     });
//     test('to test primaryXAxis last label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
//       expect(region.left.toInt(), 744);
//       expect(region.top.toInt(), 510);
//       expect(region.width.toInt(), 72);
//       expect(region.height.toInt(), 12);
//     });

//     test('to test primaryYAxis first label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
//       expect(region.left.toInt(), 12);
//       expect(region.top.toInt(), 496);
//       expect(region.width.toInt(), 12);
//       expect(region.height.toInt(), 12);
//     });
//     test('to test primaryYAxis last label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
//       expect(region.left.toInt(), 0);
//       expect(region.top.toInt(), -6);
//       expect(region.width.toInt(), 24);
//       expect(region.height.toInt(), 12);
//     });

// //Category Axis
//     testWidgets('Category axis - EdgeLabelPlacement Hide',
//         (WidgetTester tester) async {
//       final _ColumnCategory chartContainer =
//           _columnCategory('category_EdgeLabelPlacement_hide')
//               as _ColumnCategory;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test primaryXAxis first label location', () {
//       final Rect? region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion;
//       expect(region, const Rect.fromLTRB(79.0, 510.0, 139.0, 522.0));
//     });
//     test('to test primaryXAxis last label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
//       expect(region.left, 669);
//       expect(region.top.toInt(), 510);
//     });

//     test('to test primaryYAxis first label location', () {
//       final Rect? region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion;
//       expect(region, null);
//     });
//     test('to test primaryYAxis last label location', () {
//       final Rect? region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion;
//       expect(region, null);
//     });

//     testWidgets('Category axis - EdgeLabelPlacement Shift',
//         (WidgetTester tester) async {
//       final _ColumnCategory chartContainer =
//           _columnCategory('category_EdgeLabelPlacement_shift')
//               as _ColumnCategory;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test primaryXAxis first label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
//       expect(region.left.toInt(), 79);
//       expect(region.top.toInt(), 510);
//       expect(region.width.toInt(), 60);
//       expect(region.height.toInt(), 12);
//     });
//     test('to test primaryXAxis last label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
//       expect(region.left.toInt(), 669);
//       expect(region.top.toInt(), 510);
//     });

//     test('to test primaryYAxis first label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
//       expect(region.left.toInt(), 12);
//       expect(region.top.toInt(), 490);
//     });
//     test('to test primaryYAxis last label location', () {
//       final Rect region = _chartState!
//           ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
//       expect(region.left.toInt(), 0);
//       expect(region.top.toInt(), 0);
//     });

    //Category Axis
    // testWidgets('Category axis - Inversed', (WidgetTester tester) async {
    //   final _ColumnCategory chartContainer =
    //       _columnCategory('category_inversed') as _ColumnCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

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

    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 675);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 73);
    //   expect(region.top.toInt(), 510);
    //   expect(region.width.toInt(), 72);
    //   expect(region.height.toInt(), 12);
    // });

    // test('to test primaryYAxis first label location', () {
    //   final Rect? region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion;
    //   expect(region, null);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect? region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion;
    //   expect(region, null);
    // });

    // //Category Axis
    // testWidgets('Category axis - Opposed', (WidgetTester tester) async {
    //   final _ColumnCategory chartContainer =
    //       _columnCategory('category_opposed') as _ColumnCategory;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels and segment', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final LineSegment segment = seriesRenderer._segments[0] as LineSegment;
    //   expect(segment._x1.toInt(), 74);
    //   expect(segment._y1.toInt(), 256);
    //   expect(segment._x2.toInt(), 223);
    //   expect(segment._y2.toInt(), 323);
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

    // test('to test primaryXAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 45);
    //   expect(region.top.toInt(), 2);
    //   expect(region.width.toInt(), 60);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryXAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryXAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 635);
    //   expect(region.top.toInt(), 2);
    //   expect(region.width.toInt(), 72);
    //   expect(region.height.toInt(), 12);
    // });

    // test('to test primaryYAxis first label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels[0]._labelRegion!;
    //   expect(region.left.toInt(), 756);
    //   expect(region.top.toInt(), 518);
    //   expect(region.width.toInt(), 12);
    //   expect(region.height.toInt(), 12);
    // });
    // test('to test primaryYAxis last label location', () {
    //   final Rect region = _chartState!
    //       ._chartAxis._primaryYAxisRenderer._visibleLabels.last._labelRegion!;
    //   expect(region.left.toInt(), 756);
    //   expect(region.top.toInt(), 16);
    //   expect(region.width.toInt(), 24);
    //   expect(region.height.toInt(), 12);
    // });

    //Category Axis
    testWidgets('Category Axis - Label and Tick Position',
        (WidgetTester tester) async {
      final _ColumnCategory chartContainer =
          _columnCategory('category_label_tickPosition') as _ColumnCategory;
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

    //Category Axis
    testWidgets('Category Axis - Major Grid and Tick lines',
        (WidgetTester tester) async {
      final _ColumnCategory chartContainer =
          _columnCategory('category_gridlines') as _ColumnCategory;
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

    //Category Axis
    // testWidgets('Category Axis - Label Style', (WidgetTester tester) async {
    //   final _ColumnCategory chartContainer =
    //       _columnCategory('category_labelStyle') as _ColumnCategory;
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

    // //Category Axis
    // testWidgets('Category Axis - Visibility', (WidgetTester tester) async {
    //   final _ColumnCategory chartContainer =
    //       _columnCategory('category_axisVisible') as _ColumnCategory;
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

    //Category Axis
    testWidgets('Category Axis - Axis Line', (WidgetTester tester) async {
      final _ColumnCategory chartContainer =
          _columnCategory('category_axisLine_title') as _ColumnCategory;
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
  });
}

StatelessWidget _columnCategory(String sampleName) {
  return _ColumnCategory(sampleName);
}

// ignore: must_be_immutable
class _ColumnCategory extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ColumnCategory(String sampleName) {
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
