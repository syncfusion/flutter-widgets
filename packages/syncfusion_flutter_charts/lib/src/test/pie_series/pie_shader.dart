import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'pie_sample.dart';

/// Testing method of pyramid chart`s legend and all its functionalities.
void pieShader() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  //ignore: unused_local_variable
  SfCircularChartState? chartState;

  group('Pie Shader', () {
    testWidgets('Pie chart - shader properties', (WidgetTester tester) async {
      final _PieShader chartContainer =
          _pieShader('pie_renderMode') as _PieShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test pie point rendermode', () {
      expect(chart!.series[0].pointRenderMode, PointRenderMode.gradient);
    });

    testWidgets('Pie chart - shader properties', (WidgetTester tester) async {
      final _PieShader chartContainer = _pieShader('pie_shader') as _PieShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test pie shader', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('Pie chart - shader properties with border',
        (WidgetTester tester) async {
      final _PieShader chartContainer =
          _pieShader('pie_shaderwithborder') as _PieShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test pie shader with border', () {
      expect(chart!.onCreateShader != null, true);
    });

    test('test pie point rendermode', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('Pie chart - pointshader ', (WidgetTester tester) async {
      final _PieShader chartContainer =
          _pieShader('pie_pointshader') as _PieShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test pie point shader mapper', () {
      expect(chart!.onCreateShader == null, true);
    });
  });
}

StatelessWidget _pieShader(String sampleName) {
  return _PieShader(sampleName);
}

// ignore: must_be_immutable
class _PieShader extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PieShader(String sampleName) {
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
