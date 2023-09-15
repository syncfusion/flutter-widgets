import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'upce_samples.dart';

///Unit test scripts of UPCE
void upceSamples() {
  SfBarcodeGenerator? barcode;
  late UPCE symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('with-value') as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '714411');
    });
  });

  group('enable-showValue', () {
    testWidgets('enable-showValue', (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('enable-showValue') as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test enable-showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('change bar color') as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('change background color') as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('set text spacing with show value')
              as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('text align as start with showValue', () {
    testWidgets('text align as start with showValue',
        (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('text align as start with showValue')
              as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test text align as start with showValue', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
      expect(barcode?.textAlign, TextAlign.start);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _UPCETestCasesExamples container =
          _upceTestCases('set text style with all the properties')
              as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
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
      final _UPCETestCasesExamples container =
          _upceTestCases('set module with all properties')
              as _UPCETestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as UPCE;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, '123456');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _upceTestCases(String sampleName) {
  return _UPCETestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _UPCETestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _UPCETestCasesExamples(String sampleName) {
    _barcode = getUPCEGenerator(sampleName);
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
