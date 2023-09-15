import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'hilo_samples.dart';

/// Test method of the Hilo series performance.
void hiloPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Hilo - default performance', () {
    testWidgets('Hilo - Default - 10K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('default_hilo', 10000) as _HiloPerformance;
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

    testWidgets('Hilo - Default - 50K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('default_hilo', 50000) as _HiloPerformance;
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

    testWidgets('Hilo - Default - 1L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('default_hilo', 100000) as _HiloPerformance;
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

    testWidgets('Hilo - Default - 2L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('default_hilo', 200000) as _HiloPerformance;
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

  group('Hilo - with marker performance', () {
    testWidgets('Hilo - with marker - 10K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_marker', 10000) as _HiloPerformance;
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

    testWidgets('Hilo - with marker - 50K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_marker', 50000) as _HiloPerformance;
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

    testWidgets('Hilo - with marker - 1L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_marker', 100000) as _HiloPerformance;
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

    testWidgets('Hilo - with marker - 2L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_marker', 200000) as _HiloPerformance;
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

  group('Hilo - with datalabel performance', () {
    testWidgets('Hilo - with datalabel - 10K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_datalabel', 10000) as _HiloPerformance;
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

    testWidgets('Hilo - with datalabel - 50K', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_datalabel', 50000) as _HiloPerformance;
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

    testWidgets('Hilo - with datalabel - 1L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_datalabel', 100000) as _HiloPerformance;
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

    testWidgets('Hilo - with datalabel - 2L', (WidgetTester tester) async {
      final _HiloPerformance chartContainer =
          _hiloPerformance('hilo_with_datalabel', 200000) as _HiloPerformance;
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

StatelessWidget _hiloPerformance(String sampleName, int noOfSamples) {
  return _HiloPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _HiloPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HiloPerformance(String sampleName, int noOfSamples) {
    chart = getHiloPerformanceChart(sampleName, noOfSamples);
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
