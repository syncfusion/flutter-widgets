import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'events_sample.dart';

/// Test method of the triangular chart events.
void triangularEvents() {
  SfPyramidChart? chart;

  group('Pyramid Events -', () {
    testWidgets('DataLabel render events', (WidgetTester tester) async {
      final _TriangularEvents chartContainer =
          _triangularEvents('triangular_DataLabel_Legend') as _TriangularEvents;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    // test('to test data label', () {
    //   final PyramidSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   expect(seriesRenderer._dataPoints[0].y, 32);
    // });
    test('to test shape', () {
      final PyramidSeries<dynamic, dynamic> series = chart!.series;
      expect(series.legendIconType, LegendIconType.seriesType);
    });
  });
}

StatelessWidget _triangularEvents(String sampleName) {
  return _TriangularEvents(sampleName);
}

// ignore: must_be_immutable
class _TriangularEvents extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TriangularEvents(String sampleName) {
    chart = getPyramidChartSample(sampleName);
  }
  SfPyramidChart? chart;
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
