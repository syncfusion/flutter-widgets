// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'chart_sample.dart';

// /// Test method for unbounded width in chart.
// void chartUnboundedWidth() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Chart Size - unbounded', () {
//     testWidgets('Chart Widget - Size unbounded Width',
//         (WidgetTester tester) async {
//       final _ChartUnboundedWidth chartContainer =
//           _chartUnboundedWidth('size') as _ChartUnboundedWidth;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     test('Test Container Rect', () {
//       expect(
//           _chartState!._renderingDetails.chartContainerRect.width.toInt(), 619);
//       expect(_chartState!._renderingDetails.chartContainerRect.height.toInt(),
//           262);
//     });
//     test('Test Bottom Axes Bounds', () {
//       final Rect bottomAxes =
//           _chartState!._chartAxis._bottomAxisRenderers[0]._bounds;
//       expect(bottomAxes.bottom.toInt(), 262);
//       expect(bottomAxes.left.toInt(), 54);
//       expect(bottomAxes.right.toInt(), 619);
//       expect(bottomAxes.top.toInt(), 220);
//     });
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

// StatelessWidget _chartUnboundedWidth(String sampleName) {
//   return _ChartUnboundedWidth(sampleName);
// }

// // ignore: must_be_immutable
// class _ChartUnboundedWidth extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ChartUnboundedWidth(String sampleName) {
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
//           body: Column(children: <Widget>[chart!])),
//     );
//   }
// }
