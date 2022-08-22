// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import 'package:intl/intl.dart';
// import '../../../charts.dart';
// import 'circular_sample.dart';

// /// Test method of the circular chart bugs.
// void customerBugTestCircular() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCircularChart? chart;

//   group('Customer bugs - Pie Position - legend bottom ', () {
//     testWidgets('Testing Pie series with bottom legend',
//         (WidgetTester tester) async {
//       final _CustomerBugCircular chartContainer =
//           _customerBugCircular('bottom_legend') as _CustomerBugCircular;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test pie series position', () {
//       final CircularSeriesRenderer seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final PieSeries<dynamic, dynamic> series =
//           seriesRenderer._series as PieSeries<dynamic, dynamic>;
//       expect(series.startAngle, 0);
//       expect(series.endAngle, 360);
//       expect(seriesRenderer._center!.dy.toInt(), 248);
//       expect(seriesRenderer._center!.dx.toInt(), 390);
//     });
//     test('test pie position', () {
//       final ChartPoint<dynamic> visiblePoint =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//       expect(visiblePoint.startAngle, -90);
//       expect(visiblePoint.endAngle, -27.391304347826086);
//       expect(visiblePoint.midAngle, -58.69565217391305);
//       expect(visiblePoint.center!.dy.toInt(), 248);
//       expect(visiblePoint.center!.dx, 390.0);
//       expect(visiblePoint.innerRadius, 0.0);
//       expect(visiblePoint.outerRadius!.toInt(), 190);
//       expect(visiblePoint.fill.value, 4283140025);
//     });
//   });

//   group('Pie Position - legend top ', () {
//     testWidgets('Testing Pie series with top legend',
//         (WidgetTester tester) async {
//       final _CustomerBugCircular chartContainer =
//           _customerBugCircular('top_legend') as _CustomerBugCircular;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test pie series position', () {
//       final CircularSeriesRenderer seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final PieSeries<dynamic, dynamic> series =
//           seriesRenderer._series as PieSeries<dynamic, dynamic>;
//       expect(series.startAngle, 0);
//       expect(series.endAngle, 360);
//       expect(seriesRenderer._center!.dy.toInt(), 248);
//       expect(seriesRenderer._center!.dx.toInt(), 390);
//     });
//     test('test pie position', () {
//       final ChartPoint<dynamic> visiblePoint =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//       expect(visiblePoint.startAngle, -90);
//       expect(visiblePoint.endAngle, -27.391304347826086);
//       expect(visiblePoint.midAngle, -58.69565217391305);
//       expect(visiblePoint.center!.dy.toInt(), 248);
//       expect(visiblePoint.center!.dx, 390.0);
//       expect(visiblePoint.innerRadius, 0.0);
//       expect(visiblePoint.outerRadius!.toInt(), 190);
//       expect(visiblePoint.fill.value, const Color(0xff4b87b9).value);
//     });
//   });

//   group('Pie Position - legend right ', () {
//     testWidgets('Testing Pie series with right legend',
//         (WidgetTester tester) async {
//       final _CustomerBugCircular chartContainer =
//           _customerBugCircular('right_legend') as _CustomerBugCircular;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test pie series position', () {
//       final CircularSeriesRenderer seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final PieSeries<dynamic, dynamic> series =
//           seriesRenderer._series as PieSeries<dynamic, dynamic>;
//       expect(series.startAngle, 0);
//       expect(series.endAngle, 360);
//       expect(seriesRenderer._center!.dy.toInt(), 262);
//       expect(seriesRenderer._center!.dx.toInt(), 325);
//     });
//     test('test pie position', () {
//       final ChartPoint<dynamic> visiblePoint =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//       expect(visiblePoint.startAngle, -90);
//       expect(visiblePoint.endAngle, -27.391304347826086);
//       expect(visiblePoint.midAngle, -58.69565217391305);
//       expect(visiblePoint.center!.dy.toInt(), 262);
//       expect(visiblePoint.center!.dx, 325.0);
//       expect(visiblePoint.innerRadius, 0.0);
//       expect(visiblePoint.outerRadius!.toInt(), 201);
//       expect(visiblePoint.fill.value, const Color(0xff4b87b9).value);
//     });
//   });
//   group('Pie Position - legend left ', () {
//     testWidgets('Testing Pie series with left legend',
//         (WidgetTester tester) async {
//       final _CustomerBugCircular chartContainer =
//           _customerBugCircular('left_legend') as _CustomerBugCircular;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test pie series position', () {
//       final CircularSeriesRenderer seriesRenderer =
//           _chartState!._chartSeries.visibleSeriesRenderers[0];
//       final CircularSeries<dynamic, dynamic> series = seriesRenderer._series;
//       expect(series.startAngle, 0);
//       expect(series.endAngle, 360);
//       expect(seriesRenderer._center!.dy.toInt(), 262);
//       expect(seriesRenderer._center!.dx.toInt(), 325);
//     });
//     test('test pie position', () {
//       final ChartPoint<dynamic> visiblePoint =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//       expect(visiblePoint.startAngle, -90);
//       expect(visiblePoint.endAngle, -27.391304347826086);
//       expect(visiblePoint.midAngle, -58.69565217391305);
//       expect(visiblePoint.center!.dy.toInt(), 262);
//       expect(visiblePoint.center!.dx, 325.0);
//       expect(visiblePoint.innerRadius, 0.0);
//       expect(visiblePoint.outerRadius!.toInt(), 201);
//       expect(visiblePoint.fill.value, const Color(0xff4b87b9).value);
//     });
//   });
// }

// StatelessWidget _customerBugCircular(String sampleName) {
//   return _CustomerBugCircular(sampleName);
// }

// // ignore: must_be_immutable
// class _CustomerBugCircular extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _CustomerBugCircular(String sampleName) {
//     chart = _getCustomerBugCircular(sampleName);
//   }
//   SfCircularChart? chart;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Test Chart Widget'),
//           ),
//           body: Center(
//               child: Container(
//             margin: EdgeInsets.zero,
//             child: chart,
//           ))),
//     );
//   }
// }
