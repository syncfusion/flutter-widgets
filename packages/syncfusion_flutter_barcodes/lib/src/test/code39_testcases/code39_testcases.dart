import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'code39_samples.dart';

/// Unit test scripts of Code39
void code39Samples() {
  SfBarcodeGenerator? barcode;
  late Code39 symbology;
  group('Default-rendering', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('with-value') as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
    });
  });

  group('with-value1', () {
    testWidgets('with-value1', (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('with-value1') as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'SYNCFUSION');
    });
  });

  group('show value for longest digit', () {
    testWidgets('show value for longest digit', (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('show value for longest digit')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test show value for longest digit', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '714411106011348790123654');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('change bar color') as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('change background color')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('set text spacing with show value')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('set text style with all the properties')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
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
      final _Code39TestCasesExamples container =
          _code39TestCases('set module with all properties')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set module, checkSum with all properties', () {
    testWidgets('set module, checkSum with all properties',
        (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('set module, checkSum with all properties')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('set module, checkSum with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.enableCheckSum, true);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set checkSum with all properties', () {
    testWidgets('set checkSum with all properties',
        (WidgetTester tester) async {
      final _Code39TestCasesExamples container =
          _code39TestCases('set checkSum with all properties')
              as _Code39TestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as Code39;
    });

    test('set checkSum with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.enableCheckSum, true);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _code39TestCases(String sampleName) {
  return _Code39TestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _Code39TestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _Code39TestCasesExamples(String sampleName) {
    _barcode = getCode39Generator(sampleName);
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
