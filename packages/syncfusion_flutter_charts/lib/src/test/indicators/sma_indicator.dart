import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'indicator_samples.dart';

/// Test method of the SMA indicator.
void smaindicator() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('sma_indicator', () {
    //region needd to be compared with test cases

    final List<Rect> region = <Rect>[];
    region.add(
        const Rect.fromLTRB(38.0, 280.5013333333333, 54.0, 296.5013333333333));
    region.add(const Rect.fromLTRB(
        221.5, 284.8953133333333, 237.5, 300.8953133333333));
    region.add(const Rect.fromLTRB(
        405.0, 305.35999999999996, 421.0, 321.35999999999996));
    region.add(const Rect.fromLTRB(
        588.5, 327.73596000000003, 604.5, 343.73596000000003));
    region.add(const Rect.fromLTRB(
        772.0, 342.3188333333333, 788.0, 358.3188333333333));

    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_default') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.indicators[0].period, 1);
    });
    // test('to test renderPoints Region', () {
    //   for (int i = 0; i < chart.indicators.length; i++) {
    //     final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //         _chartState._technicalIndicatorRenderer[i];
    //     for (int j = 0;
    //         j < _techicalIndicatorsRenderer._renderPoints.length;
    //         j++) {
    //       expect(_techicalIndicatorsRenderer._renderPoints.length, 5);
    //       final Rect renderpoints =
    //           _techicalIndicatorsRenderer._renderPoints[j].region;
    //       expect(region[j].left.toInt(), renderpoints.left.toInt());
    //       expect(region[j].top.toInt(), renderpoints.top.toInt());
    //       expect(region[j].right.toInt(), renderpoints.right.toInt());
    //       expect(region[j].bottom.toInt(), renderpoints.bottom.toInt());
    //     }
    //   }
    // });
    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_legend') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend1', () {
      final SmaIndicator<dynamic, dynamic> smainndicator =
          chart!.indicators[0] as SmaIndicator<dynamic, dynamic>;
      expect(smainndicator.isVisible, true);
      expect(smainndicator.legendIconType, LegendIconType.diamond);
    });

    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_tooltip') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend2', () {
      expect(chart!.indicators[0].isVisible, true);
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.indicators[0].period, 2);
    });
    //region points compared with testcases
    final List<Rect> region1 = <Rect>[];
    region1
        .add(const Rect.fromLTRB(382.0, 119.22699399999999, 398.0, 135.226994));
    region1.add(const Rect.fromLTRB(
        554.0, 133.39738199999996, 570.0, 149.39738199999996));
    region1.add(const Rect.fromLTRB(
        726.0, 150.62443800000003, 742.0, 166.62443800000003));

    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_field') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend3', () {
      final SmaIndicator<dynamic, dynamic> smaindicator =
          chart!.indicators[0] as SmaIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(smaindicator.valueField, 'close');
    });
    // test('to test renderPoints Region0', () {
    //   for (int i = 0; i < chart.indicators.length; i++) {
    //     final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //         _chartState._technicalIndicatorRenderer[i];
    //     for (int j = 0;
    //         j < _techicalIndicatorsRenderer._renderPoints.length;
    //         j++) {
    //       final Rect renderpoints =
    //           _techicalIndicatorsRenderer._renderPoints[j].region;
    //       expect(region1[j].left.toInt(), renderpoints.left.toInt());
    //       expect(region1[j].top.toInt(), renderpoints.top.toInt());
    //       expect(region1[j].right.toInt(), renderpoints.right.toInt());
    //       expect(region1[j].bottom.toInt(), renderpoints.bottom.toInt());
    //     }
    //   }
    // });
    final List<Rect> region2 = <Rect>[];
    region2.add(const Rect.fromLTRB(
        221.5, 271.06293999999997, 237.5, 287.06293999999997));
    region2.add(const Rect.fromLTRB(
        405.0, 285.15890999999993, 421.0, 301.15890999999993));
    region2.add(const Rect.fromLTRB(
        588.5, 296.03246999999993, 604.5, 312.03246999999993));
    region2.add(const Rect.fromLTRB(772.0, 311.35452, 788.0, 327.35452));

    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_field1') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend4', () {
      final SmaIndicator<dynamic, dynamic> smaindicator =
          chart!.indicators[0] as SmaIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(smaindicator.valueField, 'open');
    });
    // test('to test renderPoints Region1', () {
    //   for (int i = 0; i < chart.indicators.length; i++) {
    //     final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //         _chartState._technicalIndicatorRenderer[i];
    //     for (int j = 0;
    //         j < _techicalIndicatorsRenderer._renderPoints.length;
    //         j++) {
    //       final Rect renderpoints =
    //           _techicalIndicatorsRenderer._renderPoints[j].region;
    //       expect(region2[j].left.toInt(), renderpoints.left.toInt());
    //       expect(region2[j].top.toInt(), renderpoints.top.toInt());
    //       expect(region2[j].right.toInt(), renderpoints.right.toInt());
    //       expect(region2[j].bottom.toInt(), renderpoints.bottom.toInt());
    //     }
    //   }
    // });
    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_field2') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    // test('to test indicator legend4', () {
    //   final SmaIndicator<dynamic, dynamic> _smaindicator = chart.indicators[0];
    //   final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //       _chartState._technicalIndicatorRenderer[0];
    //   expect(chart.indicators[0].isVisible, true);
    //   expect(_smaindicator.valueField, 'low');
    //   expect(
    //       _techicalIndicatorsRenderer._renderPoints[0].xValue, 1351449000000);
    //   expect(_techicalIndicatorsRenderer._renderPoints[0].yValue,
    //       84.54136666666666);
    //   expect(
    //       _techicalIndicatorsRenderer._renderPoints[13].xValue, 1359311400000);
    //   expect(_techicalIndicatorsRenderer._renderPoints[13].yValue, 64.4876);
    // });
    testWidgets('sma indicator sample', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_field3') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    // test('to test indicator legend', () {
    //   final SmaIndicator<dynamic, dynamic> _smaindicator = chart.indicators[0];
    //   final TechnicalIndicatorsRenderer _techicalIndicatorsRenderer =
    //       _chartState._technicalIndicatorRenderer[0];
    //   expect(chart.indicators[0].isVisible, true);
    //   expect(_smaindicator.valueField, 'high');
    //   expect(
    //       _techicalIndicatorsRenderer._renderPoints[0].xValue, 1351449000000);
    //   expect(_techicalIndicatorsRenderer._renderPoints[0].yValue,
    //       90.05566666666668);
    //   expect(
    //       _techicalIndicatorsRenderer._renderPoints[13].xValue, 1359311400000);
    //   expect(_techicalIndicatorsRenderer._renderPoints[13].yValue,
    //       70.87333333333335);
    // });
    testWidgets('sma datasource', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_dataSource') as _SmaData;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test indicator legend', () {
      final SmaIndicator<dynamic, dynamic> smaindicator =
          chart!.indicators[0] as SmaIndicator<dynamic, dynamic>;
      expect(chart!.indicators[0].isVisible, true);
      expect(smaindicator.valueField, 'open');
    });
    testWidgets('sma callback', (WidgetTester tester) async {
      final _SmaData chartContainer = _smaData('sma_callback') as _SmaData;
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

StatelessWidget _smaData(String sampleName) {
  return _SmaData(sampleName);
}

// ignore: must_be_immutable
class _SmaData extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SmaData(String sampleName) {
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
