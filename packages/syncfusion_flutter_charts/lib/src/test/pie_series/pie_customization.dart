import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pie_sample.dart';

/// Testing method for customization of the pie chart.
void pieCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;

  group('Pie - Fill, Point Fill Color Mapping', () {
    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with default properties',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('customization_default') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // to test series count
    test('test series count', () {
      expect(chart!.series.length, 1);
    });

    final List<Color> colors = <Color>[];
    colors.add(const Color(0xff4b87b9));
    colors.add(const Color(0xffc06c84));
    colors.add(const Color(0xfff67280));
    colors.add(const Color(0xfff8b195));
    colors.add(const Color(0xff74b49b));

    // test('test slice fill color', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     for (int j = 0;
    //         j <
    //             _chartState!._chartSeries.visibleSeriesRenderers[i]
    //                 ._renderPoints!.length;
    //         j++) {
    //       final Color? fillColor = _chartState!
    //           ._chartSeries.visibleSeriesRenderers[i]._renderPoints![j].fill;
    //       expect(fillColor, colors[j]);
    //     }
    //   }
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Point Color Mapping',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_pointcolor') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // final List<int> pointColors = <int>[];
    // pointColors.add(const Color(0xffff5722).value);
    // pointColors.add(const Color(0xff673ab7).value);
    // pointColors.add(const Color(0xff8bc34a).value);
    // pointColors.add(const Color(0xfff44336).value);
    // pointColors.add(const Color(0xff9c27b0).value);

    // test('test slice fill color', () {
    //   for (int i = 0; i < chart!.series.length; i++) {
    //     for (int j = 0;
    //         j <
    //             _chartState!._chartSeries.visibleSeriesRenderers[i]
    //                 ._renderPoints!.length;
    //         j++) {
    //       final Color fillColor = _chartState!
    //           ._chartSeries.visibleSeriesRenderers[i]._renderPoints![j].fill;
    //       expect(fillColor.value, pointColors[j]);
    //     }
    //   }
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });
  });

  group('Pie - Tooltip', () {
    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_default') as _PieCustomization;
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
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_customization') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test the tooltip customization', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.borderColor, Colors.red);
      expect(chart!.tooltipBehavior.borderWidth, 5);
      expect(chart!.tooltipBehavior.color, Colors.lightBlue);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.singleTap);
    });

    testWidgets('Accumulation Chart Widget - tooltip',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_label_format') as _PieCustomization;
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
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_mode_double_tap') as _PieCustomization;
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
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_series_no_tooltip_format')
              as _PieCustomization;
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
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_series_disable_tooltip')
              as _PieCustomization;
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
      final _PieCustomization chartContainer =
          _pieCustomization('tooltip_mode_long_press') as _PieCustomization;
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

    test('test the tooltip long press event', () {
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.activationMode, ActivationMode.longPress);
    });

    // testWidgets('Accumulation Chart Widget - tooltip',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_tooltip_template')
    //           as _PieCustomization;
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

    // test('test the customization tooltip template event', () {
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   expect(value.dx, 490.5556870111685);
    //   expect(value.dy, 256.8481950793825);
    //   expect(chart!.tooltipBehavior.canShowMarker, true);
    //   expect(chart!.tooltipBehavior.duration, 3000.0);
    // });
  });
  group('Pie - Center XY, Start and End Angle', () {
    testWidgets('Accumulation Chart Widget - Pie series with Center X and Y',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('customization_centerXY') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 178);
    //   expect(visiblePoint.center!.dx, 517.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 178);
    //   expect(visiblePoint.center!.dx, 517.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start and End Angle',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_start_end_angle')
    //           as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -45);
    //   expect(visiblePoint.endAngle, -0.6521739130434767);
    //   expect(visiblePoint.midAngle, -22.82608695652174);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 135.16304347826087);
    //   expect(visiblePoint.endAngle, 210.0);
    //   expect(visiblePoint.midAngle, 172.58152173913044);
    //   expect(visiblePoint.center!.dx, 400);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start Angle Greater than End Angle',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_start_high') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, 155);
    //   expect(visiblePoint.endAngle, 209.7826086956522);
    //   expect(visiblePoint.midAngle, 182.3913043478261);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start and End Angle Equal',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_start_end_equal')
    //           as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -45);
    //   expect(visiblePoint.endAngle, 17.608695652173914);
    //   expect(visiblePoint.midAngle, -13.695652173913043);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 209.3478260869565);
    //   expect(visiblePoint.endAngle, 315.0);
    //   expect(visiblePoint.midAngle, 262.17391304347825);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start and End Angle Greater than 360',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('start_end_360') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -70);
    //   expect(visiblePoint.endAngle, -38.69565217391305);
    //   expect(visiblePoint.midAngle, -54.34782608695652);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 57.17391304347825);
    //   expect(visiblePoint.endAngle, 110.0);
    //   expect(visiblePoint.midAngle, 83.58695652173913);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start and End Angle from -1 to -360',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('start_end_-1_-360') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, 80);
    //   expect(visiblePoint.endAngle, 126.95652173913044);
    //   expect(visiblePoint.midAngle, 103.47826086956522);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 270.7608695652174);
    //   expect(visiblePoint.endAngle, 350.0);
    //   expect(visiblePoint.midAngle, 310.3804347826087);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Start and End Angle lesser than -360',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('start_end_-360') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, 250);
    //   expect(visiblePoint.endAngle, 281.30434782608694);
    //   expect(visiblePoint.midAngle, 265.6521739130435);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 377.1739130434782);
    //   expect(visiblePoint.endAngle, 429.99999999999994);
    //   expect(visiblePoint.midAngle, 403.58695652173907);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });
  });

  group('Pie - Title and Margin', () {
    testWidgets('Accumulation Chart Widget - Pie series with Title',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('customization_title') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test title properties', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'Pie Series');
      // expect(title.textStyle.color, Colors.deepPurple);
      // expect(title.textStyle.fontSize, 12);
      expect(title.alignment, ChartAlignment.near);
    });

    // testWidgets('Accumulation Chart Widget - Pie series with Margin',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_margin') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 176);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dy.toInt(), 174);
    //   expect(visiblePoint.center!.dx, 514.0);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 176);
    // });
  });

  group('Pie - Explode', () {
    testWidgets('Accumulation Chart Widget - Pie series with Explode',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('customization_explode') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
      // _chartState!.didUpdateWidget(chart!);
      // _chartState!._redraw();
      await tester.pump(const Duration(seconds: 3));
    });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dx.toInt(), 409);
    //   expect(visiblePoint.center!.dy.toInt(), 234);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dx, 400.0);
    //   expect(visiblePoint.center!.dy.toInt(), 250);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    testWidgets('Accumulation Chart Widget - Pie series with Explode All',
        (WidgetTester tester) async {
      final _PieCustomization chartContainer =
          _pieCustomization('customization_explodeAll') as _PieCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    // test('test the first visible point', () {
    //   final ChartPoint<dynamic> visiblePoint =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(visiblePoint.startAngle, -90);
    //   expect(visiblePoint.endAngle, -27.391304347826086);
    //   expect(visiblePoint.midAngle, -58.69565217391305);
    //   expect(visiblePoint.center!.dx.toInt(), 409);
    //   expect(visiblePoint.center!.dy.toInt(), 234);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });

    // test('test the last visible point', () {
    //   final ChartPoint<dynamic> visiblePoint = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![_chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length -
    //       1];
    //   expect(visiblePoint.startAngle, 164.3478260869565);
    //   expect(visiblePoint.endAngle, 270.0);
    //   expect(visiblePoint.midAngle, 217.17391304347825);
    //   expect(visiblePoint.center!.dx.toInt(), 384);
    //   expect(visiblePoint.center!.dy.toInt(), 238);
    //   expect(visiblePoint.innerRadius, 0.0);
    //   expect(visiblePoint.outerRadius!.toInt(), 192);
    // });
  });

  group('Pie - Grouping', () {
    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Grouping Mode Point',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_groupPoint') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test group mode - point', () {
    //   final int pointlength = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
    //   expect(pointlength, 3);
    // });

    // testWidgets(
    //     'Accumulation Chart Widget - Pie series with Grouping Mode Value',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_groupValue') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test group mode - value', () {
    //   final int pointlength = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints!.length;
    //   expect(pointlength, 3);
    // });

    // testWidgets('Accumulation Chart Widget - Pie series with Stroke',
    //     (WidgetTester tester) async {
    //   final _PieCustomization chartContainer =
    //       _pieCustomization('customization_stroke') as _PieCustomization;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('test the last visible point', () {
    //   final Color color = _chartState!
    //       ._chartSeries.visibleSeriesRenderers[0]._renderPoints![0].strokeColor;
    //   final double? width = _chartState!._chartSeries.visibleSeriesRenderers[0]
    //       ._renderPoints![0].strokeWidth as double?;
    //   expect(const Color(0xfff44336).value, color.value);
    //   expect(2.0, width);
    // });
  });
}

StatelessWidget _pieCustomization(String sampleName) {
  return _PieCustomization(sampleName);
}

// ignore: must_be_immutable
class _PieCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PieCustomization(String sampleName) {
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
