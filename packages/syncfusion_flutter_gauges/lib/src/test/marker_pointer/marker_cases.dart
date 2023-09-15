import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../gauges.dart';
import 'marker_samples.dart';

/// Unit test scripts of marker pointer
void markerSamples() {
  SfRadialGauge? gauge;

  // Default-marker
  group('Default-marker', () {
    testWidgets('Default-marker', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Default-marker');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Default-marker', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 0);
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.color, null);
      expect(marker.markerHeight, 10);
      expect(marker.markerWidth, 10);
      expect(marker.markerOffset, 0);
      expect(marker.enableDragging, false);
      expect(marker.enableAnimation, false);
      expect(marker.animationType, AnimationType.ease);
    });
  });

  /// Marker-dragging
  testWidgets('Marker-dragging', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _MarkerTestCasesExamples('Marker-dragging');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test Marker-dragging', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.enableDragging, true);
  });

  // AnimationType - bounceOut
  group('AnimationType - bounceOut', () {
    testWidgets('AnimationType - bounceOut', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - bounceOut');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to testAnimationType - bounceOut', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge!.axes[0].pointers![0].animationType, AnimationType.bounceOut);
    });
  });

  // 'AnimationType - linear
  group('AnimationType - linear', () {
    testWidgets('AnimationType - linear', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - linear');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to testAnimationType - bounceOut', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(gauge!.axes[0].pointers![0].animationType, AnimationType.linear);
    });
  });

  // AnimationType - ease
  group('AnimationType - ease', () {
    testWidgets('AnimationType - ease', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - ease');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - ease', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(gauge!.axes[0].pointers![0].animationType, AnimationType.ease);
    });
  });

  // AnimationType - easeInCirc
  group('AnimationType - easeInCirc', () {
    testWidgets('AnimationType - easeInCirc', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - easeInCirc');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - easeInCirc', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge!.axes[0].pointers![0].animationType, AnimationType.easeInCirc);
    });
  });

  // AnimationType - elasticOut
  group('AnimationType - elasticOut', () {
    testWidgets('AnimationType - elasticOut', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - elasticOut');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - elasticOut', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge!.axes[0].pointers![0].animationType, AnimationType.elasticOut);
    });
  });

  // AnimationType - slowMiddle
  group('AnimationType - slowMiddle', () {
    testWidgets('AnimationType - slowMiddle', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - slowMiddle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - slowMiddle', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge!.axes[0].pointers![0].animationType, AnimationType.slowMiddle);
    });
  });

  // AnimationType - easeOutBack
  group('AnimationType - easeOutBack', () {
    testWidgets('AnimationType - easeOutBack', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('AnimationType - easeOutBack');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test AnimationType - easeOutBack', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(
          gauge!.axes[0].pointers![0].animationType, AnimationType.easeOutBack);
    });
  });

  // Animation-Duration
  group('Animation-Duration', () {
    testWidgets('Animation-Duration', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Animation-Duration');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Animation-Duration', () {
      expect(gauge!.axes[0].pointers!.length, 1);
      expect(gauge!.axes[0].pointers![0].value, 50);
      expect(gauge!.axes[0].pointers![0].enableAnimation, true);
      expect(gauge!.axes[0].pointers![0].animationType, AnimationType.ease);
      expect(gauge!.axes[0].pointers![0].animationDuration, 4000);
    });
  });

  //MarkerType-Circle
  testWidgets('MarkerType-Circle', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _markerTestCases('MarkerType-Circle');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test MarkerType-Circle', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.markerType, MarkerType.circle);
  });

  //MarkerType-Rectangle
  testWidgets('MarkerType-Rectangle', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _markerTestCases('MarkerType-Rectangle');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to testMarkerType-Rectangle', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.markerType, MarkerType.rectangle);
  });

  //MarkerType-Diamond
  testWidgets('MarkerType-Diamond', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _markerTestCases('MarkerType-Diamond');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test MarkerType-Diamond', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.markerType, MarkerType.diamond);
  });

  //MarkerType-Triangle
  testWidgets('MarkerType-Triangle', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _markerTestCases('MarkerType-Triangle');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test MarkerType-Triangle', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.markerType, MarkerType.triangle);
  });

  //MarkerType-invertedTriangle
  testWidgets('MarkerType-invertedTriangle', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container =
        _markerTestCases('MarkerType-invertedTriangle');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test MarkerType-invertedTriangle', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.markerType, MarkerType.invertedTriangle);
  });

  //MarkerType-image
  group('MarkerType-image', () {
    testWidgets('MarkerType-image', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('MarkerType-image');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test MarkerType-image', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerType, MarkerType.image);
      expect(marker.imageUrl, null);
    });
  });

  //MarkerType-text
  group('MarkerType-text', () {
    testWidgets('MarkerType-text', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('MarkerType-text');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test MarkerType-text', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerType, MarkerType.text);
      expect(marker.text, 'Gauge');
      // expect(marker.textStyle.fontSize, 12);
      // expect(marker.textStyle.fontFamily, 'Segoe UI');
      // expect(marker.textStyle.fontWeight, FontWeight.normal);
      // expect(marker.textStyle.fontStyle, FontStyle.normal);
      // expect(marker.textStyle.color, null);
    });
  });

  //text-Customization
  group('text-Customization', () {
    testWidgets('text-Customization', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('text-Customization');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test text-Customization', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerType, MarkerType.text);
      expect(marker.text, 'Gauge');
      expect(marker.textStyle.fontSize, 20);
      expect(marker.textStyle.fontFamily, 'Times');
      expect(marker.textStyle.fontWeight, FontWeight.bold);
      expect(marker.textStyle.fontStyle, FontStyle.italic);
      expect(marker.textStyle.color, Colors.red);
    });
  });

  //Marker-color
  testWidgets('Marker-color', (WidgetTester tester) async {
    final _MarkerTestCasesExamples container = _markerTestCases('Marker-color');
    await tester.pumpWidget(container);
    gauge = container.gauge;
  });

  test('to test Marker-color', () {
    final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
    expect(marker.color, Colors.lightBlueAccent);
  });

  //Marker-width
  group('Marker-width', () {
    testWidgets('Marker-width', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Marker-width');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Marker-width', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerWidth, 30);
      expect(marker.markerHeight, 10);
    });
  });

  //Marker-height
  group('Marker-height', () {
    testWidgets('Marker-height', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Marker-height');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Marker-height', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerWidth, 10);
      expect(marker.markerHeight, 30);
    });
  });

  //Marker-Size
  group('Marker-Size', () {
    testWidgets('Marker-Size', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Marker-Size');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Marker-Size', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerWidth, 30);
      expect(marker.markerHeight, 30);
    });
  });

  //border-color
  group('border-color', () {
    testWidgets('border-color', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('border-color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test border-color', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 0);
      expect(marker.borderColor, Colors.black);
    });
  });

  //border-width
  group('border-width', () {
    testWidgets('border-width', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('border-width');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test border-width', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.borderColor, null);
    });
  });

  //Border-customization
  group('Border-customzation', () {
    testWidgets('Border-customzation', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Border-customzation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Border-customzation', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.borderColor, Colors.black);
    });
  });

  //Border-customization for rectangle
  group('Border-customzation for rectangle', () {
    testWidgets('Border-customzation for rectangle',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Border-customzation for rectangle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Border-customzation for rectangle', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.markerType, MarkerType.rectangle);
      expect(marker.borderColor, Colors.black);
    });
  });

  //Border-customization for diamond
  group('Border-customzation for diamond', () {
    testWidgets('Border-customzation for diamond', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _MarkerTestCasesExamples('Border-customzation for diamond');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Border-customzation for diamond', () {
      expect(gauge!.enableLoadingAnimation, true);
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.markerType, MarkerType.diamond);
      expect(marker.borderColor, Colors.black);
    });
  });

  //Border-customization for triangle
  group('Border-customzation for triangle', () {
    testWidgets('Border-customzation for triangle',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Border-customzation for triangle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Border-customzation for triangle', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.enableAnimation, true);
      expect(marker.markerType, MarkerType.triangle);
      expect(marker.borderColor, Colors.black);
    });
  });

  //Border-customization for triangle
  group('Border-customzation for circle', () {
    testWidgets('Border-customzation for circle', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Border-customzation for circle');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Border-customzation for circle', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.borderWidth, 2);
      expect(marker.markerType, MarkerType.circle);
      expect(marker.borderColor, Colors.black);
    });
  });

  //Offset in pixel
  group('Offset in pixel', () {
    testWidgets('Offset in pixel', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Offset in pixel', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, 30);
      expect(marker.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //Negative offset in pixel
  group('Negative offset in pixel', () {
    testWidgets('Negative offset in pixel', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Negative offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in pixel', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, -30);
      expect(marker.offsetUnit, GaugeSizeUnit.logicalPixel);
    });
  });

  //Offset in factor
  group('Offset in factor', () {
    testWidgets('Offset in factor', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in pixel', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, 0.2);
      expect(marker.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //Negative offset in factor
  group('Negative offset in factor', () {
    testWidgets('Negative offset in factor', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('Negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test Negative offset in factor', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, -0.2);
      expect(marker.offsetUnit, GaugeSizeUnit.factor);
    });
  });

  //TicksPosition- offset in pixel
  group('TicksPosition- offset in pixel', () {
    testWidgets('TicksPosition- offset in pixel', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('TicksPosition- offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- offset in pixel', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, 30);
      expect(marker.offsetUnit, GaugeSizeUnit.logicalPixel);
      //  expect(marker._totalOffset,
      //     marker._axis._axisOffset + marker._actualMarkerOffset );
    });
  });

  //TicksPosition- offset in pixel
  group('TicksPosition- negative offset in pixel', () {
    testWidgets('TicksPosition- negative offset in pixel',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('TicksPosition- negative offset in pixel');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- negative offset in pixel', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, -30);
      expect(marker.offsetUnit, GaugeSizeUnit.logicalPixel);
      // expect(marker._totalOffset,
      //     marker._axis._getAxisOffset() + marker._actualMarkerOffset);
    });
  });

  //TicksPosition- offset in factor
  group('TicksPosition- offset in factor', () {
    testWidgets('TicksPosition- offset in factor', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('TicksPosition- offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- offset in factor', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, 0.2);
      expect(marker.offsetUnit, GaugeSizeUnit.factor);
      // expect(marker._totalOffset,
      //     marker._axis._axisOffset + marker._actualMarkerOffset);
    });
  });

  //TicksPosition- negative offset in factor
  group('TicksPosition- negative offset in factor', () {
    testWidgets('TicksPosition- negative offset in factor',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('TicksPosition- negative offset in factor');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test TicksPosition- negative offset in factor', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.markerOffset, -0.2);
      expect(marker.offsetUnit, GaugeSizeUnit.factor);
      // expect(marker._totalOffset,
      //     marker._axis._getAxisOffset() + marker._actualMarkerOffset);
    });
  });

  //marker pointer with loading animation
  group('marker pointer with loading animation', () {
    testWidgets('marker pointer with loading animation',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('marker pointer with loading animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test marker pointer with loading animation', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(gauge!.enableLoadingAnimation, true);
      expect(marker.value, 136);
      expect(marker.enableAnimation, false);
    });
  });

  //marker pointer with loadingAnimation and pointer animation
  group('marker pointer with laodingAnimation and pointer animation', () {
    testWidgets('marker pointer with laodingAnimation and pointer animation',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container = _markerTestCases(
          'marker pointer with laodingAnimation and pointer animation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test marker pointer with laodingAnimation and pointer animation',
        () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(gauge!.enableLoadingAnimation, true);
      expect(marker.value, 136);
      expect(marker.enableAnimation, true);
    });
  });

  //marker with 0 elevation
  group('marker with 0 elevation', () {
    testWidgets('marker with 0 elevation', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('marker with 0 elevation');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test marker with 0 elevation', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.elevation, 0);
    });
  });

  //marker with elevation as 5
  group('marker with elevation as 5', () {
    testWidgets('marker with elevation as 5', (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('marker with elevation as 5');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test marker with elevation as 5', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.elevation, 5);
    });
  });

  //marker with transparent overlay color
  group('marker with transparent overlay color', () {
    testWidgets('marker with transparent overlay color',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('marker with transparent overlay color');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test mmarker with transparent overlay color', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.overlayColor, Colors.transparent);
    });
  });

  //marker with overlay color as red
  group('marker with overlay color as red', () {
    testWidgets('marker with overlay color as red',
        (WidgetTester tester) async {
      final _MarkerTestCasesExamples container =
          _markerTestCases('marker with overlay color as red');
      await tester.pumpWidget(container);
      gauge = container.gauge;
    });

    test('to test marker with transparent overlay color', () {
      final MarkerPointer marker = gauge!.axes[0].pointers![0] as MarkerPointer;
      expect(marker.overlayColor, Colors.red.withOpacity(0.12));
    });
  });
}

_MarkerTestCasesExamples _markerTestCases(String sampleName) {
  return _MarkerTestCasesExamples(sampleName);
}

class _MarkerTestCasesExamples extends StatelessWidget {
  _MarkerTestCasesExamples(String sampleName) {
    gauge = getMarkerTestSample(sampleName);
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
