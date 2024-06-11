import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'ean8_samples.dart';

/// Unit test scripts of EAN-8
void ean8Samples() {
  SfBarcodeGenerator? barcode;
  late EAN8 symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('with-value') as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '1234567');
    });
  });

  group('enable-showValue', () {
    testWidgets('enable-showValue', (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('enable-showValue') as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test enable-showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('change bar color') as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('change background color') as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('set text spacing with show value')
              as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('text align as start with showValue', () {
    testWidgets('text align as start with showValue',
        (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('text align as start with showValue')
              as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test text align as start with showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.textAlign, TextAlign.start);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('set text style with all the properties')
              as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '11223344');
      expect(barcode?.textAlign, TextAlign.right);
      expect(barcode?.showValue, true);
      expect(
          barcode?.textStyle,
          const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set module with all properties', () {
    testWidgets('set module with all properties', (WidgetTester tester) async {
      final _EAN8TestCasesExamples container =
          _ean8TestCases('set module with all properties')
              as _EAN8TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as EAN8;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, '11223344');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _ean8TestCases(String sampleName) {
  return _EAN8TestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _EAN8TestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _EAN8TestCasesExamples(String sampleName) {
    _barcode = getEAN8Generator(sampleName);
  }

  late SfBarcodeGenerator _barcode;

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
            child: _barcode,
          ))),
    );
  }
}
