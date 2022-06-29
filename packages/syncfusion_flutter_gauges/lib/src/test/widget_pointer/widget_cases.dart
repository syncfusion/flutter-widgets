import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'widget_samples.dart';

/// Unit test scripts of widget pointer
void widgetPointerSamples() {
  late SfRadialGauge gauge = SfRadialGauge();

  // Default- widget pointer
  group('Default-widget pointer', () {
    testWidgets('Default-widget pointer', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Default-widget pointer');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-widget pointer', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 0);
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, 0);
      expect(widgetPointer.enableDragging, false);
      expect(widgetPointer.enableAnimation, false);
      expect(widgetPointer.animationType, AnimationType.ease);
    });
  });

  /// Widget-dragging
  testWidgets('Widget pointer-dragging', (WidgetTester tester) async {
    final _WidgetPointerTestCasesExamples container =
        _widgetPointerTestCases('Widget pointer-dragging');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test Widget pointer-dragging', () {
    final WidgetPointer widgetPointer =
        gauge.axes[0].pointers![0] as WidgetPointer;
    expect(widgetPointer.enableDragging, true);
  });

  // AnimationType - bounceOut
  group('AnimationType - bounceOut', () {
    testWidgets('AnimationType - bounceOut', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - bounceOut');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to testAnimationType - bounceOut', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(gauge.axes[0].pointers![0].animationType, AnimationType.bounceOut);
    });
  });

  // 'AnimationType - linear
  group('AnimationType - linear', () {
    testWidgets('AnimationType - linear', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - linear');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to testAnimationType - bounceOut', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(gauge.axes[0].pointers![0].animationType, AnimationType.linear);
    });
  });

  // AnimationType - ease
  group('AnimationType - ease', () {
    testWidgets('AnimationType - ease', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - ease');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - ease', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(gauge.axes[0].pointers![0].animationType, AnimationType.ease);
    });
  });

  // AnimationType - easeInCirc
  group('AnimationType - easeInCirc', () {
    testWidgets('AnimationType - easeInCirc', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - easeInCirc');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - easeInCirc', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge.axes[0].pointers![0].animationType, AnimationType.easeInCirc);
    });
  });

  // AnimationType - elasticOut
  group('AnimationType - elasticOut', () {
    testWidgets('AnimationType - elasticOut', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - elasticOut');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - elasticOut', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge.axes[0].pointers![0].animationType, AnimationType.elasticOut);
    });
  });

  // AnimationType - slowMiddle
  group('AnimationType - slowMiddle', () {
    testWidgets('AnimationType - slowMiddle', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - slowMiddle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - slowMiddle', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge.axes[0].pointers![0].animationType, AnimationType.slowMiddle);
    });
  });

  // AnimationType - easeOutBack
  group('AnimationType - easeOutBack', () {
    testWidgets('AnimationType - easeOutBack', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('AnimationType - easeOutBack');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - easeOutBack', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge.axes[0].pointers![0].animationType, AnimationType.easeOutBack);
    });
  });

  // Animation-Duration
  group('Animation-Duration', () {
    testWidgets('Animation-Duration', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Animation-Duration');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Animation-Duration', () {
      expect(gauge.axes[0].pointers!.length, 1);
      expect(gauge.axes[0].pointers![0].value, 50);
      expect(gauge.axes[0].pointers![0].enableAnimation, true);
      expect(gauge.axes[0].pointers![0].animationType, AnimationType.ease);
      expect(gauge.axes[0].pointers![0].animationDuration, 4000);
    });
  });

  //Offset in pixel
  group('Offset in pixel', () {
    testWidgets('Offset in pixel', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Offset in pixel', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, 30);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //Negative offset in pixel
  group('Negative offset in pixel', () {
    testWidgets('Negative offset in pixel', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Negative offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in pixel', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, -30);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //Offset in factor
  group('Offset in factor', () {
    testWidgets('Offset in factor', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in pixel', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, 0.2);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //Negative offset in factor
  group('Negative offset in factor', () {
    testWidgets('Negative offset in factor', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('Negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in factor', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, -0.2);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //TicksPosition- offset in pixel
  group('TicksPosition- offset in pixel', () {
    testWidgets('TicksPosition- offset in pixel', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('TicksPosition- offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- offset in pixel', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, 30);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //TicksPosition- offset in pixel
  group('TicksPosition- negative offset in pixel', () {
    testWidgets('TicksPosition- negative offset in pixel',
        (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('TicksPosition- negative offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- negative offset in pixel', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, -30);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //TicksPosition- offset in factor
  group('TicksPosition- offset in factor', () {
    testWidgets('TicksPosition- offset in factor', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('TicksPosition- offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- offset in factor', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, 0.2);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //TicksPosition- negative offset in factor
  group('TicksPosition- negative offset in factor', () {
    testWidgets('TicksPosition- negative offset in factor',
        (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('TicksPosition- negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- negative offset in factor', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(widgetPointer.offset, -0.2);
      expect(widgetPointer.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //pointer with loading animation
  group('pointer with loading animation', () {
    testWidgets('pointer with loading animation', (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container =
          _widgetPointerTestCases('pointer with loading animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test pointer with loading animation', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(gauge.enableLoadingAnimation, true);
      expect(widgetPointer.value, 136);
      expect(widgetPointer.enableAnimation, false);
    });
  });

  //pointer with loadingAnimation and pointer animation
  group('widget pointer with laodingAnimation and pointer animation', () {
    testWidgets('pointer with laodingAnimation and pointer animation',
        (WidgetTester tester) async {
      final _WidgetPointerTestCasesExamples container = _widgetPointerTestCases(
          'widget pointer with laodingAnimation and pointer animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test pointer with laodingAnimation and pointer animation', () {
      final WidgetPointer widgetPointer =
          gauge.axes[0].pointers![0] as WidgetPointer;
      expect(gauge.enableLoadingAnimation, true);
      expect(widgetPointer.value, 136);
      expect(widgetPointer.enableAnimation, true);
    });
  });
}

_WidgetPointerTestCasesExamples _widgetPointerTestCases(String sampleName) {
  return _WidgetPointerTestCasesExamples(sampleName);
}

class _WidgetPointerTestCasesExamples extends StatelessWidget {
  _WidgetPointerTestCasesExamples(String sampleName) {
    gauge = getWidgetPointerTestSample(sampleName);
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
