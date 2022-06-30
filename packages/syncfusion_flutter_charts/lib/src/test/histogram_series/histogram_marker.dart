import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'histogram_sample.dart';

/// Test method for markers in the histogram series.
void histogramMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Column - Marker', () {
    testWidgets('Chart Widget - Testing Column Series with Marker',
        (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_default') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, null);
      expect(marker.width, 8.0);
      expect(marker.height, 8.0);
      expect(marker.shape, DataMarkerType.circle);
      expect(marker.borderColor, null);
      expect(marker.borderWidth, 2);
    });

    //Histogram series with marker
    testWidgets('Chart Widget - Testing Column Sries with Marker Customization',
        (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_cutomization') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.diamond);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    // Histogram series with marker
    testWidgets('Chart Widget - Testing Column series Makrer with Empty Point',
        (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_EmptyPoint') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color!.value, 4294924066);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.horizontalLine);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });
  });

  group('Column Marker Shapes', () {
    // Column series with marker
    testWidgets('Chart Widget - Rectangle Marker', (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_rect') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;

      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.rectangle);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    testWidgets('Chart Widget - Rectangle Marker', (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_rect') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;

      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.rectangle);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    testWidgets('Chart Widget - Pentagon Marker', (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_pentagon') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.pentagon);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    testWidgets('Chart Widget - Vertical Line Marker',
        (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_verticalLine') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.verticalLine);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    testWidgets('Chart Widget - Invertical Triangle Marker',
        (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_invertTriangle') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.invertedTriangle);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });

    testWidgets('Chart Widget - Triangle Marker', (WidgetTester tester) async {
      final _HistogramMarker chartContainer =
          _histogramMarker('marker_triangle') as _HistogramMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, true);
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.triangle);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });
  });
}

StatelessWidget _histogramMarker(String sampleName) {
  return _HistogramMarker(sampleName);
}

// ignore: must_be_immutable
class _HistogramMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _HistogramMarker(String sampleName) {
    chart = getHistogramchart(sampleName);
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
