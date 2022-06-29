import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the Stochastic indicator.
void stochasticindicator() {
  SfCartesianChart? chart;
  group('stochastic_indicator', () {
    testWidgets('stochastic indicator sample', (WidgetTester tester) async {
      final _StochasticData chartContainer =
          _stochasticData('stochastic_default') as _StochasticData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //chart.isTransposed = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.indicators[1].isVisible, false);
    });
    test('test the Line colors and width', () {
      final StochasticIndicator<dynamic, dynamic> stochasticindicator =
          chart!.indicators[0] as StochasticIndicator<dynamic, dynamic>;
      expect(stochasticindicator.upperLineColor.value, 4294940672);
      expect(stochasticindicator.upperLineWidth, 3);
      expect(stochasticindicator.lowerLineColor.value, 0);
      expect(stochasticindicator.lowerLineWidth, 3);
      expect(stochasticindicator.periodLineColor.value, 4288423856);
      expect(stochasticindicator.periodLineWidth, 3);
    });
    testWidgets('stochastic indicator sample', (WidgetTester tester) async {
      final _StochasticData chartContainer =
          _stochasticData('stochastic_legend') as _StochasticData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
    });
    testWidgets('stochastic indicator sample', (WidgetTester tester) async {
      final _StochasticData chartContainer =
          _stochasticData('stochastic_tooltip') as _StochasticData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('stochastic indicator sample', (WidgetTester tester) async {
      final _StochasticData chartContainer =
          _stochasticData('stochastic_zoneVisible') as _StochasticData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      final StochasticIndicator<dynamic, dynamic> stochastic =
          chart!.indicators[0] as StochasticIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(stochastic.showZones, true);
    });
    testWidgets('stochastic indicator callback sample',
        (WidgetTester tester) async {
      final _StochasticData chartContainer =
          _stochasticData('stochastic_callback') as _StochasticData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _stochasticData(String sampleName) {
  return _StochasticData(sampleName);
}

// ignore: must_be_immutable
class _StochasticData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StochasticData(String sampleName) {
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
