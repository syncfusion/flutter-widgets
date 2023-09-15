import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code128C generator
SfBarcodeGenerator getCode128CGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          symbology: Code128C(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '6738989812',
          symbology: Code128C(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '12345645',
          showValue: true,
          symbology: Code128C(),
        );
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060119045',
          showValue: true,
          symbology: Code128C(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          barColor: Colors.green,
          symbology: Code128C(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          backgroundColor: Colors.yellow,
          symbology: Code128C(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          textSpacing: 10,
          showValue: true,
          symbology: Code128C(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: Code128C(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: Code128C(),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code128C(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
