// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'user_interaction.dart';

// /// Test method of selection
// void selectionRenderer() {
//   SfCartesianChart? chart;
//   // SfCartesianChartState? _chartState;

//   group('Column Selection', () {
//     testWidgets('point mode', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('column_with_customization')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       // _chartState = key.currentState as SfCartesianChartState?;
//       // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//       //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       // ColumnSegment cSegment = cSeriesRenderer._segments[0] as ColumnSegment;
//       // Offset value = Offset(
//       //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
//       //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
//       // _chartState?._containerArea._performPointerDown(
//       //     PointerDownEvent(position: Offset(value.dx, value.dy)));
//       // //
//       // cSegment = cSeriesRenderer._segments[3] as ColumnSegment;
//       // value = Offset(
//       //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
//       //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
//       // _chartState?._containerArea._performPointerDown(
//       //     PointerDownEvent(position: Offset(value.dx, value.dy)));
//     });

//     test('to test selection mode', () {
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//       expect(chart!.selectionType, SelectionType.point);
//     });
//     // test('to test selected and unseleted segments length', () {
//     //   // expect(_chartState!._selectedSegments.length, 2);
//     //   expect(_chartState!._unselectedSegments.length, 4);
//     // });
//     // test('to test selected and unselected segment colors', () {
//     //   final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//     //   // expect(cSeriesRenderer.segments[0].fillPaint.color, const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0xff9e9e9e));
//     //   expect(cSeriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0xff9e9e9e));
//     //   expect(cSeriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[4].fillPaint!.color,
//     //       const Color(0xff9e9e9e));
//     //   expect(chart!.selectionType, SelectionType.point);
//     // });

//     testWidgets('series mode', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('column_series_selection')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       // _chartState = key.currentState as SfCartesianChartState?;
//       // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//       //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       // final ColumnSegment cSegment =
//       //     cSeriesRenderer._segments[0] as ColumnSegment;
//       // final Offset value = Offset(
//       //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
//       //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
//       // _chartState?._containerArea._performPointerDown(
//       //     PointerDownEvent(position: Offset(value.dx, value.dy)));
//     });

//     test('to test selection mode', () {
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//       expect(chart!.selectionType, SelectionType.series);
//     });

//     // test('to test selected and unseleted segments length', () {
//     //   ColumnSeriesRenderer cSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//     //   expect(_chartState!._selectedSegments.length,
//     //       cSeriesRenderer._segments.length);
//     //   cSeriesRenderer = _chartState!._chartSeries.visibleSeriesRenderers[1]
//     //       as ColumnSeriesRenderer;
//     //   expect(_chartState!._unselectedSegments.length,
//     //       cSeriesRenderer._segments.length);
//     // });

//     // test('to test selected series color', () {
//     //   final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//     //   expect(cSeriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(cSeriesRenderer._segments[4].fillPaint!.color,
//     //       const Color(0xfff44336));
//     // });
//     // test('to test unselected series color', () {
//     //   final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as ColumnSeriesRenderer;
//     //   expect(cSeriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(cSeriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(cSeriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(cSeriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(cSeriesRenderer._segments[4].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     // });
//   });

//   // group('Bar Selection', () {
//   //   testWidgets('bar series', (WidgetTester tester) async {
//   //     final _CartesianSelectionSample chartContainer =
//   //         _cartesianSelectionSample('bar_with_multiselect')
//   //             as _CartesianSelectionSample;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //     final BarSeriesRenderer barSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
//   //     BarSegment barSegment = barSeriesRenderer._segments[0] as BarSegment;
//   //     Offset value = Offset(
//   //         (barSegment.segmentRect.left + barSegment.segmentRect.right) / 2,
//   //         barSegment.segmentRect.bottom);
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: Offset(value.dx, value.dy)));
//   //     await tester.pump(const Duration(seconds: 3));

//   //     barSegment = barSeriesRenderer._segments[2] as BarSegment;
//   //     value = Offset(
//   //         (barSegment.segmentRect.left + barSegment.segmentRect.right) / 2,
//   //         barSegment.segmentRect.bottom);
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: Offset(value.dx, value.dy)));
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: Offset(value.dx, value.dy)));
//   //     await tester.pump(const Duration(seconds: 3));
//   //   });

