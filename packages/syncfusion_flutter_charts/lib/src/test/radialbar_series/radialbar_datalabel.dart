import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'radialbar_sample.dart';

/// Test method of the radial bar chart data label.
void radialBarDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  //const Rect dataLabelRect = Rect.fromLTRB(369.0, 137.2, 397.0, 153.2);
  group('Radialbar - DataLabel', () {
    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with Datalabel',
        (WidgetTester tester) async {
      final _RadialBarDataLabel chartContainer =
          _radialBarDataLabel('datalabel_default') as _RadialBarDataLabel;
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

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with Datalabel',
        (WidgetTester tester) async {
      final _RadialBarDataLabel chartContainer =
          _radialBarDataLabel('datalabel_pointColor') as _RadialBarDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel point Color', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0x00000000).value);
      expect(label.borderWidth, 0.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.labelIntersectAction, LabelIntersectAction.shift);
      expect(label.useSeriesColor, true);
    });

    // test('test datalabel rect', () {
    //   final Rect labelRect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(labelRect.left.toInt(), dataLabelRect.left.toInt());
    //   expect(labelRect.top.toInt(), dataLabelRect.top.toInt());
    //   expect(labelRect.right.toInt(), dataLabelRect.right.toInt());
    //   expect(labelRect.bottom.toInt(), dataLabelRect.bottom.toInt());
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with Datalabel',
        (WidgetTester tester) async {
      final _RadialBarDataLabel chartContainer =
          _radialBarDataLabel('datalabel_customization') as _RadialBarDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.color!.value, const Color(0xfff44336).value);
    });

    // test('test datalabel rect', () {
    //   final Rect labelRect = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
    //   expect(labelRect.left.toInt(), dataLabelRect.left.toInt());
    //   expect(labelRect.top.toInt(), dataLabelRect.top.toInt());
    //   expect(labelRect.right.toInt(), dataLabelRect.right.toInt());
    //   expect(labelRect.bottom.toInt(), dataLabelRect.bottom.toInt());
    // });
    testWidgets('Data label- isVisibleForZero property',
        (WidgetTester tester) async {
      final _RadialBarDataLabel chartContainer =
          _radialBarDataLabel('radial_isVisibleForZero') as _RadialBarDataLabel;
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

StatelessWidget _radialBarDataLabel(String sampleName) {
  return _RadialBarDataLabel(sampleName);
}

// ignore: must_be_immutable
class _RadialBarDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RadialBarDataLabel(String sampleName) {
    chart = getRadialbarchart(sampleName);
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
