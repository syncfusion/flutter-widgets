// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'radialbar_sample.dart';

// /// Testing method of radial bar chart data source.
// void radialBarDataSource() {
// // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCircularChart? chart;

//   // group('RadialBar Single Point', () {
//   //   testWidgets('Testing RadialBar series with single point',
//   //       (WidgetTester tester) async {
//   //     final _RadialBarDataSource chartContainer =
//   //         _radialBarDataSource('single_point') as _RadialBarDataSource;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     // _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('test empty point average', () {
//   //     final ChartPoint<dynamic> visiblePoint =
//   //         _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
//   //     expect(visiblePoint.startAngle, -90);
//   //     expect(visiblePoint.endAngle, 269.999);
//   //     expect(visiblePoint.midAngle, 89.99950000000001);
//   //     expect(visiblePoint.center!.dy.toInt(), 272);
//   //     expect(visiblePoint.center!.dx, 400.0);
//   //     expect(visiblePoint.innerRadius, 104.80000000000001);
//   //     expect(visiblePoint.outerRadius!.toInt(), 208);
//   //     expect(visiblePoint.fill.value, const Color(0xff4b87b9).value);
//   //   });
//   // });

//   group('Radial Bar - Mapping', () {
//     testWidgets(
//         'Accumulation Chart Widget - Testing RadialBar series with Radius Mapping',
//         (WidgetTester tester) async {
//       final _RadialBarDataSource chartContainer =
//           _radialBarDataSource('radiusMapping') as _RadialBarDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point radius', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].outerRadius!.toInt(), 127);
//       expect(points[1].outerRadius!.toInt(), 159);
//       expect(points[2].outerRadius!.toInt(), 191);
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing RadialBar series with SortField Mapping',
//         (WidgetTester tester) async {
//       final _RadialBarDataSource chartContainer =
//           _radialBarDataSource('sorting') as _RadialBarDataSource;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test point order', () {
//       final List<ChartPoint<dynamic>> points =
//           _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
//       expect(points[0].x.toString(), 'Facilities');
//       expect(points[1].x.toString(), 'Labour');
//       expect(points[2].x.toString(), 'Legal');
//       expect(points[3].x.toString(), 'License');
//       expect(points[4].x.toString(), 'Production');
//     });
//   });
// }

// StatelessWidget _radialBarDataSource(String sampleName) {
//   return _RadialBarDataSource(sampleName);
// }

// // ignore: must_be_immutable
// class _RadialBarDataSource extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _RadialBarDataSource(String sampleName) {
//     chart = _getRadialbarchart(sampleName);
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
