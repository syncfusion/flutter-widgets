import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the ean8 generator
SfBarcodeGenerator getEAN8Generator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '1234567',
          symbology: EAN8(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          showValue: true,
          symbology: EAN8(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          barColor: Colors.green,
          symbology: EAN8(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          backgroundColor: Colors.yellow,
          symbology: EAN8(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          textSpacing: 10,
          showValue: true,
          symbology: EAN8(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: EAN8(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: EAN8(),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '11223344',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: EAN8(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
