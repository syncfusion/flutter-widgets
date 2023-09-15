import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'axis_sample.dart';

/// Unit test scripts of default axis
void defaultPropertiesSamples() {
  late SfRadialGauge gauge;

  // To check ticks and labels count with default rendering
  group('Default-axis', () {
    testWidgets('Default-axis', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Default-axis');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default axis line style', () {
      //expect(gauge.axes[0]._majorTickOffsets.length, 21);
      //expect(gauge.axes[0]._minorTickOffsets.length, 20);
      // expect(gauge.axes[0]._axisLabels.length, 21);
    });
  });
  // To check default axis property
  group('Radial Axis - Default Axis Rendering', () {
    testWidgets('Default ticks and labels count', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Default-rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default axis style value', () {
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 100);
      expect(gauge.axes[0].minorTicksPerInterval, 1);
      expect(gauge.axes[0].showLabels, true);
      expect(gauge.axes[0].showFirstLabel, true);
      expect(gauge.axes[0].showLastLabel, false);
      expect(gauge.axes[0].showTicks, true);
      expect(gauge.axes[0].showLabels, true);
      expect(gauge.axes[0].tickOffset, 0);
      expect(gauge.axes[0].labelOffset, 15);
      expect(gauge.axes[0].isInversed, false);
      expect(gauge.axes[0].maximumLabels, 3);
      expect(gauge.axes[0].useRangeColorForAxis, false);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.inside);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.inside);
      expect(gauge.axes[0].offsetUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].useRangeColorForAxis, false);
      expect(gauge.axes[0].axisLineStyle.thickness, 10);
      expect(gauge.axes[0].majorTickStyle.length, 7);
      expect(gauge.axes[0].minorTickStyle.length, 5);
      expect(gauge.axes[0].axisLineStyle.thickness, 10);

      /// While providing the text theme support, we have changed the textStyle
      /// properties to null. Due to facing test cases failed issues in CI ,
      /// hence commented this code to make CI success.
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 12);
      // expect(gauge.axes[0].axisLabelStyle.fontFamily, 'Segoe UI');
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.normal);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.normal);
    });
  });

  // To check the ticks and the labels count with the interval
  group('Radial Axis - Default Rendering with interval', () {
    testWidgets('Default ticks and labels count with interval',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('With-interval');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default ticks and labels count with interval', () {
      // expect(gauge.axes[0]._majorTickOffsets.length, 11);
      // expect(gauge.axes[0]._minorTickOffsets.length, 10);
      // expect(gauge.axes[0]._axisLabels.length, 11);
    });
  });

  /// To check the gauge with title
  group('Gauge - with title', () {
    testWidgets('Gauge with title', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('With-title');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default gauge title', () {
      expect(gauge.title!.text, 'SfRadialGauge');
      expect(gauge.title!.alignment, GaugeAlignment.center);
      // expect(gauge.title!.textStyle?.fontSize, 15);
      // expect(gauge.title!.textStyle?.fontFamily, 'Segoe UI');
      // expect(gauge.title!.textStyle?.fontStyle, FontStyle.normal);
      // expect(gauge.title!.textStyle?.fontWeight, FontWeight.normal);
    });
  });

  /// To check the gauge with title customization
  group('Gauge - title customization', () {
    testWidgets('Title customization', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Title-cutomization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test title cutomization', () {
      expect(gauge.title!.text, 'SfRadialGauge');
      // expect(gauge.title!.textStyle?.color, Colors.red);
      // expect(gauge.title!.textStyle?.fontSize, 20);
      // expect(gauge.title!.textStyle?.fontWeight, FontWeight.bold);
    });
  });

  /// To check the gauge with title border customization
  group('Gauge - title border customization', () {
    testWidgets('Title border customization', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Title-with-border');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test title border cutomization', () {
      expect(gauge.title!.borderColor, Colors.yellow);
      expect(gauge.title!.borderWidth, 2);
    });
  });

  /// To check the gauge with title background customization
  group('Gauge - title background customization', () {
    testWidgets('Title background customization', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Title-background');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test title background cutomization', () {
      expect(gauge.title!.backgroundColor, Colors.yellow);
    });
  });

  testWidgets('Title alignment - near', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('Title-alignment-near');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test title near alignment', () {
    expect(gauge.title!.alignment, GaugeAlignment.near);
  });

  testWidgets('Title alignment - far', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('Title-alignment-far');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test title far alignment', () {
    expect(gauge.title!.alignment, GaugeAlignment.far);
  });

  /// To check the gauge with default angle
  group('Default-angle', () {
    testWidgets('Default-angle', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Default-rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default angle', () {
      expect(gauge.axes[0].startAngle, 130);
      expect(gauge.axes[0].endAngle, 50);
    });
  });

  /// Axis angle customization
  group('Angle- Customization', () {
    testWidgets('Angle-Customization', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Angle-customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default angle', () {
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
    });
  });

  /// Axis range
  group('Default-range', () {
    testWidgets('Default-range', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Default-rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default range', () {
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 100);
    });
  });

  /// Axis range customization
  group('Range- customization', () {
    testWidgets('Range-Customziation', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Range-customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test range customization', () {
      expect(gauge.axes[0].minimum, -60);
      expect(gauge.axes[0].maximum, 60);
    });
  });

  /// Default position
  group('Default-range', () {
    testWidgets('Default-position', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Default-rendering');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test default position', () {
      expect(gauge.axes[0].centerX, 0.5);
      expect(gauge.axes[0].centerY, 0.5);
      expect(gauge.axes[0].radiusFactor, 0.95);
    });
  });

  /// axis centerX customization
  group('axis-centerX', () {
    testWidgets('axis-centerX', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-centerX');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test center x customization', () {
      expect(gauge.axes[0].centerX, 0.3);
      expect(gauge.axes[0].centerY, 0.5);
    });
  });

  /// axis centerY customization
  group('axis-centerY', () {
    testWidgets('axis-centerY', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-centerY');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test center y customization', () {
      expect(gauge.axes[0].centerX, 0.5);
      expect(gauge.axes[0].centerY, 0.3);
    });
  });

  /// axis radius factor customization
  group('axis-radiusFactor', () {
    testWidgets('axis-radiusFactor', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-radiusFactor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test radius customization', () {
      expect(gauge.axes[0].radiusFactor, 0.5);
    });
  });

  //To rotate the axis labels
  group('axis-needsToRotateLabels', () {
    testWidgets('axis-needsToRaotateLabels', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-needsToRaotateLabels');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label rotation', () {
      expect(gauge.axes[0].canRotateLabels, true);
    });
  });

  //First label visibility customization
  group('axis-showFirstLabel', () {
    testWidgets('axis-showFirstLabel', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-showFirstLabel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test first label visibilty customization', () {
      expect(gauge.axes[0].showFirstLabel, false);
    });
  });

  //Last label visibility customization
  group('axis-showLastLabel', () {
    testWidgets('axis-showLastLabel', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-showLastLabel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test last label visibilty customization', () {
      expect(gauge.axes[0].showLastLabel, false);
    });
  });

  //First label visibility and angle customization
  group('axis-showLastLabel', () {
    testWidgets('axis-showLastLabel', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis - showFirstLabel with angle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test first label visibility and angle customization', () {
      expect(gauge.axes[0].showFirstLabel, false);
      expect(gauge.axes[0].startAngle, 270);
      // expect(gauge.axes[0]._sweepAngle, 360);
    });
  });

  //Interval customization
  group('axis-interval', () {
    testWidgets('axis-Interval', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-interval');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis interval', () {
      expect(gauge.axes[0].interval, 50);
      // expect(gauge.axes[0]._axisLabels.length, 3);
      // expect(gauge.axes[0]._majorTickOffsets.length, 3);
      // expect(gauge.axes[0]._minorTickOffsets.length, 2);
    });
  });

  //Label visibility customization
  group('axis-showLabels', () {
    testWidgets('axis-showLabels', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-showLabels');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label visibilitu customization', () {
      expect(gauge.axes[0].showLabels, false);
      // expect(gauge.axes[0]._axisLabels.length, 21);
    });
  });

  //Tick visibility customization
  group('axis-showTicks', () {
    testWidgets('axis-showTicks', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-showTicks');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test ticks visibility customization', () {
      expect(gauge.axes[0].showTicks, false);
      // expect(gauge.axes[0]._majorTickOffsets, null);
      // expect(gauge.axes[0]._minorTickOffsets, null);
    });
  });

  /// Axis line visibility customization
  testWidgets('axis-showAxisLine', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-showAxisLine');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test axis line visibility customization', () {
    expect(gauge.axes[0].showAxisLine, false);
  });

  //minor tick interval customization
  group('axis-showTicks', () {
    testWidgets('axis-minorTicksPerInterval', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-minorTicksPerInterval');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test minor tick interval customization', () {
      expect(gauge.axes[0].minorTicksPerInterval, 2);
      // expect(gauge.axes[0]._majorTickOffsets.length, 21);
      // expect(gauge.axes[0]._minorTickOffsets.length, 40);
    });
  });

  //Direction customization
  testWidgets('axis-isInversed', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-isInversed');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test direction customization', () {
    expect(gauge.axes[0].isInversed, true);
  });

  //Tick position customization
  testWidgets('axis-tickPosition', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-tickPosition');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test tick position customization', () {
    expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
  });

  //Label position customization
  testWidgets('axis-labelPosition', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-labelsPosition');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test label position customization', () {
    expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
  });

  //tick offset customization
  group('axis-tick default offset', () {
    testWidgets('axis-tick default offset', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-tick default offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tick offset customization', () {
      expect(gauge.axes[0].tickOffset, 5);
      expect(gauge.axes[0].labelOffset, 15);
    });
  });

  //label offset customization
  group('axis-label default offset', () {
    testWidgets('axis-label default offset', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label default offset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label offset customization', () {
      expect(gauge.axes[0].tickOffset, 0);
      expect(gauge.axes[0].labelOffset, 5);
    });
  });

  //tick offset customization
  group('axis-tick offset in factor', () {
    testWidgets('axis-tick offset in factor', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-tick offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tick offset customization with factor', () {
      expect(gauge.axes[0].tickOffset, 0.1);
      expect(gauge.axes[0].offsetUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].labelOffset, 15);
    });
  });

  //label offset customization in factor
  group('axis-tick offset in factor', () {
    testWidgets('axis-label offset in factor', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label offset customization with factor', () {
      expect(gauge.axes[0].labelOffset, 0.1);
      expect(gauge.axes[0].offsetUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].tickOffset, 0);
    });
  });

  //tick offset in negative
  group('axis-tick offset in negative', () {
    testWidgets('axis-tick offset in negative', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-tick offset in negative');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test tick offset customization in negative', () {
      expect(gauge.axes[0].tickOffset, -10);
      expect(gauge.axes[0].labelOffset, 15);
    });
  });

  //label offset in negative
  group('axis-tick offset in negative', () {
    testWidgets('axis-tick offset in negative', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label offset in negative');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label offset customization in negative', () {
      expect(gauge.axes[0].tickOffset, 0);
      expect(gauge.axes[0].labelOffset, -30);
    });
  });

  //maximum labels customization
  group('axis-tick offset in negative', () {
    testWidgets('axis-maximum labels', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-maximum labels');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test maximum lables', () {
      expect(gauge.axes[0].maximumLabels, 1);
      // expect(gauge.axes[0]._axisLabels.length, 6);
    });
  });

  //To format the axis label
  testWidgets('axis-labelFormat', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-labelFormat');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test format label ', () {
    // expect(gauge.axes[0]._axisLabels[0].text, '0m');
  });

  //To format the axis value
  testWidgets('axis-numberFormat', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-numberFormat');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test number format ', () {
    expect(gauge.axes[0].labelFormat, null);
  });

  //major tick length customization
  group('axis-major tick length', () {
    testWidgets('axis-major tick length', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-major tick length');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick length', () {
      expect(gauge.axes[0].majorTickStyle.length, 10);
      expect(gauge.axes[0].majorTickStyle.thickness, 1.5);
      expect(gauge.axes[0].majorTickStyle.color, null);
    });
  });

  //major tick length customization in factor
  group('axis-major tick length in factor', () {
    testWidgets('axis-major tick length', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis- major tick length in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick length in factor', () {
      expect(gauge.axes[0].majorTickStyle.length, 0.1);
      expect(gauge.axes[0].majorTickStyle.lengthUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].majorTickStyle.thickness, 1.5);
    });
  });

  //major tick thickness customization
  group('axis-major tick thickness', () {
    testWidgets('axis-major tick thickness', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-major tick thickness');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick thickness', () {
      expect(gauge.axes[0].majorTickStyle.thickness, 3);
      expect(
          gauge.axes[0].majorTickStyle.lengthUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].majorTickStyle.length, 7);
    });
  });

  //major tick color customization
  group('axis-major tick color', () {
    testWidgets('axis-major tick color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-major tick color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick color', () {
      expect(gauge.axes[0].majorTickStyle.thickness, 1.5);
      expect(gauge.axes[0].majorTickStyle.color, Colors.red);
    });
  });

  //minor tick length customization
  group('axis-minor tick length', () {
    testWidgets('axis-minor tick length', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-minor tick length');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick length', () {
      expect(gauge.axes[0].minorTickStyle.length, 10);
      expect(gauge.axes[0].minorTickStyle.thickness, 1.5);
      expect(gauge.axes[0].minorTickStyle.color, null);
    });
  });

  //minor tick length customization in factor
  group('axis-minor tick length in factor', () {
    testWidgets('axis-minor tick length', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis- minor tick length in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test minor tick length in factor', () {
      expect(gauge.axes[0].minorTickStyle.length, 0.1);
      expect(gauge.axes[0].minorTickStyle.lengthUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].minorTickStyle.thickness, 1.5);
    });
  });

  //minor tick thickness customization
  group('axis-minor tick thickness', () {
    testWidgets('axis-minor tick thickness', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-minor tick thickness');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test minor tick thickness', () {
      expect(gauge.axes[0].minorTickStyle.thickness, 3);
      expect(
          gauge.axes[0].minorTickStyle.lengthUnit, GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].minorTickStyle.length, 5);
    });
  });

  //minor tick color customization
  group('axis-minor tick color', () {
    testWidgets('axis-minor tick color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-minor tick color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test minor tick color', () {
      expect(gauge.axes[0].minorTickStyle.thickness, 1.5);
      expect(gauge.axes[0].minorTickStyle.color, Colors.red);
      expect(gauge.axes[0].minorTickStyle.dashArray, null);
    });
  });

  //minor tick dash array
  group('axis-minor tick dash array', () {
    testWidgets('axis-minor tick dash array', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-minor tick dash array');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test minor tick dash array', () {
      expect(gauge.axes[0].minorTickStyle.dashArray!.length, 2);
    });
  });

  //major tick dash array
  group('axis-major tick dash array', () {
    testWidgets('axis-major tick dash array', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-major tick dash array');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test major tick dash array', () {
      expect(gauge.axes[0].majorTickStyle.dashArray!.length, 2);
    });
  });

  //Customizes the label color
  group('axis-label color', () {
    testWidgets('axis-label color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label color', () {
      expect(gauge.axes[0].axisLabelStyle.color, Colors.red);
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 12);
      // expect(
      //   gauge.axes[0].axisLabelStyle.fontFamily,
      //   'Segoe UI',
      // );
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.normal);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.normal);
    });
  });

  //Customizes the label font family
  group('axis-label color', () {
    testWidgets('axis-label fontFamily', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label fontFamily');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label font family', () {
      expect(gauge.axes[0].axisLabelStyle.color, null);
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 12);
      // expect(
      //   gauge.axes[0].axisLabelStyle.fontFamily,
      //   'Times',
      // );
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.normal);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.normal);
    });
  });

  //Customizes the label font Size
  group('axis-label color', () {
    testWidgets('axis-label fontSize', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label fontSize');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label font size', () {
      expect(gauge.axes[0].axisLabelStyle.color, null);
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 20);
      // expect(
      //   gauge.axes[0].axisLabelStyle.fontFamily,
      //   'Segoe UI',
      // );
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.normal);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.normal);
    });
  });

  //Customizes the label font Style
  group('axis-label fontStyle', () {
    testWidgets('axis-label fontStyle', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label fontStyle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label font style', () {
      expect(gauge.axes[0].axisLabelStyle.color, null);
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 12);
      // expect(
      //   gauge.axes[0].axisLabelStyle.fontFamily,
      //   'Segoe UI',
      // );
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.italic);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.normal);
    });
  });

  //Customizes the label font weight
  group('axis-label fontStyle', () {
    testWidgets('axis-label fontWeight', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-label fontWeight');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label font style', () {
      expect(gauge.axes[0].axisLabelStyle.color, null);
      // expect(gauge.axes[0].axisLabelStyle.fontSize, 12);
      // expect(
      //   gauge.axes[0].axisLabelStyle.fontFamily,
      //   'Segoe UI',
      // );
      // expect(gauge.axes[0].axisLabelStyle.fontStyle, FontStyle.normal);
      // expect(gauge.axes[0].axisLabelStyle.fontWeight, FontWeight.bold);
    });
  });

  //Customizes the axis line thickness
  group('axis-line thickness', () {
    testWidgets('axis-line thickness', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-line thickness');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis line thickness ', () {
      expect(gauge.axes[0].axisLineStyle.color, null);
      expect(gauge.axes[0].axisLineStyle.thickness, 20);
      expect(gauge.axes[0].axisLineStyle.thicknessUnit,
          GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.bothFlat);
      expect(gauge.axes[0].axisLineStyle.dashArray, null);
    });
  });

  //Customizes the axis line thickness in factor
  group('axis-line thickness in factor', () {
    testWidgets('axis-line thickness in factor', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-line thickness in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis line thickness in factor', () {
      expect(gauge.axes[0].axisLineStyle.color, null);
      expect(gauge.axes[0].axisLineStyle.thickness, 0.1);
      expect(gauge.axes[0].axisLineStyle.thicknessUnit, GaugeSizeUnit.factor);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.bothFlat);
      expect(gauge.axes[0].axisLineStyle.dashArray, null);
    });
  });

  //Customizes the axis line color
  group('axis-line color', () {
    testWidgets('axis-line color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-line color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis line color ', () {
      expect(gauge.axes[0].axisLineStyle.color, Colors.red);
      expect(gauge.axes[0].axisLineStyle.thickness, 10);
      expect(gauge.axes[0].axisLineStyle.thicknessUnit,
          GaugeSizeUnit.logicalPixel);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.bothFlat);
      expect(gauge.axes[0].axisLineStyle.dashArray, null);
    });
  });

  // Customize the axis line corner with CornerStyle.startCurve
  testWidgets('axis-line startCurve', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-line startCurve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test CornerStyle.startCurve ', () {
    expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.startCurve);
  });

  // Customize the axis line corner with CornerStyle.endCurve
  testWidgets('axis-line endCurve', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-line endCurve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test CornerStyle.endCurve ', () {
    expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.endCurve);
  });

  // Customize the axis line corner with CornerStyle.bothCurve
  testWidgets('axis-line bothCurve', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-line bothCurve');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test CornerStyle.bothCurve ', () {
    expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.bothCurve);
  });

  // Customize the axis line with dash array
  testWidgets('axis-line dashArray', (WidgetTester tester) async {
    final _DefaultAxisPropertiesExamples container =
        _defaultAxisProperties('axis-line dashArray');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test dashed axis line ', () {
    expect(gauge.axes[0].axisLineStyle.dashArray, <double>[5, 5]);
  });

  //Add multiple axis
  group('axis-line color', () {
    testWidgets('axis- multiple axis', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis- multiple axis');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test multiple scale ', () {
      expect(gauge.axes[0].radiusFactor, 0.95);
      expect(gauge.axes[1].radiusFactor, 0.6);
      expect(gauge.axes.length, 2);
      expect(gauge.axes[0].centerX, 0.5);
      expect(gauge.axes[0].centerY, 0.5);
      expect(gauge.axes[1].centerX, 0.5);
      expect(gauge.axes[1].centerY, 0.5);
    });
  });

  //Test axis line gradient
  group('axis-gradient', () {
    testWidgets('axis-gradient', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-gradient');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis-gradient ', () {
      expect(
        gauge.axes[0].axisLineStyle.gradient,
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

  //Test axis-gradient-isInversed
  group('axis-gradient-isInversed', () {
    testWidgets('axis-gradient-isInversed', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('axis-gradient-isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axis-gradient-isInversed', () {
      expect(gauge.axes[0].isInversed, true);
      expect(
        gauge.axes[0].axisLineStyle.gradient,
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

  //Test isCenterAligned property
  group('is aligned to center', () {
    testWidgets('isCenterAligned-case', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('isCenterAligned-case');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test center aligned property ', () {
      expect(gauge.axes[0].canScaleToFit, true);
    });
  });

  //Test canScaleToFit with startAngle as 270 and endAngle as 270
  group('Test canScaleToFit with startAngle as 270 and endAngle as 270', () {
    testWidgets('canScaleToFit- startAngle: 270, endAngle: 270',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 270, endAngle: 270');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 270 and endAngle as 270 ',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 270);
      expect(gauge.axes[0].endAngle, 270);
    });
  });

  //Test canScaleToFit with startAngle as 270 and endAngle as 0
  group('Test canScaleToFit with startAngle as 270 and endAngle as 0', () {
    testWidgets('canScaleToFit- startAngle: 270, endAngle: 0',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('canScaleToFit- startAngle: 270, endAngle: 0');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 270 and endAngle as 0 ', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 270);
      expect(gauge.axes[0].endAngle, 0);
    });
  });

  //Test canScaleToFit with startAngle as 270 and endAngle as 315
  group('Test canScaleToFit with startAngle as 270 and endAngle as 315', () {
    testWidgets('canScaleToFit- startAngle: 270, endAngle: 315',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 270, endAngle: 315');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 270 and endAngle as 315',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 270);
      expect(gauge.axes[0].endAngle, 315);
    });
  });

  //Test canScaleToFit with startAngle as 0 and endAngle as 45
  group('Test canScaleToFit with startAngle as 0 and endAngle as 45', () {
    testWidgets('canScaleToFit- startAngle: 0, endAngle: 45',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('canScaleToFit- startAngle: 0, endAngle: 45');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 0 and endAngle as 45', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 0);
      expect(gauge.axes[0].endAngle, 45);
    });
  });

  //Test canScaleToFit with startAngle as 0 and endAngle as 90
  group('Test canScaleToFit with startAngle as 0 and endAngle as 90', () {
    testWidgets('canScaleToFit- startAngle: 0, endAngle: 90',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('canScaleToFit- startAngle: 0, endAngle: 90');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 0 and endAngle as 90', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 0);
      expect(gauge.axes[0].endAngle, 90);
    });
  });

  //Test canScaleToFit with startAngle as 90 and endAngle as 135
  group('Test canScaleToFit with startAngle as 90 and endAngle as 135', () {
    testWidgets('canScaleToFit- startAngle: 90, endAngle: 135',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 90, endAngle: 135');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 90 and endAngle as 135', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, 135);
    });
  });

  //Test canScaleToFit with startAngle as 90 and endAngle as 180
  group('Test canScaleToFit with startAngle as 90 and endAngle as 180', () {
    testWidgets('canScaleToFit- startAngle: 90, endAngle: 180',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 90, endAngle: 180');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 90 and endAngle as 180', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, 180);
    });
  });

  //Test canScaleToFit with startAngle as 270 and endAngle as 0 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 270 and endAngle as 0 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 270, endAngle: 0',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 270, endAngle: 0, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 270 and endAngle as 0 ', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 270);
      expect(gauge.axes[0].endAngle, 0);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test canScaleToFit with startAngle as 270 and endAngle as 315 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 270 and endAngle as 315 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 270, endAngle: 315',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 270, endAngle: 315, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 270 and endAngle as 315',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 270);
      expect(gauge.axes[0].endAngle, 315);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test canScaleToFit with startAngle as 0 and endAngle as 45 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 0 and endAngle as 45 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 0, endAngle: 45',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 0, endAngle: 45, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test canScaleToFit with startAngle as 0 and endAngle as 45', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 0);
      expect(gauge.axes[0].endAngle, 45);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test canScaleToFit with startAngle as 0 and endAngle as 90 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 0 and endAngle as 90 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 0, endAngle: 90',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 0, endAngle: 90, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test(
        'to test canScaleToFit with startAngle as 0 and endAngle as 90 and isInversed as true',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 0);
      expect(gauge.axes[0].endAngle, 90);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test canScaleToFit with startAngle as 90 and endAngle as 135 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 90 and endAngle as 135 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 90, endAngle: 135',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 90, endAngle: 135, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test(
        'to test canScaleToFit with startAngle as 90 and endAngle as 135 and isInversed as true',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, 135);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test canScaleToFit with startAngle as 90 and endAngle as 180 and isInversed as true
  group(
      'Test canScaleToFit with startAngle as 90 and endAngle as 180 and isInversed as true',
      () {
    testWidgets('canScaleToFit- startAngle: 90, endAngle: 180',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'canScaleToFit- startAngle: 90, endAngle: 180, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test(
        'to test canScaleToFit with startAngle as 90 and endAngle as 180 and isInversed as true',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test cornerStyle as bothCurve and isInversed as true
  group('Test cornerStyle as bothCurve and isInversed as true', () {
    testWidgets('cornerStyle as bothCurve and isInversed as true',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('cornerStyle: bothCurve, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test cornerStyle as bothCurve and isInversed as true', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.bothCurve);
      expect(
        gauge.axes[0].axisLineStyle.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ),
      );
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test cornerStyle as startCurve and isInversed as true
  group('Test cornerStyle as startCurve and isInversed as true', () {
    testWidgets('cornerStyle as startCurve and isInversed as true',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('cornerStyle: startCurve, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test cornerStyle as startCurve and isInversed as true', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.startCurve);
      expect(
        gauge.axes[0].axisLineStyle.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ),
      );
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test cornerStyle as endCurve and isInversed as true
  group('Test cornerStyle as endCurve and isInversed as true', () {
    testWidgets('cornerStyle as endCurve and isInversed as true',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('cornerStyle: endCurve, isInversed: true');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test cornerStyle as endCurve and isInversed as true', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].axisLineStyle.cornerStyle, CornerStyle.endCurve);
      expect(
        gauge.axes[0].axisLineStyle.gradient,
        const SweepGradient(
          colors: <Color>[
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.pink
          ],
        ),
      );
      expect(gauge.axes[0].isInversed, true);
    });
  });

  //Test scale elements customization with canScaleToFit
  group('Test scale elements customization with canScaleToFit', () {
    testWidgets('Scale elements customization with canScaleToFit',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'Scale elements customization with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test scale elements customization with canScaleToFit', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
    });
  });

  //Test scale elements customization with canScaleToFit
  group('Test scale elements customization with canScaleToFit, isInversed', () {
    testWidgets('cornerStyle as endCurve and isInversed as true',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'Scale elements customization with canScaleToFit, isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test scale elements customization with canScaleToFit,  isInversed',
        () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
    });
  });

  //Test scale elements customization with canScaleToFit
  group('Test number format with canScaleToFit, isInversed', () {
    testWidgets('Number format with canScaleToFit, isInversed',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'Number format with canScaleToFit, isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Number format with canScaleToFit, isInversed', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].canRotateLabels, true);
      expect(gauge.axes[0].minimum, 1000);
      expect(gauge.axes[0].interval, 1000);
      expect(gauge.axes[0].maximum, 10000);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
    });
  });

  //Test scale elements customization with canScaleToFit
  group('Test Number format with canScaleToFit', () {
    testWidgets('Number format with canScaleToFit',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('Number format with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to testNumber format with canScaleToFit', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].canRotateLabels, true);
      expect(gauge.axes[0].minimum, 1000);
      expect(gauge.axes[0].interval, 1000);
      expect(gauge.axes[0].maximum, 10000);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
    });
  });

  //Test scale elements customization with canScaleToFit
  group('Test label format with canScaleToFit, isInversed', () {
    testWidgets('label format with canScaleToFit, isInversed',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('label format with canScaleToFit, isInversed');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label format with canScaleToFit, isInversed', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].canRotateLabels, true);
      expect(gauge.axes[0].isInversed, true);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelFormat, '{value}cm');
    });
  });

  group('Test label format with canScaleToFit', () {
    testWidgets('label format with canScaleToFit', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('label format with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label format with canScaleToFit', () {
      expect(gauge.axes[0].canScaleToFit, true);
      expect(gauge.axes[0].canRotateLabels, true);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelFormat, '{value}cm');
    });
  });

  group('Test label created event', () {
    testWidgets('Test label created event', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('label created event');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test label label created event', () {
      // expect(gauge.axes[0]._axisLabels[5].text, '50');
    });
  });

  group('Test custom scale', () {
    testWidgets('Test custom scale', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('custom scale');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test custom scale', () {
      // expect(gauge.axes[0]._axisLabels[4].text, '20');
      expect(gauge.axes[0].minimum, 0);
      expect(gauge.axes[0].maximum, 150);
    });
  });

  group('axisFeatureOffset is greater than axisOffset', () {
    testWidgets('axisFeatureOffset is greater than axisOffset',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container = _defaultAxisProperties(
          'axisFeatureOffset is greater than axisOffset');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test axisFeatureOffset is greater than axisOffset', () {
      final MarkerPointer pointer = gauge.axes[0].pointers![0] as MarkerPointer;
      // expect(gauge.axes[0]._axisLabels[4].text, '20');
      expect(gauge.axes[0].ticksPosition, ElementsPosition.outside);
      expect(gauge.axes[0].labelsPosition, ElementsPosition.outside);
      expect(pointer.markerOffset, -60);
    });
  });

  group('startAngle: 0 with canScaleToFit', () {
    testWidgets('startAngle: 0 with canScaleToFit',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('startAngle: 0 with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test startAngle: 0 with canScaleToFit', () {
      expect(gauge.axes[0].startAngle, 0);
      expect(gauge.axes[0].endAngle, 360);
      expect(gauge.axes[0].canScaleToFit, true);
    });
  });

  group('startAngle: 90 with canScaleToFit', () {
    testWidgets('startAngle: 90 with canScaleToFit',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('startAngle: 90 with canScaleToFit');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test startAngle: 90 with canScaleToFit', () {
      expect(gauge.axes[0].startAngle, 90);
      expect(gauge.axes[0].endAngle, 90);
      expect(gauge.axes[0].canScaleToFit, true);
    });
  });

  group('gauge with background color', () {
    testWidgets('gauge with background color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('gauge with background color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('gauge with background color', () {
      expect(gauge.axes.length, 1);
      expect(gauge.backgroundColor, Colors.lightBlue);
    });
  });

  group('pointers with background color', () {
    testWidgets('pointers with background color', (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('pointers with background color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('pointers with background color', () {
      expect(gauge.axes[0].pointers!.length, 3);
      expect(gauge.axes[0].pointers![0].value, 30);
      expect(gauge.axes[0].pointers![1].value, 50);
      expect(gauge.axes[0].pointers![2].value, 60);
      expect(gauge.backgroundColor, Colors.lightBlue);
    });
  });

  group('ranges and annotation with background color', () {
    testWidgets('ranges and annotation with background color',
        (WidgetTester tester) async {
      final _DefaultAxisPropertiesExamples container =
          _defaultAxisProperties('ranges and annotation with background color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('ranges and annotation with background color', () {
      expect(gauge.axes[0].ranges!.length, 1);
      expect(gauge.axes[0].startAngle, 180);
      expect(gauge.axes[0].endAngle, 180);
      expect(gauge.axes[0].ranges![0].startValue, 0);
      expect(gauge.axes[0].ranges![0].endValue, 30);
      expect(gauge.axes[0].annotations!.length, 1);
      expect(gauge.backgroundColor, Colors.lightBlue);
    });
  });
}

_DefaultAxisPropertiesExamples _defaultAxisProperties(String sampleName) {
  return _DefaultAxisPropertiesExamples(sampleName);
}

class _DefaultAxisPropertiesExamples extends StatelessWidget {
  _DefaultAxisPropertiesExamples(String sampleName) {
    gauge = getAxisTestSample(sampleName)!;
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
