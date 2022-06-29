import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'radialbar_sample.dart';

/// Test method of the legend in radial bar series.
void radialBarLegend() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Radialbar Legend', () {
    testWidgets(
        'Accumulation Chart Widget - Testing radialbar series with Legend',
        (WidgetTester tester) async {
      final _RadialBarLegend chartContainer =
          _radialBarLegend('legend_bottom') as _RadialBarLegend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test legend properties', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor!.value, Colors.red.value);
      expect(legend.borderColor.value, Colors.black.value);
      expect(legend.borderWidth.toInt(), 1);
      expect(legend.position, LegendPosition.bottom);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing radialbar series with Legend Top',
        (WidgetTester tester) async {
      final _RadialBarLegend chartContainer =
          _radialBarLegend('legend_top') as _RadialBarLegend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test legend properties', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor!.value, Colors.red.value);
      expect(legend.borderColor.value, Colors.black.value);
      expect(legend.borderWidth.toInt(), 1);
      expect(legend.position, LegendPosition.top);
    });

    //Commented the below cases since overflow exception is thrown
    testWidgets(
        'Accumulation Chart Widget - Testing radialbar series with Legend Left',
        (WidgetTester tester) async {
      final _RadialBarLegend chartContainer =
          _radialBarLegend('legend_left') as _RadialBarLegend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test legend properties', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor!.value, Colors.red.value);
      expect(legend.borderColor.value, Colors.black.value);
      expect(legend.borderWidth.toInt(), 1);
      expect(legend.position, LegendPosition.left);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing radialbar series with Legend Right',
        (WidgetTester tester) async {
      final _RadialBarLegend chartContainer =
          _radialBarLegend('legend_right') as _RadialBarLegend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test legend properties', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor!.value, Colors.red.value);
      expect(legend.borderColor.value, Colors.black.value);
      expect(legend.borderWidth.toInt(), 1);
      expect(legend.position, LegendPosition.right);
    });
  });
}

StatelessWidget _radialBarLegend(String sampleName) {
  return _RadialBarLegend(sampleName);
}

// ignore: must_be_immutable
class _RadialBarLegend extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RadialBarLegend(String sampleName) {
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
