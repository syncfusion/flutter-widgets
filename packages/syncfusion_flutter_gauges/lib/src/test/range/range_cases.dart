import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'range_sample.dart';

/// Unit test scripts of range
void rangeSamples() {
  late SfRadialGauge gauge;

  // To test the default range rendering
  group('Default-range', () {
    testWidgets('Default-range', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('Default-range');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default range rendreing', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 10);
      expect(gauge.axes[0].ranges![0].endWidth, 10);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0);
    });
  });

  /// Range width customization
  group('Width-customization', () {
    testWidgets('Width-customization', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('Width-customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width customization', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 30);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0);
    });
  });

  /// Range width customization in factor
  group('Width-customization in factor', () {
    testWidgets('Width-customization in factor', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('Width-customization in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test width customization in factor', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.2);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0);
    });
  });

  /// Range offset customization
  group('range offset', () {
    testWidgets('range offset', (WidgetTester tester) async {
      final _RangeTestCasesExamples container = _rangeTestCases('range offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test wrange offset customization', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 20);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].rangeOffset, 30);
    });
  });

  /// Range offset customization in factor
  group('range offset in factor', () {
    testWidgets('range offset in factor', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range offset customization in factor', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0.1);
    });
  });

  /// Range offset in negative
  group('rrange offset in negative', () {
    testWidgets('range offset in negative', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range offset in negative');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range offset customization in negative', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 10);
      expect(gauge.axes[0].ranges![0].endWidth, 10);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].rangeOffset, -10);
    });
  });

  /// Range offset in negative factor
  group('negative range offset in factor', () {
    testWidgets('negative range offset in factor', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('negative range offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range offset factor customization in negative', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0.1);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].rangeOffset, -0.1);
    });
  });

  /// multiple ranges
  group('multiple - ranges', () {
    testWidgets('multiple - ranges', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple - ranges');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test gauge with multiple ranges', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 10);
      expect(gauge.axes[0].ranges![0].endWidth, 10);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 10);
      expect(gauge.axes[0].ranges![1].endWidth, 10);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 10);
      expect(gauge.axes[0].ranges![2].endWidth, 10);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// multiple ranges with varying width
  group('multiple - ranges with varying width', () {
    testWidgets('multiple - ranges with varying width',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple - ranges with varying width');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test gauge with multiple ranges with varying width', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// Use range color for axis
  group('range color for axis', () {
    testWidgets('range color for axis', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range color for axis');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range color for axis', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].useRangeColorForAxis, true);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// multiple labels with negative offset in factor
  group('multiple labels with negative offset in factor', () {
    testWidgets('multiple labels with negative offset in factor',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels with negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('multiple labels with negative offset in factor', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].useRangeColorForAxis, true);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// To add the label for range
  group('range with label', () {
    testWidgets('range with label', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range with label');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with label', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, null);
      expect(gauge.axes[0].ranges![0].endWidth, null);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].label, 'low');
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 12);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Segoe UI');
      // expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.normal);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// Label Customization
  group('range label customization', () {
    testWidgets('range label customization', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range label customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with label', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, null);
      expect(gauge.axes[0].ranges![0].endWidth, null);
      expect(gauge.axes[0].ranges![0].color, null);
      expect(gauge.axes[0].ranges![0].label, 'low');
      expect(gauge.axes[0].ranges![0].labelStyle.color, Colors.red);
      expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// To add multiple labels
  group('multiple labels', () {
    testWidgets('multiple labels', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple labels', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0.1);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].label, 'Low');
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0);
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 12);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Segoe UI');
      // expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.normal);
      // expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0.1);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].label, 'Average');
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![1].rangeOffset, 0);
      expect(gauge.axes[0].ranges![1].labelStyle.color, null);
      // expect(gauge.axes[0].ranges![1].labelStyle.fontSize, 12);
      // expect(gauge.axes[0].ranges![1].labelStyle.fontFamily, 'Segoe UI');
      // expect(gauge.axes[0].ranges![1].labelStyle.fontWeight, FontWeight.normal);
      // expect(gauge.axes[0].ranges![1].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0.1);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].label, 'High');
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![2].rangeOffset, 0);
      expect(gauge.axes[0].ranges![2].labelStyle.color, null);
      // expect(gauge.axes[0].ranges![2].labelStyle.fontSize, 12);
      // expect(gauge.axes[0].ranges![2].labelStyle.fontFamily, 'Segoe UI');
      // expect(gauge.axes[0].ranges![2].labelStyle.fontWeight, FontWeight.normal);
      // expect(gauge.axes[0].ranges![2].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// To multiple label customization
  group('multiple labels customization', () {
    testWidgets('multiple labels customization', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple labels customization', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0.1);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].label, 'Low');
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0);
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 20);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Segoe UI');
      expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0.1);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].label, 'Average');
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![1].rangeOffset, 0);
      expect(gauge.axes[0].ranges![1].labelStyle.color, null);
      expect(gauge.axes[0].ranges![1].labelStyle.fontSize, 20);
      //expect(gauge.axes[0].ranges![1].labelStyle.fontFamily, 'Segoe UI');
      expect(gauge.axes[0].ranges![1].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![1].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0.1);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].label, 'High');
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![2].rangeOffset, 0);
      expect(gauge.axes[0].ranges![2].labelStyle.color, null);
      expect(gauge.axes[0].ranges![2].labelStyle.fontSize, 20);
      //expect(gauge.axes[0].ranges![2].labelStyle.fontFamily, 'Segoe UI');
      expect(gauge.axes[0].ranges![2].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![2].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// multiple labels with offset in factor
  group('multiple labels with offset in factor', () {
    testWidgets('multiple labels with offset in factor',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels with offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple ranges with offset in factor', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].label, 'low');
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![1].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].label, 'Average');
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![1].labelStyle.color, null);
      expect(gauge.axes[0].ranges![1].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![1].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![1].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![1].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![2].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].label, 'High');
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].ranges![2].labelStyle.color, null);
      expect(gauge.axes[0].ranges![2].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![2].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![2].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![2].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// multiple labels with offset in factor
  group('multiple ranges with offset in factor', () {
    testWidgets('multiple ranges with offset in factor',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple ranges with offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple ranges with offset in factor', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);
      expect(gauge.axes[0].useRangeColorForAxis, true);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![1].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.factor);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![2].rangeOffset, 0.15);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.factor);
    });
  });

  /// multiple ranges with offset
  group('multiple ranges with offset', () {
    testWidgets('multiple ranges with offset', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple ranges with offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple ranges with offset', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);
      expect(gauge.axes[0].useRangeColorForAxis, true);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].rangeOffset, 20);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].rangeOffset, 20);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].rangeOffset, 20);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// multiple labels with offset in factor
  group('multiple ranges with negative offset in factor', () {
    testWidgets('multiple ranges with negative offset in factor',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple ranges with negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple ranges with negative offset in factor', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
      expect(gauge.axes[0].ranges![0].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.factor);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 0.1);
      expect(gauge.axes[0].ranges![1].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.factor);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 0.1);
      expect(gauge.axes[0].ranges![2].rangeOffset, -0.15);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.factor);
    });
  });

  /// multiple labels with offset in factor
  group('multiple ranges with negative offset', () {
    testWidgets('multiple ranges with negative offset',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple ranges with negative offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple ranges with negative offset', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].rangeOffset, -20);
      expect(gauge.axes[0].ranges![0].color, Colors.red);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].rangeOffset, -20);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].rangeOffset, -20);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
    });
  });

  /// multiple labels with offset
  group('multiple labels with offset', () {
    testWidgets('multiple labels with offset', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels with offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple labels with offset', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].rangeOffset, 20);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].label, 'Low');
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].rangeOffset, 20);
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].rangeOffset, 20);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].label, 'Average');
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![1].rangeOffset, 20);
      expect(gauge.axes[0].ranges![1].labelStyle.color, null);
      expect(gauge.axes[0].ranges![1].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![1].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![1].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![1].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].rangeOffset, 20);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].label, 'High');
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![2].rangeOffset, 20);
      expect(gauge.axes[0].ranges![2].labelStyle.color, null);
      expect(gauge.axes[0].ranges![2].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![2].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![2].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![2].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  /// multiple labels with offset
  group('multiple labels with negative offset', () {
    testWidgets('multiple labels with negative offset',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('multiple labels with negative offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple labels with offset', () {
      expect(gauge.axes[0].ranges!.length, 3);
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 90);

      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 15);
      expect(gauge.axes[0].ranges![0].rangeOffset, -20);
      expect(gauge.axes[0].ranges![0].color, Colors.red);
      expect(gauge.axes[0].ranges![0].label, 'Low');
      expect(gauge.axes[0].ranges![0].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![0].labelStyle.color, null);
      expect(gauge.axes[0].ranges![0].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![0].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![0].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![0].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![1].startValue, 30);
      expect(gauge.axes[0].ranges![1].endValue, 60);
      expect(gauge.axes[0].ranges![1].startWidth, 0);
      expect(gauge.axes[0].ranges![1].endWidth, 15);
      expect(gauge.axes[0].ranges![1].rangeOffset, -20);
      expect(gauge.axes[0].ranges![1].color, Colors.yellow);
      expect(gauge.axes[0].ranges![1].label, 'Average');
      expect(gauge.axes[0].ranges![1].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![1].labelStyle.color, null);
      expect(gauge.axes[0].ranges![1].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![1].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![1].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![1].labelStyle.fontStyle, FontStyle.normal);

      expect(gauge.axes[0].ranges![2].startValue, 60);
      expect(gauge.axes[0].ranges![2].endValue, 90);
      expect(gauge.axes[0].ranges![2].startWidth, 0);
      expect(gauge.axes[0].ranges![2].endWidth, 15);
      expect(gauge.axes[0].ranges![2].rangeOffset, -20);
      expect(gauge.axes[0].ranges![2].color, Colors.green);
      expect(gauge.axes[0].ranges![2].label, 'High');
      expect(gauge.axes[0].ranges![2].sizeUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].ranges![2].labelStyle.color, null);
      expect(gauge.axes[0].ranges![2].labelStyle.fontSize, 20);
      expect(gauge.axes[0].ranges![2].labelStyle.fontFamily, 'Times');
      expect(gauge.axes[0].ranges![2].labelStyle.fontWeight, FontWeight.bold);
      //expect(gauge.axes[0].ranges![2].labelStyle.fontStyle, FontStyle.normal);
    });
  });

  // With tick position outside
  group('tickPoistion-outside', () {
    testWidgets('tickPoistion-outside', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('tickPoistion-outside');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tickPoistion-outside', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
    });
  });

  // With tick position outside with tick Offset
  group('tickPoistion-outside with tick Offset', () {
    testWidgets('tickPoistion-outside with tick Offset',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('tickPoistion-outside with tick Offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tickPoistion-outside with tick Offset', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].tickOffset, 20);
    });
  });

  // With labelsPoistion-outside
  group('labelsPoistion-outside', () {
    testWidgets('labelsPoistion-outside', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('labelsPoistion-outside');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test labelsPoistion-outside', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
    });
  });

  // With labelsPoistion-outside with tick Offset
  group('labelsPoistion-outside with tick Offset', () {
    testWidgets('labelsPoistion-outside with tick Offset',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('labelsPoistion-outside with tick Offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test labelsPoistion-outside with tick Offset', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelOffset, 20);
    });
  });

  // with radiusFactor
  group('with radiusFactor', () {
    testWidgets('with radiusFactor', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('with radiusFactor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with radiusFactor', () {
      // expect(gauge.axes[0].ranges[0]._rangeRect.height,
      //     gauge.axes[0]._axisRect.height);
    });
  });

  //with centerX
  group('with centerX', () {
    testWidgets('with centerX', (WidgetTester tester) async {
      final _RangeTestCasesExamples container = _rangeTestCases('with centerX');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with centerX', () {
      // expect(gauge.axes[0].ranges[0]._rangeRect.left,
      //     gauge.axes[0]._axisRect.left);
    });
  });

  //with centerX
  group('with centerY', () {
    testWidgets('with centerY', (WidgetTester tester) async {
      final _RangeTestCasesExamples container = _rangeTestCases('with centerY');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with centerY', () {
      // expect(gauge.axes[0].ranges[0]._rangeRect.top,
      //     gauge.axes[0]._axisRect.top);
    });
  });

  //with Gradient
  group('range-gradient', () {
    testWidgets('range-gradient', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range-gradient');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range-gradient', () {
      expect(
        gauge.axes[0].ranges![0].gradient,
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
  });

  //with Load-Time animation
  group('Test with Load-Time animation', () {
    testWidgets('with Load-Time animation', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('with Load-Time animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test with Load-Time animation', () {
      expect(gauge.enableLoadingAnimation, true);
    });
  });

  //with Varying range width with Load-Time animation
  group('Different range width with loadTimeAnimation', () {
    testWidgets('Different range width with loadTimeAnimation',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('Different range width with loadTimeAnimation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test different range width with loadTimeAnimation', () {
      expect(gauge.enableLoadingAnimation, true);
      expect(gauge.animationDuration, 3500);
      expect(gauge.axes[0].ranges![0].startWidth, 0.05);
      expect(gauge.axes[0].ranges![0].endWidth, 0.25);
    });
  });

  //with range with isInversed
  group('range with isInversed', () {
    testWidgets('range with isInversed', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range with isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with isInversed', () {
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
    });
  });

  //with axis angle reversed
  group('axis angle reversed', () {
    testWidgets('axis angle reversed', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('axis angle reversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis angle reversed', () {
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 0);
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
    });
  });

  //with range with isInversed without canScaleToFit
  group('range with isInversed without canScaleToFit', () {
    testWidgets('range with isInversed without canScaleToFit',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range with isInversed without canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with isInversed without canScaleToFit', () {
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
    });
  });

  //with axis angle reversed without canScaleToFit
  group('axis angle reversed without canScaleToFit', () {
    testWidgets('axis angle reversed without canScaleToFit',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('axis angle reversed without canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis angle reversed without canScaleToFit', () {
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 0);
      expect(gauge.axes[0].ranges![0].startWidth, 0);
      expect(gauge.axes[0].ranges![0].endWidth, 0.1);
    });
  });

  //with range label with canScaleToFit
  group('with range label with canScaleToFit', () {
    testWidgets('with range label with canScaleToFit',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range label with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range label with canScaleToFit', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].ranges![0].label, 'Slow');
      expect(gauge.axes[0].ranges![0].startWidth, 0.65);
      expect(gauge.axes[0].ranges![0].endWidth, 0.65);
      expect(gauge.axes[0].ranges![1].label, 'Moderate');
      expect(gauge.axes[0].ranges![1].startWidth, 0.65);
      expect(gauge.axes[0].ranges![1].endWidth, 0.65);
      expect(gauge.axes[0].ranges![2].label, 'Fast');
      expect(gauge.axes[0].ranges![2].startWidth, 0.65);
      expect(gauge.axes[0].ranges![2].endWidth, 0.65);
    });
  });

  //with range label with canScaleToFit, isInversed
  group('with range label with canScaleToFit with minimum start angle', () {
    testWidgets('with range label with canScaleToFit with minimum start angle',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container = _rangeTestCases(
          'range label with canScaleToFit with minimum start angle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range label with canScaleToFit with minimum start angle', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].ranges![0].label, 'Slow');
      expect(gauge.axes[0].ranges![0].startWidth, 0.65);
      expect(gauge.axes[0].ranges![0].endWidth, 0.65);
      expect(gauge.axes[0].ranges![1].label, 'Moderate');
      expect(gauge.axes[0].ranges![1].startWidth, 0.65);
      expect(gauge.axes[0].ranges![1].endWidth, 0.65);
      expect(gauge.axes[0].ranges![2].label, 'Fast');
      expect(gauge.axes[0].ranges![2].startWidth, 0.65);
      expect(gauge.axes[0].ranges![2].endWidth, 0.65);
    });
  });

  //negative sweepAngle
  group('negative sweepAngle', () {
    testWidgets('negative sweepAngle', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('negative sweepAngle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test negative sweepAngle', () {
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, -180);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
    });
  });

  //range with loading animation
  group('range with loading animation', () {
    testWidgets('range with loading animation', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range with loading animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with loading animation', () {
      expect(gauge.axes[0].ranges!.length, 4);
      expect(gauge.enableLoadingAnimation, true);
    });
  });

  //range with loading animation
  group('range with loading animation', () {
    testWidgets('range with loading animation', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range with loading animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range with loading animation', () {
      expect(gauge.axes[0].ranges!.length, 4);
      expect(gauge.enableLoadingAnimation, true);
    });
  });

  //range-gradient without stops
  group('range-gradient without stops', () {
    testWidgets('range-gradient without stops', (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range-gradient without stops');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range-gradient without stops', () {
      expect(
        gauge.axes[0].ranges![0].gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ),
      );
      expect(
          gauge.axes[0].ranges![1].gradient,
          const SweepGradient(
            colors: <Color>[
              Colors.green,
              Colors.blue,
              Colors.orange,
              Colors.pink
            ],
          ));
    });
  });

  //range-gradient without stops
  group('range-gradient without stops and isInversed', () {
    testWidgets('range-gradient without stops and isInversed',
        (WidgetTester tester) async {
      final _RangeTestCasesExamples container =
          _rangeTestCases('range-gradient without stops and isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range-gradient without stops and isInversed', () {
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.enableLoadingAnimation, true);
      expect(
        gauge.axes[0].ranges![0].gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ),
      );
    });
  });
}

_RangeTestCasesExamples _rangeTestCases(String sampleName) {
  return _RangeTestCasesExamples(sampleName);
}

class _RangeTestCasesExamples extends StatelessWidget {
  _RangeTestCasesExamples(String sampleName) {
    gauge = getRangeTestSample(sampleName);
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
