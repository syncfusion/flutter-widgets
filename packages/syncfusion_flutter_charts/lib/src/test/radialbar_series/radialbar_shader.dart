import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'radialbar_sample.dart';

/// Testing method of pyramid chart`s legend and all its functionalities.
void radialBarShader() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  //ignore: unused_local_variable
  //SfCircularChartState? _chartState;

  group(' Shader', () {
    testWidgets('RadialBar chart - shader properties',
        (WidgetTester tester) async {
      final _RadialBarShader chartContainer =
          _radialBarShader('radialbar_shader') as _RadialBarShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test RadialBar shader', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('RadialBar chart - shader properties with border',
        (WidgetTester tester) async {
      final _RadialBarShader chartContainer =
          _radialBarShader('radialbar_shaderwithborder') as _RadialBarShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test RadialBar shader with border', () {
      expect(chart!.onCreateShader != null, true);
    });
    testWidgets('RadialBar chart - pointshader ', (WidgetTester tester) async {
      final _RadialBarShader chartContainer =
          _radialBarShader('radialbar_pointshader') as _RadialBarShader;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
      // final GlobalKey key = chart!.key as GlobalKey<State<StatefulWidget>>;
      // _chartState = key.currentState as SfCircularChartState?;
    });

    test('test RadialBar point shadermapper', () {
      expect(chart!.onCreateShader == null, true);
    });
  });
}

StatelessWidget _radialBarShader(String sampleName) {
  return _RadialBarShader(sampleName);
}

// ignore: must_be_immutable
class _RadialBarShader extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _RadialBarShader(String sampleName) {
    chart = getRadialbarchart(sampleName);
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
