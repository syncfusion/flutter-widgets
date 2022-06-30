import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'legend_sample.dart';

/// Test method of legend.
void legend() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  // SfCartesianChartState? _chartState;
  group('Chart Legend', () {
    // testWidgets('Chart Widget -Default Legend', (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('default') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test default values', () {
    //   final Legend legend = chart!.legend;
    //   final LegendRenderer legendRenderer =
    //       _chartState!._renderingDetails.legendRenderer;
    //   expect(legend.backgroundColor, null);
    //   expect(legend.borderColor, const Color(0x00000000));
    //   expect(legend.height, null);
    //   expect(legend.iconBorderColor, const Color(0x00000000));
    //   expect(legend.iconBorderWidth.toInt(), 0);
    //   expect(legend.iconHeight, 12);
    //   expect(legend.iconWidth, 12);
    //   expect(legend.isResponsive, false);
    //   expect(legend.itemPadding.toInt(), 15);
    //   expect(legend.orientation, LegendItemOrientation.auto);
    //   expect(legendRenderer._legendPosition, LegendPosition.bottom);
    //   expect(legend.opacity.toInt(), 1);
    //   expect(legend.orientation, LegendItemOrientation.auto);
    //   expect(legend.overflowMode, LegendItemOverflowMode.scroll);
    //   expect(legend.toggleSeriesVisibility, true);
    //   expect(legend.isVisible, true);
    //   expect(legend.width, null);
    //   expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 780);
    //   expect(axisRect.bottom.toInt(), 469);
    // });

    testWidgets('Legend Customization', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legend_template') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test customized values', () {
      final Legend legend = chart!.legend;
      expect(legend.isVisible, true);
      expect(legend.position, LegendPosition.auto);
      expect(legend.iconHeight, 12.0);
      expect(legend.iconWidth, 12.0);
      expect(legend.alignment, ChartAlignment.center);
      expect(legend.borderWidth, 0.0);
    });

    testWidgets('Legend Customization', (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('toggleSeriesVisibility') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test toggleSeriesVisibility', () {
      final Legend legend = chart!.legend;
      expect(legend.isVisible, true);
      expect(legend.toggleSeriesVisibility, false);
    });

    testWidgets('Legend Customization', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('IsVisibleInLegend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test IsVisibleInLegend', () {
      final Legend legend = chart!.legend;
      final LineSeries<LegendSample1, int?> lSeries =
          chart!.series[1] as LineSeries<LegendSample1, int?>;
      expect(legend.isVisible, true);
      expect(lSeries.isVisibleInLegend, true);
    });

    // testWidgets('Legend Customization', (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('onLegendItemRender') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test onLegendItemRender', () {
    //   final _ChartLegend cLegend = _chartState!._renderingDetails.chartLegend;
    //   final _LegendRenderContext lContext = cLegend.legendCollections![0];
    //   expect(lContext.iconType, LegendIconType.diamond);
    //   expect(lContext.text, 'Legend Text'); //
    // });
    // testWidgets('Legend With Horizantal orientation',
    //     (WidgetTester tester) async {
    //   final _Legend chartContainer =
    //       _legend('legend_horizontalOrientation') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });
    // test('to test orientation and position', () {
    //   expect(_chartState!._renderingDetails.chartLegend.legend!.orientation,
    //       LegendItemOrientation.horizontal);
    //   expect(_chartState!._renderingDetails.chartLegend.legend!.height, '120');
    //   expect(_chartState!._renderingDetails.chartLegend.legend!.width, '100');
    // });

    testWidgets('Chart Widget -Customized Legend', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('customization') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
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
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 593);
    //   expect(axisRect.bottom.toInt(), 502);
    // });

    // testWidgets('Chart Widget - Without Series Name',
    //     (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('withoutSeriesName') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 619);
    //   expect(axisRect.bottom.toInt(), 502);
    //   expect(label.left.toInt(), 26);
    //   expect(label.top.toInt(), 226);
    //   expect(label.bottom.toInt(), 242);
    //   expect(label.right.toInt(), 42);
    // });

    // testWidgets('Chart Widget - With Series Name and Legend Text',
    //     (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('withSeriesLegendName') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 567);
    //   expect(axisRect.bottom.toInt(), 502);
    //   expect(label.left.toInt(), 26);
    //   expect(label.top.toInt(), 226);
    //   expect(label.bottom.toInt(), 242);
    //   expect(label.right.toInt(), 42);
    // });

    // testWidgets('Chart Widget - With Legend Text', (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('withLegendName') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   final CartesianSeriesRenderer cartesianSeriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 567);
    //   expect(axisRect.bottom.toInt(), 502);
    //   expect(label.left.toInt(), 26);
    //   expect(label.top.toInt(), 226);
    //   expect(label.bottom.toInt(), 242);
    //   expect(label.right.toInt(), 42);
    // });
    group('Cartesain legend - Legend icon as Marker Shape -', () {
      testWidgets('Legend Triangle icon', (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_triangleMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.triangle);
        expect(series.legendIconType, LegendIconType.seriesType);
      });
      testWidgets('Legend Circle icon', (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_circleMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.circle);
      });
      testWidgets('Legend pentagon icon', (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_pentagonMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.pentagon);
      });
      testWidgets('Legend rentangle icon ', (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_rectangleMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.rectangle);
      });
      testWidgets('Legend inverted triangle icon ',
          (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_invertedTriangleMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.invertedTriangle);
      });
      testWidgets('Legend horizontal line icon ', (WidgetTester tester) async {
        final _Legend chartContainer = _legend('legend_HLineMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.horizontalLine);
      });
      testWidgets('Legend vertical line icon ', (WidgetTester tester) async {
        final _Legend chartContainer = _legend('legend_VLineMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.verticalLine);
      });
      testWidgets('Legend diamond icon ', (WidgetTester tester) async {
        final _Legend chartContainer =
            _legend('legend_diamondMarker') as _Legend;
        await tester.pumpWidget(chartContainer);
        chart = chartContainer.chart;
        // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
        // _chartState = key.currentState as SfCartesianChartState?;
      });

      test('to test shape', () {
        final CartesianSeries<dynamic, dynamic> series =
            chart!.series[0] as CartesianSeries<dynamic, dynamic>;
        expect(series.markerSettings.shape, DataMarkerType.diamond);
      });
    });
    testWidgets('Legend line with marker ', (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('legend_line_with_Marker_shape') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      final CartesianSeries<dynamic, dynamic> series =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      expect(series.markerSettings.shape, DataMarkerType.triangle);
    });
    testWidgets('Legend dashed line with marker ', (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('legend_dashLine_with_Marker_shape') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      final CartesianSeries<dynamic, dynamic> series =
          chart!.series[0] as CartesianSeries<dynamic, dynamic>;
      expect(series.markerSettings.shape, DataMarkerType.circle);
    });
    testWidgets('Chart Widget - Legend alignment near -',
        (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendAlignment_near') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test alignment', () {
      expect(chart!.legend.alignment, ChartAlignment.near);
    });

    testWidgets('Chart Widget - Legend alignment far -',
        (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendAlignment_far') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test alignment', () {
      expect(chart!.legend.alignment, ChartAlignment.far);
    });

    testWidgets('Chart Widget - Legend alignment center -',
        (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('legendAlignment_center') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test alignment', () {
      expect(chart!.legend.alignment, ChartAlignment.center);
    });

    testWidgets('Chart Widget - Legend title alignment -',
        (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('legend_titleAlignment') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });
    test('to test title alignment', () {
      expect(chart!.legend.title.alignment, ChartAlignment.near);
    });

    testWidgets('Chart Widget - Legend Left', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('left') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 593);
    //   expect(axisRect.bottom.toInt(), 502);
    // });

    // testWidgets('Chart Widget - Legend Top', (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('top') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   // _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 780);
    //   expect(axisRect.bottom.toInt(), 464);
    // });

    // testWidgets('Chart Widget - Legend Right', (WidgetTester tester) async {
    //   final _Legend chartContainer = _legend('right') as _Legend;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('to test primaryXAxis labels', () {
    //   final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //   expect(axisRect.left.toInt(), 34);
    //   expect(axisRect.top.toInt(), 0);
    //   expect(axisRect.right.toInt(), 593);
    //   expect(axisRect.bottom.toInt(), 502);
    // });

    //   testWidgets('Legend With Multiple Series', (WidgetTester tester) async {
    //     final _Legend chartContainer = _legend('multipleSeries') as _Legend;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //     expect(axisRect.left.toInt(), 58);
    //     expect(axisRect.top.toInt(), 0);
    //     expect(axisRect.right.toInt(), 580);
    //     expect(axisRect.bottom.toInt(), 502);
    //     expect(label.left.toInt(), 50);
    //     expect(label.top.toInt(), 477);
    //     expect(label.bottom.toInt(), 493);
    //     expect(label.right.toInt(), 66);
    //   });
    //   testWidgets('Legend With Multiple Series- Scrollable',
    //       (WidgetTester tester) async {
    //     final _Legend chartContainer = _legend('legendScrollable') as _Legend;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //     expect(axisRect.left.toInt(), 58);
    //     expect(axisRect.top.toInt(), 0);
    //     expect(axisRect.right.toInt(), 580);
    //     expect(axisRect.bottom.toInt(), 502);
    //     expect(label.left.toInt(), 50);
    //     expect(label.top.toInt(), 477);
    //     expect(label.bottom.toInt(), 493);
    //     expect(label.right.toInt(), 66);
    //   });

    //   testWidgets('Legend With Multiple Series', (WidgetTester tester) async {
    //     final _Legend chartContainer =
    //         _legend('multipleSeries_overflow') as _Legend;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //   });

    //   test('to test primaryXAxis labels', () {
    //     final Rect axisRect = _chartState!._chartAxis._axisClipRect;
    //     final CartesianSeriesRenderer cartesianSeriesRenderer =
    //         _chartState!._chartSeries.visibleSeriesRenderers[0];
    //     final Rect label = cartesianSeriesRenderer._dataPoints[0].region!;
    //     expect(axisRect.left.toInt(), 58);
    //     expect(axisRect.top.toInt(), 0);
    //     expect(axisRect.right.toInt(), 580);
    //     expect(axisRect.bottom.toInt(), 502);
    //     expect(label.left.toInt(), 50);
    //     expect(label.top.toInt(), 477);
    //     expect(label.bottom.toInt(), 493);
    //     expect(label.right.toInt(), 66);
    //   });

    //   testWidgets('Legend Item Builder', (WidgetTester tester) async {
    //     final _Legend chartContainer = _legend('legend_itemBuilder') as _Legend;
    //     await tester.pumpWidget(chartContainer);
    //     chart = chartContainer.chart;
    //     final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //     _chartState = key.currentState as SfCartesianChartState?;
    //     await tester.pump(const Duration(seconds: 3));
    //   });

    //   test('to test legendItemBuilder', () {
    //     expect(_chartState!._renderingDetails.chartLegend.legend!.iconHeight, 12);
    //     expect(_chartState!._renderingDetails.chartLegend.legend!.iconWidth, 12);
    //     expect(_chartState!._renderingDetails.chartLegend.legendSize,
    //         const Size(110.0, 45.0));
    //   });
  });

  group('Cartesain legend - Legend Shape', () {
    testWidgets('Legend Circle', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendCircle') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.circle);
    });

    testWidgets('Legend Diamond', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendDiamond') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.diamond);
    });

    testWidgets('Legend horizontalLine', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendHLine') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.horizontalLine);
    });

    testWidgets('Legend invertedTriangle', (WidgetTester tester) async {
      final _Legend chartContainer =
          _legend('legendInvertedTriangle') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.invertedTriangle);
    });

    testWidgets('Legend pentagon', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendpentagon') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.pentagon);
    });

    testWidgets('Legend rectangle', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendrectangle') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.rectangle);
    });

    testWidgets('Legend triangle', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendtriangle') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.triangle);
    });

    testWidgets('Legend verticalLine', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('legendverticalLine') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.verticalLine);
    });
  });
  group('Cartesain Series Types -', () {
    testWidgets('Various cartesian series_spline', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('spline_legend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test spline shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Various cartesian series_bar', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('bar_legend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test bar shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Various cartesian series_area', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('area_legend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test area shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Various cartesian series_stepLine',
        (WidgetTester tester) async {
      final _Legend chartContainer = _legend('stepLine_legend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test step line shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });

    testWidgets('Various cartesian series_bubble', (WidgetTester tester) async {
      final _Legend chartContainer = _legend('bubble_legend') as _Legend;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test bubble shape', () {
      expect(chart!.series[0].legendIconType, LegendIconType.seriesType);
    });
  });

  // testWidgets('Gradient and scatter series with image',
  //     (WidgetTester tester) async {
  //   final _Legend chartContainer = _legend('legend_vertical') as _Legend;
  //   await tester.pumpWidget(chartContainer);
  //   chart = chartContainer.chart;
  //   // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
  //   // _chartState = key.currentState as SfCartesianChartState?;
  //   await tester.pump(const Duration(seconds: 3));
  // });

  // test('to test orientation', () {
  //   expect(_chartState!._renderingDetails.chartLegend.legend!.orientation,
  //       LegendItemOrientation.vertical);
  // });

  testWidgets('Gradient and scatter series with image',
      (WidgetTester tester) async {
    final _Legend chartContainer = _legend('gradient') as _Legend;
    await tester.pumpWidget(chartContainer);
    chart = chartContainer.chart;
    // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    // _chartState = key.currentState as SfCartesianChartState?;
    await tester.pump(const Duration(seconds: 3));
  });

  test('to test gradient', () {
    final RangeColumnSeries<OrdinalSales, dynamic> rangeSeries =
        chart!.series[0] as RangeColumnSeries<OrdinalSales, dynamic>;
    expect(rangeSeries.gradient!.colors[0], Colors.blue);
    expect(rangeSeries.gradient!.colors[1], Colors.red);
    expect(rangeSeries.gradient!.colors[2], Colors.yellow);
  });
}

//ignore: unused_element
StatelessWidget _legend(String sampleName) {
  return _Legend(sampleName);
}

// ignore: must_be_immutable
class _Legend extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Legend(String sampleName) {
    chart = getLegendchart(sampleName);
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
