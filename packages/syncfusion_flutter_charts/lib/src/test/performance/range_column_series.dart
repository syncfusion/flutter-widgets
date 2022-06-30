import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_column_samples.dart';

/// Test method of the range column series performance.
void rangeColumnPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('RangeColumn - default performance', () {
    testWidgets('RangeColumn - Default - 10K', (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('default_rangeColumn', 10000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 37000, true);
    // });

    testWidgets('RangeColumn - Default - 20K', (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('default_rangeColumn', 20000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 145000, true);
    // });

    // testWidgets('RangeColumn - Default - 1L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('default_rangeColumn', 100000);
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

    // testWidgets('RangeColumn - Default - 2L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('default_rangeColumn', 200000);
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

  group('RangeColumn - with marker performance', () {
    testWidgets('RangeColumn - with marker - 10K', (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('rangeColumn_with_marker', 10000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 42000, true);
    // });

    testWidgets('RangeColumn - with marker - 20K', (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('rangeColumn_with_marker', 20000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 145000, true);
    // });

    // testWidgets('RangeColumn - with marker - 1L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('rangeColumn_with_marker', 100000);
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

    // testWidgets('RangeColumn - with marker - 2L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('rangeColumn_with_marker', 200000);
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

  group('RangeColumn - with datalabel performance', () {
    testWidgets('RangeColumn - with datalabel - 10K',
        (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('rangeColumn_with_datalabel', 10000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 62000, true);
    // });

    testWidgets('RangeColumn - with datalabel - 20K',
        (WidgetTester tester) async {
      final _RangeColumnPerformance chartContainer =
          _rangeColumnPerformance('rangeColumn_with_datalabel', 20000)
              as _RangeColumnPerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 145000, true);
    // });

    // testWidgets('RangeColumn - with datalabel - 1L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('rangeColumn_with_datalabel', 100000);
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

    // testWidgets('RangeColumn - with datalabel - 2L', (WidgetTester tester) async {
    //   final _RangeColumnPerformance chartContainer = _rangeColumnPerformance('rangeColumn_with_datalabel', 200000);
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

StatelessWidget _rangeColumnPerformance(String sampleName, int noOfSamples) {
  return _RangeColumnPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _RangeColumnPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeColumnPerformance(String sampleName, int noOfSamples) {
    chart = getRangeColumnPerformanceChart(sampleName, noOfSamples);
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
