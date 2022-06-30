import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pyramid_sample.dart';

/// Test method of the pyramid chart.
void pyramidChart() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfPyramidChart? chart;
  // SfPyramidChartState? _chartState;
  // final List<PyramidData> funnelData = <PyramidData>[
  //   PyramidData('Walnuts', 654),
  //   PyramidData('Almonds', 575),
  //   PyramidData('Soybeans', 446),
  //   PyramidData('Black beans', 341),
  //   PyramidData('Mushrooms', 296),
  //   PyramidData('Avacado', 160),
  // ];

  // group('Pyramid - Series,', () {
  //   testWidgets('Pyramid sample', (WidgetTester tester) async {
  //     final PyramidData1 chartContainer =
  //         PyramidData('pyramid_chart_default_style') as PyramidData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     // _chartState = key.currentState as SfPyramidChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(
  //         _chartState!._chartSeries.visibleSeriesRenderers[0]._explodeDistance,
  //         78.0);
  //     expect(_chartState!._chartSeries.visibleSeriesRenderers[0]._seriesType,
  //         'pyramid');
  //   });
  // });

  // group('Pyramid - Series - Empty points', () {
  //   testWidgets('Pyramid sample', (WidgetTester tester) async {
  //     final PyramidData1 chartContainer =
  //         PyramidData('pyramid_chart_emptypoint_average') as PyramidData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfPyramidChartState?;
  //   });

  //   test('to test empty point mode average', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.average);
  //   });
  //   testWidgets('Pyramid sample', (WidgetTester tester) async {
  //     final PyramidData1 chartContainer =
  //         PyramidData('pyramid_chart_emptypoint_zero') as PyramidData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfPyramidChartState?;
  //   });

  //   test('to test empty point mode zero', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.zero);
  //   });
  //   testWidgets('Pyramid sample', (WidgetTester tester) async {
  //     final PyramidData1 chartContainer =
  //         PyramidData('pyramid_chart_emptypoint_default') as PyramidData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfPyramidChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.gap);
  //   });
  // });

  group('Pyramid - Series,', () {
    // testWidgets('Pyramid sample', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_chart_legend');
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    // final GlobalKey key = chart.key;
    // _chartState = key.currentState;
    // });

    // test('to test default values', () {

    //   expect(_chartState._chartSeries.visibleSeriesRenderers[0]._dataPoints.length, 6);
    //   expect(chart.legend.isVisible, true);
    //   expect(chart.legend.position, LegendPosition.auto);
    // });

    testWidgets('Pyramid sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_legend_position_left') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test legend position left', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.legend.isVisible, true);
      expect(chart!.legend.position, LegendPosition.left);
    });
  });

  group('Pyramid - Series,', () {
    testWidgets('Pyramid sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_tooltip') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.textAlignment, ChartAlignment.center);
    });

    // testWidgets('Pyramid sample', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_chart_animation') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfPyramidChartState?;
    // });

    // test('to test default values', () {
    //   expect(
    //       _chartState!
    //           ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
    //       6);
    //   // expect(chart.tooltipBehavior.enable, true);
    //   // expect(chart.tooltipBehavior.textAlignment, ChartAlignment.center);
    // });
  });

  // group('Pyramid - Series size,', () {
  //   testWidgets('chart tite sample', (WidgetTester tester) async {
  //     final PyramidData1 chartContainer =
  //         PyramidData('pyramid_chart_change_size') as PyramidData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfPyramidChartState?;
  //   });

  //   test('to test chart size', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.height, '50%');
  //     expect(_chartState!._chartSeries.currentSeries.width, '50%');
  //   });
  // });

  group('Pyramid - change gap,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_change_gap') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.series.gapRatio, 0.1);
      // expect(_chartState._chartSeries.currentSeries.neckWidth, '10%');
    });
  });

  group('Pyramid - Explode segment,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_explode_segments') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.series.explode, true);
      expect(chart!.series.explodeIndex, 2);
      expect(chart!.series.explodeOffset, '5%');
    });
  });

  group('Pyramid - smart labels,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_smart_datalabel_inside') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
  });

  group('Pyramid - smart labels,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_smart_datalabel_outside') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      //  expect(_chartState._chartSeries.visibleSeriesRenderers[0]._dataPoints.length, 6);
      // expect(chart.series.dataLabelSettings.isVisible, true);
      // expect(chart.series.dataLabelSettings.labelPosition, 'inside');
    });
  });

  group('Pyramid - data lable rect,', () {
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_dataLableArgs') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(milliseconds: 3));
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
      expect(chart!.series.dataLabelSettings.builder, null);
      expect(chart!.series.dataLabelSettings.color, Colors.red);
      expect(chart!.series.dataLabelSettings.borderWidth, 5);
    });
  });
  group('Pyramid - label_connect_type,', () {
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_datalable_connect_type') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
      // _chartState!._renderingDetails.isLegendToggled = true;
      await tester.pump(const Duration(milliseconds: 3));
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
      expect(chart!.series.dataLabelSettings.labelIntersectAction,
          LabelIntersectAction.shift);
      expect(chart!.series.dataLabelSettings.connectorLineSettings.type,
          ConnectorType.curve);
    });
  });
  group('Pyramid - onDataLabelRender,', () {
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_onDatalableRender') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
      // _chartState!._renderDataLabel!.state?.render();
    });
    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
  });
  group('Pyramid - point_color_mapper,', () {
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_point_color_mapper') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });
    test('to test default values', () async {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_datalabel_setting_builder') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    testWidgets('_drawRect', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_datalabel_position') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
      // _chartState!._renderingDetails.initialRender = false;
      // _chartState!._renderingDetails.widgetNeedUpdate = false;
      // _chartState!._renderingDetails.isLegendToggled = true;
      // _chartState._chartPlotArea._bindSeriesWidgets();
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    // testWidgets('_drawRect', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_datalabel_userSeriesColor') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   _chartState!._redraw();
    // });
    // test('to test default values', () {
    //   _chartState!.didUpdateWidget(SfPyramidChart(
    //     key: GlobalKey<State<SfPyramidChart>>(),
    //     series: PyramidSeries<PyramidData, String?>(
    //         dataSource: funnelData,
    //         xValueMapper: (PyramidData data, _) => data.x,
    //         yValueMapper: (PyramidData data, _) => data.y,
    //         dataLabelSettings: const DataLabelSettings(
    //           isVisible: true,
    //           textStyle: TextStyle(
    //             color: Colors.blue,
    //           ),
    //           labelPosition: ChartDataLabelPosition.outside,
    //         )),
    //   ));
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    testWidgets('pyramid', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_without_datasource') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    testWidgets('pyramid', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_without_animation') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    testWidgets('pyramid', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_interaction_doubletap') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
      // final Offset value = _getTouchPosition(
      //     _chartState!._chartSeries.visibleSeriesRenderers[0])!;
      // _chartState!._renderingDetails.explodedPoints = <int>[0, 1, 2, 3, 4, 5];
      // _chartState!._renderingDetails.selectionData = <int>[0];
      // _chartState!._chartPlotArea
      //     ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
      // _chartState!._chartPlotArea._onDoubleTap();
      await tester.pump(const Duration(seconds: 3));
    });
    test('to test default values', () {
      expect(chart!.series.dataLabelSettings.isVisible, true);
    });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_interaction_doubletap') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   _chartState!._renderingDetails.initialRender = false;
    //   _chartState!._renderingDetails.widgetNeedUpdate = false;
    //   _chartState!._renderingDetails.isLegendToggled = true;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._renderingDetails.explodedPoints = <int>[0, 1, 2, 3, 4, 5];
    //   _chartState!._renderingDetails.selectionData = <int>[0];
    //   _chartState!._chartPlotArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._chartPlotArea._onDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_interaction') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._renderingDetails.explodedPoints = <int>[0, 1, 2, 3, 4, 5];
    //   _chartState!._renderingDetails.selectionData = <int>[0];
    //   _chartState!._chartPlotArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._chartPlotArea._onDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });

    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_interaction_doubletap') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   _chartState!._chartPlotArea
    //       ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
    //   _chartState!._chartPlotArea._onDoubleTap();
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_interaction_longpress') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._chartPlotArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._chartPlotArea._onLongPress();
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_interaction_singletap') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._chartPlotArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._chartPlotArea
    //       ._onTapUp(PointerUpEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_singletap') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   final Offset value = _getTouchPosition(
    //       _chartState!._chartSeries.visibleSeriesRenderers[0])!;
    //   _chartState!._chartPlotArea
    //       ._onTapDown(PointerDownEvent(position: Offset(value.dx, value.dy)));
    //   _chartState!._chartPlotArea
    //       ._onTapUp(PointerUpEvent(position: Offset(value.dx, value.dy)));
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_series') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   _chartState!._renderingDetails.legendToggleStates =
    //       <_LegendRenderContext>[
    //     _LegendRenderContext(
    //         size: null,
    //         text: '',
    //         textSize: null,
    //         iconColor: null,
    //         iconType: LegendIconType.circle,
    //         point: null,
    //         isSelect: false,
    //         seriesIndex: 0,
    //         seriesRenderer: null)
    //   ];
    //   _chartState!._chartSeries._processDataPoints();
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
    // testWidgets('pyramid', (WidgetTester tester) async {
    //   final PyramidData1 chartContainer =
    //       PyramidData('pyramid_series_legend') as PyramidData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfPyramidChartState?;
    //   _chartState!._renderingDetails.legendToggleTemplateStates =
    //       <_MeasureWidgetContext>[
    //     _MeasureWidgetContext(
    //         context: null,
    //         key: null,
    //         widget: null,
    //         seriesIndex: null,
    //         pointIndex: 0)
    //   ];
    //   await tester.pump(const Duration(seconds: 3));
    // });
    // test('to test default values', () {
    //   expect(chart!.series.dataLabelSettings.isVisible, true);
    // });
  });

  group('Pyramid - pallete color,', () {
    testWidgets('pyramid series', (WidgetTester tester) async {
      final PyramidData1 chartContainer =
          PyramidData('pyramid_chart_palettecolor') as PyramidData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfPyramidChartState?;
    });

    test('to test default values', () {
      expect(chart!.palette.length, 3);
      expect(chart!.palette[1], Colors.orange);
      expect(chart!.palette[2], Colors.brown);
    });
  });
  testWidgets('pyramid series', (WidgetTester tester) async {
    final PyramidData1 chartContainer =
        PyramidData('pyramid_datalabel_collide') as PyramidData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfPyramidChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values', () {
    expect(chart!.series.dataLabelSettings.isVisible, true);
  });
  testWidgets('pyramid series', (WidgetTester tester) async {
    final PyramidData1 chartContainer =
        PyramidData('pyramid_datalabelrender_args') as PyramidData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfPyramidChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values', () {
    expect(chart!.onDataLabelRender == null, false);
  });
  testWidgets('pyramid series', (WidgetTester tester) async {
    final PyramidData1 chartContainer =
        PyramidData('pyramid_datalabel_zero') as PyramidData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfPyramidChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values', () {
    expect(chart!.series.dataLabelSettings.showZeroValue, true);
  });
}

/// Returns the pyramid data
// ignore: non_constant_identifier_names
StatelessWidget PyramidData(String sampleName) => PyramidData1(sampleName);

/// Represents the pyramid data
// ignore: must_be_immutable
class PyramidData1 extends StatelessWidget {
  /// Creates an instance of pyramid data
  // ignore: prefer_const_constructors_in_immutables
  PyramidData1(String sampleName) {
    chart = getPyramidSample(sampleName);
  }

  /// Holds the chart value
  SfPyramidChart? chart;
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