//   //   test('to test selection mode', () {
//   //     final BarSeriesRenderer barSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
//   //     for (int i = 0; i < barSeriesRenderer._segments.length; i++) {
//   //       expect(chart!.selectionGesture, ActivationMode.singleTap);
//   //     }
//   //   });

//   //   // test('to test selected and unselected segment colors', () {
//   //   //   final BarSeriesRenderer barSeriesRenderer = _chartState._chartSeries.visibleSeriesRenderers[0];
//   //   //   expect(barSeriesRenderer.segments[0].fillPaint.color.value, 2157878942);
//   //   //   expect(barSeriesRenderer.segments[1].fillPaint.color.value, 2157878942);
//   //   //   expect(barSeriesRenderer.segments[2].fillPaint.color.value, 2157878942);
//   //   //   expect(barSeriesRenderer.segments[3].fillPaint.color.value, 2157878942);
//   //   //   expect(barSeriesRenderer.segments[4].fillPaint.color.value, 2157878942);
//   //   //   expect(chart.selectionType, SelectionType.point);
//   //   // });

//   //   testWidgets('bar series', (WidgetTester tester) async {
//   //     final _CartesianSelectionSample chartContainer =
//   //         _cartesianSelectionSample('bar_with_multiselect')
//   //             as _CartesianSelectionSample;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //     BarSeriesRenderer barSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(3, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//   //     final _CartesianSelectionSample chartContainer2 =
//   //         _cartesianSelectionSample('bar_with_multiselect')
//   //             as _CartesianSelectionSample;
//   //     await tester.pumpWidget(chartContainer2);
//   //     chart = chartContainer2.chart;
//   //     barSeriesRenderer = _chartState!._chartSeries.visibleSeriesRenderers[0]
//   //         as BarSeriesRenderer;
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(2, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(4, 0);
//   //     barSeriesRenderer._series.selectionBehavior.selectDataPoints(2, 0);
//   //     await tester.pump(const Duration(seconds: 3));
//   //   });
//   //   test('to test selected segment length', () {
//   //     expect(_chartState!._selectedSegments.length, 4);
//   //   });
//   //   test('to test selected and unselected segment colors', () {
//   //     final BarSeriesRenderer barSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
//   //     expect(barSeriesRenderer._segments[0].fillPaint!.color,
//   //         const Color(0xfff44336));
//   //     expect(barSeriesRenderer._segments[1].fillPaint!.color,
//   //         const Color(0xfff44336));
//   //     expect(barSeriesRenderer._segments[2].fillPaint!.color,
//   //         const Color(0x809e9e9e));
//   //     expect(barSeriesRenderer._segments[3].fillPaint!.color,
//   //         const Color(0xfff44336));
//   //     expect(barSeriesRenderer._segments[4].fillPaint!.color,
//   //         const Color(0xfff44336));
//   //   });
//   // });

//   group('Multi Selection - Series Type', () {
//     testWidgets('line series - single selection', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('line_with_multiselect')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       // _chartState = key.currentState as SfCartesianChartState?;
//       // final RenderBox renderBox =
//       //     _chartState!.context.findRenderObject() as RenderBox;
//       // final LineSeriesRenderer lineSeriesRenderer = _chartState!
//       //     ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//       // final LineSegment lineSegment =
//       //     lineSeriesRenderer._segments[2] as LineSegment;
//       // final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//       // _chartState?._containerArea._performPointerDown(
//       //     PointerDownEvent(position: renderBox.localToGlobal(value)));
//       await tester.pump(const Duration(seconds: 3));
//     });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 4);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xfff44336));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0x809e9e9e));
//     //   }
//     // });

//     // testWidgets('line series - single unselect', (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_multiselect')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 0);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xffc06c84));
//     //   }
//     // });

//     // testWidgets('line series - multiple selection',
//     //     (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_multiselect')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSeriesRenderer lineSeriesRenderer1 = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final LineSegment lineSegment1 =
//     //       lineSeriesRenderer1._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   final Offset value1 = Offset(lineSegment1._x1, lineSegment1._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 8);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xfff44336));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xfff44336));
//     //   }
//     // });

//     // testWidgets('line series - multiselect - single unselect',
//     //     (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_multiselect')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSeriesRenderer lineSeriesRenderer1 = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final LineSegment lineSegment1 =
//     //       lineSeriesRenderer1._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   final Offset value1 = Offset(lineSegment1._x1, lineSegment1._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 4);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0x809e9e9e));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xfff44336));
//     //   }
//     // });

//     // testWidgets('line series - multiple unselect', (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_multiselect')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSeriesRenderer lineSeriesRenderer1 = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final LineSegment lineSegment1 =
//     //       lineSeriesRenderer1._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   final Offset value1 = Offset(lineSegment1._x1, lineSegment1._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 0);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xffc06c84));
//     //   }
//     // });
//   });

//   // group('Multi Selection - Cluster Type', () {
//   //   testWidgets('line series - single selection', (WidgetTester tester) async {
//   //     final _CartesianSelectionSample chartContainer =
//   //         _cartesianSelectionSample('line_with_clustermode')
//   //             as _CartesianSelectionSample;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //     final RenderBox renderBox =
//   //         _chartState!.context.findRenderObject() as RenderBox;
//   //     final LineSeriesRenderer lineSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//   //     final LineSegment lineSegment =
//   //         lineSeriesRenderer._segments[2] as LineSegment;
//   //     final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: renderBox.localToGlobal(value)));
//   //     await tester.pump(const Duration(seconds: 3));
//   //   });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 2);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     // });

//     // testWidgets('line series - single unselect', (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_clustermode')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 0);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//     //   }
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   for (final ChartSegment segment in seriesRenderer._segments) {
//     //     expect(segment.fillPaint!.color, const Color(0xffc06c84));
//     //   }
//     // });

//     // testWidgets('line series - multiple selection',
//     //     (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_clustermode')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[0] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   final LineSegment lineSegment1 =
//     //       lineSeriesRenderer._segments[3] as LineSegment;
//     //   final Offset value1 = Offset(lineSegment1._x2, lineSegment1._y2);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 4);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0xfff44336));
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0xfff44336));
//     // });

