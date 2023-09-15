import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'column_sample.dart';

/// Test method of the column series data label.
void columnDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Column - Data Label', () {
    testWidgets('Chart Widget - Testing Column Series with Data label',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_default') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, null);
      // expect(dataLabel.textStyle, isNotNull);
      expect(dataLabel.margin.left, 5.0);
      expect(dataLabel.margin.top, 5.0);
      expect(dataLabel.margin.right, 5.0);
      expect(dataLabel.margin.bottom, 5.0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
      expect(dataLabel.borderRadius, 5.0);
      expect(dataLabel.angle, 0);
    });

    testWidgets('Column Series with Data label template',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_template') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label default properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.builder, isNotNull);
      expect(dataLabel.margin.left, 5.0);
    });

    testWidgets(
        'Column Series with Data label template of bottom alignment with center chart alignment',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_template_bottom_with_center_alignment')
              as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
      await tester.pump(const Duration(seconds: 1));
    });

    // test(
    //     'to test data label template with bottom position and center alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 478);
    // });

    // testWidgets(
    //     'Column Series with Data label template of bottom alignment with near chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_bottom_with_near_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with bottom position and near alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 488);
    // });

    // testWidgets(
    //     'Column Series with Data label template of bottom alignment with far chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_bottom_with_far_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with bottom position and far alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 452);
    // });

    // testWidgets(
    //     'Column Series with Data label template of top alignment with center chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_top_with_center_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with top position and center alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 248);
    // });

    // testWidgets(
    //     'Column Series with Data label template of top alignment with near chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_top_with_near_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with top position and near alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 274);
    // });

    // testWidgets(
    //     'Column Series with Data label template of top alignment with far chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_top_with_far_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with top position and far alignment', () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 222);
    // });

    // testWidgets(
    //     'Column Series with Data label template of middle alignment with center chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_middle_with_center_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test(
    //     'to test data label template with middle position and center alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 361);
    // });

    // testWidgets(
    //     'Column Series with Data label template of middle alignment with near chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_middle_with_near_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with middle position and near alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 387);
    // });

    // testWidgets(
    //     'Column Series with Data label template of middle alignment with far chart alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_middle_with_far_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with middle position and far alignment',
    //     () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 335);
    // });

    // testWidgets('Column Series with Data label template of outer alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_outer_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with outer position', () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 206);
    // });

    // testWidgets('Column Series with Data label template of auto alignment',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_template_auto_alignment')
    //           as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    //   await tester.pump(const Duration(seconds: 1));
    // });

    // test('to test data label template with auto position', () {
    //   final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> point = seriesRenderer._dataPoints[0];
    //   expect(dataLabel.builder, isNotNull);
    //   expect(point.labelLocation!.x.toInt(), 73);
    //   expect(point.labelLocation!.y.toInt(), 206);
    // });

    testWidgets('Column Series with Data label template',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('series_visibility_dataLabel_template')
              as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label template with series visbility', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.builder, isNotNull);
      expect(dataLabel.margin.left, 5.0);
      expect(chart!.series[0].isVisible, false);
    });

    testWidgets(
        'Chart Widget - Testing Column Series with Data label customization',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_customization') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, Colors.red);
      // expect(dataLabel.textStyle.color, Colors.black);
      // expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.bottom);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 130);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 480);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 108);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // test('test last data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[seriesRenderer._dataPoints.length - 1];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 659);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 480);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 108);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    testWidgets(
        'Chart Widget - Testing Column Series with Mapping from Data Source',
        (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_mapping') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    // Measure text height and width
    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      // expect(dataLabel.textStyle.color, Colors.black);
      // expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    testWidgets('Chart Widget - dataLabel Auto', (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_auto') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      // expect(dataLabel.textStyle.color, Colors.black);
      // expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 0);
      expect(dataLabel.margin.left, 0);
      expect(dataLabel.margin.top, 0);
      expect(dataLabel.margin.right, 0);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.auto);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });
    testWidgets('Chart Widget - dataLabel Outer', (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_outer') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, Colors.red);
      // expect(dataLabel.textStyle.color, Colors.black);
      // expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.outer);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 208);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // test('test last data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[seriesRenderer._dataPoints.length - 1];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 693);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Column series dataLabel outer with alignment as near ',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_outer_near') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 232);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Column series dataLabel middle with point color mapping',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_pointColor') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 85);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 362);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Column series dataLabel middle with series color',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_series_color') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 39);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 437);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    testWidgets('Chart Widget - Data Label Top', (WidgetTester tester) async {
      final _ColumnDataLabel chartContainer =
          _columnDataLabel('dataLabel_top') as _ColumnDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCartesianChartState?;
    });

    test('to test data label customized properties', () {
      final DataLabelSettings dataLabel = chart!.series[0].dataLabelSettings!;
      expect(dataLabel.isVisible, true);
      expect(dataLabel.color, Colors.red);
      // expect(dataLabel.textStyle.color, Colors.black);
      // expect(dataLabel.textStyle.fontSize, 12);
      expect(dataLabel.margin.bottom, 5);
      expect(dataLabel.margin.left, 5);
      expect(dataLabel.margin.top, 5);
      expect(dataLabel.margin.right, 5);
      expect(dataLabel.opacity, 1.0);
      expect(dataLabel.labelAlignment, ChartDataLabelAlignment.top);
      expect(dataLabel.borderRadius, 10.0);
      expect(dataLabel.angle, 0);
    });

    // testWidgets('Chart Widget - Data Label Location with Inversed Axis',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_inversed') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 693);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 281);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // test('test last data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[seriesRenderer._dataPoints.length - 1];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 465);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Column series dataLabel top with alignment as far ',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_top_far') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 96);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 224);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Chart Widget - Data Label Location with Opposed',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_opposed') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 62);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 230);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // test('test last data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[seriesRenderer._dataPoints.length - 1];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 659);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 46);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // testWidgets('Chart Widget - Data Label Location with transposed',
    //     (WidgetTester tester) async {
    //   final _ColumnDataLabel chartContainer =
    //       _columnDataLabel('dataLabel_transpose') as _ColumnDataLabel;
    //   await tester.pumpWidget(chartContainer);
    //   chart = chartContainer.chart;
    //   final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
    //   _chartState = key.currentState as SfCartesianChartState?;
    // });

    // test('test first data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[0];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 468);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 445);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });

    // test('test last data label region', () {
    //   final CartesianSeriesRenderer seriesRenderer =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0];
    //   final CartesianChartPoint<dynamic> dataPoints =
    //       seriesRenderer._dataPoints[seriesRenderer._dataPoints.length - 1];
    //   expect(dataPoints.dataLabelRegion!.left.toInt(), 724);
    //   expect(dataPoints.dataLabelRegion!.top.toInt(), 44);
    //   expect(dataPoints.dataLabelRegion!.width.toInt(), 24);
    //   expect(dataPoints.dataLabelRegion!.height.toInt(), 12);
    // });
  });
}

StatelessWidget _columnDataLabel(String sampleName) {
  return _ColumnDataLabel(sampleName);
}

// ignore: must_be_immutable
class _ColumnDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ColumnDataLabel(String sampleName) {
    chart = getColumnchart(sampleName);
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
