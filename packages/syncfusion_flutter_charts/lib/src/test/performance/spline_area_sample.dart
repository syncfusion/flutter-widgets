import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'spline_area_series.dart';

/// Test method of the spline area series performance.
void splineareaPerformance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('Splinearea - default performance', () {
    testWidgets('Splinearea - Default - 10K', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('default_splinearea', 10000)
              as _SplineareaPerformance;
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

    testWidgets('Splinearea - Default - 10K', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('default_splinearea', 50000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 350000, true);
    // });

    testWidgets('Splinearea - Default - 1L', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('default_splinearea', 100000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 300000, true);
    // });

    // testWidgets('Splinearea - Default - 2L', (WidgetTester tester) async {
    //   final _SplineareaPerformance chartContainer = _spLineareaPerformance('default_splinearea', 200000);
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
    //   expect(_chartState._renderDuration.inMilliseconds < 600000, true);
    // });
  });

  group('Splinearea- with marker performance', () {
    testWidgets('Line - with marker - 10K', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_marker', 10000)
              as _SplineareaPerformance;
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

    testWidgets('Splinearea - with marker - 50K', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_marker', 50000)
              as _SplineareaPerformance;
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

    testWidgets('Splinearea - with marker - 1L', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_marker', 100000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 300000, true);
    // });

    testWidgets('Splinearea - with marker - 2L', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_marker', 200000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 600000, true);
    // });
  });

  group('Splinearea - with datalabel performance', () {
    testWidgets('Line - with datalabel - 10K', (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_datalabel', 10000)
              as _SplineareaPerformance;
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

    testWidgets('Splinearea - with datalabel - 50K',
        (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_datalabel', 50000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 45000, true);
    // });

    testWidgets('Splinearea - with datalabel - 1L',
        (WidgetTester tester) async {
      final _SplineareaPerformance chartContainer =
          _spLineareaPerformance('splinearea_with_datalabel', 100000)
              as _SplineareaPerformance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 300000, true);
    // });

    //   testWidgets('Splinearea - with datalabel - 2L', (WidgetTester tester) async {
    //     final _SplineareaPerformance chartContainer = _spLineareaPerformance('splinearea_with_datalabel', 200000);
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart.key;
    //     _chartState = key.currentState;
    //   });
    // //   // to test series data count
    //   test('to test series data length', () {
    //     expect(chart.series[0].dataSource.length, 200000);
    //   });
    // //   // to test series render duration
    //   test('to test render duration', () {
    //     print(_chartState._renderDuration.inMilliseconds);
    //     expect(_chartState._renderDuration.inMilliseconds < 600000, true);
    //   });
  });
}

StatelessWidget _spLineareaPerformance(String sampleName, int noOfSamples) {
  return _SplineareaPerformance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _SplineareaPerformance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _SplineareaPerformance(String sampleName, int noOfSamples) {
    chart = getSplineareaPerformanceChart(sampleName, noOfSamples);
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
