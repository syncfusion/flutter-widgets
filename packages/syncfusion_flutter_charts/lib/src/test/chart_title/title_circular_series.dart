import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'chart_title_sample.dart';

/// Test method of title customization in circular series.
void circularSeriestitle() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCircularChart? chart;
  group('Chart Title - Circular,', () {
    testWidgets('chart tite sample', (WidgetTester tester) async {
      final _TitleCircular chartContainer =
          _titleCircular('circular_title_default_style') as _TitleCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test default values', () {
      final ChartTitle title = chart!.title;
      expect(title.text, 'Half yearly sales analysis');
      expect(title.backgroundColor, Colors.lightGreen);
      expect(title.borderColor, Colors.blue);
      expect(title.borderWidth, 2);
      expect(title.alignment, ChartAlignment.center);
    });

    testWidgets('circular chart tite alignment - near',
        (WidgetTester tester) async {
      final _TitleCircular chartContainer =
          _titleCircular('circular_title_near_Alignment') as _TitleCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test circular title near alignment', () {
      expect(chart!.title.alignment, ChartAlignment.near);
    });

    testWidgets('circular chart tite alignment - far',
        (WidgetTester tester) async {
      final _TitleCircular chartContainer =
          _titleCircular('circular_title_far_Alignment') as _TitleCircular;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('to test circular title far alignment', () {
      expect(chart!.title.alignment, ChartAlignment.far);
    });
  });
}

StatelessWidget _titleCircular(String sampleName) {
  return _TitleCircular(sampleName);
}

// ignore: must_be_immutable
class _TitleCircular extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TitleCircular(String sampleName) {
    chart = getCircularTitleChart(sampleName);
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
