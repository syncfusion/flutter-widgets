import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_column_sample.dart';

/// Test method of the stacked column series data label.
void stackedColumnDataLabel() {
  SfCartesianChart? chart;

  group('Stacked Column Category', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _StackedColumnDataLabel chartContainer =
          _stackedColumnDataLabel('datalabel_default')
              as _StackedColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 2);
    });

    test(' to test datalabel settings', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings label = chart!.series[i].dataLabelSettings!;
        expect(label.borderColor.value, const Color(0x00000000).value);
        expect(label.borderWidth, 0.0);
        expect(label.connectorLineSettings.length, null);
        expect(label.connectorLineSettings.width, 1.0);
        expect(label.connectorLineSettings.color, null);
        expect(label.labelIntersectAction, LabelIntersectAction.shift);
        expect(label.color, null);
      }
    });

    testWidgets(
        'Chart Widget - Testing stacked column Series with Data label customization',
        (WidgetTester tester) async {
      final _StackedColumnDataLabel chartContainer =
          _stackedColumnDataLabel('dataLabel_customization')
              as _StackedColumnDataLabel;
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
        'Accumulation Chart Widget - Testing stacked column series with Datalabel Mapper',
        (WidgetTester tester) async {
      final _StackedColumnDataLabel chartContainer =
          _stackedColumnDataLabel('datalabel_mapping')
              as _StackedColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
  });
}

StatelessWidget _stackedColumnDataLabel(String sampleName) {
  return _StackedColumnDataLabel(sampleName);
}

// ignore: must_be_immutable
class _StackedColumnDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedColumnDataLabel(String sampleName) {
    chart = getStackedColumnSeries(sampleName);
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
