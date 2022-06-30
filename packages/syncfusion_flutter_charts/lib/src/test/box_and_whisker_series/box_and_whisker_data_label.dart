import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'box_and_whisker_sample.dart';

/// Test method of the box plot series data label.
void boxPlotDataLabel() {
  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Box and whisker series - Data Label', () {
    testWidgets('Chart Widget - Testing Box and Whisker Series with Data label',
        (WidgetTester tester) async {
      final _BoxPlotDataLabel chartContainer =
          _boxPlotDataLabel('dataLabel_default') as _BoxPlotDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, null);
      expect(dataLabel.textStyle, isNotNull);
      expect(dataLabel.margin.left, 5.0);
      expect(dataLabel.margin.top, 5.0);
      expect(dataLabel.margin.right, 5.0);
      expect(dataLabel.margin.bottom, 5.0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
      expect(dataLabel.borderRadius, 5.0);
      expect(dataLabel.angle, 0);
    });

    // testWidgets('Box plot Series with Data label X Axis Inversed',
    //       (WidgetTester tester) async {
    //     final _BoxPlotDataLabel chartContainer =
    //         _boxPlotDataLabel('dataLabel_x_axis_inversed') as _BoxPlotDataLabel;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     await tester.pump(const Duration(seconds: 1));
    //   });

    //   test('to test data label for inversed x axis', () {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final CartesianChartPoint<dynamic> dataPoints =
    //         seriesRenderer._dataPoints[0];
    //     expect(dataPoints.dataLabelRegion!.left.toInt(), 644);
    //     expect(dataPoints.dataLabelRegion!.top.toInt(), 170);
    //   });

    //   testWidgets('Box plot Series with Data label Y Axis Inversed',
    //       (WidgetTester tester) async {
    //     final _BoxPlotDataLabel chartContainer =
    //         _boxPlotDataLabel('dataLabel_y_axis_inversed') as _BoxPlotDataLabel;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     await tester.pump(const Duration(seconds: 1));
    //   });

    //   test('to test data label inversed y axis', () {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final CartesianChartPoint<dynamic> dataPoints =
    //         seriesRenderer._dataPoints[0];
    //     expect(dataPoints.dataLabelRegion!.left.toInt(), 146);
    //     expect(dataPoints.dataLabelRegion!.top.toInt(), 170);
    //   });

    //   testWidgets(
    //       'Chart Widget - Testing Box plot Series with Data label for Transposed Series',
    //       (WidgetTester tester) async {
    //     final _BoxPlotDataLabel chartContainer =
    //         _boxPlotDataLabel('dataLabel_transposed') as _BoxPlotDataLabel;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     // await tester.pump(const Duration(seconds: 1));
    //   });

    //   test('test data label for transposed series', () {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final CartesianChartPoint<dynamic> dataPoints =
    //         seriesRenderer._dataPoints[0];
    //     expect(dataPoints.dataLabelRegion!.left.toInt(), 515);
    //     expect(dataPoints.dataLabelRegion!.top.toInt(), 412);
    //  });
  });
}

StatelessWidget _boxPlotDataLabel(String sampleName) {
  return _BoxPlotDataLabel(sampleName);
}

// ignore: must_be_immutable
class _BoxPlotDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BoxPlotDataLabel(String sampleName) {
    chart = getBoxPlotChart(sampleName);
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
