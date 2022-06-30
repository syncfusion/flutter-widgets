// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'chart_sample.dart';

// /// Test method for default size in chart.
// void chartNormal() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Chart Size - Normal', () {
//     testWidgets('Chart Widget - Size Normal', (WidgetTester tester) async {
//       final _ChartNormal chartContainer = _chartNormal('size') as _ChartNormal;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     // test('Test Container Rect', () {
//     //   expect(
//     //       _chartState!._renderingDetails.chartContainerRect.width.toInt(), 119);
//     //   expect(_chartState!._renderingDetails.chartContainerRect.height.toInt(),
//     //       262);
//     // });
//     // test('Test Bottom Axes Bounds', () {
//     //   final Rect bottomAxes =
//     //       _chartState!._chartAxis._bottomAxisRenderers[0]._bounds;
//     //   expect(bottomAxes.bottom.toInt(), 262);
//     //   expect(bottomAxes.left.toInt(), 54);
//     //   expect(bottomAxes.right.toInt(), 119);
//     //   expect(bottomAxes.top.toInt(), 220);
//     // });
//     test('Test Left Axes Bounds', () {
//       final Rect leftAxes =
//           _chartState!._chartAxis._leftAxisRenderers[0]._bounds;
//       expect(leftAxes.bottom.toInt(), 220);
//       expect(leftAxes.left.toInt(), 54);
//       expect(leftAxes.right.toInt(), 108);
//       expect(leftAxes.top.toInt(), 10);
//     });
//   });
// }

// StatelessWidget _chartNormal(String sampleName) {
//   return _ChartNormal(sampleName);
// }

// // ignore: must_be_immutable
// class _ChartNormal extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ChartNormal(String sampleName) {
//     chart = _getChartSample(sampleName);
//   }
//   SfCartesianChart? chart;

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
//             height: 300,
//             width: 300,
//             margin: EdgeInsets.zero,
//             child: chart,
//           ))),
//     );
//   }
// }
