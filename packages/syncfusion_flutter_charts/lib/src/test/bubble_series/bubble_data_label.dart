import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bubble_sample.dart';

/// Test method of the bubble series data label.
void bubbleDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bubble - DataLabel', () {
    testWidgets('Chart Widget - Testing Bubble Series with Data label',
        (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_default') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, null);
      expect(dataLabel.textStyle, isNotNull);
      expect(dataLabel.margin.top, 5.0);
      expect(dataLabel.margin.left, 5.0);
      expect(dataLabel.margin.bottom, 5.0);
      expect(dataLabel.margin.right, 5.0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
      expect(dataLabel.borderRadius, 5.0);
      expect(dataLabel.angle, 0);
    });

    testWidgets(
        'Chart Widget - Testing Line Series with Data label customization',
        (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_customization') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
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
    });

    testWidgets(
        'Chart Widget - Testing Line Series with Mapping from Data Source',
        (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_mapping') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
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
    });
  });
  group('Bubble Data Label Postioning -', () {
    testWidgets('Bubble series dataLabel_outer', (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_outer') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, Colors.red);
      expect(dataLabel.textStyle.color, Colors.black);
      expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.outer);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 208);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    testWidgets('Chart Widget - DateLabel Top', (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_top') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, Colors.red);
      expect(dataLabel.textStyle.color, Colors.black);
      expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 208);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    testWidgets('Bubble series dataLabel outer with alignment as near',
        (WidgetTester tester) async {
      final _BubbleDataLabel chartContainer =
          _bubbleDataLabel('dataLabel_outer_near') as _BubbleDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('test first data label region', () {
      //   final CartesianSeriesRenderer seriesRenderer =
      //       _chartState!._chartSeries.visibleSeriesRenderers[0];
      //   final CartesianChartPoint<dynamic> dataPoints =
      //       seriesRenderer._dataPoints[0];
      //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
      //   expect(dataPoints.dataLabelRegion!.top.toInt(), 232);
      //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
      //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
      // });

      // testWidgets('Bubble series dataLabel top with alignment as near',
      //     (WidgetTester tester) async {
      //   final _BubbleDataLabel chartContainer =
      //       _bubbleDataLabel('dataLabel_top_near') as _BubbleDataLabel;
      //   await tester.pumpWidget(chartContainer);
      //   chart = chartContainer.chart;
      //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      //   _chartState = key.currentState as SfCartesianChartState?;
      // });
      // test('test first data label region', () {
      //   final CartesianSeriesRenderer seriesRenderer =
      //       _chartState!._chartSeries.visibleSeriesRenderers[0];
      //   final CartesianChartPoint<dynamic> dataPoints =
      //       seriesRenderer._dataPoints[0];
      //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
      //   expect(dataPoints.dataLabelRegion!.top.toInt(), 232);
      //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
      //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
      // });

      // testWidgets('Bubble series dataLabel bottom with alignment as far',
      //     (WidgetTester tester) async {
      //   final _BubbleDataLabel chartContainer =
      //       _bubbleDataLabel('dataLabel_bottom_far') as _BubbleDataLabel;
      //   await tester.pumpWidget(chartContainer);
      //   chart = chartContainer.chart;
      //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      //   _chartState = key.currentState as SfCartesianChartState?;
      // });
      // test('test first data label region', () {
      //   final CartesianSeriesRenderer seriesRenderer =
      //       _chartState!._chartSeries.visibleSeriesRenderers[0];
      //   final CartesianChartPoint<dynamic> dataPoints =
      //       seriesRenderer._dataPoints[0];
      //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
      //   expect(dataPoints.dataLabelRegion!.top.toInt(), 224);
      //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
      //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
      // });
      // testWidgets('Bubble series dataLabel middle with alignment as center',
      //     (WidgetTester tester) async {
      //   final _BubbleDataLabel chartContainer =
      //       _bubbleDataLabel('dataLabel_middle_center') as _BubbleDataLabel;
      //   await tester.pumpWidget(chartContainer);
      //   chart = chartContainer.chart;
      //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      //   _chartState = key.currentState as SfCartesianChartState?;
      // });
      // test('test first data label region', () {
      //   final CartesianSeriesRenderer seriesRenderer =
      //       _chartState!._chartSeries.visibleSeriesRenderers[0];
      //   final CartesianChartPoint<dynamic> dataPoints =
      //       seriesRenderer._dataPoints[0];
      //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
      //   expect(dataPoints.dataLabelRegion!.top.toInt(), 228);
      //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
      //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    });
  });
}

StatelessWidget _bubbleDataLabel(String sampleName) {
  return _BubbleDataLabel(sampleName);
}

// ignore: must_be_immutable
class _BubbleDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BubbleDataLabel(String sampleName) {
    chart = getBubblechart(sampleName);
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
