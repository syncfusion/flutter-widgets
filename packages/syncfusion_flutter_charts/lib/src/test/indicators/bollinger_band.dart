import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the Bollinger indicator.
void bollingerindicator() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('bollingerdata', () {
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_default') as _Bollingerdata;
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
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_legend') as _Bollingerdata;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
      expect(chart!.indicators[0].period, 3);
      expect(chart!.indicators[0].legendItemText, 'bollinger');
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_tooltip') as _Bollingerdata;
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
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_without_series') as _Bollingerdata;
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
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_trackball') as _Bollingerdata;
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
      final _Bollingerdata chartContainer =
          _bollingerdata('bollingerdata_notvisible') as _Bollingerdata;
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
      final _Bollingerdata chartContainer =
          _bollingerdata('multiple_bands') as _Bollingerdata;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test multiple emas', () {
      expect(chart!.indicators.length, 2);
      //  expect(_chartState!._renderingDetails.isLegendToggled, true);
    });
    testWidgets('indicator sample', (WidgetTester tester) async {
      final _Bollingerdata chartContainer =
          _bollingerdata('multiple_series') as _Bollingerdata;
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
      // expect(_chartState!._technicalIndicatorRenderer[0]._indicatorType,
      //     'Bollinger');
      // expect(_chartState!._technicalIndicatorRenderer[1]._indicatorType, 'ATR');
    });
    testWidgets('indicator callback', (WidgetTester tester) async {
      final _Bollingerdata chartContainer =
          _bollingerdata('bollinger_callback') as _Bollingerdata;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _bollingerdata(String sampleName) {
  return _Bollingerdata(sampleName);
}

// ignore: must_be_immutable
class _Bollingerdata extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Bollingerdata(String sampleName) {
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
