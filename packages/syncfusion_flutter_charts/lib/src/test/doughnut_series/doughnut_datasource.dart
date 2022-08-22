// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'doughnut_sample.dart';

// /// Testing method of doughnut series data source.
// void doughnutDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCircularChart? chart;
//   SfCircularChartState? _chartState;

//   group('Doughnut - Empty Point', () {
//     testWidgets(
//         'Accumulation Chart Widget - Testing Doughnut series with EmptyPoint Average',
//         (WidgetTester tester) async {
//       final _DoughnutDataSource chartContainer =
//           _doughnutDataSource('emptypoint_avg') as _DoughnutDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     // test('test empty point average', () {
//     //   final ChartPoint<dynamic> visiblePoint =
//     //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![1];
//     //   expect(visiblePoint.startAngle, 22.941176470588232);
//     //   expect(visiblePoint.endAngle, 142.94117647058823);
//     //   expect(visiblePoint.midAngle, 82.94117647058823);
//     //   expect(visiblePoint.center!.dy.toInt(), 250);
//     //   expect(visiblePoint.center!.dx, 400.0);
//     //   expect(visiblePoint.innerRadius!.toInt(), 96);
//     //   expect(visiblePoint.outerRadius!.toInt(), 192);
//     //   expect(const Color(0xff00bcd4).value, visiblePoint.fill.value);
//     // });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Doughnut series with EmptyPoint Gap',
//         (WidgetTester tester) async {
//       final _DoughnutDataSource chartContainer =
//           _doughnutDataSource('emptypoint_gap') as _DoughnutDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     // test('test empty point gap', () {
//     //   final int pointLength = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//     //   expect(2, pointLength);
//     // });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Doughnut series with EmptyPoint Drop',
//         (WidgetTester tester) async {
//       final _DoughnutDataSource chartContainer =
//           _doughnutDataSource('emptypoint_drop') as _DoughnutDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     // test('test empty point drop', () {
//     //   final int pointLength = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//     //   expect(2, pointLength);
//     // });

//     // testWidgets(
//     //     'Accumulation Chart Widget - Testing Doughnut series with EmptyPoint Zero',
//     //     (WidgetTester tester) async {
//     //   final _DoughnutDataSource chartContainer =
//     //       _doughnutDataSource('emptypoint_zero') as _DoughnutDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCircularChartState?;
//     // });

//     // test('test empty point zero', () {
//     //   final int pointLength = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//     //   expect(pointLength, 3);
//     // });

//     // testWidgets(
//     //     'Accumulation Chart Widget - Testing Doughnut series with Radius Mapping',
//     //     (WidgetTester tester) async {
//     //   final _DoughnutDataSource chartContainer =
//     //       _doughnutDataSource('radiusMapping') as _DoughnutDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCircularChartState?;
//     // });

//     // test('test point radius', () {
//     //   final List<ChartPoint<dynamic>> points =
//     //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//     //   expect(points[0].outerRadius!.toInt(), 48);
//     //   expect(points[1].outerRadius!.toInt(), 105);
//     //   expect(points[2].outerRadius!.toInt(), 72);
//     // });
//     // testWidgets(
//     //     'Accumulation Chart Widget - Testing doughnut series with SortField Mapping',
//     //     (WidgetTester tester) async {
//     //   final _DoughnutDataSource chartContainer =
//     //       _doughnutDataSource('sorting') as _DoughnutDataSource;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCircularChartState?;
//     // });

//     // test('test point order', () {
//     //   final List<ChartPoint<dynamic>> points =
//     //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//     //   expect(points[0].x.toString(), 'China');
//     //   expect(points[1].x.toString(), 'India');
//     //   expect(points[2].x.toString(), 'Japan');
//     //   expect(points[3].x.toString(), 'London');
//     //   expect(points[4].x.toString(), 'Spain');
//     // });
//   });
// }

// StatelessWidget _doughnutDataSource(String sampleName) {
//   return _DoughnutDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _DoughnutDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _DoughnutDataSource(String sampleName) {
//     chart = getDoughnutchart(sampleName);
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
