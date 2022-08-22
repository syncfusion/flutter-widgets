import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pie_sample.dart';

/// Testing method of pyramid chart`s legend and all its functionalities.
void pieLegend() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Pie Legend', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Legend bottom',
        (WidgetTester tester) async {
      final _PieLegend chartContainer =
          _pieLegend('legend_bottom') as _PieLegend;
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
        'Accumulation Chart Widget - Testing Pie series with Legend Top',
        (WidgetTester tester) async {
      final _PieLegend chartContainer = _pieLegend('legend_top') as _PieLegend;
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
        'Accumulation Chart Widget - Testing Pie series with Legend Left',
        (WidgetTester tester) async {
      final _PieLegend chartContainer = _pieLegend('legend_left') as _PieLegend;
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
        'Accumulation Chart Widget - Testing Pie series with Legend Right',
        (WidgetTester tester) async {
      final _PieLegend chartContainer =
          _pieLegend('legend_right') as _PieLegend;
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

StatelessWidget _pieLegend(String sampleName) {
  return _PieLegend(sampleName);
}

// ignore: must_be_immutable
class _PieLegend extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PieLegend(String sampleName) {
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
