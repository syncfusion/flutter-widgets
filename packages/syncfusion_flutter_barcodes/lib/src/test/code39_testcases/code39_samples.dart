import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code39 generator
SfBarcodeGenerator getCode39Generator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          symbology: Code39(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator =
            SfBarcodeGenerator(value: 'SYNCFUSION', symbology: Code39());
      }
      break;

    case 'with-specialcharcter':
      {
        barcodeGenerator =
            SfBarcodeGenerator(value: 'SYNCFUSION:/+', symbology: Code39());
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '714411106011348790123654',
            showValue: true,
            symbology: Code39());
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            barColor: Colors.green,
            symbology: Code39());
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            backgroundColor: Colors.yellow,
            symbology: Code39());
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textSpacing: 10,
            showValue: true,
            symbology: Code39());
      }
      break;

    case 'set text align as start':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textAlign: TextAlign.start,
            symbology: Code39());
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
            symbology: Code39());
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
          symbology: Code39(module: 2),
        );
      }
      break;

    case 'set module, checkSum with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code39(module: 2),
        );
      }
      break;

    case 'set checkSum with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: Code39(),
        );
      }
      break;
  }

  return barcodeGenerator;
}
