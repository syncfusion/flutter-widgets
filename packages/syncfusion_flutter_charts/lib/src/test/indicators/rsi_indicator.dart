import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the RSI indicator.
void rsiindicator() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('rsi_indicator', () {
    testWidgets('rsi indicator sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_default') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      final RsiIndicator<dynamic, dynamic> rsiindicator =
          chart!.indicators[0] as RsiIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(rsiindicator.upperLineColor.value, 4288585374);
      expect(rsiindicator.upperLineWidth, 3);
      expect(rsiindicator.lowerLineColor.value, 4293467747);
      expect(rsiindicator.lowerLineWidth, 3);
    });
    testWidgets('rsi indicator sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_legend') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
    });

    testWidgets('rsi indicator sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_tooltip') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.tooltipBehavior.enable, true);
    });
    // test('to test renderPoints rsiregion0', () {
    //   final TechnicalIndicatorsRenderer technicalIndicatorRenderer =
    //       _chartState._technicalIndicatorRenderer[0];
    //   expect(technicalIndicatorRenderer._renderPoints[1].xValue, 1352053800000);
    //   expect(technicalIndicatorRenderer._renderPoints[0].xValue, 1351449000000);
    // });
    testWidgets('rsi indicator sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_zoneVisible') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      final RsiIndicator<dynamic, dynamic> rsiIndicator =
          chart!.indicators[0] as RsiIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(rsiIndicator.showZones, true);
    });
    //test the region compares=d with testcases
    final List<Rect> rsiregion1 = <Rect>[];
    rsiregion1.add(const Rect.fromLTRB(
        726.0, 523.4000000000001, 742.0, 539.4000000000001));

    // test('to test renderPoints rsiregion', () {
    //   for (int i = 0; i < chart!.indicators.length; i++) {
    //     final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //         _chartState!._technicalIndicatorRenderer[i];
    //     for (int j = 0;
    //         j < _techicalIndicatorsRenderer._renderPoints.length;
    //         j++) {
    //       expect(_techicalIndicatorsRenderer._renderPoints.length, 1);
    //       final Rect renderpoints =
    //           _techicalIndicatorsRenderer._renderPoints[j].region!;
    //       expect(rsiregion1[j].left.toInt(), renderpoints.left.toInt());
    //       expect(rsiregion1[j].top.toInt(), renderpoints.top.toInt());
    //       expect(rsiregion1[j].right.toInt(), renderpoints.right.toInt());
    //       expect(rsiregion1[j].bottom.toInt(), renderpoints.bottom.toInt());
    //     }
    //   }
    // });
    testWidgets('rsi indicator sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_gain') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
    });
    testWidgets('rsi indicator callback sample', (WidgetTester tester) async {
      final _RsiData chartContainer = _rsiData('rsi_callback') as _RsiData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _rsiData(String sampleName) {
  return _RsiData(sampleName);
}

// ignore: must_be_immutable
class _RsiData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RsiData(String sampleName) {
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
