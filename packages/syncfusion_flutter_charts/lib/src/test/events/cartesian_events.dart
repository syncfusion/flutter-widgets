import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'events_sample.dart';

/// Test method of cartesian chart events.
void cartesianEvents() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Cartesian Events -', () {
    // testWidgets('onActualRangeChanged cartesian event for numeric axis',
    //     (WidgetTester tester) async {
    //   final _CartesianEvents chartContainer =
    //       _cartesianEvents('cartesian_onActualRangeChanged_numeric')
    //           as _CartesianEvents;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       '2008');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[1].text,
    //       '2012');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       '2020');
    // });
    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '5');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[1].text,
    //       '10');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '50');
    // });

    // testWidgets('onActualRangeChanged cartesian event for date time axis',
    //     (WidgetTester tester) async {
    //   final _CartesianEvents chartContainer =
    //       _cartesianEvents('cartesian_RangeChanged_dateTime')
    //           as _CartesianEvents;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'Dec 1');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[1].text,
    //       'Jan 1');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Dec 1');
    // });
    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '5');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[1].text,
    //       '10');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '50');
    // });

    // testWidgets('onActualRangeChanged cartesian event for category axis',
    //     (WidgetTester tester) async {
    //   final _CartesianEvents chartContainer =
    //       _cartesianEvents('cartesian_RangeChanged_category')
    //           as _CartesianEvents;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[0].text,
    //       'USA');
    //   expect(
    //       _chartState!._chartAxis._primaryXAxisRenderer._visibleLabels[1].text,
    //       'Japan');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels.last.text,
    //       'Russia');
    // });
    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[0].text,
    //       '5');
    //   expect(
    //       _chartState!._chartAxis._primaryYAxisRenderer._visibleLabels[1].text,
    //       '10');
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels.last.text,
    //       '50');
    // });

    // testWidgets('AxisLabel, DataLabel and Legend item render cartesian events',
    //     (WidgetTester tester) async {
    //   final _CartesianEvents chartContainer =
    //       _cartesianEvents('cartesian_AxisLabel_DataLabel_Legend')
    //           as _CartesianEvents;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryXAxisRenderer._visibleLabels[0].renderText,
    //       '8');
    // });
    // test('to test primaryYAxis labels', () {
    //   expect(
    //       _chartState!
    //           ._chartAxis._primaryYAxisRenderer._visibleLabels[0].renderText,
    //       '10');
    // });

    // test('to test data label', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
    //     seriesRenderer._dataPoints[i].label = 'Custom Label';
    //   }
    // });
    // test('to test shape', () {
    //   expect(
    //       _chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._series.legendIconType,
    //       LegendIconType.seriesType);
    // });
    testWidgets('onMarkerRender catesian events', (WidgetTester tester) async {
      final _CartesianEvents chartContainer =
          _cartesianEvents('cartesian_onMarkerRender') as _CartesianEvents;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test markerRender event', () {
      expect(chart!.onMarkerRender == null, false);
    });
    testWidgets('onMarkerRender catesian events', (WidgetTester tester) async {
      final _CartesianEvents chartContainer =
          _cartesianEvents('events_marker_default') as _CartesianEvents;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test markerRender event', () {
      expect(chart!.onMarkerRender == null, false);
    });
  });
}

StatelessWidget _cartesianEvents(String sampleName) {
  return _CartesianEvents(sampleName);
}

// ignore: must_be_immutable
class _CartesianEvents extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CartesianEvents(String sampleName) {
    chart = getChartEventsSample(sampleName);
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