//     // testWidgets('line series - multiselect - single unselect',
//     //     (WidgetTester tester) async {
//     //   final _CartesianSelectionSample chartContainer =
//     //       _cartesianSelectionSample('line_with_clustermode')
//     //           as _CartesianSelectionSample;
//     //   await tester.pumpWidget(chartContainer);
//     //   chart = chartContainer.chart;
//     //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//     //   _chartState = key.currentState as SfCartesianChartState?;
//     //   final RenderBox renderBox =
//     //       _chartState!.context.findRenderObject() as RenderBox;
//     //   final LineSeriesRenderer lineSeriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   final LineSegment lineSegment =
//     //       lineSeriesRenderer._segments[2] as LineSegment;
//     //   final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//     //   final LineSegment lineSegment1 =
//     //       lineSeriesRenderer._segments[0] as LineSegment;
//     //   final Offset value1 = Offset(lineSegment1._x1, lineSegment1._y1);
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value1)));
//     //   _chartState?._containerArea._performPointerDown(
//     //       PointerDownEvent(position: renderBox.localToGlobal(value)));
//     //   await tester.pump(const Duration(seconds: 3));
//     // });
//     // test('to test selected segments length', () {
//     //   expect(_chartState!._selectedSegments.length, 2);
//     // });
//     // test('to test Series 0 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     // });
//     // test('to test Series 1 segment colors', () {
//     //   final LineSeriesRenderer seriesRenderer = _chartState!
//     //       ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//     //   expect(seriesRenderer._segments[0].fillPaint!.color,
//     //       const Color(0xfff44336));
//     //   expect(seriesRenderer._segments[1].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[2].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     //   expect(seriesRenderer._segments[3].fillPaint!.color,
//     //       const Color(0x809e9e9e));
//     // });

