import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../charts.dart';
import 'annotation_sample.dart';

/// Testing method for cartesian annotation.
void cartesianAnnotation() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.

  // chart instance will get once pumpWidget is called
  SfCartesianChart? chart;

  group('Cartesian Annotation,', () {
    testWidgets('Default annotation sample', (WidgetTester tester) async {
      final CartesianAnnotation chartContainer =
          _cartesianAnnotation('cartesian_annotation_default')
              as CartesianAnnotation;
      await tester.pumpWidget(chartContainer);
      chart = chartContainer.chart;
    });

    test('test series count', () {
      expect(chart!.series.length, 1);
    });
  });
}

StatelessWidget _cartesianAnnotation(String sampleName) {
  return CartesianAnnotation(sampleName);
}

/// Respresents the cartesian annotation
// ignore: must_be_immutable
class CartesianAnnotation extends StatelessWidget {
  /// Creates an instance for cartesian annotation
  // ignore: prefer_const_constructors_in_immutables
  CartesianAnnotation(String sampleName) {
    chart = getCartesianAnnotationSample(sampleName);
  }

  /// Represents the chart value
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
