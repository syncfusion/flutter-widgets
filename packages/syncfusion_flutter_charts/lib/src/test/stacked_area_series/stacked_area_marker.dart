import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_area_sample.dart';

/// Test method for markers in the stacked area series.
void stackedAreaMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Stacke Area Marker', () {
    testWidgets('Chart Widget - Testing stacked area Series with Marker',
        (WidgetTester tester) async {
      final _StackedAreaMarker chartContainer =
          _stackedAreaMarker('marker_default') as _StackedAreaMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test marker default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;
        final MarkerSettings marker = cartesianSeries.markerSettings;
        expect(marker.isVisible, true);
        expect(marker.color, null);
        expect(marker.width, 8.0);
        expect(marker.height, 8.0);
        expect(marker.shape, DataMarkerType.circle);
        expect(marker.borderColor, null);
        expect(marker.borderWidth, 2);
      }
    });

    // Bar series with marker
    testWidgets(
        'Chart Widget - Testing stacked area Sries with Marker Customization',
        (WidgetTester tester) async {
      final _StackedAreaMarker chartContainer =
          _stackedAreaMarker('marker_cutomization') as _StackedAreaMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;

        final MarkerSettings marker = cartesianSeries.markerSettings;
        expect(marker.isVisible, true);
        expect(marker.color, Colors.deepOrange);
        expect(marker.width, 10);
        expect(marker.height, 10);
        expect(marker.shape, DataMarkerType.diamond);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    // Bar series with marker
    testWidgets(
        'Chart Widget - Testing stacked area series Marker with Empty Point',
        (WidgetTester tester) async {
      final _StackedAreaMarker chartContainer =
          _stackedAreaMarker('marker_EmptyPoint') as _StackedAreaMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;

        final MarkerSettings marker = cartesianSeries.markerSettings;
        expect(marker.isVisible, true);
        expect(marker.color!.value, 4294924066);
        expect(marker.width, 10);
        expect(marker.height, 10);
        expect(marker.shape, DataMarkerType.horizontalLine);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    // stacked area Series with Marker Point Color
    testWidgets(
        'Chart Widget - Testing stacked area Series with Marker Point Color',
        (WidgetTester tester) async {
      final _StackedAreaMarker chartContainer =
          _stackedAreaMarker('marker_PointColormapping') as _StackedAreaMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test marker default properties', () {
      for (int i = 0; i < chart!.series.length; i++) {
        final CartesianSeries<dynamic, dynamic> cartesianSeries =
            chart!.series[i] as CartesianSeries<dynamic, dynamic>;
        final MarkerSettings marker = cartesianSeries.markerSettings;
        expect(marker.isVisible, true);
        expect(marker.color, Colors.deepOrange);
        expect(marker.width, 10.0);
        expect(marker.height, 10.0);
        expect(marker.shape, DataMarkerType.horizontalLine);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });
  });
}

StatelessWidget _stackedAreaMarker(String sampleName) {
  return _StackedAreaMarker(sampleName);
}

// ignore: must_be_immutable
class _StackedAreaMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedAreaMarker(String sampleName) {
    chart = getStackedAreaChart(sampleName);
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
