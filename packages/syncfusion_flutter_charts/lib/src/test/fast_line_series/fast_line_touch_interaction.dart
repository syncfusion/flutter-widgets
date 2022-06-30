// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_test/flutter_test.dart';
// import '../../../charts.dart';
// import 'fast_line_sample.dart';

// /// Test method of user interaction in the fast line series.
// void fastlineTouchInteraction() {
//   // Define a test. The TestWidgets function will also provide a WidgetTester
//   // for us to work with. The WidgetTester will allow us to build and interact
//   // with Widgets in the test environment.

//   // chart instance will get once pumpWidget is called
//   SfCartesianChart? chart;
//   // SfCartesianChartState? _chartState;

//   group('Fastline - Series,', () {
//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_tooltip')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip touch event', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     test('to test tooltip touch event', () {
//       final FastLineSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as FastLineSeriesRenderer;
//       final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint!;
//       chart!.tooltipBehavior.hide();
//       expect(value.x, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.y, 234.26666666666668);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_tooltip_double_tap')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip double tap touch event', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_tooltip_longpress')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test tooltip long press touch event', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_tooltip_template')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test tooltip template touch event', () {
//       final FastLineSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as FastLineSeriesRenderer;
//       final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint!;
//       expect(value.x, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.y, 234.26666666666668);
//       expect(chart!.tooltipBehavior.canShowMarker, true);
//       expect(chart!.tooltipBehavior.duration, 3000.0);
//     });

//     test('to test tooltip template', () {
//       final FastLineSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as FastLineSeriesRenderer;
//       final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint!;
//       chart!.crosshairBehavior.hide();
//       expect(value.x, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.y, 234.26666666666668);
//     });
//   });
//   group('Fastline - Series - Zooming', () {
//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_pinch_zoom')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
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
//       }

//       _chartState!._containerArea._performPointerUp(PointerUpEvent(
//           position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
//       _chartState!._containerArea._performPointerUp(PointerUpEvent(
//           position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test pinch zoom', () {
//       //   final FastLineSeries<_FastLineSample, String> cSeries = _chartState._chartSeries.visibleSeriesRenderers[0];
//       //   final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint;
//       //    double firstTouchXValue =value.x; final double firstTouchYValue = value.y;
//       // double secondTouchXValue = value.x + 50; final double secondTouchYValue =value.y + 50;

//       // _chartState._containerArea._performPointerDown(PointerDownEvent(position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
//       // _chartState._containerArea._performPointerDown(PointerDownEvent(position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
//       // for(int i =0; i<10;i++)
//       // {
//       //   firstTouchXValue -=1; secondTouchXValue +=1;
//       //   _chartState._containerArea._performPointerMove(PointerMoveEvent(position: Offset(firstTouchXValue,firstTouchYValue), pointer: 2));
//       //   _chartState._containerArea._performPointerMove(PointerMoveEvent(position: Offset(secondTouchXValue,secondTouchYValue), pointer: 3));
//       // }

//       // _chartState._containerArea._performPointerUp(PointerUpEvent(position: Offset(firstTouchXValue,firstTouchYValue), pointer: 2));
//       // _chartState._containerArea._performPointerUp(PointerUpEvent(position: Offset(secondTouchXValue,secondTouchYValue), pointer: 3));
//       // expect(value.x, 108.60000000000001);//const Offset(56.4,234.3));
//       // expect(value.y, 234.26666666666668);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_zoom')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       double firstTouchXValue = 50;
//       double firstTouchYValue = 250;

//       Timer? timer;

//       _chartState!._containerArea._performPanDown(DragDownDetails(
//           globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       for (int i = 0; i < 60; i++) {
//         firstTouchXValue += 4;
//         firstTouchYValue += 3;
//         _chartState!._containerArea._performLongPressMoveUpdate(
//             LongPressMoveUpdateDetails(
//                 globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//       }
//       _chartState!._containerArea._performLongPressEnd();

//       timer = Timer(const Duration(milliseconds: 2000), () {
//         _chartState!._containerArea._performPanDown(DragDownDetails(
//             globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//         for (int i = 0; i < 60; i++) {
//           firstTouchXValue += 4;
//           firstTouchYValue += 3;
//           _chartState!._containerArea._performLongPressMoveUpdate(
//               LongPressMoveUpdateDetails(
//                   globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
//         }
//         _chartState!._containerArea._performLongPressEnd();

//         if (timer != null) {
//           timer.cancel();
//         }
//       });
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection zoom', () {
// //                 double firstTouchXValue =50; double firstTouchYValue = 250;

// //       Timer timer;

