import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'bar_sample.dart';

/// Test method of user interaction in the bar series.
void barTouchInteraction() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Bar - Series,', () {
    testWidgets('bar series sample', (WidgetTester tester) async {
      final _BarUIInteraction chartContainer =
          _barUIInteraction('bar_series_tooltip') as _BarUIInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final Offset value = getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    // test('to test tooltip touch event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    testWidgets('bar series sample', (WidgetTester tester) async {
      final _BarUIInteraction chartContainer =
          _barUIInteraction('bar_series_tooltip_renderer') as _BarUIInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final Offset value = getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._containerArea._performPointerUp(
      //     PointerUpEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    // test('to test tooltip renderer', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    test('to test tooltip hide', () {
      chart!.tooltipBehavior.hide();
    });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_tooltip_double_tap')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test tooltip double tap event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_tooltip_long_press')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performLongPress();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test tooltip long press event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_tooltip_template') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerUp(
    //       PointerUpEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test tooltip template touch event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    //   expect(chart!.tooltipBehavior.canShowMarker, true);
    //   expect(chart!.tooltipBehavior.duration, 3000.0);
    // });
  });

  group('Bar - Series,', () {
    testWidgets('bar series sample', (WidgetTester tester) async {
      final _BarUIInteraction chartContainer =
          _barUIInteraction('bar_series_trackball') as _BarUIInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final Offset value = getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    // test('to test trackball touch event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    // test('to test trackball hide', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   chart!.trackballBehavior.hide();
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_dash_array_vertical')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball dash array in vertical line type', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_dash_array_isTransposed_vertical')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball dash array in vertical line type', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 108.6); //const Offset(56.4,234.3));
    //   expect(value.dy, 368.1333333333333);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.isTransposed, true);
    //   expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_dash_array') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball dash array in vertical line type', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_dash_array_isTransposed')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball dash array in vertical line type', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 108.6); //const Offset(56.4,234.3));
    //   expect(value.dy, 368.1333333333333);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.isTransposed, true);
    //   expect(chart!.trackballBehavior.lineType, TrackballLineType.vertical);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_opposed') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball opposed axis', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 186.13333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 473.8);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.primaryXAxis.opposedPosition, true);
    //   expect(chart!.primaryYAxis.opposedPosition, true);
    // });

    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_display_mode') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball display mode', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 276.93333333333334); //const Offset(56.4,234.3));
    //   expect(value.dy, 481.60625);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.trackballBehavior.tooltipDisplayMode,
    //       TrackballDisplayMode.groupAllPoints);
    //   expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.center);
    // });
    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_tooltip_align_near')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball tooltip alignment near', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 276.93333333333334); //const Offset(56.4,234.3));
    //   expect(value.dy, 481.60625);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.trackballBehavior.tooltipDisplayMode,
    //       TrackballDisplayMode.groupAllPoints);
    //   expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.near);
    // });
    // testWidgets('Bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('trackball_tooltip_align_far') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test trackball tooltip alignment far', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 276.93333333333334); //const Offset(56.4,234.3));
    //   expect(value.dy, 481.60625);
    //   expect(chart!.trackballBehavior.enable, true);
    //   expect(chart!.trackballBehavior.tooltipDisplayMode,
    //       TrackballDisplayMode.groupAllPoints);
    //   expect(chart!.trackballBehavior.tooltipAlignment, ChartAlignment.far);
    // });
  });

  group('Bar - Series -Selection event,', () {
    testWidgets('bar series sample', (WidgetTester tester) async {
      final _BarUIInteraction chartContainer =
          _barUIInteraction('bar_default_Selection') as _BarUIInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final Offset value = getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState?._containerArea._performPointerDown(
      //     PointerDownEvent(position: Offset(value.dx, value.dy)));
      await tester.pump(const Duration(seconds: 3));
    });

    // test('to test default selection touch event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 241.73333333333332); //const Offset(56.4,234.3));
    //   expect(value.dy, 459.2402044293015);
    //   expect(chart!.series[0].selectionBehavior!.enable, true);
    //   expect(chart!.selectionGesture, ActivationMode.singleTap);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_default_selection_mode_point')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test default selection touch event', () {
    //   final BarSeriesRenderer cSeriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   expect(cSeriesRenderer._series.selectionBehavior.enable, true);
    //   expect(chart!.selectionType, SelectionType.point);
    //   cSeriesRenderer._series.selectionBehavior.selectDataPoints(1, 0);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_default_selection_mode_series')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test default selection touch event', () {
    //   final BarSeriesRenderer cSeriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   expect(cSeriesRenderer._series.selectionBehavior.enable, true);
    //   expect(chart!.selectionType, SelectionType.series);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_default_selection_mode_cluster')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test default selection touch event', () {
    //   final BarSeriesRenderer cSeriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   expect(cSeriesRenderer._series.selectionBehavior.enable, true);
    //   expect(chart!.selectionType, SelectionType.cluster);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_default_selection_customization')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test default selection touch event', () {
    //   final BarSeriesRenderer cSeriesRenderer = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0] as BarSeriesRenderer;
    //   final BarSegment cSegment = cSeriesRenderer._segments[1] as BarSegment;
    //   final Offset value = cSegment.segmentRect.center;
    //   final BarSeries<dynamic, dynamic> cSeries =
    //       cSeriesRenderer._series as BarSeries<dynamic, dynamic>;
    //   expect(value.dx, 192.8); //const Offset(56.4,234.3));
    //   expect(value.dy, 373.7206132879046);
    //   expect(cSeries.selectionBehavior.enable, true);
    //   expect(cSeries.selectionBehavior.selectedColor, Colors.red);
    //   expect(cSeries.selectionBehavior.unselectedColor, Colors.grey);
    //   expect(cSeries.selectionBehavior.selectedBorderColor, Colors.blue);
    //   expect(
    //       cSeries.selectionBehavior.unselectedBorderColor, Colors.lightGreen);
    //   expect(cSeries.selectionBehavior.selectedBorderWidth, 2);
    //   expect(cSeries.selectionBehavior.unselectedBorderWidth, 0);
    //   expect(chart!.selectionGesture, ActivationMode.singleTap);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_selection_double_tap_event')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState?._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test selection double tap event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 241.73333333333332); //const Offset(56.4,234.3));
    //   expect(value.dy, 459.2402044293015);
    //   expect(chart!.series[0].selectionBehavior!.enable, true);
    //   expect(chart!.selectionGesture, ActivationMode.doubleTap);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_selection_longpress_event')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState?._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performLongPress();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test selection long press event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 241.73333333333332); //const Offset(56.4,234.3));
    //   expect(value.dy, 459.2402044293015);
    //   expect(chart!.series[0].selectionBehavior!.enable, true);
    //   expect(chart!.selectionGesture, ActivationMode.longPress);
    // });
  });

  group('Bar Series -Zooming', () {
    testWidgets('bar series sample', (WidgetTester tester) async {
      final _BarUIInteraction chartContainer =
          _barUIInteraction('bar_series_pinch_zoom') as _BarUIInteraction;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      // final Offset value = getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // double firstTouchXValue = value.dx;
      // final double firstTouchYValue = value.dy;
      // double secondTouchXValue = value.dx + 50;
      // final double secondTouchYValue = value.dy + 50;

      // _chartState!._containerArea._performPointerDown(PointerDownEvent(
      //     position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
      // _chartState!._containerArea._performPointerDown(PointerDownEvent(
      //     position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));

      // for (int i = 0; i < 10; i++) {
      //   firstTouchXValue -= 1;
      //   secondTouchXValue += 1;
      //   _chartState!._containerArea._performPointerMove(PointerMoveEvent(
      //       position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
      //   _chartState!._containerArea._performPointerMove(PointerMoveEvent(
      //       position: Offset(secondTouchXValue, secondTouchYValue),
      //       pointer: 3));
      await tester.pump(const Duration(seconds: 3));
    });

    //   _chartState!._containerArea._performPointerUp(PointerUpEvent(
    //       position: Offset(firstTouchXValue, firstTouchYValue), pointer: 2));
    //   _chartState!._containerArea._performPointerUp(PointerUpEvent(
    //       position: Offset(secondTouchXValue, secondTouchYValue), pointer: 3));
    //});

    test('to test zoomIn method', () {
      chart!.zoomPanBehavior.zoomIn();
    });

    test('to test zoomOut method', () {
      chart!.zoomPanBehavior.zoomOut();
    });
    test('to test zoomByFactor method', () {
      chart!.zoomPanBehavior.zoomByFactor(0.5);
    });
    test('to test zoomByRect method', () {
      chart!.zoomPanBehavior
          .zoomByRect(const Rect.fromLTRB(200, 300, 300, 400));
    });
    test('to test zoomToSingleAxis method', () {
      chart!.zoomPanBehavior.zoomToSingleAxis(chart!.primaryXAxis, 0.5, 0.4);
    });

    test('to test zoomReset method', () {
      chart!.zoomPanBehavior.zoomByFactor(0.5);
      chart!.zoomPanBehavior.reset();
    });
    // test('to test pinch zoom touch event', () {});

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_selection_zoom') as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   double firstTouchXValue = 50;
    //   double firstTouchYValue = 250;

    //   _chartState!._containerArea._performPanDown(DragDownDetails(
    //       globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
    //   for (int i = 0; i < 60; i++) {
    //     firstTouchXValue += 4;
    //     firstTouchYValue += 3;
    //     _chartState!._containerArea._performLongPressMoveUpdate(
    //         LongPressMoveUpdateDetails(
    //             globalPosition: Offset(firstTouchXValue, firstTouchYValue)));
    //     await tester.pump(const Duration(seconds: 3));
    //   }
    //   _chartState!._containerArea._performLongPressEnd();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    //   test('to test selection zoom touch event', () {});

    //   testWidgets('bar series sample', (WidgetTester tester) async {
    //     final _BarUIInteraction chartContainer =
    //         _barUIInteraction('bar_series_double_tap_zoom') as _BarUIInteraction;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     final Offset value = getTouchPosition(
    //         _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //     _chartState?._containerArea._performPointerDown(
    //         PointerDownEvent(position: Offset(value.dx, value.dy)));
    //     _chartState!._containerArea._performDoubleTap();
    //     await tester.pump(const Duration(seconds: 3));
    //   });

    //   test('to test double tap zoom touch event', () {
    //     final Offset value = getTouchPosition(
    //         _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //     expect(value.dx, 278.6471389645776); //const Offset(56.4,234.3));
    //     expect(value.dy, 475.74020442930146);
    //   });
    // });

    // group('Bar - Series,', () {
    //   testWidgets('bar series sample', (WidgetTester tester) async {
    //     final _BarUIInteraction chartContainer =
    //         _barUIInteraction('bar_series_crosshair') as _BarUIInteraction;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     final Offset value = getTouchPosition(
    //         _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //     _chartState!._crosshairBehaviorRenderer._crosshairPainter!.canResetPath =
    //         false;
    //     _chartState!._containerArea._performPointerDown(
    //         PointerDownEvent(position: Offset(value.dx, value.dy)));
    //     await tester.pump(const Duration(seconds: 3));
    //   });

    //   test('to test crosshair touch event', () {
    //     final Offset value = getTouchPosition(
    //         _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //     expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //     expect(value.dy, 451.8);
    //   });

    //   test('to test crosshair hide', () {
    //     final Offset value = getTouchPosition(
    //         _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //     chart!.crosshairBehavior.hide();
    //     expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //     expect(value.dy, 451.8);
    //   });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_crosshair_double_tap')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test crosshair double tap event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333);
    //   expect(value.dy, 451.8);
    // });

    // testWidgets('bar series sample', (WidgetTester tester) async {
    //   final _BarUIInteraction chartContainer =
    //       _barUIInteraction('bar_series_crosshair_long_press')
    //           as _BarUIInteraction;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;

    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._containerArea._performPointerDown(
    //       PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._containerArea._performLongPress();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('to test crosshair long press event', () {
    //   final Offset value = getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 268.1333333333333); //const Offset(56.4,234.3));
    //   expect(value.dy, 451.8);
    //   _chartState!.didUpdateWidget(chart!);
    //                 _chartState.didUpdateWidget(
    //                   SfCartesianChart(key: GlobalKey<State<SfCartesianChart>>(),
    //         primaryXAxis: CategoryAxis(),
    //         crosshairBehavior: CrosshairBehavior(enable: true, activationMode: ActivationMode.longPress),
    //         series: <BarSeries<_BarSample, String>>[
    //           BarSeries<_BarSample, String>(
    //               enableTooltip: false,
    //               animationDuration:2000,
    //               dataSource: <_BarSample>[
    //   _BarSample(DateTime(2005, 0, 1), 'India', 1, 32, 28, 680, 760,1, Colors.deepOrange),
    //   _BarSample(DateTime(2006, 0, 1), 'China', 2, 24, 44, 550, 880,2, Colors.deepPurple),
    //   _BarSample(DateTime(2007, 0, 1), 'USA', 3, 36, 48, 440, 788,3, Colors.lightGreen),
    //   _BarSample(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560,4, Colors.red),
    //   _BarSample(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566,5, Colors.purple)
    // ],
    //               xValueMapper: (_BarSample sales, _) => sales.category,
    //               yValueMapper: (_BarSample sales, _) => sales.sales1,
    //               dataLabelSettings: DataLabelSettings(isVisible: false)
    //           )
    //         ])
    // );
    //  });
  });
}

StatelessWidget _barUIInteraction(String sampleName) {
  return _BarUIInteraction(sampleName);
}

// ignore: must_be_immutable
class _BarUIInteraction extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _BarUIInteraction(String sampleName) {
    chart = getBarChart(sampleName);
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
