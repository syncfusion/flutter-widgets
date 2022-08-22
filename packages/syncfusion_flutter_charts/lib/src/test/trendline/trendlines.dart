import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'trendline_samples.dart';

/// Test method of the trendlines.
void trendLines() {
  SfCartesianChart? chart;

  group('LineSeries', () {
    testWidgets('Trendline customization', (WidgetTester tester) async {
      final _CartesianTrendline chartContainer =
          _cartesianTrendline('customization') as _CartesianTrendline;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    // });
    // test('to test trendline animation, color and opacity', () {
    //   final LineSeries<dynamic, dynamic> series =
    //       chart!.series[0] as LineSeries<dynamic, dynamic>;
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(series.trendlines![0].animationDuration, 3000);
    //   expect(trendlineRenderer._fillColor, Colors.blue);
    //   expect(trendlineRenderer._opacity, 0.5);
    //   expect(series.trendlines![0].width, 4);
    // });
    test('to test trendline legend', () {
      final LineSeries<dynamic, dynamic> series =
          chart!.series[0] as LineSeries<dynamic, dynamic>;
      expect(series.trendlines![0].isVisibleInLegend, true);
    });
    test('to test trendline marker', () {
      final LineSeries<dynamic, dynamic> series =
          chart!.series[0] as LineSeries<dynamic, dynamic>;
      expect(series.trendlines![0].markerSettings.isVisible, true);
      expect(series.trendlines![0].markerSettings.color, Colors.green);
      expect(
          series.trendlines![0].markerSettings.shape, DataMarkerType.pentagon);
    });

    testWidgets('Forward and backward forecast', (WidgetTester tester) async {
      final _CartesianTrendline chartContainer =
          _cartesianTrendline('linear_with_forecast') as _CartesianTrendline;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      await tester.pump(const Duration(seconds: 3));
    });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 2);
    // });
    // test('to test backward forecast point', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![0].x, -1.0);
    // });
    // test('to test forward forecast point', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![1].x, 9.0);
    // });

    // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
    //   final _CartesianTrendline chartContainer =
    //       _cartesianTrendline('exponential_with_forecast')
    //           as _CartesianTrendline;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 3);
    // });
    // test('to test backward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![0].x, -1.0);
    // });
    // test('to test forward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![2].x, 9.0);
    // });

    // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
    //   final _CartesianTrendline chartContainer =
    //       _cartesianTrendline('power_with_forecast') as _CartesianTrendline;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 3);
    // });
    // test('to test backward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![0].x, 0);
    // });
    // test('to test forward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![2].x, 9.0);
    // });

    // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
    //   final _CartesianTrendline chartContainer =
    //       _cartesianTrendline('logarithmic_with_forecast')
    //           as _CartesianTrendline;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 3);
    // });
    // test('to test backward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![0].x, -1.0);
    // });
    // test('to test forward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![2].x, 9.0);
    // });

    // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
    //   final _CartesianTrendline chartContainer =
    //       _cartesianTrendline('polynomial_with_forecast')
    //           as _CartesianTrendline;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 3);
    // });
    // test('to test backward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![0].x, -1.0);
    // });
    // test('to test forward forecast points', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._pointsData![2].x, 9.0);
    // });

    // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
    //   final _CartesianTrendline chartContainer =
    //       _cartesianTrendline('movingAverage') as _CartesianTrendline;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test trendline visiblity', () {
    //   final TrendlineRenderer trendlineRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
    //   expect(trendlineRenderer._visible, true);
    //   expect(trendlineRenderer._isNeedRender, true);
    //   expect(trendlineRenderer._pointsData!.length, 4);
    // });
  });

  // group('ColumnSeries', () {
  //   testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //     final _CartesianTrendline chartContainer =
  //         _cartesianTrendline('Column-linear_with_forecast')
  //             as _CartesianTrendline;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfCartesianChartState?;
  //     await tester.pump(const Duration(seconds: 3));
  //   });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 2);
  // });
  // test('to test backward forecast point', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![0].x, -1.0);
  // });
  // test('to test forward forecast point', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![1].x, 9.0);
  // });

  // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //   final _CartesianTrendline chartContainer =
  //       _cartesianTrendline('Column-exponential_with_forecast')
  //           as _CartesianTrendline;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 3);
  // });
  // test('to test backward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![0].x, -1.0);
  // });
  // test('to test forward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![2].x, 9.0);
  // });

  // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //   final _CartesianTrendline chartContainer =
  //       _cartesianTrendline('Column-power_with_forecast')
  //           as _CartesianTrendline;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 3);
  // });
  // test('to test backward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![0].x, 0);
  // });
  // test('to test forward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![2].x, 9.0);
  // });

  // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //   final _CartesianTrendline chartContainer =
  //       _cartesianTrendline('Column-logarithmic_with_forecast')
  //           as _CartesianTrendline;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 3);
  // });
  // test('to test backward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![0].x, -1.0);
  // });
  // test('to test forward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![2].x, 9.0);
  // });

  // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //   final _CartesianTrendline chartContainer =
  //       _cartesianTrendline('Column-polynomial_with_forecast')
  //           as _CartesianTrendline;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 3);
  // });
  // test('to test backward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![0].x, -1.0);
  // });
  // test('to test forward forecast points', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._pointsData![2].x, 9.0);
  // });

  // testWidgets('Forward and backward forecast', (WidgetTester tester) async {
  //   final _CartesianTrendline chartContainer =
  //       _cartesianTrendline('Column-movingAverage') as _CartesianTrendline;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });
  // test('to test trendline visiblity', () {
  //   final TrendlineRenderer trendlineRenderer = _chartState!
  //       ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
  //   expect(trendlineRenderer._visible, true);
  //   expect(trendlineRenderer._isNeedRender, true);
  //   expect(trendlineRenderer._pointsData!.length, 4);
  // });
//  });

//   group('BubbleSeries', () {
//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-linear_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 2);
//     });
//     test('to test backward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![1].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-exponential_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-power_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, 0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-logarithmic_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-polynomial_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Bubble-movingAverage') as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 4);
//     });
//   });

//   group('RangeColumnSeries', () {
//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-linear_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 2);
//     });
//     test('to test backward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![1].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-exponential_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-power_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, 0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-logarithmic_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-polynomial_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('RangeColumn-movingAverage')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 4);
//     });
//   });

//   group('AreaSeries', () {
//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-linear_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 2);
//     });
//     test('to test backward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![1].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-exponential_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-power_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, 0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-logarithmic_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-polynomial_with_forecast')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//     });
//     test('to test backward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].x, -1.0);
//     });
//     test('to test forward forecast points', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].x, 9.0);
//     });

//     testWidgets('Forward and backward forecast', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('Area-movingAverage') as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 4);
//     });
//   });

//   group('Intercept', () {
//     testWidgets('linear trendline with intercept', (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('linear_with_intercept') as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final ColumnSeries<dynamic, dynamic> series =
//           chart!.series[0] as ColumnSeries<dynamic, dynamic>;
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 2);
//       expect(series.trendlines![0].intercept, 20);
//     });
//     test('to test backward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].y, 25.935483870967744);
//     });
//     test('to test forward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![1].y, 67.48387096774194);
//     });

//     testWidgets('exponential trendline with intercept',
//         (WidgetTester tester) async {
//       final _CartesianTrendline chartContainer =
//           _cartesianTrendline('exponential_with_intercept')
//               as _CartesianTrendline;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trendline visiblity', () {
//       final ColumnSeries<dynamic, dynamic> series =
//           chart!.series[0] as ColumnSeries<dynamic, dynamic>;
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._visible, true);
//       expect(trendlineRenderer._isNeedRender, true);
//       expect(trendlineRenderer._pointsData!.length, 3);
//       expect(series.trendlines![0].intercept, 25);
//     });
//     test('to test backward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![0].y, 28.35093198429452);
//     });
//     test('to test forward forecast point', () {
//       final TrendlineRenderer trendlineRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//       expect(trendlineRenderer._pointsData![2].y, 68.38465496167598);
//     });
//   });

//   testWidgets('exponential trendline with intercept',
//       (WidgetTester tester) async {
//     final _CartesianTrendline chartContainer =
//         _cartesianTrendline('trendline_event') as _CartesianTrendline;
//     await tester.pumpWidget(chartContainer);
//     chart = chartContainer.chart;
//     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     _chartState = key.currentState as SfCartesianChartState?;
//     await tester.pump(const Duration(seconds: 3));
//   });
//   test('to test the trendline render event args', () {
//     final TrendlineRenderer trendlineRenderer = _chartState!
//         ._chartSeries.visibleSeriesRenderers[0]._trendlineRenderer[0];
//     expect(trendlineRenderer._fillColor, Colors.greenAccent);
//     expect(trendlineRenderer._opacity, 0.18);
//     expect(trendlineRenderer._dashArray![0], 5);
//     expect(trendlineRenderer._dashArray![1], 3);
//   });
}

StatelessWidget _cartesianTrendline(String sampleName) {
  return _CartesianTrendline(sampleName);
}

// ignore: must_be_immutable
class _CartesianTrendline extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CartesianTrendline(String sampleName) {
    chart = getCartesianTrendlineSample(sampleName);
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
