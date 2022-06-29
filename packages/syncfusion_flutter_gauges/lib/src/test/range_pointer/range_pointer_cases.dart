import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'range_pointer_samples.dart';

/// Unit test scripts of range pointer
/// Unit test scripts of range pointer
void rangePointerSamples() {
  late SfRadialGauge gauge;

  // Default-view
  group('Default-Rendering', () {
    testWidgets('Default-Rendering', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('Default-Rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-Rendering', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 0);
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.enableDragging, false);
      expect(range.enableAnimation, false);
      expect(range.animationType, AnimationType.ease);
      expect(range.value, 0);
    });
  });

  // Range default properties
  group('Range default properties', () {
    testWidgets('Range default properties', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('Default-Rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Range default properties', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.width, 10);
      expect(range.pointerOffset, 0);
      expect(range.sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(range.color, null);
      expect(range.cornerStyle, CornerStyle.bothFlat);
    });
  });

  //range-value
  testWidgets('range-value', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('range-value');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test range-value', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.value, 50);
  });

  //width - in pixel
  group('width - in pixel', () {
    testWidgets('width - in pixel', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('width - in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width - in pixel', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.width, 20);
      // expect(range._actualRangeThickness, 20);
    });
  });

  //width - in factor
  group('width - in factor', () {
    testWidgets('width - in factor', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('width - in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width - in factor', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.width, 0.2);
      // expect(range._actualRangeThickness, range._axis._radius * 0.2);
      expect(range.sizeUnit, GaugeSizeUnit.factor);
    });
  });

  //offset - in pixel
  group('offset - in pixel', () {
    testWidgets('offset - in pixel', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('offset - in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test offset - in pixel', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.pointerOffset, 20);
      // expect(range._actualPointerOffset, 20);
    });
  });

  //negative offset - in pixel
  group('negative offset - in pixel', () {
    testWidgets('negative offset - in pixel', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('negative offset - in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test negative offset - in pixel', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.pointerOffset, -20);
      // expect(range._actualPointerOffset, -20);
    });
  });

  //offset - in factor
  group('offset - in factor', () {
    testWidgets('offset - in factor', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('offset - in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test offset - in factor', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.pointerOffset, 0.2);
      // expect(range._actualPointerOffset, range._axis._radius * 0.2);
    });
  });

  //negative offset - in factor
  group('negative offset - in factor', () {
    testWidgets('negative offset - in factor', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('negative offset - in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test negative offset - in factor', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.pointerOffset, -0.2);
      // expect(range._actualPointerOffset, range._axis._radius * -0.2);
    });
  });

  //both curve
  testWidgets('both curve', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('both curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test both curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.bothCurve);
  });

  //start curve
  testWidgets('start curve', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('start curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test start curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.startCurve);
  });

  //end curve
  testWidgets('end curve', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('end curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test end curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.endCurve);
  });

  //color customization
  testWidgets('color customization', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('color customization');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test color customization', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.color, Colors.lightBlueAccent);
  });

  //bounce Out
  group('bounce Out', () {
    testWidgets('bounce Out', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('bounce Out');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test bounce Out', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.bounceOut);
      expect(range.animationDuration, 2000);
    });
  });

  //linear
  group('linear', () {
    testWidgets('linear', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('linear');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test linear', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.linear);
      expect(range.animationDuration, 2000);
    });
  });

  //easeInCirc
  group('easeInCirc', () {
    testWidgets('easeInCirc', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('easeInCirc');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test easeInCirc', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.easeInCirc);
      expect(range.animationDuration, 2000);
    });
  });

  //elasticOut
  group('elasticOut', () {
    testWidgets('elasticOut', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('elasticOut');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test elasticOut', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.elasticOut);
      expect(range.animationDuration, 2000);
    });
  });

  //slowMiddle
  group('slowMiddle', () {
    testWidgets('slowMiddle', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('slowMiddle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test slowMiddle', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.slowMiddle);
      expect(range.animationDuration, 2000);
    });
  });

  //easeOutBack
  group('easeOutBack', () {
    testWidgets('easeOutBack', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('easeOutBack');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test easeOutBack', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.easeOutBack);
      expect(range.animationDuration, 2000);
    });
  });

  //ease
  group('ease', () {
    testWidgets('ease', (WidgetTester tester) async {
      final _RangePointerTestCasesExamples container =
          _rangePointerTestCases('ease');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test ease', () {
      final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
      expect(range.animationType, AnimationType.ease);
      expect(range.animationDuration, 2000);
    });
  });

  /// Test pointer with gradient
  testWidgets('pointer-Gradient', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('pointer-Gradient');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test pointer-Gradient', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(
      range.gradient,
      const SweepGradient(colors: <Color>[
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

  /// Test cornerStyle as bothCurve with isInversed
  testWidgets('Test cornerStyle as bothCurve with isInversed',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('cornerStyle as bothCurve with isInversed');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test cornerStyle as bothCurve with isInversed', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.bothCurve);
    expect(gauge.axes[0].isInversed, true);
  });

  /// Test cornerStyle as endCurve with isInversed
  testWidgets('Test cornerStyle as endCurve with isInversed',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('cornerStyle as endCurve with isInversed');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test cornerStyle as endCurve with isInversed', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.endCurve);
    expect(gauge.axes[0].isInversed, true);
  });

  /// Test cornerStyle as startCurve with isInversed
  testWidgets('Test cornerStyle as startCurve with isInversed',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('cornerStyle as startCurve with isInversed');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test cornerStyle as startCurve with isInversed', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.startCurve);
    expect(gauge.axes[0].isInversed, true);
  });

  ///  range pointer with load time animation
  testWidgets('Test range pointer with load time animation',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('range pointer with load time animation');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test range pointer with load time animation', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.endCurve);
    expect(gauge.enableLoadingAnimation, true);
  });

  ///  range pointer without load time animation
  testWidgets('Test range pointer with laodingAnimation and pointer animation',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container = _rangePointerTestCases(
        'range pointer with laodingAnimation and pointer animation');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test range pointer with laodingAnimation and pointer animation', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.cornerStyle, CornerStyle.endCurve);
    expect(gauge.enableLoadingAnimation, true);
    expect(range.enableAnimation, true);
  });

  ///  pointer-Gradient without stops
  testWidgets('Test pointer-Gradient without stops',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('pointer-Gradient without stops');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test pointer-Gradient without stops', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(
        range.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ));
  });

  ///  pointer-Gradient without stops and isInversed
  testWidgets('Test pointer-Gradient without stops and isInversed',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('pointer-Gradient without stops and isInversed');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test pointer-Gradient without stops and isInversed', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(gauge.axes[0].isInversed, true);
    expect(
        range.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ));
  });

  testWidgets('Test pointer with dash array with corner style both curve',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container = _rangePointerTestCases(
        'pointer with dash array with corner style both curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('pointer with dash array with corner style both curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.value, 50);
    expect(range.cornerStyle, CornerStyle.bothCurve);
    expect(range.dashArray, <double>[8, 2]);
    expect(
        range.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ));
  });

  testWidgets('Test pointer with dash array', (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container =
        _rangePointerTestCases('pointer with dash array');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('pointer with dash array', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.value, 50);
    expect(range.dashArray, <double>[8, 2]);
    expect(
        range.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ));
  });

  testWidgets('Test pointer with dash array with corner style start curve',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container = _rangePointerTestCases(
        'pointer with dash array with corner style start curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('pointer with dash array with corner style start curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.value, 50);
    expect(range.dashArray, <double>[8, 2]);
    expect(range.cornerStyle, CornerStyle.startCurve);
  });

  testWidgets('Test pointer with dash array with corner style end curve',
      (WidgetTester tester) async {
    final _RangePointerTestCasesExamples container = _rangePointerTestCases(
        'pointer with dash array with corner style end curve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('pointer with dash array with corner style end curve', () {
    final RangePointer range = gauge.axes[0].pointers![0] as RangePointer;
    expect(range.value, 50);
    expect(range.dashArray, <double>[8, 2]);
    expect(range.cornerStyle, CornerStyle.endCurve);
  });
}

_RangePointerTestCasesExamples _rangePointerTestCases(String sampleName) {
  return _RangePointerTestCasesExamples(sampleName);
}

class _RangePointerTestCasesExamples extends StatelessWidget {
  _RangePointerTestCasesExamples(String sampleName) {
    gauge = getRangePointerTestSample(sampleName);
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
