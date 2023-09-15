// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import '../helper.dart';
// import 'column_sample.dart';

// /// Test method of user interaction in the column series.
// void chartTouchInteration() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   SfCartesianChartState? _chartState;

//   group('Column - Series', () {
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_tooltip')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('tooltip_opposed_position')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 22.380000000000006); //const Offset(56.4,234.3));
//       expect(value.dy, 256.26666666666665);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_tooltip_template')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip template touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.tooltipBehavior.canShowMarker, true);
//       expect(chart!.tooltipBehavior.duration, 3000.0);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_tooltip_double_tap')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       _chartState!._renderingDetails.tooltipBehaviorRenderer
//           .onTouchDown(value.dx, value.dy);
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip double tap event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_tooltip_long_press')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip long press', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });
//   });

//   group('Column - Series,', () {
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_trackball')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction(
//                   'column_series_trackball_dash_array_vertical')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball dash array in vertical line type', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction(
//                   'trackball_dash_array_isTransposed_vertical')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball dash array in vertical line type', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 82.0); //const Offset(56.4,234.3));
//       expect(value.dy, 416.66);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.isTransposed, true);
//       expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_trackball_dash_array')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball dash array in vertical line type', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('trackball_dash_array_isTransposed')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball dash array in vertical line type', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 82.0); //const Offset(56.4,234.3));
//       expect(value.dy, 416.66);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.isTransposed, true);
//       expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_trackball_opposed')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball opposed axis', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 22.380000000000006); //const Offset(56.4,234.3));
//       expect(value.dy, 256.26666666666665);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.primaryXAxis.opposedPosition, true);
//       expect(chart!.primaryYAxis.opposedPosition, true);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('trackball_display_mode')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball display mode', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.trackballBehavior.tooltipDisplayMode,
//           TrackballDisplayMode.groupAllPoints);
//       expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.center);
//     });
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('trackball_tooltip_align_near')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball tooltip alignment near', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.trackballBehavior.tooltipDisplayMode,
//           TrackballDisplayMode.groupAllPoints);
//       expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
//     });
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('trackball_tooltip_align_far')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball tooltip alignment far', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.trackballBehavior.enable, true);
//       expect(chart!.trackballBehavior.tooltipDisplayMode,
//           TrackballDisplayMode.groupAllPoints);
//       expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_trackball_double_tap')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball double tap event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_trackball_long_press')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;

//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       num xValue = 56.38000000000001;
//       const num yValue = 234.26666666666668;
//       double cSegmentValue = value.dx;
//       _chartState!._trackballBehaviorRenderer._trackballPainter!.canResetPath =
//           false;
//       for (int i = 0; i < 15; i++) {
//         xValue += 10;
//         cSegmentValue += 10;
//         //chart._chartState._trackballBehaviorRenderer.onTouchMove(cSegmentValue,value.dy);
//         _chartState!._containerArea._performLongPressMoveUpdate(
//             LongPressMoveUpdateDetails(
//                 globalPosition: Offset(cSegmentValue, value.dy)));
//         expect(cSegmentValue, xValue);
//         expect(value.dy, yValue);
//       }
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(cSegmentValue, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });
//     test('to test trackball long press event', () {});
//   });

//   group('Column - Series,', () {
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_crosshair')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_crosshair_renderer')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction(
//                   'column_series_crosshair_track_line_vertical')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test crosshair trackline vertical', () {});

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_crosshair_double_tap')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test crosshair double tap', () {});

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_crosshair_long_press')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       num xValue = 56.38000000000001;
//       const num yValue = 234.26666666666668;
//       double cSegmentValue = value.dx;
//       for (int i = 0; i < 15; i++) {
//         xValue += 10;
//         cSegmentValue += 10;
//         _chartState!._containerArea._performLongPressMoveUpdate(
//             LongPressMoveUpdateDetails(
//                 globalPosition: Offset(cSegmentValue, value.dy)));
//         expect(cSegmentValue, xValue);
//         expect(value.dy, yValue);
//       }
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(xValue as double, yValue as double)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test crosshair long press', () {});

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction(
//                   'column_series_crosshair_track_line_horizontal')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test crosshair track line horizontal', () {});
//   });

//   //---------- SELECTION

//   group('Column - Series - SELECTION', () {
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_default_selection')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_initial_selection')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_multi_selection')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });
//     // late List<int?> selectedPoints;
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_selection')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       // ignore: must_be_immutable
//       final ColumnSegment cSegment =
//           cSeriesRenderer._segments[0] as ColumnSegment;
//       // ignore: must_be_immutable
//       final Offset value = Offset(
//           (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
//           (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       // selectedPoints = chart!.series[0].selectionBehavior!
//       //     .getSelectedDataPoints(
//       //         chart!.series[0] as CartesianSeries<dynamic, dynamic>);
//       await tester.pump(const Duration(seconds: 3));
//     });

