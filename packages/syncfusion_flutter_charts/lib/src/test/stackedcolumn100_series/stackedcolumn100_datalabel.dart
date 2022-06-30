import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stackedcolumn100_sample.dart';

/// Test method of the stacked column 100 series data label.
void stackedColumn100DataLabel() {
  SfCartesianChart? chart;

  group('Stacked Column Category', () {
    testWidgets('Category axis - Default', (WidgetTester tester) async {
      final _StackedColumn100DataLabel chartContainer =
          _stackedColumn100DataLabel('datalabel_default')
              as _StackedColumn100DataLabel;
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
      final _StackedColumn100DataLabel chartContainer =
          _stackedColumn100DataLabel('dataLabel_customization')
              as _StackedColumn100DataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final DataLabelSettings dataLabel = chart!.series[i].dataLabelSettings!;
        expect(dataLabel.isVisible, true);
        expect(dataLabel.color, Colors.red);
        expect(dataLabel.textStyle.color, Colors.black);
        expect(dataLabel.textStyle.fontSize, 12);
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
      final _StackedColumn100DataLabel chartContainer =
          _stackedColumn100DataLabel('datalabel_mapping')
              as _StackedColumn100DataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
  });
}

StatelessWidget _stackedColumn100DataLabel(String sampleName) {
  return _StackedColumn100DataLabel(sampleName);
}

// ignore: must_be_immutable
class _StackedColumn100DataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedColumn100DataLabel(String sampleName) {
    chart = getStackedColumn100Series(sampleName);
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
