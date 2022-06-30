import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'hilo_sample.dart';

/// Test method for date time axis of the Hilo series.
void hiloDateTimeAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Hilo DateTime - Defualt Properties', () {
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('customization_default') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_fillcolor') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_border') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_datalabel') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_negative_animation') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_high_and_close_null_value')
              as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_transposed') as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloDateTime chartContainer =
          _hiloDateTime('datetime_axis_negative_animation_with_transposed')
              as _HiloDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
  });
}

StatelessWidget _hiloDateTime(String sampleName) {
  return _HiloDateTime(sampleName);
}

// ignore: must_be_immutable
class _HiloDateTime extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HiloDateTime(String sampleName) {
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