//     // test('to test user interaction selection', () {
//     //   expect(selectedPoints[0], 0);
//     // });
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_mode_point')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection touch event', () {
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(chart!.selectionType, SelectionType.point);
//       cSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_mode_point')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection touch event', () {
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(chart!.selectionType, SelectionType.point);
//       cSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_mode_series')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection touch event', () {
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(chart!.selectionType, SelectionType.series);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_mode_cluster')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection touch event', () {
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(chart!.selectionType, SelectionType.cluster);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_customization')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test customized selection touch event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.series[0].selectionBehavior!.selectedColor, Colors.red);
//       expect(chart!.series[0].selectionBehavior!.unselectedColor, Colors.grey);
//       expect(
//           chart!.series[0].selectionBehavior!.selectedBorderColor, Colors.blue);
//       expect(chart!.series[0].selectionBehavior!.unselectedBorderColor,
//           Colors.lightGreen);
//       expect(chart!.series[0].selectionBehavior!.selectedBorderWidth, 2);
//       expect(chart!.series[0].selectionBehavior!.unselectedBorderWidth, 0);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_double_tap')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection in double tap event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.doubleTap);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_long_press')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection in long press event', () {
//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.longPress);
//     });
//   });

//   //-------------------ZOOMING

//   group('Column - Series,', () {
//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_pinch_Zoom')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;

//       final Offset value = getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       double firstTouchXValue = value.dx;
//       final double firstTouchYValue = value.dy;
//       double secondTouchXValue = value.dx + 50;
//       final double secondTouchYValue = value.dy + 50;

//       _chartState!._containerArea._performPointerDown(PointerDownEvent(
//           position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
//       _chartState!._containerArea._performPointerDown(PointerDownEvent(
//           position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
//       for (int i = 0; i < 10; i++) {
//         firstTouchXValue -= 1;
//         secondTouchXValue += 1;
//         _chartState!._containerArea._performPointerMove(PointerMoveEvent(
//             position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
//         _chartState!._containerArea._performPointerMove(PointerMoveEvent(
//             position: Offset(secondTouchXValue, secondTouchYValue),
//             pointer: 3));
//         await tester.pump(const Duration(seconds: 3));
//       }

//       _chartState!._containerArea._performPointerUp(PointerUpEvent(
//           position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
//       _chartState!._containerArea._performPointerUp(PointerUpEvent(
//           position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
//       // await tester.pump(const Duration(seconds:3));
//     });

//     test('to test pinch zoom touch event', () {});

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_selection_Zoom')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       double firstTouchXValue = 50;
//       double firstTouchYValue = 250;
//       _chartState!._containerArea._performPanDown(DragDownDetails(
//           globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       for (int i = 0; i < 40; i++) {
//         firstTouchXValue += 4;
//         firstTouchYValue += 3;
//         _chartState!._containerArea._performLongPressMoveUpdate(
//             LongPressMoveUpdateDetails(
//                 globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//         await tester.pump(const Duration(seconds: 3));
//       }
//       _chartState!._containerArea._performLongPressEnd();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection zoom touch event', () {
//       _chartState!.didUpdateWidget(chart!);
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('selection_zoom_axis_opposed')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       double firstTouchXValue = 50;
//       double firstTouchYValue = 250;
//       _chartState!._containerArea._performPanDown(DragDownDetails(
//           globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       for (int i = 0; i < 40; i++) {
//         firstTouchXValue += 4;
//         firstTouchYValue += 3;
//         _chartState!._containerArea._performLongPressMoveUpdate(
//             LongPressMoveUpdateDetails(
//                 globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       }
//       await tester.pump(const Duration(seconds: 3));
//       _chartState!._containerArea._performLongPressEnd();
//     });

//     test('to test selection zoom touch event', () {});

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('column_series_double_tap_Zoom')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       final ColumnSegment cSegment =
//           cSeriesRenderer._segments[0] as ColumnSegment;
//       final Offset value = cSegment.segmentRect.middleRect.topLeft;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test double tap zoom touch event', () {
//       chart!.zoomPanBehavior.panToDirection('top');
//       chart!.zoomPanBehavior.panToDirection('bottom');
//       chart!.zoomPanBehavior.panToDirection('right');
//       chart!.zoomPanBehavior.panToDirection('left');
//     });

//     testWidgets('column series sample', (WidgetTester tester) async {
//       final _CartesianTouchInteraction chartContainer =
//           _cartesianTouchInteraction('double_tap_Zoom_with_pan')
//               as _CartesianTouchInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final ColumnSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
//       final ColumnSegment cSegment =
//           cSeriesRenderer._segments[0] as ColumnSegment;
//       final Offset value = cSegment.segmentRect.middleRect.topLeft;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       // chart._chartState._containerArea._performPointerUp(PointerUpEvent(position:Offset(value.dx,value.dy)));
//       _chartState!._zoomPanBehaviorRenderer._isPinching = false;
//       _chartState!._containerArea._performPanDown(
//           DragDownDetails(globalPosition: Offset(value.dx, value.dy)));
//       double firstTouchXValue = value.dx;
//       for (int i = 0; i < 10; i++) {
//         firstTouchXValue += 10;
//         _chartState!._containerArea._performPanUpdate(DragUpdateDetails(
//             globalPosition: Offset(firstTouchXValue, value.dy)));
//       }
//       _chartState!._containerArea._performPanEnd(DragEndDetails());
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test double tap zoom touch event', () {});
//   });
// }

// StatelessWidget _cartesianTouchInteraction(String sampleName) {
//   return _CartesianTouchInteraction(sampleName);
// }

// // ignore: must_be_immutable
// class _CartesianTouchInteraction extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _CartesianTouchInteraction(String sampleName) {
//     chart = _getColumnchart(sampleName);
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
