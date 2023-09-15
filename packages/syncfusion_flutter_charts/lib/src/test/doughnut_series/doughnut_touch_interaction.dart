import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'doughnut_sample.dart';

/// Test method of user interaction in the doughnut series.
void doughnutTouchInteraction() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Doughnut Selection', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with selection',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_default')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
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

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with selection',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_event')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
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
    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with selection',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_double_tap')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection event in double tap', () {
      expect(chart!.series[0].selectionBehavior.enable, true);
      expect(chart!.selectionGesture, ActivationMode.doubleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with selection',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_long_press')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
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

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with selection',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_customization')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    // test('test selection customization', () {
    //   final DoughnutSeries<_DoughnutSample, String?> pSeries =
    //       chart!.series[0] as DoughnutSeries<_DoughnutSample, String?>;
    //   expect(pSeries.selectionBehavior.enable, true);
    //   expect(pSeries.selectionBehavior.selectedColor, Colors.red);
    //   expect(pSeries.selectionBehavior.unselectedColor, Colors.grey);
    //   expect(pSeries.selectionBehavior.selectedBorderColor, Colors.blue);
    //   expect(
    //       pSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
    //   expect(pSeries.selectionBehavior.selectedBorderWidth, 2);
    //   expect(pSeries.selectionBehavior.unselectedBorderWidth, 0);
    //   expect(pSeries.selectionBehavior.selectedOpacity, 0.5);
    //   expect(pSeries.selectionBehavior.unselectedOpacity, 1);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with customization update',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('selection_customization_update')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // _chartState!.didUpdateWidget(chart!);
      // _chartState!._redraw();
      await tester.pump(const Duration(seconds: 3));
    });

    // test('test selection customization update', () {
    //   final DoughnutSeries<_DoughnutSample, String?> pSeries =
    //       chart!.series[0] as DoughnutSeries<_DoughnutSample, String?>;
    //   expect(pSeries.selectionBehavior.enable, true);
    //   expect(pSeries.selectionBehavior.selectedColor, Colors.red);
    //   expect(pSeries.selectionBehavior.unselectedColor, Colors.grey);
    //   expect(pSeries.selectionBehavior.selectedBorderColor, Colors.blue);
    //   expect(
    //       pSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
    //   expect(pSeries.selectionBehavior.selectedBorderWidth, 2);
    //   expect(pSeries.selectionBehavior.unselectedBorderWidth, 0);
    //   expect(pSeries.selectionBehavior.selectedOpacity, 0.5);
    //   expect(pSeries.selectionBehavior.unselectedOpacity, 1);
    // });

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series with annotation',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('circular_annotation')
              as _DoughnutTouchInteraction;
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
        'Accumulation Chart Widget - Testing Doughnut series with annotation',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('circular_annotation_horizontal')
              as _DoughnutTouchInteraction;
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
        'Accumulation Chart Widget - Testing Doughnut series with annotation',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('circular_annotation_vertical')
              as _DoughnutTouchInteraction;
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

  group('Doughnut Explode', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series explode options',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('doughnut_explode_single_tap')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('test doughnutseries explode in single tap', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.singleTap);
      // _chartState!.didUpdateWidget(chart!);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series explode options',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('doughnut_explode_double_tap')
              as _DoughnutTouchInteraction;
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

    test('test doughnutseries explode in double tap', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.doubleTap);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Doughnut series explode options',
        (WidgetTester tester) async {
      final _DoughnutTouchInteraction chartContainer =
          _doughnutTouchInteraction('doughnut_explode_long_press')
              as _DoughnutTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onLongPress();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test doughnutseries explode in long press', () {
      expect(chart!.series[0].explode, true);
      expect(chart!.series[0].explodeGesture, ActivationMode.longPress);
    });
  });
}

StatelessWidget _doughnutTouchInteraction(String sampleName) {
  return _DoughnutTouchInteraction(sampleName);
}

// ignore: must_be_immutable
class _DoughnutTouchInteraction extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DoughnutTouchInteraction(String sampleName) {
    chart = getDoughnutchart(sampleName);
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
