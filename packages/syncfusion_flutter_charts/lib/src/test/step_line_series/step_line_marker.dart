import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'step_line_sample.dart';

/// Test method for markers in the step line series.
void stepLineMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('Step Line - Marker', () {
    testWidgets('Chart Widget - Testing Step Line Series with Marker',
        (WidgetTester tester) async {
      final _StepLineMarker chartContainer =
          _stepLineMarker('marker_default') as _StepLineMarker;
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
      expect(marker.width.toInt(), 8);
      expect(marker.height.toInt(), 8);
      expect(marker.shape, DataMarkerType.circle);
      expect(marker.borderColor, null);
      expect(marker.borderWidth, 2);
    });

    // Step Line series with marker
    testWidgets(
        'Chart Widget - Testing Step Line Sries with Marker Customization',
        (WidgetTester tester) async {
      final _StepLineMarker chartContainer =
          _stepLineMarker('marker_cutomization') as _StepLineMarker;
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

    // Step Line series with marker
    testWidgets(
        'Chart Widget - Testing Step Line series Makrer with Empty Point',
        (WidgetTester tester) async {
      final _StepLineMarker chartContainer =
          _stepLineMarker('marker_EmptyPoint') as _StepLineMarker;
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
      expect(marker.borderColor!.value, 4294198070);
      expect(marker.borderWidth, 5);
    });
  });
}

StatelessWidget _stepLineMarker(String sampleName) {
  return _StepLineMarker(sampleName);
}

// ignore: must_be_immutable
class _StepLineMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StepLineMarker(String sampleName) {
    chart = getStepLine(sampleName);
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
