import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'waterfall_sample.dart';

/// Test method for markers in the Waterfall series.
void waterfallMarker() {
  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Waterfall - Marker', () {
    testWidgets('Chart Widget - Testing Waterfall Series with Marker',
        (WidgetTester tester) async {
      final _WaterfallMarker chartContainer =
          _waterfallMarker('marker_default') as _WaterfallMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      // final CartesianSeriesRenderer seriesRenderer =
      //     _chartState!._chartSeries.visibleSeriesRenderers[0];
      // final CartesianChartPoint<dynamic> dataPoint =
      //     seriesRenderer._dataPoints[0];
      expect(marker.color, null);
      expect(marker.shape, DataMarkerType.circle);
      expect(marker.borderColor, null);
      expect(marker.borderWidth, 2);
      // expect(dataPoint.markerPoint!.x.toInt(), 76);
      // expect(dataPoint.markerPoint!.y.toInt(), 251);
    });

    // // Waterfall series with marker
    // testWidgets(
    //     'Chart Widget - Testing Waterfall Sries with Marker Customization',
    //     (WidgetTester tester) async {
    //   final _WaterfallMarker chartContainer =
    //       _waterfallMarker('marker_axis_transposed') as _WaterfallMarker;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test marker properties for transposed series', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoint =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoint.markerPoint!.x.toInt(), 407);
    //   expect(dataPoint.markerPoint!.y.toInt(), 481);
    // });

    // testWidgets(
    //     'Chart Widget - Testing Waterfall Sries with Intermediate Sum in 3rd data point',
    //     (WidgetTester tester) async {
    //   final _WaterfallMarker chartContainer =
    //       _waterfallMarker('marker_intermediate_sum') as _WaterfallMarker;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test marker properties for intermedite 3rd point', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoint =
    //       seriesRenderer._dataPoints[2];
    //   expect(dataPoint.markerPoint!.x.toInt(), 198);
    //   expect(dataPoint.markerPoint!.y.toInt(), 281);
    // });

    // testWidgets(
    //     'Chart Widget - Testing Waterfall Sries with Total Sum in last data point',
    //     (WidgetTester tester) async {
    //   final _WaterfallMarker chartContainer =
    //       _waterfallMarker('marker_total_sum') as _WaterfallMarker;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test marker properties for last point as total sum', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoint =
    //       seriesRenderer._dataPoints[11];
    //   expect(dataPoint.markerPoint!.x.toInt(), 749);
    //   expect(dataPoint.markerPoint!.y.toInt(), 70);
    // });
  });
}

StatelessWidget _waterfallMarker(String sampleName) {
  return _WaterfallMarker(sampleName);
}

// ignore: must_be_immutable
class _WaterfallMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _WaterfallMarker(String sampleName) {
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
