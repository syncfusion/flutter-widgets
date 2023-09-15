import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'area_samples.dart';

/// Test method of the area series performance.
void areaPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Area - default performance', () {
    testWidgets('Area - Default - 10K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('default_area', 10000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 650, true);
    // });

    testWidgets('Area - Default - 50K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('default_area', 50000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 800, true);
    // });

    testWidgets('Area - Default - 1L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('default_area', 100000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1300, true);
    // });

    testWidgets('Area - Default - 2L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('default_area', 200000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2200, true);
    // });
  });

  group('Area - with marker performance', () {
    testWidgets('Area - with marker - 10K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_marker', 10000) as _AreaPerformance;
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

    testWidgets('Area - with marker - 50K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_marker', 50000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1200, true);
    // });

    testWidgets('Area - with marker - 1L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_marker', 100000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1900, true);
    // });

    testWidgets('Area - with marker - 2L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_marker', 200000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 4100, true);
    // });
  });

  group('Area - with datalabel performance', () {
    testWidgets('Area - with datalabel - 10K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_datalabel', 10000) as _AreaPerformance;
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

    testWidgets('Area - with datalabel - 50K', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_datalabel', 50000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 800, true);
    // });

    testWidgets('Area - with datalabel - 1L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_datalabel', 100000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 1300, true);
    // });

    testWidgets('Area - with datalabel - 2L', (WidgetTester tester) async {
      final _AreaPerformance chartContainer =
          _areaPerformance('area_with_datalabel', 200000) as _AreaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 2200, true);
    // });
  });
}

StatelessWidget _areaPerformance(String sampleName, int noOfSamples) {
  return _AreaPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _AreaPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AreaPerformance(String sampleName, int noOfSamples) {
    chart = getAreaPerformanceChart(sampleName, noOfSamples);
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
