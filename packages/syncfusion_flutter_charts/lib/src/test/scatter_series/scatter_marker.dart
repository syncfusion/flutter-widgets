import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'scatter_sample.dart';

/// Test method for markers in the scatter series.
void scatterMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Scatter - Marker', () {
    testWidgets('Chart Widget - Testing Scatter Series with Marker',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('marker_default') as _ScatterMarker;
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
      expect(marker.width, 8);
      expect(marker.height, 8);
      expect(marker.shape, DataMarkerType.circle);
      expect(marker.borderColor, null);
      expect(marker.borderWidth, 2);
    });

    // Scatter series with marker
    testWidgets(
        'Chart Widget - Testing Scatter Sries with Marker Customization',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('marker_cutomization') as _ScatterMarker;
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
  });

  group('Scatter Marker -Empty Point', () {
// Scatter series with marker
    testWidgets('Chart Widget - Testing Scatter series Makrer with Empty Point',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('marker_EmptyPoint') as _ScatterMarker;
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

  group('Scatter Marker Shapes -', () {
    testWidgets('Scatter series with various marker rectangle shape',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_rectangle') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.rectangle);
    });
    testWidgets('Scatter series with various marker pentagon shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_pentagon') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.pentagon);
    });

    testWidgets('Scatter series with various marker verticalLine shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_verticalLine') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.verticalLine);
    });

    testWidgets('Scatter series with various marker horizontalLine shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_horizontalLine') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.horizontalLine);
    });

    testWidgets('Scatter series with various marker diamond shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_diamond') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.diamond);
    });

    testWidgets('Scatter series with various marker triangle shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_triangle') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.triangle);
    });

    testWidgets('Scatter series with various marker invertedTriangle shapes',
        (WidgetTester tester) async {
      final _ScatterMarker chartContainer =
          _scatterMarker('shape_invertedTriangle') as _ScatterMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.isVisible, false);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.invertedTriangle);
    });
  });
}

StatelessWidget _scatterMarker(String sampleName) {
  return _ScatterMarker(sampleName);
}

// ignore: must_be_immutable
class _ScatterMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ScatterMarker(String sampleName) {
    chart = getScatterchart(sampleName);
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
