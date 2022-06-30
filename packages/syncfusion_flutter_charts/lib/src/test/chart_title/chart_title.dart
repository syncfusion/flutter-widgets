import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'chart_title_sample.dart';

/// Test method of the title customization in chart series.
void chartTitle() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Chart Title - Series,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final _CartesianChartTitle chartContainer =
          _cartesianChartTitle('cartesian_title_default_style')
              as _CartesianChartTitle;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test default values', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'Half yearly sales analysis');
      expect(title.backgroundColor, Colors.lightGreen);
      expect(title.borderColor, Colors.blue);
      expect(title.borderWidth, 2);
      expect(title.alignment, ChartAlignment.center);
    });

    testWidgets('chart tite alignment - near', (WidgetTester tester) async {
      final _CartesianChartTitle chartContainer =
          _cartesianChartTitle('title_near_Alignment') as _CartesianChartTitle;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test title near alignment', () {
      expect(chart!.title.alignment, ChartAlignment.near);
    });

    testWidgets('chart tite alignment - far', (WidgetTester tester) async {
      final _CartesianChartTitle chartContainer =
          _cartesianChartTitle('title_far_Alignment') as _CartesianChartTitle;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test title far alignment', () {
      expect(chart!.title.alignment, ChartAlignment.far);
    });
  });
}

StatelessWidget _cartesianChartTitle(String sampleName) {
  return _CartesianChartTitle(sampleName);
}

// ignore: must_be_immutable
class _CartesianChartTitle extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CartesianChartTitle(String sampleName) {
    chart = getCartesianTitleSample(sampleName);
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
