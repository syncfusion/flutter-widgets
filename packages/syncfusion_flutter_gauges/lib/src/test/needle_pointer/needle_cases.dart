import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'needle_samples.dart';

/// Unit test scripts of needle pointer
void needleSamples() {
  late SfRadialGauge gauge;

  // Default-view
  group('Default-view', () {
    testWidgets('Default-view', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Default-view');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-view', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 0);
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.enableDragging, false);
      expect(needle.enableAnimation, false);
      expect(needle.animationType, AnimationType.ease);
      expect(needle.value, 0);
    });
  });

  // Default-view
  group('Default-view', () {
    testWidgets('Default-view', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Default-view');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-view', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 1);
      expect(needle.needleEndWidth, 10);
      expect(needle.needleLength, 0.6);
      expect(needle.needleColor, null);
      expect(needle.lengthUnit, GaugeSizeUnit.factor);
      expect(needle.knobStyle.knobRadius, 0.08);
      expect(needle.knobStyle.sizeUnit, GaugeSizeUnit.factor);
      expect(needle.tailStyle, null);
    });
  });

  // needle-value
  testWidgets('needle-value', (WidgetTester tester) async {
    final _NeedleTestCasesExamples container = _needleTestCases('needle-value');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test needle-value', () {
    final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
    expect(needle.value, 50);
  });

  // Needle length in pixel
  group('Needle length in pixel', () {
    testWidgets('Needle length in pixel', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Needle length in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Needle length in pixel', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleLength, 50);
      expect(needle.lengthUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  // Needle length in factor
  group('Needle length in factor', () {
    testWidgets('Needle length in factor', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Needle length in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Needle length in factor', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleLength, 0.7);
      expect(needle.lengthUnit, GaugeSizeUnit.factor);
    });
  });

  // Needle color
  testWidgets('Needle color', (WidgetTester tester) async {
    final _NeedleTestCasesExamples container = _needleTestCases('Needle color');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test Needle color', () {
    final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
    expect(needle.needleColor, Colors.red);
  });

  // Needle start width
  group('Needle start width', () {
    testWidgets('Needle start width', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Needle start width');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Needle start width', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 0);
      expect(needle.needleEndWidth, 10);
    });
  });

  // Needle end width
  group('Needle end width', () {
    testWidgets('Needle end width', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Needle end width');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Needle end width', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 1);
      expect(needle.needleEndWidth, 4);
    });
  });

  // Bar type needle
  group('Bar type needle', () {
    testWidgets('Bar type needle', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Bar type needle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Bar type needle', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 10);
      expect(needle.needleEndWidth, 10);
    });
  });

  // width customization
  group('width customization', () {
    testWidgets('width customization', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('width customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width customization', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 10);
      expect(needle.needleEndWidth, 1);
    });
  });

  // Default-knob
  group('Default-knob', () {
    testWidgets('Default-knob', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Default-knob');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width customization', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.knobStyle.knobRadius, 0.08);
      expect(needle.knobStyle.sizeUnit, GaugeSizeUnit.factor);
      expect(needle.knobStyle.color, null);
      expect(needle.knobStyle.borderColor, null);
      expect(needle.knobStyle.borderWidth, 0);
    });
  });

  //radius in factor
  group('radius in factor', () {
    testWidgets('radius in factor', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('radius in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test radius in factor', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.knobStyle.knobRadius, 0.1);
      // expect(needle._actualCapRadius, needle._axis._radius * 0.1);
    });
  });

  //radius in  pixel
  group('radius in  pixel', () {
    testWidgets('radius in  pixel', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('radius in  pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test radius in  pixel', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.knobStyle.knobRadius, 10);
      expect(needle.knobStyle.sizeUnit, GaugeSizeUnit.logicalPixel);
      // expect(needle._actualCapRadius, 10);
    });
  });

  testWidgets('knob color', (WidgetTester tester) async {
    final _NeedleTestCasesExamples container = _needleTestCases('knob color');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test knob color', () {
    final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
    expect(needle.knobStyle.color, Colors.red);
  });

  //border width in factor
  group('border width in factor', () {
    testWidgets('border width in factor', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('border width in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test border width in factor', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.knobStyle.knobRadius, 0.08);
      expect(needle.knobStyle.borderWidth, 0.02);
      expect(needle.knobStyle.borderColor, Colors.red);
    });
  });

  //border width in pixel
  group('border width in pixel', () {
    testWidgets('border width in pixel', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('border width in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test border width in pixel', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.knobStyle.borderWidth, 2);
      expect(needle.knobStyle.borderColor, Colors.red);
      // expect(needle._actualCapRadius, 8);
      expect(needle.knobStyle.sizeUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //Default-tail
  group('Default-tail', () {
    testWidgets('Default-tail', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('Default-tail');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-tail', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.tailStyle!.length, 0);
      expect(needle.tailStyle!.lengthUnit, GaugeSizeUnit.factor);
      expect(needle.tailStyle!.color, null);
      expect(needle.tailStyle!.borderColor, null);
      expect(needle.tailStyle!.borderWidth, 0);
    });
  });

  //tail length in factor
  group('tail length in factor', () {
    testWidgets('tail length in factor', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('tail length in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tail length in factor', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.tailStyle!.length, 0.2);
      expect(needle.tailStyle!.lengthUnit, GaugeSizeUnit.factor);
      // expect(needle._actualTailLength, needle._axis._radius * 0.2);
    });
  });

  //tail length in pixel
  group('tail length in pixel', () {
    testWidgets('tail length in pixel', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('tail length in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tail length in pixel', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.tailStyle!.length, 20);
      expect(needle.tailStyle!.lengthUnit, GaugeSizeUnit.logicalPixel);
      // expect(needle._actualTailLength, null);
    });
  });

  //tail color
  testWidgets('tail color', (WidgetTester tester) async {
    final _NeedleTestCasesExamples container = _needleTestCases('tail color');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test tail color', () {
    final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
    expect(needle.tailStyle!.color, Colors.red);
  });

  //tail border
  group('tail border', () {
    testWidgets('tail border', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('tail border');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tail border', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.tailStyle!.borderColor, Colors.red);
      expect(needle.tailStyle!.borderWidth, 3);
    });
  });

  //Needle gradient
  group('needle-gradient', () {
    testWidgets('needle-gradient', (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('needle-gradient');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test needle-gradient', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.needleStartWidth, 5);
      expect(needle.needleEndWidth, 0);
      expect(needle.tailStyle!.borderWidth, 2);
      expect(needle.tailStyle!.borderColor, Colors.black);
      expect(
        needle.gradient,
        const LinearGradient(colors: <Color>[
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.pink
        ], stops: <double>[
          0,
          0.25,
          0.5,
          0.75
        ]),
      );
      expect(
        needle.tailStyle!.gradient,
        const LinearGradient(colors: <Color>[
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.pink
        ], stops: <double>[
          0,
          0.25,
          0.5,
          0.75
        ]),
      );
    });
  });

  //needle pointer with loading animation
  group('needle pointer with loading animation', () {
    testWidgets('needle pointer with loading animation',
        (WidgetTester tester) async {
      final _NeedleTestCasesExamples container =
          _needleTestCases('needle pointer with loading animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test needle pointer with loading animation', () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.enableAnimation, false);
      expect(needle.value, 136);
      expect(gauge.enableLoadingAnimation, true);
    });
  });

  //needle pointer with laodingAnimation and pointer animation
  group('needle pointer with laodingAnimation and pointer animation', () {
    testWidgets('needle pointer with laodingAnimation and pointer animation',
        (WidgetTester tester) async {
      final _NeedleTestCasesExamples container = _needleTestCases(
          'needle pointer with laodingAnimation and pointer animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test needle pointer with laodingAnimation and pointer animationn',
        () {
      final NeedlePointer needle = gauge.axes[0].pointers![0] as NeedlePointer;
      expect(needle.enableAnimation, true);
      expect(needle.value, 136);
      expect(gauge.enableLoadingAnimation, true);
    });
  });
}

_NeedleTestCasesExamples _needleTestCases(String sampleName) {
  return _NeedleTestCasesExamples(sampleName);
}

class _NeedleTestCasesExamples extends StatelessWidget {
  _NeedleTestCasesExamples(String sampleName) {
    gauge = getNeedleTestSample(sampleName);
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
