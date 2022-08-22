import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'codabar_samples.dart';

/// Unit test scripts of Codabar
void codabarSamples() {
  SfBarcodeGenerator? barcode;
  late Codabar symbology;
  group('Default-rendering', () {
    testWidgets('Default-rendering', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('with-value') as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
    });
  });

  group('with-value1', () {
    testWidgets('Default-rendering', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('with-value1') as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test with-value1', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '714411106011348790');
    });
  });

  group('with-specialcharcter', () {
    testWidgets('Default-rendering', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('with-specialcharcter')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test with-specialcharcter', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '6738989812:/+');
    });
  });

  group('enable-showValue', () {
    testWidgets('enable-showValue', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('enable-showValue') as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test enable-showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
    });
  });

  group('show value for longest digit', () {
    testWidgets('show value for longest digit', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('show value for longest digit')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test show value for longest digit', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '714411106011348790123654');
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('change bar color') as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('chnage background color', () {
    testWidgets('chnage background color', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('chnage background color')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test chnage background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('set text spacing with show value')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('text align as start with showValue', () {
    testWidgets('text align as start with showValue',
        (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('text align as start with showValue')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('to test text align as start with showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.showValue, true);
      expect(barcode?.textAlign, TextAlign.start);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('set text style with all the properties')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.backgroundColor, Colors.yellow);
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.textAlign, TextAlign.right);
      expect(barcode?.showValue, true);
      expect(
          barcode?.textStyle,
          const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold));
    });
  });

  group('set module with all properties', () {
    testWidgets('set module with all properties', (WidgetTester tester) async {
      final _CodabarTestCasesExamples container =
          _codabarTestCases('set module with all properties')
              as _CodabarTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Codabar;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.module, 2);
      expect(barcode?.showValue, true);
      expect(barcode?.textSpacing, 10);
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.value, '7144111060113487');
    });
  });
}

StatelessWidget _codabarTestCases(String sampleName) {
  return _CodabarTestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _CodabarTestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CodabarTestCasesExamples(String sampleName) {
    _barcode = getCodabarGenerator(sampleName);
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
