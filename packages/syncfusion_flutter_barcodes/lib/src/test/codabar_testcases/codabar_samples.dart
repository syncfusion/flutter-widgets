import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the codabar generator
SfBarcodeGenerator getCodabarGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          symbology: Codabar(),
        );
      }
      break;

    case 'with-value1':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '714411106011348790',
          symbology: Codabar(),
        );
      }
      break;

    case 'with-specialcharcter':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '6738989812:/+',
          symbology: Codabar(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '123456',
          showValue: true,
          symbology: Codabar(),
        );
      }
      break;

    case 'show value for longest digit':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '714411106011348790123654',
          showValue: true,
          symbology: Codabar(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          barColor: Colors.green,
          symbology: Codabar(),
        );
      }
      break;

    case 'chnage background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          backgroundColor: Colors.yellow,
          symbology: Codabar(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          textSpacing: 10,
          showValue: true,
          symbology: Codabar(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '7144111060113487',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: Codabar(),
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
          symbology: Codabar(),
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
          symbology: Codabar(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