//   //   testWidgets('line series - multiple unselect', (WidgetTester tester) async {
//   //     final _CartesianSelectionSample chartContainer =
//   //         _cartesianSelectionSample('line_with_clustermode')
//   //             as _CartesianSelectionSample;
//   //     await tester.pumpWidget(chartContainer);
//   //     chart = chartContainer.chart;
//   //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//   //     _chartState = key.currentState as SfCartesianChartState?;
//   //     final RenderBox renderBox =
//   //         _chartState!.context.findRenderObject() as RenderBox;
//   //     final LineSeriesRenderer lineSeriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//   //     final LineSegment lineSegment =
//   //         lineSeriesRenderer._segments[2] as LineSegment;
//   //     final Offset value = Offset(lineSegment._x1, lineSegment._y1);
//   //     final LineSegment lineSegment1 =
//   //         lineSeriesRenderer._segments[0] as LineSegment;
//   //     final Offset value1 = Offset(lineSegment1._x1, lineSegment1._y1);
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: renderBox.localToGlobal(value)));
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: renderBox.localToGlobal(value1)));
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: renderBox.localToGlobal(value)));
//   //     _chartState?._containerArea._performPointerDown(
//   //         PointerDownEvent(position: renderBox.localToGlobal(value1)));
//   //     await tester.pump(const Duration(seconds: 3));
//   //   });
//   //   test('to test selected segments length', () {
//   //     expect(_chartState!._selectedSegments.length, 0);
//   //   });
//   //   test('to test Series 0 segment colors', () {
//   //     final LineSeriesRenderer seriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
//   //     for (final ChartSegment segment in seriesRenderer._segments) {
//   //       expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//   //     }
//   //   });
//   //   test('to test Series 1 segment colors', () {
//   //     final LineSeriesRenderer seriesRenderer = _chartState!
//   //         ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
//   //     for (final ChartSegment segment in seriesRenderer._segments) {
//   //       expect(segment.fillPaint!.color, const Color(0xffc06c84));
//   //     }
//   //   });
//   // });

//   group('Area - Selection', () {
//     testWidgets('area series - single select', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('area_selection')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final AreaSeriesRenderer areaSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 1);
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test selected segments length', () {
//       expect(_chartState!._selectedSegments.length, 1);
//     });
//     test('to test selected series 0 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0x809e9e9e));
//     });
//     test('to test selected series 1 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xfff44336));
//     });

//     testWidgets('area series - single unselect', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('area_selection')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final AreaSeriesRenderer areaSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 1);
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 1);
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test selected segments length', () {
//       expect(_chartState!._selectedSegments.length, 0);
//     });
//     test('to test selected series 0 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//     });
//     test('to test selected series 1 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xffc06c84));
//     });

//     testWidgets('area series - multi selection', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('area_multiselect')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final AreaSeriesRenderer areaSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 0);
//       final AreaSeriesRenderer areaSeries1Renderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       areaSeries1Renderer._series.selectionBehavior.selectDataPoints(0, 1);
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test selected segments length', () {
//       expect(_chartState!._selectedSegments.length, 2);
//     });
//     test('to test selected series 0 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xfff44336));
//     });
//     test('to test selected series 1 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xfff44336));
//     });

//     testWidgets('area series - multi selection', (WidgetTester tester) async {
//       final _CartesianSelectionSample chartContainer =
//           _cartesianSelectionSample('area_multiselect')
//               as _CartesianSelectionSample;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final AreaSeriesRenderer areaSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       final AreaSeriesRenderer areaSeriesRenderer1 = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 0);
//       areaSeriesRenderer1._series.selectionBehavior.selectDataPoints(0, 1);
//       areaSeriesRenderer._series.selectionBehavior.selectDataPoints(0, 0);
//       areaSeriesRenderer1._series.selectionBehavior.selectDataPoints(0, 1);
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test selected segments length', () {
//       expect(_chartState!._selectedSegments.length, 0);
//     });
//     test('to test selected series 0 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xff4b87b9));
//     });
//     test('to test selected series 1 color', () {
//       final AreaSeriesRenderer seriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[1] as AreaSeriesRenderer;
//       final AreaSegment segment = seriesRenderer._segments[0] as AreaSegment;
//       expect(segment.fillPaint!.color, const Color(0xffc06c84));
//     });
//   });
// }

// StatelessWidget _cartesianSelectionSample(String sampleName) {
//   return _CartesianSelectionSample(sampleName);
// }

// // ignore: must_be_immutable
// class _CartesianSelectionSample extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _CartesianSelectionSample(String sampleName) {
//     chart = _getUserInteractionChart(sampleName);
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
//             margin: EdgeInsets.zero,
//             child: chart,
//           ))),
//     );
//   }
// }
