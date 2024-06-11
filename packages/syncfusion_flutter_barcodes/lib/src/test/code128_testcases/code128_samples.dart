import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code128 generator
SfBarcodeGenerator getCode128Generator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          symbology: Code128(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'SYNCFUSION:/+=',
          symbology: Code128(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          showValue: true,
          symbology: Code128(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          barColor: Colors.green,
          symbology: Code128(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          backgroundColor: Colors.yellow,
          symbology: Code128(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          textSpacing: 10,
          showValue: true,
          symbology: Code128(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: Code128(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128(),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Code128',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code128(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
