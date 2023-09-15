import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'hilo_open_close_sample.dart';

/// Test method for date time axis of the Hilo open-close series.
void hiloOpenCloseDateTimeAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('HiloOpenClose DateTime - Defualt Properties', () {
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('customization_default')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis') as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_fillcolor')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_border')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_datalabel')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_negative_animation')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_high_and_close_null_value')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer =
          _hiloOpenCloseDateTime('datetime_axis_transposed')
              as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _HiloOpenCloseDateTime chartContainer = _hiloOpenCloseDateTime(
              'datetime_axis_negative_animation_with_transposed')
          as _HiloOpenCloseDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
  });
}

StatelessWidget _hiloOpenCloseDateTime(String sampleName) {
  return _HiloOpenCloseDateTime(sampleName);
}

// ignore: must_be_immutable
class _HiloOpenCloseDateTime extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HiloOpenCloseDateTime(String sampleName) {
    chart = getHiloOpenCloseChart(sampleName);
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
