import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bubble_samples.dart';

/// Test method of the bubble series performance.
void bubblePerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Bubble - default performance', () {
    testWidgets('Bubble - Default - 10K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('default_bubble', 10000) as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1000, true);
    // });

    testWidgets('Bubble - Default - 50K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('default_bubble', 50000) as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1500, true);
    // });

    testWidgets('Bubble - Default - 1L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('default_bubble', 100000) as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2300, true);
    // });

    testWidgets('Bubble - Default - 2L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('default_bubble', 200000) as _BubblePerformance;
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

  group('Bubble - with marker performance', () {
    testWidgets('Bubble - with marker - 10K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_marker', 10000) as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 500, true);
    // });

    testWidgets('Bubble - with marker - 50K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_marker', 50000) as _BubblePerformance;
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

    testWidgets('Bubble - with marker - 1L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_marker', 100000)
              as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 3500, true);
    // });

    testWidgets('Bubble - with marker - 2L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_marker', 200000)
              as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 5000, true);
    // });
  });

  group('Bubble - with datalabel performance', () {
    testWidgets('Bubble - with datalabel - 10K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_datalabel', 10000)
              as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 400, true);
    // });

    testWidgets('Bubble - with datalabel - 50K', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_datalabel', 50000)
              as _BubblePerformance;
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

    testWidgets('Bubble - with datalabel - 1L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_datalabel', 100000)
              as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2000, true);
    // });

    testWidgets('Bubble - with datalabel - 2L', (WidgetTester tester) async {
      final _BubblePerformance chartContainer =
          _bubblePerformance('bubble_with_datalabel', 200000)
              as _BubblePerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 4000, true);
    // });
  });
}

StatelessWidget _bubblePerformance(String sampleName, int noOfSamples) {
  return _BubblePerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _BubblePerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BubblePerformance(String sampleName, int noOfSamples) {
    chart = getBubblePerformanceChart(sampleName, noOfSamples);
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
