import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_line100_series.dart';

/// Test method of the stacked line 100 series performance.
void stackedline100Performance() {
  SfCartesianChart? chart;
  // _SfCartesianChartState _chartState;
  group('stackedline100 - default performance', () {
    testWidgets('stackedline100 - Default - 10K', (WidgetTester tester) async {
      final _Stackedline100Performance chartContainer =
          _stackedline100Performance('default_stackedline100', 10000)
              as _Stackedline100Performance;
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
    //   expect(_chartState._renderDuration.inMilliseconds < 90000, true);
    // });

//     // testWidgets('Spline100 - Default - 10K', (WidgetTester tester) async {
//     //   final _Stackedline100Performance  chartContainer = _stackedline100Performance('default_stackedline100', 50000);
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
    //   final GlobalKey key = chart.key;
    //   _chartState = key.currentState;
//     // });
//     // // to test series data count
//     // test('to test series data length', () {
//     //   print(_chartState._renderDuration.inMilliseconds);
//     //   expect(chart.series[0].dataSource.length, 50000);
//     // });
//     // //to test series render duration
//     // test('to test render duration', () {
//     //   expect(_chartState._renderDuration.inMilliseconds < 2000, true);
//     // });

//     // testWidgets('Stackedline100 - Default - 1L', (WidgetTester tester) async {
//     //   final _Stackedline100Performance  chartContainer = _stackedline100Performance('default_stackedline100', 100000);
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
    //   final GlobalKey key = chart.key;
    //   _chartState = key.currentState;
//     // });
//     // // // to test series data count
//     // test('to test series data length', () {
//     //   expect(chart.series[0].dataSource.length, 100000);
//     // });
//     // // to test series render duration
//     // test('to test render duration', () {
//     //   expect(_chartState._renderDuration.inMilliseconds < 5000, true);
//     // });

//     // testWidgets('Stackedline100 - Default - 2L', (WidgetTester tester) async {
//     //   final _Stackedline100Performance  chartContainer = _stackedline100Performance('default_stackedline100', 200000);
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
    //   final GlobalKey key = chart.key;
    //   _chartState = key.currentState;
//     // });
//     // // to test series data count
//     // test('to test series data length', () {
//     //   expect(chart.series[0].dataSource.length, 200000);
//     // });
//     // // to test series render duration
//     // test('to test render duration', () {
//     //   expect(_chartState._renderDuration.inMilliseconds < 60000, true);
//     // });
  });

  // group('Stackedline100 - with marker performance',(){
  //   testWidgets('Stackedline100 - with marker - 10K', (WidgetTester tester) async {
  //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_marker', 10000);
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
  //   });
  // //   // to test series data count
  //   test('to test series data length', () {
  //     expect(chart.series[0].dataSource.length, 10000);
  //   });
  //   // to test series render duration
  // test('to test render duration', () {
  //   print(_chartState._renderDuration.inMilliseconds);
  //   expect(_chartState._renderDuration.inMilliseconds < 1500, true);
  // });

//   //   testWidgets('Stackedline100 - with marker - 50K', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_marker', 50000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 50000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 2000, true);
//   //   });

//   //   testWidgets('Stackedline100 - with marker - 1L', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_marker', 100000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 100000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 250000, true);
//   //   });

//   //   testWidgets('Stackedline100 - with marker - 2L', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_marker', 200000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 200000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 450000, true);
//   //   });
  //  });

  //   group('Stackedline100 - with datalabel performance',(){
  //   testWidgets('Stackedline100 - with datalabel - 10K', (WidgetTester tester) async {
  //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_datalabel', 10000);
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
  //   });
  // //   // to test series data count
  //   test('to test series data length', () {
  //     expect(chart.series[0].dataSource.length, 10000);
  //   });
  // //   // to test series render duration
  //   test('to test render duration', () {
  //     print(_chartState._renderDuration.inMilliseconds);
  //     expect(_chartState._renderDuration.inMilliseconds < 2500, true);
  //   });

//   //   testWidgets('Stackedline100 - with datalabel - 50K', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_datalabel', 50000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 50000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 29000, true);
//   //   });

//   //   testWidgets('Stackedline100 - with datalabel - 1L', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_datalabel', 100000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 100000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 270000, true);
//   //   });

//   //   testWidgets('Stackedline100 - with datalabel - 2L', (WidgetTester tester) async {
//   //     final _Stackedline100Performance  chartContainer = _stackedline100Performance('spline100_with_datalabel', 200000);
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
  //     final GlobalKey key = chart.key;
  //     _chartState = key.currentState;
//   //   });
//   // //   // to test series data count
//   //   test('to test series data length', () {
//   //     expect(chart.series[0].dataSource.length, 200000);
//   //   });
//   // //   // to test series render duration
//   //   test('to test render duration', () {
//   //     print(_chartState._renderDuration.inMilliseconds);
//   //     expect(_chartState._renderDuration.inMilliseconds < 490000, true);
//   //   });
  //  });
}

StatelessWidget _stackedline100Performance(String sampleName, int noOfSamples) {
  return _Stackedline100Performance(sampleName, noOfSamples);
}

// ignore: must_be_immutable
class _Stackedline100Performance extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Stackedline100Performance(String sampleName, int noOfSamples) {
    chart = getStackedline100PerformanceChart(sampleName, noOfSamples);
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
