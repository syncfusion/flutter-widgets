import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the EMA indicator.
void emaindicator() {
  SfCartesianChart? chart;
  group('ema_indicator', () {
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_default') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     87.12);
      expect(chart!.indicators[0].period, 14);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_legend') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
      expect(chart!.indicators[0].period, 3);
      expect(chart!.indicators[0].legendItemText, 'ema');
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_tooltip') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator tooltip', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.indicators[0].period, 3);
    });
    test('to test is transposed', () {
      expect(chart!.isTransposed, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer =
          _emaData('ema_without_series') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator without series', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.indicators[0].period, 14);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_trackball') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator without series', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.trackballBehavior.enable, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_notvisible') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //  final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator visiblity', () {
      expect(chart!.indicators[0].isVisible, false);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_field_high') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator ema in valueField  high', () {
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].high,
      //     93.2557);
      expect(chart!.indicators[0].period, 3);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_field_open') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator ema in valueField  open', () {
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![1].open,
      //     87.4885);
      expect(chart!.indicators[0].period, 3);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_field_low') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator ema in valueField  low', () {
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![1].low,
      //     84.4285);
      expect(chart!.indicators[0].period, 3);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_invalidperiod') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator ema in valueField  low', () {
      // expect(
      //     _chartState!._technicalIndicatorRenderer[0]._renderPoints.length, 0);
      expect(chart!.indicators[0].period, -1);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('multiple_ema') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test multiple emas', () {
      expect(chart!.indicators.length, 2);
      //expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('multiple_average') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test multiple series', () {
      expect(chart!.indicators.length, 2);
      // expect(_chartState!._renderingDetails.isLegendToggled, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._indicatorType, 'TMA');
      // expect(_chartState!._technicalIndicatorRenderer[1]._indicatorType, 'EMA');
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_numeric') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test different axis', () {
      expect(chart!.indicators.length, 1);
      //   expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator callback', (WidgetTester tester) async {
      final _EmaData chartContainer = _emaData('ema_callback') as _EmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test different axis', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _emaData(String sampleName) {
  return _EmaData(sampleName);
}

// ignore: must_be_immutable
class _EmaData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _EmaData(String sampleName) {
    chart = getIndicators(sampleName);
  }
  SfCartesianChart? chart;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'indicators Demo',
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
