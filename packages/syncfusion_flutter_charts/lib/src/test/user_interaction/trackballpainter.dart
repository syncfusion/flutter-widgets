import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'user_interaction_samples.dart';

/// Test method of the trackball in all series.
void trackballPainter() {
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;

  //categoryAxis

  group('CategoryAxis trackbal touch interaction', () {
    testWidgets('charts - trackball touch ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball touch') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball touch position', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
    testWidgets('charts - trackball touch0 ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball Rectseries') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RangeColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as RangeColumnSeriesRenderer;
      // final RangeColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as RangeColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball touch position0', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.tooltipDisplayMode,
        TrackballDisplayMode.groupAllPoints,
      );
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
    });
    testWidgets('charts - trackball tooltip ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball tooltipsetting') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball tooltip setting', () {
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // expect(value.dx, 56.38000000000001); //const Offset(56.4,234.3));
      // expect(value.dy, 234.26666666666668);
      expect(chart!.trackballBehavior.tooltipSettings.format, 'point.x%');
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.tooltipDisplayMode,
        TrackballDisplayMode.nearestPoint,
      );
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(
        chart!.trackballBehavior.lineType,
        TrackballLineType.vertical,
      );
    });
    testWidgets('charts - trackball Axis ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball horizontalOrientation')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball inverted axis', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.center);
      expect(chart!.trackballBehavior.activationMode, ActivationMode.singleTap);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
    });
    testWidgets('charts - trackball verticalOrientation ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball verticalOrientation') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball vertical orientation', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
      expect(chart!.trackballBehavior.activationMode, ActivationMode.singleTap);
    });
    testWidgets('charts - trackball nextPointinfo',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball nextPointInfo')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final LineSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
      // final LineSegment cSegment = cSeriesRenderer._segments[2] as LineSegment;
      // final Offset value =
      //     Offset(cSegment._x2, (cSegment._y1 + cSegment._y1) / 2);
      // _chartState?._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball nextPointInfo', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
    testWidgets('charts - trackball floatallPoint ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball floatAll Points')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final LineSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[1] as LineSeriesRenderer;
      // final LineSegment cSegment = cSeriesRenderer._segments[2] as LineSegment;
      // final Offset value =
      //     Offset(cSegment._x2, (cSegment._y1 + cSegment._y1) / 2);
      // _chartState?._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball floatall points', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
    testWidgets('charts - trackball horizontalOrientation ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball horizontal1')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[3] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball horizontalOrientation', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
    testWidgets('charts - trackball horizontal', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball horizontal') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[3] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball horizontal', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
    });
    testWidgets('charts - trackball isRight1', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball isright1') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[3] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball isRight1', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
    });
    testWidgets('charts - trackball tooltipalignment ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball tooltipalignment')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[3] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball tooltipalignment', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
    testWidgets('charts - trackball isRight ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball isright') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[3] as ColumnSegment;
      // final Offset value = Offset(cSegment.segmentRect.right,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball isRight', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
    });
  });

  //NumericAxis
  group('NumericAxis trackball Orientation', () {
    testWidgets('charts - trackball invertedAxis ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball inverted axis') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball inverted axis', () {
      expect(chart!.trackballBehavior.enable, true);
    });
    testWidgets('charts - trackball tooltipdisplaymode ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball tooltipDisplaymode') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[2] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball tooltip Display mode', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(
        chart!.trackballBehavior.tooltipAlignment,
        ChartAlignment.far,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
    });
    testWidgets('charts - trackball areaseries ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball areaseries') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final AreaSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as AreaSeriesRenderer;
      // final AreaSegment cSegment = cSeriesRenderer._segments[0] as AreaSegment;
      // final Offset value = Offset(
      //     (cSegment._pathRect!.left + cSegment._pathRect!.right) / 2,
      //     (cSegment._pathRect!.top + cSegment._pathRect!.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball areaseries', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(
        chart!.trackballBehavior.tooltipAlignment,
        ChartAlignment.center,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
    });
    testWidgets('charts - trackball numeric trackball ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('NumericAxis trackball') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball numeric trackball', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.center);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
    });
  });

  // DateTimeAxis
  group('DateTimeAxis trackbal tooltip setting', () {
    testWidgets('charts - trackball tooltipsettingformat ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('DateTime Axis trackball tooltipsettingformat')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball tooltipsetting format', () {
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // expect(value.dx, 70.0); //const Offset(56.4,234.3));
      // expect(value.dy, 416.7067360350493);
      expect(chart!.trackballBehavior.tooltipSettings.format, 'point.x%');
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(chart!.trackballBehavior.tooltipSettings.color!.value, 4294198070);
      expect(chart!.trackballBehavior.tooltipSettings.borderColor!.value,
          4283215696);
    });

    testWidgets('charts - trackball tooltipsize ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball tooltipsize') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final RangeAreaSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as RangeAreaSeriesRenderer;
      // final RangeAreaSegment cSegment =
      //     cSeriesRenderer._segments[0] as RangeAreaSegment;
      // final Offset value = Offset(
      //     (cSegment._pathRect!.left + cSegment._pathRect!.right) / 2,
      //     (cSegment._pathRect!.top + cSegment._pathRect!.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball tooltipsize', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(
        chart!.trackballBehavior.tooltipAlignment,
        ChartAlignment.center,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
    });
    testWidgets('charts - trackballrect numeric ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('NumericAxis trackballRect') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final ColumnSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as ColumnSeriesRenderer;
      // final ColumnSegment cSegment =
      //     cSeriesRenderer._segments[0] as ColumnSegment;
      // final Offset value = Offset(
      //     (cSegment.segmentRect.left + cSegment.segmentRect.right) / 2,
      //     (cSegment.segmentRect.top + cSegment.segmentRect.bottom) / 2);
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));

      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackballRect Numeric', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(
        chart!.trackballBehavior.tooltipAlignment,
        ChartAlignment.near,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
    });
    testWidgets('charts - trackball leftrect ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball leftrect') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final LineSeriesRenderer cSeriesRenderer = _chartState!
      //     ._chartSeries.visibleSeriesRenderers[0] as LineSeriesRenderer;
      // final LineSegment cSegment = cSeriesRenderer._segments[3] as LineSegment;
      // final Offset value =
      //     Offset(cSegment._x1, (cSegment._y1 + cSegment._y2) / 2);
      // _chartState?._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball leftrect', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
  });

  group('Trackbal tooltip marker', () {
    testWidgets('charts - trackball tooltipsetting marker ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball default marker') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball marker', () {
      expect(chart!.trackballBehavior.tooltipSettings.canShowMarker, true);
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.groupAllPoints);
    });
    testWidgets('charts - trackball tooltipsetting marker ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('trackball marker shape') as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball marker', () {
      expect(chart!.trackballBehavior.tooltipSettings.canShowMarker, true);
      expect(chart!.trackballBehavior.markerSettings!.color!.value, 4294198070);
      expect(chart!.trackballBehavior.markerSettings!.shape,
          DataMarkerType.triangle);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.floatAllPoints);
    });
    testWidgets('charts - trackball floatallPoint ',
        (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball multiple series')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test trackball floatall points', () {
      expect(chart!.trackballBehavior.enable, true);
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
      expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    });
  });
  group('Trackbal tooltip indicator', () {
    testWidgets('charts - trackball ', (WidgetTester tester) async {
      final _TrackballPaint chartContainer =
          _trackballPainter('category trackball with indicator')
              as _TrackballPaint;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.indicators[0].isVisible, true);
      // expect(_chartState!._technicalIndicatorRenderer[0]._dataPoints![0].close,
      //     98.89);
      expect(chart!.indicators[0].period, 14);
    });
    test('to test trackball indicaator', () {
      expect(
        chart!.trackballBehavior.activationMode,
        ActivationMode.singleTap,
      );
      expect(chart!.trackballBehavior.tooltipDisplayMode,
          TrackballDisplayMode.nearestPoint);
    });
    // test('to test trackball indicaator', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     final CartesianSeriesRenderer seriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[i];
    //     final CartesianChartPoint<dynamic> dataPoints =
    //         seriesRenderer._dataPoints[0];
    //     expect(seriesRenderer._dataPoints.length, 46);
    //     expect(dataPoints.region!.left.toInt(), 53);
    //     expect(dataPoints.region!.top.toInt(), 157);
    //     expect(dataPoints.region!.right.toInt(), 55);
    //     expect(dataPoints.region!.bottom.toInt(), 162);
    //   }
    // });
  });
}

StatelessWidget _trackballPainter(String sampleName) {
  return _TrackballPaint(sampleName);
}

//ignore: must_be_immutable
class _TrackballPaint extends StatelessWidget {
  //ignore: prefer_const_constructors_in_immutables
  _TrackballPaint(String sampleName) {
    chart = getUserInteractionChart(sampleName);
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
