// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'doughnut_sample.dart';

// /// Test method of the doughnut series data label.
// void doughnutDataLabel() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCircularChart? chart;
//   SfCircularChartState? _chartState;

//   group('Doughnut - Data label', () {
//     testWidgets(
//         'Accumulation Chart Widget - Testing Doughnut series with Datalabel',
//         (WidgetTester tester) async {
//       final _DoughnutDataLAbel chartContainer =
//           _doughnutDataLAbel('datalabel_default') as _DoughnutDataLAbel;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test datalabel default', () {
//       final DataLabelSettings label = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._series.dataLabelSettings;
//       expect(label.borderColor.value, const Color(0x00000000).value);
//       expect(label.borderWidth, 0.0);
//       expect(label.connectorLineSettings.length, null);
//       expect(label.connectorLineSettings.width, 1.0);
//       expect(label.connectorLineSettings.color, null);
//       expect(label.labelIntersectAction, LabelIntersectAction.hide);
//       expect(label.color, null);
//     });

//     test('test datalabel rect', () {
//       final Rect labelRect = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
//       expect(labelRect.left.toInt(), 460);
//       expect(labelRect.top.toInt(), 119);
//       expect(labelRect.right.toInt(), 488);
//       expect(labelRect.bottom.toInt(), 135);
//     });

//     testWidgets(
//         'Accumulation Chart Widget - Testing Doughnut series with Datalabel Customization',
//         (WidgetTester tester) async {
//       final _DoughnutDataLAbel chartContainer =
//           _doughnutDataLAbel('datalabel_customization') as _DoughnutDataLAbel;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test datalabel properties', () {
//       final DataLabelSettings label = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._series.dataLabelSettings;
//       expect(label.borderColor.value, const Color(0xff000000).value);
//       expect(label.borderWidth, 2.0);
//       expect(label.connectorLineSettings.length, '10');
//       expect(label.connectorLineSettings.width, 1.0);
//       expect(label.connectorLineSettings.color!.value,
//           const Color(0xff000000).value);
//       expect(label.color!.value, const Color(0xfff44336).value);
//     });

//     const Rect labelRect = Rect.fromLTRB(515.1637914871717, 65.5655125197907,
//         595.1637914871717, 89.5655125197907);
//     test('test datalabel rect', () {
//       final Rect rect = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].labelRect;
//       expect(rect.left.toInt(), labelRect.left.toInt());
//       expect(rect.top.toInt(), labelRect.top.toInt());
//       expect(rect.right.toInt(), labelRect.right.toInt());
//       expect(rect.bottom.toInt(), labelRect.bottom.toInt());
//     });
//     testWidgets('Data label- isVisibleForZero property',
//         (WidgetTester tester) async {
//       final _DoughnutDataLAbel chartContainer =
//           _doughnutDataLAbel('doughnut_isVisibleForZero') as _DoughnutDataLAbel;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCircularChartState?;
//     });

//     test('test datalabel properties', () {
//       final DataLabelSettings label = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0]._series.dataLabelSettings;
//       expect(label.showZeroValue, false);
//     });
//   });
// }

// StatelessWidget _doughnutDataLAbel(String sampleName) {
//   return _DoughnutDataLAbel(sampleName);
// }

// // ignore: must_be_immutable
// class _DoughnutDataLAbel extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _DoughnutDataLAbel(String sampleName) {
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
