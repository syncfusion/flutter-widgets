import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'range_column_sample.dart';

/// Test method for markers in the range column series.
void rangeColumnMarker() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('RangeColumn Marker', () {
    testWidgets('Chart Widget - Testing RangeColumn Series with Marker',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_default') as _RangeColumnBarMarker;
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
        'Chart Widget - Testing RangeColumn Series with Marker Customization',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_cutomization') as _RangeColumnBarMarker;
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
        'Chart Widget - Testing RangeColumn series Marker with Empty Point',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_EmptyPoint') as _RangeColumnBarMarker;
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

    testWidgets(
        'Chart Widget - Testing RangeColumn series Marker with Empty Point',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_EmptyPoint_avg')
              as _RangeColumnBarMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test marker default properties', () {
      // for (int i = 0; i < chart.series.length; i++) {
      final CartesianSeries<dynamic, dynamic> cartesianSeries =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      expect(cartesianSeries.emptyPointSettings.mode, EmptyPointMode.average);
      // }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series Marker with Point ColorMapping',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_PointColormapping')
              as _RangeColumnBarMarker;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    // Measure text height and width
    test('to test marker point color mapping  properties', () {
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

    // marker shapes
    testWidgets(
        'Chart Widget - Testing RangeColumn Series with different Marker shapes',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_rect') as _RangeColumnBarMarker;
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
        expect(marker.shape, DataMarkerType.rectangle);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with different Marker shapes',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_pentagon') as _RangeColumnBarMarker;
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
        expect(marker.shape, DataMarkerType.pentagon);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with with different Marker shapes',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_verticalLine') as _RangeColumnBarMarker;
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
        expect(marker.shape, DataMarkerType.verticalLine);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with with different Marker shapes',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_invertTriangle')
              as _RangeColumnBarMarker;
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
        expect(marker.shape, DataMarkerType.invertedTriangle);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });

    testWidgets(
        'Chart Widget - Testing RangeColumn Series with with different Marker shapes',
        (WidgetTester tester) async {
      final _RangeColumnBarMarker chartContainer =
          _rangeColumnBarMarker('marker_triangle') as _RangeColumnBarMarker;
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
        expect(marker.shape, DataMarkerType.triangle);
        expect(marker.borderColor, Colors.red);
        expect(marker.borderWidth, 5);
      }
    });
  });
}

StatelessWidget _rangeColumnBarMarker(String sampleName) {
  return _RangeColumnBarMarker(sampleName);
}

// ignore: must_be_immutable
class _RangeColumnBarMarker extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RangeColumnBarMarker(String sampleName) {
    chart = getRangeColumnchart(sampleName);
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
