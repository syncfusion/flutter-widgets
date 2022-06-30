import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_area_samples.dart';

/// Test method of the range area series performance.
void rangeAreaPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('RangeArea - default performance', () {
    testWidgets('RangeArea - Default - 10K', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('default_rangeArea', 10000)
              as _RangeAreaPerformance;
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

    testWidgets('RangeArea - Default - 50K', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('default_rangeArea', 50000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1950, true);
    // });

    testWidgets('RangeArea - Default - 1L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('default_rangeArea', 100000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2800, true);
    // });

    testWidgets('RangeArea - Default - 2L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('default_rangeArea', 200000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 4600, true);
    // });
  });

  group('RangeArea - with marker performance', () {
    testWidgets('RangeArea - with marker - 10K', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_marker', 10000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3500, true);
    // });

    testWidgets('RangeArea - with marker - 50K', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_marker', 50000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 5800, true);
    // });

    testWidgets('RangeArea - with marker - 1L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_marker', 100000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3300, true);
    // });

    testWidgets('RangeArea - with marker - 2L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_marker', 200000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 6100, true);
    // });
  });

  group('RangeArea - with datalabel performance', () {
    testWidgets('RangeArea - with datalabel - 10K',
        (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_datalabel', 10000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 450, true);
    // });

    testWidgets('RangeArea - with datalabel - 50K',
        (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_datalabel', 50000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1000, true);
    // });

    testWidgets('RangeArea - with datalabel - 1L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_datalabel', 100000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1800, true);
    // });

    testWidgets('RangeArea - with datalabel - 2L', (WidgetTester tester) async {
      final _RangeAreaPerformance chartContainer =
          _rangeAreaPerformance('rangeArea_with_datalabel', 200000)
              as _RangeAreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 4700, true);
    // });
  });
}

StatelessWidget _rangeAreaPerformance(String sampleName, int noOfSamples) {
  return _RangeAreaPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _RangeAreaPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeAreaPerformance(String sampleName, int noOfSamples) {
    chart = getRangeAreaPerformanceChart(sampleName, noOfSamples);
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
