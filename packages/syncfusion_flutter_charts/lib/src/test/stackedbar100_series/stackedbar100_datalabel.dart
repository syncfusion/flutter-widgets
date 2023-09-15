import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stackedbar100_sample.dart';

/// Test method of the stacked bar 100 series data label.
void stackedBar100DataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacked Bar - Data Label', () {
    testWidgets('Chart Widget - Testing stacked bar Series with Data label',
        (WidgetTester tester) async {
      final _StackedBar100DataLabel chartContainer =
          _stackedBar100DataLabel('dataLabel_default')
              as _StackedBar100DataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.color, null);
        // expect(dataLabel.textStyle, isNotNull);
        expect(dataLabel.margin.top, 5.0);
        expect(dataLabel.margin.left, 5.0);
        expect(dataLabel.margin.bottom, 5.0);
        expect(dataLabel.margin.right, 5.0);

        expect(dataLabel.opacity, 1.0);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
        expect(dataLabel.borderRadius, 5.0);
        expect(dataLabel.angle, 0);
      }
    });

    testWidgets(
        'Chart Widget - Testing stacked bar Series with Data label customization',
        (WidgetTester tester) async {
      final _StackedBar100DataLabel chartContainer =
          _stackedBar100DataLabel('dataLabel_customization')
              as _StackedBar100DataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.color, Colors.red);
        // expect(dataLabel.textStyle.color, Colors.black);
        // expect(dataLabel.textStyle.fontSize, 12);
        expect(dataLabel.margin.bottom, 5);
        expect(dataLabel.margin.left, 5);
        expect(dataLabel.margin.top, 5);
        expect(dataLabel.margin.right, 5);

        expect(dataLabel.opacity, 1.0);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.bottom);
        expect(dataLabel.borderRadius, 10.0);
        expect(dataLabel.angle, 0);
      }
    });

    testWidgets(
        'Chart Widget - Testing stacked bar Series with Mapping from Data Source',
        (WidgetTester tester) async {
      final _StackedBar100DataLabel chartContainer =
          _stackedBar100DataLabel('dataLabel_mapping')
              as _StackedBar100DataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.color, Colors.red);
        // expect(dataLabel.textStyle.color, Colors.black);
        // expect(dataLabel.textStyle.fontSize, 12);
        expect(dataLabel.margin.bottom, 5);
        expect(dataLabel.margin.left, 5);
        expect(dataLabel.margin.top, 5);
        expect(dataLabel.margin.right, 5);
        expect(dataLabel.opacity, 1.0);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.bottom);
        expect(dataLabel.borderRadius, 10.0);
        expect(dataLabel.angle, 0);
      }
    });
  });
}

StatelessWidget _stackedBar100DataLabel(String sampleName) {
  return _StackedBar100DataLabel(sampleName);
}

// ignore: must_be_immutable
class _StackedBar100DataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedBar100DataLabel(String sampleName) {
    chart = getStackedBar100Chart(sampleName);
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
