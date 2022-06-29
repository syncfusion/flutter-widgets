import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bubble_sample.dart';

/// Test method for markers in the bubble series.
void bubbleMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bubble Marker', () {
    testWidgets('Chart Widget - Testing Bubble Series with Marker',
        (WidgetTester tester) async {
      final _BubbleMarker chartContainer =
          _bubbleMarker('marker_default') as _BubbleMarker;
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

    // Line series with marker
    testWidgets('Chart Widget - Testing Line Sries with Marker Customization',
        (WidgetTester tester) async {
      final _BubbleMarker chartContainer =
          _bubbleMarker('marker_cutomization') as _BubbleMarker;
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

    // Line series with marker
    testWidgets('Chart Widget - Testing Line series Makrer with Empty Point',
        (WidgetTester tester) async {
      final _BubbleMarker chartContainer =
          _bubbleMarker('marker_EmptyPoint') as _BubbleMarker;
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

StatelessWidget _bubbleMarker(String sampleName) {
  return _BubbleMarker(sampleName);
}

// ignore: must_be_immutable
class _BubbleMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BubbleMarker(String sampleName) {
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
