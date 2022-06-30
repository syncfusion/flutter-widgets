import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_series.dart';

/// Test method of the spline series performance.
void splinePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('SpLine - default performance', () {
    testWidgets('SpLine - Default - 10K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('default_spline', 10000) as _SpLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2500, true);
    // });

    testWidgets('SpLine - Default - 10K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('default_spline', 50000) as _SpLinePerformance;
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
    // //to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 30000, true);
    // });

    testWidgets('Line - Default - 1L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('default_spline', 100000) as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    // // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 290000, true);
    // });

    testWidgets('Line - Default - 2L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('default_spline', 200000) as _SpLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 500000, true);
    // });
  });

  group('Line - with marker performance', () {
    testWidgets('Line - with marker - 10K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_marker', 10000) as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 10000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 2500, true);
    // });

    testWidgets('Line - with marker - 50K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_marker', 50000) as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 50000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 290000, true);
    // });

    testWidgets('Line - with marker - 1L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_marker', 100000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 250000, true);
    // });

    testWidgets('Line - with marker - 2L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_marker', 200000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 200000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 500000, true);
    // });
  });

  group('Line - with datalabel performance', () {
    testWidgets('Line - with datalabel - 10K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_datalabel', 10000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 10000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 2500, true);
    // });

    testWidgets('Line - with datalabel - 50K', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_datalabel', 50000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 50000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 29000, true);
    // });

    testWidgets('Line - with datalabel - 1L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_datalabel', 100000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 100000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 270000, true);
    // });

    testWidgets('Line - with datalabel - 2L', (WidgetTester tester) async {
      final _SpLinePerformance chartContainer =
          _splinePerformance('spline_with_datalabel', 200000)
              as _SpLinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //   // to test series data count
    test('to test series data length', () {
      expect(chart!.series[0].dataSource!.length, 200000);
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //   // to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 500000, true);
    // });
  });
}

StatelessWidget _splinePerformance(String sampleName, int noOfSamples) {
  return _SpLinePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _SpLinePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SpLinePerformance(String sampleName, int noOfSamples) {
    chart = getSplinePerformanceChart(sampleName, noOfSamples);
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
