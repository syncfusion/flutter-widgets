import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'axis_sample.dart';

/// Test method of the plot band axis.
void plotBand() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called

  SfCartesianChart? chart;

  group('Numeric Axis - PlotBand visibility', () {
    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('Numeric plotband_visible') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband colors visibility', () {
      expect(chart!.primaryXAxis.plotBands[0].color.value, 4294198070);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].color.value,
          4293467747);
    });
    test('to test primaryXAxis plotband bordercolors visibility', () {
      expect(chart!.primaryXAxis.plotBands[0].borderColor.value, 4278190080);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .borderColor
              .value,
          4278190080);
    });
    test('test the primaryxaxis plotband text', () {
      expect(chart!.primaryXAxis.plotBands[0].textAngle, 90);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].textAngle,
          90);
    });
    test('to test primaryXAxis plotband textstyle', () {
      // expect(
      //     chart!.primaryXAxis.plotBands[0].textStyle.color!.value, 4278190080);
      // expect(
      //     chart!
      //         .primaryXAxis
      //         .plotBands[chart!.primaryXAxis.plotBands.length - 1]
      //         .textStyle
      //         .color!
      //         .value,
      //     4278190080);
    });
    test('to test primaryXAxis plotband bordercolors visibility', () {
      expect(chart!.primaryXAxis.plotBands[0].borderWidth, 2);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].borderWidth,
          2);
    });
    test('to test primaryYAxis plotband bordercolors visibility', () {
      expect(chart!.primaryYAxis.plotBands[0].borderWidth, 2);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].borderWidth,
          2);
    });
    test('to test primaryYAxis plotband bordercolors visibility', () {
      expect(chart!.primaryYAxis.plotBands[0].borderColor.value, 4278190080);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .borderColor
              .value,
          4278190080);
    });
    test('to test primaryYAxis plotband colors visibility', () {
      expect(chart!.primaryYAxis.plotBands[0].color.value, 4294961979);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1].color.value,
          4294961979);
    });
    test('to test the plotband primaryXAxis horizontal alignment', () {
      expect(chart!.primaryXAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });
    test('to test the plotband primaryYAxis horizontal alignment', () {
      expect(chart!.primaryYAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });

    test('to test primaryXAxis plotband opacity', () {
      expect(chart!.primaryXAxis.plotBands[0].opacity, 0.1);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].opacity,
          0.1);
    });
    test('test the associatestart of plotband primaryXAxis', () {
      expect(chart!.primaryXAxis.plotBands[0].associatedAxisStart, 2);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisStart,
          6);
    });
    test('to test primaryYAxis plotband dashArray', () {
      expect(chart!.primaryYAxis.plotBands[0].dashArray[0], 10.0);
      expect(chart!.primaryYAxis.plotBands[0].dashArray[1], 10.0);
    });
    test('to test primaryYAxis plotband dashArray', () {
      expect(chart!.primaryYAxis.plotBands[1].dashArray[0], 10.0);
      expect(chart!.primaryYAxis.plotBands[1].dashArray[1], 20.0);
    });
    test('to test primaryYAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[1].repeatUntil, 600);
      expect(chart!.primaryYAxis.plotBands[1].repeatUntil, 600);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil, 600);
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil, 600);
    });
    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('NumericAxis_gradient') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryYAxis plotband gradient color', () {
      expect(chart!.primaryYAxis.plotBands[0].gradient!.colors[0].value,
          4293467747);
      expect(chart!.primaryYAxis.plotBands[0].gradient!.colors[1].value,
          4293467747);
      expect(chart!.primaryYAxis.plotBands[0].gradient!.colors[2].value,
          4293467747);
      expect(chart!.primaryYAxis.plotBands[0].gradient!.stops![0], 0.0);
      expect(chart!.primaryYAxis.plotBands[0].gradient!.stops![1], 0.5);
      expect(chart!.primaryYAxis.plotBands[0].gradient!.stops![2], 1.0);
    });
    test('to test primaryYAxis plotband gradient stops', () {
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[0]
              .value,
          4293467747);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[1]
              .value,
          4293467747);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[2]
              .value,
          4293467747);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![0],
          0.0);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![1],
          0.5);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![2],
          1.0);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('NumericAxis Repeatation') as _PlotBandAxis;
      chart = SfCartesianChart(
        key: GlobalKey<State<SfCartesianChart>>(),
      );
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryYAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
  });
  group('DateTime - PlotBand visibility', () {
    testWidgets('chart - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('Datetime plotband visibility') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype date', () {
      expect(
          chart!.primaryXAxis.plotBands[0].sizeType, DateTimeIntervalType.auto);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.auto);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil, DateTime(2009));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil, DateTime(2009));
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].size, 20);
      expect(chart!.primaryXAxis.plotBands[1].size, 20);
    });
    test('to test primaryXAxis plotband textstyle', () {
      // expect(
      //     chart!.primaryXAxis.plotBands[0].textStyle.color!.value, 4294198070);
      // expect(
      //     chart!
      //         .primaryXAxis
      //         .plotBands[chart!.primaryXAxis.plotBands.length - 1]
      //         .textStyle
      //         .color!
      //         .value,
      //     4278190080);
    });
    test('to test primaryXAxis plotband dashArray', () {
      expect(chart!.primaryXAxis.plotBands[0].dashArray[0], 10.0);
      expect(chart!.primaryXAxis.plotBands[0].dashArray[1], 20.0);
    });
    test('to test the plotband primaryYAxis horizontal alignment', () {
      expect(chart!.primaryYAxis.plotBands[0].verticalTextAlignment.index, 1);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .verticalTextAlignment
              .index,
          1);
    });
    test('to test primarXAxis plotband dashArray', () {
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].dashArray[0],
          10.0);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].dashArray[1],
          10.0);
    });
    test('test the associatestart of plotband primaryXAxis', () {
      expect(chart!.primaryXAxis.plotBands[0].associatedAxisStart, 2);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisStart,
          2);
    });
    test('test the associateend of plotband primaryXAxis', () {
      expect(chart!.primaryXAxis.plotBands[0].associatedAxisEnd, 6);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisEnd,
          6);
    });

    test('test the primaryxaxis plotband text', () {
      expect(chart!.primaryXAxis.plotBands[0].text, 'Winter');
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].text,
          'Summer');
    });

    test('test the primaryxaxis plotband text', () {
      expect(chart!.primaryXAxis.plotBands[0].textAngle, 90);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].textAngle,
          90);
    });
    test('to test primaryYAxis plotband repeatation', () {
      expect(chart!.primaryYAxis.plotBands[0].repeatEvery, 1);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1].repeatEvery,
          2);
    });
    test('to test primaryXAxis plotband assosiacte start', () {
      expect(chart!.primaryYAxis.plotBands[0].associatedAxisStart, 20);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisStart,
          40);
    });
    test('to test primaryYAxis plotband assosiacte start', () {
      expect(chart!.primaryYAxis.plotBands[0].associatedAxisEnd, 100);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisEnd,
          270);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTimeAxis gradient') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband gradient color', () {
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[0].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[1].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[2].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![0], 0.0);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![1], 0.5);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![2], 1.0);
    });
    test('to test primaryXAxis plotband gradient stops', () {
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[0]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[1]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[2]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![0],
          0.0);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![1],
          0.5);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![2],
          1.0);
    });
    test('to test the plotband primaryXAxis horizontal alignment', () {
      expect(chart!.primaryXAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });
    test('to test the plotband primaryYAxis horizontal alignment', () {
      expect(chart!.primaryYAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTimeAxis Repeatation') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryYAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryXAxis plotband repeatUntill', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil, DateTime(2009, 0));
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].repeatUntil,
          DateTime(2009, 0));
    });
    test('to test primaryXAxis plotband repeatEvery', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatEvery, 2);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].repeatEvery,
          2);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
    test('to test primaryAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
    test('to test primaryYAxis plotband repeatUntill', () {
      expect(chart!.primaryYAxis.plotBands[0].repeatUntil, 600);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].repeatUntil,
          600);
    });
    test('to test primaryYAxis plotband repeatEvery', () {
      expect(chart!.primaryYAxis.plotBands[0].repeatEvery, 2);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].repeatEvery,
          2);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type1') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype date', () {
      expect(chart!.primaryXAxis.plotBands[0].sizeType,
          DateTimeIntervalType.years);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.years);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil, DateTime(2009));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil, DateTime(2009));
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type2') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype date', () {
      expect(chart!.primaryXAxis.plotBands[0].sizeType,
          DateTimeIntervalType.months);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.months);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil, DateTime(2009));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil, DateTime(2009));
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });

    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type3') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype1 date', () {
      expect(chart!.primaryXAxis.plotBands[0].sizeType,
          DateTimeIntervalType.hours);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.hours);
    });
    test('to test primaryXAxis plotband repeatable1', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil,
          DateTime(2006, 1, 1, 8, 50, 60));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil,
          DateTime(2006, 1, 1, 8, 50, 60));
    });
    test('to test primaryXAxis plotband repeatable1', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable1', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });
    testWidgets('charts - PlotBand visiblity1', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type4') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype2 date', () {
      expect(
          chart!.primaryXAxis.plotBands[0].sizeType, DateTimeIntervalType.days);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.days);
    });
    test('to test primaryXAxis plotband repeatable2', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil,
          DateTime(2006, 1, 1, 7, 50, 50));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil,
          DateTime(2006, 1, 1, 7, 50, 50));
    });
    test('to test primaryXAxis plotband repeatable2', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable2', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });
    testWidgets('charts - PlotBand visiblity2', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type5') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype3 date', () {
      expect(chart!.primaryXAxis.plotBands[0].sizeType,
          DateTimeIntervalType.minutes);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.minutes);
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil,
          DateTime(2005, 1, 1, 8, 50, 60));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil,
          DateTime(2005, 1, 1, 8, 50, 60));
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });
    testWidgets('charts - PlotBand visiblity3', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('DateTime Interval Type6') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband sizetype3 date', () {
      expect(chart!.primaryXAxis.plotBands[0].sizeType,
          DateTimeIntervalType.seconds);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.seconds);
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil,
          DateTime(2005, 1, 1, 7, 50, 50));
      expect(chart!.primaryXAxis.plotBands[1].repeatUntil,
          DateTime(2005, 1, 1, 7, 50, 50));
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
      expect(chart!.primaryXAxis.plotBands[1].repeatEvery, 1);
    });
    test('to test primaryXAxis plotband repeatable3', () {
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
      expect(chart!.primaryXAxis.plotBands[1].isRepeatable, true);
    });
  });
  group('Category - PlotBand visibility', () {
    testWidgets('chart - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('Category plotband XAxis visible') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband starting date', () {
      expect(chart!.primaryXAxis.plotBands[0].start, 'USA');
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].start,
          'India');
    });
    test('to test primaryXAxis plotband end', () {
      expect(chart!.primaryXAxis.plotBands[0].end, 'India');
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].end,
          'Japan');
    });
    test('to test primaryXAxis plotband sizetype date', () {
      expect(
          chart!.primaryXAxis.plotBands[0].sizeType, DateTimeIntervalType.days);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].sizeType,
          DateTimeIntervalType.days);
    });

    test('to test primaryXAxis plotband opacity', () {
      expect(chart!.primaryXAxis.plotBands[0].opacity, 0.1);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].opacity,
          0.5);
    });
    test('to test primaryXAxis plotband repeat', () {
      expect(chart!.primaryXAxis.plotBands[0].repeatUntil, 'India');
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].repeatUntil,
          'Japan');
    });
    test('to test primaryXAxis plotband assosiacte start', () {
      expect(chart!.primaryXAxis.plotBands[0].associatedAxisStart, 2);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisStart,
          3);
    });
    test('to test primaryXAxis plotband assosiacte start', () {
      expect(chart!.primaryXAxis.plotBands[0].associatedAxisEnd, 6);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisEnd,
          7);
    });
    test('to test primaryYAxis plotband assosiacte start', () {
      expect(chart!.primaryYAxis.plotBands[0].associatedAxisStart, 1);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisStart,
          0);
    });
    test('to test primaryYAxis plotband assosiacte start', () {
      expect(chart!.primaryYAxis.plotBands[0].associatedAxisEnd, 4);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .associatedAxisEnd,
          3);
    });
    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('CategoryAxis gradient') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband gradient color', () {
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[0].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[1].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.colors[2].value,
          4293467747);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![0], 0.0);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![1], 0.5);
      expect(chart!.primaryXAxis.plotBands[0].gradient!.stops![2], 1.0);
    });
    test('to test primaryXAxis plotband gradient stops', () {
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[0]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[1]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .colors[2]
              .value,
          4293467747);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![0],
          0.0);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![1],
          0.5);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryYAxis.plotBands.length - 1]
              .gradient!
              .stops![2],
          1.0);
    });

    test('to test the plotband primaryXAxis horizontal alignment', () {
      expect(chart!.primaryXAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });
    test('to test the plotband primaryYAxis horizontal alignment', () {
      expect(chart!.primaryYAxis.plotBands[0].horizontalTextAlignment.index, 1);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .horizontalTextAlignment
              .index,
          1);
    });
    test('test the plotband primaryXAxis vertical alignment', () {
      expect(chart!.primaryXAxis.plotBands[0].verticalTextAlignment.index, 1);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .verticalTextAlignment
              .index,
          1);
    });
    testWidgets('charts - PlotBand visiblity', (WidgetTester tester) async {
      final _PlotBandAxis chartContainer =
          _plotBand('CategoryAxis Repeatation') as _PlotBandAxis;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryYAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].isRepeatable, true);
      expect(
          chart!.primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1].isRepeatable,
          true);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryXAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryXAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
    test('to test primaryXAxis plotband repeatable', () {
      expect(chart!.primaryYAxis.plotBands[0].shouldRenderAboveSeries, true);
      expect(
          chart!
              .primaryYAxis
              .plotBands[chart!.primaryXAxis.plotBands.length - 1]
              .shouldRenderAboveSeries,
          true);
    });
  });
}

StatelessWidget _plotBand(String sampleName) {
  return _PlotBandAxis(sampleName);
}

// ignore: must_be_immutable
class _PlotBandAxis extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PlotBandAxis(String sampleName) {
    chart = getAxisSample(sampleName);
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
