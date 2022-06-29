import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pie_sample.dart';

/// Test method of user interaction in the pie chart.
void pieTouchInteraction() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Pie - Selection', () {
    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_default') as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection default', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_onpoint_tapped')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection default', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_singletap_customization')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea
      //     ._onTapUp(PointerUpEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection singletap customization', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_event') as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection event in single tap', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.singleTap);
    });
    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_double_tap') as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._renderingDetails.selectionData.add(0);
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection event in double tap', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.doubleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with multi selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_double_tap_multiselection')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //  final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._renderingDetails.selectionData.add(0);
      // _chartState!._renderingDetails.selectionData.add(1);
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection event in double tap', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.doubleTap);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_long_press') as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onLongPress();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection event in long press', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.longPress);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_customization')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection customization', () {
      final PieSeries<PieSample, String?> pSeries =
          chart!.series[0] as PieSeries<PieSample, String?>;
      expect(pSeries.selectionBehavior.enable, true);
      expect(pSeries.selectionBehavior.selectedColor, Colors.red);
      expect(pSeries.selectionBehavior.unselectedColor, Colors.grey);
      expect(pSeries.selectionBehavior.selectedBorderColor, Colors.blue);
      expect(
          pSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
      expect(pSeries.selectionBehavior.selectedBorderWidth, 2);
      expect(pSeries.selectionBehavior.unselectedBorderWidth, 0);
      expect(pSeries.selectionBehavior.selectedOpacity, 0.5);
      expect(pSeries.selectionBehavior.unselectedOpacity, 1);
    });

    testWidgets('Accumulation Chart Widget - Testing Pie series with selection',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('selection_customization_update')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection customization update', () {
      final PieSeries<PieSample, String?> pSeries =
          chart!.series[0] as PieSeries<PieSample, String?>;
      expect(pSeries.selectionBehavior.enable, true);
      expect(pSeries.selectionBehavior.selectedColor, Colors.red);
      expect(pSeries.selectionBehavior.unselectedColor, Colors.grey);
      expect(pSeries.selectionBehavior.selectedBorderColor, Colors.blue);
      expect(
          pSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
      expect(pSeries.selectionBehavior.selectedBorderWidth, 2);
      expect(pSeries.selectionBehavior.unselectedBorderWidth, 0);
      expect(pSeries.selectionBehavior.selectedOpacity, 0.5);
      expect(pSeries.selectionBehavior.unselectedOpacity, 1);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with annotation',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('circular_annotation') as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test circular annotation', () {
      final CircularChartAnnotation cirAnnotation = chart!.annotations![0];
      expect(cirAnnotation.angle, 270);
      expect(cirAnnotation.radius, '55%');
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with annotation',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('circular_annotation_horizontal')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test circular annotation horizontal alignment', () {
      final CircularChartAnnotation cirAnnotation = chart!.annotations![0];
      expect(cirAnnotation.angle, 270);
      expect(cirAnnotation.radius, '55%');
      expect(
        cirAnnotation.horizontalAlignment,
        ChartAlignment.near,
      );
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with annotation',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('circular_annotation_vertical')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test circular annotation vertical alignment', () {
      final CircularChartAnnotation cirAnnotation = chart!.annotations![0];
      expect(cirAnnotation.angle, 270);
      expect(cirAnnotation.radius, '55%');
      expect(
        cirAnnotation.verticalAlignment,
        ChartAlignment.far,
      );
    });
  });

  group('Pie - Explode', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_single_tap')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode in single tap', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.singleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_single_tap_customization')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea
      //     ._onTapUp(PointerUpEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._renderingDetails.isLegendToggled = true;
      // _chartState!._redraw();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode in single tap customization', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.singleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_double_tap')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode in double tap', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.doubleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_double_tap_customization')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._renderingDetails.explodedPoints.add(0);
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode in double tap customization', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.doubleTap);
    });

    // testWidgets(
    //     'Accumulation Chart Widget - Testing Pie series explode options',
    //     (WidgetTester tester) async {
    //   final _PieTouchInteraction chartContainer =
    //       _pieTouchInteraction('pie_explode_index_double_tap')
    //           as _PieTouchInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._circularArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._circularArea._onDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('test pieseries explode index in double tap', () {
    //   expect(chart!.series[0].explode, true);
    //   expect(chart!.series[0].explodeIndex, 1);
    //   expect(chart!.series[0].explodeGesture, ActivationMode.doubleTap);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_all_double_tap')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._renderingDetails.explodedPoints.add(0);
      // _chartState!._renderingDetails.explodedPoints.add(1);
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode all in double tap', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeAll, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.doubleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series explode options',
        (WidgetTester tester) async {
      final _PieTouchInteraction chartContainer =
          _pieTouchInteraction('pie_explode_long_press')
              as _PieTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onLongPress();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test pieseries explode in long press', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.longPress);
    });
  });
}

StatelessWidget _pieTouchInteraction(String sampleName) {
  return _PieTouchInteraction(sampleName);
}

// ignore: must_be_immutable
class _PieTouchInteraction extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PieTouchInteraction(String sampleName) {
    chart = getPiechart(sampleName);
  }
  SfCircularChart? chart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Test Chart Widget'),
          ),
          body: Center(
              child: Container(
            margin: EdgeInsets.zero,
            child: chart,
          ))),
    );
  }
}
