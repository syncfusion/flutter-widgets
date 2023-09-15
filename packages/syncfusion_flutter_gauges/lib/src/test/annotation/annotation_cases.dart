import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'annotation_samples.dart';

/// Unit test scripts of annotation
void annotationSamples() {
  late SfRadialGauge gauge;
  // To find the default angle value
  testWidgets('Default-angle value', (WidgetTester tester) async {
    final _AnnotationTestCasesExamples container =
        _annotationTestCases('Default-rendering');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test Default-rendering', () {
    expect(gauge.axes[0].annotations![0].angle, null);
    expect(gauge.axes[0].annotations![0].axisValue, null);
    expect(gauge.axes[0].annotations![0].horizontalAlignment,
        GaugeAlignment.center);
    expect(
        gauge.axes[0].annotations![0].verticalAlignment, GaugeAlignment.center);
    expect(gauge.axes[0].annotations![0].positionFactor, 0);
  });

  /// Default-rendering
  group('Default-rendering', () {
    testWidgets('Default-rendering', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('Default-rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-rendering', () {
      expect(gauge.axes[0].annotations!.length, 1);
      expect(gauge.axes[0].annotations![0].horizontalAlignment,
          GaugeAlignment.center);
      expect(gauge.axes[0].annotations![0].verticalAlignment,
          GaugeAlignment.center);
    });
  });

  /// With angle
  group('With angle', () {
    testWidgets('With angle', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('With angle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test With angle', () {
      expect(gauge.axes[0].annotations![0].angle, 270);
    });
  });

  /// With value
  group('With value', () {
    testWidgets('With value', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('With value');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test With value', () {
      expect(gauge.axes[0].annotations![0].angle, null);
      expect(gauge.axes[0].annotations![0].axisValue, 0);
    });
  });

  /// annotation Size
  group('annotation Size', () {
    testWidgets('annotation Size', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('annotation Size');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test annotation Size', () {
      expect(gauge.axes[0].annotations![0].angle, 90);
      expect(gauge.axes[0].annotations![0].positionFactor, 1);
    });
  });

  /// horizontalAlignment-near
  group('horizontalAlignment-near', () {
    testWidgets('horizontalAlignment-near', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('horizontalAlignment-near');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test horizontalAlignment-near', () {
      expect(gauge.axes[0].annotations![0].horizontalAlignment,
          GaugeAlignment.near);
    });
  });

  /// horizontalAlignment-center
  group('horizontalAlignment-center', () {
    testWidgets('horizontalAlignment-center', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('horizontalAlignment-center');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test horizontalAlignment-center', () {
      expect(gauge.axes[0].annotations![0].horizontalAlignment,
          GaugeAlignment.center);
    });
  });

  /// horizontalAlignment-center
  group('horizontalAlignment-far', () {
    testWidgets('horizontalAlignment-far', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('horizontalAlignment-far');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test horizontalAlignment-far', () {
      expect(gauge.axes[0].annotations![0].horizontalAlignment,
          GaugeAlignment.far);
    });
  });

  /// verticalAlignment-near
  group('verticalAlignment-near', () {
    testWidgets('verticalAlignment-near', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('verticalAlignment-near');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test verticalAlignment-near', () {
      expect(
          gauge.axes[0].annotations![0].verticalAlignment, GaugeAlignment.near);
    });
  });

  /// verticalAlignment-center
  group('verticalAlignment-center', () {
    testWidgets('verticalAlignment-center', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('verticalAlignment-center');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test verticalAlignment-center', () {
      expect(gauge.axes[0].annotations![0].verticalAlignment,
          GaugeAlignment.center);
    });
  });

  /// verticalAlignment-far
  group('verticalAlignment-far', () {
    testWidgets('verticalAlignment-far', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('verticalAlignment-far');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test verticalAlignment-far', () {
      expect(
          gauge.axes[0].annotations![0].verticalAlignment, GaugeAlignment.far);
    });
  });

  /// with centerX
  group('with centerX', () {
    testWidgets('with centerX', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('with centerX');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with centerX', () {
      expect(gauge.axes[0].centerX, 0.3);
    });
  });

  /// with centerY
  group('with centerY', () {
    testWidgets('with centerY', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('with centerY');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with centerY', () {
      expect(gauge.axes[0].centerY, 0.3);
    });
  });

  /// with canScaleToFit
  group('canScaleToFit- true', () {
    testWidgets('canScaleToFit as true', (WidgetTester tester) async {
      final _AnnotationTestCasesExamples container =
          _annotationTestCases('canScaleToFit- true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with canScaleToFit', () {
      expect(gauge.axes[0].canScaleToFit, true);
    });
  });
}

_AnnotationTestCasesExamples _annotationTestCases(String sampleName) {
  return _AnnotationTestCasesExamples(sampleName);
}

class _AnnotationTestCasesExamples extends StatelessWidget {
  _AnnotationTestCasesExamples(String sampleName) {
    gauge = getAnnotationTestSample(sampleName)!;
  }

  late final SfRadialGauge gauge;

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
            child: gauge,
          ))),
    );
  }
}
