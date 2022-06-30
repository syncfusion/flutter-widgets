import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'step_area_sample.dart';

/// Test method for markers in the step area series.
void stepAreaMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('StepArea Series - Marker', () {
    testWidgets('Chart Widget - Testing StepArea Series with Marker',
        (WidgetTester tester) async {
      final _StepAreaMarker chartContainer =
          _stepAreaMarker('marker_default') as _StepAreaMarker;
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

    // Line series with marker
    testWidgets(
        'Chart Widget - Testing StepArea Sries with Marker Customization',
        (WidgetTester tester) async {
      final _StepAreaMarker chartContainer =
          _stepAreaMarker('marker_cutomization') as _StepAreaMarker;
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
      expect(marker.borderColor!.value, Colors.red.value);
      expect(marker.borderWidth, 5);
    });

    // Line series with marker
    testWidgets(
        'Chart Widget - Testing StepArea series Makrer with Empty Point',
        (WidgetTester tester) async {
      final _StepAreaMarker chartContainer =
          _stepAreaMarker('marker_EmptyPoint') as _StepAreaMarker;
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
}

StatelessWidget _stepAreaMarker(String sampleName) {
  return _StepAreaMarker(sampleName);
}

// ignore: must_be_immutable
class _StepAreaMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StepAreaMarker(String sampleName) {
    chart = getStepAreachart(sampleName);
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
