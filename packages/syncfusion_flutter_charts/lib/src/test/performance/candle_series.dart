import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'candle_samples.dart';

/// Test method of the candle series performance.
void candlePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Candle - default performance', () {
    testWidgets('Candle - Default - 10K', (WidgetTester tester) async {
      final _CandlePerformance chartContainer =
          _candlePerformance('default_candle', 10000) as _CandlePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 10000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 85000, true);
    // });

    testWidgets('Candle - Default - 20K', (WidgetTester tester) async {
      final _CandlePerformance chartContainer =
          _candlePerformance('default_candle', 20000) as _CandlePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 20000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 475000, true);
    // });

    // testWidgets('Candle - Default - 1L', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('default_candle', 100000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 100000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 1300, true);
    // });

    // testWidgets('Candle - Default - 2L', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('default_candle', 200000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 200000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 2200, true);
    // });
  });

  // group('Candle - with marker performance',(){
  //   testWidgets('Candle - with marker - 10K', (WidgetTester tester) async {
  //     final _CandlePerformance chartContainer = _candlePerformance('candle_with_marker', 10000);
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
  //   });
  //   // to test series data count
  //   test('to test series data length', () {
  //     expect(chart.series[0].dataSource.length, 10000);
  //   });
  //   // to test series render duration
  //   test('to test render duration', () {
  //     print(_chartState._renderDuration.inMilliseconds);
  //     expect(_chartState._renderDuration.inMilliseconds < 67000, true);
  //   });

  //   testWidgets('Candle - with marker - 20K', (WidgetTester tester) async {
  //     final _CandlePerformance chartContainer = _candlePerformance('candle_with_marker', 20000);
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
  //   });
  //   // to test series data count
  //   test('to test series data length', () {
  //     expect(chart.series[0].dataSource.length, 20000);
  //   });
  //   // to test series render duration
  //   test('to test render duration', () {
  //     print(_chartState._renderDuration.inMilliseconds);
  //     expect(_chartState._renderDuration.inMilliseconds < 475000, true);
  //   });

  //   // testWidgets('Candle - with marker - 1L', (WidgetTester tester) async {
  //   //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_marker', 100000);
  //   //   await tester.pumpWidget(chartContainer);
  //   //   chart = chartContainer.chart;
  //   final GlobalKey key = chart.key;
  //   _chartState = key.currentState;
  //   // });
  //   // // to test series data count
  //   // test('to test series data length', () {
  //   //   expect(chart.series[0].dataSource.length, 200000);
  //   // });
  //   // // to test series render duration
  //   // test('to test render duration', () {
  //   //   print(_chartState._renderDuration.inMilliseconds);
  //   //   expect(_chartState._renderDuration.inMilliseconds < 1900, true);
  //   // });

  //   // testWidgets('Candle - with marker - 2L', (WidgetTester tester) async {
  //   //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_marker', 200000);
  //   //   await tester.pumpWidget(chartContainer);
  //   //   chart = chartContainer.chart;
  //   final GlobalKey key = chart.key;
  //   _chartState = key.currentState;
  //   // });
  //   // // to test series data count
  //   // test('to test series data length', () {
  //   //   expect(chart.series[0].dataSource.length, 200000);
  //   // });
  //   // // to test series render duration
  //   // test('to test render duration', () {
  //   //   print(_chartState._renderDuration.inMilliseconds);
  //   //   expect(_chartState._renderDuration.inMilliseconds < 4100, true);
  //   // });
  // });

  group('Candle - with datalabel performance', () {
    // testWidgets('Candle - with datalabel - 10K', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_datalabel', 10000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 10000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 65000, true);
    // });

    // testWidgets('Candle - with datalabel - 20K', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_datalabel', 20000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 20000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 475000, true);
    // });

    // testWidgets('Candle - with datalabel - 1L', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_datalabel', 100000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 100000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 1300, true);
    // });

    // testWidgets('Candle - with datalabel - 2L', (WidgetTester tester) async {
    //   final _CandlePerformance chartContainer = _candlePerformance('candle_with_datalabel', 200000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });
    // // to test series data count
    // test('to test series data length', () {
    //   expect(chart.series[0].dataSource.length, 200000);
    // });
    // // to test series render duration
    // test('to test render duration', () {
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 2200, true);
    // });
  });
}

StatelessWidget _candlePerformance(String sampleName, int noOfSamples) {
  return _CandlePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _CandlePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CandlePerformance(String sampleName, int noOfSamples) {
    chart = getCandlePerformanceChart(sampleName, noOfSamples);
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
