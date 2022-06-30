import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the code39Extended generator
SfBarcodeGenerator getCode39ExtendedGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: 'Syncfuion',
          symbology: Code39Extended(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '714411106011348790', symbology: Code39Extended());
      }
      break;

    case 'with-specialcharcter':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: 'SYNCFUSION:/+', symbology: Code39Extended());
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '123456', showValue: true, symbology: Code39Extended());
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '714411106011348790123654',
            showValue: true,
            symbology: Code39Extended());
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            barColor: Colors.green,
            symbology: Code39Extended());
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            backgroundColor: Colors.yellow,
            symbology: Code39Extended());
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textSpacing: 10,
            showValue: true,
            symbology: Code39Extended());
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
            value: '7144111060113487',
            textAlign: TextAlign.start,
            showValue: true,
            symbology: Code39Extended());
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
            symbology: Code39Extended());
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
          symbology: Code39Extended(module: 2),
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
          symbology: Code39Extended(module: 2, enableCheckSum: true),
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
          symbology: Code39Extended(enableCheckSum: true),
        );
      }
      break;
  }

  return barcodeGenerator;
}
