import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the AD indicator.
void adindicator() {
  SfCartesianChart? chart;

  group('ad_indicator', () {
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_default') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     87.12);
      expect(chart!.indicators[0].period, 14);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_legend') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
      expect(chart!.indicators[0].period, 14);
      expect(chart!.indicators[0].legendItemText, 'ad');
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_tooltip') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator tooltip', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.indicators[0].period, 14);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].volume,
      //     646996264.0);
    });
    test('to test is transposed', () {
      expect(chart!.isTransposed, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_without_series') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator without series', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     87.12);
      expect(chart!.indicators[0].period, 14);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_trackball') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator trackball', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     87.12);
      expect(chart!.trackballBehavior.enable, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_notvisible') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator visiblity', () {
      expect(chart!.indicators[0].isVisible, false);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('multiple_ema') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test multiple emas', () {
      // expect(chart!.indicators.length, 2);
      // expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator callback', (WidgetTester tester) async {
      final _AdIndicator chartContainer =
          _adIndicator('ad_callback') as _AdIndicator;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // await tester.pump(const Duration(seconds: 3));
    });
    test('to test callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _adIndicator(String sampleName) {
  return _AdIndicator(sampleName);
}

// ignore: must_be_immutable
class _AdIndicator extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AdIndicator(String sampleName) {
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
