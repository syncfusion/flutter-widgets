import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'code128a_samples.dart';

/// Unit teet scripts of Code128A
void code128ASamples() {
  SfBarcodeGenerator? barcode;
  late Code128A symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('with-value') as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
    });
  });

  group('with-value1', () {
    testWidgets('with-value1', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('with-value1') as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test with-value1', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A:/+');
    });
  });

  group('enable-showValue', () {
    testWidgets('enable-showValue', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('enable-showValue') as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test enable-showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.showValue, true);
    });
  });

  group('show value for longest digit', () {
    testWidgets('show value for longest digit', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('show value for longest digit')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test show value for longest digit', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A90123654');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('change bar color') as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('change background color')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('set text spacing with show value')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('text align as start with showValue', () {
    testWidgets('text align as start with showValue',
        (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('text align as start with showValue')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test text align as start with showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.textAlign, TextAlign.start);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _Code128ATestCasesExamples container =
          _code128ATestCases('set text style with all the properties')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'CODE128A');
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
      final _Code128ATestCasesExamples container =
          _code128ATestCases('set module with all properties')
              as _Code128ATestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code128A;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, 'CODE128A');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _code128ATestCases(String sampleName) {
  return _Code128ATestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _Code128ATestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Code128ATestCasesExamples(String sampleName) {
    _barcode = getCode128AGenerator(sampleName);
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
