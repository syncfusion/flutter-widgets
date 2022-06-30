import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bar_samples.dart';

/// Test method of the bar series performance.
void barPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Bar - default performance', () {
    testWidgets('Bar - Default - 10K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('default_bar', 10000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 35000, true);
    // });

    testWidgets('Bar - Default - 20K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('default_bar', 20000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 140000, true);
    // });

    // testWidgets('Bar - Default - 1L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('default_bar', 100000);
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

    // testWidgets('Bar - Default - 2L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('default_bar', 200000);
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

  group('Bar - with marker performance', () {
    testWidgets('Bar - with marker - 10K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('bar_with_marker', 10000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 40000, true);
    // });

    testWidgets('Bar - with marker - 20K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('bar_with_marker', 20000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 140000, true);
    // });

    // testWidgets('Bar - with marker - 1L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('bar_with_marker', 100000);
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1900, true);
    // });

    // testWidgets('Bar - with marker - 2L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('bar_with_marker', 200000);
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
    //   expect(_chartState._renderDuration.inMilliseconds < 4100, true);
    // });
  });

  group('Bar - with datalabel performance', () {
    testWidgets('Bar - with datalabel - 10K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('bar_with_datalabel', 10000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 40000, true);
    // });

    testWidgets('Bar - with datalabel - 20K', (WidgetTester tester) async {
      final _BarPerformance chartContainer =
          _barPerformance('bar_with_datalabel', 20000) as _BarPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 140000, true);
    // });

    // testWidgets('Bar - with datalabel - 1L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('bar_with_datalabel', 100000);
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // // final GlobalKey key = chart.key;
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

    // testWidgets('Bar - with datalabel - 2L', (WidgetTester tester) async {
    //   final _BarPerformance chartContainer = _barPerformance('bar_with_datalabel', 200000);
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

StatelessWidget _barPerformance(String sampleName, int noOfSamples) {
  return _BarPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _BarPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BarPerformance(String sampleName, int noOfSamples) {
    chart = getBarPerformanceChart(sampleName, noOfSamples);
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
