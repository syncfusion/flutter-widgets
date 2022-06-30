// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'chart_sample.dart';

// /// Test method for unbounded height in chart.
// void chartUnboundedHeight() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Chart Size - unbounded', () {
//     testWidgets('Chart Widget - Size unbounded height',
//         (WidgetTester tester) async {
//       final _ChartUnboundedHeight chartContainer =
//           _chartUnboundedHeight('size') as _ChartUnboundedHeight;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });
//     // test('Test Container Rect', () {
//     //   expect(
//     //       _chartState!._renderingDetails.chartContainerRect.width.toInt(), 280);
//     //   expect(_chartState!._renderingDetails.chartContainerRect.height.toInt(),
//     //       473);
//     // });
//     // test('Test Bottom Axes Bounds', () {
//     //   final Rect bottomAxes =
//     //       _chartState!._chartAxis._bottomAxisRenderers[0]._bounds;
//     //   expect(bottomAxes.bottom.toInt(), 473);
//     //   expect(bottomAxes.left.toInt(), 54);
//     //   expect(bottomAxes.right.toInt(), 280);
//     //   expect(bottomAxes.top.toInt(), 431);
//     // });
//     // test('Test Left Axes Bounds', () {
//     //   final Rect leftAxes =
//     //       _chartState!._chartAxis._leftAxisRenderers[0]._bounds;
//     //   expect(leftAxes.bottom.toInt(), 431);
//     //   expect(leftAxes.left.toInt(), 54);
//     //   expect(leftAxes.right.toInt(), 108);
//     //   expect(leftAxes.top.toInt(), 10);
//     // });
//   });
// }

// StatelessWidget _chartUnboundedHeight(String sampleName) {
//   return _ChartUnboundedHeight(sampleName);
// }

// // ignore: must_be_immutable
// class _ChartUnboundedHeight extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _ChartUnboundedHeight(String sampleName) {
//     chart = _getChartSample(sampleName);
//   }
//   SfCartesianChart? chart;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Demo',
//         home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Test Chart Widget'),
//           ),
//           body: Row(children: <Widget>[chart!]),
//         ));
//   }
// }
