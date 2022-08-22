import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the MACD indicator.
void macdIndicator() {
  SfCartesianChart? chart;
  group('macd_indicator', () {
    testWidgets('Legend', (WidgetTester tester) async {
      final _MacdData chartContainer = _macdData('macd_legend') as _MacdData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.indicators[0].isVisibleInLegend, true);
      expect(chart!.indicators[0].legendIconType, LegendIconType.diamond);
      expect(chart!.indicators[0].legendItemText, 'MACD');
    });
    testWidgets('MACD properties', (WidgetTester tester) async {
      final _MacdData chartContainer =
          _macdData('macd_visibility') as _MacdData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      final MacdIndicator<dynamic, dynamic> indicator =
          chart!.indicators[0] as MacdIndicator<dynamic, dynamic>;
      expect(indicator.isVisible, true);
      expect(indicator.seriesName, 'Balloon');
      expect(indicator.name, 'MACD');
      expect(indicator.period, 2);
      expect(indicator.shortPeriod, 5);
      expect(indicator.longPeriod, 10);
      expect(indicator.macdType, MacdType.both);
      expect(indicator.histogramNegativeColor, Colors.red);
      expect(indicator.histogramPositiveColor, Colors.green);
      expect(indicator.macdLineColor, Colors.orange);
      expect(indicator.signalLineColor, Colors.purple);
      expect(indicator.signalLineWidth, 1);
      expect(indicator.macdLineWidth, 1);
    });

    testWidgets('MACD indicator render event', (WidgetTester tester) async {
      final _MacdData chartContainer = _macdData('render_event') as _MacdData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      // CartesianSeries<dynamic, dynamic> series;
      // series = _chartState._chartSeries.visibleSeries[1];
      // expect(series.dashArray, <double>[4, 3]);
      // series = _chartState._chartSeries.visibleSeries[2];
      // expect(series.color, Colors.grey);
      // expect(series.width, 3);
      // expect(series.name, 'EventChange');
      final MacdIndicator<dynamic, dynamic> indicator =
          chart!.indicators[1] as MacdIndicator<dynamic, dynamic>;
      expect(indicator.isVisible, true);
      expect(indicator.seriesName, 'Balloon');
    });
    testWidgets('MACD indicator render event', (WidgetTester tester) async {
      final _MacdData chartContainer = _macdData('macd_callback') as _MacdData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _macdData(String sampleName) {
  return _MacdData(sampleName);
}

// ignore: must_be_immutable
class _MacdData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MacdData(String sampleName) {
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
