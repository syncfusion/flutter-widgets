import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'candle_sample.dart';

/// Testing method for date time axis of the candle series.
void candleDateTimeAxis() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Candle DateTime - Defualt Properties', () {
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('customization_default') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

// to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_fillcolor') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_border') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_enablesolid') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_datalabel') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_negative_animation')
              as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_high_and_close_null_value')
              as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_transposed') as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
    testWidgets('DateTime axis - Default', (WidgetTester tester) async {
      final _CandleDateTime chartContainer =
          _candleDateTime('datetime_axis_negative_animation_with_transposed')
              as _CandleDateTime;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
  });
}

StatelessWidget _candleDateTime(String sampleName) {
  return _CandleDateTime(sampleName);
}

// ignore: must_be_immutable
class _CandleDateTime extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CandleDateTime(String sampleName) {
    chart = getCandlechart(sampleName);
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
