import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'doughnut_sample.dart';

/// Testing method of pyramid chart`s legend and all its functionalities.
void doughnutShader() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  //ignore: unused_local_variable
  SfCircularChartState? chartState;

  group('Doughnut Shader', () {
    testWidgets('Doughnut chart - shader properties',
        (WidgetTester tester) async {
      final _DoughnutShader chartContainer =
          _doughnutShader('doughnut_renderMode') as _DoughnutShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test Doughnut point rendermode', () {
      expect(chart!.series[0].pointRenderMode, PointRenderMode.gradient);
    });

    testWidgets('Doughnut chart - shader properties',
        (WidgetTester tester) async {
      final _DoughnutShader chartContainer =
          _doughnutShader('doughnut_shader') as _DoughnutShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test Doughnut shader', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('Doughnut chart - shader properties with border',
        (WidgetTester tester) async {
      final _DoughnutShader chartContainer =
          _doughnutShader('doughnut_shaderwithborder') as _DoughnutShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test doughnut shader with border', () {
      expect(chart!.onCreateShader != null, true);
    });

    test('test doughnut point rendermode', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('Doughnut chart - pointshader ', (WidgetTester tester) async {
      final _DoughnutShader chartContainer =
          _doughnutShader('doughnut_pointshader') as _DoughnutShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      chartState = key.currentState as SfCircularChartState?;
    });

    test('test Doughnut point shader mapper', () {
      expect(chart!.onCreateShader == null, true);
    });
  });
}

StatelessWidget _doughnutShader(String sampleName) {
  return _DoughnutShader(sampleName);
}

// ignore: must_be_immutable
class _DoughnutShader extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DoughnutShader(String sampleName) {
    chart = getDoughnutchart(sampleName);
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
