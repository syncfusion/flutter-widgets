import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the Momentum indicator.
void momentumindicator() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('momentum_indicator', () {
    testWidgets('momentum indicator sample', (WidgetTester tester) async {
      final _MomentumData chartContainer =
          _momentumData('momentum_default') as _MomentumData;
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
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![15].close,
      //     64.8028);
      expect(chart!.indicators[0].signalLineColor.value, 4294961979);
      expect(chart!.indicators[0].signalLineWidth, 5);
    });
    testWidgets('momentum indicator sample', (WidgetTester tester) async {
      final _MomentumData chartContainer =
          _momentumData('momentum_legend') as _MomentumData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.legend.isVisible, true);
      expect(
          chart!.indicators[0].legendIconType, LegendIconType.invertedTriangle);
    });
    testWidgets('momentum indicator sample', (WidgetTester tester) async {
      final _MomentumData chartContainer =
          _momentumData('momentum_tooltip') as _MomentumData;
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
    // test('to test the period values', () {
    //   final TechnicalIndicatorsRenderer _techicalIndicatorsRendrer =
    //       _chartState._technicalIndicatorRenderer[0];
    //   final TechnicalIndicatorsRenderer _techicalIndicatorsRendrer1 =
    //       _chartState._technicalIndicatorRenderer[1];
    //   expect(_techicalIndicatorsRendrer._renderPoints.length, 13);
    //   expect(_techicalIndicatorsRendrer1._renderPoints.length, 0);
    //   expect(_techicalIndicatorsRendrer._renderPoints[0].xValue, 1352053800000);
    //   expect(_techicalIndicatorsRendrer._renderPoints[0].yValue,
    //       89.70546372819099);
    //   expect(
    //       _techicalIndicatorsRendrer._renderPoints[12].xValue, 1359311400000);
    //   expect(_techicalIndicatorsRendrer._renderPoints[12].yValue,
    //       87.18432364436252);
    // });

    //test the region compares=d with testcases
    final List<Rect> momentumregion = <Rect>[];
    momentumregion.add(const Rect.fromLTRB(
        588.5, 266.8845576981941, 604.5, 282.8845576981941));
    momentumregion.add(const Rect.fromLTRB(
        772.0, 279.2171147710456, 788.0, 295.2171147710456));

    testWidgets('momentum indicator sample', (WidgetTester tester) async {
      final _MomentumData chartContainer =
          _momentumData('momentum_visiblity') as _MomentumData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator visible false', () {
      expect(chart!.indicators[0].isVisible, false);
      // expect(_chartState!._technicalIndicatorRenderer[1]._dataPoints![0].close,
      //     87.12);
      expect(chart!.indicators[0].period, -1);
      expect(chart!.indicators[1].signalLineColor.value, 4294198070);
      expect(chart!.indicators[1].signalLineWidth, 4);
    });
    // test('to test renderPoints rsiregion', () {
    //   for (int i = 0; i < chart!.indicators.length; i++) {
    //     final TechnicalIndicatorsRenderer _techicalIndicatorsRendrer =
    //         _chartState!._technicalIndicatorRenderer[i];
    //     for (int j = 0;
    //         j < _techicalIndicatorsRendrer._renderPoints.length;
    //         j++) {
    //       expect(_techicalIndicatorsRendrer._renderPoints.length, 2);
    //       final Rect renderpoints =
    //           _techicalIndicatorsRendrer._renderPoints[j].region!;
    //       expect(momentumregion[j].left.toInt(), renderpoints.left.toInt());
    //       expect(momentumregion[j].top.toInt(), renderpoints.top.toInt());
    //       expect(momentumregion[j].right.toInt(), renderpoints.right.toInt());
    //       expect(momentumregion[j].bottom.toInt(), renderpoints.bottom.toInt());
    //     }
    //   }
    // });
    testWidgets('momentum indicator callback sample',
        (WidgetTester tester) async {
      final _MomentumData chartContainer =
          _momentumData('momentum_callback') as _MomentumData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator callback', () {
      expect(chart!.indicators[0].onRenderDetailsUpdate != null, true);
    });
  });
}

StatelessWidget _momentumData(String sampleName) {
  return _MomentumData(sampleName);
}

// ignore: must_be_immutable
class _MomentumData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MomentumData(String sampleName) {
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
