import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_column_sample.dart';

/// Test method of the range column series data label.
void rangeColumnDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Range column - Data Label', () {
    testWidgets('Chart Widget - Testing Column Series with Data label',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_default') as _RangeColumnDataLabel;
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

    testWidgets('Chart Widget - Testing Column Series with Data label template',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_template') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.color, null);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label customization',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_customization')
              as _RangeColumnDataLabel;
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
        'Chart Widget - Testing RangeColumn Series with Data label automatic',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_auto') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label automatic properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.useSeriesColor, true);
        // expect(dataLabel.textStyle.color, Colors.black);
        // expect(dataLabel.textStyle.fontSize, 12);
        expect(dataLabel.margin.bottom, 0);
        expect(dataLabel.margin.left, 0);
        expect(dataLabel.margin.top, 0);
        expect(dataLabel.margin.right, 0);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
        expect(dataLabel.borderRadius, 10.0);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label point color',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_pointColor')
              as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label point color properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.middle);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label Series color',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_series_color')
              as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label series color properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.useSeriesColor, true);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.middle);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label outer',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_outer') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label outer properties', () {
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
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.outer);
        expect(dataLabel.borderRadius, 10.0);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label outer near',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_outer_near')
              as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label outer near properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        // expect(dataLabel.textStyle.fontSize, 12);
        expect(dataLabel.margin.bottom, 5);
        expect(dataLabel.margin.left, 5);
        expect(dataLabel.margin.top, 5);
        expect(dataLabel.margin.right, 5);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.outer);
        expect(dataLabel.alignment, ChartAlignment.near);
        expect(dataLabel.borderRadius, 10.0);
      }
    });

    testWidgets('Chart Widget - Testing RangeColumn Series with Data label top',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_top') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label top properties', () {
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
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
        expect(dataLabel.borderRadius, 10.0);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label top far',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_top_far') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label top far properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        // expect(dataLabel.textStyle.fontSize, 12);
        expect(dataLabel.margin.bottom, 5);
        expect(dataLabel.margin.left, 5);
        expect(dataLabel.margin.top, 5);
        expect(dataLabel.margin.right, 5);
        expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
        expect(dataLabel.alignment, ChartAlignment.far);
        expect(dataLabel.borderRadius, 10.0);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label inversed',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_inversed') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label inversed properties', () {
      expect(chart!.primaryXAxis.isInversed, true);
      expect(chart!.primaryYAxis.isInversed, true);
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label opposed',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_opposed') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label opposed properties', () {
      expect(chart!.primaryXAxis.opposedPosition, true);
      expect(chart!.primaryYAxis.opposedPosition, true);
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with Data label transpose',
        (WidgetTester tester) async {
      final _RangeColumnDataLabel chartContainer =
          _rangeColumnDataLabel('dataLabel_transpose') as _RangeColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label opposed properties', () {
      expect(chart!.isTransposed, true);
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
      }
    });
  });
}

StatelessWidget _rangeColumnDataLabel(String sampleName) {
  return _RangeColumnDataLabel(sampleName);
}

// ignore: must_be_immutable
class _RangeColumnDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeColumnDataLabel(String sampleName) {
    chart = getRangeColumnchart(sampleName);
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