// //       _chartState._containerArea._performPanDown(DragDownDetails(globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
// //       for(int i=0;i<60;i++)
// //       {
// //         firstTouchXValue +=4; firstTouchYValue +=3;
// //         _chartState._containerArea._performLongPressMoveUpdate(LongPressMoveUpdateDetails(globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
// //       }
// //         _chartState._containerArea._performLongPressEnd();

// //       timer = Timer(const Duration(milliseconds: 2000), () {
// //        _chartState._containerArea._performPanDown(DragDownDetails(globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
// //       for(int i=0;i<60;i++)
// //       {
// //         firstTouchXValue +=4; firstTouchYValue +=3;
// //         _chartState._containerArea._performLongPressMoveUpdate(LongPressMoveUpdateDetails(globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
// //       }
// //         _chartState._containerArea._performLongPressEnd();

// //          if (timer != null) {
// //             timer.cancel();
// //           }
// //  });
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_double_tap_zoom')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test double tap zoom', () {});
//   });

//   group('Fastline - Series,', () {
//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_trackball')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._containerArea._performPointerUp(
//           PointerUpEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test trackball touch up event', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });

//     test('to test trackball touch up event', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       chart!.trackballBehavior.hide();
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });
//   });

//   group('Fastline - Series,', () {
//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fast_line_crosshair')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState!._crosshairBehaviorRenderer.onTouchUp(value.dx, value.dy);
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test crosshair touch event', () {
//       // final FastLineSeries<_FastLineSample, String> cSeries = _chartState._chartSeries.visibleSeriesRenderers[0];
//       // final _ChartLocation value = cSeriesRenderer._dataPoints[0].markerPoint;
//       //chart._chartState._crosshairBehaviorRenderer.onTouchUp(value.x,value.y);
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//     });
//   });

//   group('Series - SELECTION', () {
//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_default_selection')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test default selection', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_mode_point')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection_mode_point', () {
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionType, SelectionType.point);
//       chart!.series[0].selectionBehavior!.selectDataPoints(1, 0);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_mode_cluster')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection_mode_cluster', () {
//       final FastLineSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as FastLineSeriesRenderer;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(chart!.selectionType, SelectionType.cluster);
//       cSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_customization')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//     });

//     test('to test selection_customization', () {
//       final FastLineSeriesRenderer cSeriesRenderer = _chartState!
//           ._chartSeries.visibleSeriesRenderers[0] as FastLineSeriesRenderer;
//       final FastLineSeries<dynamic, dynamic> cSeries =
//           cSeriesRenderer._series as FastLineSeries<dynamic, dynamic>;
//       expect(cSeriesRenderer._series.selectionBehavior.enable, true);
//       expect(cSeries.selectionBehavior.selectedColor, Colors.red);
//       expect(cSeries.selectionBehavior.unselectedColor, Colors.grey);
//       expect(cSeries.selectionBehavior.selectedBorderColor, Colors.blue);
//       expect(
//           cSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
//       expect(cSeries.selectionBehavior.selectedBorderWidth, 2);
//       expect(cSeries.selectionBehavior.unselectedBorderWidth, 0);
//       expect(chart!.selectionGesture, ActivationMode.singleTap);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_double_tap')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performDoubleTap();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection_double_tap', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.doubleTap);
//     });

//     testWidgets('fastline  series sample', (WidgetTester tester) async {
//       final _FastlinerUIInteraction chartContainer =
//           _fastlinerUIInteraction('fastline_selection_long_press')
//               as _FastlinerUIInteraction;
//       await tester.pumpWidget(chartContainer);
//       chart = chartContainer.chart;
//       final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
//       _chartState = key.currentState as SfCartesianChartState?;
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       _chartState?._containerArea._performPointerDown(
//           PointerDownEvent(position: Offset(value.dx, value.dy)));
//       _chartState!._containerArea._performLongPress();
//       await tester.pump(const Duration(seconds: 3));
//     });

//     test('to test selection_long_press', () {
//       final Offset value = _getTouchPosition(
//           _chartState!._chartSeries.visibleSeriesRenderers[0])!;
//       expect(value.dx, 108.60000000000001); //const Offset(56.4,234.3));
//       expect(value.dy, 234.26666666666668);
//       expect(chart!.series[0].selectionBehavior!.enable, true);
//       expect(chart!.selectionGesture, ActivationMode.longPress);
//     });
//   });
// }

// StatelessWidget _fastlinerUIInteraction(String sampleName) {
//   return _FastlinerUIInteraction(sampleName);
// }

// // ignore: must_be_immutable
// class _FastlinerUIInteraction extends StatelessWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _FastlinerUIInteraction(String sampleName) {
//     chart = _getFastLinechart(sampleName);
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
