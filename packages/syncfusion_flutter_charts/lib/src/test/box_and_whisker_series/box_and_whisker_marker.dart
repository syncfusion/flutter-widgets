import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'box_and_whisker_sample.dart';

/// Test method for markers in the Box plot series.
void boxPlotMarker() {
  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Box Plot - Marker', () {
    testWidgets('Chart Widget - Testing Box Plot Series with Marker',
        (WidgetTester tester) async {
      final _BoxPlotMarker chartContainer =
          _boxPlotMarker('marker_default') as _BoxPlotMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // Measure text height and width
    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.color, null);
      expect(marker.width, 8.0);
      expect(marker.height, 8.0);
      expect(marker.shape, DataMarkerType.circle);
      expect(marker.borderColor, null);
      expect(marker.borderWidth, 2);
    });

    // Box plot series with marker
    testWidgets(
        'Chart Widget - Testing Box Plot Sries with Marker Customization',
        (WidgetTester tester) async {
      final _BoxPlotMarker chartContainer =
          _boxPlotMarker('marker_cutomization') as _BoxPlotMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;

      final MarkerSettings marker = cartesianSeries.markerSettings;
      expect(marker.color, Colors.deepOrange);
      expect(marker.width, 10);
      expect(marker.height, 10);
      expect(marker.shape, DataMarkerType.diamond);
      expect(marker.borderColor, Colors.red);
      expect(marker.borderWidth, 5);
    });
  });
}

StatelessWidget _boxPlotMarker(String sampleName) {
  return _BoxPlotMarker(sampleName);
}

// ignore: must_be_immutable
class _BoxPlotMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BoxPlotMarker(String sampleName) {
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
