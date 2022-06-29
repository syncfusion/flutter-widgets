import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'radialbar_sample.dart';

/// Testing method for customization of the radial bar chart.
void radialBarCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Radialbar - Tooltip', () {
    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_default') as _RadialBarCustomization;
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

    test('test the default tooltip', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_customization')
              as _RadialBarCustomization;
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

    test('test the default tooltip', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_label_format')
              as _RadialBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test the tooltip label format', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.format, 'point.y%');
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_mode_double_tap')
              as _RadialBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._circularArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._circularArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });

    test('test the tooltip double tap event', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.doubleTap);
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_series_disable_tooltip')
              as _RadialBarCustomization;
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

    test('test the tooltip double tap event', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.doubleTap);
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('tooltip_mode_long_press')
              as _RadialBarCustomization;
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

    test('test the default tooltip', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.longPress);
    });

    // testWidgets('Accumulation Chart Widget - tooltip',
    //     (WidgetTester tester) async {
    //   final _RadialBarCustomization chartContainer =
    //       _radialBarCustomization('customization_tooltip_template')
    //           as _RadialBarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    //   // final Offset value = _getTouchPosition(
    //   //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   // _chartState!._circularArea
    //   //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   // _chartState!._circularArea._onDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });

    // test('test the customization tooltip template event', () {
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 369.0);
    //   expect(value.dy, 128.284);
    //   expect(chart!.tooltipBehavior.canShowMarker, true);
    //   expect(chart!.tooltipBehavior.duration, 3000.0);
    // });
  });

  group('Radial Bar - Title and Margin', () {
    testWidgets('Accumulation Chart Widget - Radialbar series with Title',
        (WidgetTester tester) async {
      final _RadialBarCustomization chartContainer =
          _radialBarCustomization('customization_title')
              as _RadialBarCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test title properties', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'RadialBar Series');
      expect(title.textStyle.color, Colors.deepPurple);
      expect(title.textStyle.fontSize, 12);
      expect(title.alignment, ChartAlignment.near);
    });

    // testWidgets('Accumulation Chart Widget - Radial bar series with Margin',
    //     (WidgetTester tester) async {
    //   final _RadialBarCustomization chartContainer =
    //       _radialBarCustomization('customization_margin')
    //           as _RadialBarCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -20.946483375959076);
    //   expect(visiblePoint.midAngle, -55.47324168797954);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius, 88.2);
    //   expect(visiblePoint.outerRadius!.toInt(), 104);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -6.215066496163672);
    //   expect(visiblePoint.midAngle, -48.107533248081836);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius, 158.76);
    //   expect(visiblePoint.outerRadius!.toInt(), 175);
    // });
  });
}

StatelessWidget _radialBarCustomization(String sampleName) {
  return _RadialBarCustomization(sampleName);
}

// ignore: must_be_immutable
class _RadialBarCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RadialBarCustomization(String sampleName) {
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
