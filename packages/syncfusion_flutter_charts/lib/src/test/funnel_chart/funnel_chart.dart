import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'funnel_sample.dart';

/// Test method of funnel chart.
void funnelChart() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfFunnelChart? chart;

  // group('Funnel - Series,', () {
  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_default_style') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
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
  //         'funnel');
  //   });
  // });

  // group('Funnel - Series - Empty points', () {
  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_emptypoint_zero') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test empty points mode zero', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.zero);
  //   });

  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_emptypoint_average') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test empty points mode average', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.average);
  //   });

  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_emptypoint_default') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test empty points mode default', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.emptyPointSettings.mode,
  //         EmptyPointMode.gap);
  //   });
  // });

  group('Funnel - Series,', () {
    testWidgets('Funnelsample', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_chart_legend') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
    });

    test('to test default values', () {
      expect(chart!.legend.isVisible, true);
      expect(chart!.legend.position, LegendPosition.auto);
    });

    testWidgets('Funnelsample', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_chart_legend_position_left') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
    });

    test('to test default values', () {
      expect(chart!.legend.isVisible, true);
      expect(chart!.legend.position, LegendPosition.left);
    });
  });

  group('Funnel - Series,', () {
    testWidgets('Funnelsample', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_chart_tooltip') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
      // _chartState!._funnelplotArea
      //     ._onTapDown(const PointerDownEvent(position: Offset(189, 192)));
      // _chartState!._funnelplotArea
      //     ._onTapUp(const PointerUpEvent(position: Offset(189, 192)));
      await tester.pump(const Duration(seconds: 3));
    });

    test('to test default values', () {
      // expect(
      //     _chartState!
      //         ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
      //     6);
      expect(chart!.tooltipBehavior.enable, true);
      expect(chart!.tooltipBehavior.textAlignment, ChartAlignment.center);
    });

    // testWidgets('Funnelsample', (WidgetTester tester) async {
    //   final _FunnelData1 chartContainer =
    //       _funnelData('funnel_chart_animation') as _FunnelData1;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfFunnelChartState?;
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

  // group('Funnel - Series size,', () {
  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_change_size') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
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

  // group('Funnel - neck size,', () {
  //   testWidgets('Funnel sample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_change_neck_size') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(_chartState!._chartSeries.currentSeries.neckHeight, '40%');
  //     expect(_chartState!._chartSeries.currentSeries.neckWidth, '10%');
  //   });
  // });

  // group('Funnel - change gap,', () {
  //   testWidgets('Funnelsample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_change_gap') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     expect(chart!.series.gapRatio, 0.1);
  //     // expect(_chartState._chartSeries.currentSeries.neckWidth, '10%');
  //   });
  // });

  group('Funnel - Explode segment,', () {
    testWidgets('Funnel sample', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_chart_explode_segments') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
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

  // group('Funnel - smart labels,', () {
  //   testWidgets('funnel sample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_smart_datalabel_inside') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     // expect(_chartState._chartSeries.currentSeries.neckHeight, '40%');
  //     // expect(_chartState._chartSeries.currentSeries.neckWidth, '10%');
  //   });

  //   testWidgets('Funnel sample', (WidgetTester tester) async {
  //     final _FunnelData1 chartContainer =
  //         _funnelData('funnel_chart_smart_datalabel_outside') as _FunnelData1;
  //     await tester.pumpWidget(chartContainer);
  //     chart = chartContainer.chart;
  //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //     _chartState = key.currentState as SfFunnelChartState?;
  //   });

  //   test('to test default values', () {
  //     expect(
  //         _chartState!
  //             ._chartSeries.visibleSeriesRenderers[0]._dataPoints.length,
  //         6);
  //     // expect(_chartState._chartSeries.currentSeries.neckHeight, '40%');
  //     // expect(_chartState._chartSeries.currentSeries.neckWidth, '10%');
  //   });
  // });

  group('Funnel - pallete color,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_chart_palettecolor') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
    });

    test('to test default values', () {
      expect(chart!.palette.length, 3);
      expect(chart!.palette[1], Colors.orange);
      expect(chart!.palette[2], Colors.brown);
    });
  });
  group('Funnel -datalabel renderer,', () {
    testWidgets('funnel chart datalabel', (WidgetTester tester) async {
      final _FunnelData1 chartContainer =
          _funnelData('funnel_datalabel') as _FunnelData1;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfFunnelChartState?;
      await tester.pump(const Duration(seconds: 3));
    });

    test('to datalabel render', () {
      expect(chart!.legend.isVisible, false);
    });
  });
  testWidgets('funnel series-collide', (WidgetTester tester) async {
    final _FunnelData1 chartContainer =
        _funnelData('funnel_datalabel_collide') as _FunnelData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfFunnelChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values collide', () {
    expect(chart!.series.dataLabelSettings.isVisible, true);
  });
  testWidgets('funnel series', (WidgetTester tester) async {
    final _FunnelData1 chartContainer =
        _funnelData('funnel_datalabelrender_args') as _FunnelData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfFunnelChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values outside label', () {
    expect(chart!.onDataLabelRender == null, false);
  });
  testWidgets('funnel series', (WidgetTester tester) async {
    final _FunnelData1 chartContainer =
        _funnelData('funnel_datalabel_zero') as _FunnelData1;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfFunnelChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test default values', () {
    expect(chart!.series.dataLabelSettings.showZeroValue, true);
  });
}

StatelessWidget _funnelData(String sampleName) {
  return _FunnelData1(sampleName);
}

// ignore: must_be_immutable
class _FunnelData1 extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _FunnelData1(String sampleName) {
    chart = getFunnelSample(sampleName);
  }
  SfFunnelChart? chart;
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
