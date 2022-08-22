import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'fast_line_samples.dart';

/// Test method of the fast line series performance.
void fastLinePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;

  group('FastLine - with marker performance', () {
    testWidgets('FastLine - with marker - 10K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_marker', 10000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1100, true);
    // });

    testWidgets('FastLine - with marker - 50K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_marker', 50000)
              as _FastLinePerformance;
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

    testWidgets('FastLine - with marker - 1L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_marker', 100000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2400, true);
    // });

    testWidgets('FastLine - with marker - 2L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_marker', 200000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3800, true);
    // });
  });

  group('FastLine - default performance', () {
    testWidgets('FastLine - Default - 10K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('default_fastLine', 10000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1300, true);
    // });

    testWidgets('FastLine - Default - 50K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('default_fastLine', 50000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 700, true);
    // });

    testWidgets('FastLine - Default - 1L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('default_fastLine', 100000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1600, true);
    // });

    testWidgets('FastLine - Default - 2L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('default_fastLine', 200000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3200, true);
    // });
  });

  group('FastLine - with datalabel performance', () {
    testWidgets('FastLine - with datalabel - 10K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_datalabel', 10000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 300, true);
    // });

    testWidgets('FastLine - with datalabel - 50K', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_datalabel', 50000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 700, true);
    // });

    testWidgets('FastLine - with datalabel - 1L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_datalabel', 100000)
              as _FastLinePerformance;
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

    testWidgets('FastLine - with datalabel - 2L', (WidgetTester tester) async {
      final _FastLinePerformance chartContainer =
          _fastLinePerformance('fastLine_with_datalabel', 200000)
              as _FastLinePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3600, true);
    // });
  });
}

StatelessWidget _fastLinePerformance(String sampleName, int noOfSamples) {
  return _FastLinePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _FastLinePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _FastLinePerformance(String sampleName, int noOfSamples) {
    chart = getFastLinePerformanceChart(sampleName, noOfSamples);
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
