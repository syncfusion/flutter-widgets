import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'step_area_sample.dart';

/// Test method of the step area series data label.
void stepAreaDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('StepArea Data label', () {
    testWidgets('Chart Widget - Testing StepArea with Data label',
        (WidgetTester tester) async {
      final _StepAreaDataLabel chartContainer =
          _stepAreaDataLabel('dataLabel_default') as _StepAreaDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, null);
      // expect(dataLabel.textStyle, isNotNull);
      expect(dataLabel.margin.top, 5.0);
      expect(dataLabel.margin.right, 5.0);
      expect(dataLabel.margin.bottom, 5.0);
      expect(dataLabel.margin.left, 5.0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
      expect(dataLabel.borderRadius, 5.0);
      expect(dataLabel.angle, 0);
    });

    testWidgets(
        'Chart Widget - Testing StepArea Series with Data label customization',
        (WidgetTester tester) async {
      final _StepAreaDataLabel chartContainer =
          _stepAreaDataLabel('dataLabel_customization') as _StepAreaDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
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
    });

    testWidgets(
        'Chart Widget - Testing StepArea Series with Mapping from Data Source',
        (WidgetTester tester) async {
      final _StepAreaDataLabel chartContainer =
          _stepAreaDataLabel('dataLabel_mapping') as _StepAreaDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
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
    });
  });
}

StatelessWidget _stepAreaDataLabel(String sampleName) {
  return _StepAreaDataLabel(sampleName);
}

// ignore: must_be_immutable
class _StepAreaDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StepAreaDataLabel(String sampleName) {
    chart = getStepAreachart(sampleName);
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
