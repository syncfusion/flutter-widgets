import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'area_sample.dart';

/// Testing method for data label of the area series.
void areaDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Area Data label', () {
    testWidgets('Chart Widget - Testing Area Series with Data label',
        (WidgetTester tester) async {
      final _AreaDataLabel chartContainer =
          _areaDataLabel('dataLabel_default') as _AreaDataLabel;
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
        'Chart Widget - Testing Area Series with Data label customization',
        (WidgetTester tester) async {
      final _AreaDataLabel chartContainer =
          _areaDataLabel('dataLabel_customization') as _AreaDataLabel;
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
        'Chart Widget - Testing Area Series with Mapping from Data Source',
        (WidgetTester tester) async {
      final _AreaDataLabel chartContainer =
          _areaDataLabel('dataLabel_mapping') as _AreaDataLabel;
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

StatelessWidget _areaDataLabel(String sampleName) {
  return _AreaDataLabel(sampleName);
}

// ignore: must_be_immutable
class _AreaDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _AreaDataLabel(String sampleName) {
    chart = getAreachart(sampleName);
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
