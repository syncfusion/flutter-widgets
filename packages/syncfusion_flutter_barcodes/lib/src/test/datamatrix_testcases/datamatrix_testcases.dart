import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import '../../../barcodes.dart';
import 'datamatrix_samples.dart';

/// Unit test scripts for data matrix samples
void dataMatrixSamples() {
  SfBarcodeGenerator? barcode;
  late DataMatrix symbology;
  group('with-value', () {
    testWidgets('with-value', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('with-value') as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'https://syncfusion.com');
    });
  });

  group('with-value1', () {
    testWidgets('with-value1', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('with-value1') as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test with-value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'SYNCFUSION');
    });
  });

  group('change bar color', () {
    testWidgets('change bar color', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('change bar color')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test change bar color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.barColor, Colors.green);
    });
  });

  group('change background color', () {
    testWidgets('change background color', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('change background color')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test change background color', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set text spacing with show value', () {
    testWidgets('set text spacing with show value',
        (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set text spacing with show value')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test set text spacing with show value', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textSpacing, 10);
      expect(barcode?.showValue, true);
    });
  });

  group('set text style with all the properties', () {
    testWidgets('set text style with all the properties',
        (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set text style with all the properties')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('to test set text style with all the properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode?.value, 'Syncfusion');
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
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set module with all properties')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set module with all properties', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set encoding as ascii', () {
    testWidgets('set encoding as ascii', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set encoding as ascii')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set encoding as ascii', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.encoding, DataMatrixEncoding.ascii);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set encoding as asciiNumeric', () {
    testWidgets('set encoding as asciiNumeric', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set encoding as asciiNumeric')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set encoding as asciiNumeric', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.encoding, DataMatrixEncoding.asciiNumeric);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set encoding as base256', () {
    testWidgets('set encoding as base256', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set encoding as base256')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set encoding as base256', () {
      expect(barcode!.symbology, symbology);
      expect(barcode!.symbology.module, 2);
      expect(symbology.encoding, DataMatrixEncoding.base256);
      expect(barcode?.value, 'https://syncfusion.com');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 10x10', () {
    testWidgets('set size as 10x10', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 10x10')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 10x10', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size10x10);
      expect(barcode?.value, 'Syn');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 12x12', () {
    testWidgets('set size as 12x12', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 12x12')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 12x12', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size12x12);
      expect(barcode?.value, 'Sync');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 14x14', () {
    testWidgets('set size as 14x14', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 14x14')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 14x14', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size14x14);
      expect(barcode?.value, 'Sync');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 16x16', () {
    testWidgets('set size as 16x16', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 16x16')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 16x16', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size16x16);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 18x18', () {
    testWidgets('set size as 18x18', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 18x18')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 18x18', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size18x18);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 20x20', () {
    testWidgets('set size as 20x20', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 20x20')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 20x20', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size20x20);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 22x22', () {
    testWidgets('set size as 22x22', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 22x22')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 22x22', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size22x22);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 24x24', () {
    testWidgets('set size as 24x24', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 24x24')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 24x24', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size24x24);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 26x26', () {
    testWidgets('set size as 26x26', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 26x26')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 26x26', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size26x26);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 32x32', () {
    testWidgets('set size as 32x32', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 32x32')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 32x32', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size32x32);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 36x36', () {
    testWidgets('set size as 36x36', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 36x36')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 36x36', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size36x36);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 40x40', () {
    testWidgets('set size as 40x40', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 40x40')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 40x40', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size40x40);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 44x44', () {
    testWidgets('set size as 44x44', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 44x44')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 44x44', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size44x44);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 48x48', () {
    testWidgets('set size as 48x48', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 48x48')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 48x48', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size48x48);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 52x52', () {
    testWidgets('set size as 52x52', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 52x52')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 52x52', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size52x52);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 64x64', () {
    testWidgets('set size as 64x64', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 64x64')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 64x64', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size64x64);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 72x72', () {
    testWidgets('set size as 72x72', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 72x72')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 72x72', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size72x72);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 80x80', () {
    testWidgets('set size as 80x80', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 80x80')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 80x80', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size80x80);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 88x88', () {
    testWidgets('set size as 88x88', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 88x88')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 88x88', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size88x88);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 96x96', () {
    testWidgets('set size as 96x96', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 96x96')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 96x96', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size96x96);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 104x104', () {
    testWidgets('set size as 104x104', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 104x104')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 104x104', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size104x104);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 120x120', () {
    testWidgets('set size as 120x120', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 120x120')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 120x120', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size120x120);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 132x132', () {
    testWidgets('set size as 132x132', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 132x132')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 132x132', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size132x132);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 144x144', () {
    testWidgets('set size as 144x144', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 144x144')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 144x144', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size144x144);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as  8x18', () {
    testWidgets('set size as  8x18', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as  8x18')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as  8x18', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size8x18);
      expect(barcode?.value, 'Sync');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 8x32', () {
    testWidgets('set size as 8x32', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 8x32')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 8x32', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size8x32);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 12x26', () {
    testWidgets('set size as 12x26', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 12x26')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 12x26', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size12x26);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 12x36', () {
    testWidgets('set size as 12x36', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 12x36')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 12x36', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size12x36);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 16x36', () {
    testWidgets('set size as 16x36', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 16x36')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 16x36', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size16x36);
      expect(barcode?.value, 'Syncfusion');
      expect(barcode?.textAlign, TextAlign.end);
      expect(barcode?.showValue, true);
      expect(barcode?.textStyle,
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
      expect(barcode?.barColor, Colors.green);
      expect(barcode?.backgroundColor, Colors.yellow);
    });
  });

  group('set size as 16x48', () {
    testWidgets('set size as 16x48', (WidgetTester tester) async {
      final _DataMatrixTestCasesExamples container =
          _dataMatrixTestCases('set size as 16x48')
              as _DataMatrixTestCasesExamples;
      await tester.pumpWidget(container);
      barcode = container._barcode;
      symbology = barcode!.symbology as DataMatrix;
    });

    test('set size as 16x48', () {
      expect(barcode!.symbology, symbology);
      expect(symbology.dataMatrixSize, DataMatrixSize.size16x48);
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

StatelessWidget _dataMatrixTestCases(String sampleName) {
  return _DataMatrixTestCasesExamples(sampleName);
}

// ignore: must_be_immutable
class _DataMatrixTestCasesExamples extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DataMatrixTestCasesExamples(String sampleName) {
    _barcode = getDataMatrixGenerator(sampleName);
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
