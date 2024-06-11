import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'qr_code_samples.dart';

/// Unit test scripts for QR Code
void qrCodeSamples() {
  SfBarcodeGenerator? barcode;
  late QRCode symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('with-value') as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '123456');
    });
  });

  group('with-value1', () {
    testWidgets('with-value1', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('with-value1') as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'SYNCFUSION');
    });
  });

  group('show value for longest digit', () {
    testWidgets('show value for longest digit', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('show value for longest digit')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('to test show value for longest digit', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '714411106011348790123654');
      expect(barcode?.showValue, true);
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('change bar color') as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('change background color')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
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
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set text spacing with show value')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
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
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set text style with all the properties')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
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
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set module with all properties')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
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

  group('set input mode as numeric', () {
    testWidgets('set input mode as numeric', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set input mode as numeric')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set input mode as numeric', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.inputMode, QRInputMode.numeric);
      expect(barcode?.value, '7144111060113487');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set input mode as alphanumeric', () {
    testWidgets('set input mode as alphanumeric', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set input mode as alphanumeric')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set input mode as alphanumeric', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.inputMode, QRInputMode.alphaNumeric);
      expect(barcode?.value, 'Syncfusion1234');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set input mode as binary', () {
    testWidgets('set input mode as binary', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set input mode as binary')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set input mode as binary', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.inputMode, QRInputMode.binary);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set correction level as low', () {
    testWidgets('set correction level as low', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set correction level as low')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set correction level as low', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.errorCorrectionLevel, ErrorCorrectionLevel.low);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set correction level as medium', () {
    testWidgets('set correction level as medium', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set correction level as medium')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set correction level as medium', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.errorCorrectionLevel, ErrorCorrectionLevel.medium);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set correction level as quartile', () {
    testWidgets('set correction level as quartile',
        (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set correction level as quartile')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set correction level as quartile', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.errorCorrectionLevel, ErrorCorrectionLevel.quartile);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version01', () {
    testWidgets('set version as version01', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version01')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version01', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version01);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, '12332');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version02', () {
    testWidgets('set version as version02', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version02')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version02', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version02);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version03', () {
    testWidgets('set version as version03', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version03')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version03', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version03);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version04', () {
    testWidgets('set version as version04', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version04')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version04', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version04);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version05', () {
    testWidgets('set version as version05', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version05')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version05', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version05);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version06', () {
    testWidgets('set version as version06', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version06')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version06', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version06);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version07', () {
    testWidgets('set version as version07', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version07')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version07', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version07);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version08', () {
    testWidgets('set version as version08', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version08')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version08', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version08);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version09', () {
    testWidgets('set version as version09', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version09')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version09', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version09);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version10', () {
    testWidgets('set version as version10', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version10')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version10', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version10);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version11', () {
    testWidgets('set version as version11', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version11')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version11', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version11);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version12', () {
    testWidgets('set version as version12', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version12')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version12', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version12);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version13', () {
    testWidgets('set version as version13', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version13')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version13', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version13);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version14', () {
    testWidgets('set version as version14', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version14')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version14', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version14);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version15', () {
    testWidgets('set version as version15', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version15')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version15', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version15);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version16', () {
    testWidgets('set version as version16', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version16')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version16', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version16);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version18', () {
    testWidgets('set version as version18', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version18')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version18', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version18);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version19', () {
    testWidgets('set version as version19', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version19')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version19', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version19);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version20', () {
    testWidgets('set version as version20', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version20')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version20', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version20);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version21', () {
    testWidgets('set version as version21', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version21')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version21', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version21);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version22', () {
    testWidgets('set version as version22', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version22')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version22', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version22);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version23', () {
    testWidgets('set version as version23', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version23')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version23', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version23);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version24', () {
    testWidgets('set version as version24', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version24')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version24', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version24);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version25', () {
    testWidgets('set version as version25', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version25')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version25', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version25);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version26', () {
    testWidgets('set version as version26', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version26')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version26', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version26);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version27', () {
    testWidgets('set version as version27', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version27')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version27', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version27);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version28', () {
    testWidgets('set version as version28', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version28')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version28', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version28);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version29', () {
    testWidgets('set version as version29', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version29')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version29', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version29);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version30', () {
    testWidgets('set version as version30', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version30')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version30', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version30);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version31', () {
    testWidgets('set version as version31', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version31')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version31', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version31);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version32', () {
    testWidgets('set version as version32', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version32')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version32', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version32);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version33', () {
    testWidgets('set version as version33', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version33')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version33', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version33);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version34', () {
    testWidgets('set version as version34', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version34')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version34', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version34);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version35', () {
    testWidgets('set version as version35', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version35')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version35', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version35);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version36', () {
    testWidgets('set version as version36', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version36')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version36', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version36);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version37', () {
    testWidgets('set version as version37', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version37')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version37', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version37);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version38', () {
    testWidgets('set version as version38', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version38')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version38', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version38);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version39', () {
    testWidgets('set version as version39', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version39')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version39', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version39);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set version as version40', () {
    testWidgets('set version as version40', (WidgetTester tester) async {
      final _QRCodeTestCasesExamples container =
          _qrCodeTestCases('set version as version40')
              as _QRCodeTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as QRCode;
    });

    test('set version as version40', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.codeVersion, QRCodeVersion.version40);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });
}

StatelessWidget _qrCodeTestCases(String sampleName) {
  return _QRCodeTestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _QRCodeTestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _QRCodeTestCasesExamples(String sampleName) {
    _barcode = getQRCodeGenerator(sampleName);
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
