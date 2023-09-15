import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'code128_samples.dart';

/// Unit test scripts of Code128
void code128Samples() {
  SfBarcodeGenerator? barcode;
  late Code128 symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('with-value') as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
    });
  });

  group('with-value1', () {
    testWidgets('with-value1', (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('with-value1') as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'SYNCFUSION:/+=');
    });
  });

  group('enable-showValue', () {
    testWidgets('enable-showValue', (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('enable-showValue') as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test enable-showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('change bar color') as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('change background color')
              as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('set text spacing with show value')
              as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('text align as start with showValue', () {
    testWidgets('text align as start with showValue',
        (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('text align as start with showValue')
              as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test text align as start with showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
      expect(barcode?.textAlign, TextAlign.start);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _Code128TestCasesExamples container =
          _code128TestCases('set text style with all the properties')
              as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Code128');
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
      final _Code128TestCasesExamples container =
          _code128TestCases('set module with all properties')
              as _Code128TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, 'Code128');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _code128TestCases(String sampleName) {
  return _Code128TestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _Code128TestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Code128TestCasesExamples(String sampleName) {
    _barcode = getCode128Generator(sampleName);
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
