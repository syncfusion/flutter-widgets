// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import '../../../charts.dart';
// import 'events_sample.dart';

// /// Test method of the circular chart events.
// void circularEvents() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   // SfCircularChartState? _chartState;

//   // group('Circular Events -', () {
//   //   testWidgets('DataLabel and Legend item render cartesian events',
//   //       (WidgetTester tester) async {
//   //     final _CircularEvents chartContainer =
//   //         _circularEvents('circular_DataLabel_Legend') as _CircularEvents;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     // _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('to test data label', () {
//   //     final CircularSeriesRenderer circularSeriesRenderer =
//   //         _chartState!._chartSeries.visibleSeriesRenderers[0];
//   //     expect(circularSeriesRenderer._dataPoints[0].dataLabelPosition,
//   //         Position.right);
//   //   });
//   //   test('to test shape', () {
//   //     expect(
//   //         _chartState!
//   //             ._chartSeries.visibleSeriesRenderers[0]._series.legendIconType,
//   //         LegendIconType.seriesType);
//   //   });
//   //   testWidgets('DataLabel events in cicular charts',
//   //       (WidgetTester tester) async {
//   //     final _CircularEvents chartContainer =
//   //         _circularEvents('circular_Empty_DataLabel') as _CircularEvents;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCircularChartState?;
//   //   });

//   //   test('to test data label with empty string', () {
//   //     final DataLabelSettings label = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0]._series.dataLabelSettings;
//   //     expect(label.showZeroValue, true);
//   //   });
//   // });
// }

// StatelessWidget _circularEvents(String sampleName) {
//   return _CircularEvents(sampleName);
// }

// // ignore: must_be_immutable
// class _CircularEvents extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _CircularEvents(String sampleName) {
//     chart = getCircularChartSample(sampleName);
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
