import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'radialbar_sample.dart';

/// Test method of user interaction in the radial bar series.
void radialBarTouchInteraction() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  // SfCircularChartState? _chartState;

  group('RadialBar - Selection and Annotation', () {
    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_default')
              as _RadialBarTouchInteraction;
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

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_event')
              as _RadialBarTouchInteraction;
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

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_double_tap')
              as _RadialBarTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //  final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
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
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_long_press')
              as _RadialBarTouchInteraction;
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

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_customization')
              as _RadialBarTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection customization', () {
      final RadialBarSeries<RadialbarSample, String?> rSeries =
          chart!.series[0] as RadialBarSeries<RadialbarSample, String?>;
      expect(rSeries.selectionBehavior.enable, true);
      expect(rSeries.selectionBehavior.selectedColor, Colors.red);
      expect(rSeries.selectionBehavior.unselectedColor, Colors.grey);
      expect(rSeries.selectionBehavior.selectedBorderColor, Colors.blue);
      expect(
          rSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
      expect(rSeries.selectionBehavior.selectedBorderWidth, 2);
      expect(rSeries.selectionBehavior.unselectedBorderWidth, 0);
      expect(rSeries.selectionBehavior.selectedOpacity, 0.5);
      expect(rSeries.selectionBehavior.unselectedOpacity, 1);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with selection',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('selection_customization_update')
              as _RadialBarTouchInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    test('test selection customization update', () {
      final RadialBarSeries<RadialbarSample, String?> rSeries =
          chart!.series[0] as RadialBarSeries<RadialbarSample, String?>;
      expect(rSeries.selectionBehavior.enable, true);
      expect(rSeries.selectionBehavior.selectedColor, Colors.red);
      expect(rSeries.selectionBehavior.unselectedColor, Colors.grey);
      expect(rSeries.selectionBehavior.selectedBorderColor, Colors.blue);
      expect(
          rSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
      expect(rSeries.selectionBehavior.selectedBorderWidth, 2);
      expect(rSeries.selectionBehavior.unselectedBorderWidth, 0);
      expect(rSeries.selectionBehavior.selectedOpacity, 0.5);
      expect(rSeries.selectionBehavior.unselectedOpacity, 1);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing RadialBar series with annotation',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('circular_annotation')
              as _RadialBarTouchInteraction;
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
        'Accumulation Chart Widget - Testing RadialBar series with annotation',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('circular_annotation_horizontal')
              as _RadialBarTouchInteraction;
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
        'Accumulation Chart Widget - Testing RadialBar series with annotation',
        (WidgetTester tester) async {
      final _RadialBarTouchInteraction chartContainer =
          _radialBarTouchInteraction('circular_annotation_vertical')
              as _RadialBarTouchInteraction;
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
}

StatelessWidget _radialBarTouchInteraction(String sampleName) {
  return _RadialBarTouchInteraction(sampleName);
}

// ignore: must_be_immutable
class _RadialBarTouchInteraction extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RadialBarTouchInteraction(String sampleName) {
    chart = getRadialbarchart(sampleName);
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
