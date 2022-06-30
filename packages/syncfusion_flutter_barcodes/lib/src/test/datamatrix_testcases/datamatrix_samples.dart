import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the datamatrix generator
SfBarcodeGenerator getDataMatrixGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          symbology: DataMatrix(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator =
            SfBarcodeGenerator(value: 'SYNCFUSION', symbology: DataMatrix());
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            barColor: Colors.green,
            symbology: DataMatrix());
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            backgroundColor: Colors.yellow,
            symbology: DataMatrix());
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            textSpacing: 10,
            showValue: true,
            symbology: DataMatrix());
      }
      break;

    case 'set text align as start':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            textAlign: TextAlign.start,
            symbology: DataMatrix());
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            textSpacing: 10,
            showValue: true,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.right,
            textStyle: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
            symbology: DataMatrix());
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(module: 2),
        );
      }
      break;

    case 'set encoding as ascii':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'https://syncfusion.com',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(module: 2, encoding: DataMatrixEncoding.ascii),
        );
      }
      break;

    case 'set encoding as asciiNumeric':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'https://syncfusion.com',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(
                module: 2, encoding: DataMatrixEncoding.asciiNumeric));
      }
      break;

    case 'set encoding as base256':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'https://syncfusion.com',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology:
                DataMatrix(module: 2, encoding: DataMatrixEncoding.base256));
      }
      break;

    case 'set size as 10x10':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syn',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size10x10),
        );
      }
      break;

    case 'set size as 12x12':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Sync',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size12x12));
      }
      break;

    case 'set size as 14x14':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Sync',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size14x14),
        );
      }
      break;

    case 'set size as 16x16':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size16x16),
        );
      }
      break;

    case 'set size as 18x18':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size18x18),
        );
      }
      break;

    case 'set size as 20x20':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size20x20));
      }
      break;

    case 'set size as 22x22':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size22x22));
      }
      break;

    case 'set size as 24x24':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size24x24));
      }
      break;

    case 'set size as 26x26':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size26x26));
      }
      break;

    case 'set size as 32x32':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size32x32),
        );
      }
      break;

    case 'set size as 36x36':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size36x36),
        );
      }
      break;

    case 'set size as 40x40':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size40x40),
        );
      }
      break;

    case 'set size as 44x44':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size44x44));
      }
      break;

    case 'set size as 48x48':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size48x48),
        );
      }
      break;

    case 'set size as 52x52':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size52x52),
        );
      }
      break;

    case 'set size as 64x64':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size64x64));
      }
      break;

    case 'set size as 72x72':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size72x72),
        );
      }
      break;

    case 'set size as 80x80':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size80x80),
        );
      }
      break;

    case 'set size as 88x88':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size88x88),
        );
      }
      break;

    case 'set size as 96x96':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size96x96),
        );
      }
      break;

    case 'set size as 104x104':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size104x104),
        );
      }
      break;

    case 'set size as 120x120':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size120x120));
      }
      break;

    case 'set size as 132x132':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'Syncfusion',
            showValue: true,
            textSpacing: 10,
            backgroundColor: Colors.yellow,
            barColor: Colors.green,
            textAlign: TextAlign.end,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size132x132));
      }
      break;

    case 'set size as 144x144':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size144x144),
        );
      }
      break;

    case 'set size as  8x18':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Sync',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size8x18),
        );
      }
      break;

    case 'set size as 8x32':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size8x32),
        );
      }
      break;

    case 'set size as 12x26':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size12x26),
        );
      }
      break;

    case 'set size as 12x36':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size12x36),
        );
      }
      break;

    case 'set size as 16x36':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size16x36),
        );
      }
      break;

    case 'set size as 16x48':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfusion',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: DataMatrix(dataMatrixSize: DataMatrixSize.size16x48),
        );
      }
      break;
  }

  return barcodeGenerator;
}
