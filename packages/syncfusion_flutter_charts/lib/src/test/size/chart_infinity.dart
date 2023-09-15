import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'chart_sample.dart';

/// Test method for infinity values of size in chart.
void chartInfinity() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called

  group('Chart Size', () {
    testWidgets('Chart Widget - Size', (WidgetTester tester) async {
      final _ChartInfinity chartContainer =
          _chartInfinity('size') as _ChartInfinity;
      await tester.pumpWidget(chartContainer);
    });
    // test('Test Container Rect', () {
    //   expect(
    //       _chartState!._renderingDetails.chartContainerRect.width.toInt(), 619);
    //   expect(_chartState!._renderingDetails.chartContainerRect.height.toInt(),
    //       506);
    // });
    // test('Test With Margin Values', () {
    //   final Rect containerRect =
    //       _chartState!._renderingDetails.chartContainerRect;
    //   final Rect rect = Rect.fromLTWH(
    //       containerRect.left + chart!.margin.left,
    //       containerRect.top + chart!.margin.top,
    //       containerRect.width - chart!.margin.right - chart!.margin.left,
    //       containerRect.height - chart!.margin.top - chart!.margin.bottom);
    //   expect(rect.width.toInt(), 599);
    //   expect(rect.height.toInt(), 486);
    // });
  });
}

StatelessWidget _chartInfinity(String sampleName) {
  return _ChartInfinity(sampleName);
}

// ignore: must_be_immutable
class _ChartInfinity extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ChartInfinity(String sampleName) {
    firstChart = getChartSample(sampleName);
    secondChart = getChartSample(sampleName);
    thirdChart = getChartSample(sampleName);
    fourthChart = getChartSample(sampleName);
    fifthChart = getChartSample(sampleName);
    sixthChart = getChartSample(sampleName);
  }
  SfCartesianChart? firstChart;
  SfCartesianChart? secondChart;
  SfCartesianChart? thirdChart;
  SfCartesianChart? fourthChart;
  SfCartesianChart? fifthChart;
  SfCartesianChart? sixthChart;

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
              child: firstChart,
            ),
            //   ListView(children: <Widget>[
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: firstChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: secondChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: thirdChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: fourthChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: fifthChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),
            // Container(
            //   margin: EdgeInsets.zero,
            //   child: sixthChart,
            // ),
            // const Divider(
            //   height: 5,
            // ),

            // ]
            // )
          )),
    );
  }
}
