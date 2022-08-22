// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'funnel_sample';

// /// Test method of user interaction in the funnel series.
// void funnelTouchInteration() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called

//   group('funnel- explode', () {
//     // testWidgets('funnel series sample', (WidgetTester tester) async {
//     //   final _FunnelTouchInteraction chartContainer =
//     //       _funnelTouchInteraction('funnel_explode_singletap');
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart.key;
//     //   _chartState = key.currentState;
//     //   // ignore: prefer_const_constructors_in_immutables
//     //   _chartState._funnelplotArea
//     //       ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test explode on single tap', () {
//     //   expect(189, 189);
//     //   expect(192, 192);
//     // });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_notpoint') as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 450)));
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode in not point', () {
//       expect(189, 189);
//       expect(319, 319);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_exploded') as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._renderingDetails.explodedPoints = <int>[2];
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._renderingDetails.legendToggleStates =
//           <_LegendRenderContext>[
//         _LegendRenderContext(
//             size: null,
//             text: '',
//             textSize: null,
//             iconColor: null,
//             iconType: LegendIconType.circle,
//             point: null,
//             isSelect: false,
//             seriesIndex: 0,
//             seriesRenderer: null)
//       ];
//       _chartState!._chartSeries._processDataPoints(
//           _chartState!._chartSeries.visibleSeriesRenderers[0]);
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea._onDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode on double tap', () {
//       expect(189, 189);
//       expect(_chartState!._renderingDetails.explodedPoints.isNotEmpty, true);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_explode_doubletap')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea._onDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode on double tap', () {
//       expect(189, 189);
//       expect(192, 192);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_explode_longpress')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea._onLongPress();
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode on longpress', () {
//       expect(189, 189);
//       expect(192, 192);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_explode_tapup')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea
//           ._onTapUp(const PointerUpEvent(position: Offset(189, 192)));
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode on tapUp', () {
//       expect(189, 189);
//       expect(192, 192);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_explode_tapup_build')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea
//           ._onTapUp(const PointerUpEvent(position: Offset(189, 192)));
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test explode on tapUp without build', () {
//       expect(189, 189);
//       expect(192, 192);
//     });
//   });
//   group('funnel - Selection', () {
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_selection')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('test selection event in single tap', () {
//       expect(chart!.series.selectionBehavior.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });
//     testWidgets('funnel series sample', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_selectedData')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._funnelplotArea._onDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('test selection event in selected data', () {
//       expect(chart!.series.selectionBehavior.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.doubleTap);
//     });
//     testWidgets('funnel series with selection', (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('selection_event') as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       // ignore: prefer_const_constructors_in_immutables
//       _chartState!._funnelplotArea
//           ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
//       _chartState!._renderingDetails.legendToggleTemplateStates =
//           <_MeasureWidgetContext>[
//         _MeasureWidgetContext(
//             context: _chartState!.context,
//             widget: chart,
//             seriesIndex: 0,
//             pointIndex: 0)
//       ];
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('test on selection changed event', () {
//       expect(chart!.series.selectionBehavior.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//       expect(
//           _chartState!._renderingDetails.legendToggleTemplateStates.isNotEmpty,
//           true);
//     });
//     testWidgets('funnel series with legend builder',
//         (WidgetTester tester) async {
//       final _FunnelTouchInteraction chartContainer =
//           _funnelTouchInteraction('funnel_legendtoggle')
//               as _FunnelTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfFunnelChartState?;
//       _chartState!._renderingDetails.legendToggleTemplateStates =
//           <_MeasureWidgetContext>[
//         _MeasureWidgetContext(
//             context: _chartState!.context,
//             widget: chart,
//             seriesIndex: 0,
//             pointIndex: 0)
//       ];
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('test on legend_togglestates', () {
//       expect(
//           _chartState!._renderingDetails.legendToggleTemplateStates.isNotEmpty,
//           true);
//     });
//   });
// }

// StatelessWidget _funnelTouchInteraction(String sampleName) {
//   return _FunnelTouchInteraction(sampleName);
// }

// // ignore: must_be_immutable
// class _FunnelTouchInteraction extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _FunnelTouchInteraction(String sampleName) {
//     chart = _getFunnelSample(sampleName);
//   }
//   SfFunnelChart? chart;
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
