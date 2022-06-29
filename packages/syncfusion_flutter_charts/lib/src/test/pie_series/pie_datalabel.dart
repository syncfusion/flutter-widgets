import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pie_sample.dart';

/// Test method of the pie chart data label.
void pieDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  // const Rect dataLabelRect = Rect.fromLTRB(
  //     435.0, 160.3048532826278, 463.9839759934087, 176.3048532826278);
  // const Rect dataLabelRect1 = Rect.fromLTRB(417.9839759934087,
  //     160.3048532826278, 481.9839759934087, 176.3048532826278);
  group('Pie - Data Label', () {
    testWidgets('Accumulation Chart Widget - Testing Pie series with Datalabel',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_default') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test datalabel default', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0x00000000).value);
      expect(label.borderWidth, 0.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.labelIntersectAction, LabelIntersectAction.shift);
      expect(label.color, null);
    });

    // test('test datalabel rect', () {
    //   final Rect labelRect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(labelRect.left.toInt(), dataLabelRect.left.toInt());
    //   expect(labelRect.top.toInt(), dataLabelRect.top.toInt());
    //   expect(labelRect.right.toInt(), dataLabelRect.right.toInt());
    //   expect(labelRect.bottom.toInt(), dataLabelRect.bottom.toInt());
    // });
    testWidgets('Accumulation Chart Widget - Testing Pie series with Datalabel',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_pointColor') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel pointColor', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0x00000000).value);
      expect(label.borderWidth, 0.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.labelIntersectAction, LabelIntersectAction.shift);
      expect(label.useSeriesColor, true);
    });

    // testWidgets('Accumulation Chart Widget - Datalabel Template',
    //     (WidgetTester tester) async {
    //   final _PieDataLabel chartContainer =
    //       _pieDataLabel('datalabel_template') as _PieDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test datalabel template', () {
    //   final Rect labelRect = _chartState._chartSeries.visibleSeriesRenderers[0]._renderPoints[0].labelRect;
    //   expect(chart.series[0].dataLabelSettings.builder, isNotNull);
    //   expect(labelRect.left.toInt(), 435);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Customization',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_customization') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.connectorLineSettings.length, '10%');
      expect(label.connectorLineSettings.width, 2.0);
      expect(label.connectorLineSettings.color!.value,
          const Color(0xff000000).value);
      expect(label.color!.value, const Color(0xfff44336).value);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Renderer',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_customization_ondatalabelrender')
              as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel customization', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0x00000000).value);
      expect(label.borderWidth, 0.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.labelIntersectAction, LabelIntersectAction.shift);
      expect(label.color, null);
    });

    // test('test datalabel rect', () {
    //   final Rect labelRect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(labelRect.left.toInt(), dataLabelRect1.left.toInt());
    //   expect(labelRect.top.toInt(), dataLabelRect1.top.toInt());
    //   expect(labelRect.right.toInt(), dataLabelRect1.right.toInt());
    //   expect(labelRect.bottom.toInt(), dataLabelRect1.bottom.toInt());
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Saturation',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_saturation') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.color, null);
      expect(label.labelPosition, ChartDataLabelPosition.outside);
    });

    // const Rect labelRect = Rect.fromLTRB(519.9647471854992, 58.67067722178115,
    //     769.9647471854992, 80.67067722178115);
    // test('test datalabel rect', () {
    //   final Rect rect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(rect.left.toInt(), labelRect.left.toInt());
    //   expect(rect.top.toInt(), labelRect.top.toInt());
    //   expect(rect.right.toInt(), labelRect.right.toInt());
    //   expect(rect.bottom.toInt(), labelRect.bottom.toInt());
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Connector Line',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_connector_line') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.labelPosition, ChartDataLabelPosition.inside);
      expect(label.connectorLineSettings.length, '10');
      expect(label.connectorLineSettings.width, 2.0);
      expect(label.connectorLineSettings.type, ConnectorType.line);
      expect(label.connectorLineSettings.color!.value,
          const Color(0xff000000).value);
      expect(label.color!.value, const Color(0xfff44336).value);
    });

    // test('test datalabel rect', () {
    //   final Rect rect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(rect.left.toInt(), 410);
    //   expect(rect.top.toInt(), 149);
    //   expect(rect.right.toInt(), 438);
    //   expect(rect.bottom.toInt(), 165);
    // });
  });

  group('Pie - Date Label Collision', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Collision Shift',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('datalabel_collide') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.color!.value, const Color(0xfff44336).value);
    });

    // test('test datalabel rect', () {
    //   final Rect rect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(rect.left.toInt(), 410);
    //   expect(rect.top.toInt(), 149);
    //   expect(rect.right.toInt(), 438);
    //   expect(rect.bottom.toInt(), 165);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Collision Hide',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('collide_hide') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.labelIntersectAction, LabelIntersectAction.hide);
    });

    // test('test datalabel rect', () {
    //   final Rect rect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(rect.left.toInt(), 302);
    //   expect(rect.top.toInt(), 149);
    //   expect(rect.right.toInt(), 546);
    //   expect(rect.bottom.toInt(), 165);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Collision Hide customization',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('collide_hide_customization') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.labelIntersectAction, LabelIntersectAction.hide);
      expect(label.color!.value, const Color(0xfff44336).value);
    });

    // test('test datalabel rect', () {
    //   final Rect rect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(rect.left.toInt(), 302);
    //   expect(rect.top.toInt(), 149);
    //   expect(rect.right.toInt(), 546);
    //   expect(rect.bottom.toInt(), 165);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Collision none',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('collide_none') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.labelIntersectAction, LabelIntersectAction.none);
    });

    // test('test datalabel rect', () {
    //   final Rect startRect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(startRect.left.toInt(), 302);
    //   expect(startRect.top.toInt(), 149);
    //   expect(startRect.right.toInt(), 546);
    //   expect(startRect.bottom.toInt(), 165);
    //   final Rect endRect = _chartState!
    //       ._chartSeries
    //       .visibleSeriesRenderers[0]
    //       ._renderPoints![_chartState!._chartSeries.visibleSeriesRenderers[0]
    //               ._renderPoints!.length -
    //           1]
    //       .labelRect;
    //   expect(endRect.left.toInt(), 47);
    //   expect(endRect.top.toInt(), 32);
    //   expect(endRect.right.toInt(), 345);
    //   expect(endRect.bottom.toInt(), 54);
    // });
    testWidgets('Data label- isVisibleForZero property',
        (WidgetTester tester) async {
      final _PieDataLabel chartContainer =
          _pieDataLabel('pie_isVisibleForZero') as _PieDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.showZeroValue, false);
    });
  });
}

StatelessWidget _pieDataLabel(String sampleName) {
  return _PieDataLabel(sampleName);
}

// ignore: must_be_immutable
class _PieDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PieDataLabel(String sampleName) {
    chart = getPiechart(sampleName);
  }
  SfCircularChart? chart;

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
