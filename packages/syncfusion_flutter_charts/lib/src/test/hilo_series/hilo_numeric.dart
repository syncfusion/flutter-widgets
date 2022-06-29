import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'hilo_sample.dart';

/// Test method for numeric axis of the Hilo series.
void hiloNumericAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Hilo Numeric - Defualt Properties', () {
    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('customization_default') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_fillcolor') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_border') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_datalabel') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_negative_animation') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_high_and_close_null_value')
              as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_transposed') as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('Numeric axis - Default', (WidgetTester tester) async {
      final _HiloNumeric chartContainer =
          _hiloNumeric('numeric_axis_negative_animation_with_transposed')
              as _HiloNumeric;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
  });
}

StatelessWidget _hiloNumeric(String sampleName) {
  return _HiloNumeric(sampleName);
}

// ignore: must_be_immutable
class _HiloNumeric extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HiloNumeric(String sampleName) {
    chart = getHiloChart(sampleName);
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
