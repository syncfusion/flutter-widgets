import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'stacked_doughnut_sample.dart';

/// Test method of the stacked doughnut series data label.
void stackedDoughnutDataLabel() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  group('Stacked Doughnut - Data Label', () {
    testWidgets('Accumulation Chart Widget - Testing Pie series with Datalabel',
        (WidgetTester tester) async {
      final _StackedDoughnutDataLabel chartContainer =
          _stackedDoughnutDataLabel('datalabel_default')
              as _StackedDoughnutDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test datalabel default', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0x00000000).value);
      expect(label.borderWidth, 0.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color, null);
      expect(label.labelIntersectAction, LabelIntersectAction.shift);
      expect(label.color, null);
    });

    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Customization',
        (WidgetTester tester) async {
      final _StackedDoughnutDataLabel chartContainer =
          _stackedDoughnutDataLabel('datalabel_customization')
              as _StackedDoughnutDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test datalabel properties', () {
      final DataLabelSettings label = chart!.series[0].dataLabelSettings;
      expect(label.borderColor.value, const Color(0xff000000).value);
      expect(label.borderWidth, 2.0);
      expect(label.connectorLineSettings.length, null);
      expect(label.connectorLineSettings.width, 1.0);
      expect(label.connectorLineSettings.color!.value,
          const Color(0xff000000).value);
      expect(label.borderRadius, 5);
      expect(label.color!.value, const Color(0xfff44336).value);
    });
    testWidgets(
        'Accumulation Chart Widget - Testing Pie series with Datalabel Mapper',
        (WidgetTester tester) async {
      final _StackedDoughnutDataLabel chartContainer =
          _stackedDoughnutDataLabel('datalabel_mapper')
              as _StackedDoughnutDataLabel;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    // test('test datalabel mapper', () {
    //   final List<ChartPoint<dynamic>> points =
    //       _chartState!._chartSeries.visibleSeriesRenderers[0]._renderPoints!;
    //   expect(chart!.series[0].opacity, 0.5);
    //   expect(points[0].text, 'India');
    //   expect(points[1].text, 'China');
    //   expect(points[2].text, 'USA');
    //   expect(points[3].text, 'Japan');
    //   expect(points[4].text, 'Russia');
    // });
  });
}

StatelessWidget _stackedDoughnutDataLabel(String sampleName) {
  return _StackedDoughnutDataLabel(sampleName);
}

// ignore: must_be_immutable
class _StackedDoughnutDataLabel extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _StackedDoughnutDataLabel(String sampleName) {
    chart = getStackedDoughnut(sampleName);
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
