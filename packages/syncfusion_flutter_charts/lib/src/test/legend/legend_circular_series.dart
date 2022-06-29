import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'legend_sample.dart';

/// Test method of legend in circular series.
void legendCircularSeries() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  group('Chart Legend', () {
    testWidgets('Chart Widget -Default Legend', (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('accumulationLegend') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('to test default values', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor, null);
      expect(legend.borderColor, const Color(0x00000000));
      expect(legend.height, null);
      expect(legend.iconBorderColor, const Color(0x00000000));
      expect(legend.iconBorderWidth.toInt(), 0);
      expect(legend.iconHeight, 12);
      expect(legend.iconWidth, 12);
      expect(legend.isResponsive, false);
      expect(legend.itemPadding.toInt(), 15);
      expect(legend.position, LegendPosition.auto);
      expect(legend.opacity.toInt(), 1);
      expect(legend.orientation, LegendItemOrientation.auto);
      expect(legend.overflowMode, LegendItemOverflowMode.scroll);
      expect(legend.toggleSeriesVisibility, true);
      expect(legend.isVisible, true);
      expect(legend.width, null);
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Legend Customization', (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('legend_template') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    // test('to test customized values', () {
    //   final Legend legend = chart!.legend;
    //   final LegendRenderer legendRenderer =
    //       _chartState!._renderingDetails.legendRenderer;
    //   expect(legend.isVisible, true);
    //   expect(legend.position, LegendPosition.auto);
    //   expect(legendRenderer._legendPosition, LegendPosition.right);
    //   expect(legend.iconHeight, 12.0);
    //   expect(legend.iconWidth, 12.0);
    //   expect(legend.alignment, ChartAlignment.center);
    //   expect(legend.borderWidth, 0.0);
    // });
    testWidgets('Legend Customization', (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('accumulationLegend_customization')
              as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('to test customized values', () {
      final Legend legend = chart!.legend;
      expect(legend.backgroundColor, Colors.red);
      expect(legend.borderColor, Colors.black);
      expect(legend.borderWidth, 1);
      expect(legend.height, '150');
      expect(legend.iconBorderColor, Colors.orange);
      expect(legend.iconBorderWidth.toInt(), 2);
      expect(legend.iconHeight, 12);
      expect(legend.iconWidth, 12);
      expect(legend.isResponsive, true);
      expect(legend.itemPadding.toInt(), 15);
      expect(legend.opacity, 0.5);
      expect(legend.orientation, LegendItemOrientation.vertical);
      expect(legend.overflowMode, LegendItemOverflowMode.wrap);
      expect(legend.toggleSeriesVisibility, true);
      expect(legend.isVisible, true);
      expect(legend.width, '250');
    });

    // test('to test first slice', () {
    //   final ChartPoint<dynamic> point =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(point.startAngle!.toInt(), -90);
    //   expect(point.endAngle!.toInt(), -37);
    //   expect(point.midAngle!.toInt(), -63);
    //   expect(point.outerRadius!.toInt(), 184);
    // });

    // testWidgets('Legend Customization', (WidgetTester tester) async {
    //   final _LegendCircular chartContainer =
    //       _legendCircular('onLegendItemRender') as _LegendCircular;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });

    // test('to test onLegendItemRender', () {
    //   final _ChartLegend cLegend = _chartState!._renderingDetails.chartLegend;
    //   final _LegendRenderContext lContext = cLegend.legendCollections![0];
    //   expect(lContext.iconType, LegendIconType.diamond);
    //   expect(lContext.text, 'Legend Text'); //
    // });
  });

  group('Legend Position', () {
    testWidgets('Bottom', (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('legend_bottom') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });
    // test('to test first slice', () {
    //   final ChartPoint<dynamic> point =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(point.startAngle!.toInt(), -90);
    //   expect(point.endAngle!.toInt(), -37);
    //   expect(point.midAngle!.toInt(), -63);
    //   expect(point.outerRadius!.toInt(), 190);
    // });

    testWidgets('Bottom', (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('toggleSeriesVisibility') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });
    test('to test toggleSeriesVisibility', () {
      expect(chart!.legend.toggleSeriesVisibility, false);
    });

    // testWidgets('Left', (WidgetTester tester) async {
    //   final _LegendCircular chartContainer =
    //       _legendCircular('legend_left') as _LegendCircular;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });
    // test('to test default values', () {
    //   final ChartPoint<dynamic> point =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(point.startAngle!.toInt(), -90);
    //   expect(point.endAngle!.toInt(), -37);
    //   expect(point.midAngle!.toInt(), -63);
    //   expect(point.outerRadius!.toInt(), 201);
    // });

    // testWidgets('Top', (WidgetTester tester) async {
    //   final _LegendCircular chartContainer =
    //       _legendCircular('legend_top') as _LegendCircular;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });
    // test('to test default values', () {
    //   final ChartPoint<dynamic> point =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(point.startAngle!.toInt(), -90);
    //   expect(point.endAngle!.toInt(), -37);
    //   expect(point.midAngle!.toInt(), -63);
    //   expect(point.outerRadius!.toInt(), 190);
    // });

    // testWidgets('Auto', (WidgetTester tester) async {
    //   final _LegendCircular chartContainer =
    //       _legendCircular('legend_auto') as _LegendCircular;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCircularChartState?;
    // });
    // test('to test default values', () {
    //   final ChartPoint<dynamic> point =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints![0];
    //   expect(point.startAngle!.toInt(), -90);
    //   expect(point.endAngle!.toInt(), -37);
    //   expect(point.midAngle!.toInt(), -63);
    //   expect(point.outerRadius!.toInt(), 201);
    // });
  });

  group('Circular Series Types -', () {
    testWidgets('Various circular series_doughnut',
        (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('doughnut_legend') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('to test doughnut shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Various circular series_radialbar',
        (WidgetTester tester) async {
      final _LegendCircular chartContainer =
          _legendCircular('radialbar_legend') as _LegendCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('to test radialbar shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });
  });
}

//ignore: unused_element
StatelessWidget _legendCircular(String sampleName) {
  return _LegendCircular(sampleName);
}

// ignore: must_be_immutable
class _LegendCircular extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _LegendCircular(String sampleName) {
    chart = getAccumulationChart(sampleName);
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
