import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'line_samples.dart';

/// Test method of the line series performance.
void linePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Line - default performance', () {
    testWidgets('Line - Default - 10K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('default_line', 10000) as _LinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1250, true);
    // });

    testWidgets('Line - Default - 50K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('default_line', 50000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 50000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 1700, true);
    // });

    testWidgets('Line - Default - 1L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('default_line', 100000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 2700, true);
    // });

    testWidgets('Line - Default - 2L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('default_line', 200000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 200000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 5700, true);
    // });
  });

  group('Line - with marker performance', () {
    testWidgets('Line - with marker - 10K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_marker', 10000) as _LinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1400, true);
    // });

    testWidgets('Line - with marker - 50K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_marker', 50000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 50000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 2100, true);
    // });

    testWidgets('Line - with marker - 1L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_marker', 100000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 3600, true);
    // });

    testWidgets('Line - with marker - 2L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_marker', 200000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 200000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 7400, true);
    // });
  });

  group('Line - with datalabel performance', () {
    testWidgets('Line - with datalabel - 10K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_datalabel', 10000) as _LinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1250, true);
    // });

    testWidgets('Line - with datalabel - 50K', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_datalabel', 50000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 50000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 1550, true);
    // });

    testWidgets('Line - with datalabel - 1L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_datalabel', 100000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 3600, true);
    // });

    testWidgets('Line - with datalabel - 2L', (WidgetTester tester) async {
      final _LinePerformance chartContainer =
          _linePerformance('line_with_datalabel', 200000) as _LinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 200000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 5500, true);
    // });
  });
}

StatelessWidget _linePerformance(String sampleName, int noOfSamples) {
  return _LinePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _LinePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _LinePerformance(String sampleName, int noOfSamples) {
    chart = getLinePerformanceChart(sampleName, noOfSamples);
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
