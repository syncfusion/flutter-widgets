import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'hilo_openclose_samples.dart';

/// Test method of the Hilo open-close series performance.
void hiloOpenClosePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('HiloOpenClose - default performance', () {
    testWidgets('HiloOpenClose - Default - 10K', (WidgetTester tester) async {
      final _HiloOpenClosePerformance chartContainer =
          _hiloOpenClosePerformance('default_hiloOpenClose', 10000)
              as _HiloOpenClosePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 65000, true);
    // });

    testWidgets('HiloOpenClose - Default - 20K', (WidgetTester tester) async {
      final _HiloOpenClosePerformance chartContainer =
          _hiloOpenClosePerformance('default_hiloOpenClose', 20000)
              as _HiloOpenClosePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 400000, true);
    // });

    // testWidgets('HiloOpenClose - Default - 1L', (WidgetTester tester) async {
    //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('default_hiloOpenClose', 100000);
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

    // testWidgets('HiloOpenClose - Default - 2L', (WidgetTester tester) async {
    //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('default_hiloOpenClose', 200000);
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

  // group('HiloOpenClose - with marker performance',(){
  //   testWidgets('HiloOpenClose - with marker - 10K', (WidgetTester tester) async {
  //     final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_marker', 10000);
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
  //     expect(_chartState._renderDuration.inMilliseconds < 68000, true);
  //   });

  //   testWidgets('HiloOpenClose - with marker - 20K', (WidgetTester tester) async {
  //     final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_marker', 20000);
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

  //   // testWidgets('HiloOpenClose - with marker - 1L', (WidgetTester tester) async {
  //   //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_marker', 100000);
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

  //   // testWidgets('HiloOpenClose - with marker - 2L', (WidgetTester tester) async {
  //   //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_marker', 200000);
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

  group('HiloOpenClose - with datalabel performance', () {
    testWidgets('HiloOpenClose - with datalabel - 10K',
        (WidgetTester tester) async {
      final _HiloOpenClosePerformance chartContainer =
          _hiloOpenClosePerformance('hiloOpenClose_with_datalabel', 10000)
              as _HiloOpenClosePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 65000, true);
    // });

    testWidgets('HiloOpenClose - with datalabel - 20K',
        (WidgetTester tester) async {
      final _HiloOpenClosePerformance chartContainer =
          _hiloOpenClosePerformance('hiloOpenClose_with_datalabel', 20000)
              as _HiloOpenClosePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 400000, true);
    // });

    // testWidgets('HiloOpenClose - with datalabel - 1L', (WidgetTester tester) async {
    //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_datalabel', 100000);
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

    // testWidgets('HiloOpenClose - with datalabel - 2L', (WidgetTester tester) async {
    //   final _HiloOpenClosePerformance chartContainer = _hiloOpenClosePerformance('hiloOpenClose_with_datalabel', 200000);
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

StatelessWidget _hiloOpenClosePerformance(String sampleName, int noOfSamples) {
  return _HiloOpenClosePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _HiloOpenClosePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HiloOpenClosePerformance(String sampleName, int noOfSamples) {
    chart = getHiloOpenClosePerformanceChart(sampleName, noOfSamples);
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
