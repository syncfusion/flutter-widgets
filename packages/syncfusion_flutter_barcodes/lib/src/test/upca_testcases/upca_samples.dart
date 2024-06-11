import 'package:flutter/material.dart';
import '../../../barcodes.dart';

/// Returns the upca generator
SfBarcodeGenerator getUPCAGenerator(String sample) {
  late SfBarcodeGenerator barcodeGenerator;
  switch (sample) {
    case 'with-value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '12345612345',
          symbology: UPCA(),
        );
      }
      break;

    case 'enable-showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          showValue: true,
          symbology: UPCA(),
        );
      }
      break;

    case 'change bar color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          barColor: Colors.green,
          symbology: UPCA(),
        );
      }
      break;

    case 'change background color':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          backgroundColor: Colors.yellow,
          symbology: UPCA(),
        );
      }
      break;

    case 'set text spacing with show value':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          textSpacing: 10,
          showValue: true,
          symbology: UPCA(),
        );
      }
      break;

    case 'text align as start with showValue':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          textAlign: TextAlign.start,
          showValue: true,
          symbology: UPCA(),
        );
      }
      break;

    case 'set text style with all the properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          textSpacing: 10,
          showValue: true,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.right,
          textStyle: const TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          symbology: UPCA(),
        );
      }
      break;

    case 'set module with all properties':
      {
        barcodeGenerator = SfBarcodeGenerator(
          value: '72527273070',
          showValue: true,
          textSpacing: 10,
          backgroundColor: Colors.yellow,
          barColor: Colors.green,
          textAlign: TextAlign.end,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          symbology: UPCA(module: 2),
        );
      }
      break;
  }

  return barcodeGenerator;
}
