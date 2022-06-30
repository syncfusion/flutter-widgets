// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'pie_sample.dart';

// /// Testing method of pie chart`s data source.
// void pieDataSource() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCircularChart? chart;

//   // group('Pie Single Point', () {
//   //   testWidgets('Testing Pie series with single point',
//   //       (WidgetTester tester) async {
//   //     final _PieDataSource chartContainer =
//   //         _pieDataSource('single_point') as _PieDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     // _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point average', () {
//   //     final ChartPoint<dynamic> visiblePoint =
//   //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//   //     expect(visiblePoint.startAngle, -90);
//   //     expect(visiblePoint.endAngle, 270);
//   //     expect(visiblePoint.midAngle, 90);
//   //     expect(visiblePoint.center!.dy.toInt(), 272);
//   //     expect(visiblePoint.center!.dx, 400.0);
//   //     expect(visiblePoint.innerRadius, 0.0);
//   //     expect(visiblePoint.outerRadius!.toInt(), 209);
//   //     expect(visiblePoint.fill.value, const Color(0xff4b87b9).value);
//   //   });
//   // });
//   // group('Pie - Empty Point', () {
//   //   testWidgets(
//   //       'Accumulation Chart Widget - Testing Pie series with EmptyPoint Average',
//   //       (WidgetTester tester) async {
//   //     final _PieDataSource chartContainer =
//   //         _pieDataSource('emptypoint_avg') as _PieDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point average', () {
//   //     final ChartPoint<dynamic> visiblePoint =
//   //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![1];
//   //     expect(visiblePoint.startAngle, 22.941176470588232);
//   //     expect(visiblePoint.endAngle, 142.94117647058823);
//   //     expect(visiblePoint.midAngle, 82.94117647058823);
//   //     expect(visiblePoint.center!.dy.toInt(), 250);
//   //     expect(visiblePoint.center!.dx, 400.0);
//   //     expect(visiblePoint.innerRadius, 0.0);
//   //     expect(visiblePoint.outerRadius!.toInt(), 192);
//   //     expect(const Color(0xff00bcd4).value, visiblePoint.fill.value);
//   //   });

//   //   testWidgets(
//   //       'Accumulation Chart Widget - Testing Pie series with EmptyPoint Gap',
//   //       (WidgetTester tester) async {
//   //     final _PieDataSource chartContainer =
//   //         _pieDataSource('emptypoint_gap') as _PieDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point gap', () {
//   //     final int pointLength = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//   //     expect(pointLength, 2);
//   //   });

//   //   testWidgets(
//   //       'Accumulation Chart Widget - Testing Pie series with EmptyPoint Drop',
//   //       (WidgetTester tester) async {
//   //     final _PieDataSource chartContainer =
//   //         _pieDataSource('emptypoint_drop') as _PieDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point drop', () {
//   //     final int pointLength = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//   //     expect(pointLength, 2);
//   //   });

//   //   testWidgets(
//   //       'Accumulation Chart Widget - Testing Pie series with EmptyPoint Zero',
//   //       (WidgetTester tester) async {
//   //     final _PieDataSource chartContainer =
//   //         _pieDataSource('emptypoint_zero') as _PieDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point zero', () {
//   //     final int pointLength = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
//   //     expect(pointLength, 3);
//   //   });
//   // });

//   group('Pie - Sorting & Radius Mapping', () {
//     testWidgets(
//         'Accumulation Chart Widget - Testing Pie series with Radius Mapping',
//         (WidgetTester tester) async {
//       final _PieDataSource chartContainer =
//           _pieDataSource('radiusMapping') as _PieDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point radius', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].outerRadius!.toInt(), 48);
//       expect(points[1].outerRadius!.toInt(), 105);
//       expect(points[2].outerRadius!.toInt(), 72);
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Pie series with SortField Mapping ascending',
//         (WidgetTester tester) async {
//       final _PieDataSource chartContainer =
//           _pieDataSource('sorting_ascending') as _PieDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point order', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].x.toString(), 'China');
//       expect(points[1].x.toString(), 'India');
//       expect(points[2].x.toString(), 'Japan');
//       expect(points[3].x.toString(), 'London');
//       expect(points[4].x.toString(), 'Spain');
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Pie series with SortField Mapping ascending customization',
//         (WidgetTester tester) async {
//       final _PieDataSource chartContainer =
//           _pieDataSource('sorting_ascending_customization') as _PieDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point order customization', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].x.toString(), 'India');
//       expect(points[1].x.toString(), 'Spain');
//       expect(points[2].x.toString(), 'London');
//       expect(points[3].x.toString(), 'China');
//       expect(points[4].x.toString(), 'Japan');
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Pie series with SortField Mapping descending',
//         (WidgetTester tester) async {
//       final _PieDataSource chartContainer =
//           _pieDataSource('sorting_descending') as _PieDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point order', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].x.toString(), 'Spain');
//       expect(points[1].x.toString(), 'London');
//       expect(points[2].x.toString(), 'Japan');
//       expect(points[3].x.toString(), 'India');
//       expect(points[4].x.toString(), 'China');
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Pie series with SortField Mapping descending customization',
//         (WidgetTester tester) async {
//       final _PieDataSource chartContainer =
//           _pieDataSource('sorting_descending_customization') as _PieDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point order customization', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].x.toString(), 'Japan');
//       expect(points[1].x.toString(), 'London');
//       expect(points[2].x.toString(), 'Spain');
//       expect(points[3].x.toString(), 'India');
//       expect(points[4].x.toString(), 'China');
//     });
//   });
// }

// StatelessWidget _pieDataSource(String sampleName) {
//   return _PieDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _PieDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _PieDataSource(String sampleName) {
//     chart = _getPiechart(sampleName);
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
