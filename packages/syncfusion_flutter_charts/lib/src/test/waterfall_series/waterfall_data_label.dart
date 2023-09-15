import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'waterfall_sample.dart';

/// Test method of the waterfall series data label.
void waterfallDataLabel() {
  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Waterfall series - Data Label', () {
    testWidgets('Chart Widget - Testing Waterfall Series with Data label',
        (WidgetTester tester) async {
      final _WaterfallDataLabel chartContainer =
          _waterfallDataLabel('dataLabel_default') as _WaterfallDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, null);
      // expect(dataLabel.textStyle, isNotNull);
      expect(dataLabel.margin.left, 5.0);
      expect(dataLabel.margin.top, 5.0);
      expect(dataLabel.margin.right, 5.0);
      expect(dataLabel.margin.bottom, 5.0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
      expect(dataLabel.borderRadius, 5.0);
      expect(dataLabel.angle, 0);
    });

    // testWidgets('Waterfall Series with Data label X Axis Inversed',
    //     (WidgetTester tester) async {
    //   final _WaterfallDataLabel chartContainer =
    //       _waterfallDataLabel('dataLabel_x_axis_inversed')
    //           as _WaterfallDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label for inversed x axis', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 737);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 229);
    // });

    // testWidgets('Waterfall Series with Data label Y Axis Inversed',
    //     (WidgetTester tester) async {
    //   final _WaterfallDataLabel chartContainer =
    //       _waterfallDataLabel('dataLabel_y_axis_inversed')
    //           as _WaterfallDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label inversed y axis', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 64);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 261);
    // });

    // testWidgets(
    //     'Chart Widget - Testing Waterfall Series with Data label for Transposed Series',
    //     (WidgetTester tester) async {
    //   final _WaterfallDataLabel chartContainer =
    //       _waterfallDataLabel('dataLabel_transposed') as _WaterfallDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   // await tester.pump(const Duration(seconds: 1));
    // });

    // test('test data label for transposed series', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 417);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 489);
    // });
  });
}

StatelessWidget _waterfallDataLabel(String sampleName) {
  return _WaterfallDataLabel(sampleName);
}

// ignore: must_be_immutable
class _WaterfallDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _WaterfallDataLabel(String sampleName) {
    chart = getWaterfallChart(sampleName);
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
