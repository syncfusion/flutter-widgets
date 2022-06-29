import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stepline_series.dart';

/// Test method of the step line series performance.
void steplinePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Stepline - default performance', () {
    testWidgets('Stepline - Default - 10K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('default_stepline', 10000)
              as _SteplinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1500, true);
    // });

    testWidgets('Stepline - Default - 10K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('default_stepline', 50000)
              as _SteplinePerformance;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart.key;
      // _chartState = key.currentState;
    });
    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // // to test series data count
    // test('to test series data length', () {
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(chart.series[0].dataSource.length, 50000);
    // });

    //Commented the below test case, since removed _renderDuration property from
    // chart_base.dart file. Need to check for another possibilities.
    // //to test series render duration
    // test('to test render duration', () {
    //   expect(_chartState._renderDuration.inMilliseconds < 1950, true);
    // });

    testWidgets('Stepline - Default - 1L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('default_stepline', 100000)
              as _SteplinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2850, true);
    // });

    testWidgets('Stepline - Default - 2L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('default_stepline', 200000)
              as _SteplinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 5600, true);
    // });
  });

  group('Stepline - with marker performance', () {
    testWidgets('Stepline - with marker - 10K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_marker', 10000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 1500, true);
    // });

    testWidgets('Stepline - with marker - 50K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_marker', 50000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 1935, true);
    // });

    testWidgets('Stepline - with marker - 1L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_marker', 100000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 2945, true);
    // });

    testWidgets('Stepline - with marker - 2L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_marker', 200000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 5600, true);
    // });
  });

  group('Stepline - with datalabel performance', () {
    testWidgets('Stepline - with datalabel - 10K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_datalabel', 10000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 1500, true);
    // });

    testWidgets('Stepline - with datalabel - 50K', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_datalabel', 50000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 1900, true);
    // });

    testWidgets('Stepline - with datalabel - 1L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_datalabel', 100000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 3000, true);
    // });

    testWidgets('Stepline - with datalabel - 2L', (WidgetTester tester) async {
      final _SteplinePerformance chartContainer =
          _steplinePerformance('stepline_with_datalabel', 200000)
              as _SteplinePerformance;
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
    //   print(_chartState._renderDuration.inMilliseconds);
    //   expect(_chartState._renderDuration.inMilliseconds < 5600, true);
    // });
  });
}

StatelessWidget _steplinePerformance(String sampleName, int noOfSamples) {
  return _SteplinePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _SteplinePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SteplinePerformance(String sampleName, int noOfSamples) {
    chart = getSteplinePerformanceChart(sampleName, noOfSamples);
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
