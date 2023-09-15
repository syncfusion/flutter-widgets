import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'chart_theme_sample.dart';

/// Test method of the theme customization in charts.
void chartThemeCustomization() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;
  group('Chart Theme', () {
    testWidgets('Chart Widget - Customized Theme', (WidgetTester tester) async {
      final _ChartThemeCustomization chartContainer =
          _chartThemeCustomization('default') as _ChartThemeCustomization;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });
    test('Test customized theme', () {
      expect(chart, chart);
      // expect(
      //     chart!.title.textStyle.color!.value, const Color(0xfff44336).value);
      // expect(chart!.primaryXAxis.labelStyle.color!.value,
      //     const Color(0xff4caf50).value);
      // expect(chart!.primaryYAxis.labelStyle.color!.value,
      //     const Color(0xff4caf50).value);
      expect(chart!.primaryXAxis.axisLine.color!.value,
          const Color(0xff3f51b5).value);
      expect(chart!.primaryYAxis.axisLine.color!.value,
          const Color(0xff3f51b5).value);
      expect(chart!.primaryXAxis.majorGridLines.color!.value,
          const Color(0xffff5722).value);
      expect(chart!.primaryXAxis.majorTickLines.color!.value,
          const Color(0xff673ab7).value);
      expect(chart!.primaryXAxis.minorGridLines.color!.value,
          const Color(0xff673ab7).value);
      expect(chart!.primaryXAxis.minorTickLines.color!.value,
          const Color(0xff673ab7).value);
      expect(chart!.primaryYAxis.majorGridLines.color!.value,
          const Color(0xffff5722).value);
      expect(chart!.primaryYAxis.majorTickLines.color!.value,
          const Color(0xff673ab7).value);
      expect(chart!.primaryYAxis.minorGridLines.color!.value,
          const Color(0xff673ab7).value);
      expect(chart!.primaryYAxis.minorTickLines.color!.value,
          const Color(0xff673ab7).value);
      // expect(
      //     chart!.title.textStyle.color!.value, const Color(0xfff44336).value);
      expect(
          chart!.title.backgroundColor!.value, const Color(0xffff5722).value);
      expect(
          chart!.legend.backgroundColor!.value, const Color(0xfff44336).value);
      expect(
          chart!.plotAreaBackgroundColor!.value, const Color(0xff9e9e9e).value);
      expect(chart!.crosshairBehavior.lineColor!.value,
          const Color(0xff4caf50).value);
      expect(chart!.series[0].selectionBehavior!.selectedColor!.value,
          const Color(0xffff9800).value);
    });
  });
}

StatelessWidget _chartThemeCustomization(String sampleName) {
  return _ChartThemeCustomization(sampleName);
}

// ignore: must_be_immutable
class _ChartThemeCustomization extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ChartThemeCustomization(String sampleName) {
    chart = getThemechart(sampleName);
  }
  SfCartesianChart? chart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
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
