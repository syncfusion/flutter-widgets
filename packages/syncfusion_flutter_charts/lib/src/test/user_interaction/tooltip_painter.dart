import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'tooltip_painter_samples.dart';

/// Test method of tooltip in chart.
void tooltipPainter() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('tooltip painter', () {
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip start') as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RenderBox renderBox =
      //     _chartState!.context.findRenderObject() as RenderBox;
      // final CartesianSeriesRenderer cSeriesRenderer =
      //     _chartState!._chartSeries.visibleSeriesRenderers[0];
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // //  ignore: prefer_const_constructors_in_immutables
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: renderBox.localToGlobal(value)));
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: renderBox.localToGlobal(value)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip end') as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RenderBox renderBox =
      //     _chartState!.context.findRenderObject() as RenderBox;
      // final CartesianSeriesRenderer cSeriesRenderer =
      //     _chartState!._chartSeries.visibleSeriesRenderers[0];
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[10] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // //  ignore: prefer_const_constructors_in_immutables
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: renderBox.localToGlobal(value)));
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: renderBox.localToGlobal(value)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip top') as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RenderBox renderBox =
      //     _chartState!.context.findRenderObject() as RenderBox;
      // final CartesianSeriesRenderer cSeriesRenderer =
      //     _chartState!._chartSeries.visibleSeriesRenderers[0];
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[6] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // // ignore: prefer_const_constructors_in_immutables
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: renderBox.localToGlobal(value)));
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: renderBox.localToGlobal(value)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip start_top')
              as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RenderBox renderBox =
      //     _chartState!.context.findRenderObject() as RenderBox;
      // // ignore: prefer_const_constructors_in_immutables
      // _chartState!._containerArea._performPointerDown(PointerDownEvent(
      //     position: renderBox.localToGlobal(const Offset(52, 52.9))));
      // _chartState!._containerArea
      //     ._performPointerUp(const PointerUpEvent(position: Offset(49, 73.8)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip end_top') as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._containerArea
      //     ._performPointerUp(const PointerUpEvent(position: Offset(776, 75)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip start_bottom')
              as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._containerArea._performPointerUp(
      //     const PointerUpEvent(position: Offset(49.8, 490.18)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip end_bottom')
              as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // _chartState!._containerArea._performPointerUp(
      //     const PointerUpEvent(position: Offset(775.6, 530.18)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
    testWidgets('tooltip', (WidgetTester tester) async {
      final _CartesianTooltipSample chartContainer =
          _cartesianTooltipSample('tooltip header null')
              as _CartesianTooltipSample;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RenderBox renderBox =
      //     _chartState!.context.findRenderObject() as RenderBox;
      // final CartesianSeriesRenderer cSeriesRenderer =
      //     _chartState!._chartSeries.visibleSeriesRenderers[0];
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // //  ignore: prefer_const_constructors_in_immutables
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: renderBox.localToGlobal(value)));
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: renderBox.localToGlobal(value)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test tooltip', () {
      expect(chart!.selectionGesture, ActivationMode.singleTap);
      expect(chart!.tooltipBehavior.enable, true);
    });
  });
}

StatelessWidget _cartesianTooltipSample(String sampleName) {
  return _CartesianTooltipSample(sampleName);
}

// ignore: must_be_immutable
class _CartesianTooltipSample extends StatelessWidget {
  _CartesianTooltipSample(String sampleName) {
    chart = getTooltipPainter(sampleName);
  }

  SfCartesianChart? chart;
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
