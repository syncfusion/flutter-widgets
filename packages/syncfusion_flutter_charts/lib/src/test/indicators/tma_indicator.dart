import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the TMA indicator.
void tmaindicator() {
  SfCartesianChart? chart;

  group('tma_indicator', () {
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_default') as _TmaData;
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
      final _TmaData chartContainer = _tmaData('tma_legend') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
      expect(chart!.indicators[0].period, 2);
      expect(chart!.indicators[0].legendItemText, 'tma');
    });
    // test('to test period change',(){
    //   expect(chart.indicators[0]._datapoints[0].low,87.0885);
    //    expect(chart.indicators[0]._datapoints[1].low,84.4285);
    //     expect(chart.indicators[0]._datapoints[2].low,82.1071);
    //      expect(chart.indicators[0]._datapoints[3].low,76.2457);
    // });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_tooltip') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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
      final _TmaData chartContainer = _tmaData('tma_field_high') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].high,
      //     93.2557);
      expect(chart!.indicators[0].period, 3);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_field_open') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].open,
      //     90.3357);
      expect(chart!.indicators[0].period, 1);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_field_close') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator tooltip', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     87.12);
      expect(chart!.indicators[0].period, 5);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer =
          _tmaData('tma_without_series') as _TmaData;
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
      final _TmaData chartContainer = _tmaData('tma_trackball') as _TmaData;
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
      expect(chart!.trackballBehavior.enable, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_notvisible') as _TmaData;
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
      final _TmaData chartContainer = _tmaData('tma_invalidperiod') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator ema in valueField  low', () {
      // expect(
      //     _chartState!._technicalIndicatorRenderer[0]._renderPoints.length, 0);
      expect(chart!.indicators[0].period, -1);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('multiple_tma') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test multiple tmas', () {
      expect(chart!.indicators.length, 2);
      // expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_numeric') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test different axis', () {
      expect(chart!.indicators.length, 1);
      //  expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator callback', (WidgetTester tester) async {
      final _TmaData chartContainer = _tmaData('tma_callback') as _TmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test different callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _tmaData(String sampleName) {
  return _TmaData(sampleName);
}

// ignore: must_be_immutable
class _TmaData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TmaData(String sampleName) {
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
